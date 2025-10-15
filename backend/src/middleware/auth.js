const JWTUtil = require('../utils/jwt');
const ApiResponse = require('../utils/apiResponse');
const { User } = require('../models');

/**
 * Authentication middleware
 * Verifies JWT token and attaches user to request
 */
const authenticate = async (req, res, next) => {
  try {
    // Get token from header
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return ApiResponse.unauthorized(res, 'No token provided');
    }

    const token = authHeader.substring(7); // Remove 'Bearer ' prefix

    // Verify token
    const decoded = JWTUtil.verifyAccessToken(token);

    // Get user from database
    const user = await User.findByPk(decoded.id, {
      attributes: { exclude: ['password_hash'] }
    });

    if (!user) {
      return ApiResponse.unauthorized(res, 'User not found');
    }

    if (!user.is_active) {
      return ApiResponse.forbidden(res, 'Account is inactive');
    }

    // Attach user to request
    req.user = user;
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
      return ApiResponse.unauthorized(res, 'Authentication required');
    }

    // Owner has access to everything
    if (req.user.role === 'owner') {
      return next();
    }

    // Check if user's role is in allowed roles
    if (!allowedRoles.includes(req.user.role)) {
      return ApiResponse.forbidden(res, 'Insufficient permissions');
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
