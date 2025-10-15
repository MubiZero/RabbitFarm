const bcrypt = require('bcrypt');

const SALT_ROUNDS = 10;

/**
 * Password hashing utilities
 */
class PasswordUtil {
  /**
   * Hash password
   * @param {String} password - Plain text password
   * @returns {Promise<String>} - Hashed password
   */
  static async hash(password) {
    return await bcrypt.hash(password, SALT_ROUNDS);
  }

  /**
   * Compare password with hash
   * @param {String} password - Plain text password
   * @param {String} hash - Hashed password
   * @returns {Promise<Boolean>} - True if password matches
   */
  static async compare(password, hash) {
    return await bcrypt.compare(password, hash);
  }

  /**
   * Validate password strength
   * @param {String} password - Password to validate
   * @returns {Object} - Validation result
   */
  static validateStrength(password) {
    const errors = [];

    if (password.length < 8) {
      errors.push('Password must be at least 8 characters long');
    }

    if (!/[a-z]/.test(password)) {
      errors.push('Password must contain at least one lowercase letter');
    }

    if (!/[A-Z]/.test(password)) {
      errors.push('Password must contain at least one uppercase letter');
    }

    if (!/[0-9]/.test(password)) {
      errors.push('Password must contain at least one number');
    }

    return {
      valid: errors.length === 0,
      errors
    };
  }
}

module.exports = PasswordUtil;
