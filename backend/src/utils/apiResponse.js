/**
 * Standardized API response utilities
 */

class ApiResponse {
  /**
   * Success response
   * @param {Object} res - Express response object
   * @param {*} data - Response data
   * @param {String} message - Success message
   * @param {Number} statusCode - HTTP status code
   */
  static success(res, data = null, message = 'Успешно', statusCode = 200) {
    return res.status(statusCode).json({
      success: true,
      data,
      message,
      timestamp: new Date().toISOString()
    });
  }

  /**
   * Error response
   * @param {Object} res - Express response object
   * @param {String} message - Error message
   * @param {Number} statusCode - HTTP status code
   * @param {String} code - Error code
   * @param {Array} details - Error details
   */
  static error(res, message = 'Ошибка', statusCode = 500, code = 'SERVER_ERROR', details = null) {
    const response = {
      success: false,
      error: {
        code,
        message
      },
      timestamp: new Date().toISOString()
    };

    if (details) {
      response.error.details = details;
    }

    return res.status(statusCode).json(response);
  }

  /**
   * Paginated response
   * @param {Object} res - Express response object
   * @param {Array} items - Array of items
   * @param {Number} page - Current page
   * @param {Number} limit - Items per page
   * @param {Number} total - Total items count
   * @param {String} message - Success message
   */
  static paginated(res, items, page, limit, total, message = 'Успешно') {
    // Значения по умолчанию, чтобы в ответ не утекали NaN, если вызывающий
    // не передал страницу или размер: клиент по ним считает «показать ещё».
    const safePage = parseInt(page) || 1;
    const safeTotal = parseInt(total) || 0;
    const safeLimit = parseInt(limit) || items.length || safeTotal || 1;

    return res.status(200).json({
      success: true,
      data: {
        items,
        pagination: {
          page: safePage,
          limit: safeLimit,
          total: safeTotal,
          totalPages: Math.ceil(safeTotal / safeLimit)
        }
      },
      message,
      timestamp: new Date().toISOString()
    });
  }

  /**
   * Created response (201)
   */
  static created(res, data = null, message = 'Запись создана') {
    return this.success(res, data, message, 201);
  }

  /**
   * No content response (204)
   */
  static noContent(res) {
    return res.status(204).send();
  }

  /**
   * Bad request response (400)
   * @param {String} code - машинный код, когда клиенту важно отличить случай
   *   (например `RABBIT_LIMIT_REACHED`) — по умолчанию общий `BAD_REQUEST`
   */
  static badRequest(res, message = 'Неверный запрос', code = 'BAD_REQUEST', details = null) {
    return this.error(res, message, 400, code, details);
  }

  /**
   * Unauthorized response (401)
   */
  static unauthorized(res, message = 'Не авторизован') {
    return this.error(res, message, 401, 'UNAUTHORIZED');
  }

  /**
   * Forbidden response (403)
   */
  static forbidden(res, message = 'Доступ запрещён') {
    return this.error(res, message, 403, 'FORBIDDEN');
  }

  /**
   * Not found response (404)
   */
  static notFound(res, message = 'Запись не найдена') {
    return this.error(res, message, 404, 'NOT_FOUND');
  }

  /**
   * Conflict response (409) — нарушение уникальности: сущность уже существует.
   * @param {String} code - уточняющий код, когда клиенту важно отличить случай
   */
  static conflict(res, message = 'Такая запись уже существует', code = 'CONFLICT', details = null) {
    return this.error(res, message, 409, code, details);
  }

  /**
   * Validation error response (422)
   */
  static validationError(res, details, message = 'Проверка данных не пройдена') {
    return this.error(res, message, 422, 'VALIDATION_ERROR', details);
  }

  /**
   * Internal server error response (500)
   */
  static serverError(res, message = 'Внутренняя ошибка сервера') {
    return this.error(res, message, 500, 'SERVER_ERROR');
  }
}

module.exports = ApiResponse;
