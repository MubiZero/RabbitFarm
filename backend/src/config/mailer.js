require('dotenv').config();

/**
 * Почта (сброс пароля) — опциональная интеграция, как Payom SMS и Firebase:
 * сервис стартует и без неё, просто письмо не уходит. SMTP через
 * собственный почтовый сервер (Stalwart), не сторонний API-провайдер.
 */
const host = process.env.SMTP_HOST;
const port = Number(process.env.SMTP_PORT) || 587;
const useStartTls = process.env.SMTP_USE_STARTTLS !== 'false';
const username = process.env.SMTP_USERNAME;
const password = process.env.SMTP_PASSWORD;
const fromAddress = process.env.SMTP_FROM_ADDRESS;
const fromName = process.env.SMTP_FROM_NAME || 'RabbitFarm';

module.exports = {
  host,
  port,
  useStartTls,
  username,
  password,
  fromAddress,
  fromName,
  isConfigured: Boolean(host && username && password && fromAddress)
};
