require('dotenv').config();

/**
 * Срок жизни refresh-токена в миллисекундах.
 *
 * Одно значение и для самого токена, и для строки в `refresh_tokens`: раньше
 * срок был записан дважды — в переменной окружения и числом `+ 7` в
 * authService, — и переменная ничего не решала, потому что в базу всё равно
 * ложилась неделя.
 */
function parseDuration(value, fallbackMs) {
  const match = /^(\d+)([dhm])$/.exec(String(value || '').trim());
  if (!match) return fallbackMs;

  const amount = Number(match[1]);
  const unitMs = { d: 86400000, h: 3600000, m: 60000 }[match[2]];
  return amount * unitMs;
}

// Три месяца, а не неделя. Токен обновляется при каждом заходе, поэтому срок
// задевает только тех, кто долго не открывал приложение, — а фермеру в
// межсезонье это нормально. Экран входа с запросом СМС-кода после каждой
// паузы отучает пользоваться приложением быстрее, чем что-либо ещё.
const DEFAULT_REFRESH_MS = 90 * 86400000;
const refreshExpiresIn = process.env.JWT_REFRESH_EXPIRE || '90d';

module.exports = {
  secret: process.env.JWT_SECRET,
  expiresIn: process.env.JWT_EXPIRE || '15m',
  refreshSecret: process.env.JWT_REFRESH_SECRET,
  refreshExpiresIn,
  refreshExpiresMs: parseDuration(refreshExpiresIn, DEFAULT_REFRESH_MS),
  algorithm: 'HS256'
};
