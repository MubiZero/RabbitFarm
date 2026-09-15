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
/**
 * Отказ банка — состояние окончательное, и человеку о нём надо сказать.
 *
 * Раньше `failed` не проставлялся ни в одной ветке: платёж, по которому банк
 * отказал, навсегда оставался «новым», и экран бесконечно отвечал «платёж
 * ещё не подтверждён». Выйти из этого состояния было нельзя.
 *
 * Список слов, а не «всё, что не COMPLETED»: документации по словарю
 * состояний у нас нет, и незнакомое значение безопаснее считать «ещё не
 * решили», чем объявить отказом живой платёж.
 */
const DECLINED_MARKERS = ['DECLIN', 'CANCEL', 'REJECT', 'FAIL', 'EXPIR', 'REVERS'];

function isDeclined(bankStatus) {
  if (!bankStatus) return false;
  const value = String(bankStatus).toUpperCase();
  return DECLINED_MARKERS.some((marker) => value.includes(marker));
}

class PaymentService {
  /**
   * Создать заказ на оплату для фермы.
   * @returns {{success:true, payment, qr, invoiceUrl, deepLink} | {success:false, message}}
   */
  async createPayment(farmId, { amount, description, plan }) {
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
      // Тариф фермы на этот момент, а не на момент подтверждения: между
      // созданием заказа и оплатой админ мог сменить план, а заплачено
      // будет за тот, по которому посчитана сумма.
      plan: plan || null,
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

    if (isDeclined(bankStatus)) {
      await payment.update({ status: 'failed', raw_response: body.data });
      logger.info('Payment declined by bank', { invoiceId, orderId: payment.order_id, bankStatus });
      return { found: true, payment, changed: true };
    }

    // Банк ещё не решил — или прислал слово, которого мы не знаем. Второе
    // пишем в лог именно затем, чтобы словарь ниже пополнялся по факту, а
    // не по догадкам: ошибиться здесь в сторону «отказ» хуже, чем подождать.
    if (bankStatus) {
      logger.warn('Unknown bank order status', { invoiceId, bankStatus });
    }
    await payment.update({ raw_response: body.data });
    return { found: true, payment, changed: false };
  }
}

module.exports = new PaymentService();
module.exports.isDeclined = isDeclined;
