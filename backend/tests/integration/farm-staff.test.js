const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { User } = require('../../src/models');

/**
 * Работник фермы видит хозяйство владельца, а не собственное пустое,
 * и при этом ферма остаётся закрытой для посторонних.
 */
describe('Ферма и работники', () => {
  let ownerToken;
  let workerToken;
  let managerToken;
  let strangerToken;
  let rabbitId;
  let breedId;

  beforeAll(async () => {
    await syncTestDb();

    const owner = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'farm_owner@example.com', password: 'Password123!', full_name: 'Владелец' });
    ownerToken = owner.body.data.access_token;

    // Работника пока заводим напрямую: приглашений ещё нет.
    await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'farm_worker@example.com', password: 'Password123!', full_name: 'Работник' });
    await User.update(
      { farm_id: owner.body.data.user.farm_id, role: 'worker' },
      { where: { email: 'farm_worker@example.com' } }
    );
    const workerLogin = await request(app)
      .post('/api/v1/auth/login')
      .send({ email: 'farm_worker@example.com', password: 'Password123!' });
    workerToken = workerLogin.body.data.access_token;

    // Менеджер той же фермы: ему разрешено вести поголовье.
    await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'farm_manager@example.com', password: 'Password123!', full_name: 'Менеджер' });
    await User.update(
      { farm_id: owner.body.data.user.farm_id, role: 'manager' },
      { where: { email: 'farm_manager@example.com' } }
    );
    const managerLogin = await request(app)
      .post('/api/v1/auth/login')
      .send({ email: 'farm_manager@example.com', password: 'Password123!' });
    managerToken = managerLogin.body.data.access_token;

    // Посторонний владелец собственной фермы.
    const stranger = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'other_farm@example.com', password: 'Password123!', full_name: 'Сосед' });
    strangerToken = stranger.body.data.access_token;

    const breed = await request(app)
      .post('/api/v1/breeds')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ name: 'Порода фермы' });
    breedId = breed.body.data.id;

    const rabbit = await request(app)
      .post('/api/v1/rabbits')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ name: 'Белка', breed_id: breedId, sex: 'female', birth_date: '2026-01-10' });
    rabbitId = rabbit.body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  it('владелец видит своего кролика', async () => {
    const res = await request(app)
      .get(`/api/v1/rabbits/${rabbitId}`)
      .set('Authorization', `Bearer ${ownerToken}`);

    expect(res.status).toBe(200);
  });

  it('работник видит кролика своей фермы', async () => {
    const res = await request(app)
      .get(`/api/v1/rabbits/${rabbitId}`)
      .set('Authorization', `Bearer ${workerToken}`);

    expect(res.status).toBe(200);
    expect(res.body.data.name).toBe('Белка');
  });

  it('работник видит поголовье фермы в списке', async () => {
    const res = await request(app)
      .get('/api/v1/rabbits')
      .set('Authorization', `Bearer ${workerToken}`);

    expect(res.status).toBe(200);
    const items = res.body.data.items || res.body.data;
    expect(items.map(r => r.name)).toContain('Белка');
  });

  it('работнику не разрешено заводить поголовье', async () => {
    const res = await request(app)
      .post('/api/v1/rabbits')
      .set('Authorization', `Bearer ${workerToken}`)
      .send({ name: 'Не должна появиться', breed_id: breedId, sex: 'female', birth_date: '2026-02-01' });

    expect(res.status).toBe(403);
  });

  it('запись менеджера попадает в ферму владельца', async () => {
    const created = await request(app)
      .post('/api/v1/rabbits')
      .set('Authorization', `Bearer ${managerToken}`)
      .send({ name: 'Стрелка', breed_id: breedId, sex: 'female', birth_date: '2026-02-01' });

    expect(created.status).toBe(201);

    // Владелец должен увидеть то, что внёс сотрудник.
    const list = await request(app)
      .get('/api/v1/rabbits')
      .set('Authorization', `Bearer ${ownerToken}`);
    const items = list.body.data.items || list.body.data;
    expect(items.map(r => r.name)).toContain('Стрелка');
  });

  it('чужая ферма кролика не видит', async () => {
    const res = await request(app)
      .get(`/api/v1/rabbits/${rabbitId}`)
      .set('Authorization', `Bearer ${strangerToken}`);

    expect(res.status).toBe(404);
  });

  describe('изоляция ферм на записях о здоровье', () => {
    let vaccinationId;

    beforeAll(async () => {
      const created = await request(app)
        .post('/api/v1/vaccinations')
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({
          rabbit_id: rabbitId,
          vaccine_name: 'ВГБК',
          vaccine_type: 'vhd',
          vaccination_date: '2026-03-01'
        });
      vaccinationId = created.body.data.id;
    });

    // Регрессия: правка вакцинации искала запись по одному идентификатору,
    // без фильтра по ферме — чужую историю прививок можно было переписать.
    it('сосед не может править вакцинацию чужой фермы', async () => {
      const res = await request(app)
        .put(`/api/v1/vaccinations/${vaccinationId}`)
        .set('Authorization', `Bearer ${strangerToken}`)
        .send({ vaccine_name: 'Подмена' });

      expect(res.status).toBe(404);

      const check = await request(app)
        .get(`/api/v1/vaccinations/${vaccinationId}`)
        .set('Authorization', `Bearer ${ownerToken}`);
      expect(check.body.data.vaccine_name).toBe('ВГБК');
    });

    it('владелец правит свою вакцинацию', async () => {
      const res = await request(app)
        .put(`/api/v1/vaccinations/${vaccinationId}`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ vaccine_name: 'ВГБК-2' });

      expect(res.status).toBe(200);
    });
  });

  describe('роли на финансах и складе', () => {
    let transactionId;

    beforeAll(async () => {
      const created = await request(app)
        .post('/api/v1/transactions')
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({
          type: 'expense',
          category: 'feed',
          amount: 1000,
          transaction_date: '2026-03-05'
        });
      transactionId = created.body.data.id;
    });

    // Регрессия: восемь роутеров не проверяли роль вообще, поэтому работник
    // не мог удалить кролика, но мог стереть финансовую запись.
    it('работнику не разрешено заводить расходы', async () => {
      const res = await request(app)
        .post('/api/v1/transactions')
        .set('Authorization', `Bearer ${workerToken}`)
        .send({ type: 'expense', category: 'feed', amount: 50, transaction_date: '2026-03-06' });

      expect(res.status).toBe(403);
    });

    // Записывать расходы работник не мог, а читать книгу целиком — мог:
    // выручка, закупочные цены и баланс хозяйства были открыты всем.
    it('работнику не видна книга доходов и расходов', async () => {
      const res = await request(app)
        .get('/api/v1/transactions')
        .set('Authorization', `Bearer ${workerToken}`);

      expect(res.status).toBe(403);
    });

    it('работнику не видна финансовая сводка', async () => {
      const res = await request(app)
        .get('/api/v1/transactions/statistics')
        .set('Authorization', `Bearer ${workerToken}`);

      expect(res.status).toBe(403);
    });

    it('управляющему книга открыта', async () => {
      const res = await request(app)
        .get('/api/v1/transactions')
        .set('Authorization', `Bearer ${managerToken}`);

      expect(res.status).toBe(200);
    });

    it('работнику не разрешено удалять финансовые записи', async () => {
      const res = await request(app)
        .delete(`/api/v1/transactions/${transactionId}`)
        .set('Authorization', `Bearer ${workerToken}`);

      expect(res.status).toBe(403);
    });

    it('работнику не разрешено удалять клетки', async () => {
      const cage = await request(app)
        .post('/api/v1/cages')
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ number: 'Ж1', type: 'single', capacity: 1 });

      const res = await request(app)
        .delete(`/api/v1/cages/${cage.body.data.id}`)
        .set('Authorization', `Bearer ${workerToken}`);

      expect(res.status).toBe(403);
    });

    it('владелец удаляет финансовую запись', async () => {
      const res = await request(app)
        .delete(`/api/v1/transactions/${transactionId}`)
        .set('Authorization', `Bearer ${ownerToken}`);

      expect(res.status).toBe(200);
    });
  });

  describe('исполнитель задачи', () => {
    // Регрессия: проверялось лишь существование пользователя, поэтому задачу
    // можно было назначить работнику соседней фермы — она появлялась в его
    // списке, а удалить её он не мог.
    it('нельзя назначить задачу на пользователя другой фермы', async () => {
      const stranger = await User.findOne({ where: { email: 'other_farm@example.com' } });

      const res = await request(app)
        .post('/api/v1/tasks')
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({
          title: 'Чужая задача',
          type: 'other',
          due_date: '2026-04-01',
          assigned_to: stranger.id
        });

      expect(res.status).toBe(404);
    });

    it('на работника своей фермы задача назначается', async () => {
      const worker = await User.findOne({ where: { email: 'farm_worker@example.com' } });

      const res = await request(app)
        .post('/api/v1/tasks')
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({
          title: 'Почистить клетки',
          type: 'cleaning',
          due_date: '2026-04-01',
          assigned_to: worker.id
        });

      expect(res.status).toBe(201);
    });
  });
});
