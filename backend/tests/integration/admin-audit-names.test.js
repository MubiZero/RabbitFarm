const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { User, Farm } = require('../../src/models');
const JWTUtil = require('../../src/utils/jwt');

/**
 * Журнал действий платформенного админа читает человек.
 *
 * Данные для него лежали полные — кто, когда, над какой фермой, что было и
 * что стало, — но выдача шла голыми номерами: «Админ №3 · Ферма №7». Имена
 * при этом были в базе рядом, одним join. Это ровно тот случай, когда
 * конкретика уже на руках и просто не доезжает до читателя.
 *
 * Ферма и админ заводятся напрямую моделями, а не через регистрацию с кодом
 * из SMS: вход по коду зависит от общего с другими наборами состояния, и
 * такой тест падал через раз, ничего не говоря о самом журнале.
 */
describe('Журнал админа называет людей и фермы по именам', () => {
  let adminToken;
  let farmId;

  beforeAll(async () => {
    await syncTestDb();

    const farm = await Farm.create({ name: 'Заря' }, { tenantScope: 'all' });
    farmId = farm.id;

    const admin = await User.create({
      full_name: 'Пётр Смирнов',
      email: 'audit_admin@example.com',
      role: 'owner',
      farm_id: farm.id,
      is_active: true,
      is_platform_admin: true
    }, { tenantScope: 'all' });

    adminToken = JWTUtil.generateAccessToken({
      id: admin.id,
      role: admin.role,
      tv: admin.token_version || 0
    });
  });

  afterAll(async () => {
    await closeTestDb();
  });

  it('действие админа попадает в журнал вместе с именами', async () => {
    const changed = await request(app)
      .patch(`/api/v1/platform-admin/farms/${farmId}/status`)
      .set({ Authorization: `Bearer ${adminToken}` })
      .send({ status: 'read_only' });

    expect(changed.status).toBe(200);

    const log = await request(app)
      .get('/api/v1/platform-admin/audit')
      .set({ Authorization: `Bearer ${adminToken}` });

    expect(log.status).toBe(200);

    const row = log.body.data.items.find((item) => item.farm_id === farmId);
    expect(row).toBeDefined();
    expect(row.admin.full_name).toBe('Пётр Смирнов');
    expect(row.farm.name).toBe('Заря');
    // Что именно изменилось — тоже должно доезжать, иначе строка журнала
    // отвечает «что-то поменяли».
    expect(row.after).toMatchObject({ status: 'read_only' });
  });
});
