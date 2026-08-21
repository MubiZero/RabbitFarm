const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { User } = require('../../src/models');

/**
 * Работник фермы видит хозяйство владельца, а не собственное пустое,
 * и при этом ферма остаётся закрытой для посторонних.
 */
describe('Ферма и работники', () => {
  let ownerToken;
  let workerToken;
  let managerToken;
  let strangerToken;
  let rabbitId;
  let breedId;

  beforeAll(async () => {
    await syncTestDb();

    const owner = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'farm_owner@example.com', password: 'Password123!', full_name: 'Владелец' });
    ownerToken = owner.body.data.access_token;

    // Работника пока заводим напрямую: приглашений ещё нет.
    await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'farm_worker@example.com', password: 'Password123!', full_name: 'Работник' });
    await User.update(
      { owner_id: owner.body.data.user.id, role: 'worker' },
      { where: { email: 'farm_worker@example.com' } }
    );
    const workerLogin = await request(app)
      .post('/api/v1/auth/login')
      .send({ email: 'farm_worker@example.com', password: 'Password123!' });
    workerToken = workerLogin.body.data.access_token;

    // Менеджер той же фермы: ему разрешено вести поголовье.
    await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'farm_manager@example.com', password: 'Password123!', full_name: 'Менеджер' });
    await User.update(
      { owner_id: owner.body.data.user.id, role: 'manager' },
      { where: { email: 'farm_manager@example.com' } }
    );
    const managerLogin = await request(app)
      .post('/api/v1/auth/login')
      .send({ email: 'farm_manager@example.com', password: 'Password123!' });
    managerToken = managerLogin.body.data.access_token;

    // Посторонний владелец собственной фермы.
    const stranger = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'other_farm@example.com', password: 'Password123!', full_name: 'Сосед' });
    strangerToken = stranger.body.data.access_token;

    const breed = await request(app)
      .post('/api/v1/breeds')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ name: 'Порода фермы' });
    breedId = breed.body.data.id;

    const rabbit = await request(app)
      .post('/api/v1/rabbits')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ name: 'Белка', breed_id: breedId, sex: 'female', birth_date: '2026-01-10' });
    rabbitId = rabbit.body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  it('владелец видит своего кролика', async () => {
    const res = await request(app)
      .get(`/api/v1/rabbits/${rabbitId}`)
      .set('Authorization', `Bearer ${ownerToken}`);

    expect(res.status).toBe(200);
  });

  it('работник видит кролика своей фермы', async () => {
    const res = await request(app)
      .get(`/api/v1/rabbits/${rabbitId}`)
      .set('Authorization', `Bearer ${workerToken}`);

    expect(res.status).toBe(200);
    expect(res.body.data.name).toBe('Белка');
  });

  it('работник видит поголовье фермы в списке', async () => {
    const res = await request(app)
      .get('/api/v1/rabbits')
      .set('Authorization', `Bearer ${workerToken}`);

    expect(res.status).toBe(200);
    const items = res.body.data.items || res.body.data;
    expect(items.map(r => r.name)).toContain('Белка');
  });

  it('работнику не разрешено заводить поголовье', async () => {
    const res = await request(app)
      .post('/api/v1/rabbits')
      .set('Authorization', `Bearer ${workerToken}`)
      .send({ name: 'Не должна появиться', breed_id: breedId, sex: 'female', birth_date: '2026-02-01' });

    expect(res.status).toBe(403);
  });

  it('запись менеджера попадает в ферму владельца', async () => {
    const created = await request(app)
      .post('/api/v1/rabbits')
      .set('Authorization', `Bearer ${managerToken}`)
      .send({ name: 'Стрелка', breed_id: breedId, sex: 'female', birth_date: '2026-02-01' });

    expect(created.status).toBe(201);

    // Владелец должен увидеть то, что внёс сотрудник.
    const list = await request(app)
      .get('/api/v1/rabbits')
      .set('Authorization', `Bearer ${ownerToken}`);
    const items = list.body.data.items || list.body.data;
    expect(items.map(r => r.name)).toContain('Стрелка');
  });

  it('чужая ферма кролика не видит', async () => {
    const res = await request(app)
      .get(`/api/v1/rabbits/${rabbitId}`)
      .set('Authorization', `Bearer ${strangerToken}`);

    expect(res.status).toBe(404);
  });
});
