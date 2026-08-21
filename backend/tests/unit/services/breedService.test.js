/**
 * Unit tests for breedService
 *
 * Породы принадлежат ферме, поэтому каждая проверка отвечает не только
 * «работает ли операция», но и «ограничена ли она своим владельцем».
 */
jest.mock('../../../src/models', () => ({
  Breed: {
    findAll: jest.fn(),
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

const OWNER = 7;
const STRANGER = 8;

describe('breedService', () => {
  beforeEach(() => {
    jest.resetAllMocks();
  });

  describe('getAllBreeds', () => {
    it('возвращает только породы своей фермы', async () => {
      const breeds = [{ id: 1, name: 'Rex' }, { id: 2, name: 'Angora' }];
      Breed.findAll.mockResolvedValue(breeds);

      const result = await breedService.getAllBreeds(OWNER);

      expect(result).toEqual(breeds);
      expect(Breed.findAll).toHaveBeenCalledWith({
        where: { user_id: OWNER },
        order: [['name', 'ASC']]
      });
    });

    it('пробрасывает ошибку базы', async () => {
      Breed.findAll.mockRejectedValue(new Error('DB error'));

      await expect(breedService.getAllBreeds(OWNER)).rejects.toThrow('DB error');
    });
  });

  describe('getBreedById', () => {
    it('находит породу своей фермы', async () => {
      const breed = { id: 1, name: 'Rex' };
      Breed.findOne.mockResolvedValue(breed);

      const result = await breedService.getBreedById(1, OWNER);

      expect(result).toEqual(breed);
      expect(Breed.findOne).toHaveBeenCalledWith({
        where: { id: 1, user_id: OWNER }
      });
    });

    it('чужая порода выглядит как несуществующая', async () => {
      // Запрос ограничен user_id, поэтому чужая строка просто не находится —
      // и посторонний не узнаёт даже о самом факте её существования.
      Breed.findOne.mockResolvedValue(null);

      await expect(breedService.getBreedById(1, STRANGER))
        .rejects.toThrow('BREED_NOT_FOUND');
    });
  });

  describe('createBreed', () => {
    it('проставляет владельца создаваемой породе', async () => {
      Breed.findOne.mockResolvedValue(null);
      const newBreed = { id: 1, name: 'Rex' };
      Breed.create.mockResolvedValue(newBreed);

      const result = await breedService.createBreed({ name: 'Rex' }, OWNER);

      expect(result).toEqual(newBreed);
      expect(Breed.create).toHaveBeenCalledWith({ name: 'Rex', user_id: OWNER });
    });

    it('имя проверяется на уникальность в пределах фермы', async () => {
      Breed.findOne.mockResolvedValue(null);
      Breed.create.mockResolvedValue({ id: 1 });

      await breedService.createBreed({ name: 'Rex' }, OWNER);

      expect(Breed.findOne).toHaveBeenCalledWith({
        where: { name: 'Rex', user_id: OWNER }
      });
    });

    it('своё занятое имя даёт BREED_NAME_EXISTS', async () => {
      Breed.findOne.mockResolvedValue({ id: 1, name: 'Rex' });

      await expect(breedService.createBreed({ name: 'Rex' }, OWNER))
        .rejects.toThrow('BREED_NAME_EXISTS');
    });
  });

  describe('updateBreed', () => {
    it('обновляет породу своей фермы', async () => {
      const breed = { id: 1, name: 'Rex', update: jest.fn().mockResolvedValue(true) };
      Breed.findOne.mockResolvedValueOnce(breed).mockResolvedValueOnce(null);

      const result = await breedService.updateBreed(1, { name: 'New Rex' }, OWNER);

      expect(breed.update).toHaveBeenCalledWith({ name: 'New Rex' });
      expect(result).toBe(breed);
    });

    it('чужую породу не найти', async () => {
      Breed.findOne.mockResolvedValue(null);

      await expect(breedService.updateBreed(999, { name: 'Test' }, STRANGER))
        .rejects.toThrow('BREED_NOT_FOUND');
    });

    it('нельзя переписать породу на чужую ферму', async () => {
      const breed = { id: 1, name: 'Rex', update: jest.fn().mockResolvedValue(true) };
      Breed.findOne.mockResolvedValue(breed);

      await breedService.updateBreed(1, { description: 'x', user_id: STRANGER }, OWNER);

      expect(breed.update).toHaveBeenCalledWith({ description: 'x' });
    });

    it('занятое имя даёт BREED_NAME_EXISTS', async () => {
      const breed = { id: 1, name: 'Rex', update: jest.fn() };
      Breed.findOne
        .mockResolvedValueOnce(breed)
        .mockResolvedValueOnce({ id: 2, name: 'Angora' });

      await expect(breedService.updateBreed(1, { name: 'Angora' }, OWNER))
        .rejects.toThrow('BREED_NAME_EXISTS');
    });

    it('имя не изменилось — уникальность не перепроверяется', async () => {
      const breed = { id: 1, name: 'Rex', update: jest.fn().mockResolvedValue(true) };
      Breed.findOne.mockResolvedValue(breed);

      await breedService.updateBreed(1, { name: 'Rex' }, OWNER);

      expect(Breed.findOne).toHaveBeenCalledTimes(1);
    });

    it('обновление без смены имени', async () => {
      const breed = { id: 1, name: 'Rex', update: jest.fn().mockResolvedValue(true) };
      Breed.findOne.mockResolvedValue(breed);

      await breedService.updateBreed(1, { description: 'Updated desc' }, OWNER);

      expect(breed.update).toHaveBeenCalledWith({ description: 'Updated desc' });
    });
  });

  describe('deleteBreed', () => {
    it('удаляет породу своей фермы', async () => {
      const breed = { id: 1, destroy: jest.fn().mockResolvedValue(true) };
      Breed.findOne.mockResolvedValue(breed);
      Rabbit.count.mockResolvedValue(0);

      const result = await breedService.deleteBreed(1, OWNER);

      expect(breed.destroy).toHaveBeenCalled();
      expect(result).toEqual({ success: true });
    });

    it('чужую породу удалить нельзя', async () => {
      Breed.findOne.mockResolvedValue(null);

      await expect(breedService.deleteBreed(1, STRANGER))
        .rejects.toThrow('BREED_NOT_FOUND');
      expect(Rabbit.count).not.toHaveBeenCalled();
    });

    it('породу с кроликами удалить нельзя', async () => {
      Breed.findOne.mockResolvedValue({ id: 1 });
      Rabbit.count.mockResolvedValue(3);

      await expect(breedService.deleteBreed(1, OWNER))
        .rejects.toThrow('BREED_HAS_RABBITS');
      // Считаем только своих кроликов: чужие не должны мешать удалению.
      expect(Rabbit.count).toHaveBeenCalledWith({
        where: { breed_id: 1, user_id: OWNER }
      });
    });
  });
});
