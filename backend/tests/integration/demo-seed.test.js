const Sequelize = require('sequelize');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { sequelize, Farm, User, Cage, Breed, Feed } = require('../../src/models');
const demoSeed = require('../../seeders/20251015000001-initial-data');

/**
 * Демо-данные должны давать ферму, на которой сразу видно роли: владелец,
 * управляющий и работник — одна ферма. Раньше сидер заводил всех троих
 * владельцами собственных ферм, и вход работником показывал пустые экраны.
 */
describe('Демо-данные', () => {
  const runSeeder = () => demoSeed.up(sequelize.getQueryInterface(), Sequelize);

  const findByEmail = (email) => User.findOne({ where: { email } });

  beforeAll(async () => {
    await syncTestDb();
    await runSeeder();
  });

  afterAll(async () => {
    await closeTestDb();
  });

  it('демо-ферма заведена и знает своего владельца', async () => {
    const owner = await findByEmail('admin@rabbitfarm.com');
    const farm = await Farm.findByPk(owner.farm_id);

    expect(owner.role).toBe('owner');
    expect(farm).not.toBeNull();
    expect(farm.owner_id).toBe(owner.id);
  });

  it('управляющий и работник — сотрудники фермы владельца', async () => {
    const owner = await findByEmail('admin@rabbitfarm.com');
    const manager = await findByEmail('manager@rabbitfarm.com');
    const worker = await findByEmail('worker@rabbitfarm.com');

    expect(manager.farm_id).toBe(owner.farm_id);
    expect(manager.role).toBe('manager');
    expect(worker.farm_id).toBe(owner.farm_id);
    expect(worker.role).toBe('worker');
  });

  it('в ферму владельца входят все трое', async () => {
    const owner = await findByEmail('admin@rabbitfarm.com');
    const manager = await findByEmail('manager@rabbitfarm.com');
    const worker = await findByEmail('worker@rabbitfarm.com');

    const members = await User.findAll({ where: { farm_id: owner.farm_id } });

    expect(members.map((m) => m.id).sort())
      .toEqual([owner.id, manager.id, worker.id].sort());
  });

  it('демо-клетки, породы и корма принадлежат ферме владельца', async () => {
    const owner = await findByEmail('admin@rabbitfarm.com');

    expect(await Cage.count({ where: { farm_id: owner.farm_id } })).toBe(10);
    expect(await Breed.count({ where: { farm_id: owner.farm_id } })).toBe(8);
    expect(await Feed.count({ where: { farm_id: owner.farm_id } })).toBe(6);
  });

  it('повторный запуск не падает и не плодит дублей', async () => {
    await expect(runSeeder()).resolves.not.toThrow();

    const owner = await findByEmail('admin@rabbitfarm.com');

    expect(await User.count()).toBe(3);
    expect(await Farm.count()).toBe(1);
    // Считаем по всем фермам намеренно: проверяем, что второго набора
    // демо-данных не появилось.
    expect(await Cage.count({ tenantScope: 'all' })).toBe(10);
    expect(await Breed.count({ tenantScope: 'all' })).toBe(8);
    expect(await Feed.count({ tenantScope: 'all' })).toBe(6);
    expect((await findByEmail('worker@rabbitfarm.com')).farm_id).toBe(owner.farm_id);
  });

  it('в продакшене сидер отказывается работать', async () => {
    process.env.NODE_ENV = 'production';
    try {
      await expect(runSeeder()).rejects.toThrow(/продакшен/i);
    } finally {
      process.env.NODE_ENV = 'test';
    }
  });
});
