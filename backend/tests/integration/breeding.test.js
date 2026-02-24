const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');

describe('Breeding API', () => {
  let accessToken, maleId, femaleId;

  beforeAll(async () => {
    await syncTestDb();

    const res = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'breedowner@example.com', password: 'Password123!', full_name: 'Breed Owner', role: 'owner' });
    accessToken = res.body.data.access_token;

    // Create a breed first
    const breedRes = await request(app)
      .post('/api/v1/breeds')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({ name: 'Белый великан', description: 'Порода', average_weight: 5.0 });
    const breedId = breedRes.body.data.id;

    // Create male rabbit
    const maleRes = await request(app)
      .post('/api/v1/rabbits')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({ name: 'Самец', breed_id: breedId, sex: 'male', birth_date: '2023-01-01', status: 'healthy' });
    maleId = maleRes.body.data.id;

    // Create female rabbit
    const femaleRes = await request(app)
      .post('/api/v1/rabbits')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({ name: 'Самка', breed_id: breedId, sex: 'female', birth_date: '2023-01-01', status: 'healthy' });
    femaleId = femaleRes.body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('POST /api/v1/breeding', () => {
    it('должен создавать запись о случке', async () => {
      const res = await request(app)
        .post('/api/v1/breeding')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          male_id: maleId,
          female_id: femaleId,
          breeding_date: '2024-03-01',
          status: 'planned'
        });

      expect(res.status).toBe(201);
      expect(res.body.data.male_id).toBe(maleId);
      expect(res.body.data.female_id).toBe(femaleId);
    });

    it('должен отклонять создание без авторизации', async () => {
      const res = await request(app)
        .post('/api/v1/breeding')
        .send({ male_id: maleId, female_id: femaleId, breeding_date: '2024-03-01' });

      expect(res.status).toBe(401);
    });

    it('должен отклонять несуществующего самца', async () => {
      const res = await request(app)
        .post('/api/v1/breeding')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ male_id: 99999, female_id: femaleId, breeding_date: '2024-03-01' });

      expect(res.status).toBe(404);
    });

    it('должен отклонять самку в качестве самца', async () => {
      // Use female rabbit as male (different IDs to avoid CANNOT_BREED_SAME_RABBIT check)
      const res = await request(app)
        .post('/api/v1/breeding')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ male_id: femaleId, female_id: maleId, breeding_date: '2024-03-01' });

      expect(res.status).toBe(400);
    });
  });

  describe('GET /api/v1/breeding', () => {
    it('должен возвращать список случек', async () => {
      const res = await request(app)
        .get('/api/v1/breeding')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data).toHaveProperty('items');
      expect(res.body.data).toHaveProperty('pagination');
      expect(Array.isArray(res.body.data.items)).toBe(true);
    });
  });

  describe('GET /api/v1/breeding/:id', () => {
    let breedingId;

    beforeAll(async () => {
      const res = await request(app)
        .post('/api/v1/breeding')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ male_id: maleId, female_id: femaleId, breeding_date: '2024-04-01' });
      breedingId = res.body.data.id;
    });

    it('должен возвращать случку по ID', async () => {
      const res = await request(app)
        .get(`/api/v1/breeding/${breedingId}`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.id).toBe(breedingId);
    });

    it('должен возвращать 404 для несуществующей случки', async () => {
      const res = await request(app)
        .get('/api/v1/breeding/99999')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(404);
    });
  });

  describe('GET /api/v1/breeding/statistics', () => {
    it('должен возвращать статистику случек', async () => {
      const res = await request(app)
        .get('/api/v1/breeding/statistics')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data).toHaveProperty('total');
    });
  });
});
