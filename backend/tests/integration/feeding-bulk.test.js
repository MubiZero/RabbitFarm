const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');

const API = '/api/v1';

/**
 * Кормление пачкой и границы периода.
 *
 * Обе истории про одно и то же место: работник кормит ферму дважды в день,
 * а увидеть свою работу не может — записывать приходилось по одной, а из
 * отчёта сегодняшние кормления выпадали целиком.
 */
describe('Кормление пачкой', () => {
  let ownerToken;
  let feedId;
  const cageIds = [];
  let strangerCageId;

  const stockOf = async (id) => {
    const res = await request(app)
      .get(`${API}/feeds/${id}`)
      .set('Authorization', `Bearer ${ownerToken}`);
    return parseFloat(res.body.data.current_stock);
  };

  const recordCount = async () => {
    const res = await request(app)
      .get(`${API}/feeding-records?limit=1`)
      .set('Authorization', `Bearer ${ownerToken}`);
    return res.body.data.pagination.total;
  };

  beforeAll(async () => {
    await syncTestDb();

    const owner = await registerFarm(app, {
      email: 'bulkfeed@example.com',
      full_name: 'Bulk Owner'
    });
    ownerToken = owner.accessToken;

    const stranger = await registerFarm(app, {
      email: 'bulkstranger@example.com',
      full_name: 'Stranger Owner'
    });

    const feed = await request(app)
      .post(`${API}/feeds`)
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ name: 'Комбикорм для пачки', type: 'pellets', unit: 'kg', current_stock: 100 });
    feedId = feed.body.data.id;

    for (const number of ['B-01', 'B-02', 'B-03']) {
      const cage = await request(app)
        .post(`${API}/cages`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ number, type: 'group', capacity: 4, location: 'Ряд A' });
      cageIds.push(cage.body.data.id);
    }

    // Клетка соседа заводится его же руками, через API. Раньше здесь стоял
    // прямой вызов модели с оговоркой «вторую ферму регистрацией не завести»:
    // владельцем становился только самый первый пользователь системы.
    // Регистрация теперь заводит новое хозяйство, и обходной путь не нужен —
    // тест проверяет ровно ту дорогу, по которой ходят живые клиенты.
    const strangerCage = await request(app)
      .post(`${API}/cages`)
      .set('Authorization', `Bearer ${stranger.accessToken}`)
      .send({ number: 'X-01', type: 'single', capacity: 1, condition: 'good' });
    strangerCageId = strangerCage.body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('POST /api/v1/feeding-records/bulk', () => {
    it('создаёт запись на каждого получателя одним запросом', async () => {
      const before = await stockOf(feedId);

      const res = await request(app)
        .post(`${API}/feeding-records/bulk`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({
          feed_id: feedId,
          cage_ids: cageIds,
          quantity: 1.5,
          fed_at: '2024-06-10T07:00:00Z',
          notes: 'Утренний обход'
        });

      expect(res.status).toBe(201);
      expect(res.body.data.created).toBe(3);
      // Количество указано на одного получателя, поэтому со склада уходит
      // 1.5 × 3, а в каждой записи стоит 1.5.
      expect(res.body.data.quantity_per_recipient).toBe(1.5);
      expect(res.body.data.total_quantity).toBe(4.5);

      const list = await request(app)
        .get(`${API}/feeding-records?feed_id=${feedId}&limit=100`)
        .set('Authorization', `Bearer ${ownerToken}`);

      const created = list.body.data.items.filter(
        (item) => item.notes === 'Утренний обход'
      );
      expect(created).toHaveLength(3);
      expect(created.map((item) => item.cage_id).sort()).toEqual([...cageIds].sort());
      expect(created.every((item) => parseFloat(item.quantity) === 1.5)).toBe(true);

      // Остаток списан один раз на всю пачку, а не по разу на запись.
      expect(await stockOf(feedId)).toBe(before - 4.5);
    });

    it('отказывает из-за чужой клетки и не создаёт ни одной записи', async () => {
      const stockBefore = await stockOf(feedId);
      const countBefore = await recordCount();

      const res = await request(app)
        .post(`${API}/feeding-records/bulk`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({
          feed_id: feedId,
          cage_ids: [cageIds[0], strangerCageId],
          quantity: 2,
          fed_at: '2024-06-10T18:00:00Z'
        });

      expect(res.status).toBe(404);
      // Своя клетка из той же пачки тоже не записана: пачка проходит целиком
      // или не проходит вовсе.
      expect(await recordCount()).toBe(countBefore);
      expect(await stockOf(feedId)).toBe(stockBefore);
    });

    it('требует хотя бы одного получателя', async () => {
      const res = await request(app)
        .post(`${API}/feeding-records/bulk`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({
          feed_id: feedId,
          cage_ids: [],
          quantity: 1,
          fed_at: '2024-06-10T07:00:00Z'
        });

      expect(res.status).toBe(422);
    });

    it('не списывает больше, чем есть на складе', async () => {
      const stockBefore = await stockOf(feedId);
      const countBefore = await recordCount();

      const res = await request(app)
        .post(`${API}/feeding-records/bulk`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({
          feed_id: feedId,
          cage_ids: cageIds,
          quantity: stockBefore, // на одного хватает, на троих — нет
          fed_at: '2024-06-10T07:00:00Z'
        });

      expect(res.status).toBe(400);
      expect(await stockOf(feedId)).toBe(stockBefore);
      expect(await recordCount()).toBe(countBefore);
    });

    it('оставляет прежний POST / без изменений', async () => {
      const res = await request(app)
        .post(`${API}/feeding-records`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({
          feed_id: feedId,
          cage_id: cageIds[0],
          quantity: 1,
          fed_at: '2024-06-11T07:00:00Z'
        });

      expect(res.status).toBe(201);
      expect(res.body.data.cage_id).toBe(cageIds[0]);
    });
  });

  /**
   * fed_at — момент времени, а период задаётся календарной датой. Пока
   * верхняя граница сравнивалась как `<= to_date`, она означала полночь
   * последнего дня, и всё, что записано в этот день, пропадало из выборок.
   */
  describe('Верхняя граница периода', () => {
    let lateRecordId;

    beforeAll(async () => {
      const res = await request(app)
        .post(`${API}/feeding-records`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({
          feed_id: feedId,
          cage_id: cageIds[0],
          quantity: 2,
          fed_at: '2024-05-01T23:30:00Z',
          notes: 'Поздний вечер последнего дня периода'
        });
      lateRecordId = res.body.data.id;
    });

    it('запись в конце последнего дня видна в списке', async () => {
      const res = await request(app)
        .get(`${API}/feeding-records?from_date=2024-05-01&to_date=2024-05-01`)
        .set('Authorization', `Bearer ${ownerToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.items.map((item) => item.id)).toContain(lateRecordId);
    });

    it('запись в конце последнего дня попадает в статистику', async () => {
      const res = await request(app)
        .get(`${API}/feeding-records/statistics?from_date=2024-05-01&to_date=2024-05-01`)
        .set('Authorization', `Bearer ${ownerToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.total_feedings).toBe(1);
      expect(res.body.data.quantity_by_unit.kg).toBe(2);
    });

    it('запись в конце последнего дня попадает в отчёт по ферме', async () => {
      const res = await request(app)
        .get(`${API}/reports/farm?from_date=2024-05-01&to_date=2024-05-01`)
        .set('Authorization', `Bearer ${ownerToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.feeding.total_feeding_records).toBe(1);
    });

    it('сегодняшнее кормление попадает в отчёт за период по умолчанию', async () => {
      // Период по умолчанию заканчивается сегодняшним днём — именно на нём
      // отчёт показывал «Кормления: 0» при живых записях в базе.
      const justNow = new Date(Date.now() - 60 * 1000).toISOString();

      await request(app)
        .post(`${API}/feeding-records`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({
          feed_id: feedId,
          cage_id: cageIds[1],
          quantity: 1,
          fed_at: justNow
        });

      const res = await request(app)
        .get(`${API}/reports/farm`)
        .set('Authorization', `Bearer ${ownerToken}`);

      expect(res.status).toBe(200);
      // Остальные записи файла датированы 2024 годом и в последние 30 дней
      // не попадают, поэтому счётчик равен ровно одной сегодняшней записи.
      expect(res.body.data.feeding.total_feeding_records).toBe(1);
      expect(res.body.data.feeding.consumption_by_unit).toEqual([
        { unit: 'kg', total: '1.00' }
      ]);
    });
  });
});
