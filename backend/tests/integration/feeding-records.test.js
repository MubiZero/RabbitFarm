const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');

describe('Feeding Records API', () => {
  let accessToken, feedId, cageId, recordId;

  beforeAll(async () => {
    await syncTestDb();

    const res = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'feedrecowner@example.com', password: 'Password123!', full_name: 'FeedRec Owner', role: 'owner' });
    accessToken = res.body.data.access_token;

    // Create a feed for feeding records
    const feedRes = await request(app)
      .post('/api/v1/feeds')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({ name: 'Корм для записей', type: 'pellets', current_stock: 100 });
    feedId = feedRes.body.data.id;

    // Create a cage for feeding records
    const cageRes = await request(app)
      .post('/api/v1/cages')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({ number: 'C-FEED-01', type: 'single', capacity: 2, location: 'Test' });
    if (!cageRes.body.data) throw new Error(`Cage creation failed: ${JSON.stringify(cageRes.body)}`);
    cageId = cageRes.body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('POST /api/v1/feeding-records', () => {
    it('должен создавать запись кормления для клетки', async () => {
      const res = await request(app)
        .post('/api/v1/feeding-records')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          feed_id: feedId,
          cage_id: cageId,
          quantity: 2.5,
          fed_at: '2024-05-01T08:00:00Z',
          notes: 'Утреннее кормление'
        });

      expect(res.status).toBe(201);
      expect(res.body.data.feed_id).toBe(feedId);
      recordId = res.body.data.id;
    });

    it('должен отклонять создание без авторизации', async () => {
      const res = await request(app)
        .post('/api/v1/feeding-records')
        .send({ feed_id: feedId, cage_id: cageId, quantity: 1.0, fed_at: '2024-05-01T08:00:00Z' });

      expect(res.status).toBe(401);
    });

    it('должен отклонять создание без обязательных полей', async () => {
      const res = await request(app)
        .post('/api/v1/feeding-records')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ feed_id: feedId });

      expect(res.status).toBe(422);
    });
  });

  describe('GET /api/v1/feeding-records', () => {
    it('должен возвращать список записей кормления', async () => {
      const res = await request(app)
        .get('/api/v1/feeding-records')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data).toHaveProperty('rows');
    });

    it('должен фильтровать по feed_id', async () => {
      const res = await request(app)
        .get(`/api/v1/feeding-records?feed_id=${feedId}`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
    });
  });

  describe('GET /api/v1/feeding-records/:id', () => {
    it('должен возвращать запись кормления по ID', async () => {
      const res = await request(app)
        .get(`/api/v1/feeding-records/${recordId}`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.id).toBe(recordId);
    });

    it('должен возвращать 404 для несуществующей записи', async () => {
      const res = await request(app)
        .get('/api/v1/feeding-records/99999')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(404);
    });
  });

  describe('PUT /api/v1/feeding-records/:id', () => {
    it('должен обновлять запись кормления', async () => {
      const res = await request(app)
        .put(`/api/v1/feeding-records/${recordId}`)
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ notes: 'Обновлённые примечания' });

      expect(res.status).toBe(200);
    });

    it('должен возвращать 404 при обновлении несуществующей записи', async () => {
      const res = await request(app)
        .put('/api/v1/feeding-records/99999')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ notes: 'Тест' });

      expect(res.status).toBe(404);
    });
  });

  describe('GET /api/v1/feeding-records/statistics', () => {
    it('должен возвращать статистику кормления', async () => {
      const res = await request(app)
        .get('/api/v1/feeding-records/statistics')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
    });
  });

  describe('GET /api/v1/feeding-records/recent', () => {
    it('должен возвращать последние записи кормления', async () => {
      const res = await request(app)
        .get('/api/v1/feeding-records/recent')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
    });
  });

  describe('DELETE /api/v1/feeding-records/:id', () => {
    it('должен удалять запись кормления', async () => {
      const createRes = await request(app)
        .post('/api/v1/feeding-records')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ feed_id: feedId, cage_id: cageId, quantity: 1.0, fed_at: '2024-05-01T09:00:00Z' });

      const res = await request(app)
        .delete(`/api/v1/feeding-records/${createRes.body.data.id}`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
    });

    it('должен возвращать 404 при удалении несуществующей записи', async () => {
      const res = await request(app)
        .delete('/api/v1/feeding-records/99999')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(404);
    });
  });
});
