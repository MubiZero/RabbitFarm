const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm, login } = require('./helpers/auth');

/**
 * Назначение — свойство хозяйства, а не двухсот карточек.
 *
 * Выставить его всему поголовью разом можно было и раньше, но каждый новый
 * кролик спрашивал заново, и фермер, заведя тридцатого подряд «на мясо»,
 * справедливо не понимал, зачем. Теперь хозяйство говорит это один раз.
 */
describe('Назначение по умолчанию', () => {
  let token;
  let breedId;
  const contact = { email: 'purpose_owner@example.com' };

  const auth = () => ({ Authorization: `Bearer ${token}` });

  const addRabbit = (body) =>
    request(app)
      .post('/api/v1/rabbits')
      .set(auth())
      .send({ breed_id: breedId, sex: 'female', birth_date: '2026-01-10', ...body });

  beforeAll(async () => {
    await syncTestDb();
    const owner = await registerFarm(app, { ...contact, full_name: 'Владелец' });
    token = owner.accessToken;

    const breed = await request(app)
      .post('/api/v1/breeds')
      .set(auth())
      .send({ name: 'Порода' });
    breedId = breed.body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  it('пока хозяйство не сказало, кролик заводится племенным', async () => {
    const res = await addRabbit({ name: 'Первая' });

    expect(res.status).toBe(201);
    expect(res.body.data.purpose).toBe('breeding');
  });

  it('простановка всему поголовью становится умолчанием хозяйства', async () => {
    await request(app)
      .patch('/api/v1/rabbits/purpose')
      .set(auth())
      .send({ purpose: 'meat' })
      .expect(200);

    const res = await addRabbit({ name: 'Вторая' });

    expect(res.status).toBe(201);
    // Фермер сказал «мы держим на мясо» один раз — и больше его об этом не
    // спрашивают.
    expect(res.body.data.purpose).toBe('meat');
  });

  it('названное в карточке важнее умолчания', async () => {
    const res = await addRabbit({ name: 'Третья', purpose: 'breeding' });

    expect(res.body.data.purpose).toBe('breeding');
  });

  it('приложение узнаёт умолчание вместе с фермой', async () => {
    // Иначе форма нового кролика не знала бы, что подставить, и показывала
    // бы «племя» ферме, которая держит на мясо.
    const session = await login(app, contact);
    expect(session.user.farm.default_purpose).toBe('meat');
  });
});
