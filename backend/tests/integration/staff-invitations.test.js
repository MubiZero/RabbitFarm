const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm, loginWithOtp, KNOWN_CODE } = require('./helpers/auth');
const { LoginOtp, User } = require('../../src/models');
const { hashOtp } = require('../../src/utils/otp');

/**
 * Полный путь работника: владелец зовёт человека по контакту, тот входит
 * кодом с экрана входа и сразу видит хозяйство фермы.
 *
 * Отдельной формы «принять приглашение» больше нет: приглашение и обычный
 * вход — одна и та же дверь, поэтому проверяется именно она.
 */
describe('Приглашения в ферму', () => {
  let ownerToken;
  let breedId;

  beforeAll(async () => {
    await syncTestDb();

    const owner = await registerFarm(app, { email: 'inv_owner@example.com', full_name: 'Владелец' });
    ownerToken = owner.accessToken;

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

  it('владелец выписывает приглашение — диктовать при этом нечего', async () => {
    const res = await request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ email: 'newworker@example.com', full_name: 'Новый Работник', role: 'worker' });

    expect(res.status).toBe(201);
    expect(res.body.data.role).toBe('worker');
    // Своего кода у приглашения нет: работник войдёт обычным кодом на свой
    // же контакт. Раньше здесь выписывался длинный токен, который
    // показывался владельцу и уходил SMS-кой, — вводить его было некуда.
    expect(res.body.data.code).toBeUndefined();
    expect(res.body.message).toContain('код придёт письмом');
  });

  it('без имени приглашение не выписывается', async () => {
    // Имя называет владелец: человек вводит только код на экране входа и
    // представиться ему больше негде — безымянный работник в составе фермы
    // читался бы как сбой.
    const res = await request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ email: 'nameless@example.com', role: 'worker' });

    expect(res.status).toBe(422);
  });

  it('в записи приглашения не остаётся никакого секрета', async () => {
    const { Invitation } = require('../../src/models');
    await request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ email: 'hashcheck@example.com', full_name: 'Проверка Хеша', role: 'worker' });

    const row = await Invitation.findOne({
      where: { email: 'hashcheck@example.com' },
      tenantScope: 'all'
    });
    expect(row.get('token_hash')).toBeUndefined();
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

  it('приглашённый входит кодом и сразу видит поголовье фермы', async () => {
    await request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ email: 'joiner@example.com', full_name: 'Новый работник', role: 'worker' });

    await request(app).post('/api/v1/auth/otp/request').send({ email: 'joiner@example.com' });
    const session = await loginWithOtp(app, { email: 'joiner@example.com' });

    expect(session.user.role).toBe('worker');
    // Имя пришло из приглашения: сам приглашённый его нигде не вводит.
    expect(session.user.full_name).toBe('Новый работник');

    const rabbits = await request(app)
      .get('/api/v1/rabbits')
      .set('Authorization', `Bearer ${session.access_token}`);

    const items = rabbits.body.data.items || rabbits.body.data;
    expect(items.map((r) => r.name)).toContain('Белка');
  });

  it('приглашение срабатывает один раз — второй вход не плодит работника', async () => {
    await request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ email: 'once@example.com', full_name: 'Единственный', role: 'worker' });

    await request(app).post('/api/v1/auth/otp/request').send({ email: 'once@example.com' });
    const first = await loginWithOtp(app, { email: 'once@example.com' });

    await request(app).post('/api/v1/auth/otp/request').send({ email: 'once@example.com' });
    const second = await loginWithOtp(app, { email: 'once@example.com' });

    // Второй вход — это вход уже существующего работника, а не повторная
    // активация приглашения: в ферме он остаётся один.
    expect(second.user.id).toBe(first.user.id);
    expect(await User.count({ where: { email: 'once@example.com' }, tenantScope: 'all' })).toBe(1);
  });

  it('неверный код приглашённого не пускает и работника не заводит', async () => {
    await request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ email: 'wrongcode@example.com', full_name: 'Ошибшийся', role: 'worker' });

    await request(app).post('/api/v1/auth/otp/request').send({ email: 'wrongcode@example.com' });
    const res = await request(app)
      .post('/api/v1/auth/otp/verify')
      .send({ email: 'wrongcode@example.com', code: '000000' });

    expect(res.status).toBe(400);
    expect(await User.count({ where: { email: 'wrongcode@example.com' }, tenantScope: 'all' })).toBe(0);
  });

  it('отозванное приглашение перестаёт работать даже с высланным кодом', async () => {
    const invite = await request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ email: 'revoked@example.com', full_name: 'Отозванный', role: 'worker' });

    // Код уходит человеку до отзыва — проверяется именно промежуток между
    // «код на руках» и «владелец передумал».
    await request(app).post('/api/v1/auth/otp/request').send({ email: 'revoked@example.com' });
    const otp = await LoginOtp.findOne({
      where: { identifier: 'revoked@example.com' },
      order: [['created_at', 'DESC']]
    });
    await otp.update({ token_hash: hashOtp(KNOWN_CODE) });

    await request(app)
      .delete(`/api/v1/staff/invitations/${invite.body.data.id}`)
      .set('Authorization', `Bearer ${ownerToken}`);

    const res = await request(app)
      .post('/api/v1/auth/otp/verify')
      .send({ email: 'revoked@example.com', code: KNOWN_CODE });

    expect(res.status).toBe(400);
    expect(await User.count({ where: { email: 'revoked@example.com' }, tenantScope: 'all' })).toBe(0);
  });

  it('владелец видит состав фермы', async () => {
    const res = await request(app)
      .get('/api/v1/staff')
      .set('Authorization', `Bearer ${ownerToken}`);

    expect(res.status).toBe(200);
    const emails = res.body.data.map((m) => m.email);
    expect(emails).toContain('inv_owner@example.com');
    expect(emails).toContain('joiner@example.com');
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

    // Отключённому сервис кода не шлёт вовсе, поэтому подкладываем свой:
    // проверяется сама дверь, а не доставка.
    await LoginOtp.destroy({ where: { identifier: 'joiner@example.com' } });
    await LoginOtp.create({
      identifier: 'joiner@example.com',
      channel: 'email',
      token_hash: hashOtp(KNOWN_CODE),
      expires_at: new Date(Date.now() + 10 * 60 * 1000)
    });

    const login = await request(app)
      .post('/api/v1/auth/otp/verify')
      .send({ email: 'joiner@example.com', code: KNOWN_CODE });

    expect(login.status).toBe(403);
  });

  it('сброса пароля работнику больше нет — паролей нет вовсе', async () => {
    // Забывший доступ работник просто запрашивает новый код на свой контакт,
    // владелец в этом не участвует.
    const owner = await request(app)
      .get('/api/v1/staff')
      .set('Authorization', `Bearer ${ownerToken}`);
    const someone = owner.body.data[0];

    const res = await request(app)
      .post(`/api/v1/staff/${someone.id}/reset-password`)
      .set('Authorization', `Bearer ${ownerToken}`);

    expect(res.status).toBe(404);
  });

  it('работник не может приглашать', async () => {
    await request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ email: 'nested@example.com', full_name: 'Вложенный', role: 'worker' });

    await request(app).post('/api/v1/auth/otp/request').send({ email: 'nested@example.com' });
    const joined = await loginWithOtp(app, { email: 'nested@example.com' });

    const res = await request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${joined.access_token}`)
      .send({ email: 'someone@example.com', full_name: 'Кто-то', role: 'worker' });

    expect(res.status).toBe(403);
  });

  // Регрессия: при активации приглашения наружу уходил урезанный пользователь
  // (без is_active и временных меток), и клиент падал на разборе ответа до
  // сохранения токенов — войти по приглашению было невозможно вообще.
  it('в ответе на вход приходит полный профиль пользователя', async () => {
    await request(app)
      .post('/api/v1/staff/invitations')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ email: 'full_payload@example.com', full_name: 'Полный Профиль', role: 'worker' });

    await request(app).post('/api/v1/auth/otp/request').send({ email: 'full_payload@example.com' });
    const session = await loginWithOtp(app, { email: 'full_payload@example.com' });

    for (const field of ['id', 'email', 'full_name', 'role', 'is_active', 'created_at', 'updated_at']) {
      expect(session.user[field]).toBeDefined();
    }
  });
});
