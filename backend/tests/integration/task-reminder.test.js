const request = require('supertest');
const app = require('./helpers/testApp');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { registerFarm } = require('./helpers/auth');
const { Task } = require('../../src/models');
const { runTaskReminders } = require('../../src/jobs/taskReminderJob');
const notificationService = require('../../src/services/notificationService');

const API = '/api/v1';
const MINUTE = 60 * 1000;

/**
 * Напоминание о задаче — заранее, а не после.
 *
 * Поле «за сколько предупредить» лежало в базе с самого начала, но выбрать
 * его было негде, и не читал его никто: единственным сигналом оставалась
 * утренняя сводка про уже просроченное. Человек ставил напоминание за день
 * до прививки, спокойно про неё забывал — и узнавал наутро, что опоздал.
 */
describe('Напоминание о задаче', () => {
  let ownerToken;
  let ownerId;

  beforeAll(async () => {
    await syncTestDb();

    const owner = await registerFarm(app, {
      email: 'reminder_owner@example.com',
      full_name: 'Сафар'
    });
    ownerToken = owner.accessToken;
    ownerId = owner.user.id;
  });

  afterAll(async () => {
    await closeTestDb();
  });

  beforeEach(() => {
    jest.spyOn(notificationService, 'sendToUsers').mockResolvedValue(undefined);
  });

  afterEach(() => {
    jest.restoreAllMocks();
  });

  const createTask = (body) =>
    request(app)
      .post(`${API}/tasks`)
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({
        title: 'Привить молодняк',
        type: 'vaccination',
        priority: 'high',
        ...body
      });

  it('сохраняет выбранное время напоминания', async () => {
    const res = await createTask({
      due_date: new Date(Date.now() + 2 * 60 * MINUTE).toISOString(),
      reminder_before: 60
    });

    expect(res.status).toBe(201);
    expect(res.body.data.reminder_before).toBe(60);
  });

  it('уходит исполнителю, когда момент наступил', async () => {
    const dueAt = new Date(Date.now() + 60 * MINUTE);
    const created = await createTask({
      due_date: dueAt.toISOString(),
      reminder_before: 60,
      assigned_to: ownerId
    });

    // Сейчас: срок через час, предупредить за час.
    const handled = await runTaskReminders(new Date());
    expect(handled).toBeGreaterThan(0);

    expect(notificationService.sendToUsers).toHaveBeenCalledWith(
      expect.any(Number),
      [ownerId],
      expect.objectContaining({
        data: expect.objectContaining({
          type: 'task_reminder',
          route: `/tasks/${created.body.data.id}`
        })
      })
    );

    // Отметка о доставке проставлена — по кругу слать не будет.
    const stored = await Task.findByPk(created.body.data.id, {
      tenantScope: 'all'
    });
    expect(stored.reminder_sent_at).not.toBeNull();
  });

  it('второй проход по той же задаче молчит', async () => {
    await runTaskReminders(new Date());
    expect(notificationService.sendToUsers).not.toHaveBeenCalled();
  });

  it('перенос срока возвращает напоминание', async () => {
    const created = await createTask({
      due_date: new Date(Date.now() + 30 * MINUTE).toISOString(),
      reminder_before: 30,
      assigned_to: ownerId
    });
    const taskId = created.body.data.id;

    await runTaskReminders(new Date());
    notificationService.sendToUsers.mockClear();

    // Срок передвинули — предупредить нужно заново, иначе по этой задаче
    // напоминание не придёт вовсе: оно «уже отправлено».
    await request(app)
      .put(`${API}/tasks/${taskId}`)
      .set('Authorization', `Bearer ${ownerToken}`)
      .send({ due_date: new Date(Date.now() + 90 * MINUTE).toISOString() });

    const afterEdit = await Task.findByPk(taskId, { tenantScope: 'all' });
    expect(afterEdit.reminder_sent_at).toBeNull();
  });

  it('задача без напоминания не трогается вовсе', async () => {
    await createTask({
      due_date: new Date(Date.now() + 10 * MINUTE).toISOString(),
      assigned_to: ownerId
    });

    await runTaskReminders(new Date());

    expect(notificationService.sendToUsers).not.toHaveBeenCalledWith(
      expect.any(Number),
      expect.any(Array),
      expect.objectContaining({
        data: expect.objectContaining({ type: 'task_reminder' })
      })
    );
  });
});
