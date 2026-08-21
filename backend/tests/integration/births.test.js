const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');

/**
 * Окролы: до сих пор были покрыты только юнит-тестами с полностью
 * замоканными моделями, поэтому обращение к несуществующей связи в
 * getBirthById оставалось незамеченным — карточка окрола всегда падала в 500.
 */
describe('Births API', () => {
  let accessToken, motherId, birthId;

  beforeAll(async () => {
    await syncTestDb();

    const owner = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'birthowner@example.com', password: 'Password123!', full_name: 'Birth Owner' });
    accessToken = owner.body.data.access_token;

    const breed = await request(app)
      .post('/api/v1/breeds')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({ name: 'Порода для окролов' });

    const mother = await request(app)
      .post('/api/v1/rabbits')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({
        name: 'Крольчиха',
        breed_id: breed.body.data.id,
        sex: 'female',
        birth_date: '2023-01-01',
        status: 'pregnant'
      });
    motherId = mother.body.data.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('POST /api/v1/births', () => {
    it('должен регистрировать окрол и переводить мать в активный статус', async () => {
      const res = await request(app)
        .post('/api/v1/births')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({
          mother_id: motherId,
          birth_date: '2024-03-01',
          kits_born_alive: 7,
          kits_born_dead: 1
        });

      expect(res.status).toBe(201);
      birthId = res.body.data.id;

      // Статус 'active' есть в модели, но отсутствовал в схеме БД —
      // на реальной базе этот шаг ронял всю транзакцию окрола.
      const mother = await request(app)
        .get(`/api/v1/rabbits/${motherId}`)
        .set('Authorization', `Bearer ${accessToken}`);
      expect(mother.body.data.status).toBe('active');
    });

    it('должен отклонять окрол от чужой матери', async () => {
      const res = await request(app)
        .post('/api/v1/births')
        .set('Authorization', `Bearer ${accessToken}`)
        .send({ mother_id: 99999, birth_date: '2024-03-01', kits_born_alive: 1 });

      expect(res.status).toBe(404);
    });
  });

  describe('GET /api/v1/births/:id', () => {
    it('должен возвращать окрол вместе с матерью и её породой', async () => {
      const res = await request(app)
        .get(`/api/v1/births/${birthId}`)
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.id).toBe(birthId);
      expect(res.body.data.mother.name).toBe('Крольчиха');
      expect(res.body.data.mother.breed.name).toBe('Порода для окролов');
    });

    it('должен возвращать 404 для несуществующего окрола', async () => {
      const res = await request(app)
        .get('/api/v1/births/99999')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(404);
    });

    it('должен отклонять запрос без авторизации', async () => {
      const res = await request(app).get(`/api/v1/births/${birthId}`);

      expect(res.status).toBe(401);
    });
  });

  describe('GET /api/v1/births', () => {
    it('должен возвращать список окролов фермы', async () => {
      const res = await request(app)
        .get('/api/v1/births')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      const items = res.body.data.items || res.body.data;
      expect(items.length).toBeGreaterThan(0);
    });
  });
});
