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
const {
  attachChangeAudit,
  entityTypeOf,
  isRequestSubject
} = require('../../../src/utils/changeAudit');
const { withRequestContext } = require('../../../src/utils/requestContext');

/**
 * Журнал изменений отвечает владельцу на два вопроса: «кто стёр мою запись»
 * и «кто её исправил». Проверяется не то, что хук зарегистрирован, а что в
 * журнале оказывается читаемая строка — и что она не появляется там, где
 * автора нет или где изменение было не работой человека, а следствием.
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

/** Изменённая запись: что стало, что было и какие поля тронуты. */
const edited = (fields, previous) => ({
  get: (key) => fields[key],
  previous: (key) => previous[key],
  changed: () => Object.keys(previous)
});

/** Выполнить действие так, будто его делает вошедший пользователь. */
const asUser = (userId, farmId, fn, path = '/api/v1/rabbits/42') =>
  new Promise((resolve, reject) => {
    withRequestContext({ user: { id: userId }, farmId, originalUrl: path }, {}, () => {
      Promise.resolve(fn()).then(resolve, reject);
    });
  });

describe('журнал изменений', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    FarmAuditLog.create.mockResolvedValue({});
  });

  it('записывает, кто удалил и что именно', async () => {
    const Rabbit = fakeModel('Rabbit');
    attachChangeAudit({ Rabbit });

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
    attachChangeAudit({ FeedingRecord });

    await asUser(7, 3, () =>
      FeedingRecord.fire('afterDestroy', instance({ id: 5, farm_id: 3, fed_at: '2026-09-14' }))
    );

    const row = FarmAuditLog.create.mock.calls[0][0];
    expect(row.entity_type).toBe('feeding_record');
    expect(row.entity_label).toBe('2026-09-14');
  });

  it('молчит про уборку сервером — у неё нет автора', async () => {
    const Cage = fakeModel('Cage');
    attachChangeAudit({ Cage });

    // Вне запроса: снос удалённой фермы по расписанию стёр бы тысячи строк,
    // и журнал фермы утонул бы в записях без автора.
    await Cage.fire('afterDestroy', instance({ id: 1, farm_id: 3, number: 'A-1' }));

    expect(FarmAuditLog.create).not.toHaveBeenCalled();
  });

  it('не роняет само удаление, если журнал недоступен', async () => {
    const Note = fakeModel('Note');
    attachChangeAudit({ Note });
    FarmAuditLog.create.mockRejectedValue(new Error('база недоступна'));

    await expect(
      asUser(7, 3, () => Note.fire('afterDestroy', instance({ id: 9, farm_id: 3, title: 'Купить корм' })))
    ).resolves.not.toThrow();

    expect(logger.error).toHaveBeenCalled();
  });

  it('служебные таблицы в журнал не попадают', () => {
    const DeviceToken = fakeModel('DeviceToken');
    attachChangeAudit({ DeviceToken });

    expect(DeviceToken.hasHook('afterDestroy')).toBe(false);
  });

  it('имя сущности совпадает с тем, что ждёт приложение', () => {
    expect(entityTypeOf({ name: 'MedicalRecord' })).toBe('medical_record');
    expect(entityTypeOf({ name: 'Birth' })).toBe('birth');
  });
});

describe('журнал правок', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    FarmAuditLog.create.mockResolvedValue({});
  });

  it('записывает, кто исправил и что было до правки', async () => {
    const FeedingRecord = fakeModel('FeedingRecord');
    attachChangeAudit({ FeedingRecord });

    await asUser(
      7,
      3,
      () =>
        FeedingRecord.fire(
          'afterUpdate',
          edited(
            { id: 5, farm_id: 3, fed_at: '2026-09-14', quantity: '500.00' },
            { quantity: '250.00' }
          )
        ),
      '/api/v1/feeding-records/5'
    );

    expect(FarmAuditLog.create).toHaveBeenCalledWith({
      farm_id: 3,
      actor_id: 7,
      action: 'feeding_record.updated',
      entity_type: 'feeding_record',
      entity_id: 5,
      entity_label: '2026-09-14',
      // Ради этой пары журнал и заводится: «500 вместо 250» владелец
      // проверит сам, «кто-то что-то поправил» — нет.
      before: { quantity: '250.00' },
      after: { quantity: '500.00' }
    });
  });

  it('побочное изменение в чужом запросе не выдаётся за правку', async () => {
    // Сохранённое кормление списывает корм со склада. Пиши мы и это —
    // журнал заполнился бы остатками, за которыми не видно работы людей.
    const Feed = fakeModel('Feed');
    attachChangeAudit({ Feed });

    await asUser(
      7,
      3,
      () =>
        Feed.fire(
          'afterUpdate',
          edited(
            { id: 2, farm_id: 3, name: 'Комбикорм', current_stock: '49.50' },
            { current_stock: '50.00' }
          )
        ),
      '/api/v1/feeding-records/5'
    );

    expect(FarmAuditLog.create).not.toHaveBeenCalled();
  });

  it('но тот же корм, исправленный напрямую, в журнал попадает', async () => {
    const Feed = fakeModel('Feed');
    attachChangeAudit({ Feed });

    await asUser(
      7,
      3,
      () =>
        Feed.fire(
          'afterUpdate',
          edited(
            { id: 2, farm_id: 3, name: 'Комбикорм', current_stock: '80.00' },
            { current_stock: '50.00' }
          )
        ),
      '/api/v1/feeds/2'
    );

    expect(FarmAuditLog.create).toHaveBeenCalledWith(
      expect.objectContaining({ action: 'feed.updated', entity_label: 'Комбикорм' })
    );
  });

  it('открыл форму и вышел — это не событие', async () => {
    const Note = fakeModel('Note');
    attachChangeAudit({ Note });

    await asUser(
      7,
      3,
      () => Note.fire('afterUpdate', edited({ id: 9, farm_id: 3, title: 'Купить корм' }, {})),
      '/api/v1/notes/9'
    );

    expect(FarmAuditLog.create).not.toHaveBeenCalled();
  });

  it('служебные поля сами по себе правкой не считаются', async () => {
    // `updated_at` меняется при любом сохранении: строка «Сафар что-то
    // изменил», за которой не стоит ни одного изменённого поля, — шум.
    const Task = fakeModel('Task');
    attachChangeAudit({ Task });

    await asUser(
      7,
      3,
      () =>
        Task.fire(
          'afterUpdate',
          edited({ id: 4, farm_id: 3, title: 'Почистить клетки' }, { updated_at: new Date(0) })
        ),
      '/api/v1/tasks/4'
    );

    expect(FarmAuditLog.create).not.toHaveBeenCalled();
  });

  it('уборка сервером автора не имеет и в журнал не идёт', async () => {
    const Rabbit = fakeModel('Rabbit');
    attachChangeAudit({ Rabbit });

    await Rabbit.fire('afterUpdate', edited({ id: 1, farm_id: 3, name: 'Мушка' }, { status: 'sold' }));

    expect(FarmAuditLog.create).not.toHaveBeenCalled();
  });

  it('адрес запроса и имя сущности сходятся для всех записей фермы', () => {
    // Правило простое — «в адресе есть имя сущности», — и оно молча
    // перестало бы работать, переименуй кто-нибудь маршрут. Случка
    // смонтирована без множественного числа, поэтому проверяются обе формы.
    expect(isRequestSubject({ path: '/api/v1/medical-records/12' }, 'medical_record')).toBe(true);
    expect(isRequestSubject({ path: '/api/v1/breeding/12' }, 'breeding')).toBe(true);
    expect(isRequestSubject({ path: '/api/v1/rabbits/12/status' }, 'rabbit')).toBe(true);
    expect(isRequestSubject({ path: '/api/v1/transactions/12' }, 'rabbit')).toBe(false);
    expect(isRequestSubject({}, 'rabbit')).toBe(false);
  });
});
