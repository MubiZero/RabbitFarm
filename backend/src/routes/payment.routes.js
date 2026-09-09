const express = require('express');
const router = express.Router();
const paymentController = require('../controllers/paymentController');
const { authenticate, authorize } = require('../middleware/auth');

/**
 * @route   POST /api/v1/payments
 * @desc    Создать заказ на оплату продления тарифа. Тело пустое: сумму
 *          считает сервер по тарифу фермы (см. docs/plans/PLATFORM-ADMIN.md,
 *          4.1) — раньше клиент присылал произвольную сумму сам.
 * @access  Private (Owner only) — оплата фермы, не рабочий процесс
 */
router.post(
  '/',
  authenticate,
  authorize(['owner']),
  paymentController.create
);

/**
 * @route   GET /api/v1/payments/:invoiceId
 * @desc    Ручной опрос статуса своего платежа — без ожидания вебхука
 * @access  Private (Owner only)
 */
router.get('/:invoiceId', authenticate, authorize(['owner']), paymentController.status);

/**
 * @route   POST /api/v1/payments/webhook
 * @desc    Вебхук Эсхата Мерчант о завершении заказа
 * @access  Public — банк не несёт наш JWT; тело не подписано, поэтому
 *          контроллер не доверяет ему напрямую и всегда перепроверяет
 *          статус подписанным запросом (см. paymentService.reconcile)
 */
router.post('/webhook', paymentController.webhook);

module.exports = router;
