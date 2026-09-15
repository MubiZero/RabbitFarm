const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');

/**
 * Сервер сам заводит задачи по ходу цикла: прощупать, поставить маточник,
 * ждать окрола, взвесить, отсадка. Закрыть их мог только человек галочкой —
 * и почти никогда не закрывал, потому что дело он делает не через задачу, а
 * через запись. Записал окрол — «прощупать» и «ожидаемый окрол» оставались
 * просроченными навсегда и каждое утро в 08:00 уходили пушем.
 */
describe('Автозадачи закрываются самим делом', () => {
  let token;
  let breedId;
  let femaleId;
  let maleId;

  const auth = () => ({ Authorization: `Bearer ${token}` });

  const openTaskKeys = async (rabbitId) => {
    const res = await request(app)
      .get('/api/v1/tasks')
      .query({ limit: 100 })
      .set(auth());
    return res.body.data.items
      .filter((task) => task.rabbit_id === rabbitId && task.status === 'pending')
      .map((task) => task.title_key);
  };

  beforeAll(async () => {
    await syncTestDb();

    const owner = await registerFarm(app, {
      email: 'autotask_owner@example.com',
      full_name: 'Владелец'
    });
    token = owner.accessToken;

    const breed = await request(app)
      .post('/api/v1/breeds')
      .set(auth())
      .send({ name: 'Порода для задач' });
    breedId = breed.body.data.id;

    const female = await request(app)
      .post('/api/v1/rabbits')
      .set(auth())
      .send({ name: 'Мушка', breed_id: breedId, sex: 'female', birth_date: '2025-01-01' });
    femaleId = female.body.data.id;

    const male = await request(app)
      .post('/api/v1/rabbits')
      .set(auth())
      .send({ name: 'Борис', breed_id: breedId, sex: 'male', birth_date: '2025-01-01' });
    maleId = male.body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  it('окрол закрывает прощупывание, маточник и ожидание окрола', async () => {
    const breeding = await request(app)
      .post('/api/v1/breeding')
      .set(auth())
      .send({ male_id: maleId, female_id: femaleId, breeding_date: '2026-08-01' });

    expect(breeding.status).toBe(201);

    const beforeBirth = await openTaskKeys(femaleId);
    expect(beforeBirth).toEqual(
      expect.arrayContaining(['palpation', 'nestBox', 'expectedKindling'])
    );

    await request(app)
      .post('/api/v1/births')
      .set(auth())
      .send({
        breeding_id: breeding.body.data.id,
        mother_id: femaleId,
        birth_date: '2026-09-01',
        kits_born_alive: 6,
        kits_born_dead: 0
      })
      .expect(201);

    const afterBirth = await openTaskKeys(femaleId);
    expect(afterBirth).not.toContain('palpation');
    expect(afterBirth).not.toContain('nestBox');
    expect(afterBirth).not.toContain('expectedKindling');
    // Задачи про молодняк окрол не закрывает — их дело ещё впереди.
    expect(afterBirth).toEqual(expect.arrayContaining(['weighKits', 'weaning']));
  });

  it('выбывший кролик не оставляет за собой задач', async () => {
    // Взвесить павшего или поставить маточник проданной самке никто не
    // пойдёт, а в утренний дайджест это уходило каждый день.
    await request(app)
      .put(`/api/v1/rabbits/${femaleId}`)
      .set(auth())
      .send({ status: 'dead', death_date: '2026-09-14' })
      .expect(200);

    expect(await openTaskKeys(femaleId)).toHaveLength(0);
  });

  it('задачу, заведённую человеком, событие не снимает', async () => {
    const survivor = await request(app)
      .post('/api/v1/rabbits')
      .set(auth())
      .send({ name: 'Пушок', breed_id: breedId, sex: 'female', birth_date: '2025-02-01' });
    const rabbitId = survivor.body.data.id;

    const manual = await request(app)
      .post('/api/v1/tasks')
      .set(auth())
      .send({
        title: 'Показать ветеринару',
        type: 'checkup',
        due_date: '2026-10-01',
        rabbit_id: rabbitId
      });
    expect(manual.status).toBe(201);

    await request(app)
      .put(`/api/v1/rabbits/${rabbitId}`)
      .set(auth())
      .send({ status: 'sold' })
      .expect(200);

    const left = await request(app)
      .get(`/api/v1/tasks/${manual.body.data.id}`)
      .set(auth());
    // Мы не знаем, что человек имел в виду, — снимать за него нельзя.
    expect(left.body.data.status).toBe('pending');
  });
});
