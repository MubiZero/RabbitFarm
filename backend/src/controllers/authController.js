const authService = require('../services/authService');
const ApiResponse = require('../utils/apiResponse');
const logger = require('../utils/logger');

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
      if (error.message === 'USER_EXISTS') {
        return ApiResponse.error(res, 'Пользователь с таким email уже существует', 400, 'USER_EXISTS');
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
        return ApiResponse.forbidden(res, 'Аккаунт неактивен');
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
        return ApiResponse.unauthorized(res, 'Refresh token истек');
      }
      if (error.message === 'USER_INACTIVE') {
        return ApiResponse.forbidden(res, 'Аккаунт неактивен');
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
      await authService.logout(refresh_token);

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
}

module.exports = new AuthController();
