const Redis = require('ioredis');
const config = require('../config/redis');
const logger = require('./logger');

// `retryStrategy: () => null` — если Redis один раз оказался недоступен, не
// пытаться переподключаться бесконечно в фоне (это держало бы соединение
// подвисшим и задерживало каждый следующий запрос таймаутом). Кэш просто
// выключается до перезапуска процесса — не хуже, чем если бы его не было.
const client = config.isConfigured
  ? new Redis(config.url, {
    lazyConnect: true,
    connectTimeout: 2000,
    maxRetriesPerRequest: 1,
    retryStrategy: () => null
  })
  : null;

if (client) {
  client.on('error', (error) => {
    logger.warn('Redis недоступен, кэш отключён на время процесса', { error: error.message });
  });
}

/**
 * Взять значение по ключу из кэша; при промахе — посчитать через `fn`,
 * закэшировать на `ttlSeconds` и вернуть посчитанное.
 *
 * Без `REDIS_URL` (или при любом сбое связи с Redis) просто зовёт `fn()`
 * напрямую — кэш только ускоряет, сервис не должен зависеть от него как от
 * источника истины.
 */
async function getOrSet(key, ttlSeconds, fn) {
  if (!client) return fn();

  try {
    const cached = await client.get(key);
    if (cached !== null) return JSON.parse(cached);
  } catch (error) {
    logger.warn('Redis: не удалось прочитать кэш, считаем заново', { key, error: error.message });
  }

  const value = await fn();

  try {
    await client.set(key, JSON.stringify(value), 'EX', ttlSeconds);
  } catch (error) {
    logger.warn('Redis: не удалось записать кэш', { key, error: error.message });
  }

  return value;
}

module.exports = { getOrSet, client };
