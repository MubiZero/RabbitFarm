const { generateOtp, hashOtp } = require('../../../src/utils/otp');

describe('otp', () => {
  describe('generateOtp', () => {
    it('должен возвращать строку ровно из 6 цифр', () => {
      for (let i = 0; i < 50; i++) {
        const code = generateOtp();
        expect(code).toMatch(/^\d{6}$/);
      }
    });

    it('должен дополнять нулями слева маленькие числа', () => {
      const randomIntSpy = jest.spyOn(require('crypto'), 'randomInt').mockReturnValue(42);
      expect(generateOtp()).toBe('000042');
      randomIntSpy.mockRestore();
    });
  });

  describe('hashOtp', () => {
    it('должен возвращать 64-символьный hex (SHA-256)', () => {
      expect(hashOtp('123456')).toMatch(/^[a-f0-9]{64}$/);
    });

    it('должен быть детерминированным для одного и того же кода', () => {
      expect(hashOtp('123456')).toBe(hashOtp('123456'));
    });

    it('должен давать разный хэш для разных кодов', () => {
      expect(hashOtp('123456')).not.toBe(hashOtp('654321'));
    });
  });
});
