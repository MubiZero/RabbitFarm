const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');
const { client: minioClient, bucket: minioBucket } = require('../../src/config/minio');
const { PNG_1PX } = require('../helpers/fileFixtures');

async function objectExists(relativeUrl) {
  const objectKey = relativeUrl.replace(/^\/uploads\//, '');
  try {
    await minioClient.statObject(minioBucket, objectKey);
    return true;
  } catch {
    return false;
  }
}

/**
 * Чек операции.
 *
 * Поле `receipt_url` было в модели с самого начала, но взять этот URL
 * человеку было негде: приложение файл не отправляло, а валидатор к тому же
 * требовал абсолютный URI — то есть наш собственный `/uploads/...` он бы и
 * не принял. Чек снимают телефоном у кассы, значит он и должен приходить
 * файлом.
 */
describe('Чек операции', () => {
  let token;

  const auth = () => ({ Authorization: `Bearer ${token}` });

  beforeAll(async () => {
    await syncTestDb();
    const owner = await registerFarm(app, {
      email: 'receipt_owner@example.com',
      full_name: 'Владелец'
    });
    token = owner.accessToken;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  const createWithReceipt = () =>
    request(app)
      .post('/api/v1/transactions')
      .set(auth())
      .field('type', 'expense')
      .field('category', 'feed')
      .field('amount', '150.50')
      .field('transaction_date', '2026-09-01')
      .field('description', 'Мешок комбикорма')
      .attach('receipt', PNG_1PX, 'receipt.png');

  it('проводка заводится вместе со снимком чека', async () => {
    const res = await createWithReceipt();

    expect(res.status).toBe(201);
    expect(res.body.data.receipt_url).toMatch(/^\/uploads\/farm-\d+\/receipts\//);
    expect(await objectExists(res.body.data.receipt_url)).toBe(true);

    // Файл отдаётся тем же путём, что и фото кролика: приложение не знает
    // про хранилище.
    const served = await request(app).get(res.body.data.receipt_url).set(auth());
    expect(served.status).toBe(200);
  });

  it('новый чек заменяет прежний, и прежний не остаётся в хранилище', async () => {
    const created = await createWithReceipt();
    const firstUrl = created.body.data.receipt_url;

    const updated = await request(app)
      .put(`/api/v1/transactions/${created.body.data.id}`)
      .set(auth())
      .attach('receipt', PNG_1PX, 'receipt-2.png');

    expect(updated.status).toBe(200);
    expect(updated.body.data.receipt_url).not.toBe(firstUrl);
    expect(await objectExists(updated.body.data.receipt_url)).toBe(true);
    // Забытый файл занимал бы место фермы по тарифу до конца времён.
    expect(await objectExists(firstUrl)).toBe(false);
  });

  it('снятый чек уносит за собой файл', async () => {
    const created = await createWithReceipt();
    const url = created.body.data.receipt_url;

    const updated = await request(app)
      .put(`/api/v1/transactions/${created.body.data.id}`)
      .set(auth())
      .send({ receipt_url: '' });

    expect(updated.status).toBe(200);
    expect(await objectExists(url)).toBe(false);
  });

  it('удалённая проводка уносит чек', async () => {
    const created = await createWithReceipt();
    const url = created.body.data.receipt_url;

    await request(app)
      .delete(`/api/v1/transactions/${created.body.data.id}`)
      .set(auth())
      .expect(200);

    expect(await objectExists(url)).toBe(false);
  });

  it('ссылку вместо файла не принимаем', async () => {
    // Путь к файлу выдаёт сервер; чужой адрес в этом поле — это либо
    // ошибка клиента, либо попытка увести человека наружу.
    const res = await request(app)
      .post('/api/v1/transactions')
      .set(auth())
      .send({
        type: 'expense',
        category: 'feed',
        amount: 10,
        transaction_date: '2026-09-01',
        receipt_url: 'https://example.com/receipt.png'
      });

    expect(res.status).toBe(422);
  });
});
