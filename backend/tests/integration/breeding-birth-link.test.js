const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');

/**
 * Список случек и связанный с ними окрол.
 *
 * Отсадку молодняка отсчитывают от дня окрола, а список случек отдавал только
 * самца и самку — приложению оставалось считать отсадку от ОЖИДАЕМОЙ даты
 * окрола. Окрол на неделю раньше ожидания уводил срок отсадки на ту же
 * неделю, а это единственный день, ради которого приложение и открывают.
 *
 * Поле добавлено, а не заменено: телефоны со старыми сборками читают ответ
 * по-прежнему, поэтому прежняя форма проверяется здесь так же придирчиво,
 * как новая.
 */
describe('Список случек: связанный окрол', () => {
  let accessToken, maleId, femaleId;
  let breedingWithBirthId, breedingWithoutBirthId, birthId;
  let createdBirth;

  const listBreedings = () =>
    request(app)
      .get('/api/v1/breeding')
      .set('Authorization', `Bearer ${accessToken}`);

  const findItem = (res, id) => res.body.data.items.find((item) => item.id === id);

  beforeAll(async () => {
    await syncTestDb();

    const owner = await registerFarm(app, {
        email: 'cycleowner@example.com',
        full_name: 'Cycle Owner'
      });
    accessToken = owner.accessToken;

    const breed = await request(app)
      .post('/api/v1/breeds')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({ name: 'Порода для цикла' });

    const male = await request(app)
      .post('/api/v1/rabbits')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({
        name: 'Самец',
        breed_id: breed.body.data.id,
        sex: 'male',
        birth_date: '2023-01-01',
        status: 'healthy'
      });
    maleId = male.body.data.id;

    const female = await request(app)
      .post('/api/v1/rabbits')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({
        name: 'Самка',
        breed_id: breed.body.data.id,
        sex: 'female',
        birth_date: '2023-01-01',
        status: 'healthy'
      });
    femaleId = female.body.data.id;

    const withBirth = await request(app)
      .post('/api/v1/breeding')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({ male_id: maleId, female_id: femaleId, breeding_date: '2024-03-01' });
    breedingWithBirthId = withBirth.body.data.id;

    const withoutBirth = await request(app)
      .post('/api/v1/breeding')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({ male_id: maleId, female_id: femaleId, breeding_date: '2024-06-01' });
    breedingWithoutBirthId = withoutBirth.body.data.id;

    const birth = await request(app)
      .post('/api/v1/births')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({
        mother_id: femaleId,
        breeding_id: breedingWithBirthId,
        birth_date: '2024-03-28',
        kits_born_alive: 7
      });
    birthId = birth.body.data.id;
    createdBirth = birth.body.data;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  it('отдаёт день окрола вместе со случкой', async () => {
    const res = await listBreedings();
    const item = findItem(res, breedingWithBirthId);

    expect(res.status).toBe(200);
    expect(item.birth).not.toBeNull();
    expect(item.birth.id).toBe(birthId);
    // Сравниваем с тем, что отдаёт сам эндпоинт окролов: важно, что список
    // случек называет тот же день, а не то, как его форматирует часовой пояс.
    expect(item.birth.birth_date).toBe(createdBirth.birth_date);
    expect(item.birth.birth_date).toMatch(/^\d{4}-\d{2}-\d{2}$/);
  });

  it('у случки без окрола поле пустое, а не отсутствует', async () => {
    const res = await listBreedings();
    const item = findItem(res, breedingWithoutBirthId);

    expect(item).toHaveProperty('birth');
    expect(item.birth).toBeNull();
  });

  it('тащит из окрола только нужные списку поля', async () => {
    const res = await listBreedings();
    const item = findItem(res, breedingWithBirthId);

    expect(Object.keys(item.birth).sort()).toEqual(
      ['birth_date', 'breeding_id', 'id', 'weaning_date']
    );
    // Массив под именем ассоциации Sequelize наружу уезжать не должен.
    expect(item).not.toHaveProperty('Births');
  });

  it('показывает отсадку, как только её записали', async () => {
    const updated = await request(app)
      .put(`/api/v1/births/${birthId}`)
      .set('Authorization', `Bearer ${accessToken}`)
      .send({ weaning_date: '2024-05-12' });

    expect(updated.status).toBe(200);

    const res = await listBreedings();
    const item = findItem(res, breedingWithBirthId);

    expect(item.birth.weaning_date).toBe(updated.body.data.weaning_date);
    expect(item.birth.weaning_date).toMatch(/^\d{4}-\d{2}-\d{2}$/);
  });

  it('прежняя форма строки списка не изменилась', async () => {
    const res = await listBreedings();
    const item = findItem(res, breedingWithBirthId);

    expect(item).toMatchObject({
      id: breedingWithBirthId,
      male_id: maleId,
      female_id: femaleId,
      status: 'completed'
    });
    expect(item.breeding_date).toBeTruthy();
    expect(item.expected_birth_date).toBeTruthy();
    expect(item.male.name).toBe('Самец');
    expect(item.female.name).toBe('Самка');
    expect(res.body.data.pagination).toMatchObject({ page: 1, total: 2 });
  });
});
