const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');

describe('Rabbits API', () => {
  let accessToken, breedId;

  beforeAll(async () => {
    await syncTestDb();

    const res = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'farmer@example.com', password: 'Password123!', full_name: 'Farmer', role: 'owner' });
    accessToken = res.body.data.access_token;

    const breedRes = await request(app)
      .post('/api/v1/breeds')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({ name: 'Серый великан', description: 'Мясная порода', average_weight: 5.0 });
    breedId = breedRes.body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('POST /api/v1/rabbits', () => {
    it('должен создавать кролика', async () => {
      const res = await request(app)
        .post('/api/v1/rabbits')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          name: 'Буся',
          breed_id: breedId,
          sex: 'female',
          birth_date: '2024-01-01',
          status: 'healthy',
          purpose: 'breeding',
          weight: 2.5
        });

      expect(res.status).toBe(201);
      expect(res.body.data.name).toBe('Буся');
    });

    it('должен отклонять создание кролика без авторизации', async () => {
      const res = await request(app)
        .post('/api/v1/rabbits')
        .send({ name: 'Тест', breed_id: breedId, sex: 'male' });

      expect(res.status).toBe(401);
    });

    it('должен отклонять несуществующую породу', async () => {
      const res = await request(app)
        .post('/api/v1/rabbits')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Тест', breed_id: 9999, sex: 'male', birth_date: '2024-01-01', status: 'healthy' });

      expect(res.status).toBe(404);
    });
  });

  describe('GET /api/v1/rabbits', () => {
    it('должен возвращать список кроликов пользователя', async () => {
      const res = await request(app)
        .get('/api/v1/rabbits')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data).toHaveProperty('items');
      expect(res.body.data).toHaveProperty('pagination');
      expect(Array.isArray(res.body.data.items)).toBe(true);
    });

    it('должен применять фильтр по полу', async () => {
      const res = await request(app)
        .get('/api/v1/rabbits?sex=female')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      res.body.data.items.forEach(rabbit => {
        expect(rabbit.sex).toBe('female');
      });
    });

    it('должен поддерживать пагинацию', async () => {
      const res = await request(app)
        .get('/api/v1/rabbits?page=1&limit=5')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.pagination.page).toBe(1);
      expect(res.body.data.pagination.limit).toBe(5);
    });
  });

  describe('GET /api/v1/rabbits/:id', () => {
    let rabbitId;

    beforeAll(async () => {
      const res = await request(app)
        .post('/api/v1/rabbits')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Гоша', breed_id: breedId, sex: 'male', birth_date: '2024-01-01', status: 'healthy' });
      rabbitId = res.body.data.id;
    });

    it('должен возвращать кролика по ID', async () => {
      const res = await request(app)
        .get(`/api/v1/rabbits/${rabbitId}`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.name).toBe('Гоша');
    });

    it('должен возвращать 404 для несуществующего кролика', async () => {
      const res = await request(app)
        .get('/api/v1/rabbits/99999')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(404);
    });

    it('не должен возвращать кролика другого пользователя (IDOR защита)', async () => {
      const res2 = await request(app)
        .post('/api/v1/auth/register')
        .send({ email: 'other@example.com', password: 'Password123!', full_name: 'Other' });
      const otherToken = res2.body.data.access_token;

      const rabbitRes = await request(app)
        .get(`/api/v1/rabbits/${rabbitId}`)
        .set('Authorization', `Bearer ${otherToken}`);

      expect(rabbitRes.status).toBe(404);
    });
  });
});
