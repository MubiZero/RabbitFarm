const paymentService = require('../services/paymentService');
const ApiResponse = require('../utils/apiResponse');
const logger = require('../utils/logger');

/**
 * Payment controller — оплата подписки через Эсхата Мерчант.
 */
class PaymentController {
  /**
   * Создать заказ на оплату.
   * POST /api/v1/payments
   */
  async create(req, res, next) {
    try {
      const result = await paymentService.createPayment(req.farmId, req.body);

      if (!result.success) {
        return ApiResponse.badRequest(res, result.message);
      }

      return ApiResponse.created(res, {
        invoice_id: result.payment.invoice_id,
        qr: result.qr,
        invoice_url: result.invoiceUrl,
        deep_link: result.deepLink
      }, 'Заказ на оплату создан');
    } catch (error) {
      next(error);
    }
  }

  /**
   * Вебхук банка. Тело не подписано — единственное действие здесь: узнать,
   * какую заявку перепроверить. Сам перевод в completed происходит только
   * по результату подписанного /orders/status, внутри paymentService.
   *
   * Банк повторяет доставку, если получает не 200 — поэтому на любое
   * событие не про нас или без нужных полей отвечаем 200, а не 4xx/5xx.
   * 5xx здесь означало бы «попробуйте ещё раз позже» — уместно только если
   * сверка на нашей стороне не удалась технически (БД недоступна и т.п.),
   * что дальше уходит в next(error) и общий обработчик.
   */
  async webhook(req, res, next) {
    try {
      const invoiceId = req.body && req.body.invoiceId;
      if (!invoiceId) {
        return res.sendStatus(200);
      }

      const result = await paymentService.reconcile(invoiceId);
      if (!result.found) {
        logger.info('Webhook for unknown invoice, ignoring', { invoiceId });
      }

      return res.sendStatus(200);
    } catch (error) {
      next(error);
    }
  }
}

module.exports = new PaymentController();
