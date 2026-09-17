const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm, login } = require('./helpers/auth');
const { User, Farm } = require('../../src/models');

/**
 * Удаление своей учётной записи — требование обоих магазинов приложений:
 * завёл учётку в приложении, значит и удалить её должен из приложения, без
 * писем в поддержку. Пути к этому не было вовсе.
 *
 * Проверяется не «ручка отвечает 200», а последствия: закрылся ли доступ,
 * остались ли данные хозяйства при уходе работника и переживает ли удаление
 * чужая ферма.
 */
describe('Удаление своей учётной записи', () => {
  const auth = (token) => ({ Authorization: `Bearer ${token}` });

  const addMember = async (email, fullName, farmId, role = 'worker') => {
    await request(app)
      .post('/api/v1/auth/register')
      .send({ email, full_name: fullName });
    await User.update({ farm_id: farmId, role }, { where: { email } });
    const session = await login(app, { email });
    return session.accessToken;
  };

  beforeAll(async () => {
    await syncTestDb();
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('работник удаляет себя', () => {
    let ownerToken;
    let workerToken;
    let farmId;
    let recordId;

    beforeAll(async () => {
      const owner = await registerFarm(app, {
        email: 'del_owner1@example.com',
        full_name: 'Владелец',
        farm_name: 'Зелёная поляна'
      });
      ownerToken = owner.accessToken;
      farmId = owner.user.farm_id;

      workerToken = await addMember(
        'del_worker@example.com',
        'Сафар',
        farmId
      );

      const cage = await request(app)
        .post('/api/v1/cages')
        .set(auth(ownerToken))
        .send({ number: 'A-1', capacity: 5 });

      const feed = await request(app)
        .post('/api/v1/feeds')
        .set(auth(ownerToken))
        .send({
          name: 'Комбикорм',
          type: 'pellets',
          unit: 'kg',
          current_stock: 100,
          cost_per_unit: 4
        });

      const record = await request(app)
        .post('/api/v1/feeding-records')
        .set(auth(workerToken))
        .send({
          feed_id: feed.body.data.id,
          cage_id: cage.body.data.id,
          quantity: 2,
          fed_at: '2026-09-14T08:00:00.000Z'
        });
      recordId = record.body.data.id;
    });

    it('учётка исчезает, и войти по её токену больше нельзя', async () => {
      const res = await request(app)
        .delete('/api/v1/auth/account')
        .set(auth(workerToken))
        .send({});

      expect(res.status).toBe(200);
      expect(res.body.data.scope).toBe('user');

      const gone = await User.findOne({
        where: { email: 'del_worker@example.com' }
      });
      expect(gone).toBeNull();

      const after = await request(app)
        .get('/api/v1/auth/me')
        .set(auth(workerToken));
      expect(after.status).toBe(401);
    });

    it('записи остаются хозяйству — это его данные, а не работника', async () => {
      const res = await request(app)
        .get(`/api/v1/feeding-records/${recordId}`)
        .set(auth(ownerToken));

      expect(res.status).toBe(200);
      // Автор погас вместе с учёткой, сама запись на месте.
      expect(res.body.data.fed_by).toBeNull();
    });

    it('в журнале остаётся имя ушедшего', async () => {
      const res = await request(app)
        .get('/api/v1/staff/audit')
        .query({ scope: 'staff', limit: 50 })
        .set(auth(ownerToken));

      const row = res.body.data.items.find(
        (item) => item.action === 'staff.self_deleted'
      );

      expect(row).toBeDefined();
      // Ссылки на человека гаснут вместе с ним, поэтому имя записано в самой
      // строке журнала — иначе владелец увидел бы «кто-то ушёл».
      expect(row.before.full_name).toBe('Сафар');
    });
  });

  describe('владелец удаляет хозяйство', () => {
    let ownerToken;
    let workerToken;
    let farmId;

    beforeAll(async () => {
      const owner = await registerFarm(app, {
        email: 'del_owner2@example.com',
        full_name: 'Хозяин',
        farm_name: 'Солнечный склон'
      });
      ownerToken = owner.accessToken;
      farmId = owner.user.farm_id;

      workerToken = await addMember(
        'del_worker2@example.com',
        'Дилноза',
        farmId,
        'manager'
      );
    });

    it('без точного названия хозяйство остаётся на месте', async () => {
      const res = await request(app)
        .delete('/api/v1/auth/account')
        .set(auth(ownerToken))
        .send({ confirm_name: 'солнечный склон' });

      expect(res.status).toBe(400);
      expect(res.body.error.code).toBe('CONFIRM_NAME_MISMATCH');

      const farm = await Farm.findByPk(farmId);
      expect(farm.deleted_at).toBeNull();
    });

    it('с точным названием доступ закрывается сразу, а данные ждут зачистки', async () => {
      const res = await request(app)
        .delete('/api/v1/auth/account')
        .set(auth(ownerToken))
        .send({ confirm_name: 'Солнечный склон' });

      expect(res.status).toBe(200);
      expect(res.body.data.scope).toBe('farm');
      // Тридцать дней до физической зачистки — окно на «удалил сгоряча».
      const days = Math.round(
        (new Date(res.body.data.purge_at) - new Date(res.body.data.deleted_at)) /
          (24 * 60 * 60 * 1000)
      );
      expect(days).toBe(30);

      const farm = await Farm.findByPk(farmId);
      expect(farm.deleted_at).not.toBeNull();
    });

    it('работник той же фермы теряет доступ вместе с ней', async () => {
      const res = await request(app)
        .get('/api/v1/rabbits')
        .set(auth(workerToken));

      expect(res.status).toBe(403);
      expect(res.body.error.code).toBe('FARM_DELETED');
    });

    it('чужое хозяйство продолжает работать', async () => {
      const stranger = await registerFarm(app, {
        email: 'del_stranger@example.com',
        full_name: 'Сосед'
      });

      const res = await request(app)
        .get('/api/v1/rabbits')
        .set(auth(stranger.accessToken));

      expect(res.status).toBe(200);
    });
  });
});
