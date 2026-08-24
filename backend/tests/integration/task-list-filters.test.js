const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');

/**
 * Фильтры списка задач раньше «работали» молча: валидация пропускала запрос,
 * ошибок не было, а выборка не менялась. Поэтому проверяем не код ответа,
 * а состав items — только он показывает, что фильтр действительно фильтрует.
 */
describe('Фильтры списка задач', () => {
  let accessToken;

  const titles = (res) => res.body.data.items.map((task) => task.title);

  const createTask = async (title, dueDate) => {
    const res = await request(app)
      .post('/api/v1/tasks')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({ title, type: 'feeding', priority: 'medium', due_date: dueDate });
    return res.body.data.id;
  };

  const listTasks = (query) =>
    request(app)
      .get('/api/v1/tasks')
      .query({ limit: 100, ...query })
      .set('Authorization', `Bearer ${accessToken}`);

  beforeAll(async () => {
    await syncTestDb();

    const registered = await request(app)
      .post('/api/v1/auth/register')
      .send({
        email: 'taskfilters@example.com',
        password: 'Password123!',
        full_name: 'Task Filters Owner',
        role: 'owner'
      });
    accessToken = registered.body.data.access_token;

    await createTask('Просрочена', '2020-01-01T10:00:00.000Z');
    await createTask('В будущем', '2099-01-01T10:00:00.000Z');
    await createTask('Сегодня', new Date().toISOString());

    const completedId = await createTask('Просрочена и завершена', '2020-02-01T10:00:00.000Z');
    await request(app)
      .post(`/api/v1/tasks/${completedId}/complete`)
      .set('Authorization', `Bearer ${accessToken}`);
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('overdue_only', () => {
    it('должен оставлять только незакрытые просроченные задачи', async () => {
      const res = await listTasks({ overdue_only: 'true' });

      expect(res.status).toBe(200);
      expect(titles(res)).toContain('Просрочена');
      expect(titles(res)).not.toContain('В будущем');
      // Завершённая задача не просрочена: догонять уже нечего.
      expect(titles(res)).not.toContain('Просрочена и завершена');
    });

    it('не должен ничего отсекать при overdue_only=false', async () => {
      const res = await listTasks({ overdue_only: 'false' });

      expect(res.status).toBe(200);
      expect(titles(res)).toContain('В будущем');
    });

    it('не должен ничего отсекать без overdue_only', async () => {
      const res = await listTasks({});

      expect(res.status).toBe(200);
      expect(titles(res)).toEqual(
        expect.arrayContaining(['Просрочена', 'В будущем', 'Сегодня', 'Просрочена и завершена'])
      );
    });
  });

  describe('today_only', () => {
    it('должен оставлять только сегодняшние задачи', async () => {
      const res = await listTasks({ today_only: 'true' });

      expect(res.status).toBe(200);
      expect(titles(res)).toEqual(['Сегодня']);
    });

    it('не должен ничего отсекать при today_only=false', async () => {
      const res = await listTasks({ today_only: 'false' });

      expect(res.status).toBe(200);
      expect(titles(res)).toEqual(
        expect.arrayContaining(['Просрочена', 'В будущем', 'Сегодня'])
      );
    });
  });

  describe('диапазон дат', () => {
    it('должен принимать to_date без from_date и обрезать по нему', async () => {
      const res = await listTasks({ to_date: '2021-01-01' });

      expect(res.status).toBe(200);
      expect(titles(res)).toContain('Просрочена');
      expect(titles(res)).not.toContain('В будущем');
      expect(titles(res)).not.toContain('Сегодня');
    });

    it('должен принимать from_date без to_date', async () => {
      const res = await listTasks({ from_date: '2050-01-01' });

      expect(res.status).toBe(200);
      expect(titles(res)).toEqual(['В будущем']);
    });

    it('должен отвергать to_date раньше from_date', async () => {
      const res = await listTasks({ from_date: '2026-08-10', to_date: '2026-08-01' });

      expect(res.status).toBe(422);
    });
  });
});
