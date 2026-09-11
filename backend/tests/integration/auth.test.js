const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm, login: signIn, loginWithOtp, KNOWN_CODE } = require('./helpers/auth');
const { User, LoginOtp } = require('../../src/models');
const { hashOtp } = require('../../src/utils/otp');

/**
 * Вход в сервис — только по одноразовому коду: телефон основной, почта
 * запасная. Пароля нет вовсе, короткий ПИН живёт на самом устройстве и до
 * сервера не доходит.
 */
describe('Auth API', () => {
  beforeAll(async () => {
    await syncTestDb();
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('POST /api/v1/auth/register', () => {
    it('заводит ферму и отправляет код, но не открывает сессию', async () => {
      const res = await request(app)
        .post('/api/v1/auth/register')
        .send({ email: 'new@example.com', full_name: 'Test User' });

      expect(res.status).toBe(201);
      expect(res.body.success).toBe(true);
      expect(res.body.data).toEqual({
        user_id: expect.any(Number),
        farm_id: expect.any(Number),
        channel: 'email'
      });
      // Токенов нет намеренно: контакт ещё не подтверждён, войти можно
      // только кодом, который на него ушёл.
      expect(res.body.data).not.toHaveProperty('access_token');
      expect(res.body.data).not.toHaveProperty('refresh_token');

      const otp = await LoginOtp.findOne({ where: { identifier: 'new@example.com' } });
      expect(otp).not.toBeNull();
      expect(otp.channel).toBe('email');
    });

    it('регистрация по телефону шлёт код на телефон', async () => {
      const res = await request(app)
        .post('/api/v1/auth/register')
        .send({ phone: '901110011', full_name: 'Телефонный' });

      expect(res.status).toBe(201);
      expect(res.body.data.channel).toBe('phone');

      // Номер приводится к тому же виду, в котором его ждёт вход.
      const otp = await LoginOtp.findOne({ where: { identifier: '+992901110011' } });
      expect(otp).not.toBeNull();
      expect(otp.channel).toBe('phone');
    });

    it('отклоняет дублирующуюся почту', async () => {
      await request(app)
        .post('/api/v1/auth/register')
        .send({ email: 'dup@example.com', full_name: 'User' });

      const res = await request(app)
        .post('/api/v1/auth/register')
        .send({ email: 'dup@example.com', full_name: 'User 2' });

      expect(res.status).toBe(409);
      // Экран регистрации по этому коду предлагает перейти ко входу.
      expect(res.body.error.code).toBe('USER_EXISTS');
    });

    it('отклоняет занятый телефон', async () => {
      await request(app)
        .post('/api/v1/auth/register')
        .send({ phone: '+992902220022', full_name: 'Первый' });

      const res = await request(app)
        .post('/api/v1/auth/register')
        .send({ phone: '902220022', full_name: 'Второй' });

      expect(res.status).toBe(409);
      expect(res.body.error.code).toBe('PHONE_EXISTS');
    });

    it('отклоняет невалидную почту', async () => {
      const res = await request(app)
        .post('/api/v1/auth/register')
        .send({ email: 'not-an-email', full_name: 'User' });

      expect(res.status).toBe(422);
    });

    it('без контакта регистрировать нечего — код слать некуда', async () => {
      const res = await request(app)
        .post('/api/v1/auth/register')
        .send({ full_name: 'Безымянный контакт' });

      expect(res.status).toBe(422);
    });

    it('присланный пароль ни на что не влияет — войти можно только кодом',
      async () => {
        // Старый клиент ещё может слать `password`: валидация лишние поля
        // отбрасывает, а не отвергает запрос целиком. Важно, что ферма
        // заводится как обычно и никакого пароля у неё не появляется —
        // хранить его больше негде.
        const res = await request(app)
          .post('/api/v1/auth/register')
          .send({
            email: 'with_password@example.com',
            full_name: 'User',
            password: 'Password123!'
          });

        expect(res.status).toBe(201);

        const user = await User.findOne({
          where: { email: 'with_password@example.com' }
        });
        expect(user.get()).not.toHaveProperty('password_hash');

        // И вход тем же паролем невозможен: маршрута нет вовсе.
        const login = await request(app)
          .post('/api/v1/auth/login')
          .send({ email: 'with_password@example.com', password: 'Password123!' });
        expect(login.status).toBe(404);
      });
  });

  describe('POST /api/v1/auth/otp/request', () => {
    beforeAll(async () => {
      await request(app)
        .post('/api/v1/auth/register')
        .send({ email: 'otp_user@example.com', full_name: 'OTP User' });
    });

    it('на неизвестный контакт отвечает так же, как на известный', async () => {
      const res = await request(app)
        .post('/api/v1/auth/otp/request')
        .send({ email: 'never_registered@example.com' });

      expect(res.status).toBe(200);
      // И кода при этом не создаёт — иначе по базе можно было бы понять,
      // какие адреса заведены на ферме.
      const otp = await LoginOtp.findOne({
        where: { identifier: 'never_registered@example.com' }
      });
      expect(otp).toBeNull();
    });

    it('почта ищется без учёта регистра', async () => {
      await LoginOtp.destroy({ where: { identifier: 'otp_user@example.com' } });

      const res = await request(app)
        .post('/api/v1/auth/otp/request')
        .send({ email: 'OTP_User@Example.com' });

      expect(res.status).toBe(200);
      const otp = await LoginOtp.findOne({ where: { identifier: 'otp_user@example.com' } });
      expect(otp).not.toBeNull();
    });

    it('четвёртый запрос кода подряд отклоняется', async () => {
      // Регрессия: прежде чем создать новый код, сервис сносил прежние по
      // тому же контакту — и счётчик запросов, который считается по этим же
      // записям, никогда не превышал единицы. Лимит был недостижим, а ферму
      // можно было засыпать SMS.
      await LoginOtp.destroy({ where: { identifier: 'otp_user@example.com' } });

      for (let i = 0; i < 3; i += 1) {
        const ok = await request(app)
          .post('/api/v1/auth/otp/request')
          .send({ email: 'otp_user@example.com' });
        expect(ok.status).toBe(200);
      }

      const res = await request(app)
        .post('/api/v1/auth/otp/request')
        .send({ email: 'otp_user@example.com' });

      expect(res.status).toBe(429);
      expect(res.body.error.code).toBe('OTP_RATE_LIMITED');
    });

    it('нетаджикский номер отклоняется на валидации', async () => {
      const res = await request(app)
        .post('/api/v1/auth/otp/request')
        .send({ phone: '+79161234567' });

      expect(res.status).toBe(422);
    });

    it('без контакта — ошибка валидации', async () => {
      const res = await request(app).post('/api/v1/auth/otp/request').send({});

      expect(res.status).toBe(422);
    });

    it('телефон и почта сразу — тоже ошибка: непонятно, куда слать', async () => {
      const res = await request(app)
        .post('/api/v1/auth/otp/request')
        .send({ phone: '+992901234567', email: 'otp_user@example.com' });

      expect(res.status).toBe(422);
    });
  });

  describe('POST /api/v1/auth/otp/verify', () => {
    beforeAll(async () => {
      await request(app)
        .post('/api/v1/auth/register')
        .send({ email: 'verify@example.com', full_name: 'Verify User' });
    });

    it('верный код открывает сессию', async () => {
      const session = await signIn(app, { email: 'verify@example.com' });

      expect(session.accessToken).toEqual(expect.any(String));
      expect(session.refreshToken).toEqual(expect.any(String));
      expect(session.user.email).toBe('verify@example.com');
    });

    it('неверный код не пускает и не выдаёт токенов', async () => {
      await request(app)
        .post('/api/v1/auth/otp/request')
        .send({ email: 'verify@example.com' });

      const res = await request(app)
        .post('/api/v1/auth/otp/verify')
        .send({ email: 'verify@example.com', code: '000000' });

      expect(res.status).toBe(400);
      expect(res.body.error.code).toBe('OTP_INVALID');
    });

    it('просроченный код не принимается', async () => {
      await request(app)
        .post('/api/v1/auth/otp/request')
        .send({ email: 'verify@example.com' });
      const otp = await LoginOtp.findOne({
        where: { identifier: 'verify@example.com' },
        order: [['created_at', 'DESC']]
      });
      await otp.update({
        token_hash: hashOtp(KNOWN_CODE),
        expires_at: new Date(Date.now() - 60 * 1000)
      });

      const res = await request(app)
        .post('/api/v1/auth/otp/verify')
        .send({ email: 'verify@example.com', code: KNOWN_CODE });

      expect(res.status).toBe(400);
      expect(res.body.error.code).toBe('OTP_EXPIRED');
    });

    it('после пяти промахов код блокируется, даже если потом ввести верный',
      async () => {
        await request(app)
          .post('/api/v1/auth/otp/request')
          .send({ email: 'verify@example.com' });
        const otp = await LoginOtp.findOne({
          where: { identifier: 'verify@example.com' },
          order: [['created_at', 'DESC']]
        });
        await otp.update({ token_hash: hashOtp(KNOWN_CODE) });

        for (let i = 0; i < 5; i += 1) {
          await request(app)
            .post('/api/v1/auth/otp/verify')
            .send({ email: 'verify@example.com', code: '000000' });
        }

        const res = await request(app)
          .post('/api/v1/auth/otp/verify')
          .send({ email: 'verify@example.com', code: KNOWN_CODE });

        expect(res.status).toBe(429);
        expect(res.body.error.code).toBe('OTP_LOCKED');
      });

    it('отключённый аккаунт не пускают даже с верным кодом', async () => {
      await request(app)
        .post('/api/v1/auth/register')
        .send({ email: 'disabled@example.com', full_name: 'Disabled User' });
      await User.update(
        { is_active: false },
        { where: { email: 'disabled@example.com' } }
      );
      await request(app)
        .post('/api/v1/auth/otp/request')
        .send({ email: 'disabled@example.com' });

      // Кода на отключённый аккаунт сервис не создаёт вовсе — подкладываем
      // свой, чтобы проверить саму проверку на активность. Прежние записи
      // (код с регистрации) сносим: при совпадении секунды создания порядок
      // между ними не определён.
      await LoginOtp.destroy({ where: { identifier: 'disabled@example.com' } });
      await LoginOtp.create({
        identifier: 'disabled@example.com',
        channel: 'email',
        token_hash: hashOtp(KNOWN_CODE),
        expires_at: new Date(Date.now() + 10 * 60 * 1000)
      });

      const res = await request(app)
        .post('/api/v1/auth/otp/verify')
        .send({ email: 'disabled@example.com', code: KNOWN_CODE });

      expect(res.status).toBe(403);
    });
  });

  describe('GET /api/v1/auth/me', () => {
    let accessToken;

    beforeAll(async () => {
      ({ accessToken } = await registerFarm(app, {
        email: 'me@example.com',
        full_name: 'Me User'
      }));
    });

    it('возвращает профиль авторизованного пользователя', async () => {
      const res = await request(app)
        .get('/api/v1/auth/me')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.email).toBe('me@example.com');
      expect(res.body.data).not.toHaveProperty('password_hash');
    });

    it('отклоняет запрос без токена', async () => {
      const res = await request(app).get('/api/v1/auth/me');
      expect(res.status).toBe(401);
    });

    it('отклоняет запрос с невалидным токеном', async () => {
      const res = await request(app)
        .get('/api/v1/auth/me')
        .set('Authorization', 'Bearer invalid.token.here');
      expect(res.status).toBe(401);
    });
  });

  describe('POST /api/v1/auth/refresh', () => {
    let refreshToken;

    beforeAll(async () => {
      ({ refreshToken } = await registerFarm(app, {
        email: 'refresh@example.com',
        full_name: 'Refresh User'
      }));
    });

    it('обновляет access token по refresh token', async () => {
      const res = await request(app)
        .post('/api/v1/auth/refresh')
        .send({ refresh_token: refreshToken });

      expect(res.status).toBe(200);
      expect(res.body.data).toHaveProperty('access_token');
      expect(res.body.data).toHaveProperty('refresh_token');
    });

    it('отклоняет невалидный refresh token', async () => {
      const res = await request(app)
        .post('/api/v1/auth/refresh')
        .send({ refresh_token: 'invalid-token' });

      expect(res.status).toBe(401);
    });
  });

  describe('POST /api/v1/auth/logout', () => {
    it('инвалидирует refresh token', async () => {
      const { refreshToken } = await registerFarm(app, {
        email: 'logout@example.com',
        full_name: 'Logout User'
      });

      const logoutRes = await request(app)
        .post('/api/v1/auth/logout')
        .send({ refresh_token: refreshToken });

      expect(logoutRes.status).toBe(200);

      const refreshRes = await request(app)
        .post('/api/v1/auth/refresh')
        .send({ refresh_token: refreshToken });

      expect(refreshRes.status).toBe(401);
    });
  });

  describe('маршруты пароля закрыты', () => {
    // Пароля в сервисе нет: страницы входа паролем, его смены и сброса
    // исчезли вместе с ним. Старый клиент не должен получать на них
    // осмысленный ответ.
    it.each([
      ['/api/v1/auth/login', { email: 'me@example.com', password: 'Password123!' }],
      ['/api/v1/auth/change-password', { current_password: 'a', new_password: 'b' }],
      ['/api/v1/auth/forgot-password', { email: 'me@example.com' }],
      ['/api/v1/auth/reset-password', { email: 'me@example.com', code: '123456', new_password: 'x' }],
      ['/api/v1/auth/set-password', { new_password: 'Password123!' }],
      ['/api/v1/auth/accept-invitation', { code: 'x', password: 'y', full_name: 'z' }]
    ])('%s больше не существует', async (path, body) => {
      const res = await request(app).post(path).send(body);
      expect(res.status).toBe(404);
    });
  });

  describe('приглашение активируется тем же кодом входа', () => {
    it('код на приглашённую почту заводит работника в ферме', async () => {
      const owner = await registerFarm(app, {
        email: 'invite_owner@example.com',
        full_name: 'Владелец'
      });

      const invite = await request(app)
        .post('/api/v1/staff/invitations')
        .set('Authorization', `Bearer ${owner.accessToken}`)
        .send({
          email: 'invited_worker@example.com',
          full_name: 'Приглашённый Работник',
          role: 'worker'
        });
      expect(invite.status).toBe(201);

      await request(app)
        .post('/api/v1/auth/otp/request')
        .send({ email: 'invited_worker@example.com' });
      const session = await loginWithOtp(app, { email: 'invited_worker@example.com' });

      expect(session.user.role).toBe('worker');
      expect(session.user.full_name).toBe('Приглашённый Работник');
      expect(session.user.farm_id).toBe(owner.user.farm_id);
    });
  });
});
