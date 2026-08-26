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
    Farm: { findOne: jest.fn(), findAll: jest.fn() },
    sequelize: mockSequelize
  };
});

const { Rabbit, Cage, Vaccination, MedicalRecord, Feed, FeedingRecord, Transaction, Task, Breeding, Birth } = require('../../../src/models');
const ctrl = require('../../../src/controllers/reportController');

const mockReq = (overrides = {}) => ({
  // Роль нужна отчётам: денежный блок работнику не отдаётся вовсе, поэтому
  // без роли сводка приходила бы без денег и тесты про суммы разъезжались.
  body: {}, params: {}, query: {}, user: { id: 1, role: 'owner' }, farmId: 1, ...overrides
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

    // Деньги сводка искала по тому, кто внёс операцию, а поголовье — по ферме.
    // Признак должен быть один, иначе две цифры про одни деньги разъедутся.
    it('отбирает деньги, задачи и поголовье по одной и той же ферме', async () => {
      setAllMocksToEmpty();

      await ctrl.getDashboard(mockReq({ farmId: 7 }), mockRes(), mockNext);

      expect(mockNext).not.toHaveBeenCalled();

      const counted = [
        ...Rabbit.count.mock.calls, ...Rabbit.findAll.mock.calls,
        ...Cage.count.mock.calls, ...Vaccination.count.mock.calls,
        ...Task.count.mock.calls, ...Feed.count.mock.calls,
        ...Birth.count.mock.calls, ...Birth.findAll.mock.calls
      ].map(([options]) => options.where);

      // У Transaction.sum первым аргументом идёт поле, опции — вторым.
      const money = Transaction.sum.mock.calls.map(([, options]) => options.where);

      expect(counted).toHaveLength(14);
      expect(money).toHaveLength(2);
      for (const where of [...counted, ...money]) {
        expect(where.farm_id).toBe(7);
      }
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

    it('should default date_from to 30 days ago when no dates provided', async () => {
      setAllMocksToEmpty();

      // Fix Date to a known value
      const fixedNow = new Date('2025-06-15T12:00:00Z');
      jest.useFakeTimers();
      jest.setSystemTime(fixedNow);

      const req = mockReq({ query: {} });
      const res = mockRes();

      await ctrl.getFarmReport(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);

      // Transaction.findAll should have been called with date range starting 30 days ago
      const txCall = Transaction.findAll.mock.calls[0][0];
      const { Op } = require('sequelize');
      expect(txCall.where.transaction_date[Op.gte]).toBe('2025-05-16');
      expect(txCall.where.transaction_date[Op.lte]).toBe('2025-06-15');

      // period in response should reflect the defaults
      const responseBody = res.json.mock.calls[0][0];
      expect(responseBody.data.period.from).toBe('2025-05-16');
      expect(responseBody.data.period.to).toBe('2025-06-15');

      jest.useRealTimers();
    });

    it('should use explicit date_from when provided', async () => {
      setAllMocksToEmpty();

      const req = mockReq({ query: { from_date: '2024-01-01' } });
      const res = mockRes();

      await ctrl.getFarmReport(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
      const txCall = Transaction.findAll.mock.calls[0][0];
      const { Op } = require('sequelize');
      expect(txCall.where.transaction_date[Op.gte]).toBe('2024-01-01');
    });

    it('should call next on error', async () => {
      Rabbit.count.mockRejectedValue(new Error('DB error'));

      await ctrl.getFarmReport(mockReq({ query: {} }), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });

    it('считает каждый раздел по колонке фермы', async () => {
      setAllMocksToEmpty();

      await ctrl.getFarmReport(mockReq({ query: {}, farmId: 7 }), mockRes(), mockNext);

      expect(mockNext).not.toHaveBeenCalled();

      const calls = [
        ...Rabbit.findAll.mock.calls, ...Rabbit.count.mock.calls,
        ...Transaction.findAll.mock.calls, ...Vaccination.count.mock.calls,
        ...MedicalRecord.count.mock.calls, ...Breeding.count.mock.calls,
        ...Birth.count.mock.calls, ...FeedingRecord.count.mock.calls,
        ...FeedingRecord.findAll.mock.calls
      ];

      expect(calls).toHaveLength(9);
      for (const [options] of calls) {
        expect(options.where.farm_id).toBe(7);
      }
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

    it('отбирает прививки и лечения по колонке фермы', async () => {
      Vaccination.findAll.mockResolvedValue([]);
      MedicalRecord.findAll.mockResolvedValue([]);

      await ctrl.getHealthReport(mockReq({ query: {}, farmId: 7 }), mockRes(), mockNext);

      expect(mockNext).not.toHaveBeenCalled();

      const calls = [...Vaccination.findAll.mock.calls, ...MedicalRecord.findAll.mock.calls];
      expect(calls).toHaveLength(3);
      for (const [options] of calls) {
        expect(options.where.farm_id).toBe(7);
      }
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

    it('should apply from_date and to_date filters', async () => {
      Transaction.findAll.mockResolvedValue([
        { type: 'income', total: '500', category: 'sale', count: '2' },
        { type: 'expense', total: '200', category: 'feed', count: '1' }
      ]);

      const req = mockReq({ query: { from_date: '2024-01-01', to_date: '2024-12-31' } });
      const res = mockRes();

      await ctrl.getFinancialReport(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
      expect(Transaction.findAll).toHaveBeenCalled();
    });

    it('should call next on error', async () => {
      Transaction.findAll.mockRejectedValue(new Error('DB error'));

      await ctrl.getFinancialReport(mockReq({ query: {} }), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });

    it('отбирает операции по ферме, а не по автору записи', async () => {
      Transaction.findAll.mockResolvedValue([]);

      await ctrl.getFinancialReport(mockReq({ query: {}, farmId: 7 }), mockRes(), mockNext);

      expect(mockNext).not.toHaveBeenCalled();
      for (const [options] of Transaction.findAll.mock.calls) {
        expect(options.where.farm_id).toBe(7);
        expect(options.where.created_by).toBeUndefined();
      }
    });

    it('should group by category when groupBy=by_category', async () => {
      // First call: totalByType; Second call: byCategory grouped
      Transaction.findAll
        .mockResolvedValueOnce([
          { type: 'income', total: '1000' },
          { type: 'expense', total: '300' }
        ])
        .mockResolvedValueOnce([
          { category: 'sale', total_income: '1000', total_expense: '0' },
          { category: 'feed', total_income: '0', total_expense: '300' }
        ]);

      const req = mockReq({ query: { groupBy: 'by_category' } });
      const res = mockRes();

      await ctrl.getFinancialReport(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
      const body = res.json.mock.calls[0][0];
      expect(body.data.summary).toBeDefined();
      expect(body.data.grouped).toHaveLength(2);
      expect(body.data.grouped[0]).toEqual({
        category: 'sale',
        total_income: '1000.00',
        total_expense: '0.00',
        net: '1000.00'
      });
      expect(body.data.grouped[1]).toEqual({
        category: 'feed',
        total_income: '0.00',
        total_expense: '300.00',
        net: '-300.00'
      });
      // Should not have by_category (the old flat key)
      expect(body.data.by_category).toBeUndefined();
    });

    it('should group by month when groupBy=by_month', async () => {
      Transaction.findAll
        .mockResolvedValueOnce([
          { type: 'income', total: '1500' }
        ])
        .mockResolvedValueOnce([
          { month: '2024-01', total_income: '800', total_expense: '200' },
          { month: '2024-02', total_income: '700', total_expense: '0' }
        ]);

      const req = mockReq({ query: { groupBy: 'by_month' } });
      const res = mockRes();

      await ctrl.getFinancialReport(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
      const body = res.json.mock.calls[0][0];
      expect(body.data.grouped).toHaveLength(2);
      expect(body.data.grouped[0]).toEqual({
        month: '2024-01',
        total_income: '800.00',
        total_expense: '200.00',
        net: '600.00'
      });
      expect(body.data.grouped[1]).toEqual({
        month: '2024-02',
        total_income: '700.00',
        total_expense: '0.00',
        net: '700.00'
      });
    });

    it('should group by type when groupBy=by_type', async () => {
      Transaction.findAll
        .mockResolvedValueOnce([
          { type: 'income', total: '500' },
          { type: 'expense', total: '200' }
        ])
        .mockResolvedValueOnce([
          { type: 'income', total: '500', count: '3' },
          { type: 'expense', total: '200', count: '2' }
        ]);

      const req = mockReq({ query: { groupBy: 'by_type' } });
      const res = mockRes();

      await ctrl.getFinancialReport(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
      const body = res.json.mock.calls[0][0];
      expect(body.data.grouped).toHaveLength(2);
      expect(body.data.grouped[0]).toEqual({
        type: 'income',
        total: '500.00',
        count: 3
      });
      expect(body.data.grouped[1]).toEqual({
        type: 'expense',
        total: '200.00',
        count: 2
      });
    });

    it('should return default ungrouped response for unknown groupBy value', async () => {
      Transaction.findAll
        .mockResolvedValueOnce([{ type: 'income', total: '100' }])
        .mockResolvedValueOnce([{ type: 'income', category: 'sale', total: '100', count: '1' }]);

      const req = mockReq({ query: { groupBy: 'by_unknown' } });
      const res = mockRes();

      await ctrl.getFinancialReport(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
      const body = res.json.mock.calls[0][0];
      expect(body.data.by_category).toBeDefined();
      expect(body.data.grouped).toBeUndefined();
    });
  });

  describe('getFarmReport — date filters & income/expense branches', () => {
    it('should apply from_date and to_date filters', async () => {
      setAllMocksToEmpty();
      Rabbit.count.mockResolvedValue(3);

      const req = mockReq({ query: { from_date: '2024-01-01', to_date: '2024-12-31' } });
      const res = mockRes();

      await ctrl.getFarmReport(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should apply only from_date filter', async () => {
      setAllMocksToEmpty();
      const req = mockReq({ query: { from_date: '2024-06-01' } });
      const res = mockRes();

      await ctrl.getFarmReport(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should calculate income and expense totals from transactions', async () => {
      setAllMocksToEmpty();
      Transaction.findAll.mockResolvedValue([
        { type: 'income', total: '1000', count: '5' },
        { type: 'expense', total: '400', count: '3' }
      ]);

      const req = mockReq({ query: {} });
      const res = mockRes();

      await ctrl.getFarmReport(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
      const responseBody = res.json.mock.calls[0][0];
      expect(responseBody.data.financial.summary.total_income).toBe(1000);
      expect(responseBody.data.financial.summary.total_expenses).toBe(400);
    });
  });

  describe('getHealthReport — date filters', () => {
    it('should apply from_date and to_date filters', async () => {
      Vaccination.findAll.mockResolvedValue([]);
      MedicalRecord.findAll.mockResolvedValue([]);

      const req = mockReq({ query: { from_date: '2024-01-01', to_date: '2024-12-31' } });
      const res = mockRes();

      await ctrl.getHealthReport(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should apply only to_date filter', async () => {
      Vaccination.findAll.mockResolvedValue([]);
      MedicalRecord.findAll.mockResolvedValue([]);

      const req = mockReq({ query: { to_date: '2024-06-30' } });
      const res = mockRes();

      await ctrl.getHealthReport(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });
  });
});
