const express = require('express');
const router = express.Router();
const transactionController = require('../controllers/transactionController');
const { createTransactionSchema, updateTransactionSchema } = require('../validators/transactionValidator');
const { authenticate } = require('../middleware/auth');
const validate = require('../middleware/validation');

/**
 * @swagger
 * tags:
 *   name: Transactions
 *   description: Финансовые операции
 *
 * /transactions:
 *   get:
 *     summary: Список транзакций
 *     tags: [Transactions]
 *     parameters:
 *       - in: query
 *         name: type
 *         schema: { type: string, enum: [income, expense] }
 *       - in: query
 *         name: page
 *         schema: { type: integer, default: 1 }
 *       - in: query
 *         name: limit
 *         schema: { type: integer, default: 20 }
 *     responses:
 *       200:
 *         description: Список транзакций с пагинацией
 *   post:
 *     summary: Создать транзакцию
 *     tags: [Transactions]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [type, amount, transaction_date]
 *             properties:
 *               type: { type: string, enum: [income, expense] }
 *               amount: { type: number }
 *               transaction_date: { type: string, format: date }
 *               description: { type: string }
 *               category: { type: string }
 *     responses:
 *       201:
 *         description: Транзакция создана
 *
 * /transactions/{id}:
 *   get:
 *     summary: Получить транзакцию по ID
 *     tags: [Transactions]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Данные транзакции
 *       404:
 *         description: Транзакция не найдена
 *   put:
 *     summary: Обновить транзакцию
 *     tags: [Transactions]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Транзакция обновлена
 *   delete:
 *     summary: Удалить транзакцию
 *     tags: [Transactions]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Транзакция удалена
 *
 * /transactions/statistics:
 *   get:
 *     summary: Финансовая статистика
 *     tags: [Transactions]
 *     responses:
 *       200:
 *         description: Сводная финансовая статистика
 *
 * /transactions/monthly-report:
 *   get:
 *     summary: Ежемесячный финансовый отчёт
 *     tags: [Transactions]
 *     responses:
 *       200:
 *         description: Отчёт по месяцам
 */

// Apply authentication to all routes
router.use(authenticate);

// Statistics and special queries (before :id routes)
router.get('/statistics', transactionController.getStatistics);
router.get('/monthly-report', transactionController.getMonthlyReport);

// CRUD routes
router.post('/', validate(createTransactionSchema), transactionController.create);
router.get('/', transactionController.list);
router.get('/:id', transactionController.getById);
router.put('/:id', validate(updateTransactionSchema), transactionController.update);
router.delete('/:id', transactionController.delete);

module.exports = router;
