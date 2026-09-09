const express = require('express');
const request = require('supertest');

const { checkAppVersion } = require('../../../src/middleware/appVersion');

// Мини-приложение вместо настоящего src/app: проверка версии не ходит в базу,
// и поднимать ради неё весь стек незачем.
const app = express();
app.use('/api/', checkAppVersion);
app.get('/api/v1/ping', (req, res) => res.status(200).json({ success: true }));

const originalMinVersion = process.env.MIN_APP_VERSION;

describe('checkAppVersion', () => {
  afterEach(() => {
    if (originalMinVersion === undefined) {
      delete process.env.MIN_APP_VERSION;
    } else {
      process.env.MIN_APP_VERSION = originalMinVersion;
    }
  });

  it('пропускает запрос без заголовка версии', async () => {
    process.env.MIN_APP_VERSION = '2.0.0';

    const res = await request(app).get('/api/v1/ping');

    expect(res.status).toBe(200);
  });

  it('пропускает версию не ниже минимальной', async () => {
    process.env.MIN_APP_VERSION = '1.4.0';

    const equal = await request(app).get('/api/v1/ping').set('X-App-Version', '1.4.0');
    const newer = await request(app).get('/api/v1/ping').set('X-App-Version', '2.0.1');

    expect(equal.status).toBe(200);
    expect(newer.status).toBe(200);
  });

  it('отвечает 426 UPGRADE_REQUIRED на версию ниже минимальной', async () => {
    process.env.MIN_APP_VERSION = '1.4.0';

    const res = await request(app).get('/api/v1/ping').set('X-App-Version', '1.3.9');

    expect(res.status).toBe(426);
    expect(res.body.success).toBe(false);
    expect(res.body.error.code).toBe('UPGRADE_REQUIRED');
    // Клиенту нужно знать, до чего обновляться, а не просто «нельзя».
    expect(res.body.error.message).toContain('1.4.0');
  });

  it('отбрасывает номер сборки из версии клиента', async () => {
    process.env.MIN_APP_VERSION = '1.4.0';

    const ok = await request(app).get('/api/v1/ping').set('X-App-Version', '1.4.0+87');
    const old = await request(app).get('/api/v1/ping').set('X-App-Version', '1.2.0+87');

    expect(ok.status).toBe(200);
    expect(old.status).toBe(426);
  });

  it('пропускает запрос, если версию клиента не удалось разобрать', async () => {
    process.env.MIN_APP_VERSION = '2.0.0';

    const res = await request(app).get('/api/v1/ping').set('X-App-Version', 'unknown');

    expect(res.status).toBe(200);
  });

  it('не блокирует никого, если MIN_APP_VERSION задана мусором', async () => {
    process.env.MIN_APP_VERSION = 'не-версия';

    const res = await request(app).get('/api/v1/ping').set('X-App-Version', '0.0.1');

    expect(res.status).toBe(200);
  });

  it('по умолчанию требует 1.0.0', async () => {
    delete process.env.MIN_APP_VERSION;

    const older = await request(app).get('/api/v1/ping').set('X-App-Version', '0.9.9');
    const current = await request(app).get('/api/v1/ping').set('X-App-Version', '1.0.0');

    expect(older.status).toBe(426);
    expect(current.status).toBe(200);
  });
});
