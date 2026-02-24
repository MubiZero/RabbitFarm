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

  describe('validateStrength', () => {
    it('should return valid=true for strong password', () => {
      const result = PasswordUtil.validateStrength('StrongPass1');
      expect(result.valid).toBe(true);
      expect(result.errors).toHaveLength(0);
    });

    it('should return error for password shorter than 8 chars', () => {
      const result = PasswordUtil.validateStrength('Abc1');
      expect(result.valid).toBe(false);
      expect(result.errors).toContain('Password must be at least 8 characters long');
    });

    it('should return error for missing lowercase letter', () => {
      const result = PasswordUtil.validateStrength('UPPERCASE123');
      expect(result.valid).toBe(false);
      expect(result.errors).toContain('Password must contain at least one lowercase letter');
    });

    it('should return error for missing uppercase letter', () => {
      const result = PasswordUtil.validateStrength('lowercase123');
      expect(result.valid).toBe(false);
      expect(result.errors).toContain('Password must contain at least one uppercase letter');
    });

    it('should return error for missing number', () => {
      const result = PasswordUtil.validateStrength('NoNumbers!');
      expect(result.valid).toBe(false);
      expect(result.errors).toContain('Password must contain at least one number');
    });

    it('should return multiple errors for very weak password', () => {
      const result = PasswordUtil.validateStrength('abc');
      expect(result.valid).toBe(false);
      expect(result.errors.length).toBeGreaterThan(1);
    });
  });
});
