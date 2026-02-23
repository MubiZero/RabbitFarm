const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');

describe('Auth API', () => {
  beforeAll(async () => {
    await syncTestDb();
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('POST /api/v1/auth/register', () => {
    it('должен регистрировать нового пользователя', async () => {
      const res = await request(app)
        .post('/api/v1/auth/register')
        .send({ email: 'new@example.com', password: 'Password123!', full_name: 'Test User' });

      expect(res.status).toBe(201);
      expect(res.body.success).toBe(true);
      expect(res.body.data).toHaveProperty('access_token');
      expect(res.body.data).toHaveProperty('refresh_token');
      expect(res.body.data.user).toHaveProperty('id');
      expect(res.body.data.user).not.toHaveProperty('password_hash');
    });

    it('должен отклонять дублирующийся email', async () => {
      await request(app)
        .post('/api/v1/auth/register')
        .send({ email: 'dup@example.com', password: 'Password123!', full_name: 'User' });

      const res = await request(app)
        .post('/api/v1/auth/register')
        .send({ email: 'dup@example.com', password: 'Password123!', full_name: 'User 2' });

      expect(res.status).toBe(400);
      expect(res.body.success).toBe(false);
    });

    it('должен отклонять невалидный email', async () => {
      const res = await request(app)
        .post('/api/v1/auth/register')
        .send({ email: 'not-an-email', password: 'Password123!', full_name: 'User' });

      expect(res.status).toBe(422);
    });

    it('должен отклонять слабый пароль', async () => {
      const res = await request(app)
        .post('/api/v1/auth/register')
        .send({ email: 'weak@example.com', password: '123', full_name: 'User' });

      expect(res.status).toBe(422);
    });
  });

  describe('POST /api/v1/auth/login', () => {
    beforeAll(async () => {
      await request(app)
        .post('/api/v1/auth/register')
        .send({ email: 'login@example.com', password: 'Password123!', full_name: 'Login User' });
    });

    it('должен входить с верными данными', async () => {
      const res = await request(app)
        .post('/api/v1/auth/login')
        .send({ email: 'login@example.com', password: 'Password123!' });

      expect(res.status).toBe(200);
      expect(res.body.data).toHaveProperty('access_token');
    });

    it('должен отклонять неверный пароль', async () => {
      const res = await request(app)
        .post('/api/v1/auth/login')
        .send({ email: 'login@example.com', password: 'WrongPass!' });

      expect(res.status).toBe(401);
    });

    it('должен отклонять несуществующего пользователя', async () => {
      const res = await request(app)
        .post('/api/v1/auth/login')
        .send({ email: 'ghost@example.com', password: 'Password123!' });

      expect(res.status).toBe(401);
    });
  });

  describe('GET /api/v1/auth/me', () => {
    let accessToken;

    beforeAll(async () => {
      const res = await request(app)
        .post('/api/v1/auth/register')
        .send({ email: 'me@example.com', password: 'Password123!', full_name: 'Me User' });
      accessToken = res.body.data.access_token;
    });

    it('должен возвращать профиль авторизованного пользователя', async () => {
      const res = await request(app)
        .get('/api/v1/auth/me')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.email).toBe('me@example.com');
    });

    it('должен отклонять запрос без токена', async () => {
      const res = await request(app).get('/api/v1/auth/me');
      expect(res.status).toBe(401);
    });

    it('должен отклонять запрос с невалидным токеном', async () => {
      const res = await request(app)
        .get('/api/v1/auth/me')
        .set('Authorization', 'Bearer invalid.token.here');
      expect(res.status).toBe(401);
    });
  });

  describe('POST /api/v1/auth/refresh', () => {
    let refreshToken;

    beforeAll(async () => {
      const res = await request(app)
        .post('/api/v1/auth/register')
        .send({ email: 'refresh@example.com', password: 'Password123!', full_name: 'Refresh User' });
      refreshToken = res.body.data.refresh_token;
    });

    it('должен обновлять access token по refresh token', async () => {
      const res = await request(app)
        .post('/api/v1/auth/refresh')
        .send({ refresh_token: refreshToken });

      expect(res.status).toBe(200);
      expect(res.body.data).toHaveProperty('access_token');
      expect(res.body.data).toHaveProperty('refresh_token');
    });

    it('должен отклонять невалидный refresh token', async () => {
      const res = await request(app)
        .post('/api/v1/auth/refresh')
        .send({ refresh_token: 'invalid-token' });

      expect(res.status).toBe(401);
    });
  });

  describe('POST /api/v1/auth/logout', () => {
    it('должен инвалидировать refresh token', async () => {
      const registerRes = await request(app)
        .post('/api/v1/auth/register')
        .send({ email: 'logout@example.com', password: 'Password123!', full_name: 'Logout User' });
      const { refresh_token } = registerRes.body.data;

      const logoutRes = await request(app)
        .post('/api/v1/auth/logout')
        .send({ refresh_token });

      expect(logoutRes.status).toBe(200);

      // После logout refresh token должен быть недействителен
      const refreshRes = await request(app)
        .post('/api/v1/auth/refresh')
        .send({ refresh_token });

      expect(refreshRes.status).toBe(401);
    });
  });
});
