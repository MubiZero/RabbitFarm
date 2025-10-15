const jwt = require('jsonwebtoken');
const jwtConfig = require('../config/jwt');

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
    return jwt.sign(payload, jwtConfig.secret, {
      expiresIn: jwtConfig.expiresIn,
      algorithm: jwtConfig.algorithm
    });
  }

  /**
   * Generate refresh token
   * @param {Object} payload - Token payload
   * @returns {String} - JWT refresh token
   */
  static generateRefreshToken(payload) {
    return jwt.sign(payload, jwtConfig.refreshSecret, {
      expiresIn: jwtConfig.refreshExpiresIn,
      algorithm: jwtConfig.algorithm
    });
  }

  /**
   * Verify access token
   * @param {String} token - JWT token
   * @returns {Object} - Decoded payload
   */
  static verifyAccessToken(token) {
    try {
      return jwt.verify(token, jwtConfig.secret);
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
      return jwt.verify(token, jwtConfig.refreshSecret);
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
