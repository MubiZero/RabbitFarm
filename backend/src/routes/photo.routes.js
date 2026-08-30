const express = require('express');
const router = express.Router();
const rabbitController = require('../controllers/rabbitController');
const { listFarmPhotosQuerySchema } = require('../validators/photoValidator');
const { authenticate } = require('../middleware/auth');
const validate = require('../middleware/validation');

/**
 * @swagger
 * tags:
 *   name: Photos
 *   description: Лента фото по всей ферме — для Дневника
 *
 * /photos:
 *   get:
 *     summary: Фото по всей ферме, за любого кролика
 *     tags: [Photos]
 *     parameters:
 *       - in: query
 *         name: page
 *         schema: { type: integer, default: 1 }
 *     responses:
 *       200:
 *         description: Список фото с пагинацией
 */

router.use(authenticate);

router.get('/', validate(listFarmPhotosQuerySchema, 'query'), rabbitController.listFarmPhotos);

module.exports = router;
