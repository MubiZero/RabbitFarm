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
router.get('/:folder/:filename', async (req, res) => {
  const { folder, filename } = req.params;

  if (!/^[a-zA-Z0-9_-]+$/.test(folder) || !/^[a-zA-Z0-9_.-]+$/.test(filename)) {
    return res.sendStatus(400);
  }

  try {
    await fileStorage.serveFile(`${folder}/${filename}`, res);
  } catch (error) {
    logger.error('Error serving file', { error: error.message, folder, filename });
    res.sendStatus(404);
  }
});

module.exports = router;
