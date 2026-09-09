const { Farm, User, RefreshToken, TokenBlacklist, PasswordResetToken } = require('../models');
const PasswordUtil = require('../utils/password');
const JWTUtil = require('../utils/jwt');
const logger = require('../utils/logger');
const { generateOtp, hashOtp } = require('../utils/otp');
const payomSmsTransport = require('./notifications/payomSmsTransport');
const emailTransport = require('./notifications/emailTransport');
const planService = require('./planService');

const RESET_CODE_TTL_MINUTES = 15;
const RESET_CODE_MAX_ATTEMPTS = 5;

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
      // много. Раньше владельцем становился только самый первый
      // зарегистрировавшийся, а всем следующим доставалась роль работника
      // без фермы: пустой экран и ни одной доступной кнопки.
      //
      // Работника заводит не регистрация, а приглашение по коду
      // (`staffService.acceptInvitation`): там человек получает `farm_id`
      // фермы, которая его позвала.
      //
      // Флаг остаётся выключателем: `ALLOW_REGISTRATION=false` закрывает
      // публичную регистрацию, когда стенд не должен принимать посторонних.
      if (process.env.ALLOW_REGISTRATION === 'false') {
        throw new Error('REGISTRATION_CLOSED');
      }

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
        email: userData.email,
        password_hash: passwordHash,
        full_name: userData.full_name,
        phone: userData.phone || null,
        role: 'owner',
        farm_id: farm.id
      }, { transaction });

      await farm.update({ owner_id: user.id }, { transaction });

      // Generate tokens
      const accessToken = JWTUtil.generateAccessToken({ id: user.id, email: user.email, role: user.role, tv: user.token_version || 0 });
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
      logger.info('User registered successfully', { userId: user.id, email: user.email, farmId: farm.id });

      // Remove password hash from response
      const userResponse = user.toJSON();
      // Свежая ферма создаётся без `include`, поэтому статус (см. `login`/
      // `getProfile`, откуда мобильный клиент узнаёт про read_only/suspended)
      // приходится проставить руками — здесь он всегда `active`.
      userResponse.farm = { id: farm.id, status: farm.status };

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
      // `farm` — чтобы мобильный клиент сразу знал про read_only/suspended
      // (см. `middleware/auth.js`), а не узнавал об этом только по отказу
      // первой же попытки что-то записать.
      const user = await User.findOne({
        where: { email },
        include: [{ model: Farm, as: 'farm', attributes: ['id', 'status'] }]
      });

      // Порядок проверок важен. Раньше отключённый аккаунт отвечал отдельным
      // 403 ещё до сверки пароля, то есть любой желающий мог узнать, какие
      // адреса заведены на ферме. Теперь про отключение узнаёт только тот,
      // кто уже назвал верный пароль, а для неизвестного адреса тратится
      // столько же времени, сколько на настоящую проверку.
      if (!user) {
        await PasswordUtil.fakeCompare(password);
        throw new Error('INVALID_CREDENTIALS');
      }

      const isPasswordValid = await PasswordUtil.compare(password, user.password_hash);
      if (!isPasswordValid) {
        throw new Error('INVALID_CREDENTIALS');
      }

      if (!user.is_active) {
        throw new Error('USER_INACTIVE');
      }

      // Generate tokens
      const accessToken = JWTUtil.generateAccessToken({ id: user.id, email: user.email, role: user.role, tv: user.token_version || 0 });
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
        attributes: { exclude: ['password_hash'] },
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

      // Отметка времени отзывает и уже выданные access-токены: без неё они
      // жили бы до конца своего срока, хотя пользователю сказано
      // «войдите заново».
      await user.update({
        password_hash: newPasswordHash,
        token_version: (user.token_version || 0) + 1
      }, { transaction });

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
   * Запросить сброс пароля — код на телефон (если есть) или на email.
   * Всегда отвечает успехом, даже если аккаунта нет: иначе по ответу можно
   * было бы угадывать существующие email (энумерация).
   * @param {String} email - User email
   */
  async forgotPassword(email) {
    try {
      const user = await User.findOne({ where: { email } });
      if (!user || !user.is_active) {
        return { success: true };
      }

      // Предыдущий код этого пользователя больше не должен работать —
      // активным остаётся только последний запрошенный.
      await PasswordResetToken.destroy({ where: { user_id: user.id } });

      const code = generateOtp();
      const tokenHash = hashOtp(code);
      const channel = user.phone ? 'sms' : 'email';

      const expiresAt = new Date();
      expiresAt.setMinutes(expiresAt.getMinutes() + RESET_CODE_TTL_MINUTES);

      await PasswordResetToken.create({
        user_id: user.id,
        token_hash: tokenHash,
        channel,
        expires_at: expiresAt
      });

      logger.info('Password reset code created', { userId: user.id, channel });

      // Доставка — best-effort: не настроено или упало на стороне шлюза —
      // логируем и продолжаем, не проваливая запрос (и не выдавая тем самым,
      // что аккаунт существует, а канал недоступен).
      try {
        if (channel === 'sms') {
          await payomSmsTransport.sendTemplateSms({
            templateKey: 'user.verification_code',
            telephone: user.phone,
            variables: { 'text-1': 'RabbitFarm', 'code-1': code }
          });
        } else {
          await emailTransport.sendPasswordResetEmail({ to: user.email, code });
        }
      } catch (dispatchError) {
        logger.warn('Password reset dispatch failed', {
          channel,
          userId: user.id,
          error: dispatchError.message
        });
      }

      return { success: true };
    } catch (error) {
      logger.error('Forgot password error', { error: error.message, email });
      throw error;
    }
  }

  /**
   * Сбросить пароль по коду, присланному forgotPassword.
   * @param {Object} params
   * @param {String} params.email
   * @param {String} params.code - 6-значный код
   * @param {String} params.newPassword
   */
  async resetPassword({ email, code, newPassword }) {
    const transaction = await User.sequelize.transaction();
    try {
      const user = await User.findOne({ where: { email }, transaction });
      if (!user) {
        throw new Error('INVALID_RESET_CODE');
      }

      // Код короткий (6 цифр) и не гарантирует глобальную уникальность хэша,
      // в отличие от прежнего 32-байтного токена — ищем в пределах
      // конкретного пользователя, а не по одному хэшу по всей таблице.
      const resetRecord = await PasswordResetToken.findOne({
        where: { user_id: user.id },
        transaction
      });

      if (!resetRecord) {
        throw new Error('INVALID_RESET_CODE');
      }

      // Эти три ветки завершаются ошибкой, а значит внешний catch откатит
      // `transaction` — если снос/инкремент попадёт в неё же, откат вернёт
      // всё как было. Поэтому здесь они выполняются вне транзакции: должны
      // пережить неудачную попытку, а не отмениться вместе с ней.
      if (resetRecord.attempts >= RESET_CODE_MAX_ATTEMPTS) {
        await resetRecord.destroy();
        throw new Error('RESET_CODE_LOCKED');
      }

      if (new Date() > resetRecord.expires_at) {
        await resetRecord.destroy();
        throw new Error('RESET_CODE_EXPIRED');
      }

      if (hashOtp(code) !== resetRecord.token_hash) {
        await resetRecord.increment('attempts');
        throw new Error('INVALID_RESET_CODE');
      }

      if (!user.is_active) {
        throw new Error('USER_INACTIVE');
      }

      const newPasswordHash = await PasswordUtil.hash(newPassword);

      await User.update(
        { password_hash: newPasswordHash, token_version: (user.token_version || 0) + 1 },
        { where: { id: user.id }, transaction }
      );

      // Delete used token
      await resetRecord.destroy({ transaction });

      // Invalidate all refresh tokens (force re-login)
      await RefreshToken.destroy({ where: { user_id: user.id }, transaction });

      await transaction.commit();
      logger.info('Password reset successfully', { userId: user.id });

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
