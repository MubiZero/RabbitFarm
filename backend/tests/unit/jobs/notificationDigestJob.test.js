/**
 * Обход ферм в суточном дайджесте. Полное покрытие самих правил дайджеста
 * здесь не цель — проверяется выбор ферм, которым он вообще положен, и
 * фильтр получателей по `digest_enabled`.
 */
jest.mock('../../../src/models', () => ({
  Farm: { findAll: jest.fn() },
  User: { findAll: jest.fn() },
  Vaccination: { count: jest.fn() },
  Task: { findAll: jest.fn() },
  Feed: { count: jest.fn() },
  Breeding: { findAll: jest.fn() },
  Birth: {},
  Rabbit: {},
  Cage: {}
}));
// Счёт просроченных прививок переехал в общий помощник: он считает
// кроликов, а не строки истории, и делает это запросом с подзапросом —
// подменять здесь модель было бы подменой чужой логики.
jest.mock('../../../src/utils/vaccinationDue', () => ({
  overdueRabbits: jest.fn().mockResolvedValue(0),
  upcomingRabbits: jest.fn().mockResolvedValue(0)
}));
jest.mock('../../../src/services/notificationService', () => ({
  sendToRoles: jest.fn(),
  sendToUsers: jest.fn()
}));
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(), error: jest.fn(), warn: jest.fn()
}));

const { NEST_BOX_BEFORE_BIRTH } = require('../../../src/utils/breedingCycle');
const { Farm, User, Task, Feed, Breeding } = require('../../../src/models');
const { overdueRabbits } = require('../../../src/utils/vaccinationDue');
const logger = require('../../../src/utils/logger');
const notificationService = require('../../../src/services/notificationService');
const { runDigest } = require('../../../src/jobs/notificationDigestJob');

// 03:00 UTC = 08:00 в Душанбе. Сводка уходит хозяйству в его восемь утра,
// поэтому теперь у прогона есть «сейчас»: без него фермы молча пропускаются.
const MORNING_IN_DUSHANBE = new Date('2026-08-21T03:00:00.000Z');

describe('notificationDigestJob.runDigest', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    overdueRabbits.mockResolvedValue(0);
    Feed.count.mockResolvedValue(0);
    Task.findAll.mockResolvedValue([]);
    Breeding.findAll.mockResolvedValue([]);
    User.findAll.mockResolvedValue([{ id: 10 }, { id: 11 }]);
  });

  // Обход ферм проглатывает исключения в logger.error, поэтому забытая
  // модель в моке дала бы зелёный тест при полностью упавшем дайджесте.
  afterEach(() => {
    expect(logger.error).not.toHaveBeenCalled();
  });

  it('не рассылает дайджест мягко удалённым фермам — входить туда всё равно нельзя', async () => {
    Farm.findAll.mockResolvedValue([]);

    await runDigest(MORNING_IN_DUSHANBE);

    expect(Farm.findAll).toHaveBeenCalledWith(expect.objectContaining({
      where: { deleted_at: null }
    }));
  });

  describe('утро у каждого хозяйства своё', () => {
    it('ферма в Москве не получает сводку, когда утро в Душанбе', async () => {
      // 03:00 UTC — восемь утра в Душанбе и только шесть в Москве. Раньше
      // задача била в восемь утра сервера и будила всех разом.
      Farm.findAll.mockResolvedValue([{ id: 1, timezone: 'Europe/Moscow' }]);

      await runDigest(MORNING_IN_DUSHANBE);

      expect(notificationService.sendToUsers).not.toHaveBeenCalled();
    });

    it('та же ферма получает её в своё восемь утра', async () => {
      Farm.findAll.mockResolvedValue([{ id: 1, timezone: 'Europe/Moscow' }]);
      overdueRabbits.mockResolvedValue(3);

      // 05:00 UTC — восемь утра в Москве.
      await runDigest(new Date('2026-08-21T05:00:00.000Z'));

      expect(notificationService.sendToUsers)
        .toHaveBeenCalledWith(1, [10, 11], expect.anything());
    });

    it('в один час просыпаются только фермы этого пояса', async () => {
      Farm.findAll.mockResolvedValue([
        { id: 1, timezone: 'Asia/Dushanbe' },
        { id: 2, timezone: 'Europe/Moscow' }
      ]);
      overdueRabbits.mockResolvedValue(1);

      await runDigest(MORNING_IN_DUSHANBE);

      expect(notificationService.sendToUsers)
        .toHaveBeenCalledWith(1, [10, 11], expect.anything());
      expect(notificationService.sendToUsers)
        .not.toHaveBeenCalledWith(2, expect.anything(), expect.anything());
    });

    it('ферма без пояса считается таджикской, как было до выбора страны', async () => {
      Farm.findAll.mockResolvedValue([{ id: 1 }]);
      overdueRabbits.mockResolvedValue(2);

      await runDigest(MORNING_IN_DUSHANBE);

      expect(notificationService.sendToUsers)
        .toHaveBeenCalledWith(1, [10, 11], expect.anything());
    });
  });

  it('обходит все живые фермы и шлёт только тем, кто не выключил дайджест', async () => {
    Farm.findAll.mockResolvedValue([{ id: 1 }, { id: 2 }]);
    overdueRabbits.mockResolvedValue(3);

    await runDigest(MORNING_IN_DUSHANBE);

    expect(User.findAll).toHaveBeenCalledWith(expect.objectContaining({
      where: expect.objectContaining({ farm_id: 1, is_active: true, digest_enabled: true })
    }));
    expect(notificationService.sendToUsers).toHaveBeenCalledWith(1, [10, 11], expect.anything());
    expect(notificationService.sendToUsers).toHaveBeenCalledWith(2, [10, 11], expect.anything());
    // Общий канал на роли здесь больше не используется — получатели уже
    // отфильтрованы по настройке, а не решаются на стороне сервиса.
    expect(notificationService.sendToRoles).not.toHaveBeenCalled();
  });

  it('никого не выключивших дайджест — не шлёт вовсе, а не пустому списку', async () => {
    Farm.findAll.mockResolvedValue([{ id: 1 }]);
    overdueRabbits.mockResolvedValue(3);
    User.findAll.mockResolvedValue([]);

    await runDigest(MORNING_IN_DUSHANBE);

    expect(notificationService.sendToUsers).not.toHaveBeenCalled();
  });

  it('персональный пуш по просроченной задаче уходит исполнителю независимо от digest_enabled', async () => {
    Farm.findAll.mockResolvedValue([{ id: 1 }]);
    User.findAll.mockResolvedValue([]);
    Task.findAll.mockResolvedValue([
      { id: 5, title: 'Почистить клетку', assigned_to: 42 }
    ]);

    await runDigest(MORNING_IN_DUSHANBE);

    expect(notificationService.sendToUsers).toHaveBeenCalledWith(1, [42], expect.objectContaining({
      i18n: expect.objectContaining({ key: 'taskOverdue' })
    }));

    // Название задачи вычисляется на языке получателя уже при отправке:
    // у автозадач в базе лежит только русский запасной вариант.
    const [, , payload] = notificationService.sendToUsers.mock.calls[0];
    expect(payload.i18n.params('ru')).toEqual({ task: 'Почистить клетку' });
  });
  describe('предупреждение о скором окроле', () => {
    const femaleInCage = (number) => ({
      id: 7,
      name: 'Мушка',
      tag_id: 'A-0231',
      Cage: number === null ? null : { number }
    });

    it('зовёт поставить маточник и называет клетку, а не самку', async () => {
      Farm.findAll.mockResolvedValue([{ id: 1 }]);
      Breeding.findAll.mockResolvedValue([
        { id: 99, female: femaleInCage('14'), Births: [] }
      ]);

      await runDigest(MORNING_IN_DUSHANBE);

      // Текст собирается уже на языке получателя — джоб передаёт составные
      // части, а не готовую русскую строку.
      expect(notificationService.sendToUsers).toHaveBeenCalledWith(1, [10, 11], {
        i18n: { key: 'kindlingSoon', params: { cageNumber: '14', femaleName: 'Мушка' } },
        data: { type: 'kindling_soon', route: '/breeding/99' }
      });
    });

    // Срок берётся из общей константы, а не переписывается числом: задача
    // «поставить маточник» и этот пуш — одно и то же дело, и разъехавшись
    // на сутки, они звали человека в разные дни.
    it('спрашивает окролы ровно за столько дней, за сколько ставят маточник', async () => {
      Farm.findAll.mockResolvedValue([{ id: 1 }]);

      const expected = new Date();
      expected.setDate(expected.getDate() + NEST_BOX_BEFORE_BIRTH);
      const expectedDate = expected.toISOString().split('T')[0];

      await runDigest(MORNING_IN_DUSHANBE);

      expect(Breeding.findAll).toHaveBeenCalledWith(expect.objectContaining({
        where: expect.objectContaining({ expected_birth_date: expectedDate })
      }));
    });

    it('молчит про самку, которая уже окотилась', async () => {
      Farm.findAll.mockResolvedValue([{ id: 1 }]);
      Breeding.findAll.mockResolvedValue([
        { id: 99, female: femaleInCage('14'), Births: [{ id: 3 }] }
      ]);

      await runDigest(MORNING_IN_DUSHANBE);

      expect(notificationService.sendToUsers).not.toHaveBeenCalled();
    });

    it('без клетки зовёт самку по кличке, а не молчит', async () => {
      Farm.findAll.mockResolvedValue([{ id: 1 }]);
      Breeding.findAll.mockResolvedValue([
        { id: 99, female: femaleInCage(null), Births: [] }
      ]);

      await runDigest(MORNING_IN_DUSHANBE);

      expect(notificationService.sendToUsers).toHaveBeenCalledWith(1, [10, 11], expect.objectContaining({
        i18n: { key: 'kindlingSoon', params: { cageNumber: null, femaleName: 'Мушка' } }
      }));
    });
  });
});
