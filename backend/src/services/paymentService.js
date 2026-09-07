const crypto = require('crypto');
const { Payment } = require('../models');
const eskhataClient = require('./eskhata/eskhataClient');
const { buildDeepLink } = require('./eskhata/eskhataDeepLink');
const logger = require('../utils/logger');

/**
 * Оплата подписки через Эсхата Мерчант.
 *
 * Правило banка: HTTP 200 ещё не значит успех — деловой отказ приезжает с
 * `status: false` в теле. Заявку, которой банк отказал при создании, мы не
 * сохраняем вовсе: платить по ней нечем, а в списке платежей она выглядела
 * бы как ожидающая оплаты.
 *
 * Зачисление денег в этом сервисе не описано намеренно: сервис отвечает
 * только за жизненный цикл платежа в терминах банка (new → completed/failed).
 * Что именно покупает платёж (продление подписки, план) — решает вызывающий
 * код после того, как статус стал `completed`.
 */
class PaymentService {
  /**
   * Создать заказ на оплату для фермы.
   * @returns {{success:true, payment, qr, invoiceUrl, deepLink} | {success:false, message}}
   */
  async createPayment(farmId, { amount, description }) {
    const invoiceId = crypto.randomUUID();

    const { body } = await eskhataClient.createOrder({ invoiceId, amount, description });

    if (!body.status) {
      logger.warn('Eskhata order declined at creation', { invoiceId, farmId, message: body.message });
      return { success: false, message: body.message || 'ORDER_DECLINED' };
    }

    const payment = await Payment.create({
      farm_id: farmId,
      invoice_id: invoiceId,
      order_id: body.data.orderId,
      pos_id: body.data.posId,
      amount,
      description,
      status: 'new',
      raw_response: body.data
    });

    logger.info('Payment order created', { invoiceId, orderId: body.data.orderId, farmId });

    return {
      success: true,
      payment,
      qr: body.data.qr,
      invoiceUrl: body.data.invoiceUrl,
      deepLink: buildDeepLink(body.data.invoiceUrl)
    };
  }

  /**
   * Перепроверить и, если банк подтвердил оплату, закрыть платёж как
   * завершённый. Идемпотентно: платёж, уже отмеченный `completed`, второй
   * раз не переоткрывается — и вебхук, и опрос статуса могут прийти на один
   * и тот же платёж не один раз.
   *
   * Вызывается и по вебхуку (после которого — ещё и обязательная сверка),
   * и напрямую, если понадобится ручной опрос.
   */
  async reconcile(invoiceId) {
    const payment = await Payment.findOne({ where: { invoice_id: invoiceId }, tenantScope: 'all' });
    if (!payment) {
      // Приходит и на чужие, и на неинтересные события — не наша заявка,
      // а не ошибка.
      return { found: false };
    }

    if (payment.status === 'completed') {
      return { found: true, payment, changed: false };
    }

    const { body } = await eskhataClient.checkStatus({
      invoiceId: payment.invoice_id,
      orderId: payment.order_id,
      amount: payment.amount,
      currency: payment.currency,
      posId: payment.pos_id
    });

    if (!body.status) {
      logger.warn('Eskhata status check declined', { invoiceId, message: body.message });
      return { found: true, payment, changed: false };
    }

    const bankStatus = body.data && body.data.orderStatus;
    if (bankStatus === 'COMPLETED') {
      await payment.update({ status: 'completed', raw_response: body.data });
      logger.info('Payment completed', { invoiceId, orderId: payment.order_id });
      return { found: true, payment, changed: true };
    }

    await payment.update({ raw_response: body.data });
    return { found: true, payment, changed: false };
  }
}

module.exports = new PaymentService();
