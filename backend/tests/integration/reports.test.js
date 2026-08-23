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

  describe('отчёт по ферме считает то, что обещает', () => {
    let breedId;

    beforeAll(async () => {
      const breed = await request(app)
        .post('/api/v1/breeds')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Порода для отчёта' });
      breedId = breed.body.data.id;

      const alive = await request(app)
        .post('/api/v1/rabbits')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Живой', breed_id: breedId, sex: 'male', birth_date: '2024-01-01' });

      const sold = await request(app)
        .post('/api/v1/rabbits')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Проданный', breed_id: breedId, sex: 'female', birth_date: '2024-01-01' });

      await request(app)
        .put(`/api/v1/rabbits/${sold.body.data.id}`)
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ status: 'sold' });

      // Прививка внутри периода и прививка задолго до него.
      for (const date of ['2026-03-10', '2024-06-01']) {
        await request(app)
          .post('/api/v1/vaccinations')
          .set('Authorization', `Bearer ${accessToken}`)
          .send({
            rabbit_id: alive.body.data.id,
            vaccine_name: 'ВГБК',
            vaccine_type: 'vhd',
            vaccination_date: date
          });
      }

      // Два корма в разных единицах измерения.
      const pellets = await request(app)
        .post('/api/v1/feeds')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Комбикорм', type: 'pellets', unit: 'kg', current_stock: 100 });

      const carrots = await request(app)
        .post('/api/v1/feeds')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Морковь', type: 'vegetables', unit: 'piece', current_stock: 100 });

      await request(app)
        .post('/api/v1/feeding-records')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          feed_id: pellets.body.data.id,
          rabbit_id: alive.body.data.id,
          quantity: 2.5,
          fed_at: '2026-03-11T09:00:00.000Z'
        });

      await request(app)
        .post('/api/v1/feeding-records')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          feed_id: carrots.body.data.id,
          rabbit_id: alive.body.data.id,
          quantity: 4,
          fed_at: '2026-03-11T10:00:00.000Z'
        });
    });

    // Регрессия: показатели здоровья и кормления считались за всё время
    // фермы, хотя ответ заявлял период.
    it('здоровье и кормление считаются за указанный период', async () => {
      const res = await request(app)
        .get('/api/v1/reports/farm?from_date=2026-03-01&to_date=2026-03-31')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.health.vaccinations).toBe(1);
      expect(res.body.data.feeding.total_feeding_records).toBe(2);
    });

    // Регрессия: расход суммировал килограммы комбикорма со штуками моркови.
    it('расход корма разбит по единицам измерения', async () => {
      const res = await request(app)
        .get('/api/v1/reports/farm?from_date=2026-03-01&to_date=2026-03-31')
        .set('Authorization', `Bearer ${accessToken}`);

      const byUnit = res.body.data.feeding.consumption_by_unit;
      const units = byUnit.map((row) => row.unit).sort();

      expect(units).toEqual(['kg', 'piece']);
      expect(parseFloat(byUnit.find((r) => r.unit === 'kg').total)).toBe(2.5);
      expect(parseFloat(byUnit.find((r) => r.unit === 'piece').total)).toBe(4);
    });

    // Регрессия: проданные и павшие попадали в поголовье.
    it('проданный кролик не входит в поголовье', async () => {
      const farm = await request(app)
        .get('/api/v1/reports/farm')
        .set('Authorization', `Bearer ${accessToken}`);
      expect(farm.body.data.population.total_rabbits).toBe(1);

      const dashboard = await request(app)
        .get('/api/v1/reports/dashboard')
        .set('Authorization', `Bearer ${accessToken}`);
      expect(dashboard.body.data.rabbits.total).toBe(1);
      expect(dashboard.body.data.rabbits.female).toBe(0);
    });
  });
});
