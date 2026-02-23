const JWTUtil = require('../../../src/utils/jwt');

describe('JWTUtil', () => {
  const payload = { id: 1, email: 'test@example.com', role: 'owner' };

  describe('generateAccessToken', () => {
    it('должен создавать валидный access token', () => {
      const token = JWTUtil.generateAccessToken(payload);
      expect(token).toBeDefined();
      expect(typeof token).toBe('string');
      expect(token.split('.')).toHaveLength(3);
    });
  });

  describe('verifyAccessToken', () => {
    it('должен верифицировать корректный token', () => {
      const token = JWTUtil.generateAccessToken(payload);
      const decoded = JWTUtil.verifyAccessToken(token);
      expect(decoded.id).toBe(payload.id);
      expect(decoded.email).toBe(payload.email);
      expect(decoded.role).toBe(payload.role);
    });

    it('должен бросать ошибку для невалидного token', () => {
      expect(() => JWTUtil.verifyAccessToken('invalid.token.here')).toThrow('Invalid or expired token');
    });

    it('должен бросать ошибку для подделанного token', () => {
      const token = JWTUtil.generateAccessToken(payload);
      const tampered = token.slice(0, -5) + 'XXXXX';
      expect(() => JWTUtil.verifyAccessToken(tampered)).toThrow('Invalid or expired token');
    });
  });

  describe('generateRefreshToken + verifyRefreshToken', () => {
    it('должен создавать и верифицировать refresh token', () => {
      const refreshPayload = { id: 1 };
      const token = JWTUtil.generateRefreshToken(refreshPayload);
      const decoded = JWTUtil.verifyRefreshToken(token);
      expect(decoded.id).toBe(1);
    });
  });

  describe('decode', () => {
    it('должен декодировать token без верификации', () => {
      const token = JWTUtil.generateAccessToken(payload);
      const decoded = JWTUtil.decode(token);
      expect(decoded.id).toBe(payload.id);
    });
  });
});
