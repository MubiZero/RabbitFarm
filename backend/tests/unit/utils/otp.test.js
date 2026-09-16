const crypto = require('crypto');
const { generateOtp, hashOtp, otpMatches } = require('../../../src/utils/otp');

/**
 * Код входа — шесть цифр, то есть миллион вариантов. Всё, что защищает его в
 * базе, — подпись серверным секретом: без неё «хеш» перебирается за доли
 * секунды и не даёт ничего поверх хранения открытым текстом. Тест сторожит
 * именно это свойство.
 */
describe('код входа', () => {
  const secret = process.env.JWT_SECRET;

  afterEach(() => {
    process.env.JWT_SECRET = secret;
    delete process.env.OTP_SECRET;
  });

  it('шесть цифр, включая ведущие нули', () => {
    for (let i = 0; i < 200; i++) {
      expect(generateOtp()).toMatch(/^\d{6}$/);
    }
  });

  it('по хешу код не перебрать без секрета', () => {
    const code = '000123';
    const plain = crypto.createHash('sha256').update(code).digest('hex');

    // Ровно та подстановка, которой код доставали из базы вручную: посчитать
    // sha256 от всех шести-значных чисел и найти совпадение.
    expect(hashOtp(code)).not.toBe(plain);
  });

  it('смена секрета меняет подпись того же кода', () => {
    process.env.OTP_SECRET = 'первый-секрет-подписи-кодов-входа';
    const first = hashOtp('123456');

    process.env.OTP_SECRET = 'второй-секрет-подписи-кодов-входа';
    expect(hashOtp('123456')).not.toBe(first);
  });

  it('отдельный секрет важнее общего', () => {
    process.env.OTP_SECRET = 'отдельный-секрет-для-кодов-входа-32сим';
    const withOwn = hashOtp('123456');

    delete process.env.OTP_SECRET;
    expect(hashOtp('123456')).not.toBe(withOwn);
  });

  it('свой код подходит, чужой — нет', () => {
    const stored = hashOtp('654321');

    expect(otpMatches('654321', stored)).toBe(true);
    expect(otpMatches('654322', stored)).toBe(false);
  });

  it('мусор вместо хеша не ломает проверку', () => {
    // Строка не той длины валила бы `timingSafeEqual` исключением, а из-за
    // него вход отвечал бы пятисоткой вместо «неверный код».
    expect(otpMatches('123456', '')).toBe(false);
    expect(otpMatches('123456', null)).toBe(false);
    expect(otpMatches('123456', 'не-шестнадцатеричная-строка')).toBe(false);
  });

  it('без секрета подписывать нечем — и это заметно сразу', () => {
    delete process.env.JWT_SECRET;
    expect(() => hashOtp('123456')).toThrow(/OTP_SECRET or JWT_SECRET/);
  });
});
