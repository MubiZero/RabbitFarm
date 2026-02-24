/**
 * Unit tests for breedService
 */
jest.mock('../../../src/models', () => ({
  Breed: {
    findAll: jest.fn(),
    findByPk: jest.fn(),
    findOne: jest.fn(),
    create: jest.fn()
  },
  Rabbit: {
    count: jest.fn()
  }
}));

jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

const { Breed, Rabbit } = require('../../../src/models');
const breedService = require('../../../src/services/breedService');

describe('breedService', () => {
  beforeEach(() => {
    jest.resetAllMocks();
  });

  describe('getAllBreeds', () => {
    it('should return all breeds', async () => {
      const breeds = [{ id: 1, name: 'Rex' }, { id: 2, name: 'Angora' }];
      Breed.findAll.mockResolvedValue(breeds);

      const result = await breedService.getAllBreeds();

      expect(result).toEqual(breeds);
      expect(Breed.findAll).toHaveBeenCalledWith({ order: [['name', 'ASC']] });
    });

    it('should throw on DB error', async () => {
      Breed.findAll.mockRejectedValue(new Error('DB error'));

      await expect(breedService.getAllBreeds()).rejects.toThrow('DB error');
    });
  });

  describe('getBreedById', () => {
    it('should return breed by id', async () => {
      const breed = { id: 1, name: 'Rex' };
      Breed.findByPk.mockResolvedValue(breed);

      const result = await breedService.getBreedById(1);

      expect(result).toEqual(breed);
    });

    it('should throw BREED_NOT_FOUND when breed does not exist', async () => {
      Breed.findByPk.mockResolvedValue(null);

      await expect(breedService.getBreedById(999)).rejects.toThrow('BREED_NOT_FOUND');
    });
  });

  describe('createBreed', () => {
    it('should create breed successfully', async () => {
      Breed.findOne.mockResolvedValue(null);
      const newBreed = { id: 1, name: 'Rex' };
      Breed.create.mockResolvedValue(newBreed);

      const result = await breedService.createBreed({ name: 'Rex' });

      expect(result).toEqual(newBreed);
      expect(Breed.create).toHaveBeenCalledWith({ name: 'Rex' });
    });

    it('should throw BREED_NAME_EXISTS if name already taken', async () => {
      Breed.findOne.mockResolvedValue({ id: 1, name: 'Rex' });

      await expect(breedService.createBreed({ name: 'Rex' })).rejects.toThrow('BREED_NAME_EXISTS');
    });
  });

  describe('updateBreed', () => {
    it('should update breed successfully', async () => {
      const breed = { id: 1, name: 'Rex', update: jest.fn().mockResolvedValue(true) };
      Breed.findByPk.mockResolvedValue(breed);
      Breed.findOne.mockResolvedValue(null);

      const result = await breedService.updateBreed(1, { name: 'New Rex' });

      expect(breed.update).toHaveBeenCalledWith({ name: 'New Rex' });
      expect(result).toBe(breed);
    });

    it('should throw BREED_NOT_FOUND if breed does not exist', async () => {
      Breed.findByPk.mockResolvedValue(null);

      await expect(breedService.updateBreed(999, { name: 'Test' })).rejects.toThrow('BREED_NOT_FOUND');
    });

    it('should throw BREED_NAME_EXISTS if new name is taken', async () => {
      const breed = { id: 1, name: 'Rex', update: jest.fn() };
      Breed.findByPk.mockResolvedValue(breed);
      Breed.findOne.mockResolvedValue({ id: 2, name: 'Angora' });

      await expect(breedService.updateBreed(1, { name: 'Angora' })).rejects.toThrow('BREED_NAME_EXISTS');
    });

    it('should not check name uniqueness if name unchanged', async () => {
      const breed = { id: 1, name: 'Rex', update: jest.fn().mockResolvedValue(true) };
      Breed.findByPk.mockResolvedValue(breed);

      await breedService.updateBreed(1, { name: 'Rex' });

      expect(Breed.findOne).not.toHaveBeenCalled();
    });

    it('should update without name change', async () => {
      const breed = { id: 1, name: 'Rex', update: jest.fn().mockResolvedValue(true) };
      Breed.findByPk.mockResolvedValue(breed);

      await breedService.updateBreed(1, { description: 'Updated desc' });

      expect(breed.update).toHaveBeenCalledWith({ description: 'Updated desc' });
    });
  });

  describe('deleteBreed', () => {
    it('should delete breed successfully', async () => {
      const breed = { id: 1, destroy: jest.fn().mockResolvedValue(true) };
      Breed.findByPk.mockResolvedValue(breed);
      Rabbit.count.mockResolvedValue(0);

      const result = await breedService.deleteBreed(1);

      expect(breed.destroy).toHaveBeenCalled();
      expect(result).toEqual({ success: true });
    });

    it('should throw BREED_NOT_FOUND if breed does not exist', async () => {
      Breed.findByPk.mockResolvedValue(null);

      await expect(breedService.deleteBreed(999)).rejects.toThrow('BREED_NOT_FOUND');
    });

    it('should throw BREED_HAS_RABBITS if breed has rabbits', async () => {
      const breed = { id: 1 };
      Breed.findByPk.mockResolvedValue(breed);
      Rabbit.count.mockResolvedValue(3);

      await expect(breedService.deleteBreed(1)).rejects.toThrow('BREED_HAS_RABBITS');
    });
  });
});
