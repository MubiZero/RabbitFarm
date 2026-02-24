const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');

describe('Feeds API', () => {
  let accessToken;
  let feedId;

  beforeAll(async () => {
    await syncTestDb();

    const res = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'feedowner@example.com', password: 'Password123!', full_name: 'Feed Owner', role: 'owner' });
    accessToken = res.body.data.access_token;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('POST /api/v1/feeds', () => {
    it('должен создавать корм', async () => {
      const res = await request(app)
        .post('/api/v1/feeds')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          name: 'Гранулированный корм',
          type: 'pellets',
          unit: 'kg',
          current_stock: 50,
          min_stock: 10,
          cost_per_unit: 120.50
        });

      expect(res.status).toBe(201);
      expect(res.body.data.name).toBe('Гранулированный корм');
      expect(res.body.data.type).toBe('pellets');
      feedId = res.body.data.id;
    });

    it('должен создавать корм с минимальными полями', async () => {
      const res = await request(app)
        .post('/api/v1/feeds')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          name: 'Сено',
          type: 'hay'
        });

      expect(res.status).toBe(201);
      expect(res.body.data.name).toBe('Сено');
    });

    it('должен отклонять создание без авторизации', async () => {
      const res = await request(app)
        .post('/api/v1/feeds')
        .send({ name: 'Тест', type: 'hay' });

      expect(res.status).toBe(401);
    });

    it('должен отклонять корм без обязательных полей', async () => {
      const res = await request(app)
        .post('/api/v1/feeds')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ type: 'pellets' });

      expect(res.status).toBe(422);
    });
  });

  describe('GET /api/v1/feeds', () => {
    it('должен возвращать список кормов', async () => {
      const res = await request(app)
        .get('/api/v1/feeds')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data).toHaveProperty('rows');
      expect(Array.isArray(res.body.data.rows)).toBe(true);
    });

    it('должен применять фильтр по типу', async () => {
      const res = await request(app)
        .get('/api/v1/feeds?type=pellets')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      res.body.data.rows.forEach(feed => {
        expect(feed.type).toBe('pellets');
      });
    });

    it('должен поддерживать поиск', async () => {
      const res = await request(app)
        .get('/api/v1/feeds')
        .query({ search: 'Гранул' })
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(Array.isArray(res.body.data.rows)).toBe(true);
    });
  });

  describe('GET /api/v1/feeds/:id', () => {
    it('должен возвращать корм по ID', async () => {
      const res = await request(app)
        .get(`/api/v1/feeds/${feedId}`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.id).toBe(feedId);
    });

    it('должен возвращать 404 для несуществующего корма', async () => {
      const res = await request(app)
        .get('/api/v1/feeds/99999')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(404);
    });
  });

  describe('PUT /api/v1/feeds/:id', () => {
    it('должен обновлять корм', async () => {
      const res = await request(app)
        .put(`/api/v1/feeds/${feedId}`)
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Обновлённый корм', min_stock: 15 });

      expect(res.status).toBe(200);
      expect(res.body.data.name).toBe('Обновлённый корм');
    });

    it('должен возвращать 404 при обновлении несуществующего корма', async () => {
      const res = await request(app)
        .put('/api/v1/feeds/99999')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Тест' });

      expect(res.status).toBe(404);
    });
  });

  describe('GET /api/v1/feeds/statistics', () => {
    it('должен возвращать статистику кормов', async () => {
      const res = await request(app)
        .get('/api/v1/feeds/statistics')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data).toHaveProperty('total_feeds');
      expect(res.body.data).toHaveProperty('by_type');
      expect(res.body.data).toHaveProperty('low_stock_count');
    });
  });

  describe('GET /api/v1/feeds/low-stock', () => {
    it('должен возвращать корма с низким запасом', async () => {
      const res = await request(app)
        .get('/api/v1/feeds/low-stock')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(Array.isArray(res.body.data)).toBe(true);
    });
  });

  describe('POST /api/v1/feeds/:id/adjust-stock', () => {
    it('должен добавлять запас корма', async () => {
      const res = await request(app)
        .post(`/api/v1/feeds/${feedId}/adjust-stock`)
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ quantity: 20, operation: 'add' });

      expect(res.status).toBe(200);
    });

    it('должен списывать запас корма', async () => {
      const res = await request(app)
        .post(`/api/v1/feeds/${feedId}/adjust-stock`)
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ quantity: 5, operation: 'subtract' });

      expect(res.status).toBe(200);
    });

    it('должен возвращать ошибку при недостаточном запасе', async () => {
      const res = await request(app)
        .post(`/api/v1/feeds/${feedId}/adjust-stock`)
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ quantity: 99999, operation: 'subtract' });

      expect(res.status).toBe(400);
    });

    it('должен возвращать 404 для несуществующего корма', async () => {
      const res = await request(app)
        .post('/api/v1/feeds/99999/adjust-stock')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ quantity: 10, operation: 'add' });

      expect(res.status).toBe(404);
    });

    it('должен отклонять некорректные данные', async () => {
      const res = await request(app)
        .post(`/api/v1/feeds/${feedId}/adjust-stock`)
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ quantity: -5, operation: 'add' });

      expect(res.status).toBe(422);
    });
  });

  describe('DELETE /api/v1/feeds/:id', () => {
    it('должен возвращать 404 при удалении несуществующего корма', async () => {
      const res = await request(app)
        .delete('/api/v1/feeds/99999')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(404);
    });

    it('должен удалять корм без записей кормления', async () => {
      // Create a feed to delete
      const createRes = await request(app)
        .post('/api/v1/feeds')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Временный корм', type: 'grain' });

      const tempFeedId = createRes.body.data.id;

      const res = await request(app)
        .delete(`/api/v1/feeds/${tempFeedId}`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
    });
  });
});
