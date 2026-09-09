const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { User } = require('../../src/models');

/**
 * Обращения в поддержку: ферма пишет, платформенный админ разбирает.
 *
 * Главное, что проверяется здесь помимо обычного пути, — что форма
 * обращения работает у фермы, которой закрыли доступ. Ровно из-за этого
 * случая (`Хозяйство приостановлено. Обратитесь в поддержку.`) фича и
 * появилась, и под обычным `authenticate` она упиралась бы в тот самый отказ.
 */
describe('Обращения в поддержку (интеграция)', () => {
  let adminToken;
  let ownerToken;
  let workerToken;
  let suspendedOwnerToken;
  let farmId;
  let suspendedFarmId;

  beforeAll(async () => {
    await syncTestDb();

    const admin = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'support_admin@example.com', password: 'Password123!', full_name: 'Суперадмин' });
    adminToken = admin.body.data.access_token;
    await User.update(
      { is_platform_admin: true },
      { where: { id: admin.body.data.user.id } }
    );

    const owner = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'support_owner@example.com', password: 'Password123!', full_name: 'Владелец' });
    ownerToken = owner.body.data.access_token;
    farmId = owner.body.data.user.farm_id;

    // Работник той же фермы — заводится напрямую, как в тестах состава фермы.
    await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'support_worker@example.com', password: 'Password123!', full_name: 'Работник' });
    await User.update(
      { farm_id: farmId, role: 'worker' },
      { where: { email: 'support_worker@example.com' } }
    );
    const workerLogin = await request(app)
      .post('/api/v1/auth/login')
      .send({ email: 'support_worker@example.com', password: 'Password123!' });
    workerToken = workerLogin.body.data.access_token;

    // Отдельная ферма под приостановку: закрывать доступ основной значило бы
    // ломать остальные проверки этого же файла.
    const suspendedOwner = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'support_suspended@example.com', password: 'Password123!', full_name: 'Отключённый' });
    suspendedOwnerToken = suspendedOwner.body.data.access_token;
    suspendedFarmId = suspendedOwner.body.data.user.farm_id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  it('без токена не принимает обращение', async () => {
    const res = await request(app)
      .post('/api/v1/support-requests')
      .send({ text: 'Ничего не работает, помогите' });

    expect(res.status).toBe(401);
  });

  it('владелец отправляет обращение — оно новое и подписано автором', async () => {
    const res = await request(app)
      .post('/api/v1/support-requests')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ text: 'Не приходит уведомление об окроле' });

    expect(res.status).toBe(201);
    expect(res.body.data.status).toBe('new');
    expect(res.body.data.farm_id).toBe(farmId);
    expect(res.body.data.author.email).toBe('support_owner@example.com');
  });

  it('работник пишет наравне с владельцем — роль здесь не ограничена', async () => {
    const res = await request(app)
      .post('/api/v1/support-requests')
      .set('Authorization', `Bearer ${workerToken}`)
      .send({ text: 'Не могу отметить кормление, кнопка не нажимается' });

    expect(res.status).toBe(201);
    expect(res.body.data.author.role).toBe('worker');
  });

  it('слишком короткий текст не проходит', async () => {
    const res = await request(app)
      .post('/api/v1/support-requests')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ text: 'ой' });

    expect(res.status).toBe(422);
  });

  it('ферма с закрытым доступом всё равно может написать в поддержку', async () => {
    const suspended = await request(app)
      .patch(`/api/v1/platform-admin/farms/${suspendedFarmId}/status`)
      .set('Authorization', `Bearer ${adminToken}`)
      .send({ status: 'suspended' });
    expect(suspended.status).toBe(200);

    // Контрольный выстрел: обычная запись у неё уже не проходит.
    const blocked = await request(app)
      .post('/api/v1/notes')
      .set('Authorization', `Bearer ${suspendedOwnerToken}`)
      .send({ content: 'Запись после приостановки' });
    expect(blocked.status).toBe(403);

    const res = await request(app)
      .post('/api/v1/support-requests')
      .set('Authorization', `Bearer ${suspendedOwnerToken}`)
      .send({ text: 'Почему закрыли доступ к хозяйству?' });

    expect(res.status).toBe(201);
    expect(res.body.data.farm_id).toBe(suspendedFarmId);
  });

  it('обычный владелец фермы не видит чужих обращений', async () => {
    const res = await request(app)
      .get('/api/v1/platform-admin/support-requests')
      .set('Authorization', `Bearer ${ownerToken}`);

    expect(res.status).toBe(403);
  });

  it('админ видит обращения всех ферм с пагинацией', async () => {
    const res = await request(app)
      .get('/api/v1/platform-admin/support-requests')
      .set('Authorization', `Bearer ${adminToken}`);

    expect(res.status).toBe(200);
    expect(res.body.data.pagination.total).toBe(3);
    expect(res.body.data.items).toHaveLength(3);

    const farms = res.body.data.items.map((item) => item.farm.id);
    expect(farms).toContain(farmId);
    expect(farms).toContain(suspendedFarmId);
  });

  it('разобранное обращение уходит вниз списка и остаётся разобранным', async () => {
    const before = await request(app)
      .get('/api/v1/platform-admin/support-requests')
      .set('Authorization', `Bearer ${adminToken}`);
    const first = before.body.data.items[0];

    const resolved = await request(app)
      .patch(`/api/v1/platform-admin/support-requests/${first.id}/resolve`)
      .set('Authorization', `Bearer ${adminToken}`);

    expect(resolved.status).toBe(200);
    expect(resolved.body.data.status).toBe('resolved');

    // Повтор — не ошибка: две открытые панели закрывают одно и то же.
    const again = await request(app)
      .patch(`/api/v1/platform-admin/support-requests/${first.id}/resolve`)
      .set('Authorization', `Bearer ${adminToken}`);
    expect(again.status).toBe(200);
    expect(again.body.data.status).toBe('resolved');

    const after = await request(app)
      .get('/api/v1/platform-admin/support-requests')
      .set('Authorization', `Bearer ${adminToken}`);
    expect(after.body.data.items[0].status).toBe('new');
    expect(after.body.data.items.at(-1).id).toBe(first.id);
  });

  it('несуществующее обращение — 404, а не пятисотка', async () => {
    const res = await request(app)
      .patch('/api/v1/platform-admin/support-requests/999999/resolve')
      .set('Authorization', `Bearer ${adminToken}`);

    expect(res.status).toBe(404);
  });
});
