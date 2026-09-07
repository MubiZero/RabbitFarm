const config = require('../../config/eskhata');
const { signCreateOrder, signStatus, formatAmount } = require('./eskhataSigner');

/**
 * X-CompanyId уходит в base64, а не как есть.
 */
function companyIdHeader() {
  return Buffer.from(config.companyId, 'utf8').toString('base64');
}

function headers() {
  return {
    'Content-Type': 'application/json',
    'X-CompanyId': companyIdHeader()
  };
}

/**
 * Создать заказ. Для orderTypeId=3 (динамическая касса) posId уходит нулём —
 * банк назначает кассу сам и возвращает её в ответе.
 *
 * Возвращает разобранное тело ответа как есть: вызывающий код обязан
 * проверить поле `status` — HTTP 200 c `status: false` означает деловой
 * отказ (например «нет свободной кассы»), а не успех.
 */
async function createOrder({ invoiceId, amount, currency = '972', description, orderTypeId = 3 }) {
  const posId = 0;
  const merchantId = Number(config.merchantId);
  const hash = signCreateOrder(
    { invoiceId, amount, currency, description, posId, orderTypeId, merchantId },
    config.hashKey
  );

  const response = await fetch(`${config.baseUrl}/merchant/api/v1/orders/create`, {
    method: 'POST',
    headers: headers(),
    body: JSON.stringify({
      hash,
      invoiceId,
      amount: Number(formatAmount(amount)),
      currency,
      description,
      posId,
      merchantId,
      orderTypeId
    })
  });

  return { httpStatus: response.status, body: await response.json() };
}

/**
 * Перепроверить статус заказа подписанным запросом. Единственный источник
 * истины «оплачено или нет» — вебхук сам по себе не доказывает ничего.
 */
async function checkStatus({ invoiceId, orderId, amount, currency = '972', posId }) {
  const hash = signStatus({ invoiceId, orderId, amount, currency, posId }, config.hashKey);

  const response = await fetch(`${config.baseUrl}/merchant/api/v1/orders/status`, {
    method: 'POST',
    headers: headers(),
    body: JSON.stringify({ hash, invoiceId, orderId, amount: Number(formatAmount(amount)), currency, posId })
  });

  return { httpStatus: response.status, body: await response.json() };
}

module.exports = { createOrder, checkStatus, companyIdHeader };
