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
    const field = err.errors?.[0]?.path;
    // Имя колонки пользователю ни о чём не говорит — отдаём его в details,
    // а сообщение держим на языке остальных ответов API.
    return ApiResponse.conflict(
      res,
      'Такая запись уже существует',
      'CONFLICT',
      field ? [{ field, message: 'Значение должно быть уникальным' }] : null
    );
  }

  // Sequelize foreign key constraint error
  if (err.name === 'SequelizeForeignKeyConstraintError') {
    return ApiResponse.badRequest(res, 'Ссылка на связанную запись недействительна');
  }

  // JWT errors
  if (err.name === 'JsonWebTokenError') {
    return ApiResponse.unauthorized(res, 'Недействительный токен');
  }

  if (err.name === 'TokenExpiredError') {
    return ApiResponse.unauthorized(res, 'Срок действия токена истёк');
  }

  // Multer errors (file upload)
  if (err.name === 'MulterError') {
    if (err.code === 'LIMIT_FILE_SIZE') {
      return ApiResponse.badRequest(res, 'Файл слишком большой');
    }
    // Текст multer-ошибки английский и технический; подробности уже в логе.
    return ApiResponse.badRequest(res, 'Не удалось загрузить файл');
  }

  // Custom application errors
  if (err.statusCode) {
    return ApiResponse.error(res, err.message, err.statusCode, err.code);
  }

  // Default server error
  return ApiResponse.serverError(res,
    process.env.NODE_ENV === 'development' ? err.message : 'Внутренняя ошибка сервера'
  );
};

/**
 * 404 Not Found handler
 */
const notFoundHandler = (req, res, next) => {
  ApiResponse.notFound(res, `Маршрут ${req.originalUrl} не найден`);
};

module.exports = {
  errorHandler,
  notFoundHandler
};
