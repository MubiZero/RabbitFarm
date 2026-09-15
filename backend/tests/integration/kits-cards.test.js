const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');

/**
 * Крольчонок и его две правды.
 *
 * До сих пор он существовал в приложении дважды и независимо: числом в
 * записи об окроле и, если нажали «Завести карточки», строкой в поголовье.
 * Половины друг о друге не знали, и из этого росло всё сразу — кнопку можно
 * было нажать дважды, падёж не доходил до второй половины, а поголовье
 * фермы (и её счёт по тарифу) зависели от того, нажимали кнопку или нет.
 *
 * Теперь правда одна: пока карточек нет — считаем числами, как только
 * заведены — карточками, и числа замораживаются.
 */
describe('Крольчата: числа или карточки, но не оба сразу', () => {
  let token;
  let breedId;
  let motherId;
  let birthId;

  const auth = () => ({ Authorization: `Bearer ${token}` });

  const countRabbits = async () => {
    const res = await request(app)
      .get('/api/v1/rabbits')
      .query({ limit: 100 })
      .set(auth());
    return res.body.data.items.length;
  };

  beforeAll(async () => {
    await syncTestDb();

    const owner = await registerFarm(app, {
      email: 'kits_owner@example.com',
      full_name: 'Владелец'
    });
    token = owner.accessToken;

    const breed = await request(app)
      .post('/api/v1/breeds')
      .set(auth())
      .send({ name: 'Порода выводка' });
    breedId = breed.body.data.id;

    const mother = await request(app)
      .post('/api/v1/rabbits')
      .set(auth())
      .send({ name: 'Мать', breed_id: breedId, sex: 'female', birth_date: '2025-01-01' });
    motherId = mother.body.data.id;

    const birth = await request(app)
      .post('/api/v1/births')
      .set(auth())
      .send({
        mother_id: motherId,
        birth_date: '2026-08-01',
        kits_born_alive: 6,
        kits_born_dead: 0
      });
    birthId = birth.body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  it('пока карточек нет, падёж отмечают в выводке', async () => {
    const res = await request(app)
      .put(`/api/v1/births/${birthId}`)
      .set(auth())
      .send({ kits_died: 1 });

    expect(res.status).toBe(200);
    expect(res.body.data.kits_died).toBe(1);
    expect(res.body.data.kits_carded_at).toBeNull();
  });

  it('карточки заводятся один раз', async () => {
    const before = await countRabbits();

    const first = await request(app)
      .post(`/api/v1/births/${birthId}/create-kits`)
      .set(auth())
      .send({ count: 5, name_prefix: 'Малыш' });

    expect(first.status).toBe(201);
    expect(await countRabbits()).toBe(before + 5);

    // Второе нажатие — та же кнопка, тот же выводок. Раньше отвечало 201 и
    // заводило ещё пятерых: шесть крольчат превращались в одиннадцать
    // карточек, и за них же ферма платила по тарифу.
    const second = await request(app)
      .post(`/api/v1/births/${birthId}/create-kits`)
      .set(auth())
      .send({ count: 5, name_prefix: 'Малыш' });

    expect(second.status).toBe(409);
    expect(await countRabbits()).toBe(before + 5);
  });

  it('после карточек числа выводка не правятся', async () => {
    const res = await request(app)
      .put(`/api/v1/births/${birthId}`)
      .set(auth())
      .send({ kits_died: 3 });

    // Отказ называет, что делать вместо этого: падёж крольчонка теперь
    // отмечают на его карточке.
    expect(res.status).toBe(409);
    expect(res.body.error.message).toMatch(/карточк/i);
  });

  it('заметки и дату окрола править можно и после карточек', async () => {
    // Запрет узкий: он про счёт крольчат, а не про запись целиком.
    const res = await request(app)
      .put(`/api/v1/births/${birthId}`)
      .set(auth())
      .send({ notes: 'выводок крупный' });

    expect(res.status).toBe(200);
    expect(res.body.data.notes).toBe('выводок крупный');
  });

  it('карточка выводка говорит, что крольчата заведены', async () => {
    const res = await request(app)
      .get(`/api/v1/births/${birthId}`)
      .set(auth());

    expect(res.status).toBe(200);
    expect(res.body.data.kits_carded_at).not.toBeNull();
  });
});
