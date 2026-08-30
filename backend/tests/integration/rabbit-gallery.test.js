const request = require('supertest');
const path = require('path');
const fs = require('fs');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');

// Крошечный валидный PNG (1x1), чтобы multer принял файл как настоящее
// изображение — content-type определяется supertest по расширению файла.
const PNG_1PX = Buffer.from(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
  'base64'
);

describe('Галерея фото кролика', () => {
  let ownerToken;
  let workerToken;
  let strangerToken;
  let rabbitId;
  let strangerRabbitId;

  beforeAll(async () => {
    await syncTestDb();

    const owner = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'gallery_owner@example.com', password: 'Password123!', full_name: 'Владелец' });
    ownerToken = owner.body.data.access_token;

    const breed = await request(app)
      .post('/api/v1/breeds')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ name: 'Порода для галереи' });

    const rabbit = await request(app)
      .post('/api/v1/rabbits')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ name: 'Буся', breed_id: breed.body.data.id, sex: 'female', birth_date: '2025-01-01' });
    rabbitId = rabbit.body.data.id;

    const { User } = require('../../src/models');
    await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'gallery_worker@example.com', password: 'Password123!', full_name: 'Работник' });
    await User.update(
      { farm_id: owner.body.data.user.farm_id, role: 'worker' },
      { where: { email: 'gallery_worker@example.com' } }
    );
    const workerLogin = await request(app)
      .post('/api/v1/auth/login')
      .send({ email: 'gallery_worker@example.com', password: 'Password123!' });
    workerToken = workerLogin.body.data.access_token;

    const stranger = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'gallery_stranger@example.com', password: 'Password123!', full_name: 'Сосед' });
    strangerToken = stranger.body.data.access_token;
    const strangerBreed = await request(app)
      .post('/api/v1/breeds')
      .set('Authorization', `Bearer ${strangerToken}`)
      .send({ name: 'Чужая порода' });
    const strangerRabbit = await request(app)
      .post('/api/v1/rabbits')
      .set('Authorization', `Bearer ${strangerToken}`)
      .send({ name: 'Чужой', breed_id: strangerBreed.body.data.id, sex: 'male', birth_date: '2025-01-01' });
    strangerRabbitId = strangerRabbit.body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('POST /api/v1/rabbits/:id/photos', () => {
    it('владелец добавляет фото в галерею', async () => {
      const res = await request(app)
        .post(`/api/v1/rabbits/${rabbitId}/photos`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .field('caption', 'На выставке')
        .attach('photo', PNG_1PX, 'rabbit.png');

      expect(res.status).toBe(201);
      expect(res.body.data.caption).toBe('На выставке');
      expect(res.body.data.url).toMatch(/^\/uploads\/rabbits\//);
      expect(res.body.data.author.full_name).toBe('Владелец');

      // Файл реально лежит на диске.
      const absolutePath = path.join(__dirname, '../../', res.body.data.url);
      expect(fs.existsSync(absolutePath)).toBe(true);
    });

    it('работнику нельзя добавлять фото', async () => {
      const res = await request(app)
        .post(`/api/v1/rabbits/${rabbitId}/photos`)
        .set('Authorization', `Bearer ${workerToken}`)
        .attach('photo', PNG_1PX, 'rabbit.png');

      expect(res.status).toBe(403);
    });

    it('без файла — 400', async () => {
      const res = await request(app)
        .post(`/api/v1/rabbits/${rabbitId}/photos`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send();

      expect(res.status).toBe(400);
    });

    it('нельзя добавить фото чужому кролику', async () => {
      const res = await request(app)
        .post(`/api/v1/rabbits/${strangerRabbitId}/photos`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .attach('photo', PNG_1PX, 'rabbit.png');

      expect(res.status).toBe(404);
    });
  });

  describe('GET /api/v1/rabbits/:id/photos', () => {
    it('владелец видит галерею', async () => {
      const res = await request(app)
        .get(`/api/v1/rabbits/${rabbitId}/photos`)
        .set('Authorization', `Bearer ${ownerToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.length).toBeGreaterThan(0);
    });

    it('работник тоже видит галерею', async () => {
      const res = await request(app)
        .get(`/api/v1/rabbits/${rabbitId}/photos`)
        .set('Authorization', `Bearer ${workerToken}`);

      expect(res.status).toBe(200);
    });

    it('чужая ферма галерею не видит', async () => {
      const res = await request(app)
        .get(`/api/v1/rabbits/${rabbitId}/photos`)
        .set('Authorization', `Bearer ${strangerToken}`);

      expect(res.status).toBe(404);
    });
  });

  describe('DELETE /api/v1/rabbits/:id/photos/:photoId', () => {
    let photoId;
    let photoUrl;

    beforeAll(async () => {
      const created = await request(app)
        .post(`/api/v1/rabbits/${rabbitId}/photos`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .attach('photo', PNG_1PX, 'to-delete.png');
      photoId = created.body.data.id;
      photoUrl = created.body.data.url;
    });

    it('работнику нельзя удалить фото', async () => {
      const res = await request(app)
        .delete(`/api/v1/rabbits/${rabbitId}/photos/${photoId}`)
        .set('Authorization', `Bearer ${workerToken}`);

      expect(res.status).toBe(403);
    });

    it('владелец удаляет фото — файл тоже исчезает', async () => {
      const absolutePath = path.join(__dirname, '../../', photoUrl);
      expect(fs.existsSync(absolutePath)).toBe(true);

      const res = await request(app)
        .delete(`/api/v1/rabbits/${rabbitId}/photos/${photoId}`)
        .set('Authorization', `Bearer ${ownerToken}`);

      expect(res.status).toBe(200);
      expect(fs.existsSync(absolutePath)).toBe(false);
    });

    it('повторное удаление — 404', async () => {
      const res = await request(app)
        .delete(`/api/v1/rabbits/${rabbitId}/photos/${photoId}`)
        .set('Authorization', `Bearer ${ownerToken}`);

      expect(res.status).toBe(404);
    });
  });
});
