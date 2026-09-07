const deviceTokenService = require('../services/deviceTokenService');
const ApiResponse = require('../utils/apiResponse');

/**
 * Device Token Controller
 * Регистрация и снятие FCM-токенов устройств для push-уведомлений
 */

exports.register = async (req, res, next) => {
  try {
    await deviceTokenService.register(req.farmId, req.user.id, req.body);
    return ApiResponse.success(res, null, 'Устройство зарегистрировано', 201);
  } catch (error) {
    next(error);
  }
};

exports.unregister = async (req, res, next) => {
  try {
    await deviceTokenService.unregister(req.farmId, req.body.token);
    return ApiResponse.success(res, null, 'Устройство отвязано');
  } catch (error) {
    next(error);
  }
};
