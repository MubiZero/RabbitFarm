/**
 * Unit tests for feedingRecordController
 */
jest.mock('../../../src/models', () => {
  const mockSequelize = { transaction: jest.fn() };
  return {
    FeedingRecord: { findOne: jest.fn(), findAll: jest.fn(), findAndCountAll: jest.fn(), create: jest.fn() },
    Feed: { findOne: jest.fn(), findByPk: jest.fn() },
    Rabbit: { findOne: jest.fn() },
    Cage: { findOne: jest.fn() },
    User: {},
    sequelize: mockSequelize
  };
});

const { FeedingRecord, Feed, Rabbit, Cage, sequelize } = require('../../../src/models');
const ctrl = require('../../../src/controllers/feedingRecordController');

const mockReq = (overrides = {}) => ({
  body: {}, params: {}, query: {}, user: { id: 1 }, ...overrides
});
const mockRes = () => {
  const res = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  return res;
};
const mockNext = jest.fn();
const mockTx = { commit: jest.fn(), rollback: jest.fn(), LOCK: { UPDATE: 'UPDATE' } };

describe('feedingRecordController', () => {
  beforeEach(() => {
    jest.resetAllMocks();
    mockNext.mockReset();
    // Default: supports both callback and explicit style
    sequelize.transaction.mockImplementation(async (cb) => {
      if (typeof cb === 'function') return cb(mockTx);
      return mockTx;
    });
  });

  describe('create', () => {
    const baseBody = { feed_id: 1, quantity: 2.5, cage_id: 5, fed_at: '2024-05-01T08:00:00Z' };

    it('should create feeding record successfully', async () => {
      const cage = { id: 5 };
      Cage.findOne.mockResolvedValue(cage);
      const feed = { id: 1, current_stock: 10, update: jest.fn().mockResolvedValue(true) };
      Feed.findOne.mockResolvedValue(feed);
      const record = { id: 1, reload: jest.fn().mockResolvedValue(true) };
      FeedingRecord.create.mockResolvedValue(record);

      const req = mockReq({ body: baseBody });
      const res = mockRes();

      await ctrl.create(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(201);
    });

    it('should return 404 if rabbit not found', async () => {
      Rabbit.findOne.mockResolvedValue(null);

      const req = mockReq({ body: { ...baseBody, rabbit_id: 99 } });
      const res = mockRes();

      await ctrl.create(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('should return 404 if cage not found', async () => {
      Cage.findOne.mockResolvedValue(null);

      const req = mockReq({ body: baseBody });
      const res = mockRes();

      await ctrl.create(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('should return 404 if feed not found inside transaction', async () => {
      Cage.findOne.mockResolvedValue({ id: 5 });
      Feed.findOne.mockResolvedValue(null);

      const req = mockReq({ body: baseBody });
      const res = mockRes();

      await ctrl.create(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('should return 400 if insufficient stock', async () => {
      Cage.findOne.mockResolvedValue({ id: 5 });
      Feed.findOne.mockResolvedValue({ id: 1, current_stock: 1.0 }); // less than quantity 2.5

      const req = mockReq({ body: baseBody });
      const res = mockRes();

      await ctrl.create(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('should create record without rabbit_id or cage_id', async () => {
      const feed = { id: 1, current_stock: 10, update: jest.fn().mockResolvedValue(true) };
      Feed.findOne.mockResolvedValue(feed);
      const record = { id: 2, reload: jest.fn().mockResolvedValue(true) };
      FeedingRecord.create.mockResolvedValue(record);

      const req = mockReq({ body: { feed_id: 1, quantity: 1.0 } });
      const res = mockRes();

      await ctrl.create(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(201);
    });
  });

  describe('getById', () => {
    it('should return feeding record', async () => {
      FeedingRecord.findOne.mockResolvedValue({ id: 1 });

      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await ctrl.getById(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return 404 if not found', async () => {
      FeedingRecord.findOne.mockResolvedValue(null);

      const res = mockRes();
      await ctrl.getById(mockReq({ params: { id: '999' } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('should call next on error', async () => {
      FeedingRecord.findOne.mockRejectedValue(new Error('DB error'));

      await ctrl.getById(mockReq({ params: { id: '1' } }), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalled();
    });
  });

  describe('list', () => {
    it('should return paginated list', async () => {
      FeedingRecord.findAndCountAll.mockResolvedValue({ rows: [], count: 0 });

      const req = mockReq({ query: {} });
      const res = mockRes();

      await ctrl.list(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should apply rabbit_id, feed_id, cage_id filters', async () => {
      FeedingRecord.findAndCountAll.mockResolvedValue({ rows: [], count: 0 });

      await ctrl.list(
        mockReq({ query: { rabbit_id: '1', feed_id: '2', cage_id: '3' } }),
        mockRes(), mockNext
      );

      expect(FeedingRecord.findAndCountAll).toHaveBeenCalledWith(
        expect.objectContaining({
          where: expect.objectContaining({ rabbit_id: '1', feed_id: '2', cage_id: '3' })
        })
      );
    });

    it('should apply from_date and to_date filters', async () => {
      FeedingRecord.findAndCountAll.mockResolvedValue({ rows: [], count: 0 });

      await ctrl.list(
        mockReq({ query: { from_date: '2024-01-01', to_date: '2024-12-31' } }),
        mockRes(), mockNext
      );

      expect(FeedingRecord.findAndCountAll).toHaveBeenCalled();
    });
  });

  describe('getByRabbit', () => {
    it('should return feeding records for rabbit', async () => {
      Rabbit.findOne.mockResolvedValue({ id: 1 });
      FeedingRecord.findAll.mockResolvedValue([{ id: 1 }]);

      const req = mockReq({ params: { rabbitId: '1' } });
      const res = mockRes();

      await ctrl.getByRabbit(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return 404 if rabbit not found', async () => {
      Rabbit.findOne.mockResolvedValue(null);

      const res = mockRes();
      await ctrl.getByRabbit(mockReq({ params: { rabbitId: '999' } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });
  });

  describe('update', () => {
    it('should return 404 if record not found', async () => {
      FeedingRecord.findOne.mockResolvedValue(null);

      const res = mockRes();
      await ctrl.update(mockReq({ params: { id: '999' }, body: {} }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('should update record without stock changes when no quantity/feed change', async () => {
      const record = {
        id: 1, feed_id: 1, cage_id: null, rabbit_id: null,
        quantity: '2.0',
        update: jest.fn().mockResolvedValue(true),
        reload: jest.fn().mockResolvedValue(true)
      };
      FeedingRecord.findOne.mockResolvedValue(record);
      // No feed_id or quantity in body → no stock check needed
      Feed.findOne.mockResolvedValue({ id: 1, current_stock: 5, update: jest.fn().mockResolvedValue(true) });

      const req = mockReq({ params: { id: '1' }, body: { notes: 'updated' } });
      const res = mockRes();

      await ctrl.update(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
      expect(mockTx.commit).toHaveBeenCalled();
    });

    it('should return 404 when new rabbit_id not found', async () => {
      const record = { id: 1, feed_id: 1, cage_id: null, rabbit_id: 1, quantity: '2.0' };
      FeedingRecord.findOne.mockResolvedValue(record);
      Rabbit.findOne.mockResolvedValue(null);

      const res = mockRes();
      await ctrl.update(mockReq({ params: { id: '1' }, body: { rabbit_id: 99 } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('should return 404 when new cage_id not found', async () => {
      const record = { id: 1, feed_id: 1, cage_id: 1, rabbit_id: null, quantity: '2.0' };
      FeedingRecord.findOne.mockResolvedValue(record);
      Cage.findOne.mockResolvedValue(null);

      const res = mockRes();
      await ctrl.update(mockReq({ params: { id: '1' }, body: { cage_id: 99 } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });
  });

  describe('delete', () => {
    it('should delete feeding record and restore stock', async () => {
      const feed = { id: 1, current_stock: '5.0', update: jest.fn().mockResolvedValue(true) };
      const record = { id: 1, feed_id: 1, quantity: '2.5', destroy: jest.fn().mockResolvedValue(true) };
      FeedingRecord.findOne.mockResolvedValue(record);
      Feed.findOne.mockResolvedValue(feed);

      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await ctrl.delete(req, res, mockNext);

      expect(feed.update).toHaveBeenCalledWith(
        { current_stock: 7.5 },
        expect.any(Object)
      );
      expect(record.destroy).toHaveBeenCalled();
      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return 404 if record not found', async () => {
      FeedingRecord.findOne.mockResolvedValue(null);

      const res = mockRes();
      await ctrl.delete(mockReq({ params: { id: '999' } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should delete without restoring stock when feed not found', async () => {
      const record = { id: 1, feed_id: 99, quantity: '1.0', destroy: jest.fn().mockResolvedValue(true) };
      FeedingRecord.findOne.mockResolvedValue(record);
      Feed.findOne.mockResolvedValue(null); // feed not found

      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await ctrl.delete(req, res, mockNext);

      expect(record.destroy).toHaveBeenCalled();
      expect(res.status).toHaveBeenCalledWith(200);
    });
  });

  describe('getStatistics', () => {
    it('should return statistics with empty records', async () => {
      FeedingRecord.findAll.mockResolvedValue([]);

      const req = mockReq({ query: {} });
      const res = mockRes();

      await ctrl.getStatistics(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should compute statistics with records', async () => {
      const records = [
        {
          quantity: '2.0',
          feed: { name: 'Pellets', type: 'pellets', unit: 'kg', cost_per_unit: '5.0' }
        }
      ];
      FeedingRecord.findAll.mockResolvedValue(records);

      const res = mockRes();
      await ctrl.getStatistics(mockReq({ query: {} }), res, mockNext);

      const json = res.json.mock.calls[0][0];
      expect(json.data.total_feedings).toBe(1);
      expect(json.data.by_feed_type.pellets).toBe(2);
    });

    it('should apply date filters', async () => {
      FeedingRecord.findAll.mockResolvedValue([]);

      await ctrl.getStatistics(
        mockReq({ query: { from_date: '2024-01-01', to_date: '2024-12-31' } }),
        mockRes(), mockNext
      );

      expect(FeedingRecord.findAll).toHaveBeenCalled();
    });
  });

  describe('getRecent', () => {
    it('should return recent feeding records', async () => {
      FeedingRecord.findAll.mockResolvedValue([{ id: 1 }, { id: 2 }]);

      const req = mockReq({ query: {} });
      const res = mockRes();

      await ctrl.getRecent(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });
  });
});
