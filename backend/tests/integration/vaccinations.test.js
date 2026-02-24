const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');

describe('Vaccinations API', () => {
  let accessToken, rabbitId, vaccinationId;

  beforeAll(async () => {
    await syncTestDb();

    const res = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'vacowner@example.com', password: 'Password123!', full_name: 'Vac Owner', role: 'owner' });
    accessToken = res.body.data.access_token;

    const breedRes = await request(app)
      .post('/api/v1/breeds')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({ name: 'Порода для вакцинации' });

    const rabbitRes = await request(app)
      .post('/api/v1/rabbits')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({ name: 'Кролик для вакцин', breed_id: breedRes.body.data.id, sex: 'male', birth_date: '2023-01-01', status: 'healthy' });
    rabbitId = rabbitRes.body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('POST /api/v1/vaccinations', () => {
    it('должен создавать запись о вакцинации', async () => {
      const res = await request(app)
        .post('/api/v1/vaccinations')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          rabbit_id: rabbitId,
          vaccine_name: 'ВГБК',
          vaccine_type: 'vhd',
          vaccination_date: '2024-01-15',
          next_vaccination_date: '2024-07-15',
          notes: 'Плановая вакцинация'
        });

      expect(res.status).toBe(201);
      expect(res.body.data.rabbit_id).toBe(rabbitId);
      expect(res.body.data.vaccine_name).toBe('ВГБК');
      vaccinationId = res.body.data.id;
    });

    it('должен отклонять создание без авторизации', async () => {
      const res = await request(app)
        .post('/api/v1/vaccinations')
        .send({ rabbit_id: rabbitId, vaccine_name: 'Тест', vaccine_type: 'vhd', vaccination_date: '2024-01-01' });

      expect(res.status).toBe(401);
    });

    it('должен отклонять создание без обязательных полей', async () => {
      const res = await request(app)
        .post('/api/v1/vaccinations')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ rabbit_id: rabbitId });

      expect(res.status).toBe(422);
    });
  });

  describe('GET /api/v1/vaccinations', () => {
    it('должен возвращать список вакцинаций', async () => {
      const res = await request(app)
        .get('/api/v1/vaccinations')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data).toHaveProperty('items');
    });

    it('должен фильтровать по rabbit_id', async () => {
      const res = await request(app)
        .get(`/api/v1/vaccinations?rabbit_id=${rabbitId}`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
    });
  });

  describe('GET /api/v1/vaccinations/:id', () => {
    it('должен возвращать вакцинацию по ID', async () => {
      const res = await request(app)
        .get(`/api/v1/vaccinations/${vaccinationId}`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.id).toBe(vaccinationId);
    });

    it('должен возвращать 404 для несуществующей вакцинации', async () => {
      const res = await request(app)
        .get('/api/v1/vaccinations/99999')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(404);
    });
  });

  describe('PUT /api/v1/vaccinations/:id', () => {
    it('должен обновлять запись о вакцинации', async () => {
      const res = await request(app)
        .put(`/api/v1/vaccinations/${vaccinationId}`)
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ notes: 'Обновлённые примечания' });

      expect(res.status).toBe(200);
    });

    it('должен возвращать 404 при обновлении несуществующей записи', async () => {
      const res = await request(app)
        .put('/api/v1/vaccinations/99999')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ notes: 'Тест' });

      expect(res.status).toBe(404);
    });
  });

  describe('GET /api/v1/vaccinations/statistics', () => {
    it('должен возвращать статистику вакцинаций', async () => {
      const res = await request(app)
        .get('/api/v1/vaccinations/statistics')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
    });
  });

  describe('GET /api/v1/vaccinations/upcoming', () => {
    it('должен возвращать предстоящие вакцинации', async () => {
      const res = await request(app)
        .get('/api/v1/vaccinations/upcoming')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
    });
  });

  describe('GET /api/v1/vaccinations/overdue', () => {
    it('должен возвращать просроченные вакцинации', async () => {
      const res = await request(app)
        .get('/api/v1/vaccinations/overdue')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
    });
  });

  describe('DELETE /api/v1/vaccinations/:id', () => {
    it('должен удалять запись о вакцинации', async () => {
      const createRes = await request(app)
        .post('/api/v1/vaccinations')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          rabbit_id: rabbitId,
          vaccine_name: 'Для удаления',
          vaccine_type: 'other',
          vaccination_date: '2024-02-01'
        });

      const res = await request(app)
        .delete(`/api/v1/vaccinations/${createRes.body.data.id}`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
    });

    it('должен возвращать 404 при удалении несуществующей записи', async () => {
      const res = await request(app)
        .delete('/api/v1/vaccinations/99999')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(404);
    });
  });
});
