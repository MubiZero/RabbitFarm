const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');

describe('Transactions API', () => {
  let accessToken;

  beforeAll(async () => {
    await syncTestDb();

    const res = await registerFarm(app, { email: 'financeowner@example.com', full_name: 'Finance Owner' });
    accessToken = res.accessToken;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('POST /api/v1/transactions', () => {
    it('должен создавать транзакцию дохода', async () => {
      const res = await request(app)
        .post('/api/v1/transactions')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          type: 'income',
          category: 'sale_rabbit',
          amount: 1500.00,
          description: 'Продажа кролика',
          transaction_date: '2024-05-01'
        });

      expect(res.status).toBe(201);
      expect(res.body.data.type).toBe('income');
      expect(parseFloat(res.body.data.amount)).toBe(1500);
    });

    it('должен создавать транзакцию расхода', async () => {
      const res = await request(app)
        .post('/api/v1/transactions')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          type: 'expense',
          category: 'feed',
          amount: 500.00,
          description: 'Покупка корма',
          transaction_date: '2024-05-02'
        });

      expect(res.status).toBe(201);
      expect(res.body.data.type).toBe('expense');
    });

    it('должен отклонять создание без авторизации', async () => {
      const res = await request(app)
        .post('/api/v1/transactions')
        .send({ type: 'income', category: 'sale_rabbit', amount: 100 });

      expect(res.status).toBe(401);
    });

    it('должен отклонять транзакцию без обязательных полей', async () => {
      const res = await request(app)
        .post('/api/v1/transactions')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ type: 'income' });

      expect(res.status).toBe(422);
    });
  });

  describe('GET /api/v1/transactions', () => {
    it('должен возвращать список транзакций', async () => {
      const res = await request(app)
        .get('/api/v1/transactions')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data).toHaveProperty('items');
      expect(res.body.data).toHaveProperty('pagination');
      expect(Array.isArray(res.body.data.items)).toBe(true);
    });

    it('должен применять фильтр по типу', async () => {
      const res = await request(app)
        .get('/api/v1/transactions?type=income')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      res.body.data.items.forEach(tx => {
        expect(tx.type).toBe('income');
      });
    });
  });

  describe('GET /api/v1/transactions/statistics', () => {
    it('должен возвращать финансовую статистику', async () => {
      const res = await request(app)
        .get('/api/v1/transactions/statistics')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data).toHaveProperty('total_income');
      expect(res.body.data).toHaveProperty('total_expenses');
    });
  });

  describe('продажа кролика', () => {
    // Регрессия: код искал категорию 'sale'/'продажа', которых нет в схеме,
    // поэтому проданный кролик оставался активным и занимал место в клетке.
    let rabbitId;

    beforeAll(async () => {
      const breed = await request(app)
        .post('/api/v1/breeds')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Порода на продажу' });

      const rabbit = await request(app)
        .post('/api/v1/rabbits')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          name: 'Кролик на продажу',
          breed_id: breed.body.data.id,
          sex: 'male',
          birth_date: '2023-03-01',
          status: 'healthy'
        });
      rabbitId = rabbit.body.data.id;
    });

    it('доход категории sale_rabbit помечает кролика проданным', async () => {
      const res = await request(app)
        .post('/api/v1/transactions')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          type: 'income',
          category: 'sale_rabbit',
          amount: 2000,
          rabbit_id: rabbitId,
          transaction_date: '2024-06-01'
        });

      expect(res.status).toBe(201);

      const rabbit = await request(app)
        .get(`/api/v1/rabbits/${rabbitId}`)
        .set('Authorization', `Bearer ${accessToken}`);
      expect(rabbit.body.data.status).toBe('sold');
      expect(rabbit.body.data.cage_id).toBeNull();
    });

    it('доход другой категории кролика не трогает', async () => {
      const breed = await request(app)
        .post('/api/v1/breeds')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Порода для вязки' });

      const rabbit = await request(app)
        .post('/api/v1/rabbits')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          name: 'Кролик по вязке',
          breed_id: breed.body.data.id,
          sex: 'male',
          birth_date: '2023-03-01',
          status: 'healthy'
        });

      await request(app)
        .post('/api/v1/transactions')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          type: 'income',
          category: 'breeding_fee',
          amount: 500,
          rabbit_id: rabbit.body.data.id,
          transaction_date: '2024-06-02'
        });

      const after = await request(app)
        .get(`/api/v1/rabbits/${rabbit.body.data.id}`)
        .set('Authorization', `Bearer ${accessToken}`);
      expect(after.body.data.status).toBe('healthy');
    });
  });
});
