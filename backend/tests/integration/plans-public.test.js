const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { Plan } = require('../../src/models');

/**
 * Тарифы спрашивают до регистрации.
 *
 * В знакомстве человек говорит, сколько у него кроликов, и тут же должен
 * увидеть, во что это обойдётся. Узнать цену, уже заведя хозяйство и триста
 * записей, — тупик того же сорта, что разбирал `docs/plans/DEAD-ENDS.md`,
 * поэтому список открыт без входа.
 */
describe('Публичный список тарифов', () => {
  beforeAll(async () => {
    await syncTestDb();
    await Plan.bulkCreate([
      { name: 'Большой', max_rabbits: null, max_staff: null, price: 250, is_active: true },
      { name: 'Бесплатный', max_rabbits: 20, max_staff: 1, price: 0, is_active: true, is_default: true },
      { name: 'Средний', max_rabbits: 200, max_staff: 3, price: 90, is_active: true },
      { name: 'Снятый с продажи', max_rabbits: 50, max_staff: 2, price: 40, is_active: false }
    ]);
  });

  afterAll(async () => {
    await closeTestDb();
  });

  it('отдаётся без входа: цену спрашивают до регистрации', async () => {
    const res = await request(app).get('/api/v1/plans');

    expect(res.status).toBe(200);
    expect(res.body.data.plans.map((plan) => plan.name)).toEqual([
      'Бесплатный',
      'Средний',
      'Большой'
    ]);
  });

  it('выключенный тариф не предлагается', async () => {
    const res = await request(app).get('/api/v1/plans');

    expect(res.body.data.plans.map((plan) => plan.name)).not.toContain(
      'Снятый с продажи'
    );
  });

  it('отдаёт только то, чем тарифы различаются', async () => {
    const res = await request(app).get('/api/v1/plans');
    const free = res.body.data.plans[0];

    expect(free).toEqual({
      id: expect.any(Number),
      name: 'Бесплатный',
      max_rabbits: 20,
      max_staff: 1,
      price: 0
    });
    // Ферм на тарифе и флага «по умолчанию» покупателю знать незачем: это
    // наша кухня, а не ответ на его вопрос.
    expect(free).not.toHaveProperty('farms');
    expect(free).not.toHaveProperty('is_default');
  });

  it('«без ограничения» стоит последним, а не первым', async () => {
    const res = await request(app).get('/api/v1/plans');
    const last = res.body.data.plans[res.body.data.plans.length - 1];

    expect(last.max_rabbits).toBeNull();
  });
});
