const request = require('supertest');
const app = require('./helpers/testApp');

/**
 * Веб-версия ходит в API из браузера, а браузер сначала спрашивает
 * preflight-ом, какие заголовки можно слать. Клиент шлёт `X-App-Version` на
 * каждом запросе — не оказалось его в списке, и на боевом вебе падал вообще
 * любой запрос, причём выглядело это как «нет связи» (2026-09-13).
 */
describe('CORS', () => {
  const origin = 'http://localhost:3000';

  it('preflight разрешает заголовок версии приложения', async () => {
    const res = await request(app)
      .options('/api/v1/auth/otp/request')
      .set('Origin', origin)
      .set('Access-Control-Request-Method', 'POST')
      .set('Access-Control-Request-Headers', 'content-type,x-app-version');

    expect(res.status).toBe(200);
    const allowed = (res.headers['access-control-allow-headers'] || '').toLowerCase();
    expect(allowed).toContain('x-app-version');
    expect(allowed).toContain('content-type');
    expect(allowed).toContain('authorization');
  });

  it('запрос с заголовком версии проходит и получает разрешение источника',
    async () => {
      const res = await request(app)
        .post('/api/v1/auth/otp/request')
        .set('Origin', origin)
        .set('X-App-Version', '1.0.0')
        .send({ email: 'nobody@example.com' });

      expect(res.status).toBe(200);
      expect(res.headers['access-control-allow-origin']).toBe(origin);
    });
});
