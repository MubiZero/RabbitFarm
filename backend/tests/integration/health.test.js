const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');

describe('Medical Records API', () => {
  let accessToken, rabbitId, breedId;

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
    breedId = breedRes.body.data.id;

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

      expect(res.status).toBe(422);
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

  // Регрессии: обе автоматизации писали значения, которых нет в ENUM'ах
  // ('alive' в статусе кролика, 'Health' в категории расхода), из-за чего вся
  // транзакция откатывалась и терялась сама медицинская запись.
  describe('автоматизации при создании записи', () => {
    it('исход "выздоровел" возвращает кролика в здоровый статус', async () => {
      const rabbit = await request(app)
        .post('/api/v1/rabbits')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ name: 'Выздоравливающий', breed_id: breedId, sex: 'female', birth_date: '2023-07-01', status: 'sick' });

      const res = await request(app)
        .post('/api/v1/medical-records')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          rabbit_id: rabbit.body.data.id,
          symptoms: 'Кашель',
          started_at: '2024-05-01',
          outcome: 'recovered'
        });

      expect(res.status).toBe(201);

      const updated = await request(app)
        .get(`/api/v1/rabbits/${rabbit.body.data.id}`)
        .set('Authorization', `Bearer ${accessToken}`);
      expect(updated.body.data.status).toBe('healthy');
    });

    it('стоимость лечения превращается в ветеринарный расход', async () => {
      const res = await request(app)
        .post('/api/v1/medical-records')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          rabbit_id: rabbitId,
          symptoms: 'Отит',
          started_at: '2024-05-02',
          cost: 250
        });

      expect(res.status).toBe(201);

      const transactions = await request(app)
        .get('/api/v1/transactions')
        .set('Authorization', `Bearer ${accessToken}`);
      const created = transactions.body.data.items
        .find((t) => Number(t.amount) === 250);

      expect(created).toBeDefined();
      expect(created.category).toBe('veterinary');
      expect(created.type).toBe('expense');
    });
  });

  describe('DELETE /api/v1/medical-records/:id', () => {
    // Регрессия: include без алиаса 'rabbit' — Sequelize отказывался
    // выполнять запрос, и удаление всегда падало в 500.
    it('должен удалять запись', async () => {
      const created = await request(app)
        .post('/api/v1/medical-records')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ rabbit_id: rabbitId, symptoms: 'Опечатка', started_at: '2024-05-03' });

      const res = await request(app)
        .delete(`/api/v1/medical-records/${created.body.data.id}`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);

      const gone = await request(app)
        .get(`/api/v1/medical-records/${created.body.data.id}`)
        .set('Authorization', `Bearer ${accessToken}`);
      expect(gone.status).toBe(404);
    });

    it('должен возвращать 404 для несуществующей записи', async () => {
      const res = await request(app)
        .delete('/api/v1/medical-records/99999')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(404);
    });
  });
});
