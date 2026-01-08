const { FeedingRecord, Feed, Rabbit, Cage, User } = require('../models');
const ApiResponse = require('../utils/apiResponse');
const { Op } = require('sequelize');

/**
 * Feeding Record Controller
 * Управление записями кормления
 */

/**
 * Create new feeding record
 */
exports.create = async (req, res, next) => {
  try {
    const { feed_id, quantity, rabbit_id, cage_id } = req.body;
    const fed_by = req.user.id;

    // Validate rabbit_id if provided
    if (rabbit_id) {
      const rabbit = await Rabbit.findOne({
        where: { id: rabbit_id, user_id: req.user.id }
      });
      if (!rabbit) {
        return ApiResponse.error(res, 'Кролик не найден', 404);
      }
    }

    // Validate cage_id if provided
    if (cage_id) {
      const cage = await Cage.findOne({
        where: { id: cage_id, user_id: req.user.id }
      });
      if (!cage) {
        return ApiResponse.error(res, 'Клетка не найдена', 404);
      }
    }

    // Check if feed exists and has enough stock and belongs to user
    const feed = await Feed.findOne({
      where: { id: feed_id, user_id: req.user.id }
    });
    if (!feed) {
      return ApiResponse.error(res, 'Корм не найден', 404);
    }

    const currentStock = parseFloat(feed.current_stock);
    const quantityNeeded = parseFloat(quantity);

    if (currentStock < quantityNeeded) {
      return ApiResponse.error(
        res,
        `Недостаточно корма на складе. Доступно: ${currentStock} ${feed.unit}`,
        400
      );
    }

    // Create feeding record
    const feedingRecord = await FeedingRecord.create({
      ...req.body,
      fed_by
    });

    // Deduct from feed stock
    await feed.update({
      current_stock: currentStock - quantityNeeded
    });

    // Load relationships with safety filters
    await feedingRecord.reload({
      include: [
        { model: Feed, as: 'feed', where: { user_id: req.user.id }, required: false },
        { model: Rabbit, as: 'rabbit', where: { user_id: req.user.id }, required: false },
        { model: Cage, as: 'cage', where: { user_id: req.user.id }, required: false },
        { model: User, as: 'fedBy', attributes: ['id', 'full_name', 'email'] }
      ]
    });

    return ApiResponse.success(res, feedingRecord, 'Запись о кормлении создана', 201);
  } catch (error) {
    next(error);
  }
};

/**
 * Get feeding record by ID
 */
exports.getById = async (req, res, next) => {
  try {
    const { id } = req.params;

    const feedingRecord = await FeedingRecord.findOne({
      where: {
        id,
        fed_by: req.user.id // Verify ownership
      },
      include: [
        { model: Feed, as: 'feed' },
        { model: Rabbit, as: 'rabbit' },
        { model: Cage, as: 'cage' },
        { model: User, as: 'fedBy', attributes: ['id', 'full_name', 'email'] }
      ]
    });

    if (!feedingRecord) {
      return ApiResponse.error(res, 'Запись о кормлении не найдена', 404);
    }

    return ApiResponse.success(res, feedingRecord);
  } catch (error) {
    next(error);
  }
};

/**
 * Get list of feeding records with filters
 */
exports.list = async (req, res, next) => {
  try {
    const {
      page = 1,
      limit = 50,
      sort_by = 'fed_at',
      sort_order = 'DESC',
      rabbit_id,
      feed_id,
      cage_id,
      from_date,
      to_date
    } = req.query;

    const offset = (page - 1) * limit;
    const where = {
      fed_by: req.user.id // Filter by user
    };

    // Filter by rabbit
    if (rabbit_id) {
      where.rabbit_id = rabbit_id;
    }

    // Filter by feed
    if (feed_id) {
      where.feed_id = feed_id;
    }

    // Filter by cage
    if (cage_id) {
      where.cage_id = cage_id;
    }

    // Filter by date range
    if (from_date || to_date) {
      where.fed_at = {};
      if (from_date) {
        where.fed_at[Op.gte] = new Date(from_date);
      }
      if (to_date) {
        where.fed_at[Op.lte] = new Date(to_date);
      }
    }

    const { rows, count } = await FeedingRecord.findAndCountAll({
      where,
      include: [
        { model: Feed, as: 'feed' },
        { model: Rabbit, as: 'rabbit' },
        { model: Cage, as: 'cage' },
        { model: User, as: 'fedBy', attributes: ['id', 'full_name', 'email'] }
      ],
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
 * Get feeding records for specific rabbit
 */
exports.getByRabbit = async (req, res, next) => {
  try {
    const { rabbitId } = req.params;

    // Check if rabbit exists and belongs to user
    const rabbit = await Rabbit.findOne({
      where: {
        id: rabbitId,
        user_id: req.user.id
      }
    });
    if (!rabbit) {
      return ApiResponse.error(res, 'Кролик не найден', 404);
    }

    const records = await FeedingRecord.findAll({
      where: { rabbit_id: rabbitId },
      include: [
        { model: Feed, as: 'feed', where: { user_id: req.user.id }, required: false },
        { model: User, as: 'fedBy', attributes: ['id', 'full_name', 'email'] }
      ],
      order: [['fed_at', 'DESC']]
    });

    return ApiResponse.success(res, records);
  } catch (error) {
    next(error);
  }
};

/**
 * Update feeding record
 */
exports.update = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { quantity: newQuantity, feed_id: newFeedId } = req.body;

    const feedingRecord = await FeedingRecord.findOne({
      where: {
        id,
        fed_by: req.user.id // Verify ownership
      }
    });

    if (!feedingRecord) {
      return ApiResponse.error(res, 'Запись о кормлении не найдена', 404);
    }

    const oldQuantity = parseFloat(feedingRecord.quantity);
    const oldFeedId = feedingRecord.feed_id;

    // If quantity or feed changed, adjust stock
    if (newQuantity || newFeedId) {
      const targetFeedId = newFeedId || oldFeedId;
      const targetQuantity = newQuantity ? parseFloat(newQuantity) : oldQuantity;

      // Return stock to old feed
      if (newFeedId && newFeedId !== oldFeedId) {
        const oldFeed = await Feed.findByPk(oldFeedId);
        if (oldFeed) {
          await oldFeed.update({
            current_stock: parseFloat(oldFeed.current_stock) + oldQuantity
          });
        }
      }

      // Deduct from new/same feed
      const targetFeed = await Feed.findOne({
        where: { id: targetFeedId, user_id: req.user.id }
      });
      if (!targetFeed) {
        return ApiResponse.error(res, 'Корм не найден', 404);
      }

      const quantityDiff = targetQuantity - (targetFeedId === oldFeedId ? oldQuantity : 0);
      const newStock = parseFloat(targetFeed.current_stock) - quantityDiff;

      if (newStock < 0) {
        return ApiResponse.error(res, 'Недостаточно корма на складе', 400);
      }

      await targetFeed.update({ current_stock: newStock });
    }

    if (req.body.rabbit_id && req.body.rabbit_id !== feedingRecord.rabbit_id) {
      const rabbit = await Rabbit.findOne({ where: { id: req.body.rabbit_id, user_id: req.user.id } });
      if (!rabbit) return ApiResponse.error(res, 'Кролик не найден', 404);
    }

    if (req.body.cage_id && req.body.cage_id !== feedingRecord.cage_id) {
      const cage = await Cage.findOne({ where: { id: req.body.cage_id, user_id: req.user.id } });
      if (!cage) return ApiResponse.error(res, 'Клетка не найдена', 404);
    }

    await feedingRecord.update(req.body);

    await feedingRecord.reload({
      include: [
        { model: Feed, as: 'feed', where: { user_id: req.user.id }, required: false },
        { model: Rabbit, as: 'rabbit', where: { user_id: req.user.id }, required: false },
        { model: Cage, as: 'cage', where: { user_id: req.user.id }, required: false },
        { model: User, as: 'fedBy', attributes: ['id', 'full_name', 'email'] }
      ]
    });

    return ApiResponse.success(res, feedingRecord, 'Запись о кормлении обновлена');
  } catch (error) {
    next(error);
  }
};

/**
 * Delete feeding record
 */
exports.delete = async (req, res, next) => {
  try {
    const { id } = req.params;

    const feedingRecord = await FeedingRecord.findOne({
      where: {
        id,
        fed_by: req.user.id // Verify ownership
      }
    });

    if (!feedingRecord) {
      return ApiResponse.error(res, 'Запись о кормлении не найдена', 404);
    }

    // Return stock to feed
    const feed = await Feed.findOne({
      where: { id: feedingRecord.feed_id, user_id: req.user.id }
    });
    if (feed) {
      await feed.update({
        current_stock: parseFloat(feed.current_stock) + parseFloat(feedingRecord.quantity)
      });
    }

    await feedingRecord.destroy();

    return ApiResponse.success(res, null, 'Запись о кормлении удалена');
  } catch (error) {
    next(error);
  }
};

/**
 * Get feeding statistics
 */
exports.getStatistics = async (req, res, next) => {
  try {
    const { from_date, to_date } = req.query;

    const where = {
      fed_by: req.user.id // Filter by user
    };
    if (from_date || to_date) {
      where.fed_at = {};
      if (from_date) {
        where.fed_at[Op.gte] = new Date(from_date);
      }
      if (to_date) {
        where.fed_at[Op.lte] = new Date(to_date);
      }
    }

    const records = await FeedingRecord.findAll({
      where,
      include: [{ model: Feed, as: 'feed' }]
    });

    const stats = {
      total_feedings: records.length,
      total_quantity: 0,
      by_feed_type: {
        pellets: 0,
        hay: 0,
        vegetables: 0,
        grain: 0,
        supplements: 0,
        other: 0
      },
      by_feed: {},
      total_cost: 0
    };

    records.forEach(record => {
      const quantity = parseFloat(record.quantity);
      stats.total_quantity += quantity;

      if (record.feed) {
        // Count by feed type
        const type = record.feed.type;
        if (stats.by_feed_type.hasOwnProperty(type)) {
          stats.by_feed_type[type] += quantity;
        }

        // Count by specific feed
        const feedName = record.feed.name;
        if (!stats.by_feed[feedName]) {
          stats.by_feed[feedName] = {
            quantity: 0,
            unit: record.feed.unit,
            cost: 0
          };
        }
        stats.by_feed[feedName].quantity += quantity;

        // Calculate cost
        if (record.feed.cost_per_unit) {
          const cost = quantity * parseFloat(record.feed.cost_per_unit);
          stats.by_feed[feedName].cost += cost;
          stats.total_cost += cost;
        }
      }
    });

    return ApiResponse.success(res, stats);
  } catch (error) {
    next(error);
  }
};

/**
 * Get recent feedings
 */
exports.getRecent = async (req, res, next) => {
  try {
    const { limit = 10 } = req.query;

    const records = await FeedingRecord.findAll({
      where: {
        fed_by: req.user.id // Filter by user
      },
      include: [
        { model: Feed, as: 'feed' },
        { model: Rabbit, as: 'rabbit' },
        { model: Cage, as: 'cage' },
        { model: User, as: 'fedBy', attributes: ['id', 'full_name', 'email'] }
      ],
      limit: parseInt(limit),
      order: [['fed_at', 'DESC']]
    });

    return ApiResponse.success(res, records);
  } catch (error) {
    next(error);
  }
};

module.exports = exports;
