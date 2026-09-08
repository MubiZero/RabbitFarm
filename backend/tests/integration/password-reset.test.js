const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { PasswordResetToken } = require('../../src/models');

// SMS/SMTP не настроены в tests/setup.js — оба транспорта молча деградируют
// (как push без Firebase), поэтому здесь проверяется только БД-уровень:
// сам факт отправки живьём проверен вручную (см. docs/HANDOFF.md).
describe('Сброс пароля по коду', () => {
  let ownerEmail;
  let ownerPassword;

  beforeAll(async () => {
    await syncTestDb();

    ownerEmail = 'reset_owner@example.com';
    ownerPassword = 'Password123!';

    await request(app)
      .post('/api/v1/auth/register')
      .send({ email: ownerEmail, password: ownerPassword, full_name: 'Владелец' });
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('POST /api/v1/auth/forgot-password', () => {
    it('всегда отвечает успехом для существующего email', async () => {
      const res = await request(app)
        .post('/api/v1/auth/forgot-password')
        .send({ email: ownerEmail });

      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
    });

    it('всегда отвечает успехом для несуществующего email (анти-энумерация)', async () => {
      const res = await request(app)
        .post('/api/v1/auth/forgot-password')
        .send({ email: 'ghost@example.com' });

      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
    });

    it('создаёт строку токена с каналом email (у пользователя нет телефона)', async () => {
      await request(app).post('/api/v1/auth/forgot-password').send({ email: ownerEmail });

      const { User } = require('../../src/models');
      const user = await User.findOne({ where: { email: ownerEmail } });
      const record = await PasswordResetToken.findOne({ where: { user_id: user.id } });

      expect(record).not.toBeNull();
      expect(record.channel).toBe('email');
      expect(record.attempts).toBe(0);
      expect(record.expires_at.getTime()).toBeGreaterThan(Date.now());
    });
  });

  describe('POST /api/v1/auth/reset-password', () => {
    // Код неизвестен тесту (транспорт замокан не был, письмо реально не
    // ушло) — читаем захешированный код напрямую нельзя, поэтому эти тесты
    // работают с заведомо неверным кодом и проверяют лок/срок жизни записи,
    // а успешный сценарий проверяется через service-level unit-тесты
    // (authService3.test.js), где код виден до хеширования.

    it('неверный код 5 раз подряд — блокирует запись, дальше даже верный код не примет', async () => {
      await request(app).post('/api/v1/auth/forgot-password').send({ email: ownerEmail });

      let res;
      for (let i = 0; i < 5; i++) {
        res = await request(app)
          .post('/api/v1/auth/reset-password')
          .send({ email: ownerEmail, code: '000000', new_password: 'AnotherPassword123!' });
        expect(res.status).toBe(400);
      }

      res = await request(app)
        .post('/api/v1/auth/reset-password')
        .send({ email: ownerEmail, code: '111111', new_password: 'AnotherPassword123!' });

      expect(res.status).toBe(429);
      expect(res.body.error.code).toBe('RESET_CODE_LOCKED');
    });

    it('неверный формат кода — отклоняется валидатором', async () => {
      const res = await request(app)
        .post('/api/v1/auth/reset-password')
        .send({ email: ownerEmail, code: '12', new_password: 'AnotherPassword123!' });

      expect(res.status).toBe(422);
    });

    it('без активного кода — неверный код отклоняется, пароль не меняется', async () => {
      const res = await request(app)
        .post('/api/v1/auth/reset-password')
        .send({ email: ownerEmail, code: '999999', new_password: 'AnotherPassword123!' });

      expect(res.status).toBe(400);

      const login = await request(app)
        .post('/api/v1/auth/login')
        .send({ email: ownerEmail, password: ownerPassword });
      expect(login.status).toBe(200);
    });
  });
});
