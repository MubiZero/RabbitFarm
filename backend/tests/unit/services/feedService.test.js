/**
 * Unit tests for feedService
 */
jest.mock('../../../src/models', () => {
  const mockSequelize = {
    transaction: jest.fn()
  };
  return {
    Feed: {
      findAll: jest.fn(),
      findOne: jest.fn(),
      findByPk: jest.fn(),
      findAndCountAll: jest.fn(),
      create: jest.fn(),
      sequelize: mockSequelize
    },
    FeedingRecord: {
      count: jest.fn()
    }
  };
});

jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

const { Feed, FeedingRecord } = require('../../../src/models');
const feedService = require('../../../src/services/feedService');

const mockTx = {
  commit: jest.fn(),
  rollback: jest.fn(),
  finished: false,
  LOCK: { UPDATE: 'UPDATE' }
};

describe('feedService', () => {
  beforeEach(() => {
    jest.resetAllMocks();
    Feed.sequelize.transaction.mockResolvedValue(mockTx);
    mockTx.commit.mockResolvedValue(undefined);
    mockTx.rollback.mockResolvedValue(undefined);
  });

  describe('createFeed', () => {
    it('should create feed successfully', async () => {
      const feed = { id: 1, name: 'Pellets' };
      Feed.create.mockResolvedValue(feed);

      const result = await feedService.createFeed({ name: 'Pellets', type: 'pellets' });

      expect(result).toEqual(feed);
      expect(Feed.create).toHaveBeenCalled();
    });

    it('should throw on DB error', async () => {
      Feed.create.mockRejectedValue(new Error('DB error'));

      await expect(feedService.createFeed({})).rejects.toThrow('DB error');
    });
  });

  describe('getFeedById', () => {
    it('should return feed by id', async () => {
      const feed = { id: 1, name: 'Pellets' };
      Feed.findOne.mockResolvedValue(feed);

      const result = await feedService.getFeedById(1, 1);

      expect(result).toEqual(feed);
    });

    it('should throw FEED_NOT_FOUND if not found', async () => {
      Feed.findOne.mockResolvedValue(null);

      await expect(feedService.getFeedById(999, 1)).rejects.toThrow('FEED_NOT_FOUND');
    });
  });

  describe('listFeeds', () => {
    it('should return paginated list', async () => {
      Feed.findAndCountAll.mockResolvedValue({ rows: [], count: 0 });

      const result = await feedService.listFeeds(1);

      expect(Feed.findAndCountAll).toHaveBeenCalled();
      expect(result.pagination).toBeDefined();
    });

    it('should apply type filter', async () => {
      Feed.findAndCountAll.mockResolvedValue({ rows: [], count: 0 });

      await feedService.listFeeds(1, { type: 'pellets' });

      expect(Feed.findAndCountAll).toHaveBeenCalledWith(
        expect.objectContaining({
          where: expect.objectContaining({ type: 'pellets' })
        })
      );
    });

    it('should apply low_stock filter', async () => {
      Feed.findAndCountAll.mockResolvedValue({ rows: [], count: 0 });

      await feedService.listFeeds(1, { low_stock: 'true' });

      expect(Feed.findAndCountAll).toHaveBeenCalled();
    });

    it('should apply search filter', async () => {
      Feed.findAndCountAll.mockResolvedValue({ rows: [], count: 0 });

      await feedService.listFeeds(1, { search: 'Oat' });

      expect(Feed.findAndCountAll).toHaveBeenCalled();
    });
  });

  describe('updateFeed', () => {
    it('should update feed successfully', async () => {
      const feed = { id: 1, update: jest.fn().mockResolvedValue(true) };
      Feed.findOne.mockResolvedValue(feed);

      const result = await feedService.updateFeed(1, 1, { name: 'Updated' });

      expect(feed.update).toHaveBeenCalledWith({ name: 'Updated' });
      expect(result).toBe(feed);
    });

    it('should throw FEED_NOT_FOUND if not found', async () => {
      Feed.findOne.mockResolvedValue(null);

      await expect(feedService.updateFeed(999, 1, {})).rejects.toThrow('FEED_NOT_FOUND');
    });
  });

  describe('deleteFeed', () => {
    it('should delete feed successfully', async () => {
      const feed = { id: 1, destroy: jest.fn().mockResolvedValue(true) };
      Feed.findOne.mockResolvedValue(feed);
      FeedingRecord.count.mockResolvedValue(0);

      const result = await feedService.deleteFeed(1, 1);

      expect(feed.destroy).toHaveBeenCalled();
      expect(result.success).toBe(true);
    });

    it('should throw FEED_NOT_FOUND if not found', async () => {
      Feed.findOne.mockResolvedValue(null);

      await expect(feedService.deleteFeed(999, 1)).rejects.toThrow('FEED_NOT_FOUND');
    });

    it('should throw FEED_HAS_RECORDS if has records', async () => {
      const feed = { id: 1 };
      Feed.findOne.mockResolvedValue(feed);
      FeedingRecord.count.mockResolvedValue(5);

      await expect(feedService.deleteFeed(1, 1)).rejects.toThrow('FEED_HAS_RECORDS');
    });
  });

  describe('getStatistics', () => {
    it('should return statistics for empty feeds', async () => {
      Feed.findAll.mockResolvedValue([]);

      const result = await feedService.getStatistics(1);

      expect(result.total_feeds).toBe(0);
      expect(result.low_stock_count).toBe(0);
    });

    it('should compute statistics with feeds', async () => {
      const feeds = [
        { type: 'pellets', current_stock: '5.0', min_stock: '10.0', cost_per_unit: '2.0', id: 1, name: 'Pellets', unit: 'kg' },
        { type: 'hay', current_stock: '20.0', min_stock: '5.0', cost_per_unit: null, id: 2, name: 'Hay', unit: 'kg' }
      ];
      Feed.findAll.mockResolvedValue(feeds);

      const result = await feedService.getStatistics(1);

      expect(result.total_feeds).toBe(2);
      expect(result.by_type.pellets).toBe(1);
      expect(result.by_type.hay).toBe(1);
      expect(result.low_stock_count).toBe(1);
      expect(result.low_stock_items).toHaveLength(1);
      expect(result.total_stock_value).toBe(10);
    });

    it('should handle unknown feed type', async () => {
      const feeds = [
        { type: 'unknown_type', current_stock: '5.0', min_stock: '10.0', cost_per_unit: null }
      ];
      Feed.findAll.mockResolvedValue(feeds);

      const result = await feedService.getStatistics(1);

      expect(result.total_feeds).toBe(1);
    });
  });

  describe('getLowStock', () => {
    it('should return low stock feeds', async () => {
      const feeds = [
        { toJSON: jest.fn().mockReturnValue({ id: 1, name: 'Pellets' }), current_stock: '5', min_stock: '10' }
      ];
      Feed.findAll.mockResolvedValue(feeds);

      const result = await feedService.getLowStock(1);

      expect(result).toHaveLength(1);
      expect(result[0].stock_percentage).toBeDefined();
    });

    it('should handle zero min_stock', async () => {
      const feeds = [
        { toJSON: jest.fn().mockReturnValue({ id: 1 }), current_stock: '0', min_stock: '0' }
      ];
      Feed.findAll.mockResolvedValue(feeds);

      const result = await feedService.getLowStock(1);

      expect(result[0].stock_percentage).toBe(0);
    });
  });

  describe('adjustStock', () => {
    it('should add stock successfully', async () => {
      const feed = { id: 1, current_stock: '10.0', update: jest.fn().mockResolvedValue(true) };
      Feed.findOne.mockResolvedValue(feed);

      await feedService.adjustStock(1, 1, 5, 'add');

      expect(feed.update).toHaveBeenCalledWith({ current_stock: 15 }, { transaction: mockTx });
      expect(mockTx.commit).toHaveBeenCalled();
    });

    it('should subtract stock successfully', async () => {
      const feed = { id: 1, current_stock: '10.0', update: jest.fn().mockResolvedValue(true) };
      Feed.findOne.mockResolvedValue(feed);

      await feedService.adjustStock(1, 1, 3, 'subtract');

      expect(feed.update).toHaveBeenCalledWith({ current_stock: 7 }, { transaction: mockTx });
    });

    it('should throw INSUFFICIENT_STOCK when subtracting too much', async () => {
      const feed = { id: 1, current_stock: '2.0' };
      Feed.findOne.mockResolvedValue(feed);

      await expect(feedService.adjustStock(1, 1, 5, 'subtract')).rejects.toThrow('INSUFFICIENT_STOCK');
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should throw INVALID_OPERATION for unknown operation', async () => {
      const feed = { id: 1, current_stock: '10.0' };
      Feed.findOne.mockResolvedValue(feed);

      await expect(feedService.adjustStock(1, 1, 5, 'multiply')).rejects.toThrow('INVALID_OPERATION');
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should throw FEED_NOT_FOUND if feed not found in transaction', async () => {
      Feed.findOne.mockResolvedValue(null);

      await expect(feedService.adjustStock(999, 1, 5, 'add')).rejects.toThrow('FEED_NOT_FOUND');
      expect(mockTx.rollback).toHaveBeenCalled();
    });
  });
});
