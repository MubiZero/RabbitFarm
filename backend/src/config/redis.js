require('dotenv').config();

/**
 * Redis — опциональный кэш агрегирующих запросов, как SMTP и Sentry выше:
 * без него сервис считает каждый раз заново, как и раньше, а не падает.
 */
const url = process.env.REDIS_URL;

module.exports = {
  url,
  isConfigured: Boolean(url)
};
