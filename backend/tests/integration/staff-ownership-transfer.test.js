const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm, login: signIn } = require('./helpers/auth');
const { User, Farm } = require('../../src/models');

/**
 * Передача хозяйства: владелец мгновенно уступает ферму активному
 * работнику, без подтверждения с его стороны — получатель уже участник
 * этой же фермы, а не посторонний по коду.
 */
describe('Передача хозяйства фермы', () => {
  let ownerToken;
  let farmId;
  let workerId;
  let workerToken;
  let inactiveWorkerId;
  let strangerId;

  beforeAll(async () => {
    await syncTestDb();

    const owner = await registerFarm(app, { email: 'transfer_owner@example.com', full_name: 'Владелец' });
    ownerToken = owner.accessToken;
    farmId = owner.user.farm_id;

    await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'transfer_manager@example.com', full_name: 'Управляющий' });
    await User.update(
      { farm_id: farmId, role: 'manager' },
      { where: { email: 'transfer_manager@example.com' } }
    );

    await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'transfer_worker@example.com', full_name: 'Работник' });
    await User.update(
      { farm_id: farmId, role: 'worker' },
      { where: { email: 'transfer_worker@example.com' } }
    );
    workerId = (await User.findOne({ where: { email: 'transfer_worker@example.com' } })).id;
    // Вход до передачи: токен работника понадобится, чтобы проверить, что
    // права он получает по записи в базе, а не по роли, зашитой в токен.
    ({ accessToken: workerToken } = await signIn(app, { email: 'transfer_worker@example.com' }));

    await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'transfer_inactive@example.com', full_name: 'Уволенный' });
    await User.update(
      { farm_id: farmId, role: 'worker', is_active: false },
      { where: { email: 'transfer_inactive@example.com' } }
    );
    inactiveWorkerId = (await User.findOne({ where: { email: 'transfer_inactive@example.com' } })).id;

    const stranger = await registerFarm(app, { email: 'transfer_stranger@example.com', full_name: 'Сосед' });
    strangerId = stranger.user.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  it('работника чужой фермы получателем не назначить', async () => {
    const res = await request(app)
      .post(`/api/v1/staff/${strangerId}/transfer-ownership`)
      .set('Authorization', `Bearer ${ownerToken}`);

    expect(res.status).toBe(404);
  });

  it('неактивному работнику ферму не передать', async () => {
    const res = await request(app)
      .post(`/api/v1/staff/${inactiveWorkerId}/transfer-ownership`)
      .set('Authorization', `Bearer ${ownerToken}`);

    expect(res.status).toBe(404);
  });

  it('не-владелец передать хозяйство не может', async () => {
    const managerLogin = await signIn(app, { email: 'transfer_manager@example.com' })

    const res = await request(app)
      .post(`/api/v1/staff/${workerId}/transfer-ownership`)
      .set('Authorization', `Bearer ${managerLogin.accessToken}`);

    expect(res.status).toBe(403);
  });

  it('владелец передаёт хозяйство работнику', async () => {
    const res = await request(app)
      .post(`/api/v1/staff/${workerId}/transfer-ownership`)
      .set('Authorization', `Bearer ${ownerToken}`);

    expect(res.status).toBe(200);
    expect(res.body.data.id).toBe(workerId);
    expect(res.body.data.role).toBe('owner');

    const farm = await Farm.findByPk(farmId);
    expect(farm.owner_id).toBe(workerId);

    const previousOwner = await User.findOne({ where: { email: 'transfer_owner@example.com' } });
    expect(previousOwner.role).toBe('manager');
  });

  it('бывший владелец теряет владельческий доступ без повторного логина', async () => {
    // Тот же access-токен, что и в начале файла — роль в нём не менялась,
    // но middleware читает её из базы заново на каждый запрос.
    const res = await request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ email: 'after_transfer@example.com', full_name: 'После передачи', role: 'worker' });

    expect(res.status).toBe(403);
  });

  it('новый владелец получает владельческий доступ тем же токеном', async () => {
    // Токен выдан ещё работнику — новых прав в нём нет, они приходят из базы.
    const res = await request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${workerToken}`)
      .send({ email: 'after_transfer2@example.com', full_name: 'Второй приглашённый', role: 'worker' });

    expect(res.status).toBe(201);
  });
});
