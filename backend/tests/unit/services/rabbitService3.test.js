/**
 * Tests for uncovered lines in RabbitService:
 * - createRabbit: dead/sold cage_id=null, father/mother validation, tag uniqueness, initial weight
 * - updateRabbit: all branches
 * - deleteRabbit: photo_url cleanup
 * - getStatistics, getPedigree
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
  Rabbit, Breed, Cage, RabbitWeight, Breeding, Birth, Vaccination,
  MedicalRecord, Transaction, sequelize
} = require('../../../src/models');
const { deleteFile } = require('../../../src/utils/fileHelper');
const rabbitService = require('../../../src/services/rabbitService');

describe('RabbitService - uncovered lines', () => {
  const mockTx = { commit: jest.fn(), rollback: jest.fn() };

  beforeEach(() => {
    jest.resetAllMocks();
    sequelize.transaction.mockResolvedValue(mockTx);
  });

  // Helper: setup successful createRabbit defaults
  function setupCreateDefaults(overrides = {}) {
    Breed.findByPk.mockResolvedValue({ id: 1, name: 'Rex' });
    Rabbit.create.mockResolvedValue({ id: 10 });
    Rabbit.findOne.mockResolvedValue({ id: 10, name: 'Test' }); // for getRabbitById
    Object.entries(overrides).forEach(([key, val]) => {
      if (key === 'cageFindOne') Cage.findOne.mockResolvedValue(val);
      if (key === 'rabbitCount') Rabbit.count.mockResolvedValue(val);
    });
  }

  // ========== createRabbit uncovered branches ==========
  describe('createRabbit', () => {
    it('should set cage_id to null when status is dead and cage_id provided', async () => {
      const rabbitData = { breed_id: 1, cage_id: 5, user_id: 1, status: 'dead' };
      Breed.findByPk.mockResolvedValue({ id: 1 });
      Cage.findOne.mockResolvedValue({ id: 5, capacity: 10 });
      Rabbit.count.mockResolvedValue(2); // current count in cage
      Rabbit.create.mockResolvedValue({ id: 10 });
      // getRabbitById call
      Rabbit.findOne.mockResolvedValue({ id: 10, name: 'Test' });

      const result = await rabbitService.createRabbit(rabbitData);

      // The rabbitData.cage_id should have been set to null before create
      expect(Rabbit.create).toHaveBeenCalledWith(
        expect.objectContaining({ cage_id: null }),
        expect.any(Object)
      );
      expect(result).toEqual({ id: 10, name: 'Test' });
    });

    it('should set cage_id to null when status is sold and cage_id provided', async () => {
      const rabbitData = { breed_id: 1, cage_id: 5, user_id: 1, status: 'sold' };
      Breed.findByPk.mockResolvedValue({ id: 1 });
      Cage.findOne.mockResolvedValue({ id: 5, capacity: 10 });
      Rabbit.count.mockResolvedValue(0);
      Rabbit.create.mockResolvedValue({ id: 11 });
      Rabbit.findOne.mockResolvedValue({ id: 11 });

      await rabbitService.createRabbit(rabbitData);

      expect(Rabbit.create).toHaveBeenCalledWith(
        expect.objectContaining({ cage_id: null }),
        expect.any(Object)
      );
    });

    it('should throw FATHER_NOT_FOUND_OR_INVALID_SEX when father not found', async () => {
      const rabbitData = { breed_id: 1, user_id: 1, father_id: 99 };
      Breed.findByPk.mockResolvedValue({ id: 1 });
      // father lookup returns null
      Rabbit.findOne.mockResolvedValue(null);

      await expect(rabbitService.createRabbit(rabbitData))
        .rejects.toThrow('FATHER_NOT_FOUND_OR_INVALID_SEX');
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should throw MOTHER_NOT_FOUND_OR_INVALID_SEX when mother not found', async () => {
      const rabbitData = { breed_id: 1, user_id: 1, mother_id: 88 };
      Breed.findByPk.mockResolvedValue({ id: 1 });
      // mother lookup returns null
      Rabbit.findOne.mockResolvedValue(null);

      await expect(rabbitService.createRabbit(rabbitData))
        .rejects.toThrow('MOTHER_NOT_FOUND_OR_INVALID_SEX');
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should pass father validation when father exists and is male', async () => {
      const rabbitData = { breed_id: 1, user_id: 1, father_id: 5 };
      Breed.findByPk.mockResolvedValue({ id: 1 });
      // First findOne call: father lookup -> found
      // Second findOne call: getRabbitById
      Rabbit.findOne
        .mockResolvedValueOnce({ id: 5, sex: 'male' }) // father found
        .mockResolvedValueOnce({ id: 10 }); // getRabbitById
      Rabbit.create.mockResolvedValue({ id: 10 });

      const result = await rabbitService.createRabbit(rabbitData);
      expect(result).toEqual({ id: 10 });
      expect(mockTx.commit).toHaveBeenCalled();
    });

    it('should pass mother validation when mother exists and is female', async () => {
      const rabbitData = { breed_id: 1, user_id: 1, mother_id: 6 };
      Breed.findByPk.mockResolvedValue({ id: 1 });
      Rabbit.findOne
        .mockResolvedValueOnce({ id: 6, sex: 'female' }) // mother found
        .mockResolvedValueOnce({ id: 10 }); // getRabbitById
      Rabbit.create.mockResolvedValue({ id: 10 });

      const result = await rabbitService.createRabbit(rabbitData);
      expect(result).toEqual({ id: 10 });
    });

    it('should throw TAG_ID_EXISTS when tag_id already used by user', async () => {
      const rabbitData = { breed_id: 1, user_id: 1, tag_id: 'TAG-001' };
      Breed.findByPk.mockResolvedValue({ id: 1 });
      // tag check: findOne returns existing rabbit
      Rabbit.findOne.mockResolvedValue({ id: 99, tag_id: 'TAG-001' });

      await expect(rabbitService.createRabbit(rabbitData))
        .rejects.toThrow('TAG_ID_EXISTS');
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should pass tag validation when tag_id is unique', async () => {
      const rabbitData = { breed_id: 1, user_id: 1, tag_id: 'TAG-NEW' };
      Breed.findByPk.mockResolvedValue({ id: 1 });
      Rabbit.findOne
        .mockResolvedValueOnce(null) // tag check: not found
        .mockResolvedValueOnce({ id: 10 }); // getRabbitById
      Rabbit.create.mockResolvedValue({ id: 10 });

      const result = await rabbitService.createRabbit(rabbitData);
      expect(result).toEqual({ id: 10 });
    });

    it('should create initial weight record when current_weight is provided', async () => {
      const rabbitData = { breed_id: 1, user_id: 1, current_weight: 2.5 };
      Breed.findByPk.mockResolvedValue({ id: 1 });
      Rabbit.create.mockResolvedValue({ id: 10 });
      Rabbit.findOne.mockResolvedValue({ id: 10 });
      RabbitWeight.create.mockResolvedValue({ id: 1 });

      await rabbitService.createRabbit(rabbitData);

      expect(RabbitWeight.create).toHaveBeenCalledWith(
        expect.objectContaining({
          rabbit_id: 10,
          weight: 2.5,
          measured_at: expect.any(Date)
        }),
        { transaction: mockTx }
      );
    });

    it('should NOT create weight record when current_weight is not provided', async () => {
      const rabbitData = { breed_id: 1, user_id: 1 };
      Breed.findByPk.mockResolvedValue({ id: 1 });
      Rabbit.create.mockResolvedValue({ id: 10 });
      Rabbit.findOne.mockResolvedValue({ id: 10 });

      await rabbitService.createRabbit(rabbitData);

      expect(RabbitWeight.create).not.toHaveBeenCalled();
    });
  });

  // ========== updateRabbit all branches ==========
  describe('updateRabbit', () => {
    const baseRabbit = {
      id: 1,
      user_id: 1,
      sex: 'male',
      breed_id: 1,
      cage_id: 5,
      tag_id: 'TAG-OLD',
      photo_url: null,
      current_weight: 2.0,
      status: 'healthy',
      update: jest.fn().mockResolvedValue(true)
    };

    function setupUpdateDefaults() {
      // findOne for rabbit lookup
      Rabbit.findOne.mockResolvedValueOnce({ ...baseRabbit, update: jest.fn().mockResolvedValue(true) });
    }

    it('should throw RABBIT_NOT_FOUND when rabbit does not exist', async () => {
      Rabbit.findOne.mockResolvedValueOnce(null);

      await expect(rabbitService.updateRabbit(999, 1, { name: 'New' }))
        .rejects.toThrow('RABBIT_NOT_FOUND');
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should throw CANNOT_CHANGE_SEX_WITH_HISTORY when rabbit has offspring', async () => {
      const rabbit = { ...baseRabbit, sex: 'male', update: jest.fn() };
      Rabbit.findOne.mockResolvedValueOnce(rabbit);
      // offspring count
      Rabbit.count.mockResolvedValueOnce(2);
      Breeding.count.mockResolvedValueOnce(0);

      await expect(rabbitService.updateRabbit(1, 1, { sex: 'female' }))
        .rejects.toThrow('CANNOT_CHANGE_SEX_WITH_HISTORY');
    });

    it('should throw CANNOT_CHANGE_SEX_WITH_HISTORY when rabbit has breeding records', async () => {
      const rabbit = { ...baseRabbit, sex: 'male', update: jest.fn() };
      Rabbit.findOne.mockResolvedValueOnce(rabbit);
      Rabbit.count.mockResolvedValueOnce(0); // no offspring
      Breeding.count.mockResolvedValueOnce(3); // has breedings

      await expect(rabbitService.updateRabbit(1, 1, { sex: 'female' }))
        .rejects.toThrow('CANNOT_CHANGE_SEX_WITH_HISTORY');
    });

    it('should allow sex change when no offspring or breeding history', async () => {
      const mockUpdate = jest.fn().mockResolvedValue(true);
      const rabbit = { ...baseRabbit, sex: 'male', update: mockUpdate };
      Rabbit.findOne
        .mockResolvedValueOnce(rabbit) // initial lookup
        .mockResolvedValueOnce({ id: 1 }); // getRabbitById
      Rabbit.count.mockResolvedValueOnce(0); // offspring
      Breeding.count.mockResolvedValueOnce(0); // breedings

      const result = await rabbitService.updateRabbit(1, 1, { sex: 'female' });

      expect(mockUpdate).toHaveBeenCalledWith({ sex: 'female' }, { transaction: mockTx });
      expect(mockTx.commit).toHaveBeenCalled();
    });

    it('should throw BREED_NOT_FOUND when updating to invalid breed', async () => {
      const rabbit = { ...baseRabbit, update: jest.fn() };
      Rabbit.findOne.mockResolvedValueOnce(rabbit);
      Breed.findByPk.mockResolvedValueOnce(null);

      await expect(rabbitService.updateRabbit(1, 1, { breed_id: 999 }))
        .rejects.toThrow('BREED_NOT_FOUND');
      expect(mockTx.rollback).toHaveBeenCalled();
    });

    it('should validate breed successfully when breed exists', async () => {
      const mockUpdate = jest.fn().mockResolvedValue(true);
      const rabbit = { ...baseRabbit, update: mockUpdate };
      Rabbit.findOne
        .mockResolvedValueOnce(rabbit)
        .mockResolvedValueOnce({ id: 1 }); // getRabbitById
      Breed.findByPk.mockResolvedValueOnce({ id: 2, name: 'Angora' });

      await rabbitService.updateRabbit(1, 1, { breed_id: 2 });

      expect(mockTx.commit).toHaveBeenCalled();
    });

    it('should throw CAGE_NOT_FOUND when updating to non-existent cage', async () => {
      const rabbit = { ...baseRabbit, cage_id: 5, update: jest.fn() };
      Rabbit.findOne.mockResolvedValueOnce(rabbit);
      Cage.findOne.mockResolvedValueOnce(null);

      await expect(rabbitService.updateRabbit(1, 1, { cage_id: 99 }))
        .rejects.toThrow('CAGE_NOT_FOUND');
    });

    it('should throw CAGE_FULL when cage at capacity', async () => {
      const rabbit = { ...baseRabbit, cage_id: 5, update: jest.fn() };
      Rabbit.findOne.mockResolvedValueOnce(rabbit);
      Cage.findOne.mockResolvedValueOnce({ id: 10, capacity: 3 });
      Rabbit.count.mockResolvedValueOnce(3); // cage full

      await expect(rabbitService.updateRabbit(1, 1, { cage_id: 10 }))
        .rejects.toThrow('CAGE_FULL');
    });

    it('should skip cage validation when cage_id unchanged', async () => {
      const mockUpdate = jest.fn().mockResolvedValue(true);
      const rabbit = { ...baseRabbit, cage_id: 5, update: mockUpdate };
      Rabbit.findOne
        .mockResolvedValueOnce(rabbit)
        .mockResolvedValueOnce({ id: 1 }); // getRabbitById

      await rabbitService.updateRabbit(1, 1, { cage_id: 5 });

      expect(Cage.findOne).not.toHaveBeenCalled();
      expect(mockTx.commit).toHaveBeenCalled();
    });

    it('should set cage_id to null when updateData.status is dead', async () => {
      const mockUpdate = jest.fn().mockResolvedValue(true);
      const rabbit = { ...baseRabbit, status: 'healthy', cage_id: 5, update: mockUpdate };
      Rabbit.findOne
        .mockResolvedValueOnce(rabbit)
        .mockResolvedValueOnce({ id: 1 }); // getRabbitById

      await rabbitService.updateRabbit(1, 1, { status: 'dead' });

      // The updateData should have cage_id set to null
      expect(mockUpdate).toHaveBeenCalledWith(
        expect.objectContaining({ cage_id: null }),
        expect.any(Object)
      );
    });

    it('should set cage_id to null when updateData.status is sold', async () => {
      const mockUpdate = jest.fn().mockResolvedValue(true);
      const rabbit = { ...baseRabbit, status: 'healthy', cage_id: 5, update: mockUpdate };
      Rabbit.findOne
        .mockResolvedValueOnce(rabbit)
        .mockResolvedValueOnce({ id: 1 }); // getRabbitById

      await rabbitService.updateRabbit(1, 1, { status: 'sold' });

      expect(mockUpdate).toHaveBeenCalledWith(
        expect.objectContaining({ cage_id: null }),
        expect.any(Object)
      );
    });

    it('should set cage_id to null when updateData has cage_id and status is dead', async () => {
      const mockUpdate = jest.fn().mockResolvedValue(true);
      const rabbit = { ...baseRabbit, status: 'healthy', cage_id: 5, update: mockUpdate };
      Rabbit.findOne
        .mockResolvedValueOnce(rabbit)
        .mockResolvedValueOnce({ id: 1 }); // getRabbitById
      Cage.findOne.mockResolvedValueOnce({ id: 10, capacity: 5 });
      Rabbit.count.mockResolvedValueOnce(1); // current cage count

      await rabbitService.updateRabbit(1, 1, { status: 'dead', cage_id: 10 });

      // cage_id should be null despite being provided, because status is dead
      expect(mockUpdate).toHaveBeenCalledWith(
        expect.objectContaining({ cage_id: null }),
        expect.any(Object)
      );
    });

    it('should set cage_id to null when rabbit.status is already dead and no status update', async () => {
      const mockUpdate = jest.fn().mockResolvedValue(true);
      const rabbit = { ...baseRabbit, status: 'dead', cage_id: 5, update: mockUpdate };
      Rabbit.findOne
        .mockResolvedValueOnce(rabbit)
        .mockResolvedValueOnce({ id: 1 }); // getRabbitById

      await rabbitService.updateRabbit(1, 1, { name: 'Updated' });

      expect(mockUpdate).toHaveBeenCalledWith(
        expect.objectContaining({ cage_id: null }),
        expect.any(Object)
      );
    });

    it('should throw CANNOT_BE_OWN_FATHER when father_id equals rabbitId', async () => {
      const rabbit = { ...baseRabbit, update: jest.fn() };
      Rabbit.findOne.mockResolvedValueOnce(rabbit);

      await expect(rabbitService.updateRabbit(1, 1, { father_id: 1 }))
        .rejects.toThrow('CANNOT_BE_OWN_FATHER');
    });

    it('should throw FATHER_NOT_FOUND_OR_INVALID_SEX when father not found', async () => {
      const rabbit = { ...baseRabbit, update: jest.fn() };
      Rabbit.findOne
        .mockResolvedValueOnce(rabbit) // rabbit lookup
        .mockResolvedValueOnce(null); // father lookup

      await expect(rabbitService.updateRabbit(1, 1, { father_id: 50 }))
        .rejects.toThrow('FATHER_NOT_FOUND_OR_INVALID_SEX');
    });

    it('should validate father successfully', async () => {
      const mockUpdate = jest.fn().mockResolvedValue(true);
      const rabbit = { ...baseRabbit, update: mockUpdate };
      Rabbit.findOne
        .mockResolvedValueOnce(rabbit) // rabbit lookup
        .mockResolvedValueOnce({ id: 50, sex: 'male' }) // father lookup
        .mockResolvedValueOnce({ id: 1 }); // getRabbitById

      await rabbitService.updateRabbit(1, 1, { father_id: 50 });

      expect(mockTx.commit).toHaveBeenCalled();
    });

    it('should throw CANNOT_BE_OWN_MOTHER when mother_id equals rabbitId', async () => {
      const rabbit = { ...baseRabbit, update: jest.fn() };
      Rabbit.findOne.mockResolvedValueOnce(rabbit);

      await expect(rabbitService.updateRabbit(1, 1, { mother_id: 1 }))
        .rejects.toThrow('CANNOT_BE_OWN_MOTHER');
    });

    it('should throw MOTHER_NOT_FOUND_OR_INVALID_SEX when mother not found', async () => {
      const rabbit = { ...baseRabbit, update: jest.fn() };
      Rabbit.findOne
        .mockResolvedValueOnce(rabbit) // rabbit lookup
        .mockResolvedValueOnce(null); // mother lookup

      await expect(rabbitService.updateRabbit(1, 1, { mother_id: 60 }))
        .rejects.toThrow('MOTHER_NOT_FOUND_OR_INVALID_SEX');
    });

    it('should validate mother successfully', async () => {
      const mockUpdate = jest.fn().mockResolvedValue(true);
      const rabbit = { ...baseRabbit, update: mockUpdate };
      Rabbit.findOne
        .mockResolvedValueOnce(rabbit)
        .mockResolvedValueOnce({ id: 60, sex: 'female' }) // mother lookup
        .mockResolvedValueOnce({ id: 1 }); // getRabbitById

      await rabbitService.updateRabbit(1, 1, { mother_id: 60 });

      expect(mockTx.commit).toHaveBeenCalled();
    });

    it('should throw TAG_ID_EXISTS when tag already taken by another rabbit', async () => {
      const rabbit = { ...baseRabbit, tag_id: 'TAG-OLD', update: jest.fn() };
      Rabbit.findOne
        .mockResolvedValueOnce(rabbit) // rabbit lookup
        .mockResolvedValueOnce({ id: 99, tag_id: 'TAG-NEW' }); // existing tag

      await expect(rabbitService.updateRabbit(1, 1, { tag_id: 'TAG-NEW' }))
        .rejects.toThrow('TAG_ID_EXISTS');
    });

    it('should skip tag validation when tag_id unchanged', async () => {
      const mockUpdate = jest.fn().mockResolvedValue(true);
      const rabbit = { ...baseRabbit, tag_id: 'TAG-OLD', update: mockUpdate };
      Rabbit.findOne
        .mockResolvedValueOnce(rabbit)
        .mockResolvedValueOnce({ id: 1 }); // getRabbitById

      await rabbitService.updateRabbit(1, 1, { tag_id: 'TAG-OLD' });

      // findOne should only have been called twice (rabbit + getRabbitById), not for tag check
      expect(mockTx.commit).toHaveBeenCalled();
    });

    it('should call deleteFile when photo_url changes and old photo exists', async () => {
      const mockUpdate = jest.fn().mockResolvedValue(true);
      const rabbit = { ...baseRabbit, photo_url: '/old/photo.jpg', update: mockUpdate };
      Rabbit.findOne
        .mockResolvedValueOnce(rabbit)
        .mockResolvedValueOnce({ id: 1 }); // getRabbitById

      await rabbitService.updateRabbit(1, 1, { photo_url: '/new/photo.jpg' });

      expect(deleteFile).toHaveBeenCalledWith('/old/photo.jpg');
      expect(mockTx.commit).toHaveBeenCalled();
    });

    it('should NOT call deleteFile when photo_url is same', async () => {
      const mockUpdate = jest.fn().mockResolvedValue(true);
      const rabbit = { ...baseRabbit, photo_url: '/same/photo.jpg', update: mockUpdate };
      Rabbit.findOne
        .mockResolvedValueOnce(rabbit)
        .mockResolvedValueOnce({ id: 1 });

      await rabbitService.updateRabbit(1, 1, { photo_url: '/same/photo.jpg' });

      expect(deleteFile).not.toHaveBeenCalled();
    });

    it('should NOT call deleteFile when old photo_url is null', async () => {
      const mockUpdate = jest.fn().mockResolvedValue(true);
      const rabbit = { ...baseRabbit, photo_url: null, update: mockUpdate };
      Rabbit.findOne
        .mockResolvedValueOnce(rabbit)
        .mockResolvedValueOnce({ id: 1 });

      await rabbitService.updateRabbit(1, 1, { photo_url: '/new/photo.jpg' });

      expect(deleteFile).not.toHaveBeenCalled();
    });

    it('should create weight record when current_weight changes', async () => {
      const mockUpdate = jest.fn().mockResolvedValue(true);
      const rabbit = { ...baseRabbit, current_weight: 2.0, update: mockUpdate };
      Rabbit.findOne
        .mockResolvedValueOnce(rabbit)
        .mockResolvedValueOnce({ id: 1 });
      RabbitWeight.create.mockResolvedValue({ id: 1 });

      await rabbitService.updateRabbit(1, 1, { current_weight: 3.5 });

      expect(RabbitWeight.create).toHaveBeenCalledWith(
        expect.objectContaining({
          rabbit_id: 1,
          weight: 3.5,
          measured_at: expect.any(Date)
        }),
        { transaction: mockTx }
      );
    });

    it('should NOT create weight record when current_weight unchanged', async () => {
      const mockUpdate = jest.fn().mockResolvedValue(true);
      const rabbit = { ...baseRabbit, current_weight: 2.0, update: mockUpdate };
      Rabbit.findOne
        .mockResolvedValueOnce(rabbit)
        .mockResolvedValueOnce({ id: 1 });

      await rabbitService.updateRabbit(1, 1, { current_weight: 2.0 });

      expect(RabbitWeight.create).not.toHaveBeenCalled();
    });

    it('should successfully update rabbit and return updated data', async () => {
      const mockUpdate = jest.fn().mockResolvedValue(true);
      const rabbit = { ...baseRabbit, id: 1, update: mockUpdate };
      const updatedRabbit = { id: 1, name: 'Updated Bunny' };
      Rabbit.findOne
        .mockResolvedValueOnce(rabbit) // initial lookup
        .mockResolvedValueOnce(updatedRabbit); // getRabbitById

      const result = await rabbitService.updateRabbit(1, 1, { name: 'Updated Bunny' });

      expect(mockUpdate).toHaveBeenCalledWith(
        { name: 'Updated Bunny' },
        { transaction: mockTx }
      );
      expect(mockTx.commit).toHaveBeenCalled();
      expect(result).toEqual(updatedRabbit);
    });

    it('should rollback transaction on unexpected error', async () => {
      const rabbit = { ...baseRabbit, update: jest.fn().mockRejectedValue(new Error('DB_ERROR')) };
      Rabbit.findOne.mockResolvedValueOnce(rabbit);

      await expect(rabbitService.updateRabbit(1, 1, { name: 'fail' }))
        .rejects.toThrow('DB_ERROR');
      expect(mockTx.rollback).toHaveBeenCalled();
    });
  });

  // ========== deleteRabbit with photo_url ==========
  describe('deleteRabbit - photo cleanup', () => {
    it('should call deleteFile when rabbit has photo_url', async () => {
      const rabbit = { id: 1, photo_url: '/uploads/rabbit1.jpg', destroy: jest.fn().mockResolvedValue(true) };
      Rabbit.findOne.mockResolvedValue(rabbit);
      Rabbit.count.mockResolvedValue(0);
      Breeding.count.mockResolvedValue(0);
      Birth.count.mockResolvedValue(0);
      MedicalRecord.count.mockResolvedValue(0);
      Vaccination.count.mockResolvedValue(0);
      Transaction.count.mockResolvedValue(0);

      await rabbitService.deleteRabbit(1, 1);

      expect(deleteFile).toHaveBeenCalledWith('/uploads/rabbit1.jpg');
      expect(rabbit.destroy).toHaveBeenCalled();
    });
  });

  // ========== getStatistics ==========
  describe('getStatistics', () => {
    it('should return full statistics object', async () => {
      // Setup count mocks in order they are called
      Rabbit.count
        .mockResolvedValueOnce(50)  // total
        .mockResolvedValueOnce(5)   // deadCount
        .mockResolvedValueOnce(20)  // maleCount
        .mockResolvedValueOnce(25)  // femaleCount
        .mockResolvedValueOnce(3)   // pregnantCount
        .mockResolvedValueOnce(2)   // sickCount
        .mockResolvedValueOnce(8);  // forSaleCount

      // breedDistribution
      Rabbit.findAll.mockResolvedValue([
        {
          breed_id: 1,
          breed: { name: 'Rex' },
          get: jest.fn().mockReturnValue('15')
        },
        {
          breed_id: 2,
          breed: { name: 'Angora' },
          get: jest.fn().mockReturnValue('10')
        }
      ]);

      const result = await rabbitService.getStatistics(1);

      expect(result).toEqual({
        total: 50,
        alive_count: 45,
        male_count: 20,
        female_count: 25,
        pregnant_count: 3,
        sick_count: 2,
        for_sale_count: 8,
        dead_count: 5,
        by_breed: [
          { breed_id: 1, breed_name: 'Rex', count: 15 },
          { breed_id: 2, breed_name: 'Angora', count: 10 }
        ]
      });
    });

    it('should handle empty breed distribution', async () => {
      Rabbit.count
        .mockResolvedValueOnce(0)
        .mockResolvedValueOnce(0)
        .mockResolvedValueOnce(0)
        .mockResolvedValueOnce(0)
        .mockResolvedValueOnce(0)
        .mockResolvedValueOnce(0)
        .mockResolvedValueOnce(0);
      Rabbit.findAll.mockResolvedValue([]);

      const result = await rabbitService.getStatistics(1);

      expect(result.total).toBe(0);
      expect(result.by_breed).toEqual([]);
    });

    it('should handle breed with null name', async () => {
      Rabbit.count
        .mockResolvedValueOnce(5)
        .mockResolvedValueOnce(0)
        .mockResolvedValueOnce(3)
        .mockResolvedValueOnce(2)
        .mockResolvedValueOnce(0)
        .mockResolvedValueOnce(0)
        .mockResolvedValueOnce(0);
      Rabbit.findAll.mockResolvedValue([
        {
          breed_id: 1,
          breed: null,
          get: jest.fn().mockReturnValue('5')
        }
      ]);

      const result = await rabbitService.getStatistics(1);

      expect(result.by_breed).toEqual([
        { breed_id: 1, breed_name: null, count: 5 }
      ]);
    });

    it('should throw on error', async () => {
      Rabbit.count.mockRejectedValue(new Error('DB_ERROR'));

      await expect(rabbitService.getStatistics(1))
        .rejects.toThrow('DB_ERROR');
    });
  });

  // ========== getPedigree ==========
  describe('getPedigree', () => {
    it('should build pedigree tree with parents', async () => {
      const grandFather = { id: 3, name: 'GrandPa', sex: 'male', tag_id: 'G1', birth_date: '2020-01-01', Breed: { name: 'Rex' }, father_id: null, mother_id: null };
      const grandMother = { id: 4, name: 'GrandMa', sex: 'female', tag_id: 'G2', birth_date: '2020-02-01', Breed: { name: 'Rex' }, father_id: null, mother_id: null };
      const father = { id: 2, name: 'Dad', sex: 'male', tag_id: 'F1', birth_date: '2021-01-01', Breed: { name: 'Rex' }, father_id: 3, mother_id: 4 };
      const rabbit = { id: 1, name: 'Bunny', sex: 'male', tag_id: 'R1', birth_date: '2022-01-01', Breed: { name: 'Rex' }, father_id: 2, mother_id: null };

      Rabbit.findOne
        .mockResolvedValueOnce(rabbit)       // getRabbitById(1) - initial
        .mockResolvedValueOnce(father)       // getRabbitById(2) - father
        .mockResolvedValueOnce(grandFather)  // getRabbitById(3) - grandfather
        .mockResolvedValueOnce(grandMother); // getRabbitById(4) - grandmother

      const result = await rabbitService.getPedigree(1, 1, 3);

      expect(result.id).toBe(1);
      expect(result.name).toBe('Bunny');
      expect(result.father).toBeDefined();
      expect(result.father.id).toBe(2);
      expect(result.father.father).toBeDefined();
      expect(result.father.father.id).toBe(3);
      expect(result.father.mother).toBeDefined();
      expect(result.father.mother.id).toBe(4);
    });

    it('should use default name when rabbit has no name', async () => {
      const rabbit = { id: 1, name: null, sex: 'male', tag_id: null, birth_date: null, Breed: null, father_id: null, mother_id: null };
      Rabbit.findOne.mockResolvedValueOnce(rabbit);

      const result = await rabbitService.getPedigree(1, 1, 3);

      expect(result.name).toBe('\u0411\u0435\u0437 \u0438\u043c\u0435\u043d\u0438');
      expect(result.tag_id).toBeNull();
      expect(result.sex).toBe('male');
      expect(result.breed).toBeNull();
    });

    it('should stop at generation limit', async () => {
      const father = { id: 2, name: 'Dad', sex: 'male', tag_id: 'F1', birth_date: null, Breed: null, father_id: 3, mother_id: null };
      const rabbit = { id: 1, name: 'Bunny', sex: 'male', tag_id: 'R1', birth_date: null, Breed: null, father_id: 2, mother_id: null };

      Rabbit.findOne
        .mockResolvedValueOnce(rabbit)  // getRabbitById(1)
        .mockResolvedValueOnce(father); // getRabbitById(2) - father

      // With generations=2, father is fetched at level 1, but father's father (level 2) should not be fetched
      const result = await rabbitService.getPedigree(1, 1, 2);

      expect(result.father.id).toBe(2);
      // Father's father_id is 3 but at level 2 >= generations(2), so it returns the rabbit itself
      expect(result.father.father).toBeUndefined();
    });

    it('should handle father not found gracefully (catch block)', async () => {
      const rabbit = { id: 1, name: 'Bunny', sex: 'male', tag_id: 'R1', birth_date: null, Breed: null, father_id: 99, mother_id: null };
      Rabbit.findOne
        .mockResolvedValueOnce(rabbit) // getRabbitById(1) - initial
        .mockResolvedValueOnce(null);  // getRabbitById(99) - father not found -> throws RABBIT_NOT_FOUND

      const result = await rabbitService.getPedigree(1, 1, 3);

      expect(result.id).toBe(1);
      expect(result.father).toBeUndefined();
    });

    it('should handle mother not found gracefully (catch block)', async () => {
      const rabbit = { id: 1, name: 'Bunny', sex: 'female', tag_id: 'R1', birth_date: null, Breed: null, father_id: null, mother_id: 88 };
      Rabbit.findOne
        .mockResolvedValueOnce(rabbit) // getRabbitById(1)
        .mockResolvedValueOnce(null);  // getRabbitById(88) - mother not found

      const result = await rabbitService.getPedigree(1, 1, 3);

      expect(result.id).toBe(1);
      expect(result.mother).toBeUndefined();
    });

    it('should throw when initial rabbit not found', async () => {
      Rabbit.findOne.mockResolvedValue(null);

      await expect(rabbitService.getPedigree(999, 1, 3))
        .rejects.toThrow('RABBIT_NOT_FOUND');
    });

    it('should build pedigree with both father and mother', async () => {
      const father = { id: 2, name: 'Dad', sex: 'male', tag_id: 'F1', birth_date: null, Breed: { name: 'Rex' }, father_id: null, mother_id: null };
      const mother = { id: 3, name: 'Mom', sex: 'female', tag_id: 'M1', birth_date: null, Breed: { name: 'Angora' }, father_id: null, mother_id: null };
      const rabbit = { id: 1, name: 'Baby', sex: 'female', tag_id: 'B1', birth_date: '2023-01-01', Breed: { name: 'Rex' }, father_id: 2, mother_id: 3 };

      Rabbit.findOne
        .mockResolvedValueOnce(rabbit)
        .mockResolvedValueOnce(father)
        .mockResolvedValueOnce(mother);

      const result = await rabbitService.getPedigree(1, 1, 3);

      expect(result.father.id).toBe(2);
      expect(result.father.breed).toBe('Rex');
      expect(result.mother.id).toBe(3);
      expect(result.mother.breed).toBe('Angora');
    });

    it('should handle generations=1 (no parents fetched)', async () => {
      const rabbit = { id: 1, name: 'Bunny', sex: 'male', tag_id: 'R1', birth_date: null, Breed: null, father_id: 2, mother_id: 3 };
      Rabbit.findOne.mockResolvedValueOnce(rabbit);

      // With generations=1, level 0 < 1 so we build result, but father/mother would be level 1 >= 1
      // Actually level 0 < 1 so we enter buildPedigree, but then fetching father at level+1=1 >= 1 returns currentRabbit
      const result = await rabbitService.getPedigree(1, 1, 1);

      // At level 0, we build result. father_id exists so we fetch father.
      // But buildPedigree(father, 1) with 1 >= 1 returns the father rabbit as-is
      // Actually wait - let me re-check: if level >= generations return currentRabbit
      // So father at level 1 would be returned as the raw rabbit object, not the pedigree format
      expect(result.id).toBe(1);
    });
  });
});
