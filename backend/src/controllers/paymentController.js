const paymentService = require('../services/paymentService');
const planService = require('../services/planService');
const ApiResponse = require('../utils/apiResponse');
const logger = require('../utils/logger');

/**
 * Payment controller — оплата подписки через Эсхата Мерчант.
 */
class PaymentController {
  /**
   * Создать заказ на оплату продления текущего тарифа фермы. Сумма и
   * описание считает `planService.getRenewalQuote` по тарифу фермы — тело
   * запроса пустое, платящий не выбирает сумму сам (см.
   * docs/plans/PLATFORM-ADMIN.md, 4.1).
   * POST /api/v1/payments
   */
  async create(req, res, next) {
    try {
      const quote = await planService.getRenewalQuote(req.farmId);
      const result = await paymentService.createPayment(req.farmId, quote);

      if (!result.success) {
        return ApiResponse.badRequest(res, result.message);
      }

      return ApiResponse.created(res, {
        invoice_id: result.payment.invoice_id,
        amount: quote.amount,
        qr: result.qr,
        invoice_url: result.invoiceUrl,
        deep_link: result.deepLink
      }, 'Заказ на оплату создан');
    } catch (error) {
      if (error.message === 'NO_PLAN') {
        return ApiResponse.badRequest(res, 'Ферме не назначен тариф', 'NO_PLAN');
      }
      if (error.message === 'PLAN_FREE') {
        return ApiResponse.badRequest(res, 'Текущий тариф бесплатный, оплата не требуется', 'PLAN_FREE');
      }
      next(error);
    }
  }

  /**
   * Ручной опрос статуса — мобильное приложение дёргает его после оплаты,
   * не дожидаясь вебхука банка (см. `paymentService.reconcile`, «напрямую,
   * если понадобится ручной опрос»). Платёж отдаётся, только если он
   * принадлежит своей ферме — иначе по чужому invoice_id можно было бы
   * узнать судьбу чужого платежа.
   * GET /api/v1/payments/:invoiceId
   */
  async status(req, res, next) {
    try {
      const result = await paymentService.reconcile(req.params.invoiceId);
      if (!result.found || result.payment.farm_id !== req.farmId) {
        return ApiResponse.notFound(res, 'Платёж не найден');
      }

      if (result.changed) {
        await planService.extendPlanExpiry(req.farmId);
      }

      return ApiResponse.success(res, { status: result.payment.status });
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
      const invoiceId = req.body && req.body.data && req.body.data.invoiceId;
      if (!invoiceId) {
        return res.sendStatus(200);
      }

      const result = await paymentService.reconcile(invoiceId);
      if (!result.found) {
        logger.info('Webhook for unknown invoice, ignoring', { invoiceId });
      } else if (result.changed) {
        await planService.extendPlanExpiry(result.payment.farm_id);
      }

      return res.sendStatus(200);
    } catch (error) {
      next(error);
    }
  }
}

module.exports = new PaymentController();
