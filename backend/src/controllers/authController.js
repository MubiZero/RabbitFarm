const authService = require('../services/authService');
const otpAuthService = require('../services/otpAuthService');
const ApiResponse = require('../utils/apiResponse');

/**
 * Authentication controller
 * Handles HTTP requests for authentication
 */
class AuthController {
  /**
   * Register new user
   * POST /api/v1/auth/register
   */
  async register(req, res, next) {
    try {
      const result = await authService.register(req.body);

      return ApiResponse.created(
        res,
        result,
        result.channel === 'phone'
          ? 'Ферма создана. Код для входа отправлен по SMS.'
          : 'Ферма создана. Код для входа отправлен на почту.'
      );
    } catch (error) {
      if (error.message === 'REGISTRATION_CLOSED') {
        return ApiResponse.forbidden(
          res,
          'Регистрация закрыта. Учётную запись выдаёт владелец фермы.'
        );
      }
      if (error.message === 'USER_EXISTS' || error.name === 'SequelizeUniqueConstraintError') {
        return ApiResponse.conflict(res, 'Пользователь с такой почтой уже существует', 'USER_EXISTS');
      }
      if (error.message === 'PHONE_EXISTS') {
        return ApiResponse.conflict(res, 'Пользователь с таким телефоном уже существует', 'PHONE_EXISTS');
      }
      next(error);
    }
  }

  /**
   * Refresh access token
   * POST /api/v1/auth/refresh
   */
  async refresh(req, res, next) {
    try {
      const { refresh_token } = req.body;
      const result = await authService.refreshAccessToken(refresh_token);

      return ApiResponse.success(res, result, 'Токен обновлен успешно');
    } catch (error) {
      if (error.message === 'INVALID_REFRESH_TOKEN') {
        return ApiResponse.unauthorized(res, 'Неверный refresh token');
      }
      if (error.message === 'REFRESH_TOKEN_EXPIRED') {
        return ApiResponse.unauthorized(res, 'Срок действия refresh-токена истёк');
      }
      if (error.message === 'USER_INACTIVE') {
        return ApiResponse.forbidden(res, 'Аккаунт отключён. Обратитесь к владельцу фермы.');
      }
      next(error);
    }
  }

  /**
   * Logout user
   * POST /api/v1/auth/logout
   */
  async logout(req, res, next) {
    try {
      const { refresh_token } = req.body;
      const authHeader = req.headers.authorization;
      const accessToken = authHeader && authHeader.startsWith('Bearer ')
        ? authHeader.substring(7)
        : null;
      await authService.logout(refresh_token, accessToken);

      return ApiResponse.success(res, null, 'Выход выполнен успешно');
    } catch (error) {
      next(error);
    }
  }

  /**
   * Get current user profile
   * GET /api/v1/auth/me
   */
  async getMe(req, res, next) {
    try {
      const user = await authService.getProfile(req.user.id);

      return ApiResponse.success(res, user);
    } catch (error) {
      if (error.message === 'USER_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Пользователь не найден');
      }
      next(error);
    }
  }

  /**
   * Update user profile
   * PUT /api/v1/auth/profile
   */
  async updateProfile(req, res, next) {
    try {
      const user = await authService.updateProfile(req.user.id, req.body);

      return ApiResponse.success(res, user, 'Профиль обновлен успешно');
    } catch (error) {
      if (error.message === 'USER_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Пользователь не найден');
      }
      if (error.message === 'PHONE_EXISTS') {
        return ApiResponse.conflict(
          res,
          'Этот номер уже занят другой учётной записью',
          'PHONE_EXISTS'
        );
      }
      next(error);
    }
  }

  /**
   * Request a login OTP by phone
   * POST /api/v1/auth/otp/request
   */
  async requestOtp(req, res, next) {
    try {
      const { phone, email } = req.body;
      await otpAuthService.requestOtp({ phone, email });
      // Всегда 200: по ответу нельзя понять, есть ли за этим контактом
      // аккаунт или приглашение.
      return ApiResponse.success(res, null, 'Если контакт известен, код отправлен');
    } catch (error) {
      if (error.message === 'INVALID_PHONE') {
        return ApiResponse.badRequest(res, 'Телефон должен быть таджикским номером: +992XXXXXXXXX', 'INVALID_PHONE');
      }
      if (error.message === 'INVALID_EMAIL') {
        return ApiResponse.badRequest(res, 'Неверный формат почты', 'INVALID_EMAIL');
      }
      if (error.message === 'CONTACT_REQUIRED') {
        return ApiResponse.badRequest(res, 'Укажите телефон или почту', 'CONTACT_REQUIRED');
      }
      if (error.message === 'OTP_RATE_LIMITED') {
        return ApiResponse.error(res, 'Слишком много запросов кода — попробуйте позже', 429, 'OTP_RATE_LIMITED');
      }
      next(error);
    }
  }

  /**
   * Verify a login OTP and issue tokens (creating the user from a pending
   * invitation on first login, if that's what matched the contact)
   * POST /api/v1/auth/otp/verify
   */
  async verifyOtp(req, res, next) {
    try {
      const { phone, email, code } = req.body;
      const result = await otpAuthService.verifyOtp({ phone, email }, code);

      return ApiResponse.success(res, result, 'Вход выполнен успешно');
    } catch (error) {
      if (error.message === 'OTP_INVALID') {
        return ApiResponse.badRequest(res, 'Неверный код', 'OTP_INVALID');
      }
      if (error.message === 'OTP_EXPIRED') {
        return ApiResponse.badRequest(res, 'Срок действия кода истёк', 'OTP_EXPIRED');
      }
      if (error.message === 'OTP_LOCKED') {
        return ApiResponse.error(res, 'Слишком много попыток — запросите новый код', 429, 'OTP_LOCKED');
      }
      if (error.message === 'USER_INACTIVE') {
        return ApiResponse.forbidden(res, 'Аккаунт отключён. Обратитесь к владельцу фермы.');
      }
      if (error.message === 'STAFF_LIMIT_REACHED') {
        return ApiResponse.badRequest(res, 'Достигнут лимит участников по тарифу фермы. Обратитесь к владельцу.', 'STAFF_LIMIT_REACHED');
      }
      next(error);
    }
  }

}

module.exports = new AuthController();
