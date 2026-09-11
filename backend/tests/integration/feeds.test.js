const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');

describe('Feeds API', () => {
  let accessToken;
  let feedId;

  beforeAll(async () => {
    await syncTestDb();

    const res = await registerFarm(app, { email: 'feedowner@example.com', full_name: 'Feed Owner' });
    accessToken = res.accessToken;
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
      expect(res.body.data).toHaveProperty('items');
      expect(res.body.data).toHaveProperty('pagination');
      expect(Array.isArray(res.body.data.items)).toBe(true);
    });

    it('должен применять фильтр по типу', async () => {
      const res = await request(app)
        .get('/api/v1/feeds?type=pellets')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      res.body.data.items.forEach(feed => {
        expect(feed.type).toBe('pellets');
      });
    });

    it('должен поддерживать поиск', async () => {
      const res = await request(app)
        .get('/api/v1/feeds')
        .query({ search: 'Гранул' })
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(Array.isArray(res.body.data.items)).toBe(true);
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

  describe('параметры списка проверяются', () => {
    // Регрессия: sort_by уходил в SQL как есть, и опечатка возвращала общую
    // пятисотку вместо понятного объяснения, какой параметр неверен.
    it('неизвестное поле сортировки — понятная ошибка, а не 500', async () => {
      const res = await request(app)
        .get('/api/v1/feeds?sort_by=no_such_column')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(422);
      expect(res.body.error.message).toBeTruthy();
    });

    // Регрессия: limit не был ограничен ничем — ?limit=500000 поднимал в
    // память всю таблицу вместе со связями.
    it('слишком большой лимит отклоняется', async () => {
      const res = await request(app)
        .get('/api/v1/feeds?limit=500000')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(422);
    });

    it('разрешённое поле сортировки работает', async () => {
      const res = await request(app)
        .get('/api/v1/feeds?sort_by=current_stock&sort_order=asc')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
    });
  });
});
