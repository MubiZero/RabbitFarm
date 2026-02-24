/**
 * Unit tests for medicalRecordController
 */
jest.mock('../../../src/models', () => {
  const mockSequelize = {
    transaction: jest.fn(),
    fn: jest.fn((fnName, col) => `${fnName}(${col})`),
    col: jest.fn((name) => name)
  };
  return {
    MedicalRecord: {
      findAll: jest.fn(),
      findByPk: jest.fn(),
      findOne: jest.fn(),
      findAndCountAll: jest.fn(),
      create: jest.fn(),
      count: jest.fn()
    },
    Rabbit: { findOne: jest.fn() },
    Breed: {},
    Transaction: { create: jest.fn() },
    sequelize: mockSequelize
  };
});

jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

const { MedicalRecord, Rabbit, Transaction, sequelize } = require('../../../src/models');
const ctrl = require('../../../src/controllers/medicalRecordController');

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

describe('medicalRecordController', () => {
  beforeEach(() => {
    jest.resetAllMocks();
    sequelize.transaction.mockResolvedValue(mockTx);
    mockNext.mockReset();
  });

  describe('create', () => {
    const baseBody = { rabbit_id: 1, diagnosis: 'Cold', started_at: '2024-05-01' };

    it('should create medical record successfully', async () => {
      const rabbit = { id: 1, status: 'healthy', update: jest.fn().mockResolvedValue(true) };
      Rabbit.findOne.mockResolvedValue(rabbit);
      MedicalRecord.create.mockResolvedValue({ id: 1 });
      MedicalRecord.findByPk.mockResolvedValue({ id: 1 });

      const req = mockReq({ body: baseBody });
      const res = mockRes();

      await ctrl.create(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(201);
      expect(mockTx.commit).toHaveBeenCalled();
    });

    it('should update rabbit status to dead when outcome is died', async () => {
      const rabbit = { id: 1, status: 'sick', update: jest.fn().mockResolvedValue(true) };
      Rabbit.findOne.mockResolvedValue(rabbit);
      MedicalRecord.create.mockResolvedValue({ id: 2 });
      MedicalRecord.findByPk.mockResolvedValue({ id: 2 });

      await ctrl.create(mockReq({ body: { ...baseBody, outcome: 'died' } }), mockRes(), mockNext);

      expect(rabbit.update).toHaveBeenCalledWith({ status: 'dead', cage_id: null }, expect.any(Object));
    });

    it('should update rabbit status to dead when outcome is euthanized', async () => {
      const rabbit = { id: 1, status: 'sick', update: jest.fn().mockResolvedValue(true) };
      Rabbit.findOne.mockResolvedValue(rabbit);
      MedicalRecord.create.mockResolvedValue({ id: 3 });
      MedicalRecord.findByPk.mockResolvedValue({ id: 3 });

      await ctrl.create(mockReq({ body: { ...baseBody, outcome: 'euthanized' } }), mockRes(), mockNext);

      expect(rabbit.update).toHaveBeenCalledWith({ status: 'dead', cage_id: null }, expect.any(Object));
    });

    it('should update rabbit status to sick when outcome is ongoing', async () => {
      const rabbit = { id: 1, status: 'healthy', update: jest.fn().mockResolvedValue(true) };
      Rabbit.findOne.mockResolvedValue(rabbit);
      MedicalRecord.create.mockResolvedValue({ id: 4 });
      MedicalRecord.findByPk.mockResolvedValue({ id: 4 });

      await ctrl.create(mockReq({ body: { ...baseBody, outcome: 'ongoing' } }), mockRes(), mockNext);

      expect(rabbit.update).toHaveBeenCalledWith({ status: 'sick' }, expect.any(Object));
    });

    it('should update rabbit status to alive when outcome is recovered', async () => {
      const rabbit = { id: 1, status: 'sick', update: jest.fn().mockResolvedValue(true) };
      Rabbit.findOne.mockResolvedValue(rabbit);
      MedicalRecord.create.mockResolvedValue({ id: 6 });
      MedicalRecord.findByPk.mockResolvedValue({ id: 6 });

      await ctrl.create(mockReq({ body: { ...baseBody, outcome: 'recovered' } }), mockRes(), mockNext);

      expect(rabbit.update).toHaveBeenCalledWith({ status: 'alive' }, expect.any(Object));
    });

    it('should not update rabbit status when outcome does not trigger a change', async () => {
      const rabbit = { id: 1, status: 'healthy', update: jest.fn().mockResolvedValue(true) };
      Rabbit.findOne.mockResolvedValue(rabbit);
      MedicalRecord.create.mockResolvedValue({ id: 7 });
      MedicalRecord.findByPk.mockResolvedValue({ id: 7 });

      await ctrl.create(mockReq({ body: baseBody }), mockRes(), mockNext);

      expect(rabbit.update).not.toHaveBeenCalled();
    });

    it('should create financial transaction when cost > 0', async () => {
      const rabbit = { id: 1, status: 'healthy', update: jest.fn().mockResolvedValue(true) };
      Rabbit.findOne.mockResolvedValue(rabbit);
      MedicalRecord.create.mockResolvedValue({ id: 5 });
      MedicalRecord.findByPk.mockResolvedValue({ id: 5 });
      Transaction.create.mockResolvedValue({});

      await ctrl.create(mockReq({ body: { ...baseBody, cost: 50.0 } }), mockRes(), mockNext);

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

    it('should call next on unexpected error', async () => {
      Rabbit.findOne.mockRejectedValue(new Error('DB error'));

      await ctrl.create(mockReq({ body: baseBody }), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });

    it('should handle SequelizeValidationError with badRequest', async () => {
      const rabbit = { id: 1, status: 'healthy' };
      Rabbit.findOne.mockResolvedValue(rabbit);
      const validationError = {
        name: 'SequelizeValidationError',
        errors: [{ message: 'Validation failed' }]
      };
      MedicalRecord.create.mockRejectedValue(validationError);

      const res = mockRes();
      await ctrl.create(mockReq({ body: baseBody }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
    });
  });

  describe('getById', () => {
    it('should return medical record by id', async () => {
      MedicalRecord.findByPk.mockResolvedValue({ id: 1 });

      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await ctrl.getById(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return 404 if not found', async () => {
      MedicalRecord.findByPk.mockResolvedValue(null);

      const res = mockRes();
      await ctrl.getById(mockReq({ params: { id: '999' } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('should call next on error', async () => {
      MedicalRecord.findByPk.mockRejectedValue(new Error('DB error'));

      await ctrl.getById(mockReq({ params: { id: '1' } }), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalled();
    });
  });

  describe('list', () => {
    it('should return paginated list with defaults', async () => {
      MedicalRecord.findAndCountAll.mockResolvedValue({ rows: [], count: 0 });

      const req = mockReq({ query: {} });
      const res = mockRes();

      await ctrl.list(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should apply rabbit_id filter', async () => {
      MedicalRecord.findAndCountAll.mockResolvedValue({ rows: [], count: 0 });

      await ctrl.list(mockReq({ query: { rabbit_id: '5' } }), mockRes(), mockNext);

      expect(MedicalRecord.findAndCountAll).toHaveBeenCalledWith(
        expect.objectContaining({ where: expect.objectContaining({ rabbit_id: '5' }) })
      );
    });

    it('should apply ongoing filter', async () => {
      MedicalRecord.findAndCountAll.mockResolvedValue({ rows: [], count: 0 });

      await ctrl.list(mockReq({ query: { ongoing: 'true' } }), mockRes(), mockNext);

      expect(MedicalRecord.findAndCountAll).toHaveBeenCalledWith(
        expect.objectContaining({ where: expect.objectContaining({ outcome: 'ongoing' }) })
      );
    });

    it('should apply from_date and to_date filters', async () => {
      MedicalRecord.findAndCountAll.mockResolvedValue({ rows: [], count: 0 });

      await ctrl.list(
        mockReq({ query: { from_date: '2024-01-01', to_date: '2024-12-31' } }),
        mockRes(), mockNext
      );

      expect(MedicalRecord.findAndCountAll).toHaveBeenCalled();
    });

    it('should call next on error', async () => {
      MedicalRecord.findAndCountAll.mockRejectedValue(new Error('DB error'));

      await ctrl.list(mockReq({ query: {} }), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalled();
    });
  });

  describe('getByRabbit', () => {
    it('should return medical records for a rabbit', async () => {
      const rabbit = { id: 1 };
      Rabbit.findOne.mockResolvedValue(rabbit);
      MedicalRecord.findAll.mockResolvedValue([{ id: 1 }, { id: 2 }]);

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
      MedicalRecord.findAll.mockRejectedValue(new Error('DB error'));

      await ctrl.getByRabbit(mockReq({ params: { rabbitId: '1' } }), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  describe('update', () => {
    it('should update medical record successfully', async () => {
      const medicalRecord = {
        id: 1, outcome: 'ongoing', cost: 0, rabbit_id: 1,
        rabbit: { user_id: 1, update: jest.fn().mockResolvedValue(true) },
        update: jest.fn().mockResolvedValue(true)
      };
      MedicalRecord.findByPk
        .mockResolvedValueOnce(medicalRecord)  // first call in update
        .mockResolvedValueOnce({ id: 1 });     // second call to fetch updated

      const req = mockReq({ params: { id: '1' }, body: { notes: 'Better now' } });
      const res = mockRes();

      await ctrl.update(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
      expect(mockTx.commit).toHaveBeenCalled();
    });

    it('should return 404 if record not found', async () => {
      MedicalRecord.findByPk.mockResolvedValueOnce(null);

      const res = mockRes();
      await ctrl.update(mockReq({ params: { id: '999' }, body: {} }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should return 404 if record belongs to different user', async () => {
      const medicalRecord = { id: 1, rabbit: { user_id: 99 } }; // different user
      MedicalRecord.findByPk.mockResolvedValueOnce(medicalRecord);

      const res = mockRes();
      await ctrl.update(mockReq({ params: { id: '1' }, body: {} }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('should update rabbit to dead when outcome changes to died', async () => {
      const rabbitMock = { user_id: 1, update: jest.fn().mockResolvedValue(true) };
      const medicalRecord = {
        id: 1, outcome: 'ongoing', rabbit_id: 1,
        rabbit: rabbitMock,
        update: jest.fn().mockResolvedValue(true)
      };
      MedicalRecord.findByPk
        .mockResolvedValueOnce(medicalRecord)
        .mockResolvedValueOnce({ id: 1 });

      await ctrl.update(
        mockReq({ params: { id: '1' }, body: { outcome: 'died' } }),
        mockRes(), mockNext
      );

      expect(rabbitMock.update).toHaveBeenCalledWith({ status: 'dead', cage_id: null }, expect.any(Object));
    });

    it('should return 404 if new rabbit_id not found', async () => {
      const medicalRecord = {
        id: 1, outcome: null, rabbit_id: 1,
        rabbit: { user_id: 1 },
        update: jest.fn()
      };
      MedicalRecord.findByPk.mockResolvedValueOnce(medicalRecord);
      Rabbit.findOne.mockResolvedValueOnce(null);

      const res = mockRes();
      await ctrl.update(
        mockReq({ params: { id: '1' }, body: { rabbit_id: 99 } }),
        res, mockNext
      );

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should return 400 on SequelizeValidationError in update', async () => {
      const medicalRecord = {
        id: 1, outcome: 'ongoing', rabbit_id: 1,
        rabbit: { user_id: 1, update: jest.fn() },
        update: jest.fn().mockRejectedValue({
          name: 'SequelizeValidationError',
          errors: [{ message: 'Invalid value' }]
        })
      };
      MedicalRecord.findByPk.mockResolvedValueOnce(medicalRecord);

      const res = mockRes();
      await ctrl.update(mockReq({ params: { id: '1' }, body: {} }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(400);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next on unexpected error in update', async () => {
      const medicalRecord = {
        id: 1, outcome: 'ongoing', rabbit_id: 1,
        rabbit: { user_id: 1, update: jest.fn() },
        update: jest.fn().mockRejectedValue(new Error('DB error'))
      };
      MedicalRecord.findByPk.mockResolvedValueOnce(medicalRecord);

      await ctrl.update(mockReq({ params: { id: '1' }, body: {} }), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  describe('delete', () => {
    it('should delete medical record successfully', async () => {
      const medicalRecord = { id: 1, destroy: jest.fn().mockResolvedValue(true) };
      MedicalRecord.findOne.mockResolvedValue(medicalRecord);

      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await ctrl.delete(req, res, mockNext);

      expect(medicalRecord.destroy).toHaveBeenCalled();
      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should return 404 if not found', async () => {
      MedicalRecord.findOne.mockResolvedValue(null);

      const res = mockRes();
      await ctrl.delete(mockReq({ params: { id: '999' } }), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
    });

    it('should call next on error in delete', async () => {
      MedicalRecord.findOne.mockRejectedValue(new Error('DB error'));

      await ctrl.delete(mockReq({ params: { id: '1' } }), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  describe('getStatistics', () => {
    const setupStatsMocks = (overrides = {}) => {
      // Default mocks for all parallel queries in getStatistics
      MedicalRecord.count
        .mockResolvedValueOnce(overrides.total ?? 0)       // total
        .mockResolvedValueOnce(overrides.thisYear ?? 0)     // this_year
        .mockResolvedValueOnce(overrides.lastMonth ?? 0);   // last_month
      MedicalRecord.findAll
        .mockResolvedValueOnce(overrides.byOutcome ?? [])          // GROUP BY outcome
        .mockResolvedValueOnce(overrides.totalCost ?? [{ total_cost: null }]) // SUM cost
        .mockResolvedValueOnce(overrides.ongoingList ?? []);       // ongoing treatments
    };

    it('should return statistics with empty records', async () => {
      setupStatsMocks();

      const req = mockReq();
      const res = mockRes();

      await ctrl.getStatistics(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should compute statistics for records with cost and ongoing', async () => {
      const now = new Date();
      setupStatsMocks({
        total: 2,
        byOutcome: [
          { outcome: 'ongoing', count: '1' },
          { outcome: 'recovered', count: '1' }
        ],
        totalCost: [{ total_cost: '100' }],
        thisYear: 2,
        lastMonth: 2,
        ongoingList: [
          {
            id: 1, rabbit_id: 1,
            diagnosis: 'Cold', started_at: now.toISOString(), symptoms: 'Sneezing',
            rabbit: { name: 'Bunny' }
          }
        ]
      });

      const res = mockRes();
      await ctrl.getStatistics(mockReq(), res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
      const jsonArg = res.json.mock.calls[0][0];
      expect(jsonArg.data.total_records).toBe(2);
      expect(jsonArg.data.by_outcome.ongoing).toBe(1);
    });

    it('should call next on error', async () => {
      MedicalRecord.count.mockRejectedValue(new Error('DB error'));

      await ctrl.getStatistics(mockReq(), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  describe('getOngoing', () => {
    it('should return ongoing treatments with days_ongoing', async () => {
      const started = new Date();
      started.setDate(started.getDate() - 5);
      const records = [{
        id: 1, started_at: started.toISOString(),
        toJSON: jest.fn().mockReturnValue({ id: 1, started_at: started.toISOString() })
      }];
      MedicalRecord.findAll.mockResolvedValue(records);

      const req = mockReq();
      const res = mockRes();

      await ctrl.getOngoing(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
      const json = res.json.mock.calls[0][0];
      expect(json.data[0].days_ongoing).toBeGreaterThanOrEqual(4);
    });

    it('should call next on error', async () => {
      MedicalRecord.findAll.mockRejectedValue(new Error('DB error'));

      await ctrl.getOngoing(mockReq(), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });

  describe('getCosts', () => {
    it('should return costs without date filters', async () => {
      const records = [{ id: 1, cost: 50 }, { id: 2, cost: '30.50' }];
      MedicalRecord.findAll.mockResolvedValue(records);

      const req = mockReq({ query: {} });
      const res = mockRes();

      await ctrl.getCosts(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(200);
      const json = res.json.mock.calls[0][0];
      expect(json.data.count).toBe(2);
    });

    it('should apply from_date and to_date filters', async () => {
      MedicalRecord.findAll.mockResolvedValue([]);

      await ctrl.getCosts(
        mockReq({ query: { from_date: '2024-01-01', to_date: '2024-12-31' } }),
        mockRes(), mockNext
      );

      expect(MedicalRecord.findAll).toHaveBeenCalled();
    });

    it('should apply only from_date filter', async () => {
      MedicalRecord.findAll.mockResolvedValue([]);

      await ctrl.getCosts(
        mockReq({ query: { from_date: '2024-01-01' } }),
        mockRes(), mockNext
      );

      expect(MedicalRecord.findAll).toHaveBeenCalled();
    });

    it('should call next on error', async () => {
      MedicalRecord.findAll.mockRejectedValue(new Error('DB error'));

      await ctrl.getCosts(mockReq({ query: {} }), mockRes(), mockNext);

      expect(mockNext).toHaveBeenCalledWith(expect.any(Error));
    });
  });
});
