const { User, RefreshToken } = require('../models');
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

      // Create user
      const user = await User.create({
        email: userData.email,
        password_hash: passwordHash,
        full_name: userData.full_name,
        phone: userData.phone || null,
        role: userData.role || 'worker'
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
      throw error;
    }
  }

  /**
   * Logout user
   * @param {String} refreshToken - Refresh token to invalidate
   */
  async logout(refreshToken) {
    try {
      // Delete refresh token
      const deleted = await RefreshToken.destroy({ where: { token: refreshToken } });

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
