const express = require('express');
const router = express.Router();
const feedingRecordController = require('../controllers/feedingRecordController');
const { createFeedingRecordSchema, updateFeedingRecordSchema } = require('../validators/feedingRecordValidator');
const { authenticate } = require('../middleware/auth');
const validate = require('../middleware/validation');

/**
 * @swagger
 * tags:
 *   name: FeedingRecords
 *   description: Записи кормления кроликов
 *
 * /feeding-records:
 *   get:
 *     summary: Список записей кормления
 *     tags: [FeedingRecords]
 *     parameters:
 *       - in: query
 *         name: rabbit_id
 *         schema: { type: integer }
 *       - in: query
 *         name: feed_id
 *         schema: { type: integer }
 *       - in: query
 *         name: page
 *         schema: { type: integer, default: 1 }
 *     responses:
 *       200:
 *         description: Список записей кормления с пагинацией
 *   post:
 *     summary: Создать запись кормления
 *     tags: [FeedingRecords]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [rabbit_id, feed_id, amount, fed_at]
 *             properties:
 *               rabbit_id: { type: integer }
 *               feed_id: { type: integer }
 *               amount: { type: number }
 *               fed_at: { type: string, format: date-time }
 *               notes: { type: string }
 *     responses:
 *       201:
 *         description: Запись кормления создана
 *
 * /feeding-records/{id}:
 *   get:
 *     summary: Получить запись кормления по ID
 *     tags: [FeedingRecords]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Данные записи кормления
 *       404:
 *         description: Запись не найдена
 *   put:
 *     summary: Обновить запись кормления
 *     tags: [FeedingRecords]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Запись кормления обновлена
 *   delete:
 *     summary: Удалить запись кормления
 *     tags: [FeedingRecords]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Запись кормления удалена
 *
 * /feeding-records/statistics:
 *   get:
 *     summary: Статистика кормления
 *     tags: [FeedingRecords]
 *     responses:
 *       200:
 *         description: Статистика расхода корма
 *
 * /feeding-records/recent:
 *   get:
 *     summary: Последние записи кормления
 *     tags: [FeedingRecords]
 *     responses:
 *       200:
 *         description: Последние записи кормления
 */

// Apply authentication to all routes
router.use(authenticate);
const idempotency = require('../middleware/idempotency');
router.use(idempotency);

// Statistics and special queries (before :id routes)
router.get('/statistics', feedingRecordController.getStatistics);
router.get('/recent', feedingRecordController.getRecent);

// CRUD routes
router.post('/', validate(createFeedingRecordSchema), feedingRecordController.create);
router.get('/', feedingRecordController.list);
router.get('/:id', feedingRecordController.getById);
router.put('/:id', validate(updateFeedingRecordSchema), feedingRecordController.update);
router.delete('/:id', feedingRecordController.delete);

module.exports = router;
