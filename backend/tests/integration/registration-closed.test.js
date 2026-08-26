const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { Farm, User } = require('../../src/models');

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

  const register = (email, name, farmName) =>
    request(app)
      .post('/api/v1/auth/register')
      .send({
        email,
        password: 'Password123!',
        full_name: name,
        ...(farmName === undefined ? {} : { farm_name: farmName })
      });

  it('первый зарегистрированный становится владельцем', async () => {
    const res = await register('first@example.com', 'Первый');

    expect(res.status).toBe(201);
    expect(res.body.data.user.role).toBe('owner');
  });

  it('второй тоже владелец — своей фермы, а не работник чужой', async () => {
    const res = await register('second@example.com', 'Второй');

    expect(res.status).toBe(201);
    expect(res.body.data.user.role).toBe('owner');

    // Регистрация заводит хозяйство, а не только человека: у новой фермы
    // владельцем должен стоять он сам.
    const user = await User.findByPk(res.body.data.user.id);
    const farm = await Farm.findByPk(user.farm_id);
    expect(farm.owner_id).toBe(user.id);
  });

  it('фермы разные: у второго свой farmId, не первого', async () => {
    const first = await User.findOne({ where: { email: 'first@example.com' } });
    const second = await User.findOne({ where: { email: 'second@example.com' } });

    expect(second.farm_id).not.toBe(first.farm_id);
  });

  it('название хозяйства берётся из формы', async () => {
    const res = await register('named@example.com', 'Третий', 'Кроличий двор');

    const user = await User.findByPk(res.body.data.user.id);
    const farm = await Farm.findByPk(user.farm_id);

    expect(farm.name).toBe('Кроличий двор');
  });

  it('без названия ферма зовётся по имени владельца', async () => {
    // Пустое название читалось бы в списках как сбой, а не как
    // «человек просто не заполнил поле».
    const res = await register('unnamed@example.com', 'Четвёртый');

    const user = await User.findByPk(res.body.data.user.id);
    const farm = await Farm.findByPk(user.farm_id);

    expect(farm.name).toBe('Ферма Четвёртый');
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
