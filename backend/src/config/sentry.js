require('dotenv').config();

/**
 * Sentry — опциональная интеграция, как SMTP и Payom SMS: без DSN сервис
 * стартует как обычно, просто ошибки никуда, кроме логов, не улетают.
 */
const dsn = process.env.SENTRY_DSN;
const environment = process.env.SENTRY_ENVIRONMENT || process.env.NODE_ENV || 'development';

module.exports = {
  dsn,
  environment,
  isConfigured: Boolean(dsn)
};
