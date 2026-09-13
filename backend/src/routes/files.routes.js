const express = require('express');
const router = express.Router();
const fileStorage = require('../utils/fileStorage');
const logger = require('../utils/logger');

// Замена express.static('/uploads', ...): раньше файлы отдавались прямо с
// локального диска контейнера, теперь — из MinIO. Само отсутствие
// авторизации на этом маршруте не меняется этим переносом: URL остаются
// теми же непредсказуемыми (timestamp+random в имени), что и раньше.
//
// Папка и имя проверяются по формату, который сам же генерирует
// buildObjectKey — не потому что MinIO уязвим к обходу пути (это не
// файловая система), а чтобы через этот маршрут нельзя было прочитать
// произвольный объект бакета, если он там когда-нибудь появится.
// Префикс `farm-<id>/` необязателен: новые ключи его несут, ключи, залитые
// до появления префикса, лежат в бакете без него и должны продолжать
// открываться. Маршрут с двумя сегментами пути ловил только вторые, и любое
// фото, загруженное после появления префикса, отдавалось как 404.
const OBJECT_KEY = /^(?:farm-\d+\/)?[a-zA-Z0-9_-]+\/[a-zA-Z0-9_.-]+$/;

router.get('/*', async (req, res) => {
  const objectKey = req.params[0];

  if (!OBJECT_KEY.test(objectKey)) {
    return res.sendStatus(400);
  }

  try {
    await fileStorage.serveFile(objectKey, res);
  } catch (error) {
    logger.error('Error serving file', { error: error.message, objectKey });
    res.sendStatus(404);
  }
});

module.exports = router;
