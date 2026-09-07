const express = require('express');
const router = express.Router();
const paymentController = require('../controllers/paymentController');
const { authenticate, authorize } = require('../middleware/auth');
const validate = require('../middleware/validation');
const { createPaymentSchema } = require('../validators/paymentValidator');

/**
 * @route   POST /api/v1/payments
 * @desc    Создать заказ на оплату подписки
 * @access  Private (Owner only) — оплата фермы, не рабочий процесс
 */
router.post(
  '/',
  authenticate,
  authorize(['owner']),
  validate(createPaymentSchema),
  paymentController.create
);

/**
 * @route   POST /api/v1/payments/webhook
 * @desc    Вебхук Эсхата Мерчант о завершении заказа
 * @access  Public — банк не несёт наш JWT; тело не подписано, поэтому
 *          контроллер не доверяет ему напрямую и всегда перепроверяет
 *          статус подписанным запросом (см. paymentService.reconcile)
 */
router.post('/webhook', paymentController.webhook);

module.exports = router;
