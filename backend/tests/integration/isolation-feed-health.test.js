const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');

const API = '/api/v1';

/**
 * Изоляция ферм: склад кормов, кормления, прививки, лечение.
 *
 * Ферм в сервисе много, а привязка к ферме у этих четырёх ресурсов разная:
 * у кормов есть своя колонка user_id, у кормлений фермы нет вовсе (только
 * fed_by — кто кормил), у прививок и лечения — только через кролика. Каждый
 * из трёх способов ломается по-своему: пропущенный include, include с
 * required: false, статистика через count/sum без join. Поэтому проверяется
 * не «есть ли фильтр в коде», а поведение: чужое не видно, чужое по id —
 * 404, чужое нельзя изменить, удалить, накормить и списать.
 *
 * 404, а не 403: 403 подтвердил бы, что запись с таким id существует, —
 * перебором id можно было бы пересчитать чужое хозяйство.
 */
describe('Изоляция ферм: корма и здоровье', () => {
  const farmA = { email: 'isolation-farm-a@example.com' };
  const farmB = { email: 'isolation-farm-b@example.com' };

  const client = (token) => ({
    get: (url) => request(app).get(url).set('Authorization', `Bearer ${token}`),
    post: (url, body) => request(app).post(url).set('Authorization', `Bearer ${token}`).send(body),
    put: (url, body) => request(app).put(url).set('Authorization', `Bearer ${token}`).send(body),
    del: (url) => request(app).delete(url).set('Authorization', `Bearer ${token}`)
  });

  const isoDate = (offsetDays = 0) =>
    new Date(Date.now() + offsetDays * 24 * 60 * 60 * 1000).toISOString().slice(0, 10);

  const feedStock = async (farm, feedId) => {
    const res = await farm.api.get(`${API}/feeds/${feedId}`);
    return parseFloat(res.body.data.current_stock);
  };

  const feedingRecordsTotal = async (farm) => {
    const res = await farm.api.get(`${API}/feeding-records?limit=1`);
    return res.body.data.pagination.total;
  };

  /**
   * Обе фермы заводятся обычной регистрацией: регистрация создаёт новую ферму
   * и её владельца, поэтому подкладывать данные в базу мимо API не нужно —
   * тест ходит теми же путями, что и приложение.
   */
  const setUpFarm = async (farm, { label, feedStock: stock, minStock, costPerUnit, treatmentCost }) => {
    const registered = await request(app)
      .post(`${API}/auth/register`)
      .send({
        email: farm.email,
        password: 'Password123!',
        full_name: `Владелец фермы ${label}`,
        role: 'owner'
      });

    farm.token = registered.body.data.access_token;
    farm.userId = registered.body.data.user.id;
    farm.api = client(farm.token);
    farm.label = label;

    const breed = await farm.api.post(`${API}/breeds`, { name: `Порода фермы ${label}` });
    farm.breedId = breed.body.data.id;

    const rabbit = await farm.api.post(`${API}/rabbits`, {
      name: `Кролик фермы ${label}`,
      breed_id: farm.breedId,
      sex: 'female',
      birth_date: '2024-01-10',
      status: 'healthy'
    });
    farm.rabbitId = rabbit.body.data.id;

    const cage = await farm.api.post(`${API}/cages`, {
      number: `${label}-01`,
      type: 'group',
      capacity: 4,
      location: 'Ряд 1'
    });
    farm.cageId = cage.body.data.id;

    const feed = await farm.api.post(`${API}/feeds`, {
      name: `Корм фермы ${label}`,
      type: 'pellets',
      unit: 'kg',
      current_stock: stock,
      min_stock: minStock,
      cost_per_unit: costPerUnit
    });
    farm.feedId = feed.body.data.id;

    const feedingOnCage = await farm.api.post(`${API}/feeding-records`, {
      feed_id: farm.feedId,
      cage_id: farm.cageId,
      quantity: 2,
      fed_at: '2024-06-01T07:00:00Z',
      notes: `Кормление фермы ${label}`
    });
    farm.feedingRecordId = feedingOnCage.body.data.id;

    const vaccination = await farm.api.post(`${API}/vaccinations`, {
      rabbit_id: farm.rabbitId,
      vaccine_name: `Вакцина фермы ${label}`,
      vaccine_type: 'vhd',
      vaccination_date: isoDate(-5),
      next_vaccination_date: isoDate(10)
    });
    farm.vaccinationId = vaccination.body.data.id;

    // Лечение создаётся последним: исход ongoing переводит кролика в статус
    // sick, а вакцинировать больного можно — мёртвого и проданного нельзя.
    const medicalRecord = await farm.api.post(`${API}/medical-records`, {
      rabbit_id: farm.rabbitId,
      symptoms: `Симптомы фермы ${label}`,
      diagnosis: `Диагноз фермы ${label}`,
      started_at: '2024-05-01',
      outcome: 'ongoing',
      cost: treatmentCost
    });
    farm.medicalRecordId = medicalRecord.body.data.id;
    farm.treatmentCost = treatmentCost;
  };

  beforeAll(async () => {
    await syncTestDb();

    await setUpFarm(farmA, {
      label: 'А',
      feedStock: 100,
      minStock: 5,
      costPerUnit: 10,
      treatmentCost: 500
    });

    // Просроченная прививка только у фермы А: ферма Б не должна увидеть её
    // ни в списке просроченных, ни в счётчиках статистики.
    const overdue = await farmA.api.post(`${API}/vaccinations`, {
      rabbit_id: farmA.rabbitId,
      vaccine_name: 'Просроченная вакцина фермы А',
      vaccine_type: 'myxomatosis',
      vaccination_date: '2024-01-15',
      next_vaccination_date: '2024-07-15'
    });
    farmA.overdueVaccinationId = overdue.body.data.id;

    await setUpFarm(farmB, {
      label: 'Б',
      feedStock: 50,
      minStock: 60,
      costPerUnit: 2,
      treatmentCost: 20
    });
  });

  afterAll(async () => {
    await closeTestDb();
  });

  it('обе фермы заведены регистрацией и владеют своими данными', () => {
    expect(farmA.userId).not.toBe(farmB.userId);
    expect(farmA.feedId).toBeDefined();
    expect(farmB.feedId).toBeDefined();
    expect(farmA.feedingRecordId).toBeDefined();
    expect(farmB.feedingRecordId).toBeDefined();
    expect(farmA.vaccinationId).toBeDefined();
    expect(farmB.vaccinationId).toBeDefined();
    expect(farmA.medicalRecordId).toBeDefined();
    expect(farmB.medicalRecordId).toBeDefined();
  });

  describe('Корма', () => {
    it('в списке фермы Б нет корма фермы А', async () => {
      const res = await farmB.api.get(`${API}/feeds?limit=100`);

      expect(res.status).toBe(200);
      const names = res.body.data.items.map((feed) => feed.name);
      expect(names).toContain('Корм фермы Б');
      expect(names).not.toContain('Корм фермы А');
      expect(res.body.data.items.map((feed) => feed.id)).not.toContain(farmA.feedId);
    });

    it('чужой корм по id — 404', async () => {
      const res = await farmB.api.get(`${API}/feeds/${farmA.feedId}`);
      expect(res.status).toBe(404);
    });

    it('правка чужого корма — 404, корм не изменился', async () => {
      const res = await farmB.api.put(`${API}/feeds/${farmA.feedId}`, { name: 'Перехвачено' });
      expect(res.status).toBe(404);

      const own = await farmA.api.get(`${API}/feeds/${farmA.feedId}`);
      expect(own.body.data.name).toBe('Корм фермы А');
    });

    it('удаление чужого корма — 404, корм цел', async () => {
      // Именно 404, а не 400 «корм используется в записях кормления»:
      // принадлежность проверяется раньше, чем причина отказа.
      const res = await farmB.api.del(`${API}/feeds/${farmA.feedId}`);
      expect(res.status).toBe(404);

      const own = await farmA.api.get(`${API}/feeds/${farmA.feedId}`);
      expect(own.status).toBe(200);
    });

    it('нельзя списать остаток чужого корма', async () => {
      const before = await feedStock(farmA, farmA.feedId);

      const res = await farmB.api.post(`${API}/feeds/${farmA.feedId}/adjust-stock`, {
        quantity: 50,
        operation: 'subtract'
      });

      expect(res.status).toBe(404);
      expect(await feedStock(farmA, farmA.feedId)).toBe(before);
    });

    it('нельзя пополнить остаток чужого корма', async () => {
      const before = await feedStock(farmA, farmA.feedId);

      const res = await farmB.api.post(`${API}/feeds/${farmA.feedId}/adjust-stock`, {
        quantity: 10,
        operation: 'add'
      });

      expect(res.status).toBe(404);
      expect(await feedStock(farmA, farmA.feedId)).toBe(before);
    });

    it('склад с низким остатком показывает только свои корма', async () => {
      const forB = await farmB.api.get(`${API}/feeds/low-stock`);
      expect(forB.status).toBe(200);
      expect(forB.body.data.map((feed) => feed.name)).toEqual(['Корм фермы Б']);

      // У фермы А остаток выше минимума, поэтому её список пуст — и корм Б
      // в него тоже не попадает.
      const forA = await farmA.api.get(`${API}/feeds/low-stock`);
      expect(forA.body.data).toEqual([]);
    });

    it('статистика склада фермы Б считает только её корма', async () => {
      const res = await farmB.api.get(`${API}/feeds/statistics`);
      const stock = await feedStock(farmB, farmB.feedId);

      expect(res.status).toBe(200);
      expect(res.body.data.total_feeds).toBe(1);
      expect(res.body.data.low_stock_count).toBe(1);
      expect(res.body.data.low_stock_items.map((item) => item.name)).toEqual(['Корм фермы Б']);
      // Стоимость запаса — только свой остаток по своей цене (2 за кг),
      // корм фермы А (по 10 за кг) в сумму не входит.
      expect(res.body.data.total_stock_value).toBeCloseTo(stock * 2, 2);
    });
  });

  describe('Кормления', () => {
    it('в списке фермы Б нет записей фермы А', async () => {
      const res = await farmB.api.get(`${API}/feeding-records?limit=100`);

      expect(res.status).toBe(200);
      const notes = res.body.data.items.map((record) => record.notes);
      expect(notes).toContain('Кормление фермы Б');
      expect(notes).not.toContain('Кормление фермы А');
      expect(res.body.data.items.map((r) => r.id)).not.toContain(farmA.feedingRecordId);
    });

    it('фильтр по чужой клетке не открывает чужие записи', async () => {
      const res = await farmB.api.get(`${API}/feeding-records?cage_id=${farmA.cageId}&limit=100`);

      expect(res.status).toBe(200);
      expect(res.body.data.items).toEqual([]);
    });

    it('последние кормления фермы Б не содержат записей фермы А', async () => {
      const res = await farmB.api.get(`${API}/feeding-records/recent?limit=50`);

      expect(res.status).toBe(200);
      expect(res.body.data.map((record) => record.notes)).not.toContain('Кормление фермы А');
    });

    it('чужая запись по id — 404', async () => {
      const res = await farmB.api.get(`${API}/feeding-records/${farmA.feedingRecordId}`);
      expect(res.status).toBe(404);
    });

    it('правка чужой записи — 404, запись не изменилась', async () => {
      const res = await farmB.api.put(`${API}/feeding-records/${farmA.feedingRecordId}`, {
        quantity: 99,
        notes: 'Перехвачено'
      });
      expect(res.status).toBe(404);

      const own = await farmA.api.get(`${API}/feeding-records/${farmA.feedingRecordId}`);
      expect(parseFloat(own.body.data.quantity)).toBe(2);
      expect(own.body.data.notes).toBe('Кормление фермы А');
    });

    it('удаление чужой записи — 404, запись цела и остаток не вернулся', async () => {
      const stockBefore = await feedStock(farmA, farmA.feedId);

      const res = await farmB.api.del(`${API}/feeding-records/${farmA.feedingRecordId}`);
      expect(res.status).toBe(404);

      const own = await farmA.api.get(`${API}/feeding-records/${farmA.feedingRecordId}`);
      expect(own.status).toBe(200);
      // Удаление возвращает количество на склад — значит несостоявшееся
      // удаление не должно было тронуть остаток фермы А.
      expect(await feedStock(farmA, farmA.feedId)).toBe(stockBefore);
    });

    it('нельзя записать кормление на чужого кролика', async () => {
      const res = await farmB.api.post(`${API}/feeding-records`, {
        feed_id: farmB.feedId,
        rabbit_id: farmA.rabbitId,
        quantity: 1,
        fed_at: '2024-06-02T07:00:00Z'
      });

      expect(res.status).toBe(404);
    });

    it('нельзя записать кормление на чужую клетку', async () => {
      const countBefore = await feedingRecordsTotal(farmB);

      const res = await farmB.api.post(`${API}/feeding-records`, {
        feed_id: farmB.feedId,
        cage_id: farmA.cageId,
        quantity: 1,
        fed_at: '2024-06-02T07:00:00Z'
      });

      expect(res.status).toBe(404);
      expect(await feedingRecordsTotal(farmB)).toBe(countBefore);
    });

    it('нельзя накормить своих чужим кормом', async () => {
      const strangerStock = await feedStock(farmA, farmA.feedId);

      const res = await farmB.api.post(`${API}/feeding-records`, {
        feed_id: farmA.feedId,
        cage_id: farmB.cageId,
        quantity: 1,
        fed_at: '2024-06-02T07:00:00Z'
      });

      expect(res.status).toBe(404);
      expect(await feedStock(farmA, farmA.feedId)).toBe(strangerStock);
    });

    it('нельзя перевести свою запись на чужой корм, кролика или клетку', async () => {
      const strangerStock = await feedStock(farmA, farmA.feedId);

      const onFeed = await farmB.api.put(`${API}/feeding-records/${farmB.feedingRecordId}`, {
        feed_id: farmA.feedId
      });
      expect(onFeed.status).toBe(404);

      const onRabbit = await farmB.api.put(`${API}/feeding-records/${farmB.feedingRecordId}`, {
        rabbit_id: farmA.rabbitId
      });
      expect(onRabbit.status).toBe(404);

      const onCage = await farmB.api.put(`${API}/feeding-records/${farmB.feedingRecordId}`, {
        cage_id: farmA.cageId
      });
      expect(onCage.status).toBe(404);

      expect(await feedStock(farmA, farmA.feedId)).toBe(strangerStock);

      const own = await farmB.api.get(`${API}/feeding-records/${farmB.feedingRecordId}`);
      expect(own.body.data.feed_id).toBe(farmB.feedId);
      expect(own.body.data.cage_id).toBe(farmB.cageId);
      expect(own.body.data.rabbit_id).toBeNull();
    });

    it('история кормлений чужого кролика — 404', async () => {
      const res = await farmB.api.get(`${API}/rabbits/${farmA.rabbitId}/feeding-records`);
      expect(res.status).toBe(404);
    });

    it('статистика кормлений фермы Б не считает кормления фермы А', async () => {
      const res = await farmB.api.get(`${API}/feeding-records/statistics`);
      const list = await farmB.api.get(`${API}/feeding-records?limit=100`);

      expect(res.status).toBe(200);
      expect(res.body.data.total_feedings).toBe(list.body.data.pagination.total);
      expect(Object.keys(res.body.data.by_feed)).toEqual(['Корм фермы Б']);
      // Кормление фермы А — 2 кг по 10 за кг; в расходах фермы Б этих денег
      // быть не должно.
      expect(res.body.data.total_cost).toBeCloseTo(2 * 2, 2);
    });
  });

  describe('Кормление пачкой', () => {
    it('чужая клетка в пачке — 404, не создано ни одной записи', async () => {
      const countBefore = await feedingRecordsTotal(farmB);
      const stockBefore = await feedStock(farmB, farmB.feedId);

      const res = await farmB.api.post(`${API}/feeding-records/bulk`, {
        feed_id: farmB.feedId,
        cage_ids: [farmB.cageId, farmA.cageId],
        quantity: 1,
        fed_at: '2024-06-03T07:00:00Z'
      });

      expect(res.status).toBe(404);
      // Своя клетка из той же пачки тоже не записана, и остаток не списан:
      // проверка получателей идёт до списания и внутри той же транзакции.
      expect(await feedingRecordsTotal(farmB)).toBe(countBefore);
      expect(await feedStock(farmB, farmB.feedId)).toBe(stockBefore);
    });

    it('чужой кролик в пачке — 404, не создано ни одной записи', async () => {
      const countBefore = await feedingRecordsTotal(farmB);
      const stockBefore = await feedStock(farmB, farmB.feedId);

      const res = await farmB.api.post(`${API}/feeding-records/bulk`, {
        feed_id: farmB.feedId,
        rabbit_ids: [farmA.rabbitId],
        quantity: 1,
        fed_at: '2024-06-03T07:00:00Z'
      });

      expect(res.status).toBe(404);
      expect(await feedingRecordsTotal(farmB)).toBe(countBefore);
      expect(await feedStock(farmB, farmB.feedId)).toBe(stockBefore);
    });

    it('пачка чужим кормом — 404, чужой остаток не тронут', async () => {
      const strangerStock = await feedStock(farmA, farmA.feedId);

      const res = await farmB.api.post(`${API}/feeding-records/bulk`, {
        feed_id: farmA.feedId,
        cage_ids: [farmB.cageId],
        quantity: 1,
        fed_at: '2024-06-03T07:00:00Z'
      });

      expect(res.status).toBe(404);
      expect(await feedStock(farmA, farmA.feedId)).toBe(strangerStock);
    });
  });

  describe('Прививки', () => {
    it('в списке фермы Б нет прививок фермы А', async () => {
      const res = await farmB.api.get(`${API}/vaccinations?limit=100`);

      expect(res.status).toBe(200);
      const names = res.body.data.items.map((v) => v.vaccine_name);
      expect(names).toContain('Вакцина фермы Б');
      expect(names).not.toContain('Вакцина фермы А');
      expect(names).not.toContain('Просроченная вакцина фермы А');
      expect(res.body.data.pagination.total).toBe(1);
    });

    it('фильтр по чужому кролику не открывает чужие прививки', async () => {
      const res = await farmB.api.get(`${API}/vaccinations?rabbit_id=${farmA.rabbitId}&limit=100`);

      expect(res.status).toBe(200);
      expect(res.body.data.items).toEqual([]);
    });

    it('чужая прививка по id — 404', async () => {
      const res = await farmB.api.get(`${API}/vaccinations/${farmA.vaccinationId}`);
      expect(res.status).toBe(404);
    });

    it('правка чужой прививки — 404, запись не изменилась', async () => {
      const res = await farmB.api.put(`${API}/vaccinations/${farmA.vaccinationId}`, {
        vaccine_name: 'Перехвачено'
      });
      expect(res.status).toBe(404);

      const own = await farmA.api.get(`${API}/vaccinations/${farmA.vaccinationId}`);
      expect(own.body.data.vaccine_name).toBe('Вакцина фермы А');
    });

    it('удаление чужой прививки — 404, запись цела', async () => {
      const res = await farmB.api.del(`${API}/vaccinations/${farmA.vaccinationId}`);
      expect(res.status).toBe(404);

      const own = await farmA.api.get(`${API}/vaccinations/${farmA.vaccinationId}`);
      expect(own.status).toBe(200);
    });

    it('нельзя привить чужого кролика', async () => {
      const res = await farmB.api.post(`${API}/vaccinations`, {
        rabbit_id: farmA.rabbitId,
        vaccine_name: 'Чужая вакцина',
        vaccine_type: 'vhd',
        vaccination_date: isoDate(-1)
      });

      expect(res.status).toBe(404);
    });

    it('нельзя перевесить свою прививку на чужого кролика', async () => {
      const res = await farmB.api.put(`${API}/vaccinations/${farmB.vaccinationId}`, {
        rabbit_id: farmA.rabbitId
      });

      expect(res.status).toBe(404);

      const own = await farmB.api.get(`${API}/vaccinations/${farmB.vaccinationId}`);
      expect(own.body.data.rabbit_id).toBe(farmB.rabbitId);
    });

    it('история прививок чужого кролика — 404', async () => {
      const res = await farmB.api.get(`${API}/rabbits/${farmA.rabbitId}/vaccinations`);
      expect(res.status).toBe(404);
    });

    it('предстоящие и просроченные прививки не показывают чужих', async () => {
      const upcoming = await farmB.api.get(`${API}/vaccinations/upcoming?days=30`);
      expect(upcoming.status).toBe(200);
      expect(upcoming.body.data.map((v) => v.vaccine_name)).toEqual(['Вакцина фермы Б']);

      // Просроченная прививка есть только у фермы А — у Б список пуст.
      const overdueForB = await farmB.api.get(`${API}/vaccinations/overdue`);
      expect(overdueForB.body.data).toEqual([]);

      const overdueForA = await farmA.api.get(`${API}/vaccinations/overdue`);
      expect(overdueForA.body.data.map((v) => v.vaccine_name))
        .toEqual(['Просроченная вакцина фермы А']);
    });

    it('статистика прививок фермы Б не считает прививки фермы А', async () => {
      const res = await farmB.api.get(`${API}/vaccinations/statistics`);

      expect(res.status).toBe(200);
      expect(res.body.data.total_vaccinations).toBe(1);
      // Просроченная прививка фермы А не должна попадать ни в счётчики,
      // ни в список ближайших: count и findAll идут через join по ферме.
      expect(res.body.data.by_vaccine_type.myxomatosis).toBe(0);
      expect(res.body.data.upcoming.overdue).toBe(0);
      expect(res.body.data.upcoming.list.map((v) => v.vaccine_name)).toEqual(['Вакцина фермы Б']);

      const forA = await farmA.api.get(`${API}/vaccinations/statistics`);
      expect(forA.body.data.total_vaccinations).toBe(2);
      expect(forA.body.data.upcoming.overdue).toBe(1);
    });
  });

  describe('Лечение', () => {
    it('в списке фермы Б нет записей фермы А', async () => {
      const res = await farmB.api.get(`${API}/medical-records?limit=100`);

      expect(res.status).toBe(200);
      const diagnoses = res.body.data.items.map((record) => record.diagnosis);
      expect(diagnoses).toContain('Диагноз фермы Б');
      expect(diagnoses).not.toContain('Диагноз фермы А');
      expect(res.body.data.pagination.total).toBe(1);
    });

    it('фильтр по чужому кролику не открывает чужие записи', async () => {
      const res = await farmB.api.get(`${API}/medical-records?rabbit_id=${farmA.rabbitId}&limit=100`);

      expect(res.status).toBe(200);
      expect(res.body.data.items).toEqual([]);
    });

    it('чужая запись по id — 404', async () => {
      const res = await farmB.api.get(`${API}/medical-records/${farmA.medicalRecordId}`);
      expect(res.status).toBe(404);
    });

    it('правка чужой записи — 404, запись не изменилась', async () => {
      const res = await farmB.api.put(`${API}/medical-records/${farmA.medicalRecordId}`, {
        diagnosis: 'Перехвачено',
        outcome: 'died'
      });
      expect(res.status).toBe(404);

      const own = await farmA.api.get(`${API}/medical-records/${farmA.medicalRecordId}`);
      expect(own.body.data.diagnosis).toBe('Диагноз фермы А');
      expect(own.body.data.outcome).toBe('ongoing');

      // Исход 'died' переводит кролика в статус dead — чужой кролик тоже
      // должен остаться нетронутым.
      const rabbit = await farmA.api.get(`${API}/rabbits/${farmA.rabbitId}`);
      expect(rabbit.body.data.status).not.toBe('dead');
    });

    it('удаление чужой записи — 404, запись цела', async () => {
      const res = await farmB.api.del(`${API}/medical-records/${farmA.medicalRecordId}`);
      expect(res.status).toBe(404);

      const own = await farmA.api.get(`${API}/medical-records/${farmA.medicalRecordId}`);
      expect(own.status).toBe(200);
    });

    it('нельзя завести лечение чужому кролику', async () => {
      const res = await farmB.api.post(`${API}/medical-records`, {
        rabbit_id: farmA.rabbitId,
        symptoms: 'Чужие симптомы',
        started_at: '2024-05-02'
      });

      expect(res.status).toBe(404);
    });

    it('нельзя перевесить своё лечение на чужого кролика', async () => {
      const res = await farmB.api.put(`${API}/medical-records/${farmB.medicalRecordId}`, {
        rabbit_id: farmA.rabbitId
      });

      expect(res.status).toBe(404);

      const own = await farmB.api.get(`${API}/medical-records/${farmB.medicalRecordId}`);
      expect(own.body.data.rabbit_id).toBe(farmB.rabbitId);
    });

    it('история болезней чужого кролика — 404', async () => {
      const res = await farmB.api.get(`${API}/rabbits/${farmA.rabbitId}/medical-records`);
      expect(res.status).toBe(404);
    });

    it('текущие лечения и расходы показывают только свои записи', async () => {
      const ongoing = await farmB.api.get(`${API}/medical-records/ongoing`);
      expect(ongoing.status).toBe(200);
      expect(ongoing.body.data.map((record) => record.diagnosis)).toEqual(['Диагноз фермы Б']);

      const costs = await farmB.api.get(`${API}/medical-records/costs`);
      expect(costs.status).toBe(200);
      expect(costs.body.data.count).toBe(1);
      expect(costs.body.data.total_cost).toBeCloseTo(farmB.treatmentCost, 2);
    });

    it('статистика лечения фермы Б не считает записи фермы А', async () => {
      const res = await farmB.api.get(`${API}/medical-records/statistics`);

      expect(res.status).toBe(200);
      expect(res.body.data.total_records).toBe(1);
      // SUM по стоимости — самое удобное место потерять join по ферме:
      // 500 рублей фермы А не должны появиться в сумме фермы Б.
      expect(res.body.data.total_cost).toBeCloseTo(farmB.treatmentCost, 2);
      expect(res.body.data.by_outcome.ongoing).toBe(1);
      expect(res.body.data.ongoing_treatments.map((r) => r.diagnosis)).toEqual(['Диагноз фермы Б']);

      const forA = await farmA.api.get(`${API}/medical-records/statistics`);
      expect(forA.body.data.total_cost).toBeCloseTo(farmA.treatmentCost, 2);
    });
  });
});
