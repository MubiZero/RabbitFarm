/**
 * Экспорт данных фермы (см. docs/plans/PLATFORM-ADMIN.md, 2.4).
 */
const MODEL_NAMES = [
  'User', 'Rabbit', 'RabbitWeight', 'Breeding', 'Birth', 'Vaccination',
  'MedicalRecord', 'Cage', 'Breed', 'Feed', 'FeedingRecord', 'Transaction',
  'Task', 'Photo', 'Note', 'Payment'
];

jest.mock('../../../src/models', () => {
  const models = { Farm: { findByPk: jest.fn() } };
  for (const name of [
    'User', 'Rabbit', 'RabbitWeight', 'Breeding', 'Birth', 'Vaccination',
    'MedicalRecord', 'Cage', 'Breed', 'Feed', 'FeedingRecord', 'Transaction',
    'Task', 'Photo', 'Note', 'Payment'
  ]) {
    models[name] = { findAll: jest.fn() };
  }
  return models;
});

const models = require('../../../src/models');
const { Farm, User, Payment, Rabbit } = models;
const farmExportService = require('../../../src/services/farmExportService');

describe('FarmExportService', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    for (const name of MODEL_NAMES) {
      models[name].findAll.mockResolvedValue([]);
    }
  });

  it('бросает FARM_NOT_FOUND для несуществующей фермы', async () => {
    Farm.findByPk.mockResolvedValue(null);

    await expect(farmExportService.exportFarm(999)).rejects.toThrow('FARM_NOT_FOUND');
  });

  it('собирает все секции слепка и отметку времени', async () => {
    Farm.findByPk.mockResolvedValue({ id: 7, toJSON: () => ({ id: 7, name: 'Ферма 7' }) });
    Rabbit.findAll.mockResolvedValue([{ id: 1, name: 'Кролик' }]);

    const data = await farmExportService.exportFarm(7);

    expect(data.farm).toEqual({ id: 7, name: 'Ферма 7' });
    expect(data.rabbits).toEqual([{ id: 1, name: 'Кролик' }]);
    expect(typeof data.generated_at).toBe('string');
    expect(Object.keys(data).sort()).toEqual([
      'births', 'breedings', 'breeds', 'cages', 'farm', 'feeding_records',
      'feeds', 'generated_at', 'medical_records', 'notes', 'payments',
      'photos', 'rabbit_weights', 'rabbits', 'staff', 'tasks', 'transactions',
      'vaccinations'
    ]);
  });

  it('каждую таблицу берёт только по этой ферме', async () => {
    Farm.findByPk.mockResolvedValue({ id: 7, toJSON: () => ({ id: 7 }) });

    await farmExportService.exportFarm(7);

    for (const name of MODEL_NAMES) {
      expect(models[name].findAll).toHaveBeenCalledWith(
        expect.objectContaining({ where: { farm_id: 7 } })
      );
    }
  });

  it('не выгружает хеш пароля и поколение токенов сотрудников', async () => {
    Farm.findByPk.mockResolvedValue({ id: 7, toJSON: () => ({ id: 7 }) });

    await farmExportService.exportFarm(7);

    expect(User.findAll).toHaveBeenCalledWith({
      where: { farm_id: 7 },
      attributes: { exclude: ['password_hash', 'token_version'] }
    });
  });

  it('не выгружает сырой ответ банка по платежам', async () => {
    Farm.findByPk.mockResolvedValue({ id: 7, toJSON: () => ({ id: 7 }) });

    await farmExportService.exportFarm(7);

    expect(Payment.findAll).toHaveBeenCalledWith({
      where: { farm_id: 7 },
      attributes: { exclude: ['raw_response'] }
    });
  });

  it('запрашивает ферму вместе с владельцем и его контактами', async () => {
    Farm.findByPk.mockResolvedValue({ id: 7, toJSON: () => ({ id: 7 }) });

    await farmExportService.exportFarm(7);

    expect(Farm.findByPk).toHaveBeenCalledWith(7, {
      include: [expect.objectContaining({
        as: 'owner',
        attributes: ['id', 'full_name', 'email', 'phone']
      })]
    });
  });
});
