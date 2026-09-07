const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');

describe('Device Tokens API', () => {
  let ownerToken;
  let strangerToken;

  beforeAll(async () => {
    await syncTestDb();

    const owner = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'devicetoken_owner@example.com', password: 'Password123!', full_name: 'Владелец' });
    ownerToken = owner.body.data.access_token;

    const stranger = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'devicetoken_stranger@example.com', password: 'Password123!', full_name: 'Сосед' });
    strangerToken = stranger.body.data.access_token;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('POST /api/v1/device-tokens', () => {
    it('регистрирует токен устройства', async () => {
      const res = await request(app)
        .post('/api/v1/device-tokens')
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ token: 'fcm-token-1', platform: 'android' });

      expect(res.status).toBe(201);
    });

    it('отклоняет регистрацию без авторизации', async () => {
      const res = await request(app)
        .post('/api/v1/device-tokens')
        .send({ token: 'fcm-token-2', platform: 'android' });

      expect(res.status).toBe(401);
    });

    it('отклоняет неизвестную платформу', async () => {
      const res = await request(app)
        .post('/api/v1/device-tokens')
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ token: 'fcm-token-3', platform: 'windows' });

      expect(res.status).toBe(422);
    });

    it('переезд токена на другого пользователя переписывает строку, а не плодит дубль', async () => {
      const { DeviceToken } = require('../../src/models');

      await request(app)
        .post('/api/v1/device-tokens')
        .set('Authorization', `Bearer ${strangerToken}`)
        .send({ token: 'fcm-token-1', platform: 'ios' });

      const rows = await DeviceToken.findAll({ where: { token: 'fcm-token-1' }, tenantScope: 'all' });
      expect(rows).toHaveLength(1);
      expect(rows[0].platform).toBe('ios');
    });
  });

  describe('DELETE /api/v1/device-tokens', () => {
    it('владелец отвязывает свой токен', async () => {
      await request(app)
        .post('/api/v1/device-tokens')
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ token: 'fcm-token-own', platform: 'android' });

      const res = await request(app)
        .delete('/api/v1/device-tokens')
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ token: 'fcm-token-own' });

      expect(res.status).toBe(200);

      const { DeviceToken } = require('../../src/models');
      const rows = await DeviceToken.findAll({ where: { token: 'fcm-token-own' }, tenantScope: 'all' });
      expect(rows).toHaveLength(0);
    });

    it('чужая ферма не может отвязать не свой токен', async () => {
      const { DeviceToken } = require('../../src/models');

      await request(app)
        .post('/api/v1/device-tokens')
        .set('Authorization', `Bearer ${ownerToken}`)
        .send({ token: 'fcm-token-protected', platform: 'android' });

      const res = await request(app)
        .delete('/api/v1/device-tokens')
        .set('Authorization', `Bearer ${strangerToken}`)
        .send({ token: 'fcm-token-protected' });

      expect(res.status).toBe(200);

      const rows = await DeviceToken.findAll({ where: { token: 'fcm-token-protected' }, tenantScope: 'all' });
      expect(rows).toHaveLength(1);
    });
  });
});
