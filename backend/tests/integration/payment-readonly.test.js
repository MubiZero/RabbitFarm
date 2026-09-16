const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');
const { Farm } = require('../../src/models');

/**
 * Ферма с истёкшим тарифом должна иметь возможность заплатить.
 *
 * Сервер сам переводит такую ферму в режим чтения, а режим чтения режет все
 * не-GET запросы — и оплата попадала под тот же нож. Получался замкнутый
 * круг: приложение показывало кнопку «Оплатить», нажатие возвращало 403
 * «обратитесь в поддержку», а поддержка ничего не отвечает. Заплатить не мог
 * именно тот, от кого мы ждём денег.
 *
 * Проверяется не успех оплаты (банковский шлюз на стенде не настроен), а
 * ровно то, что было сломано: запрос не отбивается по статусу фермы.
 */
describe('Оплата фермой в режиме чтения', () => {
  let token;
  let farmId;

  const auth = () => ({ Authorization: `Bearer ${token}` });

  beforeAll(async () => {
    await syncTestDb();

    const owner = await registerFarm(app, {
      email: 'readonly_owner@example.com',
      full_name: 'Владелец'
    });
    token = owner.accessToken;
    farmId = owner.user.farm_id;

    await Farm.update({ status: 'read_only' }, { where: { id: farmId } });
  });

  afterAll(async () => {
    await closeTestDb();
  });

  it('обычная запись по-прежнему закрыта — режим чтения работает', async () => {
    const res = await request(app)
      .post('/api/v1/breeds')
      .set(auth())
      .send({ name: 'Порода в режиме чтения' });

    expect(res.status).toBe(403);
    expect(res.body.error?.code).toBe('FARM_READ_ONLY');
  });

  it('создание заказа на оплату сквозь режим чтения проходит', async () => {
    const res = await request(app).post('/api/v1/payments').set(auth()).send({});

    expect(res.body.error?.code).not.toBe('FARM_READ_ONLY');
    expect(res.status).not.toBe(403);
  });

  it('телефон может зарегистрироваться на пуши — ими и напоминают про оплату', async () => {
    const res = await request(app)
      .post('/api/v1/device-tokens')
      .set(auth())
      .send({ token: 'test-device-token-readonly', platform: 'android' });

    expect(res.body.error?.code).not.toBe('FARM_READ_ONLY');
    expect(res.status).not.toBe(403);
  });
});
