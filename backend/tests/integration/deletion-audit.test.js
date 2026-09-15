const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');

/**
 * Журнал удалений целиком живёт на стыке трёх вещей: контекста запроса
 * (`utils/requestContext`), хука модели и таблицы журнала. Ни одну из них
 * юнит-тест не проверяет вместе с остальными, а стоит любой из них
 * отвалиться — журнал будет пустым и молчаливым, то есть неотличимым от
 * «никто ничего не удалял». Ради этого тест и написан.
 */
describe('Журнал удалений', () => {
  let ownerToken;
  let breedId;
  let farmId;

  const auth = (token) => ({ Authorization: `Bearer ${token}` });

  beforeAll(async () => {
    await syncTestDb();

    const owner = await registerFarm(app, {
      email: 'audit_owner@example.com',
      full_name: 'Владелец'
    });
    ownerToken = owner.accessToken;
    farmId = owner.user.farm_id;

    const breed = await request(app)
      .post('/api/v1/breeds')
      .set(auth(ownerToken))
      .send({ name: 'Порода для журнала' });
    breedId = breed.body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  const createRabbit = async (name) => {
    const res = await request(app)
      .post('/api/v1/rabbits')
      .set(auth(ownerToken))
      .send({ name, breed_id: breedId, sex: 'female', birth_date: '2025-01-01' });
    return res.body.data.id;
  };

  const dataLog = async () => {
    const res = await request(app)
      .get('/api/v1/staff/audit')
      .query({ scope: 'data', limit: 100 })
      .set(auth(ownerToken));
    return res.body.data.items;
  };

  it('удалённый кролик попадает в журнал с кличкой и автором', async () => {
    const id = await createRabbit('Мушка');

    await request(app)
      .delete(`/api/v1/rabbits/${id}`)
      .set(auth(ownerToken))
      .expect(200);

    const items = await dataLog();
    const row = items.find((item) => item.entity_id === id);

    expect(row).toBeDefined();
    expect(row.action).toBe('rabbit.deleted');
    expect(row.entity_type).toBe('rabbit');
    // Кличка, а не идентификатор: после удаления сходить за ней уже некуда.
    expect(row.entity_label).toBe('Мушка');
    expect(row.actor.full_name).toBe('Владелец');
    expect(row.farm_id).toBe(farmId);
  });

  it('кадровый срез журнала удалениями не засоряется', async () => {
    const id = await createRabbit('Пушок');
    await request(app).delete(`/api/v1/rabbits/${id}`).set(auth(ownerToken));

    const res = await request(app)
      .get('/api/v1/staff/audit')
      .query({ scope: 'staff', limit: 100 })
      .set(auth(ownerToken));

    expect(res.status).toBe(200);
    expect(res.body.data.items.every((item) => item.entity_type === null)).toBe(true);
  });

  it('чужая ферма своего журнала не показывает', async () => {
    const id = await createRabbit('Соседский');
    await request(app).delete(`/api/v1/rabbits/${id}`).set(auth(ownerToken));

    const stranger = await registerFarm(app, {
      email: 'audit_stranger@example.com',
      full_name: 'Сосед'
    });

    const res = await request(app)
      .get('/api/v1/staff/audit')
      .query({ scope: 'data', limit: 100 })
      .set(auth(stranger.accessToken));

    expect(res.status).toBe(200);
    expect(res.body.data.items).toHaveLength(0);
  });
});
