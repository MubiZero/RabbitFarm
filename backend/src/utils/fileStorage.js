const { client, bucket } = require('../config/minio');
const logger = require('./logger');

// Расширение файла определяется сервером по типу содержимого: значение,
// присланное клиентом, доверия не заслуживает. Тот же список, что раньше
// жил в config/multer.js.
const EXTENSION_BY_MIME = {
  'image/jpeg': '.jpg',
  'image/jpg': '.jpg',
  'image/png': '.png',
  'image/webp': '.webp',
  'application/pdf': '.pdf'
};

/**
 * Ключ объекта в бакете. Тот же формат имени, что и раньше на диске
 * (`fieldname-timestamp-random.ext`), чтобы старые `photo_url` в БД и новые
 * оставались одной и той же формы: `/uploads/<folder>/<key>`.
 *
 * Префикс `farm-<farmId>/` добавлен, чтобы объекты фермы можно было найти
 * по префиксу — без него посчитать место, занятое фермой, или вычистить её
 * файлы при удалении (см. docs/plans/PLATFORM-ADMIN.md, 1.6/2.4) было бы
 * невозможно: ключ не хранил, чья это ферма. Старые ключи без префикса
 * продолжают работать — `deleteFile`/`serveFile` формато-агностичны.
 */
function buildObjectKey(farmId, folder, fieldname, mimetype) {
  const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
  const ext = Object.hasOwn(EXTENSION_BY_MIME, mimetype) ? EXTENSION_BY_MIME[mimetype] : '.bin';
  return `farm-${farmId}/${folder}/${fieldname}-${uniqueSuffix}${ext}`;
}

/**
 * Загрузить файл из multer memoryStorage (req.file: {buffer, mimetype,
 * fieldname, size}) в MinIO. Возвращает относительный URL в том же виде,
 * в котором он раньше указывал на локальный диск — так формат photo_url в
 * БД не меняется, и мобильному клиенту не нужно ничего знать про MinIO.
 */
async function uploadFile(farmId, folder, file) {
  const objectKey = buildObjectKey(farmId, folder, file.fieldname, file.mimetype);
  await client.putObject(bucket, objectKey, file.buffer, file.size, {
    'Content-Type': file.mimetype
  });
  return `/uploads/${objectKey}`;
}

/**
 * Удалить файл по тому же относительному URL, что хранится в БД.
 * Ошибка логируется, а не бросается — отсутствие файла не должно ронять
 * операцию над записью, к которой он был приложен.
 */
async function deleteFile(relativeUrl) {
  if (!relativeUrl) return;

  const objectKey = relativeUrl.replace(/^\/uploads\//, '');
  try {
    await client.removeObject(bucket, objectKey);
    logger.info('File deleted', { objectKey });
  } catch (error) {
    logger.error('Error deleting file', { error: error.message, url: relativeUrl });
  }
}

/**
 * Отдать файл в ответ на HTTP-запрос — замена express.static для
 * /uploads. Content-Type берём из метаданных объекта, а не угадываем по
 * расширению: он был записан при загрузке и всегда точен.
 */
async function serveFile(objectKey, res) {
  const stat = await client.statObject(bucket, objectKey);
  res.set('Content-Type', stat.metaData['content-type'] || 'application/octet-stream');
  // Имя объекта уникально на каждую загрузку (timestamp+random в ключе),
  // поэтому один и тот же URL всегда отдаёт одно и то же содержимое —
  // жёсткое кеширование безопасно.
  res.set('Cache-Control', 'public, max-age=31536000, immutable');

  const stream = await client.getObject(bucket, objectKey);
  stream.pipe(res);
}

module.exports = {
  EXTENSION_BY_MIME,
  buildObjectKey,
  uploadFile,
  deleteFile,
  serveFile
};
