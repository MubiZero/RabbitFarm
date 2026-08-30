const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');

const PNG_1PX = Buffer.from(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
  'base64'
);

describe('Лента фото по ферме', () => {
  let ownerToken;
  let strangerToken;
  let rabbitId;

  beforeAll(async () => {
    await syncTestDb();

    const owner = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'feed_owner@example.com', password: 'Password123!', full_name: 'Владелец' });
    ownerToken = owner.body.data.access_token;

    const breed = await request(app)
      .post('/api/v1/breeds')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ name: 'Порода для ленты' });

    const rabbit = await request(app)
      .post('/api/v1/rabbits')
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ name: 'Буся', breed_id: breed.body.data.id, sex: 'female', birth_date: '2025-01-01' });
    rabbitId = rabbit.body.data.id;

    await request(app)
      .post(`/api/v1/rabbits/${rabbitId}/photos`)
      .set('Authorization', `Bearer ${ownerToken}`)
      .field('caption', 'На выставке')
      .attach('photo', PNG_1PX, 'rabbit.png');

    const stranger = await request(app)
      .post('/api/v1/auth/register')
      .send({ email: 'feed_stranger@example.com', password: 'Password123!', full_name: 'Сосед' });
    strangerToken = stranger.body.data.access_token;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  it('владелец видит фото своей фермы с указанием кролика', async () => {
    const res = await request(app)
      .get('/api/v1/photos')
      .set('Authorization', `Bearer ${ownerToken}`);

    expect(res.status).toBe(200);
    expect(res.body.data.items.length).toBeGreaterThan(0);
    expect(res.body.data.items[0].rabbit.name).toBe('Буся');
    expect(res.body.data.items[0].rabbit_id).toBe(rabbitId);
  });

  it('чужая ферма ленту не видит', async () => {
    const res = await request(app)
      .get('/api/v1/photos')
      .set('Authorization', `Bearer ${strangerToken}`);

    expect(res.status).toBe(200);
    expect(res.body.data.items).toHaveLength(0);
  });

  it('без авторизации — 401', async () => {
    const res = await request(app).get('/api/v1/photos');
    expect(res.status).toBe(401);
  });
});
