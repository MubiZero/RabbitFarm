const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');

describe('Transactions API', () => {
  let accessToken;

  beforeAll(async () => {
    await syncTestDb();

    const res = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'financeowner@example.com', password: 'Password123!', full_name: 'Finance Owner', role: 'owner' });
    accessToken = res.body.data.access_token;
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

      expect(res.status).toBe(400);
    });
  });

  describe('GET /api/v1/transactions', () => {
    it('должен возвращать список транзакций', async () => {
      const res = await request(app)
        .get('/api/v1/transactions')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data).toHaveProperty('transactions');
      expect(Array.isArray(res.body.data.transactions)).toBe(true);
    });

    it('должен применять фильтр по типу', async () => {
      const res = await request(app)
        .get('/api/v1/transactions?type=income')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      res.body.data.transactions.forEach(tx => {
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
});
