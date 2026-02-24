const feedService = require('../services/feedService');
const ApiResponse = require('../utils/apiResponse');

/**
 * Feed Controller
 * Управление кормами на складе
 */

exports.create = async (req, res, next) => {
  try {
    const feed = await feedService.createFeed({ ...req.body, user_id: req.user.id });
    return ApiResponse.success(res, feed, 'Корм успешно добавлен', 201);
  } catch (error) {
    next(error);
  }
};

exports.getById = async (req, res, next) => {
  try {
    const feed = await feedService.getFeedById(req.params.id, req.user.id);
    return ApiResponse.success(res, feed);
  } catch (error) {
    if (error.message === 'FEED_NOT_FOUND') return ApiResponse.error(res, 'Корм не найден', 404);
    next(error);
  }
};

exports.list = async (req, res, next) => {
  try {
    const result = await feedService.listFeeds(req.user.id, req.query);
    return ApiResponse.success(res, result);
  } catch (error) {
    next(error);
  }
};

exports.update = async (req, res, next) => {
  try {
    const feed = await feedService.updateFeed(req.params.id, req.user.id, req.body);
    return ApiResponse.success(res, feed, 'Корм успешно обновлен');
  } catch (error) {
    if (error.message === 'FEED_NOT_FOUND') return ApiResponse.error(res, 'Корм не найден', 404);
    next(error);
  }
};

exports.delete = async (req, res, next) => {
  try {
    const result = await feedService.deleteFeed(req.params.id, req.user.id);
    return ApiResponse.success(res, null, 'Корм успешно удален');
  } catch (error) {
    if (error.message === 'FEED_NOT_FOUND') return ApiResponse.error(res, 'Корм не найден', 404);
    if (error.message === 'FEED_HAS_RECORDS') {
      return ApiResponse.error(res, 'Нельзя удалить корм, так как он используется в записях кормления', 400);
    }
    next(error);
  }
};

exports.getStatistics = async (req, res, next) => {
  try {
    const stats = await feedService.getStatistics(req.user.id);
    return ApiResponse.success(res, stats);
  } catch (error) {
    next(error);
  }
};

exports.getLowStock = async (req, res, next) => {
  try {
    const feeds = await feedService.getLowStock(req.user.id);
    return ApiResponse.success(res, feeds);
  } catch (error) {
    next(error);
  }
};

exports.adjustStock = async (req, res, next) => {
  try {
    const { quantity, operation } = req.body;
    const feed = await feedService.adjustStock(req.params.id, req.user.id, quantity, operation);
    return ApiResponse.success(res, feed, `Остаток успешно ${operation === 'add' ? 'пополнен' : 'списан'}`);
  } catch (error) {
    if (error.message === 'FEED_NOT_FOUND') return ApiResponse.error(res, 'Корм не найден', 404);
    if (error.message === 'INSUFFICIENT_STOCK') return ApiResponse.error(res, 'Недостаточно корма на складе', 400);
    if (error.message === 'INVALID_OPERATION') return ApiResponse.error(res, 'Некорректная операция. Используйте "add" или "subtract"', 400);
    next(error);
  }
};

module.exports = exports;
