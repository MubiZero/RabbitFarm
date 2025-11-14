const { Feed, FeedingRecord } = require('../models');
const ApiResponse = require('../utils/apiResponse');
const { Op } = require('sequelize');

/**
 * Feed Controller
 * Управление кормами на складе
 */

/**
 * Create new feed
 */
exports.create = async (req, res, next) => {
  try {
    const feed = await Feed.create(req.body);

    return ApiResponse.success(res, feed, 'Корм успешно добавлен', 201);
  } catch (error) {
    next(error);
  }
};

/**
 * Get feed by ID
 */
exports.getById = async (req, res, next) => {
  try {
    const { id } = req.params;

    const feed = await Feed.findByPk(id);

    if (!feed) {
      return ApiResponse.error(res, 'Корм не найден', 404);
    }

    return ApiResponse.success(res, feed);
  } catch (error) {
    next(error);
  }
};

/**
 * Get list of feeds with filters
 */
exports.list = async (req, res, next) => {
  try {
    const {
      page = 1,
      limit = 50,
      sort_by = 'name',
      sort_order = 'ASC',
      type,
      low_stock, // Только с низким запасом
      search
    } = req.query;

    const offset = (page - 1) * limit;
    const where = {};

    // Filter by type
    if (type) {
      where.type = type;
    }

    // Filter by low stock
    if (low_stock === 'true') {
      where[Op.and] = [
        { current_stock: { [Op.lte]: require('sequelize').col('min_stock') } }
      ];
    }

    // Search by name or brand
    if (search) {
      where[Op.or] = [
        { name: { [Op.like]: `%${search}%` } },
        { brand: { [Op.like]: `%${search}%` } }
      ];
    }

    const { rows, count } = await Feed.findAndCountAll({
      where,
      limit: parseInt(limit),
      offset,
      order: [[sort_by, sort_order.toUpperCase()]]
    });

    return ApiResponse.success(res, {
      rows,
      pagination: {
        total: count,
        page: parseInt(page),
        limit: parseInt(limit),
        pages: Math.ceil(count / limit)
      }
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Update feed
 */
exports.update = async (req, res, next) => {
  try {
    const { id } = req.params;

    const feed = await Feed.findByPk(id);

    if (!feed) {
      return ApiResponse.error(res, 'Корм не найден', 404);
    }

    await feed.update(req.body);

    return ApiResponse.success(res, feed, 'Корм успешно обновлен');
  } catch (error) {
    next(error);
  }
};

/**
 * Delete feed
 */
exports.delete = async (req, res, next) => {
  try {
    const { id } = req.params;

    const feed = await Feed.findByPk(id);

    if (!feed) {
      return ApiResponse.error(res, 'Корм не найден', 404);
    }

    // Check if feed is used in feeding records
    const recordsCount = await FeedingRecord.count({
      where: { feed_id: id }
    });

    if (recordsCount > 0) {
      return ApiResponse.error(
        res,
        `Нельзя удалить корм, так как он используется в ${recordsCount} записях кормления`,
        400
      );
    }

    await feed.destroy();

    return ApiResponse.success(res, null, 'Корм успешно удален');
  } catch (error) {
    next(error);
  }
};

/**
 * Get feeds statistics
 */
exports.getStatistics = async (req, res, next) => {
  try {
    const feeds = await Feed.findAll();

    const stats = {
      total_feeds: feeds.length,
      by_type: {
        pellets: 0,
        hay: 0,
        vegetables: 0,
        grain: 0,
        supplements: 0,
        other: 0
      },
      low_stock_count: 0,
      low_stock_items: [],
      total_stock_value: 0
    };

    feeds.forEach(feed => {
      // Count by type
      if (stats.by_type.hasOwnProperty(feed.type)) {
        stats.by_type[feed.type]++;
      }

      // Check low stock
      if (parseFloat(feed.current_stock) <= parseFloat(feed.min_stock)) {
        stats.low_stock_count++;
        stats.low_stock_items.push({
          id: feed.id,
          name: feed.name,
          current_stock: parseFloat(feed.current_stock),
          min_stock: parseFloat(feed.min_stock),
          unit: feed.unit
        });
      }

      // Calculate total stock value
      if (feed.cost_per_unit) {
        stats.total_stock_value += parseFloat(feed.current_stock) * parseFloat(feed.cost_per_unit);
      }
    });

    return ApiResponse.success(res, stats);
  } catch (error) {
    next(error);
  }
};

/**
 * Get low stock feeds
 */
exports.getLowStock = async (req, res, next) => {
  try {
    const feeds = await Feed.findAll({
      where: {
        [Op.and]: [
          { current_stock: { [Op.lte]: require('sequelize').col('min_stock') } }
        ]
      },
      order: [
        [require('sequelize').literal('(current_stock / NULLIF(min_stock, 0))'), 'ASC']
      ]
    });

    const lowStockFeeds = feeds.map(feed => ({
      ...feed.toJSON(),
      stock_percentage: feed.min_stock > 0
        ? (parseFloat(feed.current_stock) / parseFloat(feed.min_stock) * 100).toFixed(1)
        : 0
    }));

    return ApiResponse.success(res, lowStockFeeds);
  } catch (error) {
    next(error);
  }
};

/**
 * Adjust feed stock (add or subtract)
 */
exports.adjustStock = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { quantity, operation } = req.body; // operation: 'add' or 'subtract'

    const feed = await Feed.findByPk(id);

    if (!feed) {
      return ApiResponse.error(res, 'Корм не найден', 404);
    }

    const currentStock = parseFloat(feed.current_stock);
    const adjustment = parseFloat(quantity);

    let newStock;
    if (operation === 'add') {
      newStock = currentStock + adjustment;
    } else if (operation === 'subtract') {
      newStock = currentStock - adjustment;
      if (newStock < 0) {
        return ApiResponse.error(res, 'Недостаточно корма на складе', 400);
      }
    } else {
      return ApiResponse.error(res, 'Некорректная операция. Используйте "add" или "subtract"', 400);
    }

    await feed.update({ current_stock: newStock });

    return ApiResponse.success(res, feed, `Остаток успешно ${operation === 'add' ? 'пополнен' : 'списан'}`);
  } catch (error) {
    next(error);
  }
};

module.exports = exports;
