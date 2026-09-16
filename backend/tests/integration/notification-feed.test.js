const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');
const notificationService = require('../../src/services/notificationService');
const { User } = require('../../src/models');

/**
 * Единственным каналом был пуш. Человек, отказавший в разрешении или просто
 * не открывший телефон утром, никогда и нигде не узнавал о просроченных
 * прививках, кончающемся корме и окроле послезавтра: сообщение не оставалось
 * ни в приложении, ни где-либо ещё.
 *
 * Firebase на стенде не настроен — и это здесь не помеха, а суть проверки:
 * лента обязана наполняться, даже когда доставить пуш некому.
 */
describe('Лента уведомлений', () => {
  let token;
  let userId;
  let farmId;

  const auth = () => ({ Authorization: `Bearer ${token}` });

  beforeAll(async () => {
    await syncTestDb();

    const owner = await registerFarm(app, {
      email: 'feed_owner@example.com',
      full_name: 'Владелец'
    });
    token = owner.accessToken;
    userId = owner.user.id;
    farmId = owner.user.farm_id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  it('сообщение ложится в ленту, даже если пуш отправить некуда', async () => {
    const result = await notificationService.sendToUsers(farmId, [userId], {
      i18n: { key: 'vaccinationDigest', params: { count: 3 } },
      data: { type: 'vaccination_digest', route: '/vaccinations' }
    });

    // Пуш действительно никуда не ушёл.
    expect(result.sent).toBe(0);

    const feed = await request(app).get('/api/v1/notifications').set(auth());
    expect(feed.status).toBe(200);

    const row = feed.body.data.items[0];
    expect(row.title).toBe('Просроченные прививки');
    expect(row.body).toBe('Просрочено: 3');
    expect(row.route).toBe('/vaccinations');
    expect(row.read_at).toBeNull();
  });

  it('текст собирается на языке читателя, а не на языке момента отправки', async () => {
    // Хранится ключ и подстановки: иначе смена языка в настройках оставила
    // бы старую ленту на прежнем языке.
    await User.update({ language: 'tg' }, { where: { id: userId } });

    const feed = await request(app).get('/api/v1/notifications').set(auth());
    expect(feed.body.data.items[0].title).toBe('Эмгузаронии мӯҳлаташ гузашта');

    await User.update({ language: 'ru' }, { where: { id: userId } });
  });

  it('счётчик непрочитанных гаснет после прочтения', async () => {
    const before = await request(app)
      .get('/api/v1/notifications/unread-count')
      .set(auth());
    expect(before.body.data.count).toBe(1);

    await request(app).post('/api/v1/notifications/read').set(auth()).expect(200);

    const after = await request(app)
      .get('/api/v1/notifications/unread-count')
      .set(auth());
    expect(after.body.data.count).toBe(0);
  });

  it('чужие уведомления не видны', async () => {
    const stranger = await registerFarm(app, {
      email: 'feed_stranger@example.com',
      full_name: 'Сосед'
    });

    const feed = await request(app)
      .get('/api/v1/notifications')
      .set({ Authorization: `Bearer ${stranger.accessToken}` });

    expect(feed.body.data.items).toHaveLength(0);
  });

  it('объявление платформы хранится готовым текстом — ключа у него нет', async () => {
    await notificationService.sendToUsers(farmId, [userId], {
      title: 'Плановые работы',
      body: 'В воскресенье сервис будет недоступен с 2 до 4 ночи.',
      data: { type: 'announcement' }
    });

    const feed = await request(app).get('/api/v1/notifications').set(auth());
    const row = feed.body.data.items[0];

    // Раньше объявление жило только в пуше: не поймал в момент отправки —
    // перечитать было негде.
    expect(row.title).toBe('Плановые работы');
    expect(row.body).toBe('В воскресенье сервис будет недоступен с 2 до 4 ночи.');
  });
});
