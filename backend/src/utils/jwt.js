const jwt = require('jsonwebtoken');
const { randomUUID } = require('crypto');
const jwtConfig = require('../config/jwt');

const ACCESS = 'access';
const REFRESH = 'refresh';

/**
 * Назначение токена подписывается вместе с ним.
 *
 * Сами по себе access- и refresh-токены различаются только секретом, которым
 * подписаны. Если оператор случайно выставит один и тот же секрет в обе
 * переменные, refresh-токен пройдёт проверку как access — и семидневный токен
 * станет обычным пропуском. Явное поле typ закрывает такую подмену, даже когда
 * секреты совпали. Токены, выписанные до появления поля, ещё принимаются.
 */
const assertType = (decoded, expected) => {
  if (decoded.typ && decoded.typ !== expected) {
    throw new Error('Wrong token type');
  }
  return decoded;
};

/**
 * JWT utility functions
 */
class JWTUtil {
  /**
   * Generate access token
   * @param {Object} payload - Token payload
   * @returns {String} - JWT token
   */
  static generateAccessToken(payload) {
    return jwt.sign(
      { ...payload, jti: randomUUID(), typ: ACCESS },
      jwtConfig.secret,
      { expiresIn: jwtConfig.expiresIn, algorithm: jwtConfig.algorithm }
    );
  }

  /**
   * Generate refresh token
   * @param {Object} payload - Token payload
   * @returns {String} - JWT refresh token
   */
  static generateRefreshToken(payload) {
    return jwt.sign(
      { ...payload, jti: randomUUID(), typ: REFRESH },
      jwtConfig.refreshSecret,
      { expiresIn: jwtConfig.refreshExpiresIn, algorithm: jwtConfig.algorithm }
    );
  }

  /**
   * Verify access token
   * @param {String} token - JWT token
   * @returns {Object} - Decoded payload
   */
  static verifyAccessToken(token) {
    try {
      return assertType(jwt.verify(token, jwtConfig.secret), ACCESS);
    } catch (error) {
      throw new Error('Invalid or expired token');
    }
  }

  /**
   * Verify refresh token
   * @param {String} token - JWT refresh token
   * @returns {Object} - Decoded payload
   */
  static verifyRefreshToken(token) {
    try {
      return assertType(jwt.verify(token, jwtConfig.refreshSecret), REFRESH);
    } catch (error) {
      throw new Error('Invalid or expired refresh token');
    }
  }

  /**
   * Decode token without verification
   * @param {String} token - JWT token
   * @returns {Object} - Decoded payload
   */
  static decode(token) {
    return jwt.decode(token);
  }
}

module.exports = JWTUtil;
