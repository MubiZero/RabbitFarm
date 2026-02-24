const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');

describe('Tasks API', () => {
  let accessToken;

  beforeAll(async () => {
    await syncTestDb();

    const res = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'taskowner@example.com', password: 'Password123!', full_name: 'Task Owner', role: 'owner' });
    accessToken = res.body.data.access_token;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('POST /api/v1/tasks', () => {
    it('должен создавать задачу', async () => {
      const res = await request(app)
        .post('/api/v1/tasks')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          title: 'Покормить кроликов',
          type: 'feeding',
          priority: 'high',
          due_date: '2024-06-01'
        });

      expect(res.status).toBe(201);
      expect(res.body.data.title).toBe('Покормить кроликов');
    });

    it('должен отклонять создание без авторизации', async () => {
      const res = await request(app)
        .post('/api/v1/tasks')
        .send({ title: 'Тест', type: 'feeding' });

      expect(res.status).toBe(401);
    });

    it('должен отклонять задачу без названия', async () => {
      const res = await request(app)
        .post('/api/v1/tasks')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ type: 'feeding' });

      expect(res.status).toBe(422);
    });
  });

  describe('GET /api/v1/tasks', () => {
    it('должен возвращать список задач', async () => {
      const res = await request(app)
        .get('/api/v1/tasks')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data).toHaveProperty('tasks');
      expect(Array.isArray(res.body.data.tasks)).toBe(true);
    });
  });

  describe('GET /api/v1/tasks/:id', () => {
    let taskId;

    beforeAll(async () => {
      const res = await request(app)
        .post('/api/v1/tasks')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ title: 'Уборка клеток', type: 'cleaning', priority: 'medium', due_date: '2024-07-01' });
      taskId = res.body.data.id;
    });

    it('должен возвращать задачу по ID', async () => {
      const res = await request(app)
        .get(`/api/v1/tasks/${taskId}`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.id).toBe(taskId);
    });

    it('должен возвращать 404 для несуществующей задачи', async () => {
      const res = await request(app)
        .get('/api/v1/tasks/99999')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(404);
    });

    it('должен завершать задачу', async () => {
      const res = await request(app)
        .post(`/api/v1/tasks/${taskId}/complete`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.status).toBe('completed');
    });
  });

  describe('GET /api/v1/tasks/statistics', () => {
    it('должен возвращать статистику задач', async () => {
      const res = await request(app)
        .get('/api/v1/tasks/statistics')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data).toHaveProperty('total_pending');
    });
  });
});
