jest.mock('../../../src/services/feedService');
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(),
  error: jest.fn(),
  warn: jest.fn()
}));

const feedService = require('../../../src/services/feedService');
const feedController = require('../../../src/controllers/feedController');

const mockReq = (overrides = {}) => ({
  user: { id: 1 },
  params: {},
  body: {},
  query: {},
  ...overrides
});

const mockRes = () => {
  const res = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  res.send = jest.fn().mockReturnValue(res);
  return res;
};

const mockNext = jest.fn();

describe('FeedController', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('create', () => {
    it('should create feed and return 201', async () => {
      const feed = { id: 1, name: 'Hay', quantity: 50 };
      feedService.createFeed.mockResolvedValue(feed);
      const req = mockReq({ body: { name: 'Hay', quantity: 50 } });
      const res = mockRes();

      await feedController.create(req, res, mockNext);

      expect(feedService.createFeed).toHaveBeenCalledWith({ name: 'Hay', quantity: 50, user_id: 1 });
      expect(res.status).toHaveBeenCalledWith(201);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: feed }));
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      feedService.createFeed.mockRejectedValue(err);
      const req = mockReq({ body: {} });
      const res = mockRes();

      await feedController.create(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('getById', () => {
    it('should return feed with 200', async () => {
      const feed = { id: 1, name: 'Hay' };
      feedService.getFeedById.mockResolvedValue(feed);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await feedController.getById(req, res, mockNext);

      expect(feedService.getFeedById).toHaveBeenCalledWith('1', 1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: feed }));
    });

    it('should return 404 when FEED_NOT_FOUND', async () => {
      feedService.getFeedById.mockRejectedValue(new Error('FEED_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' } });
      const res = mockRes();

      await feedController.getById(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      feedService.getFeedById.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await feedController.getById(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('list', () => {
    it('should return feed list with 200', async () => {
      const result = { items: [{ id: 1 }], total: 1 };
      feedService.listFeeds.mockResolvedValue(result);
      const req = mockReq({ query: { page: '1' } });
      const res = mockRes();

      await feedController.list(req, res, mockNext);

      expect(feedService.listFeeds).toHaveBeenCalledWith(1, { page: '1' });
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: result }));
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      feedService.listFeeds.mockRejectedValue(err);
      const req = mockReq({});
      const res = mockRes();

      await feedController.list(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('update', () => {
    it('should update feed and return 200', async () => {
      const feed = { id: 1, name: 'Pellets', quantity: 100 };
      feedService.updateFeed.mockResolvedValue(feed);
      const req = mockReq({ params: { id: '1' }, body: { name: 'Pellets' } });
      const res = mockRes();

      await feedController.update(req, res, mockNext);

      expect(feedService.updateFeed).toHaveBeenCalledWith('1', 1, { name: 'Pellets' });
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: feed }));
    });

    it('should return 404 when FEED_NOT_FOUND', async () => {
      feedService.updateFeed.mockRejectedValue(new Error('FEED_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' }, body: {} });
      const res = mockRes();

      await feedController.update(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      feedService.updateFeed.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' }, body: {} });
      const res = mockRes();

      await feedController.update(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('delete', () => {
    it('should delete feed and return 200', async () => {
      feedService.deleteFeed.mockResolvedValue({ deleted: true });
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await feedController.delete(req, res, mockNext);

      expect(feedService.deleteFeed).toHaveBeenCalledWith('1', 1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: null }));
    });

    it('should return 404 when FEED_NOT_FOUND', async () => {
      feedService.deleteFeed.mockRejectedValue(new Error('FEED_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' } });
      const res = mockRes();

      await feedController.delete(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 400 when FEED_HAS_RECORDS', async () => {
      feedService.deleteFeed.mockRejectedValue(new Error('FEED_HAS_RECORDS'));
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await feedController.delete(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      feedService.deleteFeed.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await feedController.delete(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('getStatistics', () => {
    it('should return feed statistics with 200', async () => {
      const stats = { totalFeeds: 5, lowStock: 2 };
      feedService.getStatistics.mockResolvedValue(stats);
      const req = mockReq({});
      const res = mockRes();

      await feedController.getStatistics(req, res, mockNext);

      expect(feedService.getStatistics).toHaveBeenCalledWith(1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: stats }));
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      feedService.getStatistics.mockRejectedValue(err);
      const req = mockReq({});
      const res = mockRes();

      await feedController.getStatistics(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('getLowStock', () => {
    it('should return low stock feeds with 200', async () => {
      const feeds = [{ id: 1, name: 'Hay', quantity: 2 }];
      feedService.getLowStock.mockResolvedValue(feeds);
      const req = mockReq({});
      const res = mockRes();

      await feedController.getLowStock(req, res, mockNext);

      expect(feedService.getLowStock).toHaveBeenCalledWith(1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: feeds }));
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      feedService.getLowStock.mockRejectedValue(err);
      const req = mockReq({});
      const res = mockRes();

      await feedController.getLowStock(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('adjustStock', () => {
    it('should add stock and return 200 with add message', async () => {
      const feed = { id: 1, name: 'Hay', quantity: 60 };
      feedService.adjustStock.mockResolvedValue(feed);
      const req = mockReq({ params: { id: '1' }, body: { quantity: 10, operation: 'add' } });
      const res = mockRes();

      await feedController.adjustStock(req, res, mockNext);

      expect(feedService.adjustStock).toHaveBeenCalledWith('1', 1, 10, 'add');
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
        success: true,
        data: feed,
        message: expect.stringContaining('пополнен')
      }));
    });

    it('should subtract stock and return 200 with subtract message', async () => {
      const feed = { id: 1, name: 'Hay', quantity: 40 };
      feedService.adjustStock.mockResolvedValue(feed);
      const req = mockReq({ params: { id: '1' }, body: { quantity: 10, operation: 'subtract' } });
      const res = mockRes();

      await feedController.adjustStock(req, res, mockNext);

      expect(feedService.adjustStock).toHaveBeenCalledWith('1', 1, 10, 'subtract');
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
        success: true,
        data: feed,
        message: expect.stringContaining('списан')
      }));
    });

    it('should return 404 when FEED_NOT_FOUND', async () => {
      feedService.adjustStock.mockRejectedValue(new Error('FEED_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' }, body: { quantity: 10, operation: 'add' } });
      const res = mockRes();

      await feedController.adjustStock(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 400 when INSUFFICIENT_STOCK', async () => {
      feedService.adjustStock.mockRejectedValue(new Error('INSUFFICIENT_STOCK'));
      const req = mockReq({ params: { id: '1' }, body: { quantity: 9999, operation: 'subtract' } });
      const res = mockRes();

      await feedController.adjustStock(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 400 when INVALID_OPERATION', async () => {
      feedService.adjustStock.mockRejectedValue(new Error('INVALID_OPERATION'));
      const req = mockReq({ params: { id: '1' }, body: { quantity: 10, operation: 'multiply' } });
      const res = mockRes();

      await feedController.adjustStock(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      feedService.adjustStock.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' }, body: { quantity: 10, operation: 'add' } });
      const res = mockRes();

      await feedController.adjustStock(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });
});
