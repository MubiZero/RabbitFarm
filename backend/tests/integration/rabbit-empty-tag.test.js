const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');
const { Rabbit } = require('../../src/models');

const API = '/api/v1';

/**
 * Кролики без бирки друг другу не мешают.
 *
 * В мелком хозяйстве биркой не метят почти никого, и до этого доходили на
 * втором же кролике: форма при пустом поле шлёт пустую строку, она доезжала
 * до базы как обычное значение, а уникальный индекс `unique_user_rabbit_tag`
 * рассчитан на NULL — в самой миграции так и написано. Понятная проверка
 * дубликата пустую строку пропускала (для условия она ложна), и наружу
 * вылезал сырой конфликт «Такая запись уже существует».
 *
 * Проверять это модульным тестом бессмысленно: ломается оно об индекс живой
 * базы, а с замоканной моделью второй кролик заводится прекрасно.
 */
describe('Кролик без бирки', () => {
  let ownerToken;
  let breedId;

  beforeAll(async () => {
    await syncTestDb();

    const owner = await registerFarm(app, {
      email: 'no_tag_owner@example.com',
      full_name: 'Сафар'
    });
    ownerToken = owner.accessToken;

    const breed = await request(app)
      .post(`${API}/breeds`)
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ name: 'Серый великан' });
    breedId = breed.body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  const createRabbit = (name, tagId) =>
    request(app)
      .post(`${API}/rabbits`)
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({
        name,
        breed_id: breedId,
        sex: 'female',
        birth_date: '2025-03-01',
        ...(tagId === undefined ? {} : { tag_id: tagId })
      });

  it('второй и третий кролик с пустой биркой заводятся', async () => {
    const first = await createRabbit('Первая', '');
    const second = await createRabbit('Вторая', '');
    const third = await createRabbit('Третья', '   ');

    expect(first.status).toBe(201);
    expect(second.status).toBe(201);
    expect(third.status).toBe(201);
  });

  it('пустая бирка хранится как отсутствие, а не как пустая строка', async () => {
    const created = await createRabbit('Четвёртая', '');
    expect(created.status).toBe(201);

    // Именно NULL: на пустой строке индекс считает кроликов дубликатами.
    const stored = await Rabbit.findByPk(created.body.data.id, {
      tenantScope: 'all'
    });
    expect(stored.tag_id).toBeNull();
  });

  it('настоящий дубликат бирки по-прежнему отбивается понятной ошибкой', async () => {
    const first = await createRabbit('Меченая', 'R-001');
    const second = await createRabbit('Ещё одна', 'R-001');

    expect(first.status).toBe(201);
    expect(second.status).toBe(409);
    // Не сырой конфликт от базы («Такая запись уже существует»), а
    // объяснение про клеймо — человеку должно быть понятно, что поправить.
    expect(second.body.error.message).toMatch(/клейм/i);
  });

  it('очистка бирки у заведённого кролика не ломается об индекс', async () => {
    const created = await createRabbit('Была с биркой', 'R-777');
    expect(created.status).toBe(201);

    const cleared = await request(app)
      .put(`${API}/rabbits/${created.body.data.id}`)
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ tag_id: '' });

    expect(cleared.status).toBe(200);

    const stored = await Rabbit.findByPk(created.body.data.id, {
      tenantScope: 'all'
    });
    expect(stored.tag_id).toBeNull();
  });
});
