const Minio = require('minio');

/**
 * Хранилище загруженных файлов — MinIO (S3-совместимое).
 *
 * В отличие от Firebase, это не опциональная интеграция: загрузка фото
 * всегда идёт сюда. Но значения по умолчанию не должны ронять конструктор
 * клиента там, где переменные ещё не заданы (юнит- и интеграционные тесты
 * держат его замоканным и никогда не обращаются к реальному MinIO, но
 * require() этого файла всё равно происходит при поднятии app.js).
 */
const client = new Minio.Client({
  endPoint: process.env.MINIO_ENDPOINT || 'localhost',
  port: parseInt(process.env.MINIO_PORT, 10) || 9000,
  useSSL: process.env.MINIO_USE_SSL === 'true',
  accessKey: process.env.MINIO_ACCESS_KEY || '',
  secretKey: process.env.MINIO_SECRET_KEY || ''
});

const bucket = process.env.MINIO_BUCKET || 'rabbitfarm-uploads';

/**
 * Завести бакет при старте, если его ещё нет. Вызывается один раз из
 * server.js — до первого запроса на загрузку файла.
 */
async function ensureBucket() {
  const exists = await client.bucketExists(bucket).catch(() => false);
  if (!exists) {
    await client.makeBucket(bucket);
  }
}

module.exports = { client, bucket, ensureBucket };
