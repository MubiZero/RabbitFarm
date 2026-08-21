const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');

/**
 * Полный путь работника: владелец выписывает код, человек по нему
 * присоединяется к ферме и сразу видит её хозяйство.
 */
describe('Приглашения в ферму', () => {
  let ownerToken;
  let ownerId;
  let breedId;

  beforeAll(async () => {
    await syncTestDb();

    const owner = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'inv_owner@example.com', password: 'Password123!', full_name: 'Владелец' });
    ownerToken = owner.body.data.access_token;
    ownerId = owner.body.data.user.id;

    const breed = await request(app)
      .post('/api/v1/breeds')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ name: 'Порода фермы' });
    breedId = breed.body.data.id;

    await request(app)
      .post('/api/v1/rabbits')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ name: 'Белка', breed_id: breedId, sex: 'female', birth_date: '2026-01-10' });
  });

  afterAll(async () => {
    await closeTestDb();
  });

  it('владелец выписывает приглашение и получает код', async () => {
    const res = await request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ email: 'newworker@example.com', role: 'worker' });

    expect(res.status).toBe(201);
    expect(res.body.data.code).toEqual(expect.any(String));
    expect(res.body.data.role).toBe('worker');
  });

  it('код не хранится в базе в открытом виде', async () => {
    const { Invitation } = require('../../src/models');
    const created = await request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ email: 'hashcheck@example.com', role: 'worker' });

    const row = await Invitation.findOne({ where: { email: 'hashcheck@example.com' } });
    expect(row.token_hash).not.toBe(created.body.data.code);
    expect(row.get('token')).toBeUndefined();
  });

  it('список приглашений не отдаёт коды', async () => {
    const res = await request(app)
      .get('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${ownerToken}`);

    expect(res.status).toBe(200);
    res.body.data.forEach((inv) => {
      expect(inv.code).toBeUndefined();
      expect(inv.token_hash).toBeUndefined();
    });
  });

  it('приглашённый вступает в ферму и видит её поголовье', async () => {
    const invite = await request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ email: 'joiner@example.com', role: 'worker' });

    const accepted = await request(app)
      .post('/api/v1/auth/accept-invitation')
      .send({ code: invite.body.data.code, password: 'Password123!', full_name: 'Новый работник' });

    expect(accepted.status).toBe(201);
    expect(accepted.body.data.user.role).toBe('worker');

    const rabbits = await request(app)
      .get('/api/v1/rabbits')
      .set('Authorization', `Bearer ${accepted.body.data.access_token}`);

    const items = rabbits.body.data.items || rabbits.body.data;
    expect(items.map((r) => r.name)).toContain('Белка');
  });

  it('код срабатывает только один раз', async () => {
    const invite = await request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ email: 'once@example.com', role: 'worker' });

    await request(app)
      .post('/api/v1/auth/accept-invitation')
      .send({ code: invite.body.data.code, password: 'Password123!', full_name: 'Первый' });

    const second = await request(app)
      .post('/api/v1/auth/accept-invitation')
      .send({ code: invite.body.data.code, password: 'Password123!', full_name: 'Второй' });

    expect(second.status).toBe(400);
  });

  it('выдуманный код не срабатывает', async () => {
    const res = await request(app)
      .post('/api/v1/auth/accept-invitation')
      .send({ code: 'совершенно-выдуманный-код', password: 'Password123!', full_name: 'Никто' });

    expect(res.status).toBe(400);
  });

  it('отозванное приглашение перестаёт работать', async () => {
    const invite = await request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ email: 'revoked@example.com', role: 'worker' });

    await request(app)
      .delete(`/api/v1/staff/invitations/${invite.body.data.id}`)
      .set('Authorization', `Bearer ${ownerToken}`);

    const res = await request(app)
      .post('/api/v1/auth/accept-invitation')
      .send({ code: invite.body.data.code, password: 'Password123!', full_name: 'Отозванный' });

    expect(res.status).toBe(400);
  });

  it('владелец видит состав фермы', async () => {
    const res = await request(app)
      .get('/api/v1/staff')
      .set('Authorization', `Bearer ${ownerToken}`);

    expect(res.status).toBe(200);
    const emails = res.body.data.map((m) => m.email);
    expect(emails).toContain('inv_owner@example.com');
    expect(emails).toContain('joiner@example.com');
    res.body.data.forEach((m) => expect(m.password_hash).toBeUndefined());
  });

  it('владелец отключает работнику доступ', async () => {
    const staff = await request(app)
      .get('/api/v1/staff')
      .set('Authorization', `Bearer ${ownerToken}`);
    const worker = staff.body.data.find((m) => m.email === 'joiner@example.com');

    const res = await request(app)
      .patch(`/api/v1/staff/${worker.id}`)
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ is_active: false });

    expect(res.status).toBe(200);

    const login = await request(app)
      .post('/api/v1/auth/login')
      .send({ email: 'joiner@example.com', password: 'Password123!' });
    expect(login.status).toBe(403);
  });

  it('работник не может приглашать', async () => {
    const invite = await request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ email: 'nested@example.com', role: 'worker' });
    const joined = await request(app)
      .post('/api/v1/auth/accept-invitation')
      .send({ code: invite.body.data.code, password: 'Password123!', full_name: 'Работник' });

    const res = await request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${joined.body.data.access_token}`)
      .send({ email: 'someone@example.com', role: 'worker' });

    expect(res.status).toBe(403);
  });
});
