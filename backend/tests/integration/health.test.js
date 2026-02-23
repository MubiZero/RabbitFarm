const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');

describe('Medical Records API', () => {
  let accessToken, rabbitId;

  beforeAll(async () => {
    await syncTestDb();

    const res = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'healthowner@example.com', password: 'Password123!', full_name: 'Health Owner', role: 'owner' });
    accessToken = res.body.data.access_token;

    // Create a breed and rabbit
    const breedRes = await request(app)
      .post('/api/v1/breeds')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({ name: 'Порода для здоровья', average_weight: 4.0 });
    const breedId = breedRes.body.data.id;

    const rabbitRes = await request(app)
      .post('/api/v1/rabbits')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({ name: 'Больной кролик', breed_id: breedId, sex: 'male', birth_date: '2023-06-01', status: 'sick' });
    rabbitId = rabbitRes.body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('POST /api/v1/medical-records', () => {
    it('должен создавать медицинскую запись', async () => {
      const res = await request(app)
        .post('/api/v1/medical-records')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          rabbit_id: rabbitId,
          symptoms: 'Вялость, потеря аппетита',
          diagnosis: 'ОРВИ',
          treatment: 'Покой, тепло',
          started_at: '2024-05-01'
        });

      expect(res.status).toBe(201);
      expect(res.body.data.rabbit_id).toBe(rabbitId);
    });

    it('должен отклонять создание без авторизации', async () => {
      const res = await request(app)
        .post('/api/v1/medical-records')
        .send({ rabbit_id: rabbitId, symptoms: 'Тест' });

      expect(res.status).toBe(401);
    });

    it('должен отклонять создание без симптомов', async () => {
      const res = await request(app)
        .post('/api/v1/medical-records')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ rabbit_id: rabbitId });

      expect(res.status).toBe(400);
    });
  });

  describe('GET /api/v1/medical-records', () => {
    it('должен возвращать список медицинских записей', async () => {
      const res = await request(app)
        .get('/api/v1/medical-records')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data).toHaveProperty('items');
      expect(Array.isArray(res.body.data.items)).toBe(true);
    });
  });

  describe('GET /api/v1/medical-records/:id', () => {
    let recordId;

    beforeAll(async () => {
      const res = await request(app)
        .post('/api/v1/medical-records')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ rabbit_id: rabbitId, symptoms: 'Насморк', started_at: '2024-05-10' });
      recordId = res.body.data.id;
    });

    it('должен возвращать запись по ID', async () => {
      const res = await request(app)
        .get(`/api/v1/medical-records/${recordId}`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.id).toBe(recordId);
    });

    it('должен возвращать 404 для несуществующей записи', async () => {
      const res = await request(app)
        .get('/api/v1/medical-records/99999')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(404);
    });
  });
});
