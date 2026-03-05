const express = require('express');
const router = express.Router();
const feedController = require('../controllers/feedController');
const { createFeedSchema, updateFeedSchema, adjustStockSchema } = require('../validators/feedValidator');
const { authenticate } = require('../middleware/auth');
const validate = require('../middleware/validation');

/**
 * @swagger
 * tags:
 *   name: Feeds
 *   description: Управление кормами
 *
 * /feeds:
 *   get:
 *     summary: Список кормов
 *     tags: [Feeds]
 *     parameters:
 *       - in: query
 *         name: type
 *         schema: { type: string }
 *       - in: query
 *         name: page
 *         schema: { type: integer, default: 1 }
 *     responses:
 *       200:
 *         description: Список кормов с пагинацией
 *   post:
 *     summary: Добавить корм
 *     tags: [Feeds]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [name, type, unit]
 *             properties:
 *               name: { type: string }
 *               type: { type: string }
 *               unit: { type: string }
 *               current_stock: { type: number }
 *               min_stock: { type: number }
 *               price_per_unit: { type: number }
 *     responses:
 *       201:
 *         description: Корм добавлен
 *
 * /feeds/{id}:
 *   get:
 *     summary: Получить корм по ID
 *     tags: [Feeds]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Данные корма
 *       404:
 *         description: Корм не найден
 *   put:
 *     summary: Обновить корм
 *     tags: [Feeds]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Корм обновлён
 *   delete:
 *     summary: Удалить корм
 *     tags: [Feeds]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Корм удалён
 *
 * /feeds/{id}/adjust-stock:
 *   post:
 *     summary: Скорректировать запас корма
 *     tags: [Feeds]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [adjustment, reason]
 *             properties:
 *               adjustment: { type: number }
 *               reason: { type: string }
 *     responses:
 *       200:
 *         description: Запас скорректирован
 *
 * /feeds/statistics:
 *   get:
 *     summary: Статистика кормов
 *     tags: [Feeds]
 *     responses:
 *       200:
 *         description: Статистика по запасам кормов
 *
 * /feeds/low-stock:
 *   get:
 *     summary: Корма с низким запасом
 *     tags: [Feeds]
 *     responses:
 *       200:
 *         description: Список кормов с запасом ниже минимума
 */

// Apply authentication to all routes
router.use(authenticate);
const idempotency = require('../middleware/idempotency');
router.use(idempotency);

// Statistics and special queries (before :id routes)
router.get('/statistics', feedController.getStatistics);
router.get('/low-stock', feedController.getLowStock);

// CRUD routes
router.post('/', validate(createFeedSchema), feedController.create);
router.get('/', feedController.list);
router.get('/:id', feedController.getById);
router.put('/:id', validate(updateFeedSchema), feedController.update);
router.delete('/:id', feedController.delete);

// Stock adjustment
router.post('/:id/adjust-stock', validate(adjustStockSchema), feedController.adjustStock);

module.exports = router;
