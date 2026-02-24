/**
 * Unit tests for reportController
 */
jest.mock('../../../src/models', () => {
  const mockSequelize = {};
  return {
    Rabbit: { count: jest.fn(), findAll: jest.fn() },
    Cage: { count: jest.fn(), findAll: jest.fn() },
    Vaccination: { count: jest.fn(), findAll: jest.fn() },
    MedicalRecord: { count: jest.fn(), findAll: jest.fn() },
    Feed: { count: jest.fn(), findAll: jest.fn() },
    FeedingRecord: { findAll: jest.fn(), count: jest.fn(), sum: jest.fn() },
    Transaction: { count: jest.fn(), findAll: jest.fn(), sum: jest.fn() },
    Task: { count: jest.fn() },
    Breeding: { count: jest.fn(), findAll: jest.fn() },
    Birth: { count: jest.fn(), findAll: jest.fn() },
    sequelize: mockSequelize
  };
});

const { Rabbit, Cage, Vaccination, MedicalRecord, Feed, FeedingRecord, Transaction, Task, Breeding, Birth, sequelize } = require('../../../src/models');
const ctrl = require('../../../src/controllers/reportController');

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

// Helper to set all mocks to zero/empty
const setAllMocksToEmpty = () => {
  Rabbit.count.mockResolvedValue(0);
  Cage.count.mockResolvedValue(0);
  Vaccination.count.mockResolvedValue(0);
  Task.count.mockResolvedValue(0);
  Feed.count.mockResolvedValue(0);
  Birth.count.mockResolvedValue(0);
  MedicalRecord.count.mockResolvedValue(0);
  Breeding.count.mockResolvedValue(0);
  Transaction.count.mockResolvedValue(0);
  Transaction.sum.mockResolvedValue(0);
  Transaction.findAll.mockResolvedValue([]);
  Rabbit.findAll.mockResolvedValue([]);
  Birth.findAll.mockResolvedValue([]);
  Cage.findAll.mockResolvedValue([]);
  Vaccination.findAll.mockResolvedValue([]);
  MedicalRecord.findAll.mockResolvedValue([]);
  Breeding.findAll.mockResolvedValue([]);
  Feed.findAll.mockResolvedValue([]);
  FeedingRecord.findAll.mockResolvedValue([]);
  FeedingRecord.count.mockResolvedValue(0);
  FeedingRecord.sum.mockResolvedValue(0);
};

describe('reportController', () => {
  beforeEach(() => {
    jest.resetAllMocks();
    mockNext.mockReset();
  });

  describe('getDashboard', () => {
    it('should return dashboard data with all zeros', async () => {
      setAllMocksToEmpty();

      const req = mockReq();
      const res = mockRes();

      await ctrl.getDashboard(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return dashboard with real data', async () => {
      setAllMocksToEmpty();
      Rabbit.count.mockResolvedValue(10);
      Cage.count.mockResolvedValue(5);
      Vaccination.count.mockResolvedValue(3);
      Task.count.mockResolvedValue(2);
      Feed.count.mockResolvedValue(1);
      Birth.count.mockResolvedValue(2);
      Transaction.sum.mockResolvedValue(500);
      Rabbit.findAll.mockResolvedValue([
        { created_at: new Date().toISOString(), death_date: null, sold_date: null }
      ]);
      Birth.findAll.mockResolvedValue([]);

      const req = mockReq();
      const res = mockRes();

      await ctrl.getDashboard(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should call next on error', async () => {
      Rabbit.count.mockRejectedValue(new Error('DB error'));

      await ctrl.getDashboard(mockReq(), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  describe('getFarmReport', () => {
    it('should return farm report', async () => {
      setAllMocksToEmpty();
      Rabbit.count.mockResolvedValue(5);
      Cage.count.mockResolvedValue(3);

      const req = mockReq({ query: {} });
      const res = mockRes();

      await ctrl.getFarmReport(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should call next on error', async () => {
      Rabbit.count.mockRejectedValue(new Error('DB error'));

      await ctrl.getFarmReport(mockReq({ query: {} }), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  describe('getHealthReport', () => {
    it('should return health report', async () => {
      Rabbit.count.mockResolvedValue(10);
      Vaccination.count.mockResolvedValue(5);
      Vaccination.findAll.mockResolvedValue([]);
      MedicalRecord.count.mockResolvedValue(3);
      MedicalRecord.findAll.mockResolvedValue([]);

      const req = mockReq({ query: {} });
      const res = mockRes();

      await ctrl.getHealthReport(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should call next on error', async () => {
      Vaccination.findAll.mockRejectedValue(new Error('DB error'));

      await ctrl.getHealthReport(mockReq({ query: {} }), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  describe('getFinancialReport', () => {
    it('should return financial report for current year/month', async () => {
      Transaction.findAll.mockResolvedValue([]);
      Transaction.sum.mockResolvedValue(0);

      const req = mockReq({ query: {} });
      const res = mockRes();

      await ctrl.getFinancialReport(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return financial report with year and month params', async () => {
      Transaction.findAll.mockResolvedValue([
        { type: 'income', amount: '1000', category: 'sale', transaction_date: '2024-05-15', toJSON: jest.fn().mockReturnValue({ type: 'income', amount: '1000' }) }
      ]);
      Transaction.sum.mockResolvedValue(1000);

      const req = mockReq({ query: { year: '2024', month: '5' } });
      const res = mockRes();

      await ctrl.getFinancialReport(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should call next on error', async () => {
      Transaction.findAll.mockRejectedValue(new Error('DB error'));

      await ctrl.getFinancialReport(mockReq({ query: {} }), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });
});
