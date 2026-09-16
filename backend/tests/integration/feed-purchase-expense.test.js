const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');

/**
 * Корм — обычно главная статья затрат фермы, и в «прибыли за 30 дней» его не
 * было вовсе: остаток пополнялся, а денег это не касалось. Транзакции во
 * всём бэкенде создавались ровно в двух местах — вручную и по ветеринарной
 * записи.
 *
 * Расход при этом не должен появляться всегда: «добавил» значит и «закупил
 * мешок», и «пересчитал, оказалось больше». Отличить одно от другого по
 * числу нельзя — поэтому спрашиваем стоимость, и она необязательна.
 */
describe('Закупка корма в книге расходов', () => {
  let token;
  let feedId;

  const auth = () => ({ Authorization: `Bearer ${token}` });

  const expenses = async () => {
    const res = await request(app)
      .get('/api/v1/transactions')
      .query({ limit: 100 })
      .set(auth());
    return res.body.data.items.filter((t) => t.category === 'feed');
  };

  const adjust = (body) =>
    request(app).post(`/api/v1/feeds/${feedId}/adjust-stock`).set(auth()).send(body);

  beforeAll(async () => {
    await syncTestDb();

    const owner = await registerFarm(app, {
      email: 'feed_expense_owner@example.com',
      full_name: 'Владелец'
    });
    token = owner.accessToken;

    const feed = await request(app)
      .post('/api/v1/feeds')
      .set(auth())
      .send({
        name: 'Комбикорм',
        type: 'pellets',
        unit: 'kg',
        current_stock: 10,
        min_stock: 5
      });
    feedId = feed.body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  it('пополнение со стоимостью заводит расход', async () => {
    const res = await adjust({ quantity: 50, operation: 'add', cost: 450 });
    expect(res.status).toBe(200);

    const rows = await expenses();
    expect(rows).toHaveLength(1);
    expect(Number(rows[0].amount)).toBe(450);
    expect(rows[0].type).toBe('expense');
    // Из описания должно быть видно, за что заплатили, — иначе в книге
    // стоит безымянная строка.
    expect(rows[0].description).toContain('Комбикорм');
  });

  it('пересчёт без стоимости расхода не создаёт', async () => {
    await adjust({ quantity: 3, operation: 'add' });

    expect(await expenses()).toHaveLength(1);
  });

  it('списание со склада расходом не считается', async () => {
    // Скормили — деньги потратили при покупке, а не сейчас.
    await adjust({ quantity: 5, operation: 'subtract', cost: 100 });

    expect(await expenses()).toHaveLength(1);
  });
});
