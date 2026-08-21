const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');

/**
 * Публичная регистрация закрыта: первый зарегистрировавшийся поднимает ферму
 * и становится её владельцем, дальше посторонний завести аккаунт не может.
 */
describe('Регистрация', () => {
  const openByDefault = process.env.ALLOW_REGISTRATION;

  beforeAll(async () => {
    await syncTestDb();
  });

  afterAll(async () => {
    process.env.ALLOW_REGISTRATION = openByDefault;
    await closeTestDb();
  });

  it('первый зарегистрированный становится владельцем', async () => {
    delete process.env.ALLOW_REGISTRATION;

    const res = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'first@example.com', password: 'Password123!', full_name: 'Первый' });

    expect(res.status).toBe(201);
    expect(res.body.data.user.role).toBe('owner');
  });

  it('второму регистрация закрыта', async () => {
    delete process.env.ALLOW_REGISTRATION;

    const res = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'stranger@example.com', password: 'Password123!', full_name: 'Посторонний' });

    expect(res.status).toBe(403);
    expect(res.body.error.message).toBe('Регистрация закрыта. Учётную запись выдаёт владелец фермы.');
  });

  it('закрытая регистрация не выдаёт, занят ли email', async () => {
    delete process.env.ALLOW_REGISTRATION;

    const res = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'first@example.com', password: 'Password123!', full_name: 'Первый' });

    // Тот же 403, что и для нового адреса: перебирать почты бессмысленно.
    expect(res.status).toBe(403);
  });

  it('при явно открытой регистрации новый пользователь получает роль работника', async () => {
    process.env.ALLOW_REGISTRATION = 'true';

    const res = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'worker@example.com', password: 'Password123!', full_name: 'Работник' });

    expect(res.status).toBe(201);
    expect(res.body.data.user.role).toBe('worker');
  });
});
