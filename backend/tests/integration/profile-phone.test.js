const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm, login: signIn } = require('./helpers/auth');
const { User } = require('../../src/models');

/**
 * Телефон в профиле — это логин: вход ищет его строго как `+992XXXXXXXXX`.
 * Пока профиль принимал любой международный формат и не приводил номер,
 * человек мог сохранить «992 18 666 33 33» и потом не найтись при входе.
 */
describe('Телефон в профиле', () => {
  let accessToken;
  let userId;

  beforeAll(async () => {
    await syncTestDb();
    const session = await registerFarm(app, {
      email: 'profile_owner@example.com',
      full_name: 'Владелец'
    });
    accessToken = session.accessToken;
    userId = session.user.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  const save = (phone) => request(app)
    .put('/api/v1/auth/profile')
    .set('Authorization', `Bearer ${accessToken}`)
    .send({ phone });

  it('номер приводится к тому виду, в котором его ищет вход', async () => {
    const res = await save('90 123 45 67');

    expect(res.status).toBe(200);
    expect(res.body.data.phone).toBe('+992901234567');

    // И теперь по нему действительно можно войти.
    const otp = await request(app)
      .post('/api/v1/auth/otp/request')
      .send({ phone: '+992901234567' });
    expect(otp.status).toBe(200);
    const session = await signIn(app, { phone: '+992901234567' });
    expect(session.user.id).toBe(userId);
  });

  it('нетаджикский номер не принимается — код на него всё равно не уйдёт',
    async () => {
      const res = await save('+79161234567');

      expect(res.status).toBe(422);
    });

  it('пустая строка стирает номер, а не сохраняет пустоту', async () => {
    const res = await save('');

    expect(res.status).toBe(200);
    const user = await User.findByPk(userId);
    // Именно NULL: телефон уникален на всю базу, и вторая пустая строка
    // упёрлась бы в тот же индекс.
    expect(user.phone).toBeNull();
  });

  it('занятый чужой номер отклоняется понятной ошибкой, а не пятисоткой',
    async () => {
      await registerFarm(app, {
        phone: '+992905550001',
        full_name: 'Сосед'
      });

      const res = await save('905550001');

      expect(res.status).toBe(409);
      expect(res.body.error.code).toBe('PHONE_EXISTS');
    });
});
