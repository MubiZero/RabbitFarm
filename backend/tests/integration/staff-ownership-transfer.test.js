const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
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
  let inactiveWorkerId;
  let strangerId;

  beforeAll(async () => {
    await syncTestDb();

    const owner = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'transfer_owner@example.com', password: 'Password123!', full_name: 'Владелец' });
    ownerToken = owner.body.data.access_token;
    farmId = owner.body.data.user.farm_id;

    await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'transfer_manager@example.com', password: 'Password123!', full_name: 'Управляющий' });
    await User.update(
      { farm_id: farmId, role: 'manager' },
      { where: { email: 'transfer_manager@example.com' } }
    );

    await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'transfer_worker@example.com', password: 'Password123!', full_name: 'Работник' });
    await User.update(
      { farm_id: farmId, role: 'worker' },
      { where: { email: 'transfer_worker@example.com' } }
    );
    workerId = (await User.findOne({ where: { email: 'transfer_worker@example.com' } })).id;

    await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'transfer_inactive@example.com', password: 'Password123!', full_name: 'Уволенный' });
    await User.update(
      { farm_id: farmId, role: 'worker', is_active: false },
      { where: { email: 'transfer_inactive@example.com' } }
    );
    inactiveWorkerId = (await User.findOne({ where: { email: 'transfer_inactive@example.com' } })).id;

    const stranger = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'transfer_stranger@example.com', password: 'Password123!', full_name: 'Сосед' });
    strangerId = stranger.body.data.user.id;
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
    const managerLogin = await request(app)
      .post('/api/v1/auth/login')
      .send({ email: 'transfer_manager@example.com', password: 'Password123!' });

    const res = await request(app)
      .post(`/api/v1/staff/${workerId}/transfer-ownership`)
      .set('Authorization', `Bearer ${managerLogin.body.data.access_token}`);

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
      .send({ email: 'after_transfer@example.com', role: 'worker' });

    expect(res.status).toBe(403);
  });

  it('новый владелец получает владельческий доступ тем же токеном', async () => {
    const newOwnerLogin = await request(app)
      .post('/api/v1/auth/login')
      .send({ email: 'transfer_worker@example.com', password: 'Password123!' });

    const res = await request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${newOwnerLogin.body.data.access_token}`)
      .send({ email: 'after_transfer2@example.com', role: 'worker' });

    expect(res.status).toBe(201);
  });
});
