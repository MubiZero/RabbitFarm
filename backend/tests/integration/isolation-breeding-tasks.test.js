const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { User } = require('../../src/models');

/**
 * Ферм в сервисе много, а к ферме эти три ресурса привязаны по-разному:
 * у случки есть своя колонка user_id, у окрола фермы нет вовсе — только через
 * мать, у задачи нет тоже — только через created_by/assigned_to. Разная
 * привязка и есть источник дыр: где-то фильтр стоит в where, где-то держится
 * на одном include, и достаточно поставить ему required: false, чтобы соседнее
 * хозяйство стало видно насквозь.
 *
 * Поэтому здесь всё проверяется двумя настоящими фермами: у каждой свои
 * кролики, клетки, случки, окролы и задачи. Проверяется не только код ответа,
 * но и состав списков и целость чужой записи после попытки правки — иначе
 * «404» может означать «удалил и не нашёл».
 */
describe('Изоляция ферм: случки, окролы и задачи', () => {
  const farmA = {};
  const farmB = {};
  let workerAToken;
  let workerAId;

  /** Дата в прошлом или будущем относительно дня прогона: 'YYYY-MM-DD'. */
  const daysFromNow = (days) => {
    const date = new Date();
    date.setDate(date.getDate() + days);
    return date.toISOString().split('T')[0];
  };

  /** Токена нет только у регистрации и входа — там заголовок не нужен. */
  const withAuth = (req, token) => (token ? req.set('Authorization', `Bearer ${token}`) : req);

  const post = (url, token, body) =>
    withAuth(request(app).post(url), token).send(body);

  const put = (url, token, body) =>
    withAuth(request(app).put(url), token).send(body);

  const get = (url, token, query = {}) =>
    withAuth(request(app).get(url), token).query(query);

  const del = (url, token) => withAuth(request(app).delete(url), token);

  /** Сколько кроликов на ферме — чтобы видеть, не появились ли лишние. */
  const rabbitCount = async (token) => {
    const res = await get('/api/v1/rabbits', token, { limit: 100 });
    return res.body.data.items.length;
  };

  const ids = (res) => res.body.data.items.map((item) => item.id);
  const titles = (res) => res.body.data.items.map((item) => item.title);

  /** Ферма целиком: порода, кролики, клетка, случка, окрол и задача. */
  const setupFarm = async (farm, { email, suffix }) => {
    const registered = await post('/api/v1/auth/register', undefined, {
      email,
      password: 'Password123!',
      full_name: `Владелец ${suffix}`
    });
    farm.token = registered.body.data.access_token;
    farm.ownerId = registered.body.data.user.id;

    const breed = await post('/api/v1/breeds', farm.token, { name: `Порода ${suffix}` });
    farm.breedId = breed.body.data.id;

    const male = await post('/api/v1/rabbits', farm.token, {
      name: `Самец ${suffix}`,
      breed_id: farm.breedId,
      sex: 'male',
      birth_date: daysFromNow(-400)
    });
    farm.maleId = male.body.data.id;

    const female = await post('/api/v1/rabbits', farm.token, {
      name: `Самка ${suffix}`,
      breed_id: farm.breedId,
      sex: 'female',
      birth_date: daysFromNow(-400)
    });
    farm.femaleId = female.body.data.id;
    farm.femaleName = `Самка ${suffix}`;

    const cage = await post('/api/v1/cages', farm.token, {
      number: `Клетка ${suffix}`,
      capacity: 10
    });
    farm.cageId = cage.body.data.id;

    const breeding = await post('/api/v1/breeding', farm.token, {
      male_id: farm.maleId,
      female_id: farm.femaleId,
      breeding_date: daysFromNow(-30)
    });
    farm.breedingId = breeding.body.data.id;

    const birth = await post('/api/v1/births', farm.token, {
      mother_id: farm.femaleId,
      breeding_id: farm.breedingId,
      birth_date: daysFromNow(-10),
      kits_born_alive: 7,
      kits_born_dead: 1
    });
    farm.birthId = birth.body.data.id;

    const task = await post('/api/v1/tasks', farm.token, {
      title: `Задача ${suffix}`,
      type: 'feeding',
      priority: 'high',
      due_date: `${daysFromNow(2)}T10:00:00.000Z`
    });
    farm.taskId = task.body.data.id;
    farm.taskTitle = `Задача ${suffix}`;
  };

  beforeAll(async () => {
    await syncTestDb();

    await setupFarm(farmA, { email: 'iso_owner_a@example.com', suffix: 'А' });
    await setupFarm(farmB, { email: 'iso_owner_b@example.com', suffix: 'Б' });

    // У фермы А задач заведомо больше: если счётчик соседа подхватит чужое,
    // числа разойдутся, а не совпадут случайно.
    await post('/api/v1/tasks', farmA.token, {
      title: 'Вторая задача А',
      type: 'cleaning',
      priority: 'low',
      due_date: `${daysFromNow(3)}T10:00:00.000Z`
    });
    await post('/api/v1/breeding', farmA.token, {
      male_id: farmA.maleId,
      female_id: farmA.femaleId,
      breeding_date: daysFromNow(-3)
    });

    // Работник заводится напрямую: приглашение здесь не предмет проверки,
    // нужен лишь второй человек в составе фермы А.
    await post('/api/v1/auth/register', undefined, {
      email: 'iso_worker_a@example.com',
      password: 'Password123!',
      full_name: 'Работник А'
    });
    const worker = await User.findOne({ where: { email: 'iso_worker_a@example.com' } });
    workerAId = worker.id;
    await worker.update({ owner_id: farmA.ownerId, role: 'worker' });

    const workerLogin = await post('/api/v1/auth/login', undefined, {
      email: 'iso_worker_a@example.com',
      password: 'Password123!'
    });
    workerAToken = workerLogin.body.data.access_token;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('Случки', () => {
    it('в списке фермы видны свои случки и нет чужих', async () => {
      const own = await get('/api/v1/breeding', farmB.token, { limit: 100 });
      expect(own.status).toBe(200);
      expect(ids(own)).toContain(farmB.breedingId);
      expect(ids(own)).not.toContain(farmA.breedingId);
    });

    it('чужая случка по id не отдаётся', async () => {
      const res = await get(`/api/v1/breeding/${farmA.breedingId}`, farmB.token);

      expect(res.status).toBe(404);
    });

    it('чужую случку нельзя переписать', async () => {
      const res = await put(`/api/v1/breeding/${farmA.breedingId}`, farmB.token, {
        status: 'cancelled',
        notes: 'взломано'
      });

      expect(res.status).toBe(404);

      const intact = await get(`/api/v1/breeding/${farmA.breedingId}`, farmA.token);
      expect(intact.status).toBe(200);
      expect(intact.body.data.status).not.toBe('cancelled');
      expect(intact.body.data.notes).not.toBe('взломано');
    });

    it('чужую случку нельзя удалить', async () => {
      const res = await del(`/api/v1/breeding/${farmA.breedingId}`, farmB.token);

      expect(res.status).toBe(404);

      const intact = await get(`/api/v1/breeding/${farmA.breedingId}`, farmA.token);
      expect(intact.status).toBe(200);
    });

    it('нельзя завести случку на чужих кроликов', async () => {
      const res = await post('/api/v1/breeding', farmB.token, {
        male_id: farmA.maleId,
        female_id: farmA.femaleId,
        breeding_date: daysFromNow(-1)
      });

      expect(res.status).toBe(404);
    });

    it('нельзя подставить чужую самку в свою случку', async () => {
      const res = await put(`/api/v1/breeding/${farmB.breedingId}`, farmB.token, {
        female_id: farmA.femaleId
      });

      // Отказ важнее его кода: 400 «некорректный id» и 404 «не найдено»
      // одинаково не подтверждают существование чужого кролика.
      expect([400, 404]).toContain(res.status);

      const intact = await get(`/api/v1/breeding/${farmB.breedingId}`, farmB.token);
      expect(intact.body.data.female_id).toBe(farmB.femaleId);
    });

    it('статистика фермы считает только свои случки', async () => {
      const statsB = await get('/api/v1/breeding/statistics', farmB.token);
      const listB = await get('/api/v1/breeding', farmB.token, { limit: 100 });

      expect(statsB.status).toBe(200);
      expect(statsB.body.data.total).toBe(listB.body.data.items.length);
      // У фермы А случек больше — совпадение чисел означало бы общий счётчик.
      const statsA = await get('/api/v1/breeding/statistics', farmA.token);
      expect(statsA.body.data.total).toBeGreaterThan(statsB.body.data.total);
    });
  });

  describe('Окролы', () => {
    it('в списке фермы видны свои окролы и нет чужих', async () => {
      const own = await get('/api/v1/births', farmB.token, { limit: 100 });

      expect(own.status).toBe(200);
      expect(ids(own)).toContain(farmB.birthId);
      expect(ids(own)).not.toContain(farmA.birthId);
    });

    it('фильтр по чужой матери не открывает чужие окролы', async () => {
      const res = await get('/api/v1/births', farmB.token, { limit: 100, mother_id: farmA.femaleId });

      expect(res.status).toBe(200);
      expect(res.body.data.items).toHaveLength(0);
    });

    it('чужой окрол по id не отдаётся', async () => {
      const res = await get(`/api/v1/births/${farmA.birthId}`, farmB.token);

      expect(res.status).toBe(404);
    });

    it('чужой окрол нельзя переписать', async () => {
      const res = await put(`/api/v1/births/${farmA.birthId}`, farmB.token, {
        kits_born_alive: 30,
        notes: 'взломано'
      });

      expect(res.status).toBe(404);

      const intact = await get(`/api/v1/births/${farmA.birthId}`, farmA.token);
      expect(intact.status).toBe(200);
      expect(intact.body.data.kits_born_alive).toBe(7);
      expect(intact.body.data.notes).not.toBe('взломано');
    });

    it('чужой окрол нельзя удалить', async () => {
      const res = await del(`/api/v1/births/${farmA.birthId}`, farmB.token);

      expect(res.status).toBe(404);

      const intact = await get(`/api/v1/births/${farmA.birthId}`, farmA.token);
      expect(intact.status).toBe(200);
    });

    it('нельзя записать окрол на чужую самку', async () => {
      const res = await post('/api/v1/births', farmB.token, {
        mother_id: farmA.femaleId,
        birth_date: daysFromNow(-1),
        kits_born_alive: 5
      });

      expect(res.status).toBe(404);
    });

    it('нельзя записать окрол на чужую случку', async () => {
      const before = await get('/api/v1/births', farmB.token, { limit: 100 });

      const res = await post('/api/v1/births', farmB.token, {
        mother_id: farmB.femaleId,
        breeding_id: farmA.breedingId,
        birth_date: daysFromNow(-1),
        kits_born_alive: 5
      });

      expect(res.status).toBe(404);

      // Отказ должен быть до записи: окрол не заводится «наполовину», со
      // ссылкой на чужую случку.
      const after = await get('/api/v1/births', farmB.token, { limit: 100 });
      expect(after.body.data.items).toHaveLength(before.body.data.items.length);
    });

    it('нельзя завести крольчат из чужого окрола', async () => {
      const res = await post(`/api/v1/births/${farmA.birthId}/create-kits`, farmB.token, {
        count: 2
      });

      expect(res.status).toBe(404);
    });

    it('нельзя записать отцом крольчат чужого самца', async () => {
      const before = await rabbitCount(farmB.token);

      const res = await post(`/api/v1/births/${farmB.birthId}/create-kits`, farmB.token, {
        count: 1,
        father_id: farmA.maleId
      });

      expect(res.status).toBe(404);
      // Карточки заводятся пачкой в транзакции: отказ не должен оставлять
      // половину помёта с чужим отцом в родословной.
      expect(await rabbitCount(farmB.token)).toBe(before);
    });

    it('нельзя записать крольчатам чужую породу', async () => {
      const res = await post(`/api/v1/births/${farmB.birthId}/create-kits`, farmB.token, {
        count: 1,
        breed_id: farmA.breedId
      });

      expect(res.status).toBe(404);
    });
  });

  describe('Задачи', () => {
    it('в списке фермы видны свои задачи и нет чужих', async () => {
      const own = await get('/api/v1/tasks', farmB.token, { limit: 100 });

      expect(own.status).toBe(200);
      expect(ids(own)).toContain(farmB.taskId);
      expect(ids(own)).not.toContain(farmA.taskId);
      expect(titles(own)).not.toContain(farmA.taskTitle);
    });

    it('автозадачи случки и окрола достаются ферме, где их завели', async () => {
      const ownA = await get('/api/v1/tasks', farmA.token, { limit: 100 });
      const ownB = await get('/api/v1/tasks', farmB.token, { limit: 100 });

      // Сервер сам заводит пальпацию, маточник и ожидаемый окрол — они
      // именуются по самке, поэтому по названию видно, чья это ферма.
      expect(titles(ownA)).toContain(`Пальпация: ${farmA.femaleName}`);
      expect(titles(ownB)).not.toContain(`Пальпация: ${farmA.femaleName}`);
      expect(titles(ownA)).toContain(`Отсадка (отъем): ${farmA.femaleName}`);
      expect(titles(ownB)).not.toContain(`Отсадка (отъем): ${farmA.femaleName}`);
    });

    it('работник видит задачи своей фермы', async () => {
      const res = await get('/api/v1/tasks', workerAToken, { limit: 100 });

      expect(res.status).toBe(200);
      expect(ids(res)).toContain(farmA.taskId);
      expect(ids(res)).not.toContain(farmB.taskId);
    });

    it('чужая задача по id не отдаётся', async () => {
      const res = await get(`/api/v1/tasks/${farmA.taskId}`, farmB.token);

      expect(res.status).toBe(404);
    });

    it('чужую задачу нельзя переписать', async () => {
      const res = await put(`/api/v1/tasks/${farmA.taskId}`, farmB.token, {
        title: 'взломано',
        status: 'cancelled'
      });

      expect(res.status).toBe(404);

      const intact = await get(`/api/v1/tasks/${farmA.taskId}`, farmA.token);
      expect(intact.status).toBe(200);
      expect(intact.body.data.title).toBe(farmA.taskTitle);
      expect(intact.body.data.status).not.toBe('cancelled');
    });

    it('чужую задачу нельзя завершить', async () => {
      const res = await post(`/api/v1/tasks/${farmA.taskId}/complete`, farmB.token, {});

      expect(res.status).toBe(404);

      const intact = await get(`/api/v1/tasks/${farmA.taskId}`, farmA.token);
      expect(intact.body.data.status).not.toBe('completed');
    });

    it('чужую задачу нельзя удалить', async () => {
      const res = await del(`/api/v1/tasks/${farmA.taskId}`, farmB.token);

      expect(res.status).toBe(404);

      const intact = await get(`/api/v1/tasks/${farmA.taskId}`, farmA.token);
      expect(intact.status).toBe(200);
    });

    it('нельзя назначить задачу владельцу чужой фермы', async () => {
      const res = await post('/api/v1/tasks', farmB.token, {
        title: 'Чужому владельцу',
        type: 'other',
        due_date: `${daysFromNow(1)}T10:00:00.000Z`,
        assigned_to: farmA.ownerId
      });

      expect(res.status).toBe(404);
    });

    it('нельзя назначить задачу работнику чужой фермы', async () => {
      const res = await post('/api/v1/tasks', farmB.token, {
        title: 'Чужому работнику',
        type: 'other',
        due_date: `${daysFromNow(1)}T10:00:00.000Z`,
        assigned_to: workerAId
      });

      expect(res.status).toBe(404);

      // Задача не должна была появиться и в списке того, кому её пытались
      // навязать: фильтр списка идёт по assigned_to.
      const workerTasks = await get('/api/v1/tasks', workerAToken, { limit: 100 });
      expect(titles(workerTasks)).not.toContain('Чужому работнику');
    });

    it('нельзя перевесить свою задачу на чужого человека', async () => {
      const res = await put(`/api/v1/tasks/${farmB.taskId}`, farmB.token, {
        assigned_to: farmA.ownerId
      });

      expect(res.status).toBe(404);

      const intact = await get(`/api/v1/tasks/${farmB.taskId}`, farmB.token);
      expect(intact.body.data.assigned_to).not.toBe(farmA.ownerId);
    });

    it('нельзя привязать задачу к чужому кролику', async () => {
      const created = await post('/api/v1/tasks', farmB.token, {
        title: 'К чужому кролику',
        type: 'checkup',
        due_date: `${daysFromNow(1)}T10:00:00.000Z`,
        rabbit_id: farmA.maleId
      });
      expect(created.status).toBe(404);

      const updated = await put(`/api/v1/tasks/${farmB.taskId}`, farmB.token, {
        rabbit_id: farmA.maleId
      });
      expect(updated.status).toBe(404);
    });

    it('нельзя привязать задачу к чужой клетке', async () => {
      const created = await post('/api/v1/tasks', farmB.token, {
        title: 'К чужой клетке',
        type: 'cleaning',
        due_date: `${daysFromNow(1)}T10:00:00.000Z`,
        cage_id: farmA.cageId
      });
      expect(created.status).toBe(404);

      const updated = await put(`/api/v1/tasks/${farmB.taskId}`, farmB.token, {
        cage_id: farmA.cageId
      });
      expect(updated.status).toBe(404);
    });

    it('фильтр по чужому исполнителю не открывает чужие задачи', async () => {
      const res = await get('/api/v1/tasks', farmB.token, { limit: 100, assigned_to: farmA.ownerId });

      expect(res.status).toBe(200);
      expect(res.body.data.items).toHaveLength(0);
    });

    it('статистика фермы считает только свои задачи', async () => {
      const statsB = await get('/api/v1/tasks/statistics', farmB.token);
      const listB = await get('/api/v1/tasks', farmB.token, { limit: 100 });

      const pendingB = listB.body.data.items.filter((task) => task.status === 'pending').length;

      expect(statsB.status).toBe(200);
      expect(statsB.body.data.total_pending).toBe(pendingB);

      // У фермы А задач больше: одинаковые числа означали бы общий счётчик.
      const statsA = await get('/api/v1/tasks/statistics', farmA.token);
      expect(statsA.body.data.total_pending).toBeGreaterThan(statsB.body.data.total_pending);
    });

    it('предстоящие задачи не содержат чужих', async () => {
      const res = await get('/api/v1/tasks/upcoming', farmB.token, { days: 30 });

      expect(res.status).toBe(200);
      const upcoming = res.body.data.map((task) => task.id);
      expect(upcoming).toContain(farmB.taskId);
      expect(upcoming).not.toContain(farmA.taskId);
    });
  });
});
