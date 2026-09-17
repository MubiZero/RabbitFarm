jest.mock('../../../src/models', () => ({
  Task: { findAll: jest.fn(), update: jest.fn() }
}));
jest.mock('../../../src/services/notificationService', () => ({
  sendToUsers: jest.fn()
}));

const { Task } = require('../../../src/models');
const notificationService = require('../../../src/services/notificationService');
const {
  runTaskReminders,
  leadText,
  MAX_LATE_MINUTES
} = require('../../../src/jobs/taskReminderJob');

const NOW = new Date('2026-09-16T10:00:00.000Z');
const MINUTE = 60 * 1000;

/** Задача со сроком через `minutesAhead` минут от NOW. */
const task = ({
  id = 1,
  minutesAhead = 60,
  reminderBefore = 60,
  assignedTo = 9,
  createdBy = 3,
  status = 'pending'
} = {}) => ({
  id,
  farm_id: 1,
  title: 'Привить молодняк',
  title_key: null,
  title_params: null,
  due_date: new Date(NOW.getTime() + minutesAhead * MINUTE),
  reminder_before: reminderBefore,
  assigned_to: assignedTo,
  created_by: createdBy,
  status
});

/**
 * Напоминание заранее.
 *
 * До сих пор поле «за сколько предупредить» сохранялось и не читалось никем:
 * единственное, что приходило человеку, — утренняя сводка про уже
 * просроченное. Напоминание сообщало, что срок пропущен, вместо того чтобы
 * помочь его не пропустить.
 */
describe('taskReminderJob', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    Task.update.mockResolvedValue([1]);
    notificationService.sendToUsers.mockResolvedValue(undefined);
  });

  describe('кому и когда уходит', () => {
    it('шлёт исполнителю, когда момент напоминания наступил', async () => {
      // Срок через час, предупредить за час — значит прямо сейчас.
      Task.findAll.mockResolvedValue([task({ minutesAhead: 60, reminderBefore: 60 })]);

      await runTaskReminders(NOW);

      expect(notificationService.sendToUsers).toHaveBeenCalledWith(
        1,
        [9],
        expect.objectContaining({
          i18n: expect.objectContaining({ key: 'taskReminder' }),
          data: expect.objectContaining({ route: '/tasks/1' })
        })
      );
    });

    it('молчит, пока момент не наступил', async () => {
      // Срок через два часа, предупредить за час — рано.
      Task.findAll.mockResolvedValue([task({ minutesAhead: 120, reminderBefore: 60 })]);

      await runTaskReminders(NOW);

      expect(notificationService.sendToUsers).not.toHaveBeenCalled();
      // И отметку не ставим: напомнить ещё предстоит.
      expect(Task.update).not.toHaveBeenCalled();
    });

    it('без исполнителя зовёт того, кто задачу завёл', async () => {
      // Иначе напоминание не получит никто — а именно этого человек и
      // добивался, когда его ставил.
      Task.findAll.mockResolvedValue([task({ assignedTo: null, createdBy: 3 })]);

      await runTaskReminders(NOW);

      expect(notificationService.sendToUsers)
        .toHaveBeenCalledWith(1, [3], expect.anything());
    });

    it('отмечает отправленным, чтобы не слать по кругу', async () => {
      Task.findAll.mockResolvedValue([task({ id: 42 })]);

      await runTaskReminders(NOW);

      expect(Task.update).toHaveBeenCalledWith(
        { reminder_sent_at: NOW },
        expect.objectContaining({ where: { id: 42 } })
      );
    });
  });

  describe('опоздание', () => {
    it('напоминает, если проход задержался ненадолго', async () => {
      // Момент напоминания был час назад — сервер мог перезапускаться.
      Task.findAll.mockResolvedValue([task({ minutesAhead: 0, reminderBefore: 60 })]);

      await runTaskReminders(NOW);

      expect(notificationService.sendToUsers).toHaveBeenCalled();
    });

    it('молчит, если момент давно прошёл', async () => {
      // Сервер лежал сутки. Просроченным занимается утренняя сводка, а это
      // — предупреждение заранее: «напоминаю о том, что вы уже пропустили»
      // человеку не нужно.
      Task.findAll.mockResolvedValue([
        task({ minutesAhead: -(MAX_LATE_MINUTES + 30), reminderBefore: 0 })
      ]);

      await runTaskReminders(NOW);

      expect(notificationService.sendToUsers).not.toHaveBeenCalled();
    });
  });

  describe('сбои', () => {
    it('неудачная отправка не помечает задачу — попробует снова', async () => {
      Task.findAll.mockResolvedValue([task()]);
      notificationService.sendToUsers.mockRejectedValue(new Error('нет связи'));

      await runTaskReminders(NOW);

      expect(Task.update).not.toHaveBeenCalled();
    });

    it('одна упавшая задача не мешает остальным', async () => {
      Task.findAll.mockResolvedValue([task({ id: 1 }), task({ id: 2 })]);
      notificationService.sendToUsers
        .mockRejectedValueOnce(new Error('нет связи'))
        .mockResolvedValueOnce(undefined);

      await runTaskReminders(NOW);

      expect(Task.update).toHaveBeenCalledTimes(1);
      expect(Task.update).toHaveBeenCalledWith(
        { reminder_sent_at: NOW },
        expect.objectContaining({ where: { id: 2 } })
      );
    });

    it('некому напомнить — отмечаем, чтобы не перебирать каждые 15 минут', async () => {
      Task.findAll.mockResolvedValue([
        task({ assignedTo: null, createdBy: null })
      ]);

      await runTaskReminders(NOW);

      expect(notificationService.sendToUsers).not.toHaveBeenCalled();
      expect(Task.update).toHaveBeenCalled();
    });
  });

  describe('отбор в запросе', () => {
    it('берёт только незавершённые задачи с напоминанием и без отметки', async () => {
      Task.findAll.mockResolvedValue([]);

      await runTaskReminders(NOW);

      const where = Task.findAll.mock.calls[0][0].where;
      expect(where.reminder_sent_at).toBeNull();
      expect(where.reminder_before).toBeDefined();
      expect(where.status).toBeDefined();
    });
  });

  describe('сколько осталось, словами', () => {
    it('минуты, часы и дни', () => {
      expect(leadText(15, 'ru')).toBe('15 мин');
      expect(leadText(120, 'ru')).toBe('2 ч');
      expect(leadText(1440, 'ru')).toBe('1 дн');
    });

    it('на языке читателя', () => {
      expect(leadText(1440, 'uz')).toBe('1 kun');
      expect(leadText(60, 'tg')).toBe('1 соат');
      expect(leadText(30, 'en')).toBe('30 min');
    });

    it('незнакомый язык не роняет отправку', () => {
      expect(leadText(30, 'zz')).toBe('30 мин');
    });
  });
});
