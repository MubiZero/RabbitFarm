const Transport = require('winston-transport');
const Sentry = require('../instrument');
const telegramAlert = require('./telegramAlert');

/**
 * Единая точка выхода наружу для всего, что логируется через `logger.error`
 * — не только ошибок HTTP-запросов, но и упавших cron-джоб, неудачного
 * health-check'а и необработанных исключений процесса (см. `server.js`).
 * Ни Sentry, ни Telegram не знают об остальном коде: обе интеграции узнают
 * об ошибке ровно тем же способом, каким raньше её видел только файл лога.
 *
 * Каждая интеграция no-op сама по себе, если не настроена (см.
 * `config/sentry.js`, `config/telegram.js`) — транспорт всегда подключён,
 * просто ничего никуда не шлёт, пока не заданы переменные окружения.
 */
class AlertTransport extends Transport {
  constructor(opts) {
    super({ ...opts, level: 'error' });
  }

  log(info, callback) {
    setImmediate(() => this.emit('logged', info));

    // `stack`, если он был передан вызовом `logger.error(..., { stack })`, —
    // настоящее место падения; без него Sentry получил бы стек этого
    // транспорта, бесполезный для разбора.
    const { message, stack, ...meta } = info;
    const error = new Error(message);
    if (typeof stack === 'string') error.stack = stack;
    Sentry.captureException(error, { extra: meta });

    const metaText = Object.keys(meta).length ? `\n${JSON.stringify(meta)}` : '';
    telegramAlert.sendAlert(`🐇 RabbitFarm: ${message}${metaText}`.slice(0, 4000));

    callback();
  }
}

module.exports = AlertTransport;
