const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');

/**
 * Назначение кролика (племя / мясо / продажа / выставка).
 *
 * Поле обязательное с самого начала, но жило одним лишь фильтром списка:
 * сводки по нему не было нигде, а выставлять его по одному на двухстах
 * карточках никто не станет. Большинство хозяйств держат кроликов для
 * чего-то одного — значит, это свойство хозяйства, а не двухсот карточек.
 */
describe('Назначение поголовья', () => {
  let token;
  let workerToken;
  let breedId;

  const auth = () => ({ Authorization: `Bearer ${token}` });

  beforeAll(async () => {
    await syncTestDb();

    const owner = await registerFarm(app, {
      email: 'purpose_owner@example.com',
      full_name: 'Владелец'
    });
    token = owner.accessToken;

    const breed = await request(app)
      .post('/api/v1/breeds')
      .set(auth())
      .send({ name: 'Порода для назначения' });
    breedId = breed.body.data.id;

    const other = await registerFarm(app, {
      email: 'purpose_stranger@example.com',
      full_name: 'Чужой владелец'
    });
    workerToken = other.accessToken;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  const createRabbit = async (name, purpose) => {
    const res = await request(app)
      .post('/api/v1/rabbits')
      .set(auth())
      .send({
        name,
        breed_id: breedId,
        sex: 'female',
        birth_date: '2025-01-01',
        purpose
      });
    return res.body.data.id;
  };

  const purposeOf = async (id) => {
    const res = await request(app).get(`/api/v1/rabbits/${id}`).set(auth());
    return res.body.data.purpose;
  };

  it('выставляет назначение всему живому поголовью и говорит, скольких задело',
    async () => {
      const first = await createRabbit('Мушка', 'breeding');
      const second = await createRabbit('Белка', 'breeding');
      const already = await createRabbit('Стрелка', 'meat');

      const res = await request(app)
        .patch('/api/v1/rabbits/purpose')
        .set(auth())
        .send({ purpose: 'meat' });

      expect(res.status).toBe(200);
      // Счёт — только реально изменённые: экран спрашивает подтверждение
      // числом, и итог обязан с ним совпасть.
      expect(res.body.data.changed).toBe(2);

      expect(await purposeOf(first)).toBe('meat');
      expect(await purposeOf(second)).toBe('meat');
      expect(await purposeOf(already)).toBe('meat');
    });

  // Назначение проданного кролика — запись о том, кем он был. Переписывать
  // её задним числом незачем.
  it('выбывших не трогает', async () => {
    const sold = await createRabbit('Ночка', 'breeding');
    await request(app)
      .put(`/api/v1/rabbits/${sold}`)
      .set(auth())
      .send({ status: 'sold' });

    await request(app)
      .patch('/api/v1/rabbits/purpose')
      .set(auth())
      .send({ purpose: 'sale' });

    expect(await purposeOf(sold)).toBe('breeding');
  });

  it('чужое поголовье не задевает', async () => {
    const mine = await createRabbit('Найда', 'breeding');

    const strangerBreed = await request(app)
      .post('/api/v1/breeds')
      .set({ Authorization: `Bearer ${workerToken}` })
      .send({ name: 'Чужая порода' });

    const stranger = await request(app)
      .post('/api/v1/rabbits')
      .set({ Authorization: `Bearer ${workerToken}` })
      .send({
        name: 'Чужой кролик',
        breed_id: strangerBreed.body.data.id,
        sex: 'male',
        birth_date: '2025-01-01',
        purpose: 'breeding'
      });

    await request(app)
      .patch('/api/v1/rabbits/purpose')
      .set(auth())
      .send({ purpose: 'show' });

    expect(await purposeOf(mine)).toBe('show');

    const strangerAfter = await request(app)
      .get(`/api/v1/rabbits/${stranger.body.data.id}`)
      .set({ Authorization: `Bearer ${workerToken}` });
    expect(strangerAfter.body.data.purpose).toBe('breeding');
  });

  it('неизвестное назначение отвергается целиком', async () => {
    const res = await request(app)
      .patch('/api/v1/rabbits/purpose')
      .set(auth())
      .send({ purpose: 'на суп' });

    expect(res.status).toBe(422);
  });

  // Сводки по назначению не было нигде: поле заполняли на каждом кролике, а
  // числа «сколько племенных, сколько на откорме» не показывал ни один экран.
  it('отчёт по ферме считает поголовье по назначению', async () => {
    await request(app)
      .patch('/api/v1/rabbits/purpose')
      .set(auth())
      .send({ purpose: 'meat' });

    const res = await request(app).get('/api/v1/reports/farm').set(auth());

    expect(res.status).toBe(200);
    const byPurpose = res.body.data.population.by_purpose;
    const meat = byPurpose.find((row) => row.purpose === 'meat');
    // Те же живые, что и в общем поголовье рядом.
    expect(meat.count).toBe(res.body.data.population.total_rabbits);
  });
});
