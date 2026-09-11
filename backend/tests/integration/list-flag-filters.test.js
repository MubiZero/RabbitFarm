const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');

/**
 * Флаговые фильтры списков ломались одинаково и тихо: Joi приводит `'true'`
 * к булеву, а код сравнивал значение со строкой — условие не срабатывало
 * никогда. Чип в интерфейсе загорался, выборка не менялась, ошибок не было.
 *
 * Ошибку однажды нашли и починили в клетках, но применили к случаю, а не к
 * классу: те же сравнения остались в задачах, кормах и лечении. Поэтому
 * проверяется не код ответа, а состав выборки — только он показывает, что
 * фильтр действительно фильтрует.
 */
describe('Флаговые фильтры списков', () => {
  let accessToken;

  const auth = (req) => req.set('Authorization', `Bearer ${accessToken}`);
  const names = (res) => res.body.data.items.map((item) => item.name);

  beforeAll(async () => {
    await syncTestDb();

    const registered = await registerFarm(app, {
        email: 'flagfilters@example.com',
        full_name: 'Flag Filters Owner'
      });
    accessToken = registered.accessToken;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('Корма: «мало на складе»', () => {
    beforeAll(async () => {
      await auth(request(app).post('/api/v1/feeds')).send({
        name: 'Кончается',
        type: 'pellets',
        unit: 'kg',
        current_stock: 5,
        min_stock: 50
      });
      await auth(request(app).post('/api/v1/feeds')).send({
        name: 'Хватает',
        type: 'hay',
        unit: 'kg',
        current_stock: 200,
        min_stock: 50
      });
    });

    it('оставляет только то, чего мало', async () => {
      const res = await auth(
        request(app).get('/api/v1/feeds').query({ low_stock: true, limit: 100 })
      );

      expect(res.status).toBe(200);
      expect(names(res)).toEqual(['Кончается']);
    });

    it('без флага отдаёт всё', async () => {
      const res = await auth(
        request(app).get('/api/v1/feeds').query({ limit: 100 })
      );

      expect(names(res).sort()).toEqual(['Кончается', 'Хватает']);
    });

    it('флаг, выключенный явно, ничего не отсекает', async () => {
      const res = await auth(
        request(app).get('/api/v1/feeds').query({ low_stock: false, limit: 100 })
      );

      expect(names(res).sort()).toEqual(['Кончается', 'Хватает']);
    });
  });

  describe('Лечение: «текущие»', () => {
    let rabbitId;

    beforeAll(async () => {
      const breed = await auth(request(app).post('/api/v1/breeds')).send({
        name: 'Порода для лечения'
      });
      const rabbit = await auth(request(app).post('/api/v1/rabbits')).send({
        tag_id: 'MED-001',
        name: 'Пациент',
        breed_id: breed.body.data.id,
        sex: 'female',
        birth_date: '2025-01-01',
        purpose: 'breeding'
      });
      rabbitId = rabbit.body.data.id;

      await auth(request(app).post('/api/v1/medical-records')).send({
        rabbit_id: rabbitId,
        symptoms: 'Лечится сейчас',
        started_at: '2026-01-10',
        outcome: 'ongoing'
      });
      await auth(request(app).post('/api/v1/medical-records')).send({
        rabbit_id: rabbitId,
        symptoms: 'Уже выздоровел',
        started_at: '2026-01-01',
        outcome: 'recovered'
      });
    });

    const symptoms = (res) =>
      res.body.data.items.map((item) => item.symptoms).sort();

    it('оставляет только незакрытые лечения', async () => {
      const res = await auth(
        request(app)
          .get('/api/v1/medical-records')
          .query({ ongoing: true, limit: 100 })
      );

      expect(res.status).toBe(200);
      expect(symptoms(res)).toEqual(['Лечится сейчас']);
    });

    it('без флага отдаёт и закрытые', async () => {
      const res = await auth(
        request(app).get('/api/v1/medical-records').query({ limit: 100 })
      );

      expect(symptoms(res)).toEqual(['Лечится сейчас', 'Уже выздоровел']);
    });
  });
});
