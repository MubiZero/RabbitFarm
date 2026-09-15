const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');

/**
 * «Просрочено прививок: 40» на ферме из восьми кроликов.
 *
 * Считались строки истории вакцинаций: кролик, привитый пять раз, давал пять
 * просрочек; павшие и проданные считались наравне с живыми; повторная
 * прививка старую строку не отменяла. Число не уменьшалось никогда, решения
 * по нему принять было нельзя — и каждое утро оно уходило пушем.
 */
describe('Просроченные прививки считаются кроликами', () => {
  let token;
  let breedId;

  const auth = () => ({ Authorization: `Bearer ${token}` });

  const yesterday = new Date(Date.now() - 24 * 60 * 60 * 1000)
    .toISOString()
    .split('T')[0];
  const nextMonth = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000)
    .toISOString()
    .split('T')[0];

  const addRabbit = async (name) => {
    const res = await request(app)
      .post('/api/v1/rabbits')
      .set(auth())
      .send({ name, breed_id: breedId, sex: 'female', birth_date: '2025-01-01' });
    return res.body.data.id;
  };

  const vaccinate = (rabbitId, nextDate) =>
    request(app)
      .post('/api/v1/vaccinations')
      .set(auth())
      .send({
        rabbit_id: rabbitId,
        vaccine_name: 'ВГБК',
        vaccine_type: 'vhd',
        vaccination_date: '2026-01-01',
        next_vaccination_date: nextDate
      });

  const overdueFromDashboard = async () => {
    const res = await request(app).get('/api/v1/reports/dashboard').set(auth());
    return res.body.data.health.overdueVaccinations;
  };

  beforeAll(async () => {
    await syncTestDb();

    const owner = await registerFarm(app, {
      email: 'vacc_owner@example.com',
      full_name: 'Владелец'
    });
    token = owner.accessToken;

    const breed = await request(app)
      .post('/api/v1/breeds')
      .set(auth())
      .send({ name: 'Порода для прививок' });
    breedId = breed.body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  it('один кролик с тремя просроченными записями — это один просроченный кролик', async () => {
    const rabbitId = await addRabbit('Мушка');
    await vaccinate(rabbitId, yesterday);
    await vaccinate(rabbitId, yesterday);
    await vaccinate(rabbitId, yesterday);

    expect(await overdueFromDashboard()).toBe(1);
  });

  it('повторная прививка снимает просрочку, а не добавляет к ней', async () => {
    const rabbitId = await addRabbit('Пушок');
    await vaccinate(rabbitId, yesterday);
    expect(await overdueFromDashboard()).toBe(2);

    // Привили заново, срок следующей — впереди.
    await vaccinate(rabbitId, nextMonth);
    expect(await overdueFromDashboard()).toBe(1);
  });

  it('павший кролик из просрочки уходит', async () => {
    const rabbitId = await addRabbit('Серый');
    await vaccinate(rabbitId, yesterday);
    expect(await overdueFromDashboard()).toBe(2);

    await request(app)
      .put(`/api/v1/rabbits/${rabbitId}`)
      .set(auth())
      .send({ status: 'dead' })
      .expect(200);

    expect(await overdueFromDashboard()).toBe(1);
  });
});
