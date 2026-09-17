jest.mock('../../../src/models', () => ({
  FeedingRecord: { findOne: jest.fn() }
}));

const models = require('../../../src/models');
const { allowOwnRecord } = require('../../../src/middleware/recordAuthor');

/**
 * Свою запись работник правит сам, чужую — только старший.
 *
 * Правка кормления не проверяла роль вовсе. Полный запрет работнику тоже не
 * годится: опечатку в собственной записи человек должен исправить сам.
 */
const record = (authorId) => ({ get: () => authorId });

const run = async (user, found) => {
  models.FeedingRecord.findOne.mockResolvedValue(found);

  const req = { user, farmId: 3, params: { id: '5' } };
  const res = {
    statusCode: null,
    body: null,
    status(code) {
      this.statusCode = code;
      return this;
    },
    json(body) {
      this.body = body;
      return this;
    }
  };
  const next = jest.fn();

  await allowOwnRecord('FeedingRecord', 'fed_by')(req, res, next);
  return { res, next };
};

const worker = { id: 7, role: 'worker' };

describe('правка чужой записи', () => {
  beforeEach(() => jest.clearAllMocks());

  it('свою запись работник правит сам', async () => {
    const { next, res } = await run(worker, record(7));

    expect(next).toHaveBeenCalled();
    expect(res.statusCode).toBeNull();
  });

  it('чужую — не правит', async () => {
    const { next, res } = await run(worker, record(9));

    expect(next).not.toHaveBeenCalled();
    expect(res.statusCode).toBe(403);
    // Код, а не текст: приложение переводит отказ на язык читателя.
    expect(res.body.error.code).toBe('NOT_RECORD_AUTHOR');
  });

  it('управляющий правит любую', async () => {
    const { next } = await run({ id: 4, role: 'manager' }, record(9));

    expect(next).toHaveBeenCalled();
    // До базы дело не дошло — лишнего запроса на каждую правку нет.
    expect(models.FeedingRecord.findOne).not.toHaveBeenCalled();
  });

  it('владелец правит любую', async () => {
    const { next } = await run({ id: 1, role: 'owner' }, record(9));

    expect(next).toHaveBeenCalled();
  });

  it('несуществующую запись объясняет контроллер, а не проверка прав', async () => {
    // Иначе один и тот же промах получал бы два разных ответа: «нет прав»
    // на чужой фермы запись и «не найдено» на свою.
    const { next, res } = await run(worker, null);

    expect(next).toHaveBeenCalled();
    expect(res.statusCode).toBeNull();
  });

  it('запись без автора работнику не отдаётся', async () => {
    // Записи старше колонки `created_by` автора не имеют — чинит старший.
    const { res } = await run(worker, record(null));

    expect(res.statusCode).toBe(403);
  });
});
