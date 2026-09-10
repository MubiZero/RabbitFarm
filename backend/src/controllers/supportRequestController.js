const supportRequestService = require('../services/supportRequestService');
const supportContactService = require('../services/supportContactService');
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

/**
 * Официальный email/телефон поддержки, если платформенный админ их задал —
 * рядом с внутренней фичей «Обращения», не вместо неё.
 */
exports.getContact = async (req, res, next) => {
  try {
    const contact = await supportContactService.get();
    return ApiResponse.success(res, { email: contact.email, phone: contact.phone }, 'Контакт поддержки получен');
  } catch (error) {
    next(error);
  }
};
