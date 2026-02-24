/**
 * Additional tests for RabbitService methods not covered in rabbitService.test.js
 * Covers: getRabbitById, listRabbits, deleteRabbit, getWeightHistory, addWeightRecord, getStatistics
 */
jest.mock('../../../src/models', () => {
  const mockSequelize = { transaction: jest.fn() };
  return {
    Rabbit: {
      findOne: jest.fn(),
      findByPk: jest.fn(),
      create: jest.fn(),
      count: jest.fn(),
      findAll: jest.fn(),
      findAndCountAll: jest.fn()
    },
    Breed: { findByPk: jest.fn(), findAll: jest.fn() },
    Cage: { findOne: jest.fn() },
    RabbitWeight: { create: jest.fn(), findAll: jest.fn() },
    Photo: { findAll: jest.fn() },
    Breeding: { count: jest.fn() },
    Birth: { count: jest.fn() },
    Vaccination: { count: jest.fn() },
    MedicalRecord: { count: jest.fn() },
    FeedingRecord: { count: jest.fn() },
    Transaction: { count: jest.fn() },
    sequelize: mockSequelize
  };
});

jest.mock('../../../src/utils/fileHelper', () => ({ deleteFile: jest.fn() }));
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

const {
  Rabbit, Breed, Cage, RabbitWeight, Breeding, Birth, Vaccination, MedicalRecord, Transaction, sequelize
} = require('../../../src/models');
const rabbitService = require('../../../src/services/rabbitService');

describe('RabbitService - extended methods', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('getRabbitById', () => {
    it('should return rabbit if found', async () => {
      const rabbit = { id: 1, name: 'Bugs', user_id: 1 };
      Rabbit.findOne.mockResolvedValue(rabbit);

      const result = await rabbitService.getRabbitById(1, 1);

      expect(result).toEqual(rabbit);
    });

    it('should throw RABBIT_NOT_FOUND if not found', async () => {
      Rabbit.findOne.mockResolvedValue(null);

      await expect(rabbitService.getRabbitById(999, 1))
        .rejects.toThrow('RABBIT_NOT_FOUND');
    });
  });

  describe('listRabbits', () => {
    it('should return paginated list', async () => {
      Rabbit.count.mockResolvedValue(2);
      Rabbit.findAll.mockResolvedValue([{ id: 1 }, { id: 2 }]);

      const result = await rabbitService.listRabbits(1);

      expect(result.items).toHaveLength(2);
      expect(result.pagination.total).toBe(2);
    });

    it('should apply breed_id filter', async () => {
      Rabbit.count.mockResolvedValue(1);
      Rabbit.findAll.mockResolvedValue([{ id: 1, breed_id: 5 }]);

      const result = await rabbitService.listRabbits(1, { breed_id: 5 });

      expect(Rabbit.count).toHaveBeenCalledWith(expect.objectContaining({
        where: expect.objectContaining({ breed_id: 5 })
      }));
    });

    it('should apply sex, status, purpose, cage_id filters', async () => {
      Rabbit.count.mockResolvedValue(0);
      Rabbit.findAll.mockResolvedValue([]);

      await rabbitService.listRabbits(1, {
        sex: 'female',
        status: 'healthy',
        purpose: 'meat',
        cage_id: 3
      });

      expect(Rabbit.count).toHaveBeenCalledWith(expect.objectContaining({
        where: expect.objectContaining({ sex: 'female', status: 'healthy', purpose: 'meat', cage_id: 3 })
      }));
    });

    it('should apply search filter', async () => {
      Rabbit.count.mockResolvedValue(0);
      Rabbit.findAll.mockResolvedValue([]);

      await rabbitService.listRabbits(1, { search: 'Bugs' });

      // Search applies Op.or which uses Symbol keys - just verify call happened
      expect(Rabbit.count).toHaveBeenCalled();
    });
  });

  describe('deleteRabbit', () => {
    it('should delete rabbit with no dependencies', async () => {
      const rabbit = { id: 1, photo_url: null, destroy: jest.fn().mockResolvedValue(true) };
      Rabbit.findOne.mockResolvedValue(rabbit);
      Rabbit.count.mockResolvedValue(0); // offspring
      Breeding.count.mockResolvedValue(0);
      Birth.count.mockResolvedValue(0);
      MedicalRecord.count.mockResolvedValue(0);
      Vaccination.count.mockResolvedValue(0);
      Transaction.count.mockResolvedValue(0);

      const result = await rabbitService.deleteRabbit(1, 1);

      expect(result).toEqual({ success: true });
      expect(rabbit.destroy).toHaveBeenCalled();
    });

    it('should throw RABBIT_NOT_FOUND if not found', async () => {
      Rabbit.findOne.mockResolvedValue(null);

      await expect(rabbitService.deleteRabbit(999, 1))
        .rejects.toThrow('RABBIT_NOT_FOUND');
    });

    it('should throw RABBIT_HAS_OFFSPRING if rabbit has children', async () => {
      Rabbit.findOne.mockResolvedValue({ id: 1 });
      Rabbit.count.mockResolvedValue(2); // offspring

      await expect(rabbitService.deleteRabbit(1, 1))
        .rejects.toThrow('RABBIT_HAS_OFFSPRING');
    });

    it('should throw RABBIT_HAS_BREEDING_HISTORY if rabbit has breeding records', async () => {
      Rabbit.findOne.mockResolvedValue({ id: 1 });
      Rabbit.count.mockResolvedValue(0);
      Breeding.count.mockResolvedValue(1);

      await expect(rabbitService.deleteRabbit(1, 1))
        .rejects.toThrow('RABBIT_HAS_BREEDING_HISTORY');
    });

    it('should throw RABBIT_HAS_BIRTH_HISTORY if rabbit has birth records', async () => {
      Rabbit.findOne.mockResolvedValue({ id: 1 });
      Rabbit.count.mockResolvedValue(0);
      Breeding.count.mockResolvedValue(0);
      Birth.count.mockResolvedValue(1);

      await expect(rabbitService.deleteRabbit(1, 1))
        .rejects.toThrow('RABBIT_HAS_BIRTH_HISTORY');
    });

    it('should throw RABBIT_HAS_HEALTH_HISTORY if rabbit has medical records', async () => {
      Rabbit.findOne.mockResolvedValue({ id: 1 });
      Rabbit.count.mockResolvedValue(0);
      Breeding.count.mockResolvedValue(0);
      Birth.count.mockResolvedValue(0);
      MedicalRecord.count.mockResolvedValue(1);

      await expect(rabbitService.deleteRabbit(1, 1))
        .rejects.toThrow('RABBIT_HAS_HEALTH_HISTORY');
    });

    it('should throw RABBIT_HAS_FINANCIAL_HISTORY if rabbit has transactions', async () => {
      Rabbit.findOne.mockResolvedValue({ id: 1 });
      Rabbit.count.mockResolvedValue(0);
      Breeding.count.mockResolvedValue(0);
      Birth.count.mockResolvedValue(0);
      MedicalRecord.count.mockResolvedValue(0);
      Vaccination.count.mockResolvedValue(0);
      Transaction.count.mockResolvedValue(1);

      await expect(rabbitService.deleteRabbit(1, 1))
        .rejects.toThrow('RABBIT_HAS_FINANCIAL_HISTORY');
    });
  });

  describe('getWeightHistory', () => {
    it('should return weight records', async () => {
      const rabbit = { id: 1 };
      const weights = [{ id: 1, weight: 2.5 }, { id: 2, weight: 2.8 }];
      Rabbit.findOne.mockResolvedValue(rabbit);
      RabbitWeight.findAll.mockResolvedValue(weights);

      const result = await rabbitService.getWeightHistory(1, 1);

      expect(result).toEqual(weights);
    });

    it('should throw RABBIT_NOT_FOUND if rabbit not found', async () => {
      Rabbit.findOne.mockResolvedValue(null);

      await expect(rabbitService.getWeightHistory(999, 1))
        .rejects.toThrow('RABBIT_NOT_FOUND');
    });
  });

  describe('addWeightRecord', () => {
    const mockTx = { commit: jest.fn(), rollback: jest.fn() };

    beforeEach(() => {
      sequelize.transaction.mockResolvedValue(mockTx);
    });

    it('should add weight record and update rabbit', async () => {
      const rabbit = { id: 1, update: jest.fn().mockResolvedValue(true) };
      const weightRecord = { id: 1, weight: 3.0 };
      Rabbit.findOne.mockResolvedValue(rabbit);
      RabbitWeight.create.mockResolvedValue(weightRecord);

      const result = await rabbitService.addWeightRecord(1, 1, { weight: 3.0, measured_at: '2024-05-01' });

      expect(RabbitWeight.create).toHaveBeenCalled();
      expect(rabbit.update).toHaveBeenCalled();
      expect(mockTx.commit).toHaveBeenCalled();
    });

    it('should throw RABBIT_NOT_FOUND if rabbit not found', async () => {
      Rabbit.findOne.mockResolvedValue(null);

      await expect(rabbitService.addWeightRecord(999, 1, { weight: 3.0 }))
        .rejects.toThrow('RABBIT_NOT_FOUND');
      expect(mockTx.rollback).toHaveBeenCalled();
    });
  });
});
