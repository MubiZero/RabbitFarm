const { User, RefreshToken, TokenBlacklist, PasswordResetToken } = require('../models');
const crypto = require('crypto');
const PasswordUtil = require('../utils/password');
const JWTUtil = require('../utils/jwt');
const logger = require('../utils/logger');

/**
 * Authentication service
 * Handles user registration, login, token management
 */
class AuthService {
  /**
   * Register new user
   * @param {Object} userData - User data
   * @returns {Object} User and tokens
   */
  async register(userData) {
    const transaction = await User.sequelize.transaction();
    try {
      // Check if user already exists
      const existingUser = await User.findOne({
        where: { email: userData.email },
        transaction
      });
      if (existingUser) {
        throw new Error('USER_EXISTS');
      }

      // Hash password
      const passwordHash = await PasswordUtil.hash(userData.password);

      // Create user — self-registered users are always owners of their farm
      const user = await User.create({
        email: userData.email,
        password_hash: passwordHash,
        full_name: userData.full_name,
        phone: userData.phone || null,
        role: 'owner'
      }, { transaction });

      // Generate tokens
      const accessToken = JWTUtil.generateAccessToken({ id: user.id, email: user.email, role: user.role });
      const refreshToken = JWTUtil.generateRefreshToken({ id: user.id });

      // Save refresh token
      const expiresAt = new Date();
      expiresAt.setDate(expiresAt.getDate() + 7); // 7 days

      await RefreshToken.create({
        user_id: user.id,
        token: refreshToken,
        expires_at: expiresAt
      }, { transaction });

      await transaction.commit();
      logger.info('User registered successfully', { userId: user.id, email: user.email });

      // Remove password hash from response
      const userResponse = user.toJSON();

      return {
        user: userResponse,
        access_token: accessToken,
        refresh_token: refreshToken
      };
    } catch (error) {
      if (transaction) await transaction.rollback();
      logger.error('Registration error', { error: error.message });
      throw error;
    }
  }

  /**
   * Login user
   * @param {String} email - User email
   * @param {String} password - User password
   * @returns {Object} User and tokens
   */
  async login(email, password) {
    try {
      // Find user
      const user = await User.findOne({ where: { email } });
      if (!user) {
        throw new Error('INVALID_CREDENTIALS');
      }

      // Check if user is active
      if (!user.is_active) {
        throw new Error('USER_INACTIVE');
      }

      // Verify password
      const isPasswordValid = await PasswordUtil.compare(password, user.password_hash);
      if (!isPasswordValid) {
        throw new Error('INVALID_CREDENTIALS');
      }

      // Generate tokens
      const accessToken = JWTUtil.generateAccessToken({ id: user.id, email: user.email, role: user.role });
      const refreshToken = JWTUtil.generateRefreshToken({ id: user.id });

      // Save refresh token
      const expiresAt = new Date();
      expiresAt.setDate(expiresAt.getDate() + 7);

      await RefreshToken.create({
        user_id: user.id,
        token: refreshToken,
        expires_at: expiresAt
      });

      // Update last login
      await user.update({ last_login_at: new Date() });

      logger.info('User logged in successfully', { userId: user.id, email: user.email });

      // Remove password hash from response
      const userResponse = user.toJSON();

      return {
        user: userResponse,
        access_token: accessToken,
        refresh_token: refreshToken
      };
    } catch (error) {
      logger.error('Login error', { error: error.message, email });
      throw error;
    }
  }

  /**
   * Refresh access token
   * @param {String} refreshToken - Refresh token
   * @returns {Object} New tokens
   */
  async refreshAccessToken(refreshToken) {
    try {
      // Verify refresh token
      const decoded = JWTUtil.verifyRefreshToken(refreshToken);

      // Find refresh token in database
      const tokenRecord = await RefreshToken.findOne({
        where: { token: refreshToken },
        include: [{ model: User, attributes: ['id', 'email', 'role', 'is_active'] }]
      });

      if (!tokenRecord) {
        throw new Error('INVALID_REFRESH_TOKEN');
      }

      // Check if token expired
      if (new Date() > tokenRecord.expires_at) {
        await tokenRecord.destroy();
        throw new Error('REFRESH_TOKEN_EXPIRED');
      }

      // Check if user is active
      if (!tokenRecord.User.is_active) {
        throw new Error('USER_INACTIVE');
      }

      // Generate new access token
      const accessToken = JWTUtil.generateAccessToken({
        id: tokenRecord.User.id,
        email: tokenRecord.User.email,
        role: tokenRecord.User.role
      });

      // Generate new refresh token
      const newRefreshToken = JWTUtil.generateRefreshToken({ id: tokenRecord.User.id });

      // Update refresh token in database
      const expiresAt = new Date();
      expiresAt.setDate(expiresAt.getDate() + 7);

      await tokenRecord.update({
        token: newRefreshToken,
        expires_at: expiresAt
      });

      logger.info('Access token refreshed', { userId: tokenRecord.User.id });

      return {
        access_token: accessToken,
        refresh_token: newRefreshToken
      };
    } catch (error) {
      logger.error('Refresh token error', { error: error.message });
      if (error.message === 'Invalid or expired refresh token') {
        throw new Error('INVALID_REFRESH_TOKEN');
      }
      throw error;
    }
  }

  /**
   * Logout user
   * @param {String} refreshToken - Refresh token to invalidate
   * @param {String} accessToken - Access token to blacklist
   */
  async logout(refreshToken, accessToken) {
    try {
      // Delete refresh token
      const deleted = await RefreshToken.destroy({ where: { token: refreshToken } });

      // Blacklist the access token if provided
      if (accessToken) {
        try {
          const decoded = JWTUtil.verifyAccessToken(accessToken);
          if (decoded && decoded.jti) {
            const expiresAt = new Date(decoded.exp * 1000);
            await TokenBlacklist.create({ jti: decoded.jti, expires_at: expiresAt });
          }
        } catch (err) {
          // Ignore invalid access tokens during logout
        }
      }

      if (deleted > 0) {
        logger.info('User logged out successfully');
      }

      return { success: true };
    } catch (error) {
      logger.error('Logout error', { error: error.message });
      throw error;
    }
  }

  /**
   * Get user profile
   * @param {Number} userId - User ID
   * @returns {Object} User profile
   */
  async getProfile(userId) {
    try {
      const user = await User.findByPk(userId, {
        attributes: { exclude: ['password_hash'] }
      });

      if (!user) {
        throw new Error('USER_NOT_FOUND');
      }

      return user;
    } catch (error) {
      logger.error('Get profile error', { error: error.message, userId });
      throw error;
    }
  }

  /**
   * Update user profile
   * @param {Number} userId - User ID
   * @param {Object} updateData - Data to update
   * @returns {Object} Updated user
   */
  async updateProfile(userId, updateData) {
    try {
      const user = await User.findByPk(userId);

      if (!user) {
        throw new Error('USER_NOT_FOUND');
      }

      await user.update(updateData);

      logger.info('Profile updated', { userId });

      // Remove password hash from response
      return user.toJSON();
    } catch (error) {
      logger.error('Update profile error', { error: error.message, userId });
      throw error;
    }
  }

  /**
   * Change user password
   * @param {Number} userId - User ID
   * @param {String} currentPassword - Current password
   * @param {String} newPassword - New password
   */
  async changePassword(userId, currentPassword, newPassword) {
    const transaction = await User.sequelize.transaction();
    try {
      const user = await User.findByPk(userId, { transaction });

      if (!user) {
        await transaction.rollback();
        throw new Error('USER_NOT_FOUND');
      }

      // Verify current password
      const isPasswordValid = await PasswordUtil.compare(currentPassword, user.password_hash);
      if (!isPasswordValid) {
        await transaction.rollback();
        throw new Error('INVALID_CURRENT_PASSWORD');
      }

      // Hash new password
      const newPasswordHash = await PasswordUtil.hash(newPassword);

      // Update password
      await user.update({ password_hash: newPasswordHash }, { transaction });

      // Invalidate all refresh tokens (force re-login on all devices)
      await RefreshToken.destroy({
        where: { user_id: userId },
        transaction
      });

      await transaction.commit();
      logger.info('Password changed successfully', { userId });

      return { success: true };
    } catch (error) {
      if (transaction) await transaction.rollback();
      logger.error('Change password error', { error: error.message, userId });
      throw error;
    }
  }

  /**
   * Request password reset
   * @param {String} email - User email
   * @returns {Object} { token } - plain text token for testing; in prod would be emailed
   */
  async forgotPassword(email) {
    try {
      const user = await User.findOne({ where: { email } });
      // Always return success to avoid email enumeration
      if (!user || !user.is_active) {
        return { success: true };
      }

      // Delete any existing tokens for this user
      await PasswordResetToken.destroy({ where: { user_id: user.id } });

      // Generate a secure random token
      const plainToken = crypto.randomBytes(32).toString('hex');
      const tokenHash = crypto.createHash('sha256').update(plainToken).digest('hex');

      const expiresAt = new Date();
      expiresAt.setHours(expiresAt.getHours() + 1); // 1 hour

      await PasswordResetToken.create({
        user_id: user.id,
        token_hash: tokenHash,
        expires_at: expiresAt
      });

      logger.info('Password reset token created', { userId: user.id, email });

      // In production, this token would be sent by email.
      // We return it here for testability.
      return { success: true, token: plainToken };
    } catch (error) {
      logger.error('Forgot password error', { error: error.message, email });
      throw error;
    }
  }

  /**
   * Reset password using token
   * @param {String} token - Plain text reset token
   * @param {String} newPassword - New password
   */
  async resetPassword(token, newPassword) {
    const transaction = await User.sequelize.transaction();
    try {
      const tokenHash = crypto.createHash('sha256').update(token).digest('hex');

      const resetRecord = await PasswordResetToken.findOne({
        where: { token_hash: tokenHash },
        include: [{ model: User, attributes: ['id', 'email', 'is_active'] }],
        transaction
      });

      if (!resetRecord) {
        throw new Error('INVALID_RESET_TOKEN');
      }

      if (new Date() > resetRecord.expires_at) {
        await resetRecord.destroy({ transaction });
        throw new Error('RESET_TOKEN_EXPIRED');
      }

      if (!resetRecord.User.is_active) {
        throw new Error('USER_INACTIVE');
      }

      const newPasswordHash = await PasswordUtil.hash(newPassword);

      await User.update(
        { password_hash: newPasswordHash },
        { where: { id: resetRecord.User.id }, transaction }
      );

      // Delete used token
      await resetRecord.destroy({ transaction });

      // Invalidate all refresh tokens (force re-login)
      await RefreshToken.destroy({ where: { user_id: resetRecord.User.id }, transaction });

      await transaction.commit();
      logger.info('Password reset successfully', { userId: resetRecord.User.id });

      return { success: true };
    } catch (error) {
      await transaction.rollback();
      logger.error('Reset password error', { error: error.message });
      throw error;
    }
  }

  /**
   * Clean expired refresh tokens
   * Should be called periodically (e.g., cron job)
   */
  async cleanExpiredTokens() {
    try {
      const deleted = await RefreshToken.destroy({
        where: {
          expires_at: { [require('sequelize').Op.lt]: new Date() }
        }
      });

      logger.info(`Cleaned ${deleted} expired refresh tokens`);
      return deleted;
    } catch (error) {
      logger.error('Clean expired tokens error', { error: error.message });
      throw error;
    }
  }
}

module.exports = new AuthService();
