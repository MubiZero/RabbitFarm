const Sentry = require('@sentry/node');
const sentryConfig = require('./config/sentry');

/**
 * Инициализация Sentry — самая первая строка, которую исполняет процесс
 * (см. `server.js`), как рекомендует сам Sentry: ошибка при загрузке любого
 * другого модуля тоже должна попасть в отчёт.
 *
 * Без `SENTRY_DSN` не инициализируется вовсе — `Sentry.captureException`
 * в этом случае просто no-op, сервис работает как раньше.
 *
 * `tracesSampleRate: 0` — только ошибки, без performance-трейсинга: на
 * бесплатном тарифе он единственный лимитированный ресурс, а на этом
 * масштабе ценность даёт именно факт исключения, не время запроса.
 */
if (sentryConfig.isConfigured) {
  Sentry.init({
    dsn: sentryConfig.dsn,
    environment: sentryConfig.environment,
    tracesSampleRate: 0
  });
}

module.exports = Sentry;
