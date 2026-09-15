const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');
const { User } = require('../../src/models');

/**
 * Обращение в поддержку было дорогой в один конец: человек отправлял текст и
 * не узнавал ничего — ни что его прочитали, ни что решили. Отметка
 * «разобрано» меняла флаг, который видел один админ.
 *
 * Проверяется весь путь: ферма пишет → видит своё обращение → админ отвечает
 * → ответ доезжает до фермы.
 */
describe('Поддержка: обращение и ответ', () => {
  let farmToken;
  let adminToken;
  let requestId;

  const auth = (token) => ({ Authorization: `Bearer ${token}` });

  beforeAll(async () => {
    await syncTestDb();

    const farm = await registerFarm(app, {
      email: 'support_farm@example.com',
      full_name: 'Фермер'
    });
    farmToken = farm.accessToken;

    const admin = await registerFarm(app, {
      email: 'support_admin@example.com',
      full_name: 'Админ платформы'
    });
    await User.update(
      { is_platform_admin: true },
      { where: { email: 'support_admin@example.com' } }
    );
    adminToken = admin.accessToken;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  it('ферма отправляет обращение и видит его у себя', async () => {
    const created = await request(app)
      .post('/api/v1/support-requests')
      .set(auth(farmToken))
      .send({ text: 'Не приходят напоминания про маточник' });

    expect(created.status).toBe(201);
    requestId = created.body.data.id;

    const mine = await request(app)
      .get('/api/v1/support-requests')
      .set(auth(farmToken));

    expect(mine.status).toBe(200);
    const row = mine.body.data.items.find((item) => item.id === requestId);
    expect(row).toBeDefined();
    expect(row.status).toBe('new');
    // Перечитать написанное — половина смысла списка: человек не помнит,
    // что именно он отправил неделю назад.
    expect(row.text).toBe('Не приходят напоминания про маточник');
  });

  it('ответ админа доезжает до фермы вместе со статусом', async () => {
    const resolved = await request(app)
      .patch(`/api/v1/platform-admin/support-requests/${requestId}/resolve`)
      .set(auth(adminToken))
      .send({ answer: 'Включите уведомления в настройках телефона' });

    expect(resolved.status).toBe(200);

    const mine = await request(app)
      .get('/api/v1/support-requests')
      .set(auth(farmToken));
    const row = mine.body.data.items.find((item) => item.id === requestId);

    expect(row.status).toBe('resolved');
    expect(row.answer).toBe('Включите уведомления в настройках телефона');
    expect(row.resolved_at).not.toBeNull();
  });

  it('чужие обращения ферме не видны', async () => {
    const stranger = await registerFarm(app, {
      email: 'support_stranger@example.com',
      full_name: 'Сосед'
    });

    const mine = await request(app)
      .get('/api/v1/support-requests')
      .set(auth(stranger.accessToken));

    expect(mine.status).toBe(200);
    expect(mine.body.data.items).toHaveLength(0);
  });

  it('закрыть можно и без ответа — часть обращений решают звонком', async () => {
    const created = await request(app)
      .post('/api/v1/support-requests')
      .set(auth(farmToken))
      .send({ text: 'Вопрос, который решили по телефону' });

    const resolved = await request(app)
      .patch(`/api/v1/platform-admin/support-requests/${created.body.data.id}/resolve`)
      .set(auth(adminToken))
      .send({});

    expect(resolved.status).toBe(200);
    expect(resolved.body.data.status).toBe('resolved');
    expect(resolved.body.data.answer).toBeNull();
  });
});
