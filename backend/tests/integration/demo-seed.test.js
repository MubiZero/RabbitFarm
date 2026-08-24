const Sequelize = require('sequelize');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { sequelize, User, Cage, Breed, Feed } = require('../../src/models');
const { farmMemberIds } = require('../../src/utils/farm');
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

  it('владелец остаётся сам себе фермой', async () => {
    const owner = await findByEmail('admin@rabbitfarm.com');

    expect(owner.role).toBe('owner');
    expect(owner.owner_id).toBeNull();
  });

  it('управляющий и работник — сотрудники фермы владельца', async () => {
    const owner = await findByEmail('admin@rabbitfarm.com');
    const manager = await findByEmail('manager@rabbitfarm.com');
    const worker = await findByEmail('worker@rabbitfarm.com');

    expect(manager.owner_id).toBe(owner.id);
    expect(manager.role).toBe('manager');
    expect(worker.owner_id).toBe(owner.id);
    expect(worker.role).toBe('worker');
  });

  it('в ферму владельца входят все трое', async () => {
    const owner = await findByEmail('admin@rabbitfarm.com');
    const manager = await findByEmail('manager@rabbitfarm.com');
    const worker = await findByEmail('worker@rabbitfarm.com');

    const members = await farmMemberIds(owner.id);

    expect(members.sort()).toEqual([owner.id, manager.id, worker.id].sort());
  });

  it('демо-клетки, породы и корма принадлежат ферме владельца', async () => {
    const owner = await findByEmail('admin@rabbitfarm.com');

    expect(await Cage.count({ where: { user_id: owner.id } })).toBe(10);
    expect(await Breed.count({ where: { user_id: owner.id } })).toBe(8);
    expect(await Feed.count({ where: { user_id: owner.id } })).toBe(6);
  });

  it('повторный запуск не падает и не плодит дублей', async () => {
    await expect(runSeeder()).resolves.not.toThrow();

    const owner = await findByEmail('admin@rabbitfarm.com');

    expect(await User.count()).toBe(3);
    expect(await Cage.count()).toBe(10);
    expect(await Breed.count()).toBe(8);
    expect(await Feed.count()).toBe(6);
    expect((await findByEmail('worker@rabbitfarm.com')).owner_id).toBe(owner.id);
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
