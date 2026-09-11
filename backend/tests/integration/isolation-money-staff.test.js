const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm, loginWithOtp } = require('./helpers/auth');
const { Invitation, User } = require('../../src/models');

/**
 * Изоляция ферм на деньгах, отчётах и персонале.
 *
 * Сервис многофермерный, но код долго исходил из того, что ферма одна, и
 * граница между хозяйствами ни разу не проверялась целиком. Здесь стоят две
 * фермы рядом и по каждому денежному и кадровому запросу проверяется и то,
 * что чужое не видно, и то, что своё видно целиком: у транзакции нет
 * колонки фермы — она опознаётся по автору, а автором бывает любой
 * работник, не только владелец.
 */
describe('Изоляция ферм: деньги, отчёты, персонал', () => {
  const today = new Date().toISOString().split('T')[0];
  const [year, month] = today.split('-');

  let alphaToken;
  let alphaId;
  let alphaFarmId;
  let alphaManagerToken;
  let alphaManagerId;
  let alphaWorkerToken;
  let betaToken;
  let betaFarmId;

  let alphaRabbitId;
  let betaRabbitId;
  let alphaIncomeId;
  let betaIncomeId;
  let alphaPendingInvitationId;

  const auth = (token) => ({ Authorization: `Bearer ${token}` });

  const createFarm = async (email) => {
    const res = await registerFarm(app, { email, full_name: email });
    return {
      token: res.accessToken,
      id: res.user.id,
      farmId: res.user.farm_id
    };
  };

  /**
   * Пригласить человека в ферму и сразу завести его входом по коду:
   * приглашение активируется тем же экраном входа, отдельной формы нет.
   */
  const hire = async (ownerToken, email, role) => {
    await request(app)
      .post('/api/v1/staff/invitations')
      .set(auth(ownerToken))
      .send({ email, full_name: email, role });

    await request(app).post('/api/v1/auth/otp/request').send({ email });
    const joined = await loginWithOtp(app, { email });

    return { token: joined.access_token, id: joined.user.id };
  };

  const addMoney = async (token, payload) => {
    const res = await request(app)
      .post('/api/v1/transactions')
      .set(auth(token))
      .send({ transaction_date: today, ...payload });
    return res.body.data.id;
  };

  const createRabbit = async (token, name) => {
    const breed = await request(app)
      .post('/api/v1/breeds')
      .set(auth(token))
      .send({ name: `Порода ${name}` });

    const rabbit = await request(app)
      .post('/api/v1/rabbits')
      .set(auth(token))
      .send({ name, breed_id: breed.body.data.id, sex: 'female', birth_date: '2026-01-10' });

    return rabbit.body.data.id;
  };

  beforeAll(async () => {
    await syncTestDb();

    const alpha = await createFarm('alpha_owner@example.com');
    alphaToken = alpha.token;
    alphaId = alpha.id;
    alphaFarmId = alpha.farmId;

    const beta = await createFarm('beta_owner@example.com');
    betaToken = beta.token;
    betaFarmId = beta.farmId;

    const alphaManager = await hire(alphaToken, 'alpha_manager@example.com', 'manager');
    alphaManagerToken = alphaManager.token;
    alphaManagerId = alphaManager.id;

    const alphaWorker = await hire(alphaToken, 'alpha_worker@example.com', 'worker');
    alphaWorkerToken = alphaWorker.token;

    alphaRabbitId = await createRabbit(alphaToken, 'Белка');
    betaRabbitId = await createRabbit(betaToken, 'Стрелка');

    // Деньги фермы «Альфа»: 1500 + 300 дохода, 500 + 250 расхода.
    alphaIncomeId = await addMoney(alphaToken, {
      type: 'income', category: 'sale_meat', amount: 1500, description: 'Мясо'
    });
    await addMoney(alphaToken, {
      type: 'expense', category: 'feed', amount: 500, rabbit_id: alphaRabbitId
    });
    // Операция управляющего — та же книга фермы, что и операция владельца.
    await addMoney(alphaManagerToken, {
      type: 'income', category: 'other', amount: 300, description: 'Доход управляющего'
    });
    // Ветеринарный расход рождается автоматикой и записывается на того, кто
    // завёл лечение, — на управляющего, а не на владельца.
    await request(app)
      .post('/api/v1/medical-records')
      .set(auth(alphaManagerToken))
      .send({ rabbit_id: alphaRabbitId, symptoms: 'Отит', started_at: today, cost: 250 });

    // Деньги фермы «Бета»: только 700 дохода.
    betaIncomeId = await addMoney(betaToken, {
      type: 'income', category: 'sale_rabbit', amount: 700, description: 'Продажа'
    });

    const pending = await request(app)
      .post('/api/v1/staff/invitations')
      .set(auth(alphaToken))
      .send({ email: 'alpha_future@example.com', full_name: 'Будущий работник', role: 'worker' });
    alphaPendingInvitationId = pending.body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('книга операций', () => {
    it('в списке фермы нет чужих операций и есть все свои', async () => {
      const res = await request(app)
        .get('/api/v1/transactions')
        .query({ limit: 100 })
        .set(auth(alphaToken));

      const amounts = res.body.data.items.map((t) => parseFloat(t.amount)).sort((a, b) => a - b);

      expect(res.status).toBe(200);
      // Регрессия: операции работников в книгу владельца не попадали —
      // ни доход управляющего, ни автоматический ветеринарный расход.
      expect(amounts).toEqual([250, 300, 500, 1500]);
      expect(amounts).not.toContain(700);
    });

    it('работник фермы видит книгу так же, как владелец', async () => {
      const res = await request(app)
        .get('/api/v1/transactions')
        .query({ limit: 100 })
        .set(auth(alphaManagerToken));

      const amounts = res.body.data.items.map((t) => parseFloat(t.amount)).sort((a, b) => a - b);

      expect(res.status).toBe(200);
      expect(amounts).toEqual([250, 300, 500, 1500]);
    });

    it('книга остаётся закрытой для работника', async () => {
      const res = await request(app)
        .get('/api/v1/transactions')
        .set(auth(alphaWorkerToken));

      expect(res.status).toBe(403);
    });

    it('в списке соседней фермы только её собственные операции', async () => {
      const res = await request(app)
        .get('/api/v1/transactions')
        .query({ limit: 100 })
        .set(auth(betaToken));

      const amounts = res.body.data.items.map((t) => parseFloat(t.amount));

      expect(amounts).toEqual([700]);
    });

    it('чужая операция по id не находится', async () => {
      const res = await request(app)
        .get(`/api/v1/transactions/${alphaIncomeId}`)
        .set(auth(betaToken));

      expect(res.status).toBe(404);
    });

    it('чужую операцию нельзя исправить, и она остаётся прежней', async () => {
      const res = await request(app)
        .put(`/api/v1/transactions/${alphaIncomeId}`)
        .set(auth(betaToken))
        .send({ amount: 1 });

      expect(res.status).toBe(404);

      const original = await request(app)
        .get(`/api/v1/transactions/${alphaIncomeId}`)
        .set(auth(alphaToken));
      expect(parseFloat(original.body.data.amount)).toBe(1500);
    });

    it('чужую операцию нельзя удалить, и она остаётся на месте', async () => {
      const res = await request(app)
        .delete(`/api/v1/transactions/${betaIncomeId}`)
        .set(auth(alphaToken));

      expect(res.status).toBe(404);

      const original = await request(app)
        .get(`/api/v1/transactions/${betaIncomeId}`)
        .set(auth(betaToken));
      expect(original.status).toBe(200);
    });

    it('операцию нельзя привязать к кролику чужой фермы', async () => {
      const res = await request(app)
        .post('/api/v1/transactions')
        .set(auth(alphaToken))
        .send({
          type: 'expense',
          category: 'veterinary',
          amount: 10,
          transaction_date: today,
          rabbit_id: betaRabbitId
        });

      expect(res.status).toBe(404);
    });

    it('свою операцию нельзя перевесить на чужого кролика', async () => {
      const res = await request(app)
        .put(`/api/v1/transactions/${alphaIncomeId}`)
        .set(auth(alphaToken))
        .send({ rabbit_id: betaRabbitId });

      expect(res.status).toBe(404);
    });

    it('карточка чужого кролика не отдаёт ни операций, ни сумм', async () => {
      const res = await request(app)
        .get(`/api/v1/rabbits/${alphaRabbitId}/transactions`)
        .set(auth(betaToken));

      expect(res.status).toBe(404);
      expect(res.body.data).toBeUndefined();
    });

    it('карточка своего кролика показывает все операции фермы по нему', async () => {
      const res = await request(app)
        .get(`/api/v1/rabbits/${alphaRabbitId}/transactions`)
        .set(auth(alphaToken));

      expect(res.status).toBe(200);
      // Корм от владельца и ветеринарный расход от управляющего.
      expect(parseFloat(res.body.data.summary.total_expenses)).toBe(750);
    });
  });

  describe('суммы и группировки', () => {
    it('сводка фермы считает своих работников и не считает соседей', async () => {
      const res = await request(app)
        .get('/api/v1/transactions/statistics')
        .set(auth(alphaToken));

      expect(res.body.data.total_income).toBe('1800.00');
      expect(res.body.data.total_expenses).toBe('750.00');
      expect(res.body.data.net_profit).toBe('1050.00');
      expect(res.body.data.total_transactions).toBe(4);
    });

    it('сводка соседней фермы состоит только из её денег', async () => {
      const res = await request(app)
        .get('/api/v1/transactions/statistics')
        .set(auth(betaToken));

      expect(res.body.data.total_income).toBe('700.00');
      expect(res.body.data.total_expenses).toBe('0.00');
      expect(res.body.data.total_transactions).toBe(1);
    });

    it('разбивка по категориям не смешивает фермы', async () => {
      const res = await request(app)
        .get('/api/v1/transactions/statistics')
        .set(auth(betaToken));

      const categories = res.body.data.income_by_category.map((row) => row.category);

      expect(categories).toEqual(['sale_rabbit']);
      expect(categories).not.toContain('sale_meat');
    });

    it('месячный отчёт фермы не включает чужой месяц', async () => {
      const alpha = await request(app)
        .get('/api/v1/transactions/monthly-report')
        .query({ year, month })
        .set(auth(alphaToken));

      const beta = await request(app)
        .get('/api/v1/transactions/monthly-report')
        .query({ year, month })
        .set(auth(betaToken));

      expect(alpha.body.data.summary.total_income).toBe('1800.00');
      expect(beta.body.data.summary.total_income).toBe('700.00');
      expect(beta.body.data.summary.transaction_count).toBe(1);
    });
  });

  describe('отчёты', () => {
    it('сводка на дашборде считает деньги всей фермы и только своей', async () => {
      const alpha = await request(app)
        .get('/api/v1/reports/dashboard')
        .set(auth(alphaToken));

      const beta = await request(app)
        .get('/api/v1/reports/dashboard')
        .set(auth(betaToken));

      // Регрессия: дашборд считал только операции владельца, поэтому
      // расходился с финансовым отчётом на всё, что внесли работники.
      expect(alpha.body.data.finance.income30days).toBe('1800.00');
      expect(alpha.body.data.finance.expenses30days).toBe('750.00');
      expect(beta.body.data.finance.income30days).toBe('700.00');
      expect(beta.body.data.finance.expenses30days).toBe('0.00');
    });

    it('дашборд не показывает чужое поголовье', async () => {
      const beta = await request(app)
        .get('/api/v1/reports/dashboard')
        .set(auth(betaToken));

      expect(beta.body.data.rabbits.total).toBe(1);
    });

    it('финансовый отчёт не смешивает фермы', async () => {
      const alpha = await request(app)
        .get('/api/v1/reports/financial')
        .set(auth(alphaToken));

      const beta = await request(app)
        .get('/api/v1/reports/financial')
        .set(auth(betaToken));

      expect(alpha.body.data.summary.total_income).toBe('1800.00');
      expect(beta.body.data.summary.total_income).toBe('700.00');
      expect(beta.body.data.summary.total_expenses).toBe('0.00');
    });

    it('финансовый отчёт по категориям не смешивает фермы', async () => {
      const res = await request(app)
        .get('/api/v1/reports/financial')
        .query({ groupBy: 'by_category' })
        .set(auth(betaToken));

      expect(res.body.data.grouped.map((row) => row.category)).toEqual(['sale_rabbit']);
    });

    it('отчёт по ферме не смешивает деньги и здоровье соседей', async () => {
      const alpha = await request(app)
        .get('/api/v1/reports/farm')
        .set(auth(alphaToken));

      const beta = await request(app)
        .get('/api/v1/reports/farm')
        .set(auth(betaToken));

      expect(alpha.body.data.financial.summary.total_income).toBe(1800);
      expect(beta.body.data.financial.summary.total_income).toBe(700);
      expect(beta.body.data.financial.summary.total_expenses).toBe(0);
      // Лечение завела «Альфа» — в отчёте соседа его быть не должно.
      expect(beta.body.data.health.medical_records).toBe(0);
      expect(beta.body.data.population.total_rabbits).toBe(1);
    });

    it('отчёт по здоровью не показывает чужие записи', async () => {
      const res = await request(app)
        .get('/api/v1/reports/health')
        .set(auth(betaToken));

      expect(res.body.data.medical_records.by_outcome).toEqual([]);
      expect(res.body.data.vaccinations.by_type).toEqual([]);
    });
  });

  describe('приглашения', () => {
    it('приглашения соседней фермы не видны', async () => {
      const res = await request(app)
        .get('/api/v1/staff/invitations')
        .set(auth(betaToken));

      expect(res.body.data.map((i) => i.email)).not.toContain('alpha_future@example.com');
    });

    it('чужое приглашение нельзя отозвать, и оно остаётся действующим', async () => {
      const res = await request(app)
        .delete(`/api/v1/staff/invitations/${alphaPendingInvitationId}`)
        .set(auth(betaToken));

      expect(res.status).toBe(404);

      const stillThere = await request(app)
        .get('/api/v1/staff/invitations')
        .set(auth(alphaToken));
      expect(stillThere.body.data.map((i) => i.id)).toContain(alphaPendingInvitationId);
    });

    it('приглашение срабатывает один раз — второй вход даёт того же работника', async () => {
      await request(app)
        .post('/api/v1/staff/invitations')
        .set(auth(betaToken))
        .send({ email: 'beta_worker@example.com', full_name: 'Работник Беты', role: 'worker' });

      await request(app).post('/api/v1/auth/otp/request').send({ email: 'beta_worker@example.com' });
      const first = await loginWithOtp(app, { email: 'beta_worker@example.com' });
      expect(first.user.farm_id).toBe(betaFarmId);

      await request(app).post('/api/v1/auth/otp/request').send({ email: 'beta_worker@example.com' });
      const second = await loginWithOtp(app, { email: 'beta_worker@example.com' });

      // Повторный вход — это вход того же человека, а не второй работник по
      // тому же приглашению: иначе лимитом по тарифу можно было бы пренебречь.
      expect(second.user.id).toBe(first.user.id);
      expect(
        await User.count({ where: { email: 'beta_worker@example.com' }, tenantScope: 'all' })
      ).toBe(1);
    });

    it('просроченное приглашение в ферму не пускает', async () => {
      const invitation = await request(app)
        .post('/api/v1/staff/invitations')
        .set(auth(betaToken))
        .send({ email: 'beta_late@example.com', full_name: 'Опоздавший', role: 'worker' });

      await Invitation.update(
        { expires_at: new Date('2020-01-01T00:00:00.000Z') },
        { where: { id: invitation.body.data.id }, tenantScope: 'all' }
      );

      // Кода на просроченное приглашение сервис не выпускает вовсе, поэтому
      // и войти нечем: любой код отвергается.
      await request(app).post('/api/v1/auth/otp/request').send({ email: 'beta_late@example.com' });
      const res = await request(app)
        .post('/api/v1/auth/otp/verify')
        .send({ email: 'beta_late@example.com', code: '123456' });

      expect(res.status).toBe(400);
      expect(
        await User.count({ where: { email: 'beta_late@example.com' }, tenantScope: 'all' })
      ).toBe(0);
    });

    it('непрошеный контакт не заводит работника и не выдаёт, что именно не так', async () => {
      await request(app).post('/api/v1/auth/otp/request').send({ email: 'stranger@example.com' });
      const res = await request(app)
        .post('/api/v1/auth/otp/verify')
        .send({ email: 'stranger@example.com', code: '123456' });

      expect(res.status).toBe(400);
      // Тот же код ошибки, что и у просто неверного кода: по ответу нельзя
      // понять, звали ли этот контакт хоть в какую-то ферму.
      expect(res.body.error.code).toBe('OTP_INVALID');
      expect(
        await User.count({ where: { email: 'stranger@example.com' }, tenantScope: 'all' })
      ).toBe(0);
    });

    it('приглашение приводит ровно в ту ферму, которая его выписала', async () => {
      await request(app)
        .post('/api/v1/staff/invitations')
        .set(auth(alphaToken))
        .send({ email: 'alpha_second@example.com', full_name: 'Новичок Альфы', role: 'worker' });

      await request(app).post('/api/v1/auth/otp/request').send({ email: 'alpha_second@example.com' });
      const joined = await loginWithOtp(app, { email: 'alpha_second@example.com' });

      expect(joined.user.farm_id).toBe(alphaFarmId);
      expect(joined.user.farm_id).not.toBe(betaFarmId);
    });
  });

  describe('персонал', () => {
    it('в составе фермы нет людей соседней фермы', async () => {
      const res = await request(app)
        .get('/api/v1/staff')
        .set(auth(betaToken));

      const emails = res.body.data.map((m) => m.email);

      expect(emails).toContain('beta_owner@example.com');
      expect(emails).not.toContain('alpha_manager@example.com');
      expect(emails).not.toContain('alpha_owner@example.com');
    });

    it('чужому работнику нельзя сменить роль', async () => {
      const res = await request(app)
        .patch(`/api/v1/staff/${alphaManagerId}`)
        .set(auth(betaToken))
        .send({ role: 'worker' });

      expect(res.status).toBe(404);

      const staff = await request(app)
        .get('/api/v1/staff')
        .set(auth(alphaToken));
      const manager = staff.body.data.find((m) => m.id === alphaManagerId);
      expect(manager.role).toBe('manager');
    });

    it('чужому работнику нельзя отключить доступ', async () => {
      const res = await request(app)
        .patch(`/api/v1/staff/${alphaManagerId}`)
        .set(auth(betaToken))
        .send({ is_active: false });

      expect(res.status).toBe(404);

      const stillWorking = await request(app)
        .get('/api/v1/transactions')
        .set(auth(alphaManagerToken));
      expect(stillWorking.status).toBe(200);
    });

    it('владельца соседней фермы не видно и не тронуть', async () => {
      const res = await request(app)
        .patch(`/api/v1/staff/${alphaId}`)
        .set(auth(betaToken))
        .send({ is_active: false });

      expect(res.status).toBe(404);
    });

    it('владельца нельзя понизить даже в своей ферме', async () => {
      const res = await request(app)
        .patch(`/api/v1/staff/${alphaId}`)
        .set(auth(alphaToken))
        .send({ role: 'worker' });

      // Ферма без хозяина не должна получаться ни одним запросом.
      expect(res.status).toBe(404);
    });

    it('работника нельзя произвести во владельцы', async () => {
      const res = await request(app)
        .patch(`/api/v1/staff/${alphaManagerId}`)
        .set(auth(alphaToken))
        .send({ role: 'owner' });

      expect(res.status).toBe(422);
    });

    it('управляющий не может менять состав фермы', async () => {
      const res = await request(app)
        .patch(`/api/v1/staff/${alphaManagerId}`)
        .set(auth(alphaManagerToken))
        .send({ role: 'worker' });

      expect(res.status).toBe(403);
    });
  });
});
