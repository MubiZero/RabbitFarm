/**
 * Unit tests for vaccinationController
 */
jest.mock('../../../src/models', () => {
  const mockSequelize = { transaction: jest.fn() };
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
  });

  describe('getStatistics', () => {
    it('should return statistics', async () => {
      Vaccination.findAll.mockResolvedValue([]);

      const req = mockReq({ query: {} });
      const res = mockRes();

      await ctrl.getStatistics(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
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
  });
});
