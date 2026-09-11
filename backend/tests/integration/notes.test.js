const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm, login: signIn } = require('./helpers/auth');

describe('Notes API', () => {
  let ownerToken;
  let workerToken;
  let strangerToken;
  let rabbitId;

  beforeAll(async () => {
    await syncTestDb();

    const owner = await registerFarm(app, { email: 'note_owner@example.com', full_name: 'Владелец' });
    ownerToken = owner.accessToken;

    const breed = await request(app)
      .post('/api/v1/breeds')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ name: 'Порода для заметок' });

    const rabbit = await request(app)
      .post('/api/v1/rabbits')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ name: 'Буся', breed_id: breed.body.data.id, sex: 'female', birth_date: '2025-01-01' });
    rabbitId = rabbit.body.data.id;

    await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'note_worker@example.com', full_name: 'Работник' });
    const { User } = require('../../src/models');
    await User.update(
      { farm_id: owner.user.farm_id, role: 'worker' },
      { where: { email: 'note_worker@example.com' } }
    );
    const workerLogin = await signIn(app, { email: 'note_worker@example.com' })
    workerToken = workerLogin.accessToken;

    const stranger = await registerFarm(app, { email: 'note_stranger@example.com', full_name: 'Сосед' });
    strangerToken = stranger.accessToken;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('POST /api/v1/notes', () => {
    it('создаёт заметку по ферме без привязки', async () => {
      const res = await request(app)
        .post('/api/v1/notes')
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ content: 'Заказать сено на следующую неделю' });

      expect(res.status).toBe(201);
      expect(res.body.data.content).toBe('Заказать сено на следующую неделю');
      expect(res.body.data.rabbit_id).toBeNull();
    });

    it('создаёт заметку по кролику', async () => {
      const res = await request(app)
        .post('/api/v1/notes')
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ content: 'Прихрамывает на заднюю лапу', rabbit_id: rabbitId });

      expect(res.status).toBe(201);
      expect(res.body.data.rabbit_id).toBe(rabbitId);
      expect(res.body.data.rabbit.name).toBe('Буся');
      expect(res.body.data.author.full_name).toBe('Владелец');
    });

    it('работник тоже может оставить заметку', async () => {
      const res = await request(app)
        .post('/api/v1/notes')
        .set('Authorization', `Bearer ${workerToken}`)
        .send({ content: 'Клетка требует уборки' });

      expect(res.status).toBe(201);
    });

    it('отклоняет заметку без текста', async () => {
      const res = await request(app)
        .post('/api/v1/notes')
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({});

      expect(res.status).toBe(422);
    });

    it('отклоняет заметку без авторизации', async () => {
      const res = await request(app)
        .post('/api/v1/notes')
        .send({ content: 'Без токена' });

      expect(res.status).toBe(401);
    });

    it('отклоняет кролика с чужой фермы', async () => {
      const strangerRabbit = await request(app)
        .post('/api/v1/breeds')
        .set('Authorization', `Bearer ${strangerToken}`)
        .send({ name: 'Чужая порода' });
      const foreignRabbit = await request(app)
        .post('/api/v1/rabbits')
        .set('Authorization', `Bearer ${strangerToken}`)
        .send({ name: 'Чужой', breed_id: strangerRabbit.body.data.id, sex: 'male', birth_date: '2025-01-01' });

      const res = await request(app)
        .post('/api/v1/notes')
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ content: 'Про чужого кролика', rabbit_id: foreignRabbit.body.data.id });

      expect(res.status).toBe(404);
    });
  });

  describe('GET /api/v1/notes', () => {
    it('возвращает список заметок фермы с пагинацией', async () => {
      const res = await request(app)
        .get('/api/v1/notes')
        .set('Authorization', `Bearer ${ownerToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data).toHaveProperty('items');
      expect(res.body.data).toHaveProperty('pagination');
      expect(res.body.data.items.length).toBeGreaterThan(0);
    });

    it('чужая ферма своих заметок не видит', async () => {
      const res = await request(app)
        .get('/api/v1/notes')
        .set('Authorization', `Bearer ${strangerToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.items).toHaveLength(0);
    });
  });

  describe('PUT и DELETE /api/v1/notes/:id', () => {
    let noteId;

    beforeAll(async () => {
      const created = await request(app)
        .post('/api/v1/notes')
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ content: 'Черновая заметка' });
      noteId = created.body.data.id;
    });

    it('владелец правит текст заметки', async () => {
      const res = await request(app)
        .put(`/api/v1/notes/${noteId}`)
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ content: 'Исправленная заметка' });

      expect(res.status).toBe(200);
      expect(res.body.data.content).toBe('Исправленная заметка');
    });

    it('чужая ферма не может править заметку', async () => {
      const res = await request(app)
        .put(`/api/v1/notes/${noteId}`)
        .set('Authorization', `Bearer ${strangerToken}`)
        .send({ content: 'Подмена' });

      expect(res.status).toBe(404);
    });

    it('работнику нельзя удалить заметку', async () => {
      const res = await request(app)
        .delete(`/api/v1/notes/${noteId}`)
        .set('Authorization', `Bearer ${workerToken}`);

      expect(res.status).toBe(403);
    });

    it('владелец удаляет заметку', async () => {
      const res = await request(app)
        .delete(`/api/v1/notes/${noteId}`)
        .set('Authorization', `Bearer ${ownerToken}`);

      expect(res.status).toBe(200);

      const check = await request(app)
        .get(`/api/v1/notes/${noteId}`)
        .set('Authorization', `Bearer ${ownerToken}`);
      expect(check.status).toBe(404);
    });
  });
});
