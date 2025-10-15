const logger = require('../utils/logger');
const ApiResponse = require('../utils/apiResponse');

/**
 * Global error handling middleware
 */
const errorHandler = (err, req, res, next) => {
  // Log error
  logger.error('Error occurred', {
    error: err.message,
    stack: err.stack,
    path: req.path,
    method: req.method,
    ip: req.ip,
    userId: req.user?.id
  });

  // Sequelize validation error
  if (err.name === 'SequelizeValidationError') {
    const details = err.errors.map(e => ({
      field: e.path,
      message: e.message
    }));
    return ApiResponse.validationError(res, details);
  }

  // Sequelize unique constraint error
  if (err.name === 'SequelizeUniqueConstraintError') {
    const field = err.errors[0]?.path;
    return ApiResponse.badRequest(res, `${field} already exists`);
  }

  // Sequelize foreign key constraint error
  if (err.name === 'SequelizeForeignKeyConstraintError') {
    return ApiResponse.badRequest(res, 'Invalid reference to related resource');
  }

  // JWT errors
  if (err.name === 'JsonWebTokenError') {
    return ApiResponse.unauthorized(res, 'Invalid token');
  }

  if (err.name === 'TokenExpiredError') {
    return ApiResponse.unauthorized(res, 'Token expired');
  }

  // Multer errors (file upload)
  if (err.name === 'MulterError') {
    if (err.code === 'LIMIT_FILE_SIZE') {
      return ApiResponse.badRequest(res, 'File too large');
    }
    return ApiResponse.badRequest(res, err.message);
  }

  // Custom application errors
  if (err.statusCode) {
    return ApiResponse.error(res, err.message, err.statusCode, err.code);
  }

  // Default server error
  return ApiResponse.serverError(res,
    process.env.NODE_ENV === 'development' ? err.message : 'Internal server error'
  );
};

/**
 * 404 Not Found handler
 */
const notFoundHandler = (req, res, next) => {
  ApiResponse.notFound(res, `Route ${req.originalUrl} not found`);
};

module.exports = {
  errorHandler,
  notFoundHandler
};
