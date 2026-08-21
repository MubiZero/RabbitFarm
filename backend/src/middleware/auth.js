const JWTUtil = require('../utils/jwt');
const ApiResponse = require('../utils/apiResponse');
const { User, TokenBlacklist } = require('../models');

/**
 * Authentication middleware
 * Verifies JWT token and attaches user to request
 */
const authenticate = async (req, res, next) => {
  try {
    // Get token from header
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return ApiResponse.unauthorized(res, 'Токен не передан');
    }

    const token = authHeader.substring(7); // Remove 'Bearer ' prefix

    // Verify token
    const decoded = JWTUtil.verifyAccessToken(token);

    // Check if token is blacklisted
    if (decoded.jti) {
      const blacklisted = await TokenBlacklist.findOne({ where: { jti: decoded.jti } });
      if (blacklisted) {
        return ApiResponse.unauthorized(res, 'Токен отозван');
      }
    }

    // Get user from database
    const user = await User.findByPk(decoded.id, {
      attributes: { exclude: ['password_hash'] }
    });

    if (!user) {
      return ApiResponse.unauthorized(res, 'Пользователь не найден');
    }

    if (!user.is_active) {
      return ApiResponse.forbidden(res, 'Аккаунт отключён. Обратитесь к владельцу фермы.');
    }

    // Attach user to request
    req.user = user;
    // Ферма запроса: у работника это ферма его владельца, у владельца — он сам.
    // Данные разделены по этому идентификатору, поэтому работник видит
    // хозяйство владельца, а не собственное пустое.
    req.farmId = user.owner_id || user.id;
    next();
  } catch (error) {
    if (error.message.includes('token')) {
      return ApiResponse.unauthorized(res, error.message);
    }
    next(error);
  }
};

/**
 * Authorization middleware
 * Checks if user has required role
 * @param {Array<String>} allowedRoles - Array of allowed roles
 */
const authorize = (allowedRoles = []) => {
  return (req, res, next) => {
    if (!req.user) {
      return ApiResponse.unauthorized(res, 'Требуется авторизация');
    }

    // Owner has access to everything
    if (req.user.role === 'owner') {
      return next();
    }

    // Check if user's role is in allowed roles
    if (!allowedRoles.includes(req.user.role)) {
      return ApiResponse.forbidden(res, 'Недостаточно прав');
    }

    next();
  };
};

/**
 * Optional authentication
 * Attaches user if token is valid, but doesn't require it
 */
const optionalAuth = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;

    if (authHeader && authHeader.startsWith('Bearer ')) {
      const token = authHeader.substring(7);
      const decoded = JWTUtil.verifyAccessToken(token);
      const user = await User.findByPk(decoded.id, {
        attributes: { exclude: ['password_hash'] }
      });

      if (user && user.is_active) {
        req.user = user;
      }
    }
  } catch (error) {
    // Ignore errors for optional auth
  }

  next();
};

module.exports = {
  authenticate,
  authorize,
  optionalAuth
};
