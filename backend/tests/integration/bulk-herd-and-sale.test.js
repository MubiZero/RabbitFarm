const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');
const { Rabbit, TransactionRabbit } = require('../../src/models');

const API = '/api/v1';

/**
 * Две вещи, из-за которых хозяйство на триста голов не уходило с таблицы.
 *
 * Перенос стада: заводить триста кроликов по одной форме никто не станет —
 * на этом перенос останавливался, не начавшись.
 *
 * Продажа партией: тридцать голов в ресторан не складывались ни одним
 * способом. Либо деньги ложились одной строкой, а кролики оставались
 * живыми; либо книга заполнялась тридцатью одинаковыми строками; либо
 * кроликов помечали руками, и выбытие висело отдельно от денег.
 */
describe('Пачка кроликов и продажа партией', () => {
  let ownerToken;
  let strangerToken;
  let breedId;
  let cageId;

  beforeAll(async () => {
    await syncTestDb();

    const owner = await registerFarm(app, {
      email: 'bulkherd@example.com',
      full_name: 'Дилноза'
    });
    ownerToken = owner.accessToken;

    const stranger = await registerFarm(app, {
      email: 'bulkherd_stranger@example.com',
      full_name: 'Сосед'
    });
    strangerToken = stranger.accessToken;

    const breed = await request(app)
      .post(`${API}/breeds`)
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ name: 'Порода для группы' });
    breedId = breed.body.data.id;

    const cage = await request(app)
      .post(`${API}/cages`)
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ number: 'H-01', type: 'group', capacity: 40, location: 'Ряд A' });
    cageId = cage.body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('перенос стада пачкой', () => {
    it('заводит сразу двадцать голов одним запросом', async () => {
      const res = await request(app)
        .post(`${API}/rabbits/bulk`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({
          count: 20,
          breed_id: breedId,
          sex: 'female',
          birth_date: '2026-03-01',
          tag_prefix: 'R-'
        });

      expect(res.status).toBe(201);
      expect(res.body.data.created).toBe(20);

      // Клеймо у каждого своё, по образцу.
      const tags = res.body.data.items.map((item) => item.tag_id).sort();
      expect(tags[0]).toBe('R-001');
      expect(tags[tags.length - 1]).toBe('R-020');
    });

    it('без образца клейма кролики заводятся без бирки, а не с пустой строкой', async () => {
      const res = await request(app)
        .post(`${API}/rabbits/bulk`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({
          count: 3,
          breed_id: breedId,
          sex: 'unknown',
          birth_date: '2026-04-01'
        });

      expect(res.status).toBe(201);
      // Именно NULL: на пустой строке уникальный индекс считает их дубликатами.
      for (const item of res.body.data.items) {
        const stored = await Rabbit.findByPk(item.id, { tenantScope: 'all' });
        expect(stored.tag_id).toBeNull();
      }
    });

    it('занятое клеймо из ряда отбивает всю пачку', async () => {
      const res = await request(app)
        .post(`${API}/rabbits/bulk`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({
          count: 5,
          breed_id: breedId,
          birth_date: '2026-05-01',
          tag_prefix: 'R-'
        });

      // R-001 уже занято первой пачкой.
      expect(res.status).toBe(409);
      expect(res.body.error.message).toMatch(/клейм/i);
    });

    it('не сажает в клетку больше, чем она вмещает', async () => {
      const res = await request(app)
        .post(`${API}/rabbits/bulk`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({
          count: 50,
          breed_id: breedId,
          birth_date: '2026-05-01',
          cage_id: cageId
        });

      expect(res.status).toBe(400);
    });

    it('чужая порода не проходит', async () => {
      const foreignBreed = await request(app)
        .post(`${API}/breeds`)
        .set('Authorization', `Bearer ${strangerToken}`)
        .send({ name: 'Соседская' });

      const res = await request(app)
        .post(`${API}/rabbits/bulk`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({
          count: 2,
          breed_id: foreignBreed.body.data.id,
          birth_date: '2026-05-01'
        });

      expect(res.status).toBe(404);
    });
  });

  describe('продажа партией', () => {
    let batch;

    beforeAll(async () => {
      const created = await request(app)
        .post(`${API}/rabbits/bulk`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({
          count: 5,
          breed_id: breedId,
          sex: 'male',
          birth_date: '2026-02-01',
          tag_prefix: 'S-'
        });
      batch = created.body.data.items.map((item) => item.id);
    });

    it('одна сделка выводит из поголовья всю партию', async () => {
      const res = await request(app)
        .post(`${API}/transactions`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({
          type: 'income',
          category: 'sale_meat',
          amount: 9000,
          transaction_date: '2026-09-16',
          rabbit_ids: batch,
          description: 'Ресторан «Чайхона»'
        });

      expect(res.status).toBe(201);

      // Деньги — одной строкой, а не пятью.
      const list = await request(app)
        .get(`${API}/transactions?limit=100`)
        .set('Authorization', `Bearer ${ownerToken}`);
      const sales = list.body.data.items.filter(
        (item) => item.description === 'Ресторан «Чайхона»'
      );
      expect(sales).toHaveLength(1);
      expect(parseFloat(sales[0].amount)).toBe(9000);

      // Поголовье уменьшилось на всю партию.
      for (const id of batch) {
        const stored = await Rabbit.findByPk(id, { tenantScope: 'all' });
        expect(stored.status).toBe('sold');
        expect(stored.sold_date).toBe('2026-09-16');
        expect(stored.cage_id).toBeNull();
      }

      // История каждого кролика знает эту сделку.
      const links = await TransactionRabbit.findAll({
        where: { transaction_id: sales[0].id },
        tenantScope: 'all'
      });
      expect(links.map((link) => link.rabbit_id).sort()).toEqual(
        [...batch].sort()
      );
    });

    it('чужой кролик в партии отбивает сделку целиком', async () => {
      const own = await request(app)
        .post(`${API}/rabbits/bulk`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ count: 2, breed_id: breedId, birth_date: '2026-02-01' });
      const ownIds = own.body.data.items.map((item) => item.id);

      const foreignBreed = await request(app)
        .post(`${API}/breeds`)
        .set('Authorization', `Bearer ${strangerToken}`)
        .send({ name: 'Соседская-2' });
      const foreign = await request(app)
        .post(`${API}/rabbits`)
        .set('Authorization', `Bearer ${strangerToken}`)
        .send({
          name: 'Чужой',
          breed_id: foreignBreed.body.data.id,
          sex: 'male',
          birth_date: '2026-02-01'
        });

      const res = await request(app)
        .post(`${API}/transactions`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({
          type: 'income',
          category: 'sale_meat',
          amount: 1000,
          transaction_date: '2026-09-16',
          rabbit_ids: [...ownIds, foreign.body.data.id]
        });

      expect(res.status).toBe(404);

      // Половина проданной партии — это расхождение денег с поголовьем,
      // которое потом никто не найдёт. Свои кролики остались живыми.
      for (const id of ownIds) {
        const stored = await Rabbit.findByPk(id, { tenantScope: 'all' });
        expect(stored.status).not.toBe('sold');
      }
    });

    it('одиночная продажа по-прежнему работает и пишет связь', async () => {
      const single = await request(app)
        .post(`${API}/rabbits`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({
          name: 'Одиночка',
          breed_id: breedId,
          sex: 'male',
          birth_date: '2026-02-01'
        });
      const rabbitId = single.body.data.id;

      const res = await request(app)
        .post(`${API}/transactions`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({
          type: 'income',
          category: 'sale_rabbit',
          amount: 300,
          transaction_date: '2026-09-16',
          rabbit_id: rabbitId
        });

      expect(res.status).toBe(201);
      expect(res.body.data.rabbit_id).toBe(rabbitId);

      const stored = await Rabbit.findByPk(rabbitId, { tenantScope: 'all' });
      expect(stored.status).toBe('sold');

      // Связь пишется и для одиночной: «кто участвовал» читается одним
      // способом, а не двумя.
      const links = await TransactionRabbit.findAll({
        where: { transaction_id: res.body.data.id },
        tenantScope: 'all'
      });
      expect(links).toHaveLength(1);
      expect(links[0].rabbit_id).toBe(rabbitId);
    });
  });
});
