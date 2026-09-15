const crypto = require('crypto');

/**
 * Одноразовый код входа: как он рождается и как хранится.
 *
 * Хранить сам код нельзя — дамп базы отдал бы действующие коды всех, кто
 * сейчас входит. Но и обычного хеша тут недостаточно: кодов ровно миллион,
 * и sha256 от шести цифр перебирается на ноутбуке за доли секунды. Такой
 * «хеш» не даёт ничего поверх хранения открытым текстом — он лишь создаёт
 * видимость защиты.
 *
 * Поэтому код подписывается серверным секретом (HMAC): без секрета перебор
 * бесполезен, а значит утёкшая копия базы кодов не выдаёт.
 */

function generateOtp() {
  return String(crypto.randomInt(0, 1_000_000)).padStart(6, '0');
}

/**
 * Секрет подписи. Отдельная переменная, если она задана, иначе тот же
 * секрет, что у токенов, — заводить новую обязательную настройку ради этого
 * значило бы уронить каждый существующий стенд при обновлении.
 *
 * Читается при каждом вызове, а не один раз при загрузке модуля: тесты
 * выставляют окружение после подключения файлов.
 */
function otpSecret() {
  const secret = process.env.OTP_SECRET || process.env.JWT_SECRET;
  if (!secret) {
    throw new Error('OTP_SECRET or JWT_SECRET must be set to hash login codes');
  }
  return secret;
}

function hashOtp(code) {
  return crypto.createHmac('sha256', otpSecret()).update(String(code)).digest('hex');
}

/**
 * Сравнение за постоянное время.
 *
 * Попыток на код всего несколько, так что подобрать его по времени ответа
 * всё равно не вышло бы, — но сравнение подписей и не должно зависеть от
 * данных, и делать здесь исключение незачем.
 */
function otpMatches(code, storedHash) {
  const actual = Buffer.from(hashOtp(code), 'hex');
  const expected = Buffer.from(String(storedHash || ''), 'hex');
  if (actual.length !== expected.length) return false;
  return crypto.timingSafeEqual(actual, expected);
}

module.exports = { generateOtp, hashOtp, otpMatches };
