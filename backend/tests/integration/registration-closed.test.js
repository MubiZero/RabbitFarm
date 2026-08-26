const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { User } = require('../../src/models');

/**
 * Ферм в сервисе много, и регистрация заводит новую: каждый
 * зарегистрировавшийся становится владельцем собственного хозяйства.
 *
 * Раньше владельцем был только самый первый пользователь системы, а всем
 * следующим доставалась роль работника без фермы — пустой экран и ни одной
 * доступной кнопки. Флаг `ALLOW_REGISTRATION` остался выключателем на случай
 * закрытого стенда, но теперь он именно выключатель: закрывает только когда
 * выставлен явно.
 */
describe('Регистрация', () => {
  const initialFlag = process.env.ALLOW_REGISTRATION;

  beforeAll(async () => {
    await syncTestDb();
  });

  afterAll(async () => {
    process.env.ALLOW_REGISTRATION = initialFlag;
    await closeTestDb();
  });

  beforeEach(() => {
    delete process.env.ALLOW_REGISTRATION;
  });

  const register = (email, name) =>
    request(app)
      .post('/api/v1/auth/register')
      .send({ email, password: 'Password123!', full_name: name });

  it('первый зарегистрированный становится владельцем', async () => {
    const res = await register('first@example.com', 'Первый');

    expect(res.status).toBe(201);
    expect(res.body.data.user.role).toBe('owner');
  });

  it('второй тоже владелец — своей фермы, а не работник чужой', async () => {
    const res = await register('second@example.com', 'Второй');

    expect(res.status).toBe(201);
    expect(res.body.data.user.role).toBe('owner');

    // Пустой `owner_id` и есть признак собственной фермы: `req.farmId`
    // считается как `owner_id || id`.
    const user = await User.findByPk(res.body.data.user.id);
    expect(user.owner_id).toBeNull();
  });

  it('фермы разные: у второго свой farmId, не первого', async () => {
    const first = await User.findOne({ where: { email: 'first@example.com' } });
    const second = await User.findOne({ where: { email: 'second@example.com' } });

    const farmOf = (user) => user.owner_id || user.id;

    expect(farmOf(second)).not.toBe(farmOf(first));
  });

  it('занятая почта отвергается', async () => {
    const res = await register('first@example.com', 'Первый');

    expect(res.status).toBe(409);
  });

  it('выключатель закрывает регистрацию', async () => {
    process.env.ALLOW_REGISTRATION = 'false';

    const res = await register('stranger@example.com', 'Посторонний');

    expect(res.status).toBe(403);
    expect(res.body.error.message).toBe(
      'Регистрация закрыта. Учётную запись выдаёт владелец фермы.'
    );
  });

  it('закрытая регистрация не выдаёт, занят ли email', async () => {
    process.env.ALLOW_REGISTRATION = 'false';

    const res = await register('first@example.com', 'Первый');

    // Тот же 403, что и для нового адреса: перебирать почты бессмысленно.
    expect(res.status).toBe(403);
  });
});
