/**
 * Разовый бэкфилл размера файла для фото, загруженных до появления
 * `photos.size_bytes` / `rabbits.photo_size_bytes` (см.
 * docs/plans/PLATFORM-ADMIN.md, 1.6).
 *
 * Ключ объекта в БД не содержит размер, поэтому единственный источник
 * правды — сам MinIO (`statObject`). Скрипт идёт по записям с NULL в
 * соответствующем поле и молча пропускает те, чей объект в MinIO не
 * нашёлся (файл мог быть удалён руками) — одна пропавшая фотография не
 * должна ронять весь прогон.
 *
 * Безопасно перезапускать: уже заполненные записи (size_bytes IS NOT NULL)
 * не трогает, поэтому повторный запуск просто доберёт то, что не успело
 * обработаться в прошлый раз.
 *
 *   node scripts/backfillPhotoSizes.js
 */
require('dotenv').config();

const { Op } = require('sequelize');
const { Photo, Rabbit, sequelize } = require('../src/models');
const { client, bucket } = require('../src/config/minio');

function objectKeyFromUrl(url) {
  return url.replace(/^\/uploads\//, '');
}

/**
 * @param {Array} records - записи с полем url/photo_url
 * @param {String} urlField - имя поля с относительным URL
 * @param {String} sizeField - имя поля, куда писать размер
 * @returns {{updated: Number, missing: Number}}
 */
async function backfill(records, urlField, sizeField) {
  let updated = 0;
  let missing = 0;

  for (const record of records) {
    const objectKey = objectKeyFromUrl(record[urlField]);
    try {
      const stat = await client.statObject(bucket, objectKey);
      await record.update({ [sizeField]: stat.size });
      updated += 1;
    } catch (error) {
      missing += 1;
      console.warn(`[backfill] объект не найден в MinIO, пропускаю: ${objectKey} (${error.message})`);
    }
  }

  return { updated, missing };
}

async function run() {
  const photos = await Photo.findAll({ where: { size_bytes: null } });
  console.log(`[backfill] photos без size_bytes: ${photos.length}`);
  const photoResult = await backfill(photos, 'url', 'size_bytes');
  console.log(`[backfill] photos: обновлено ${photoResult.updated}, пропущено ${photoResult.missing}`);

  const rabbits = await Rabbit.findAll({
    where: { photo_url: { [Op.ne]: null }, photo_size_bytes: null }
  });
  console.log(`[backfill] rabbits с photo_url без photo_size_bytes: ${rabbits.length}`);
  const rabbitResult = await backfill(rabbits, 'photo_url', 'photo_size_bytes');
  console.log(`[backfill] rabbits: обновлено ${rabbitResult.updated}, пропущено ${rabbitResult.missing}`);

  await sequelize.close();
}

// Автозапуск только когда файл вызван как скрипт (`node scripts/...`), а не
// require()-нут — так модуль можно юнит-тестировать, не трогая реальную БД.
if (require.main === module) {
  run()
    .then(() => {
      console.log('[backfill] готово');
      process.exit(0);
    })
    .catch((error) => {
      console.error('[backfill] упал с ошибкой', error);
      process.exit(1);
    });
}

module.exports = { run, backfill, objectKeyFromUrl };
