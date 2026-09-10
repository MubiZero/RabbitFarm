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

      return ApiResponse.created(res, result, 'Пользователь успешно зарегистрирован');
    } catch (error) {
      if (error.message === 'REGISTRATION_CLOSED') {
        return ApiResponse.forbidden(
          res,
          'Регистрация закрыта. Учётную запись выдаёт владелец фермы.'
        );
      }
      if (error.message === 'USER_EXISTS' || error.name === 'SequelizeUniqueConstraintError') {
        return ApiResponse.conflict(res, 'Пользователь с таким email уже существует', 'USER_EXISTS');
      }
      if (error.message === 'PHONE_EXISTS') {
        return ApiResponse.conflict(res, 'Пользователь с таким телефоном уже существует', 'PHONE_EXISTS');
      }
      next(error);
    }
  }

  /**
   * Login user
   * POST /api/v1/auth/login
   */
  async login(req, res, next) {
    try {
      const { email, password } = req.body;
      const result = await authService.login(email, password);

      return ApiResponse.success(res, result, 'Вход выполнен успешно');
    } catch (error) {
      if (error.message === 'INVALID_CREDENTIALS') {
        return ApiResponse.unauthorized(res, 'Неверный email или пароль');
      }
      if (error.message === 'USER_INACTIVE') {
        return ApiResponse.forbidden(res, 'Аккаунт отключён. Обратитесь к владельцу фермы.');
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
      next(error);
    }
  }

  /**
   * Forgot password - request reset code (SMS or email)
   * POST /api/v1/auth/forgot-password
   */
  async forgotPassword(req, res, next) {
    try {
      const { email } = req.body;
      await authService.forgotPassword(email);

      // Always return 200 to avoid account enumeration
      return ApiResponse.success(res, null, 'Если аккаунт существует, код отправлен');
    } catch (error) {
      next(error);
    }
  }

  /**
   * Reset password using the code from forgotPassword
   * POST /api/v1/auth/reset-password
   */
  async resetPassword(req, res, next) {
    try {
      const { email, code, new_password: newPassword } = req.body;
      await authService.resetPassword({ email, code, newPassword });

      return ApiResponse.success(res, null, 'Пароль успешно изменен. Пожалуйста, войдите заново.');
    } catch (error) {
      if (error.message === 'INVALID_RESET_CODE') {
        return ApiResponse.badRequest(res, 'Неверный код');
      }
      if (error.message === 'RESET_CODE_EXPIRED') {
        return ApiResponse.badRequest(res, 'Срок действия кода истёк');
      }
      if (error.message === 'RESET_CODE_LOCKED') {
        return ApiResponse.error(res, 'Слишком много попыток — запросите новый код', 429, 'RESET_CODE_LOCKED');
      }
      if (error.message === 'USER_INACTIVE') {
        return ApiResponse.forbidden(res, 'Аккаунт отключён. Обратитесь к владельцу фермы.');
      }
      next(error);
    }
  }

  /**
   * Change password
   * POST /api/v1/auth/change-password
   */
  async changePassword(req, res, next) {
    try {
      const { current_password, new_password } = req.body;
      await authService.changePassword(req.user.id, current_password, new_password);

      return ApiResponse.success(res, null, 'Пароль изменен успешно. Пожалуйста, войдите заново.');
    } catch (error) {
      if (error.message === 'USER_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Пользователь не найден');
      }
      if (error.message === 'INVALID_CURRENT_PASSWORD') {
        return ApiResponse.badRequest(res, 'Неверный текущий пароль');
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
      await otpAuthService.requestOtp(req.body.phone);
      // Всегда 200: по ответу нельзя понять, есть ли аккаунт/приглашение
      // на этот номер — та же логика, что у forgot-password.
      return ApiResponse.success(res, null, 'Если номер известен, код отправлен');
    } catch (error) {
      if (error.message === 'INVALID_PHONE') {
        return ApiResponse.badRequest(res, 'Телефон должен быть таджикским номером: +992XXXXXXXXX', 'INVALID_PHONE');
      }
      if (error.message === 'OTP_RATE_LIMITED') {
        return ApiResponse.error(res, 'Слишком много запросов кода — попробуйте позже', 429, 'OTP_RATE_LIMITED');
      }
      next(error);
    }
  }

  /**
   * Verify a login OTP and issue tokens (creating the user from a pending
   * invitation on first login, if that's what matched the phone)
   * POST /api/v1/auth/otp/verify
   */
  async verifyOtp(req, res, next) {
    try {
      const { phone, code } = req.body;
      const result = await otpAuthService.verifyOtp(phone, code);

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

  /**
   * Set an initial password for an account that only ever logged in via OTP
   * POST /api/v1/auth/set-password
   */
  async setPassword(req, res, next) {
    try {
      await authService.setPassword(req.user.id, req.body.new_password);
      return ApiResponse.success(res, null, 'Пароль установлен. Теперь можно входить им как запасным способом.');
    } catch (error) {
      if (error.message === 'PASSWORD_ALREADY_SET') {
        return ApiResponse.badRequest(res, 'Пароль уже задан — смените его через «Изменить пароль»', 'PASSWORD_ALREADY_SET');
      }
      if (error.message === 'USER_NOT_FOUND') {
        return ApiResponse.notFound(res, 'Пользователь не найден');
      }
      next(error);
    }
  }
}

module.exports = new AuthController();
