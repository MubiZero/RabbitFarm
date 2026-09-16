const notificationFeedService = require('../services/notificationFeedService');
const ApiResponse = require('../utils/apiResponse');

/**
 * Лента уведомлений — то, что раньше существовало только в виде пуша.
 *
 * Пуш пропадает со шторки, а до человека, отказавшего в разрешении, не
 * доходит вовсе. Здесь те же сообщения лежат и ждут.
 */

exports.list = async (req, res, next) => {
  try {
    const result = await notificationFeedService.list(
      req.farmId,
      req.user.id,
      req.user.language,
      { page: req.query.page, limit: req.query.limit }
    );

    return ApiResponse.paginated(
      res,
      result.items,
      result.pagination.page,
      result.pagination.limit,
      result.pagination.total,
      'Уведомления получены'
    );
  } catch (error) {
    next(error);
  }
};

exports.unreadCount = async (req, res, next) => {
  try {
    const count = await notificationFeedService.unreadCount(req.farmId, req.user.id);
    return ApiResponse.success(res, { count }, 'Непрочитанные посчитаны');
  } catch (error) {
    next(error);
  }
};

exports.markRead = async (req, res, next) => {
  try {
    const id = req.params.id ? parseInt(req.params.id, 10) : null;
    const updated = await notificationFeedService.markRead(req.farmId, req.user.id, id);
    return ApiResponse.success(res, { updated }, 'Отмечено прочитанным');
  } catch (error) {
    next(error);
  }
};
