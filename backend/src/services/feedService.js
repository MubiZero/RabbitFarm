const { Feed, FeedingRecord } = require('../models');
const { Op, col, literal } = require('sequelize');
const logger = require('../utils/logger');

/**
 * Feed service
 * Business logic for feed/stock management
 */
class FeedService {
  async createFeed(data) {
    try {
      const feed = await Feed.create(data);
      logger.info('Feed created', { feedId: feed.id });
      return feed;
    } catch (error) {
      logger.error('Create feed error', { error: error.message });
      throw error;
    }
  }

  async getFeedById(id, userId) {
    const feed = await Feed.findOne({ where: { id, user_id: userId } });
    if (!feed) throw new Error('FEED_NOT_FOUND');
    return feed;
  }

  async listFeeds(userId, filters = {}, pagination = {}) {
    const {
      page = 1,
      limit = 50,
      sort_by = 'name',
      sort_order = 'ASC',
      type,
      low_stock,
      search
    } = { ...filters, ...pagination };

    const offset = (page - 1) * limit;
    const where = { user_id: userId };

    if (type) where.type = type;
    if (low_stock === 'true') {
      where[Op.and] = [{ current_stock: { [Op.lte]: col('min_stock') } }];
    }
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

    return {
      rows,
      pagination: {
        total: count,
        page: parseInt(page),
        limit: parseInt(limit),
        pages: Math.ceil(count / limit)
      }
    };
  }

  async updateFeed(id, userId, data) {
    const feed = await Feed.findOne({ where: { id, user_id: userId } });
    if (!feed) throw new Error('FEED_NOT_FOUND');
    await feed.update(data);
    logger.info('Feed updated', { feedId: id });
    return feed;
  }

  async deleteFeed(id, userId) {
    const feed = await Feed.findOne({ where: { id, user_id: userId } });
    if (!feed) throw new Error('FEED_NOT_FOUND');

    const recordsCount = await FeedingRecord.count({ where: { feed_id: id } });
    if (recordsCount > 0) throw new Error('FEED_HAS_RECORDS');

    await feed.destroy();
    logger.info('Feed deleted', { feedId: id });
    return { success: true, recordsCount };
  }

  async getStatistics(userId) {
    const feeds = await Feed.findAll({ where: { user_id: userId } });

    const stats = {
      total_feeds: feeds.length,
      by_type: { pellets: 0, hay: 0, vegetables: 0, grain: 0, supplements: 0, other: 0 },
      low_stock_count: 0,
      low_stock_items: [],
      total_stock_value: 0
    };

    feeds.forEach(feed => {
      if (Object.prototype.hasOwnProperty.call(stats.by_type, feed.type)) {
        stats.by_type[feed.type]++;
      }
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
      if (feed.cost_per_unit) {
        stats.total_stock_value += parseFloat(feed.current_stock) * parseFloat(feed.cost_per_unit);
      }
    });

    return stats;
  }

  async getLowStock(userId) {
    const feeds = await Feed.findAll({
      where: {
        user_id: userId,
        [Op.and]: [{ current_stock: { [Op.lte]: col('min_stock') } }]
      },
      order: [[literal('(current_stock / NULLIF(min_stock, 0))'), 'ASC']]
    });

    return feeds.map(feed => ({
      ...feed.toJSON(),
      stock_percentage: feed.min_stock > 0
        ? (parseFloat(feed.current_stock) / parseFloat(feed.min_stock) * 100).toFixed(1)
        : 0
    }));
  }

  async adjustStock(id, userId, quantity, operation) {
    const transaction = await Feed.sequelize.transaction();
    try {
      const feed = await Feed.findOne({
        where: { id, user_id: userId },
        lock: transaction.LOCK.UPDATE,
        transaction
      });

      if (!feed) {
        await transaction.rollback();
        throw new Error('FEED_NOT_FOUND');
      }

      const currentStock = parseFloat(feed.current_stock);
      const adjustment = parseFloat(quantity);

      let newStock;
      if (operation === 'add') {
        newStock = currentStock + adjustment;
      } else if (operation === 'subtract') {
        newStock = currentStock - adjustment;
        if (newStock < 0) {
          await transaction.rollback();
          throw new Error('INSUFFICIENT_STOCK');
        }
      } else {
        await transaction.rollback();
        throw new Error('INVALID_OPERATION');
      }

      await feed.update({ current_stock: newStock }, { transaction });
      await transaction.commit();

      logger.info('Feed stock adjusted', { feedId: id, operation, quantity, newStock });
      return feed;
    } catch (error) {
      if (transaction && !transaction.finished) {
        await transaction.rollback();
      }
      throw error;
    }
  }
}

module.exports = new FeedService();
