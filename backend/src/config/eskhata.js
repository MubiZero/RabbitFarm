require('dotenv').config();

/**
 * Эсхата Мерчант — приём оплаты подписки.
 *
 * Опциональная интеграция того же рода, что и Firebase: сервис должен
 * стартовать и без заведённого мерчант-аккаунта — просто платежи оформить
 * будет нельзя, а не сервис не поднимется.
 */
const baseUrl = process.env.ESKHATA_BASE_URL;
const companyId = process.env.ESKHATA_COMPANY_ID;
const hashKey = process.env.ESKHATA_HASH_KEY;
const merchantId = process.env.ESKHATA_MERCHANT_ID;

module.exports = {
  baseUrl,
  companyId,
  hashKey,
  merchantId,
  isConfigured: Boolean(baseUrl && companyId && hashKey && merchantId)
};
