const request = require('supertest');
const { LoginOtp } = require('../../../src/models');
const { hashOtp } = require('../../../src/utils/otp');

/**
 * Регистрация и вход для интеграционных тестов.
 *
 * Пароля в сервисе нет: регистрация только заводит ферму и отправляет код, а
 * сессию открывает `/auth/otp/verify`. Тесту незачем ждать SMS — код в базе
 * подменяется известным, как это делает живой человек, прочитавший сообщение.
 *
 * Возвращает и токены, и id, чтобы тест не разбирал ответ сам.
 */
const KNOWN_CODE = '123456';

/** Подменить свежесозданный код известным и войти им. */
const loginWithOtp = async (app, contact) => {
  const identifier = contact.phone
    ? contact.phone.replace(/[^\d]/g, '').replace(/^(992)?/, '+992')
    : contact.email.trim().toLowerCase();

  const record = await LoginOtp.findOne({
    where: { identifier },
    order: [['created_at', 'DESC']]
  });
  if (!record) {
    throw new Error(`Код для ${identifier} не создан — вход невозможен`);
  }
  await record.update({ token_hash: hashOtp(KNOWN_CODE), attempts: 0 });

  const res = await request(app)
    .post('/api/v1/auth/otp/verify')
    .send({ ...contact, code: KNOWN_CODE });

  if (!res.body.success) {
    throw new Error(`Вход не удался: ${JSON.stringify(res.body)}`);
  }
  return res.body.data;
};

/**
 * Завести ферму и войти в неё. `contact` — `{ email }` или `{ phone }`.
 * @returns {Object} `{ accessToken, refreshToken, user }`
 */
const registerFarm = async (app, { full_name: fullName = 'Farmer', farm_name: farmName, ...contact } = {}) => {
  const payload = { full_name: fullName, ...contact };
  if (farmName) payload.farm_name = farmName;

  const res = await request(app).post('/api/v1/auth/register').send(payload);
  if (!res.body.success) {
    throw new Error(`Регистрация не удалась: ${JSON.stringify(res.body)}`);
  }

  const session = await loginWithOtp(app, contact);
  return {
    accessToken: session.access_token,
    refreshToken: session.refresh_token,
    user: session.user
  };
};

/** Войти в уже существующий аккаунт: запросить код и подтвердить его. */
const login = async (app, contact) => {
  await request(app).post('/api/v1/auth/otp/request').send(contact);
  const session = await loginWithOtp(app, contact);
  return {
    accessToken: session.access_token,
    refreshToken: session.refresh_token,
    user: session.user
  };
};

module.exports = { registerFarm, login, loginWithOtp, KNOWN_CODE };
