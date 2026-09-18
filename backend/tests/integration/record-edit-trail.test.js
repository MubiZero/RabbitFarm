const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm, login } = require('./helpers/auth');
const { User } = require('../../src/models');

/**
 * След правки: кто исправил чужую запись — и вправе ли он был.
 *
 * До сих пор кормление правил любой сотрудник (проверки роли на маршруте не
 * было вовсе), а после правки запись оставалась подписана тем, кто завёл её
 * изначально: ни отметки «исправлено», ни автора правки. В хозяйстве с
 * наёмными людьми это второй по значимости страх владельца после
 * пропущенного окрола.
 */
describe('След правки записи', () => {
  const auth = (token) => ({ Authorization: `Bearer ${token}` });

  let ownerToken;
  let workerToken;
  let otherWorkerToken;
  let feedId;
  let cageId;
  let breedId;

  const addWorker = async (email, fullName, farmId, role = 'worker') => {
    await request(app)
      .post('/api/v1/auth/register')
      .send({ email, full_name: fullName });
    await User.update({ farm_id: farmId, role }, { where: { email } });
    const session = await login(app, { email });
    return session.accessToken;
  };

  beforeAll(async () => {
    await syncTestDb();

    const owner = await registerFarm(app, {
      email: 'trail_owner@example.com',
      full_name: 'Владелец'
    });
    ownerToken = owner.accessToken;
    const farmId = owner.user.farm_id;

    workerToken = await addWorker(
      'trail_worker@example.com',
      'Сафар',
      farmId
    );
    otherWorkerToken = await addWorker(
      'trail_worker2@example.com',
      'Дилноза',
      farmId
    );

    const feed = await request(app)
      .post('/api/v1/feeds')
      .set(auth(ownerToken))
      .send({
        name: 'Комбикорм',
        type: 'pellets',
        unit: 'kg',
        current_stock: 500,
        cost_per_unit: 4
      });
    feedId = feed.body.data.id;

    // Кормление требует адресата — кролика или клетку.
    const cage = await request(app)
      .post('/api/v1/cages')
      .set(auth(ownerToken))
      .send({ number: 'A-1', capacity: 5 });
    cageId = cage.body.data.id;

    const breed = await request(app)
      .post('/api/v1/breeds')
      .set(auth(ownerToken))
      .send({ name: 'Порода для правок' });
    breedId = breed.body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  const feedRecord = async (token, quantity = 2) => {
    const res = await request(app)
      .post('/api/v1/feeding-records')
      .set(auth(token))
      .send({
        feed_id: feedId,
        cage_id: cageId,
        quantity,
        fed_at: '2026-09-14T08:00:00.000Z'
      });
    return res.body.data.id;
  };

  const dataLog = async () => {
    const res = await request(app)
      .get('/api/v1/staff/audit')
      .query({ scope: 'data', limit: 100 })
      .set(auth(ownerToken));
    return res.body.data.items;
  };

  it('свою запись работник правит сам', async () => {
    const id = await feedRecord(workerToken, 2);

    const res = await request(app)
      .put(`/api/v1/feeding-records/${id}`)
      .set(auth(workerToken))
      .send({ quantity: 3 });

    expect(res.status).toBe(200);
  });

  it('чужую запись работник не правит', async () => {
    const id = await feedRecord(workerToken, 2);

    const res = await request(app)
      .put(`/api/v1/feeding-records/${id}`)
      .set(auth(otherWorkerToken))
      .send({ quantity: 9 });

    expect(res.status).toBe(403);
    // Код, а не текст: приложение переводит отказ на язык читателя.
    expect(res.body.error.code).toBe('NOT_RECORD_AUTHOR');
  });

  it('владелец правит любую, и правка оставляет след', async () => {
    const id = await feedRecord(workerToken, 2);

    await request(app)
      .put(`/api/v1/feeding-records/${id}`)
      .set(auth(ownerToken))
      .send({ quantity: 5 })
      .expect(200);

    const row = (await dataLog()).find(
      (item) => item.entity_type === 'feeding_record' && item.entity_id === id
    );

    expect(row).toBeDefined();
    expect(row.action).toBe('feeding_record.updated');
    expect(row.actor.full_name).toBe('Владелец');
    // «Было 2, стало 5» владелец проверит сам — «кто-то что-то поправил» нет.
    expect(Number(row.before.quantity)).toBe(2);
    expect(Number(row.after.quantity)).toBe(5);
  });

  it('списанный со склада корм за правку кормления себя не выдаёт', async () => {
    // Иначе журнал заполнился бы остатками корма, за которыми не видно
    // работы людей: каждая правка кормления трогает и склад.
    const id = await feedRecord(workerToken, 2);

    await request(app)
      .put(`/api/v1/feeding-records/${id}`)
      .set(auth(ownerToken))
      .send({ quantity: 4 })
      .expect(200);

    const feedRows = (await dataLog()).filter(
      (item) => item.entity_type === 'feed'
    );

    expect(feedRows).toHaveLength(0);
  });

  it('лечение подписано автором, и правка тоже', async () => {
    const rabbit = await request(app)
      .post('/api/v1/rabbits')
      .set(auth(ownerToken))
      .send({
        name: 'Мушка',
        breed_id: breedId,
        sex: 'female',
        birth_date: '2026-01-01'
      });
    const rabbitId = rabbit.body.data.id;

    const created = await request(app)
      .post('/api/v1/medical-records')
      .set(auth(workerToken))
      .send({
        rabbit_id: rabbitId,
        symptoms: 'Вялость, отказ от корма',
        diagnosis: 'Кокцидиоз',
        started_at: '2026-09-10',
        outcome: 'ongoing'
      });

    expect(created.status).toBe(201);
    // До этой правки лечение было единственной записью фермы без автора.
    expect(created.body.data.author.full_name).toBe('Сафар');

    const foreign = await request(app)
      .put(`/api/v1/medical-records/${created.body.data.id}`)
      .set(auth(otherWorkerToken))
      .send({ diagnosis: 'Пастереллёз' });

    expect(foreign.status).toBe(403);

    await request(app)
      .put(`/api/v1/medical-records/${created.body.data.id}`)
      .set(auth(workerToken))
      .send({ diagnosis: 'Пастереллёз' })
      .expect(200);

    const row = (await dataLog()).find(
      (item) =>
        item.entity_type === 'medical_record' &&
        item.entity_id === created.body.data.id
    );

    expect(row.action).toBe('medical_record.updated');
    expect(row.before.diagnosis).toBe('Кокцидиоз');
    expect(row.after.diagnosis).toBe('Пастереллёз');
  });
});
