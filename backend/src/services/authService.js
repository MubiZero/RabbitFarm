const { Farm, User, RefreshToken, TokenBlacklist, LoginOtp } = require('../models');
const JWTUtil = require('../utils/jwt');
const logger = require('../utils/logger');
const planService = require('./planService');

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
  /**
   * Выпустить пару токенов и запомнить refresh.
   * @param {Object} user - пользователь
   * @param {Object} transaction - необязательная транзакция
   */
  async issueTokens(user, transaction = null) {
    const accessToken = JWTUtil.generateAccessToken({ id: user.id, email: user.email, role: user.role, tv: user.token_version || 0 });
    const refreshToken = JWTUtil.generateRefreshToken({ id: user.id });

    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 7);

    await RefreshToken.create({
      user_id: user.id,
      token: refreshToken,
      expires_at: expiresAt
    }, transaction ? { transaction } : {});

    return { access_token: accessToken, refresh_token: refreshToken };
  }

  async register(userData) {
    const transaction = await User.sequelize.transaction();
    try {
      // Регистрация заводит НОВУЮ ферму и её владельца — ферм в сервисе
      // много. Работника заводит не регистрация, а приглашение
      // (`staffService.createInvitation`): там человек получает `farm_id`
      // фермы, которая его позвала.
      //
      // Флаг остаётся выключателем: `ALLOW_REGISTRATION=false` закрывает
      // публичную регистрацию, когда стенд не должен принимать посторонних.
      if (process.env.ALLOW_REGISTRATION === 'false') {
        throw new Error('REGISTRATION_CLOSED');
      }

      // Контакт уже приведён валидатором к тому же виду, в котором его ищет
      // вход по коду: телефон — `+992XXXXXXXXX`, почта — в нижнем регистре.
      if (userData.email) {
        const existingUser = await User.findOne({
          where: { email: userData.email },
          transaction
        });
        if (existingUser) {
          throw new Error('USER_EXISTS');
        }
      }

      if (userData.phone) {
        const existingPhone = await User.findOne({
          where: { phone: userData.phone },
          transaction
        });
        if (existingPhone) {
          throw new Error('PHONE_EXISTS');
        }
      }

      // Ферма и её владелец ссылаются друг на друга, поэтому появляются по
      // очереди: сначала хозяйство без владельца, затем человек в нём, затем
      // владелец проставляется ферме. Всё в одной транзакции — хозяйство без
      // хозяина наружу не выходит.
      //
      // Тариф по умолчанию назначается сразу: без него «нет плана = нет
      // лимитов», то есть каждая новая ферма была бы вечным безлимитным
      // клиентом. Если дефолтный тариф ещё не заведён через админку —
      // ферма остаётся без плана, как и раньше.
      const defaultPlan = await planService.getDefault();

      const farm = await Farm.create({
        name: (userData.farm_name || '').trim() || `Ферма ${userData.full_name}`,
        owner_id: null,
        plan_id: defaultPlan ? defaultPlan.id : null
      }, { transaction });

      const user = await User.create({
        email: userData.email || null,
        full_name: userData.full_name,
        phone: userData.phone || null,
        role: 'owner',
        farm_id: farm.id
      }, { transaction });

      await farm.update({ owner_id: user.id }, { transaction });
      await transaction.commit();

      logger.info('Farm registered, awaiting login code', { userId: user.id, farmId: farm.id });

      // Сессию регистрация не открывает: пароля в сервисе нет, и войти можно
      // только кодом на названный контакт. Так и подтверждается, что номер
      // (он же логин, он же глобально уникальный) принадлежит тому, кто его
      // вписал, — иначе чужой номер можно было бы занять навсегда.
      //
      // Отправка идёт после коммита: код ищет уже существующего
      // пользователя, а внутри транзакции его ещё не видно.
      // eslint-disable-next-line global-require
      const otpAuthService = require('./otpAuthService');
      try {
        await otpAuthService.requestOtp(
          userData.phone ? { phone: userData.phone } : { email: userData.email }
        );
      } catch (dispatchError) {
        // Ферма уже создана и откату не подлежит — сорванная отправка кода
        // не повод отвечать ошибкой на успешную регистрацию: человек
        // запросит код заново кнопкой «Отправить ещё раз».
        logger.warn('Registration code dispatch failed', {
          userId: user.id,
          error: dispatchError.message
        });
      }

      return {
        user_id: user.id,
        farm_id: farm.id,
        // Клиент по нему решает, что писать на экране кода — «SMS» или
        // «письмо», и не гадает по тому, какое поле он отправлял.
        channel: userData.phone ? 'phone' : 'email'
      };
    } catch (error) {
      if (transaction && !transaction.finished) await transaction.rollback();
      logger.error('Registration error', { error: error.message });
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
      JWTUtil.verifyRefreshToken(refreshToken);

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
        role: tokenRecord.User.role,
        tv: tokenRecord.User.token_version || 0
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
      // `farm` — та же причина, что и в `login`: клиент должен узнать про
      // read_only/suspended сразу при обновлении профиля (в частности, при
      // каждом холодном старте), а не по отказу очередной записи.
      const user = await User.findByPk(userId, {
          include: [{ model: Farm, as: 'farm', attributes: ['id', 'status'] }]
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

      return user.toJSON();
    } catch (error) {
      logger.error('Update profile error', { error: error.message, userId });
      throw error;
    }
  }

  /**
   * Clean expired refresh tokens
   * Should be called periodically (e.g., cron job)
   */
  async cleanExpiredTokens() {
    try {
      const { Op } = require('sequelize');
      const deleted = await RefreshToken.destroy({
        where: {
          expires_at: { [Op.lt]: new Date() }
        }
      });

      // Коды входа живут десять минут, но записи о них остаются дольше: по
      // ним считается «сколько кодов запросили за последние десять минут»
      // (см. `otpAuthService.requestOtp`). Сутки — с запасом на это окно.
      const staleOtpBefore = new Date();
      staleOtpBefore.setDate(staleOtpBefore.getDate() - 1);
      const deletedOtps = await LoginOtp.destroy({
        where: { created_at: { [Op.lt]: staleOtpBefore } }
      });

      logger.info(`Cleaned ${deleted} expired refresh tokens, ${deletedOtps} old login codes`);
      return deleted;
    } catch (error) {
      logger.error('Clean expired tokens error', { error: error.message });
      throw error;
    }
  }
}

module.exports = new AuthService();
