const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');

/**
 * Ферм в сервисе много, а привязку к ферме сервисы получают параметром —
 * забытый параметр ничем не ловится и выглядит как обычный рабочий запрос.
 * Поэтому здесь проверяется не «код ответа приличный», а то, что ферма Б
 * вообще не достаёт данные фермы А: ни списком, ни по идентификатору,
 * ни ссылкой из собственного запроса, ни счётчиком.
 *
 * Чужая запись отвечает 404, а не 403: сам факт её существования — тоже
 * чужие данные.
 */
describe('Изоляция ферм: поголовье, породы, клетки', () => {
  const farmA = {};
  const farmB = {};

  const authorized = (token) => ({ Authorization: `Bearer ${token}` });

  const tokenForNewFarm = async (email, fullName) => {
    const { accessToken } = await registerFarm(app, { email, full_name: fullName });

    return accessToken;
  };

  const createBreed = (token, name) =>
    request(app)
      .post('/api/v1/breeds')
      .set(authorized(token))
      .send({ name });

  const createCage = (token, number) =>
    request(app)
      .post('/api/v1/cages')
      .set(authorized(token))
      .send({ number, capacity: 5 });

  const createRabbit = (token, payload) =>
    request(app)
      .post('/api/v1/rabbits')
      .set(authorized(token))
      .send({ sex: 'female', birth_date: '2025-01-01', ...payload });

  const asFarm = (token, method, url) =>
    request(app)[method](url).set(authorized(token));

  const listBreeds = (token) => asFarm(token, 'get', '/api/v1/breeds');
  const listCages = (token) => asFarm(token, 'get', '/api/v1/cages').query({ limit: 100 });
  const listRabbits = (token, query = {}) =>
    asFarm(token, 'get', '/api/v1/rabbits').query({ limit: 100, ...query });

  beforeAll(async () => {
    await syncTestDb();

    farmA.token = await tokenForNewFarm('isolation-farm-a@example.com', 'Владелец фермы А');
    farmB.token = await tokenForNewFarm('isolation-farm-b@example.com', 'Владелец фермы Б');

    farmA.breedId = (await createBreed(farmA.token, 'Порода фермы А')).body.data.id;
    farmB.breedId = (await createBreed(farmB.token, 'Порода фермы Б')).body.data.id;

    farmA.cageId = (await createCage(farmA.token, 'A-1')).body.data.id;
    farmB.cageId = (await createCage(farmB.token, 'B-1')).body.data.id;

    farmA.rabbitId = (await createRabbit(farmA.token, {
      name: 'Кролик фермы А',
      tag_id: 'A-001',
      sex: 'male',
      breed_id: farmA.breedId,
      cage_id: farmA.cageId
    })).body.data.id;

    farmB.rabbitId = (await createRabbit(farmB.token, {
      name: 'Кролик фермы Б',
      tag_id: 'B-001',
      breed_id: farmB.breedId,
      cage_id: farmB.cageId
    })).body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('списки', () => {
    it('не показывает ферме Б породы фермы А', async () => {
      const res = await listBreeds(farmB.token);

      expect(res.status).toBe(200);
      expect(res.body.data.map((breed) => breed.name)).toEqual(['Порода фермы Б']);
    });

    it('не показывает ферме Б клетки фермы А', async () => {
      const res = await listCages(farmB.token);

      expect(res.status).toBe(200);
      expect(res.body.data.items.map((cage) => cage.number)).toEqual(['B-1']);
    });

    it('не показывает ферме Б кроликов фермы А', async () => {
      const res = await listRabbits(farmB.token);

      expect(res.status).toBe(200);
      expect(res.body.data.items.map((rabbit) => rabbit.name)).toEqual(['Кролик фермы Б']);
      expect(res.body.data.pagination.total).toBe(1);
    });

    it('не расширяет выборку поиском по имени', async () => {
      // «Кролик» есть в имени у обеих ферм: поиск не должен становиться
      // лазейкой мимо фильтра по ферме.
      const res = await listRabbits(farmB.token, { search: 'Кролик' });

      expect(res.status).toBe(200);
      expect(res.body.data.items.map((rabbit) => rabbit.name)).toEqual(['Кролик фермы Б']);
    });

    it('не находит чужого кролика по его клейму', async () => {
      const res = await listRabbits(farmB.token, { search: 'A-001' });

      expect(res.status).toBe(200);
      expect(res.body.data.items).toEqual([]);
    });
  });

  describe('чтение чужой записи по id', () => {
    it('порода фермы А не читается фермой Б', async () => {
      const res = await asFarm(farmB.token, 'get', `/api/v1/breeds/${farmA.breedId}`);

      expect(res.status).toBe(404);
    });

    it('клетка фермы А не читается фермой Б', async () => {
      const res = await asFarm(farmB.token, 'get', `/api/v1/cages/${farmA.cageId}`);

      expect(res.status).toBe(404);
    });

    it('кролик фермы А не читается фермой Б', async () => {
      const res = await asFarm(farmB.token, 'get', `/api/v1/rabbits/${farmA.rabbitId}`);

      expect(res.status).toBe(404);
    });

    it('родословная чужого кролика не читается', async () => {
      const res = await asFarm(farmB.token, 'get', `/api/v1/rabbits/${farmA.rabbitId}/pedigree`);

      expect(res.status).toBe(404);
    });

    it('история взвешиваний чужого кролика не читается', async () => {
      const res = await asFarm(farmB.token, 'get', `/api/v1/rabbits/${farmA.rabbitId}/weights`);

      expect(res.status).toBe(404);
    });
  });

  describe('правка чужой записи', () => {
    it('не даёт переименовать чужую породу', async () => {
      const res = await request(app)
        .put(`/api/v1/breeds/${farmA.breedId}`)
        .set(authorized(farmB.token))
        .send({ name: 'Захвачено' });

      expect(res.status).toBe(404);

      const original = await asFarm(farmA.token, 'get', `/api/v1/breeds/${farmA.breedId}`);
      expect(original.body.data.name).toBe('Порода фермы А');
    });

    it('не даёт переписать чужую клетку', async () => {
      const res = await request(app)
        .put(`/api/v1/cages/${farmA.cageId}`)
        .set(authorized(farmB.token))
        .send({ location: 'Захвачено', capacity: 99 });

      expect(res.status).toBe(404);

      const original = await asFarm(farmA.token, 'get', `/api/v1/cages/${farmA.cageId}`);
      expect(original.body.data.location).not.toBe('Захвачено');
      expect(original.body.data.capacity).toBe(5);
    });

    it('не даёт переписать чужого кролика', async () => {
      const res = await request(app)
        .put(`/api/v1/rabbits/${farmA.rabbitId}`)
        .set(authorized(farmB.token))
        .send({ name: 'Захвачен', status: 'dead' });

      expect(res.status).toBe(404);

      const original = await asFarm(farmA.token, 'get', `/api/v1/rabbits/${farmA.rabbitId}`);
      expect(original.body.data.name).toBe('Кролик фермы А');
      expect(original.body.data.status).not.toBe('dead');
    });

    it('не даёт записать вес чужому кролику', async () => {
      const res = await request(app)
        .post(`/api/v1/rabbits/${farmA.rabbitId}/weights`)
        .set(authorized(farmB.token))
        .send({ weight: 3.5 });

      expect(res.status).toBe(404);

      const history = await asFarm(farmA.token, 'get', `/api/v1/rabbits/${farmA.rabbitId}/weights`);
      expect(history.body.data).toEqual([]);
    });

    it('не даёт отметить уборку в чужой клетке', async () => {
      const res = await asFarm(farmB.token, 'patch', `/api/v1/cages/${farmA.cageId}/clean`);

      expect(res.status).toBe(404);

      const original = await asFarm(farmA.token, 'get', `/api/v1/cages/${farmA.cageId}`);
      expect(original.body.data.last_cleaned_at).toBeNull();
    });
  });

  describe('удаление чужой записи', () => {
    it('не даёт удалить чужую породу', async () => {
      const res = await asFarm(farmB.token, 'delete', `/api/v1/breeds/${farmA.breedId}`);

      expect(res.status).toBe(404);

      const survived = await asFarm(farmA.token, 'get', `/api/v1/breeds/${farmA.breedId}`);
      expect(survived.status).toBe(200);
    });

    it('не даёт удалить чужую клетку', async () => {
      const res = await asFarm(farmB.token, 'delete', `/api/v1/cages/${farmA.cageId}`);

      expect(res.status).toBe(404);

      const survived = await asFarm(farmA.token, 'get', `/api/v1/cages/${farmA.cageId}`);
      expect(survived.status).toBe(200);
    });

    it('не даёт удалить чужого кролика', async () => {
      const res = await asFarm(farmB.token, 'delete', `/api/v1/rabbits/${farmA.rabbitId}`);

      expect(res.status).toBe(404);

      const survived = await asFarm(farmA.token, 'get', `/api/v1/rabbits/${farmA.rabbitId}`);
      expect(survived.status).toBe(200);
    });
  });

  describe('ссылки на чужие идентификаторы', () => {
    it('не даёт завести кролика с чужой породой', async () => {
      const res = await createRabbit(farmB.token, {
        name: 'Через чужую породу',
        breed_id: farmA.breedId
      });

      expect(res.status).toBe(404);
    });

    it('не даёт посадить своего кролика в чужую клетку', async () => {
      const res = await createRabbit(farmB.token, {
        name: 'Через чужую клетку',
        breed_id: farmB.breedId,
        cage_id: farmA.cageId
      });

      expect(res.status).toBe(404);
    });

    it('не даёт записать чужого кролика в родители', async () => {
      const res = await createRabbit(farmB.token, {
        name: 'Через чужого отца',
        breed_id: farmB.breedId,
        father_id: farmA.rabbitId
      });

      expect(res.status).toBe(400);
    });

    it('не даёт правкой подменить породу на чужую', async () => {
      const res = await request(app)
        .put(`/api/v1/rabbits/${farmB.rabbitId}`)
        .set(authorized(farmB.token))
        .send({ breed_id: farmA.breedId });

      expect(res.status).toBe(404);

      const own = await asFarm(farmB.token, 'get', `/api/v1/rabbits/${farmB.rabbitId}`);
      expect(own.body.data.breed_id).toBe(farmB.breedId);
      expect(own.body.data.breed.name).toBe('Порода фермы Б');
    });

    it('не даёт правкой переселить кролика в чужую клетку', async () => {
      const res = await request(app)
        .put(`/api/v1/rabbits/${farmB.rabbitId}`)
        .set(authorized(farmB.token))
        .send({ cage_id: farmA.cageId });

      expect(res.status).toBe(404);

      const own = await asFarm(farmB.token, 'get', `/api/v1/rabbits/${farmB.rabbitId}`);
      expect(own.body.data.cage_id).toBe(farmB.cageId);
    });

    it('ни одна из отклонённых попыток не создала запись', async () => {
      const res = await listRabbits(farmB.token);

      expect(res.body.data.items.map((rabbit) => rabbit.name)).toEqual(['Кролик фермы Б']);
    });
  });

  describe('счётчики и статистика', () => {
    it('статистика поголовья фермы Б не считает кроликов фермы А', async () => {
      const res = await asFarm(farmB.token, 'get', '/api/v1/rabbits/statistics');

      expect(res.status).toBe(200);
      expect(res.body.data.total).toBe(1);
      expect(res.body.data.female_count).toBe(1);
      expect(res.body.data.male_count).toBe(0);
      expect(res.body.data.by_breed).toEqual([
        expect.objectContaining({ breed_name: 'Порода фермы Б', count: 1 })
      ]);
    });

    it('статистика клеток фермы Б не считает клетки фермы А', async () => {
      const res = await asFarm(farmB.token, 'get', '/api/v1/cages/statistics');

      expect(res.status).toBe(200);
      expect(res.body.data.total_cages).toBe(1);
      expect(res.body.data.occupancy.total_capacity).toBe(5);
      expect(res.body.data.occupancy.current_occupancy).toBe(1);
    });

    it('заполненность клетки считается только своими кроликами', async () => {
      const res = await asFarm(farmB.token, 'get', `/api/v1/cages/${farmB.cageId}`);

      expect(res.status).toBe(200);
      expect(res.body.data.current_occupancy).toBe(1);
      expect(res.body.data.rabbits.map((rabbit) => rabbit.name)).toEqual(['Кролик фермы Б']);
    });
  });

  describe('совпадения имён между фермами', () => {
    it('позволяет завести породу с тем же названием, что у соседа', async () => {
      const res = await createBreed(farmB.token, 'Порода фермы А');

      expect(res.status).toBe(201);
    });

    it('позволяет использовать клеймо, занятое на соседней ферме', async () => {
      const res = await createRabbit(farmB.token, {
        name: 'Тёзка по клейму',
        tag_id: 'A-001',
        breed_id: farmB.breedId
      });

      expect(res.status).toBe(201);
    });
  });
});
