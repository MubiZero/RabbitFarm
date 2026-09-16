const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');

/**
 * Продажа кролика и дата выбытия.
 *
 * Связь «приход категории sale_* → кролик продан» работала, а дату выбытия не
 * ставил никто. Поголовье в недельной сводке считается именно по датам
 * (`reportController`), а не по статусу: кролик без `sold_date` навсегда
 * оставался в графике живым, хотя в карточке значился проданным. То же с
 * падежом, когда статус меняют не формой падежа.
 */
describe('Продажа кролика и дата выбытия', () => {
  let token;
  let breedId;
  let cageId;

  const auth = () => ({ Authorization: `Bearer ${token}` });

  beforeAll(async () => {
    await syncTestDb();

    const owner = await registerFarm(app, {
      email: 'sale_owner@example.com',
      full_name: 'Владелец'
    });
    token = owner.accessToken;

    const breed = await request(app)
      .post('/api/v1/breeds')
      .set(auth())
      .send({ name: 'Порода для продажи' });
    breedId = breed.body.data.id;

    const cage = await request(app)
      .post('/api/v1/cages')
      .set(auth())
      .send({ number: 'S-1', type: 'single', capacity: 4 });
    cageId = cage.body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  const createRabbit = async (name) => {
    const res = await request(app)
      .post('/api/v1/rabbits')
      .set(auth())
      .send({
        name,
        breed_id: breedId,
        sex: 'female',
        birth_date: '2025-01-01',
        cage_id: cageId
      });
    return res.body.data.id;
  };

  const rabbit = async (id) => {
    const res = await request(app).get(`/api/v1/rabbits/${id}`).set(auth());
    return res.body.data;
  };

  it('приход за кролика делает его проданным днём самой продажи', async () => {
    const id = await createRabbit('Мушка');

    const res = await request(app)
      .post('/api/v1/transactions')
      .set(auth())
      .send({
        type: 'income',
        category: 'sale_rabbit',
        amount: 450,
        transaction_date: '2026-09-10',
        rabbit_id: id
      });

    expect(res.status).toBe(201);

    const after = await rabbit(id);
    expect(after.status).toBe('sold');
    // День продажи, а не день, когда о ней вспомнили записать.
    expect(after.sold_date).toBe('2026-09-10');
    // Клетку продавший освобождает — место занимать больше некому.
    expect(after.cage_id).toBeNull();
  });

  it('статус «продан» без даты проставляет её сам', async () => {
    const id = await createRabbit('Белка');

    const res = await request(app)
      .put(`/api/v1/rabbits/${id}`)
      .set(auth())
      .send({ status: 'sold' });

    expect(res.status).toBe(200);

    const after = await rabbit(id);
    expect(after.status).toBe('sold');
    expect(after.sold_date).not.toBeNull();
  });

  it('присланная дата продажи остаётся как есть', async () => {
    const id = await createRabbit('Стрелка');

    await request(app)
      .put(`/api/v1/rabbits/${id}`)
      .set(auth())
      .send({ status: 'sold', sold_date: '2026-08-01' });

    expect((await rabbit(id)).sold_date).toBe('2026-08-01');
  });

  // Тот же провал графика с другой стороны: статус падежа можно поставить и
  // не формой падежа — правкой карточки, где даты не спрашивают вовсе.
  it('статус «пал» без даты проставляет день падежа сам', async () => {
    const id = await createRabbit('Найда');

    await request(app).put(`/api/v1/rabbits/${id}`).set(auth()).send({ status: 'dead' });

    const after = await rabbit(id);
    expect(after.status).toBe('dead');
    expect(after.death_date).not.toBeNull();
  });

  it('повторный приход по проданному кролику дату продажи не переписывает', async () => {
    const id = await createRabbit('Ночка');

    await request(app)
      .post('/api/v1/transactions')
      .set(auth())
      .send({
        type: 'income',
        category: 'sale_rabbit',
        amount: 300,
        transaction_date: '2026-09-01',
        rabbit_id: id
      });

    await request(app)
      .post('/api/v1/transactions')
      .set(auth())
      .send({
        type: 'income',
        category: 'sale_rabbit',
        amount: 300,
        transaction_date: '2026-09-20',
        rabbit_id: id
      });

    expect((await rabbit(id)).sold_date).toBe('2026-09-01');
  });
});
