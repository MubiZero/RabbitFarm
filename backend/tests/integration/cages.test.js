const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');

describe('Cages API', () => {
  let accessToken;

  beforeAll(async () => {
    await syncTestDb();

    const res = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'cageowner@example.com', password: 'Password123!', full_name: 'Cage Owner', role: 'owner' });
    accessToken = res.body.data.access_token;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('POST /api/v1/cages', () => {
    it('должен создавать клетку', async () => {
      const res = await request(app)
        .post('/api/v1/cages')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ number: 'A-001', type: 'single', capacity: 1, location: 'Сарай 1' });

      expect(res.status).toBe(201);
      expect(res.body.data.number).toBe('A-001');
    });

    it('должен отклонять создание без авторизации', async () => {
      const res = await request(app)
        .post('/api/v1/cages')
        .send({ number: 'A-002', type: 'single' });

      expect(res.status).toBe(401);
    });

    it('должен отклонять дублирующийся номер клетки', async () => {
      const res = await request(app)
        .post('/api/v1/cages')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ number: 'A-001', type: 'single', capacity: 1 });

      expect(res.status).toBe(400);
    });
  });

  describe('GET /api/v1/cages', () => {
    it('должен возвращать список клеток', async () => {
      const res = await request(app)
        .get('/api/v1/cages')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data).toHaveProperty('items');
      expect(res.body.data).toHaveProperty('pagination');
      expect(Array.isArray(res.body.data.items)).toBe(true);
    });

    it('должен применять фильтр по типу', async () => {
      const res = await request(app)
        .get('/api/v1/cages?type=single')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      res.body.data.items.forEach(cage => {
        expect(cage.type).toBe('single');
      });
    });
  });

  describe('GET /api/v1/cages/:id', () => {
    let cageId;

    beforeAll(async () => {
      const res = await request(app)
        .post('/api/v1/cages')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ number: 'B-001', type: 'group', capacity: 5, location: 'Сарай 2' });
      cageId = res.body.data.id;
    });

    it('должен возвращать клетку по ID', async () => {
      const res = await request(app)
        .get(`/api/v1/cages/${cageId}`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.number).toBe('B-001');
    });

    it('должен возвращать 404 для несуществующей клетки', async () => {
      const res = await request(app)
        .get('/api/v1/cages/99999')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(404);
    });

    it('не должен возвращать клетку другого пользователя (IDOR защита)', async () => {
      const otherRes = await request(app)
        .post('/api/v1/auth/register')
        .send({ email: 'other_cage@example.com', password: 'Password123!', full_name: 'Other' });
      const otherToken = otherRes.body.data.access_token;

      const res = await request(app)
        .get(`/api/v1/cages/${cageId}`)
        .set('Authorization', `Bearer ${otherToken}`);

      expect(res.status).toBe(404);
    });
  });

  describe('GET /api/v1/cages/statistics', () => {
    it('должен возвращать статистику клеток', async () => {
      const res = await request(app)
        .get('/api/v1/cages/statistics')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data).toHaveProperty('total_cages');
      expect(res.body.data).toHaveProperty('by_type');
      expect(res.body.data).toHaveProperty('occupancy');
    });
  });
});
