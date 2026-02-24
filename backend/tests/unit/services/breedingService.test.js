/**
 * Unit tests for BreedingService
 * Covers: createBreeding, getBreedingById, listBreedings, updateBreeding, deleteBreeding, getStatistics
 */
jest.mock('../../../src/models', () => {
  const mockSequelize = { transaction: jest.fn() };
  return {
    Breeding: {
      findOne: jest.fn(),
      findAll: jest.fn(),
      count: jest.fn(),
      create: jest.fn(),
      sequelize: mockSequelize
    },
    Rabbit: {
      findOne: jest.fn(),
      findByPk: jest.fn()
    },
    Task: {
      create: jest.fn()
    }
  };
});

jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

const { Breeding, Rabbit, Task } = require('../../../src/models');
const breedingService = require('../../../src/services/breedingService');

describe('BreedingService', () => {
  const mockTx = { commit: jest.fn(), rollback: jest.fn() };

  beforeEach(() => {
    jest.clearAllMocks();
    Breeding.sequelize.transaction.mockResolvedValue(mockTx);
  });

  describe('createBreeding', () => {
    const male = { id: 1, name: 'Buck', sex: 'male', status: 'healthy', cage_id: 10 };
    const female = { id: 2, name: 'Doe', sex: 'female', status: 'healthy', cage_id: 11 };
    const breedingData = {
      male_id: 1,
      female_id: 2,
      user_id: 1,
      breeding_date: '2024-05-01'
    };

    it('should create breeding with tasks when breeding_date provided', async () => {
      Rabbit.findOne
        .mockResolvedValueOnce(male)
        .mockResolvedValueOnce(female);
      Breeding.create.mockResolvedValue({ id: 1 });
      Task.create.mockResolvedValue({});
      const createdBreeding = { id: 1, male_id: 1, female_id: 2 };
      Breeding.findOne.mockResolvedValue(createdBreeding);

      const result = await breedingService.createBreeding(breedingData);

      expect(Breeding.create).toHaveBeenCalled();
      expect(Task.create).toHaveBeenCalledTimes(3);
      expect(mockTx.commit).toHaveBeenCalled();
      expect(result).toEqual(createdBreeding);
    });

    it('should create breeding without tasks when no breeding_date', async () => {
      const dataNoDate = { male_id: 1, female_id: 2, user_id: 1 };
      Rabbit.findOne
        .mockResolvedValueOnce(male)
        .mockResolvedValueOnce(female);
      Breeding.create.mockResolvedValue({ id: 2 });
      Breeding.findOne.mockResolvedValue({ id: 2 });

      await breedingService.createBreeding(dataNoDate);

      expect(Task.create).not.toHaveBeenCalled();
      expect(mockTx.commit).toHaveBeenCalled();
    });

    it('should calculate expected_birth_date when breeding_date provided but expected_birth_date missing', async () => {
      Rabbit.findOne
        .mockResolvedValueOnce(male)
        .mockResolvedValueOnce(female);
      Breeding.create.mockResolvedValue({ id: 3 });
      Task.create.mockResolvedValue({});
      Breeding.findOne.mockResolvedValue({ id: 3 });

      const data = { male_id: 1, female_id: 2, user_id: 1, breeding_date: '2024-05-01' };
      await breedingService.createBreeding(data);

      expect(data.expected_birth_date).toBe('2024-06-01');
    });

    it('should throw CANNOT_BREED_SAME_RABBIT when male_id === female_id', async () => {
      await expect(breedingService.createBreeding({ male_id: 1, female_id: 1, user_id: 1 }))
        .rejects.toThrow('CANNOT_BREED_SAME_RABBIT');
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should throw MALE_NOT_FOUND when male does not exist', async () => {
      Rabbit.findOne.mockResolvedValueOnce(null);

      await expect(breedingService.createBreeding(breedingData))
        .rejects.toThrow('MALE_NOT_FOUND');
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should throw INVALID_MALE_SEX when male is not male sex', async () => {
      Rabbit.findOne.mockResolvedValueOnce({ ...female, id: 1 });

      await expect(breedingService.createBreeding(breedingData))
        .rejects.toThrow('INVALID_MALE_SEX');
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should throw MALE_NOT_AVAILABLE when male is dead', async () => {
      Rabbit.findOne.mockResolvedValueOnce({ ...male, status: 'dead' });

      await expect(breedingService.createBreeding(breedingData))
        .rejects.toThrow('MALE_NOT_AVAILABLE');
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should throw MALE_NOT_AVAILABLE when male is sold', async () => {
      Rabbit.findOne.mockResolvedValueOnce({ ...male, status: 'sold' });

      await expect(breedingService.createBreeding(breedingData))
        .rejects.toThrow('MALE_NOT_AVAILABLE');
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should throw FEMALE_NOT_FOUND when female does not exist', async () => {
      Rabbit.findOne
        .mockResolvedValueOnce(male)
        .mockResolvedValueOnce(null);

      await expect(breedingService.createBreeding(breedingData))
        .rejects.toThrow('FEMALE_NOT_FOUND');
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should throw INVALID_FEMALE_SEX when female is not female sex', async () => {
      Rabbit.findOne
        .mockResolvedValueOnce(male)
        .mockResolvedValueOnce({ ...male, id: 2 });

      await expect(breedingService.createBreeding(breedingData))
        .rejects.toThrow('INVALID_FEMALE_SEX');
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should throw FEMALE_NOT_AVAILABLE when female is dead', async () => {
      Rabbit.findOne
        .mockResolvedValueOnce(male)
        .mockResolvedValueOnce({ ...female, status: 'dead' });

      await expect(breedingService.createBreeding(breedingData))
        .rejects.toThrow('FEMALE_NOT_AVAILABLE');
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should throw FEMALE_NOT_AVAILABLE when female is sold', async () => {
      Rabbit.findOne
        .mockResolvedValueOnce(male)
        .mockResolvedValueOnce({ ...female, status: 'sold' });

      await expect(breedingService.createBreeding(breedingData))
        .rejects.toThrow('FEMALE_NOT_AVAILABLE');
      expect(mockTx.rollback).toHaveBeenCalled();
    });
  });

  describe('getBreedingById', () => {
    it('should return breeding if found', async () => {
      const breeding = { id: 1, male_id: 1, female_id: 2 };
      Breeding.findOne.mockResolvedValue(breeding);

      const result = await breedingService.getBreedingById(1, 1);

      expect(result).toEqual(breeding);
    });

    it('should throw BREEDING_NOT_FOUND if not found', async () => {
      Breeding.findOne.mockResolvedValue(null);

      await expect(breedingService.getBreedingById(999, 1))
        .rejects.toThrow('BREEDING_NOT_FOUND');
    });
  });

  describe('listBreedings', () => {
    it('should return paginated list with defaults', async () => {
      Breeding.count.mockResolvedValue(3);
      Breeding.findAll.mockResolvedValue([{ id: 1 }, { id: 2 }, { id: 3 }]);

      const result = await breedingService.listBreedings(1);

      expect(result.items).toHaveLength(3);
      expect(result.pagination.total).toBe(3);
      expect(result.pagination.page).toBe(1);
    });

    it('should apply status filter', async () => {
      Breeding.count.mockResolvedValue(1);
      Breeding.findAll.mockResolvedValue([{ id: 1, status: 'planned' }]);

      await breedingService.listBreedings(1, { status: 'planned' });

      expect(Breeding.count).toHaveBeenCalledWith(
        expect.objectContaining({ where: expect.objectContaining({ status: 'planned' }) })
      );
    });

    it('should apply male_id and female_id filters', async () => {
      Breeding.count.mockResolvedValue(0);
      Breeding.findAll.mockResolvedValue([]);

      await breedingService.listBreedings(1, { male_id: 5, female_id: 6 });

      expect(Breeding.count).toHaveBeenCalledWith(
        expect.objectContaining({ where: expect.objectContaining({ male_id: 5, female_id: 6 }) })
      );
    });

    it('should apply from_date and to_date filters', async () => {
      Breeding.count.mockResolvedValue(0);
      Breeding.findAll.mockResolvedValue([]);

      await breedingService.listBreedings(1, { from_date: '2024-01-01', to_date: '2024-12-31' });

      expect(Breeding.count).toHaveBeenCalledWith(
        expect.objectContaining({
          where: expect.objectContaining({ breeding_date: expect.any(Object) })
        })
      );
    });

    it('should apply from_date only', async () => {
      Breeding.count.mockResolvedValue(0);
      Breeding.findAll.mockResolvedValue([]);

      await breedingService.listBreedings(1, { from_date: '2024-01-01' });

      expect(Breeding.count).toHaveBeenCalled();
    });

    it('should apply to_date only', async () => {
      Breeding.count.mockResolvedValue(0);
      Breeding.findAll.mockResolvedValue([]);

      await breedingService.listBreedings(1, { to_date: '2024-12-31' });

      expect(Breeding.count).toHaveBeenCalled();
    });

    it('should apply pagination options', async () => {
      Breeding.count.mockResolvedValue(10);
      Breeding.findAll.mockResolvedValue([]);

      const result = await breedingService.listBreedings(1, {}, { page: 2, limit: 5 });

      expect(result.pagination.page).toBe(2);
      expect(result.pagination.limit).toBe(5);
    });
  });

  describe('updateBreeding', () => {
    const existingBreeding = {
      id: 1,
      male_id: 1,
      female_id: 2,
      user_id: 1,
      update: jest.fn().mockResolvedValue(true)
    };

    it('should update breeding successfully', async () => {
      Breeding.findOne
        .mockResolvedValueOnce(existingBreeding) // findOne in updateBreeding
        .mockResolvedValueOnce({ id: 1 }); // getBreedingById at end
      existingBreeding.update.mockResolvedValue(true);

      const result = await breedingService.updateBreeding(1, 1, { status: 'completed' });

      expect(existingBreeding.update).toHaveBeenCalledWith({ status: 'completed' }, { transaction: mockTx });
      expect(mockTx.commit).toHaveBeenCalled();
    });

    it('should throw BREEDING_NOT_FOUND if not found', async () => {
      Breeding.findOne.mockResolvedValueOnce(null);

      await expect(breedingService.updateBreeding(999, 1, {}))
        .rejects.toThrow('BREEDING_NOT_FOUND');
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should throw INVALID_MALE when male_id update uses invalid rabbit', async () => {
      Breeding.findOne.mockResolvedValueOnce(existingBreeding);
      Rabbit.findOne.mockResolvedValueOnce(null); // male not found

      await expect(breedingService.updateBreeding(1, 1, { male_id: 99 }))
        .rejects.toThrow('INVALID_MALE');
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should validate male_id update successfully', async () => {
      const breeding = { ...existingBreeding, update: jest.fn().mockResolvedValue(true) };
      Breeding.findOne
        .mockResolvedValueOnce(breeding)
        .mockResolvedValueOnce({ id: 1 });
      Rabbit.findOne.mockResolvedValueOnce({ id: 3, sex: 'male' }); // valid male

      await breedingService.updateBreeding(1, 1, { male_id: 3 });

      expect(breeding.update).toHaveBeenCalled();
    });

    it('should throw CANNOT_BREED_SAME_RABBIT when female_id equals male_id', async () => {
      Breeding.findOne.mockResolvedValueOnce({ ...existingBreeding, male_id: 5 });
      Rabbit.findOne.mockResolvedValueOnce({ id: 5, sex: 'male' }); // male check passes

      await expect(breedingService.updateBreeding(1, 1, { female_id: 5, male_id: 5 }))
        .rejects.toThrow('CANNOT_BREED_SAME_RABBIT');
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should throw CANNOT_BREED_SAME_RABBIT when female_id equals existing male_id', async () => {
      Breeding.findOne.mockResolvedValueOnce({ ...existingBreeding, male_id: 7 });

      await expect(breedingService.updateBreeding(1, 1, { female_id: 7 }))
        .rejects.toThrow('CANNOT_BREED_SAME_RABBIT');
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should throw INVALID_FEMALE when female_id update uses invalid rabbit', async () => {
      Breeding.findOne.mockResolvedValueOnce({ ...existingBreeding, male_id: 1 });
      Rabbit.findOne.mockResolvedValueOnce(null); // female not found

      await expect(breedingService.updateBreeding(1, 1, { female_id: 99 }))
        .rejects.toThrow('INVALID_FEMALE');
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should throw FEMALE_NOT_AVAILABLE when female is dead', async () => {
      Breeding.findOne.mockResolvedValueOnce({ ...existingBreeding, male_id: 1 });
      Rabbit.findOne.mockResolvedValueOnce({ id: 99, sex: 'female', status: 'dead' });

      await expect(breedingService.updateBreeding(1, 1, { female_id: 99 }))
        .rejects.toThrow('FEMALE_NOT_AVAILABLE');
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should update female status to pregnant when is_pregnant=true', async () => {
      const breeding = { id: 1, male_id: 1, female_id: 2, update: jest.fn().mockResolvedValue(true) };
      const femaleMock = { id: 2, status: 'healthy', update: jest.fn().mockResolvedValue(true) };
      Breeding.findOne
        .mockResolvedValueOnce(breeding)
        .mockResolvedValueOnce({ id: 1 });
      Rabbit.findByPk.mockResolvedValueOnce(femaleMock);

      await breedingService.updateBreeding(1, 1, { is_pregnant: true });

      expect(femaleMock.update).toHaveBeenCalledWith({ status: 'pregnant' }, expect.any(Object));
    });

    it('should revert female from pregnant when is_pregnant=false', async () => {
      const breeding = { id: 1, male_id: 1, female_id: 2, update: jest.fn().mockResolvedValue(true) };
      const femaleMock = { id: 2, status: 'pregnant', update: jest.fn().mockResolvedValue(true) };
      Breeding.findOne
        .mockResolvedValueOnce(breeding)
        .mockResolvedValueOnce({ id: 1 });
      Rabbit.findByPk.mockResolvedValueOnce(femaleMock);

      await breedingService.updateBreeding(1, 1, { is_pregnant: false });

      expect(femaleMock.update).toHaveBeenCalledWith({ status: 'active' }, expect.any(Object));
    });

    it('should revert female from pregnant when status=failed', async () => {
      const breeding = { id: 1, male_id: 1, female_id: 2, update: jest.fn().mockResolvedValue(true) };
      const femaleMock = { id: 2, status: 'pregnant', update: jest.fn().mockResolvedValue(true) };
      Breeding.findOne
        .mockResolvedValueOnce(breeding)
        .mockResolvedValueOnce({ id: 1 });
      Rabbit.findByPk.mockResolvedValueOnce(femaleMock);

      await breedingService.updateBreeding(1, 1, { status: 'failed' });

      expect(femaleMock.update).toHaveBeenCalledWith({ status: 'active' }, expect.any(Object));
    });

    it('should not revert female if female status is not pregnant', async () => {
      const breeding = { id: 1, male_id: 1, female_id: 2, update: jest.fn().mockResolvedValue(true) };
      const femaleMock = { id: 2, status: 'healthy', update: jest.fn().mockResolvedValue(true) };
      Breeding.findOne
        .mockResolvedValueOnce(breeding)
        .mockResolvedValueOnce({ id: 1 });
      Rabbit.findByPk.mockResolvedValueOnce(femaleMock);

      await breedingService.updateBreeding(1, 1, { is_pregnant: false });

      expect(femaleMock.update).not.toHaveBeenCalled();
    });
  });

  describe('deleteBreeding', () => {
    it('should delete breeding successfully', async () => {
      const breeding = { id: 1, destroy: jest.fn().mockResolvedValue(true) };
      Breeding.findOne.mockResolvedValue(breeding);

      const result = await breedingService.deleteBreeding(1, 1);

      expect(breeding.destroy).toHaveBeenCalled();
      expect(result).toEqual({ success: true });
    });

    it('should throw BREEDING_NOT_FOUND if not found', async () => {
      Breeding.findOne.mockResolvedValue(null);

      await expect(breedingService.deleteBreeding(999, 1))
        .rejects.toThrow('BREEDING_NOT_FOUND');
    });
  });

  describe('getStatistics', () => {
    it('should return statistics with success rate', async () => {
      Breeding.count
        .mockResolvedValueOnce(10) // total
        .mockResolvedValueOnce(3)  // planned
        .mockResolvedValueOnce(5)  // completed
        .mockResolvedValueOnce(2); // failed

      const result = await breedingService.getStatistics(1);

      expect(result.total).toBe(10);
      expect(result.planned).toBe(3);
      expect(result.completed).toBe(5);
      expect(result.failed).toBe(2);
      expect(result.success_rate).toBe(71); // 5/(5+2)*100 = 71.4 → 71
    });

    it('should return 0 success rate when no completed or failed records', async () => {
      Breeding.count
        .mockResolvedValueOnce(2)  // total
        .mockResolvedValueOnce(2)  // planned
        .mockResolvedValueOnce(0)  // completed
        .mockResolvedValueOnce(0); // failed

      const result = await breedingService.getStatistics(1);

      expect(result.success_rate).toBe(0);
    });
  });
});
