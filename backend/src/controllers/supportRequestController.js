const supportRequestService = require('../services/supportRequestService');
const ApiResponse = require('../utils/apiResponse');

/**
 * Обращение фермы в поддержку. Читает их платформенный админ — см.
 * `platformAdminController.listSupportRequests`.
 */

exports.create = async (req, res, next) => {
  try {
    const created = await supportRequestService.create({
      farmId: req.farmId,
      userId: req.user.id,
      text: req.body.text
    });
    return ApiResponse.created(res, created, 'Обращение отправлено');
  } catch (error) {
    next(error);
  }
};
