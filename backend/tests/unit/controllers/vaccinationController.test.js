/**
 * Unit tests for vaccinationController
 */
jest.mock('../../../src/models', () => {
  const mockSequelize = {
    transaction: jest.fn(),
    fn: jest.fn((fnName, col) => `${fnName}(${col})`),
    col: jest.fn((name) => name)
  };
  return {
    Vaccination: {
      findOne: jest.fn(), findAll: jest.fn(), findByPk: jest.fn(),
      findAndCountAll: jest.fn(), create: jest.fn(), count: jest.fn()
    },
    Rabbit: { findOne: jest.fn(), findAll: jest.fn() },
    Breed: {},
    Transaction: { create: jest.fn() },
    sequelize: mockSequelize
  };
});

jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

const { Vaccination, Rabbit, Transaction, sequelize } = require('../../../src/models');
const ctrl = require('../../../src/controllers/vaccinationController');

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
const mockTx = { commit: jest.fn(), rollback: jest.fn() };

describe('vaccinationController', () => {
  beforeEach(() => {
    jest.resetAllMocks();
    mockNext.mockReset();
    sequelize.transaction.mockResolvedValue(mockTx);
  });

  describe('create', () => {
    const baseBody = { rabbit_id: 1, vaccine_name: 'VGBK', vaccination_date: '2024-05-01', vaccine_type: 'vhd' };

    it('should create vaccination successfully', async () => {
      const rabbit = { id: 1, status: 'healthy' };
      Rabbit.findOne.mockResolvedValue(rabbit);
      Vaccination.create.mockResolvedValue({ id: 1 });
      Vaccination.findByPk.mockResolvedValue({ id: 1 });

      const req = mockReq({ body: baseBody });
      const res = mockRes();

      await ctrl.create(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(201);
      expect(mockTx.commit).toHaveBeenCalled();
    });

    it('should create financial transaction when cost > 0', async () => {
      const rabbit = { id: 1, status: 'healthy' };
      Rabbit.findOne.mockResolvedValue(rabbit);
      Vaccination.create.mockResolvedValue({ id: 2 });
      Vaccination.findByPk.mockResolvedValue({ id: 2 });
      Transaction.create.mockResolvedValue({});

      await ctrl.create(
        mockReq({ body: { ...baseBody, cost: 25.0 } }),
        mockRes(), mockNext
      );

      expect(Transaction.create).toHaveBeenCalledWith(
        expect.objectContaining({ type: 'expense', category: 'Health' }),
        expect.any(Object)
      );
    });

    it('should return 404 if rabbit not found', async () => {
      Rabbit.findOne.mockResolvedValue(null);

      const res = mockRes();
      await ctrl.create(mockReq({ body: baseBody }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should return 400 if rabbit is dead', async () => {
      Rabbit.findOne.mockResolvedValue({ id: 1, status: 'dead' });

      const res = mockRes();
      await ctrl.create(mockReq({ body: baseBody }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should return 400 if rabbit is sold', async () => {
      Rabbit.findOne.mockResolvedValue({ id: 1, status: 'sold' });

      const res = mockRes();
      await ctrl.create(mockReq({ body: baseBody }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('should handle SequelizeValidationError', async () => {
      Rabbit.findOne.mockResolvedValue({ id: 1, status: 'healthy' });
      const validationError = {
        name: 'SequelizeValidationError',
        errors: [{ message: 'Validation failed' }]
      };
      Vaccination.create.mockRejectedValue(validationError);

      const res = mockRes();
      await ctrl.create(mockReq({ body: baseBody }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('should call next on unexpected error', async () => {
      Rabbit.findOne.mockRejectedValue(new Error('DB error'));

      await ctrl.create(mockReq({ body: baseBody }), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  describe('getById', () => {
    it('should return vaccination by id', async () => {
      Vaccination.findByPk.mockResolvedValue({ id: 1 });

      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await ctrl.getById(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return 404 if not found', async () => {
      Vaccination.findByPk.mockResolvedValue(null);

      const res = mockRes();
      await ctrl.getById(mockReq({ params: { id: '999' } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('should call next on error', async () => {
      Vaccination.findByPk.mockRejectedValue(new Error('DB error'));

      await ctrl.getById(mockReq({ params: { id: '1' } }), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalled();
    });
  });

  describe('list', () => {
    it('should return paginated list', async () => {
      Vaccination.findAndCountAll.mockResolvedValue({ rows: [], count: 0 });

      const req = mockReq({ query: {} });
      const res = mockRes();

      await ctrl.list(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should apply rabbit_id and vaccine_type filters', async () => {
      Vaccination.findAndCountAll.mockResolvedValue({ rows: [], count: 0 });

      await ctrl.list(
        mockReq({ query: { rabbit_id: '5', vaccine_type: 'vhd' } }),
        mockRes(), mockNext
      );

      expect(Vaccination.findAndCountAll).toHaveBeenCalledWith(
        expect.objectContaining({
          where: expect.objectContaining({ rabbit_id: '5', vaccine_type: 'vhd' })
        })
      );
    });

    it('should apply from_date and to_date filters', async () => {
      Vaccination.findAndCountAll.mockResolvedValue({ rows: [], count: 0 });

      await ctrl.list(
        mockReq({ query: { from_date: '2024-01-01', to_date: '2024-12-31' } }),
        mockRes(), mockNext
      );

      expect(Vaccination.findAndCountAll).toHaveBeenCalled();
    });

    it('should apply upcoming filter', async () => {
      Vaccination.findAndCountAll.mockResolvedValue({ rows: [], count: 0 });

      await ctrl.list(
        mockReq({ query: { upcoming: 'true' } }),
        mockRes(), mockNext
      );

      expect(Vaccination.findAndCountAll).toHaveBeenCalled();
    });

    it('should call next on error', async () => {
      Vaccination.findAndCountAll.mockRejectedValue(new Error('DB error'));

      await ctrl.list(mockReq({ query: {} }), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalled();
    });
  });

  describe('getByRabbit', () => {
    it('should return vaccinations for rabbit', async () => {
      Rabbit.findOne.mockResolvedValue({ id: 1 });
      Vaccination.findAll.mockResolvedValue([{ id: 1 }]);

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

    it('should call next on DB error', async () => {
      Rabbit.findOne.mockResolvedValue({ id: 1 });
      Vaccination.findAll.mockRejectedValue(new Error('DB error'));

      await ctrl.getByRabbit(mockReq({ params: { rabbitId: '1' } }), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  describe('update', () => {
    it('should update vaccination successfully', async () => {
      const vaccination = {
        id: 1, rabbit_id: 1,
        rabbit: { user_id: 1 },
        update: jest.fn().mockResolvedValue(true)
      };
      Vaccination.findByPk
        .mockResolvedValueOnce(vaccination)
        .mockResolvedValueOnce({ id: 1 });

      const req = mockReq({ params: { id: '1' }, body: { notes: 'Updated' } });
      const res = mockRes();

      await ctrl.update(req, res, mockNext);

      expect(vaccination.update).toHaveBeenCalled();
      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return 404 if not found', async () => {
      Vaccination.findByPk.mockResolvedValueOnce(null);

      const res = mockRes();
      await ctrl.update(mockReq({ params: { id: '999' }, body: {} }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('should return 404 for new rabbit_id not found', async () => {
      const vaccination = { id: 1, rabbit_id: 1, update: jest.fn() };
      Vaccination.findByPk.mockResolvedValueOnce(vaccination);
      Rabbit.findOne.mockResolvedValueOnce(null); // new rabbit not found

      const res = mockRes();
      await ctrl.update(mockReq({ params: { id: '1' }, body: { rabbit_id: 99 } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('should return 400 on SequelizeValidationError', async () => {
      const vaccination = {
        id: 1, rabbit_id: 1,
        rabbit: { user_id: 1 },
        update: jest.fn().mockRejectedValue({
          name: 'SequelizeValidationError',
          errors: [{ message: 'Invalid date' }]
        })
      };
      Vaccination.findByPk.mockResolvedValueOnce(vaccination);

      const res = mockRes();
      await ctrl.update(mockReq({ params: { id: '1' }, body: {} }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next on unexpected error in update', async () => {
      const vaccination = {
        id: 1, rabbit_id: 1,
        rabbit: { user_id: 1 },
        update: jest.fn().mockRejectedValue(new Error('DB error'))
      };
      Vaccination.findByPk.mockResolvedValueOnce(vaccination);

      await ctrl.update(mockReq({ params: { id: '1' }, body: {} }), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  describe('delete', () => {
    it('should delete vaccination successfully', async () => {
      const vaccination = { id: 1, destroy: jest.fn().mockResolvedValue(true) };
      Vaccination.findOne.mockResolvedValue(vaccination);

      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await ctrl.delete(req, res, mockNext);

      expect(vaccination.destroy).toHaveBeenCalled();
      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return 404 if not found', async () => {
      Vaccination.findOne.mockResolvedValue(null);

      const res = mockRes();
      await ctrl.delete(mockReq({ params: { id: '999' } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('should call next on DB error in delete', async () => {
      Vaccination.findOne.mockRejectedValue(new Error('DB error'));

      await ctrl.delete(mockReq({ params: { id: '1' } }), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  describe('getStatistics', () => {
    const setupStatsMocks = (overrides = {}) => {
      // Default mocks for all parallel queries in getStatistics
      Vaccination.count
        .mockResolvedValueOnce(overrides.total ?? 0)         // total
        .mockResolvedValueOnce(overrides.thisYear ?? 0)       // this_year
        .mockResolvedValueOnce(overrides.last30Days ?? 0)     // last_30_days
        .mockResolvedValueOnce(overrides.upcomingTotal ?? 0)  // upcoming total
        .mockResolvedValueOnce(overrides.upcomingNext30 ?? 0) // upcoming next 30 days
        .mockResolvedValueOnce(overrides.overdue ?? 0);       // overdue
      Vaccination.findAll
        .mockResolvedValueOnce(overrides.byVaccineType ?? []) // GROUP BY vaccine_type
        .mockResolvedValueOnce(overrides.upcomingList ?? []);  // upcoming list
    };

    it('should return statistics', async () => {
      setupStatsMocks();

      const req = mockReq({ query: {} });
      const res = mockRes();

      await ctrl.getStatistics(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should count this_year, last_30_days and upcoming', async () => {
      const now = new Date();
      const futureDate = new Date(now.getTime() + 10 * 24 * 60 * 60 * 1000);
      const nearFuture = new Date(now.getTime() + 20 * 24 * 60 * 60 * 1000);

      setupStatsMocks({
        total: 2,
        byVaccineType: [
          { vaccine_type: 'vhd', count: '1' },
          { vaccine_type: 'myxomatosis', count: '1' }
        ],
        thisYear: 2,
        last30Days: 2,
        upcomingTotal: 2,
        upcomingNext30: 2,
        overdue: 0,
        upcomingList: [
          {
            id: 1, rabbit_id: 1, vaccine_name: 'VGBK', vaccine_type: 'vhd',
            next_vaccination_date: futureDate.toISOString(),
            rabbit: { name: 'Буся' }
          },
          {
            id: 2, rabbit_id: 2, vaccine_name: 'Myxo', vaccine_type: 'myxomatosis',
            next_vaccination_date: nearFuture.toISOString(),
            rabbit: { name: 'Прыг' }
          }
        ]
      });

      const res = mockRes();
      await ctrl.getStatistics(mockReq(), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
      const data = res.json.mock.calls[0][0].data;
      expect(data.this_year).toBeGreaterThanOrEqual(2);
      expect(data.last_30_days).toBeGreaterThanOrEqual(2);
      expect(data.upcoming.total).toBeGreaterThanOrEqual(1);
    });

    it('should call next on error', async () => {
      Vaccination.count.mockRejectedValue(new Error('DB error'));

      await ctrl.getStatistics(mockReq(), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  describe('getUpcoming', () => {
    it('should return upcoming vaccinations', async () => {
      const now = new Date();
      const futureDate = new Date(Date.now() + 10 * 24 * 60 * 60 * 1000);
      const records = [{
        id: 1,
        next_vaccination_date: futureDate.toISOString(),
        toJSON: jest.fn().mockReturnValue({ id: 1, next_vaccination_date: futureDate.toISOString() })
      }];
      Vaccination.findAll.mockResolvedValue(records);

      const req = mockReq({ query: {} });
      const res = mockRes();

      await ctrl.getUpcoming(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should use custom days parameter', async () => {
      Vaccination.findAll.mockResolvedValue([]);

      await ctrl.getUpcoming(mockReq({ query: { days: '60' } }), mockRes(), mockNext);

      expect(Vaccination.findAll).toHaveBeenCalled();
    });

    it('should call next on error', async () => {
      Vaccination.findAll.mockRejectedValue(new Error('DB error'));

      await ctrl.getUpcoming(mockReq({ query: {} }), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  describe('getOverdue', () => {
    it('should return overdue vaccinations', async () => {
      const pastDate = new Date(Date.now() - 5 * 24 * 60 * 60 * 1000);
      const records = [{
        id: 1,
        next_vaccination_date: pastDate.toISOString(),
        toJSON: jest.fn().mockReturnValue({ id: 1, next_vaccination_date: pastDate.toISOString() })
      }];
      Vaccination.findAll.mockResolvedValue(records);

      const req = mockReq({ query: {} });
      const res = mockRes();

      await ctrl.getOverdue(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should call next on error', async () => {
      Vaccination.findAll.mockRejectedValue(new Error('DB error'));

      await ctrl.getOverdue(mockReq(), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });
});
