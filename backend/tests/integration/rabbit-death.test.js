const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');

/**
 * Отметка падежа — та сторона провода, на которую смотрит приложение.
 *
 * Экран «Отметить падёж» слал статус `deceased`, которого в списке
 * допустимых нет, и каждая попытка получала 422: падёж нельзя было записать
 * ни разу, а без связи запись вдобавок выбрасывалась из очереди как
 * «неисправимая». Проверка написана со стороны сервера и словами, а не
 * константами: ошибка была именно в константе приложения.
 */
describe('Отметка падежа', () => {
  let token;
  let breedId;

  const auth = () => ({ Authorization: `Bearer ${token}` });

  beforeAll(async () => {
    await syncTestDb();

    const owner = await registerFarm(app, {
      email: 'death_owner@example.com',
      full_name: 'Владелец'
    });
    token = owner.accessToken;

    const breed = await request(app)
      .post('/api/v1/breeds')
      .set(auth())
      .send({ name: 'Порода для падежа' });
    breedId = breed.body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  const createRabbit = async () => {
    const res = await request(app)
      .post('/api/v1/rabbits')
      .set(auth())
      .send({ name: 'Мушка', breed_id: breedId, sex: 'female', birth_date: '2025-01-01' });
    return res.body.data.id;
  };

  it('принимает статус, дату и причину — ровно то, что шлёт экран', async () => {
    const id = await createRabbit();

    const res = await request(app)
      .put(`/api/v1/rabbits/${id}`)
      .set(auth())
      .send({
        status: 'dead',
        death_date: '2026-09-14',
        death_reason: 'Не ела два дня'
      });

    expect(res.status).toBe(200);

    const after = await request(app).get(`/api/v1/rabbits/${id}`).set(auth());
    expect(after.body.data.status).toBe('dead');
    expect(after.body.data.death_reason).toBe('Не ела два дня');
    // Дата смерти раньше не доезжала вовсе: приложение её не отправляло.
    expect(after.body.data.death_date).toBe('2026-09-14');
  });

  it('слово «deceased» сервер не знает — приложению его слать нельзя', async () => {
    const id = await createRabbit();

    const res = await request(app)
      .put(`/api/v1/rabbits/${id}`)
      .set(auth())
      .send({ status: 'deceased' });

    expect(res.status).toBe(422);
  });
});
