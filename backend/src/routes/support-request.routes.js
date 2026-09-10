const express = require('express');
const router = express.Router();
const supportRequestController = require('../controllers/supportRequestController');
const { createSupportRequestSchema } = require('../validators/supportRequestValidator');
const { authenticateEvenIfFarmBlocked } = require('../middleware/auth');
const validate = require('../middleware/validation');

/**
 * @swagger
 * tags:
 *   name: SupportRequests
 *   description: Обращения фермы в поддержку
 *
 * /support-requests:
 *   post:
 *     summary: Написать в поддержку
 *     description: >
 *       Доступно любой роли фермы. Единственный маршрут, который работает и
 *       при закрытом доступе хозяйства (`suspended`, `read_only`, помечено на
 *       удаление) — иначе совет «обратитесь в поддержку» упирался бы сам в
 *       себя.
 *     tags: [SupportRequests]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [text]
 *             properties:
 *               text: { type: string, minLength: 10, maxLength: 2000 }
 *     responses:
 *       201:
 *         description: Обращение отправлено
 */

// Ролью не ограничено сознательно: в поддержку пишет тот, у кого что-то не
// работает, а не тот, у кого есть право это чинить.
router.post(
  '/',
  authenticateEvenIfFarmBlocked,
  validate(createSupportRequestSchema),
  supportRequestController.create
);

/**
 * @swagger
 * /support-requests/contact:
 *   get:
 *     summary: Официальный email/телефон поддержки, если заданы платформенным админом
 *     tags: [SupportRequests]
 */
router.get('/contact', authenticateEvenIfFarmBlocked, supportRequestController.getContact);

module.exports = router;
