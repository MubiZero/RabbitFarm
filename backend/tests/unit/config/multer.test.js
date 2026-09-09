const express = require('express');
const request = require('supertest');
const upload = require('../../../src/config/multer');
const { errorHandler } = require('../../../src/middleware/errorHandler');
const {
  PNG_1PX,
  JPEG_1PX,
  WEBP_1PX,
  PDF_MINIMAL,
  WINDOWS_EXECUTABLE,
  SVG_WITH_SCRIPT
} = require('../../helpers/fileFixtures');

// Приёмник загрузки без БД и MinIO: проверяем ровно цепочку multer →
// проверка содержимого → обработчик ошибок, как она собрана в маршрутах.
function buildApp() {
  const app = express();
  app.post('/upload', upload.single('photo'), (req, res) => {
    res.status(201).json({ mimetype: req.file ? req.file.mimetype : null });
  });
  app.use(errorHandler);
  return app;
}

const app = buildApp();
const originalAllowed = process.env.ALLOWED_FILE_TYPES;

afterEach(() => {
  if (originalAllowed === undefined) {
    delete process.env.ALLOWED_FILE_TYPES;
  } else {
    process.env.ALLOWED_FILE_TYPES = originalAllowed;
  }
});

describe('Загрузка файлов: проверка типа', () => {
  it('загрузка идёт вместе с проверкой содержимого — обойти её маршрут не может', () => {
    expect(upload.single('photo')).toHaveLength(2);
    expect(upload.array('photos', 3)).toHaveLength(2);
    expect(upload.fields([{ name: 'photo' }])).toHaveLength(2);
  });

  it('настоящий PNG проходит', async () => {
    const res = await request(app)
      .post('/upload')
      .attach('photo', PNG_1PX, { filename: 'rabbit.png', contentType: 'image/png' });

    expect(res.status).toBe(201);
    expect(res.body.mimetype).toBe('image/png');
  });

  it('исполняемый файл под видом image/png отклоняется', async () => {
    const res = await request(app)
      .post('/upload')
      .attach('photo', WINDOWS_EXECUTABLE, { filename: 'rabbit.png', contentType: 'image/png' });

    expect(res.status).toBe(400);
    expect(res.body.error.message).toMatch(/не похоже ни на один разрешённый формат/);
  });

  it('PDF под видом image/png отклоняется, когда PDF не разрешён', async () => {
    process.env.ALLOWED_FILE_TYPES = 'image/jpeg,image/png';

    const res = await request(app)
      .post('/upload')
      .attach('photo', PDF_MINIMAL, { filename: 'rabbit.png', contentType: 'image/png' });

    expect(res.status).toBe(400);
    expect(res.body.error.message).toMatch(/на самом деле имеет тип application\/pdf/);
  });

  it('JPEG под видом image/png отклоняется, хотя оба типа разрешены', async () => {
    const res = await request(app)
      .post('/upload')
      .attach('photo', JPEG_1PX, { filename: 'rabbit.png', contentType: 'image/png' });

    expect(res.status).toBe(400);
    expect(res.body.error.message).toMatch(/заявлен image\/png, фактически image\/jpeg/);
  });

  it('image/jpg считается тем же, что image/jpeg, и наружу уходит нормализованным', async () => {
    process.env.ALLOWED_FILE_TYPES = 'image/jpg,image/png';

    const res = await request(app)
      .post('/upload')
      .attach('photo', JPEG_1PX, { filename: 'rabbit.jpg', contentType: 'image/jpg' });

    expect(res.status).toBe(201);
    expect(res.body.mimetype).toBe('image/jpeg');
  });

  it('application/octet-stream отклоняется до чтения файла', async () => {
    const res = await request(app)
      .post('/upload')
      .attach('photo', PNG_1PX, { filename: 'rabbit.bin', contentType: 'application/octet-stream' });

    expect(res.status).toBe(400);
    expect(res.body.error.message).toMatch(/Недопустимый тип файла/);
  });

  it('запрос без файла проходит дальше', async () => {
    const res = await request(app).post('/upload').field('caption', 'без фото');

    expect(res.status).toBe(201);
    expect(res.body.mimetype).toBeNull();
  });

  describe('SVG', () => {
    it('запрещён, даже если он прописан в ALLOWED_FILE_TYPES', async () => {
      process.env.ALLOWED_FILE_TYPES = 'image/jpeg,image/png,image/svg+xml';

      const res = await request(app)
        .post('/upload')
        .attach('photo', SVG_WITH_SCRIPT, { filename: 'rabbit.svg', contentType: 'image/svg+xml' });

      expect(res.status).toBe(400);
      expect(res.body.error.message).toMatch(/Недопустимый тип файла/);
      expect(res.body.error.message).not.toMatch(/svg/);
    });

    it('не проходит и под видом image/png', async () => {
      const res = await request(app)
        .post('/upload')
        .attach('photo', SVG_WITH_SCRIPT, { filename: 'rabbit.png', contentType: 'image/png' });

      expect(res.status).toBe(400);
    });

    it('из списка разрешённых типов вычищается', () => {
      process.env.ALLOWED_FILE_TYPES = 'image/png,image/svg+xml';
      expect(upload.allowedMimeTypes()).toEqual(['image/png']);
    });
  });

  describe('WebP', () => {
    it('проходит, когда разрешён', async () => {
      process.env.ALLOWED_FILE_TYPES = 'image/jpeg,image/png,image/webp';

      const res = await request(app)
        .post('/upload')
        .attach('photo', WEBP_1PX, { filename: 'rabbit.webp', contentType: 'image/webp' });

      expect(res.status).toBe(201);
      expect(res.body.mimetype).toBe('image/webp');
    });

    it('отклоняется, когда не разрешён', async () => {
      process.env.ALLOWED_FILE_TYPES = 'image/jpeg,image/png';

      const res = await request(app)
        .post('/upload')
        .attach('photo', WEBP_1PX, { filename: 'rabbit.webp', contentType: 'image/webp' });

      expect(res.status).toBe(400);
    });
  });

  describe('allowedMimeTypes', () => {
    it('по умолчанию — jpeg, png, jpg', () => {
      delete process.env.ALLOWED_FILE_TYPES;
      expect(upload.allowedMimeTypes()).toEqual(['image/jpeg', 'image/png', 'image/jpg']);
    });

    it('игнорирует пробелы и типы, для которых сервер не знает расширения', () => {
      process.env.ALLOWED_FILE_TYPES = ' image/png , application/zip ,, image/webp ';
      expect(upload.allowedMimeTypes()).toEqual(['image/png', 'image/webp']);
    });
  });
});
