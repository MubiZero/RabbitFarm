const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');

describe('Breeds API', () => {
  let accessToken;
  let breedId;

  beforeAll(async () => {
    await syncTestDb();

    const res = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'breedowner@example.com', password: 'Password123!', full_name: 'Breed Owner', role: 'owner' });
    accessToken = res.body.data.access_token;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('POST /api/v1/breeds', () => {
    it('должен создавать породу', async () => {
      const res = await request(app)
        .post('/api/v1/breeds')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          name: 'Новозеландский белый',
          description: 'Мясная порода',
          origin: 'США'
        });

      expect(res.status).toBe(201);
      expect(res.body.data.name).toBe('Новозеландский белый');
      breedId = res.body.data.id;
    });

    it('должен отклонять создание дубликата породы', async () => {
      const res = await request(app)
        .post('/api/v1/breeds')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Новозеландский белый' });

      expect(res.status).toBe(400);
    });

    it('должен отклонять создание без авторизации', async () => {
      const res = await request(app)
        .post('/api/v1/breeds')
        .send({ name: 'Тест' });

      expect(res.status).toBe(401);
    });
  });

  describe('GET /api/v1/breeds', () => {
    it('должен возвращать список пород', async () => {
      const res = await request(app)
        .get('/api/v1/breeds')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(Array.isArray(res.body.data)).toBe(true);
      expect(res.body.data.length).toBeGreaterThan(0);
    });

    it('должен отклонять запрос без авторизации', async () => {
      const res = await request(app)
        .get('/api/v1/breeds');

      expect(res.status).toBe(401);
    });
  });

  describe('GET /api/v1/breeds/:id', () => {
    it('должен возвращать породу по ID', async () => {
      const res = await request(app)
        .get(`/api/v1/breeds/${breedId}`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.id).toBe(breedId);
      expect(res.body.data.name).toBe('Новозеландский белый');
    });

    it('должен возвращать 404 для несуществующей породы', async () => {
      const res = await request(app)
        .get('/api/v1/breeds/99999')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(404);
    });
  });

  describe('PUT /api/v1/breeds/:id', () => {
    it('должен обновлять породу', async () => {
      const res = await request(app)
        .put(`/api/v1/breeds/${breedId}`)
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ description: 'Обновлённое описание' });

      expect(res.status).toBe(200);
      expect(res.body.data.description).toBe('Обновлённое описание');
    });

    it('должен возвращать 404 при обновлении несуществующей породы', async () => {
      const res = await request(app)
        .put('/api/v1/breeds/99999')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Тест' });

      expect(res.status).toBe(404);
    });

    it('должен отклонять дублирующееся название при обновлении', async () => {
      // Create second breed
      await request(app)
        .post('/api/v1/breeds')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Калифорнийский' });

      const res = await request(app)
        .put(`/api/v1/breeds/${breedId}`)
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Калифорнийский' });

      expect(res.status).toBe(400);
    });
  });

  describe('DELETE /api/v1/breeds/:id', () => {
    it('должен возвращать 404 при удалении несуществующей породы', async () => {
      const res = await request(app)
        .delete('/api/v1/breeds/99999')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(404);
    });

    it('должен удалять породу без кроликов', async () => {
      const createRes = await request(app)
        .post('/api/v1/breeds')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Порода для удаления' });

      const tempBreedId = createRes.body.data.id;

      const res = await request(app)
        .delete(`/api/v1/breeds/${tempBreedId}`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
    });
  });
});
