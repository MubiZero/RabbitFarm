const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');

describe('Reports API', () => {
  let accessToken;

  beforeAll(async () => {
    await syncTestDb();

    const res = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'reportowner@example.com', password: 'Password123!', full_name: 'Report Owner', role: 'owner' });
    accessToken = res.body.data.access_token;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('GET /api/v1/reports/dashboard', () => {
    it('должен возвращать данные дашборда', async () => {
      const res = await request(app)
        .get('/api/v1/reports/dashboard')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
    });

    it('должен отклонять запрос без авторизации', async () => {
      const res = await request(app)
        .get('/api/v1/reports/dashboard');

      expect(res.status).toBe(401);
    });
  });

  describe('GET /api/v1/reports/farm', () => {
    it('должен возвращать отчёт по ферме', async () => {
      const res = await request(app)
        .get('/api/v1/reports/farm')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
    });
  });

  describe('GET /api/v1/reports/health', () => {
    it('должен возвращать отчёт по здоровью', async () => {
      const res = await request(app)
        .get('/api/v1/reports/health')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
    });
  });

  describe('GET /api/v1/reports/financial', () => {
    it('должен возвращать финансовый отчёт', async () => {
      const res = await request(app)
        .get('/api/v1/reports/financial')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
    });

    it('должен возвращать финансовый отчёт с датами', async () => {
      const res = await request(app)
        .get('/api/v1/reports/financial?year=2024&month=5')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
    });
  });
});
