const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');
const { User } = require('../../src/models');

/**
 * Смоук-тесты платформенной админки против настоящей БД.
 *
 * Юнит-тесты сервиса (tests/unit/services/platformAdminService.test.js)
 * замокивают модели целиком — они систематически не ловят один конкретный
 * класс багов: запрос к мультитенантной таблице (Rabbit, Photo, ...) без
 * условия по farm_id падает в бою на хуке src/utils/tenancy.js, но с
 * замоканной моделью хук просто не существует, и такой запрос отработает
 * «успешно». Ровно так один раз и было с platformAdminService.getSummary() —
 * баг нашёлся только вручную, пересборкой докер-образа. Эти тесты идут через
 * реальный Sequelize и реальный хук, чтобы рецидив такого класса багов ловил
 * прогон тестов, а не ручная проверка.
 *
 * Не весь модуль — только самые частые ручки (список/карточка фермы,
 * тарифы, сводка) и подтверждение, что роутер защищён авторизацией.
 */
describe('Платформенная админка (интеграция)', () => {
  let adminToken;
  let ownerAToken;
  let farmAId;
  let farmBId;
  let planId;

  beforeAll(async () => {
    await syncTestDb();

    // Платформенный админ — обычная регистрация, флаг ставится вручную в
    // БД, как и в проде (см. docs/plans/PLATFORM-ADMIN.md). is_platform_admin
    // читается заново на каждый запрос (middleware/auth.js из БД, не из
    // токена) — перелогин после смены флага не нужен.
    const admin = await registerFarm(app, {
        email: 'platform_admin_it@example.com',
        full_name: 'Суперадмин'
      });
    adminToken = admin.accessToken;
    await User.update(
      { is_platform_admin: true },
      { where: { id: admin.user.id } }
    );

    // Ферма A — с кроликами, ей назначим платный тариф ниже.
    const ownerA = await registerFarm(app, {
        email: 'summary_owner_a@example.com',
        full_name: 'Владелец А'
      });
    ownerAToken = ownerA.accessToken;
    farmAId = ownerA.user.farm_id;

    const breed = await request(app)
      .post('/api/v1/breeds')
      .set('Authorization', `Bearer ${ownerAToken}`)
      .send({ name: 'Порода для сводки' });

    for (const name of ['Кроль 1', 'Кроль 2', 'Кроль 3']) {
      await request(app)
        .post('/api/v1/rabbits')
        .set('Authorization', `Bearer ${ownerAToken}`)
        .send({ name, breed_id: breed.body.data.id, sex: 'female', birth_date: '2025-01-01' });
    }

    // Ферма B — пустая и без тарифа: считается в total, но не в rabbits_total.
    const ownerB = await registerFarm(app, {
        email: 'summary_owner_b@example.com',
        full_name: 'Владелец Б'
      });
    farmBId = ownerB.user.farm_id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  it('без токена не пускает вовсе', async () => {
    const res = await request(app).get('/api/v1/platform-admin/summary');
    expect(res.status).toBe(401);
  });

  it('обычный владелец фермы, не суперадмин, получает отказ', async () => {
    const res = await request(app)
      .get('/api/v1/platform-admin/summary')
      .set('Authorization', `Bearer ${ownerAToken}`);
    expect(res.status).toBe(403);
  });

  it('создаёт тариф и назначает его ферме', async () => {
    const created = await request(app)
      .post('/api/v1/platform-admin/plans')
      .set('Authorization', `Bearer ${adminToken}`)
      .send({ name: 'Базовый на сводке', price: 500, max_rabbits: 10, max_staff: 5, is_active: true });
    expect(created.status).toBe(201);
    planId = created.body.data.id;

    const assigned = await request(app)
      .patch(`/api/v1/platform-admin/farms/${farmAId}/plan`)
      .set('Authorization', `Bearer ${adminToken}`)
      .send({ plan_id: planId });

    expect(assigned.status).toBe(200);
    expect(assigned.body.data.plan_id).toBe(planId);
    expect(assigned.body.data.rabbits_count).toBe(3);
  });

  it('список тарифов отдаёт созданный тариф', async () => {
    const res = await request(app)
      .get('/api/v1/platform-admin/plans')
      .set('Authorization', `Bearer ${adminToken}`);

    expect(res.status).toBe(200);
    expect(res.body.data.some((plan) => plan.id === planId)).toBe(true);
  });

  it('список ферм видит все фермы с фактическим потреблением', async () => {
    const res = await request(app)
      .get('/api/v1/platform-admin/farms')
      .set('Authorization', `Bearer ${adminToken}`);

    expect(res.status).toBe(200);
    const items = res.body.data.items;
    const farmA = items.find((farm) => farm.id === farmAId);
    const farmB = items.find((farm) => farm.id === farmBId);

    expect(farmA.rabbits_count).toBe(3);
    expect(farmA.plan.id).toBe(planId);
    expect(farmB.plan).toBeNull();
  });

  it('карточка одной фермы отдаёт состав и занятое место', async () => {
    const res = await request(app)
      .get(`/api/v1/platform-admin/farms/${farmAId}`)
      .set('Authorization', `Bearer ${adminToken}`);

    expect(res.status).toBe(200);
    expect(res.body.data.rabbits_count).toBe(3);
    expect(res.body.data.staff).toHaveLength(1);
    expect(res.body.data.storage_bytes).toBe(0);
  });

  it('сводка платформы считает фермы, поголовье и категории тарифа против реальной БД', async () => {
    // Ровно тот путь, который в этой сессии падал против настоящей БД при
    // зелёных замоканных юнит-тестах: Rabbit.count()/Photo.sum()/Rabbit.sum()
    // без farm_id упирались в мультитенантный хук tenancy.js без явного
    // tenantScope: 'all'. Этот тест реально проходит через хук.
    const res = await request(app)
      .get('/api/v1/platform-admin/summary')
      .set('Authorization', `Bearer ${adminToken}`);

    expect(res.status).toBe(200);
    // Три фермы: своя у платформенного админа (её тоже создаёт /auth/register)
    // + A + B. Тестовая БД без сидов — тарифа по умолчанию нет, поэтому и
    // ферма админа, и ферма B остаются без плана.
    expect(res.body.data.farms).toEqual(
      expect.objectContaining({ total: 3, free: 0, paid: 1, no_plan: 2, expired: 0, suspended: 0, at_limit: 0 })
    );
    expect(res.body.data.rabbits_total).toBe(3);
    expect(res.body.data.storage_bytes).toBe(0);
    expect(res.body.data.registrations_30d).toBeGreaterThanOrEqual(3);
  });
});
