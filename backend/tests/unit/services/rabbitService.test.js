jest.mock('../../../src/models', () => {
  const mockSequelize = { transaction: jest.fn() };
  return {
    Rabbit: { findOne: jest.fn(), findByPk: jest.fn(), create: jest.fn(), count: jest.fn(), findAndCountAll: jest.fn() },
    Breed: { findByPk: jest.fn() },
    Cage: { findOne: jest.fn() },
    RabbitWeight: { create: jest.fn() },
    Photo: {},
    Breeding: {},
    Birth: {},
    Vaccination: {},
    MedicalRecord: {},
    FeedingRecord: {},
    Transaction: {},
    Task: {},
    sequelize: mockSequelize
  };
});
jest.mock('../../../src/utils/fileHelper', () => ({ deleteFile: jest.fn() }));

const { Rabbit, Breed, Cage, RabbitWeight, sequelize } = require('../../../src/models');
const rabbitService = require('../../../src/services/rabbitService');
const { createMockRabbit } = require('../../helpers/mockModels');

describe('RabbitService', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('createRabbit', () => {
    const mockTransaction = { commit: jest.fn(), rollback: jest.fn() };

    beforeEach(() => {
      sequelize.transaction.mockResolvedValue(mockTransaction);
    });

    it('должен бросать BREED_NOT_FOUND если порода не существует', async () => {
      Breed.findByPk.mockResolvedValue(null);

      await expect(rabbitService.createRabbit({ breed_id: 999, user_id: 1 }))
        .rejects.toThrow('BREED_NOT_FOUND');
      expect(mockTransaction.rollback).toHaveBeenCalled();
    });

    it('должен бросать CAGE_NOT_FOUND если клетка не найдена у пользователя', async () => {
      Breed.findByPk.mockResolvedValue({ id: 1 });
      Cage.findOne.mockResolvedValue(null);

      await expect(rabbitService.createRabbit({ breed_id: 1, cage_id: 1, user_id: 1 }))
        .rejects.toThrow('CAGE_NOT_FOUND');
    });

    it('должен бросать CAGE_FULL если клетка заполнена', async () => {
      Breed.findByPk.mockResolvedValue({ id: 1 });
      Cage.findOne.mockResolvedValue({ id: 1, capacity: 2 });
      Rabbit.count.mockResolvedValue(2);

      await expect(rabbitService.createRabbit({ breed_id: 1, cage_id: 1, user_id: 1, status: 'healthy' }))
        .rejects.toThrow('CAGE_FULL');
    });

    it('должен создавать кролика успешно если все данные корректны', async () => {
      const mockRabbit = createMockRabbit();
      Breed.findByPk.mockResolvedValue({ id: 1 });
      Rabbit.create.mockResolvedValue(mockRabbit);
      // getRabbitById вызывается после commit — мокаем findOne для него
      Rabbit.findOne.mockResolvedValue(mockRabbit);

      const result = await rabbitService.createRabbit({
        name: 'Буся', breed_id: 1, user_id: 1, sex: 'female',
        birth_date: '2024-01-01', status: 'healthy'
      });

      expect(result).toBeDefined();
      expect(Rabbit.create).toHaveBeenCalled();
      expect(mockTransaction.commit).toHaveBeenCalled();
    });
  });
});
