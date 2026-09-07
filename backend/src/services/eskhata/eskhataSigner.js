const crypto = require('crypto');

/**
 * Подпись Эсхата Мерчант.
 *
 * Вопреки формулировке в документации банка это НЕ HMAC: значения по
 * порядку спецификации склеиваются без разделителей, к ним через точку
 * добавляется HashKey, и от всего этого считается SHA-256 в нижнем
 * регистре. Массивы (например items) в конкатенацию не входят, сам hash —
 * тоже. Проверено сверкой с тестовым контуром банка 24.08.2026.
 */
function sha256Hex(input) {
  return crypto.createHash('sha256').update(input, 'utf8').digest('hex');
}

/**
 * Сумма — в подписи и в теле — с ровно двумя знаками после точки.
 * Считать в минорных единицах и форматировать один раз и одинаково —
 * иначе подпись и тело разойдутся на одном и том же платеже.
 */
function formatAmount(amount) {
  return Number(amount).toFixed(2);
}

/**
 * Подпись создания заказа.
 * Порядок значений: invoiceId · amount · currency · description · posId ·
 * orderTypeId · merchantId.
 */
function signCreateOrder({ invoiceId, amount, currency, description, posId, orderTypeId, merchantId }, hashKey) {
  const parts = [
    invoiceId,
    formatAmount(amount),
    currency,
    description,
    String(posId),
    String(orderTypeId),
    String(merchantId)
  ];
  return sha256Hex(parts.join('') + '.' + hashKey);
}

/**
 * Подпись запроса статуса.
 * Порядок значений: invoiceId · orderId · amount · currency · posId.
 */
function signStatus({ invoiceId, orderId, amount, currency, posId }, hashKey) {
  const parts = [invoiceId, orderId, formatAmount(amount), currency, String(posId)];
  return sha256Hex(parts.join('') + '.' + hashKey);
}

module.exports = { sha256Hex, formatAmount, signCreateOrder, signStatus };
