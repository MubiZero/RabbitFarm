const PasswordUtil = require('../../../src/utils/password');

describe('PasswordUtil', () => {
  describe('hash', () => {
    it('должен хешировать пароль', async () => {
      const hash = await PasswordUtil.hash('mypassword123');
      expect(hash).toBeDefined();
      expect(hash).not.toBe('mypassword123');
      expect(hash.startsWith('$2b$')).toBe(true);
    });

    it('должен создавать разные хеши для одного пароля', async () => {
      const hash1 = await PasswordUtil.hash('mypassword123');
      const hash2 = await PasswordUtil.hash('mypassword123');
      expect(hash1).not.toBe(hash2);
    });
  });

  describe('compare', () => {
    it('должен возвращать true для верного пароля', async () => {
      const hash = await PasswordUtil.hash('correctpassword');
      const result = await PasswordUtil.compare('correctpassword', hash);
      expect(result).toBe(true);
    });

    it('должен возвращать false для неверного пароля', async () => {
      const hash = await PasswordUtil.hash('correctpassword');
      const result = await PasswordUtil.compare('wrongpassword', hash);
      expect(result).toBe(false);
    });
  });
});
