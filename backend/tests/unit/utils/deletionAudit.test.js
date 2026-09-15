jest.mock('../../../src/models', () => ({
  FarmAuditLog: { create: jest.fn() }
}));

jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(),
  error: jest.fn(),
  warn: jest.fn(),
  debug: jest.fn()
}));

const { FarmAuditLog } = require('../../../src/models');
const logger = require('../../../src/utils/logger');
const { attachDeletionAudit, entityTypeOf } = require('../../../src/utils/deletionAudit');
const { withRequestContext } = require('../../../src/utils/requestContext');

/**
 * Журнал удалений отвечает владельцу на вопрос «кто стёр мою запись».
 * Проверяется не то, что хук зарегистрирован, а что в журнале оказывается
 * читаемая строка — и что она не появляется там, где автора нет.
 */

/** Модель-заглушка: интересен только вызванный хук и то, что он пишет. */
const fakeModel = (name) => {
  const hooks = {};
  return {
    name,
    addHook: (event, fn) => {
      hooks[event] = fn;
    },
    fire: (event, instance) => hooks[event](instance),
    hasHook: (event) => Boolean(hooks[event])
  };
};

const instance = (fields) => ({ get: (key) => fields[key] });

/** Выполнить действие так, будто его делает вошедший пользователь. */
const asUser = (userId, farmId, fn) =>
  new Promise((resolve, reject) => {
    withRequestContext({ user: { id: userId }, farmId }, {}, () => {
      Promise.resolve(fn()).then(resolve, reject);
    });
  });

describe('журнал удалений', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    FarmAuditLog.create.mockResolvedValue({});
  });

  it('записывает, кто удалил и что именно', async () => {
    const Rabbit = fakeModel('Rabbit');
    attachDeletionAudit({ Rabbit });

    await asUser(7, 3, () =>
      Rabbit.fire('afterDestroy', instance({ id: 42, farm_id: 3, name: 'Мушка', tag_id: 'A-0231' }))
    );

    expect(FarmAuditLog.create).toHaveBeenCalledWith({
      farm_id: 3,
      actor_id: 7,
      action: 'rabbit.deleted',
      entity_type: 'rabbit',
      entity_id: 42,
      // Подпись, а не идентификатор: после удаления сходить за кличкой уже
      // некуда, и «удалён кролик №42» ничего владельцу не говорит.
      entity_label: 'Мушка'
    });
  });

  it('берёт дату, когда у записи нет названия', async () => {
    const FeedingRecord = fakeModel('FeedingRecord');
    attachDeletionAudit({ FeedingRecord });

    await asUser(7, 3, () =>
      FeedingRecord.fire('afterDestroy', instance({ id: 5, farm_id: 3, fed_at: '2026-09-14' }))
    );

    const row = FarmAuditLog.create.mock.calls[0][0];
    expect(row.entity_type).toBe('feeding_record');
    expect(row.entity_label).toBe('2026-09-14');
  });

  it('молчит про уборку сервером — у неё нет автора', async () => {
    const Cage = fakeModel('Cage');
    attachDeletionAudit({ Cage });

    // Вне запроса: снос удалённой фермы по расписанию стёр бы тысячи строк,
    // и журнал фермы утонул бы в записях без автора.
    await Cage.fire('afterDestroy', instance({ id: 1, farm_id: 3, number: 'A-1' }));

    expect(FarmAuditLog.create).not.toHaveBeenCalled();
  });

  it('не роняет само удаление, если журнал недоступен', async () => {
    const Note = fakeModel('Note');
    attachDeletionAudit({ Note });
    FarmAuditLog.create.mockRejectedValue(new Error('база недоступна'));

    await expect(
      asUser(7, 3, () => Note.fire('afterDestroy', instance({ id: 9, farm_id: 3, title: 'Купить корм' })))
    ).resolves.not.toThrow();

    expect(logger.error).toHaveBeenCalled();
  });

  it('служебные таблицы в журнал не попадают', () => {
    const DeviceToken = fakeModel('DeviceToken');
    attachDeletionAudit({ DeviceToken });

    expect(DeviceToken.hasHook('afterDestroy')).toBe(false);
  });

  it('имя сущности совпадает с тем, что ждёт приложение', () => {
    expect(entityTypeOf({ name: 'MedicalRecord' })).toBe('medical_record');
    expect(entityTypeOf({ name: 'Birth' })).toBe('birth');
  });
});
