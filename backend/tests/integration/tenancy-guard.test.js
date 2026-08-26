const { Op } = require('sequelize');
const { syncTestDb, closeTestDb } = require('./helpers/testDb');
const { Farm, Rabbit, Breed, Cage } = require('../../src/models');

/**
 * Страховка от забытого фильтра по ферме.
 *
 * Разделение данных между клиентами держалось на том, что автор запроса
 * помнил дописать условие, а проверял это ревью. Ревью пропускает: так в
 * карточку пролезла чужая порода, а операции работника пропали из отчёта
 * владельца. Ошибка при этом молчит — запрос отрабатывает успешно и просто
 * возвращает не тот набор строк.
 *
 * Здесь проверяется, что молчания больше нет: запрос без условия по ферме
 * не выполняется вовсе. Тест намеренно обращается к моделям напрямую, минуя
 * HTTP: проверяется сам предохранитель, а не конкретный эндпоинт.
 */
describe('Страховка многоарендности', () => {
  let farmId;

  beforeAll(async () => {
    await syncTestDb();

    const farm = await Farm.create({ name: 'Ферма для проверки' });
    farmId = farm.id;

    const breed = await Breed.create({ name: 'Ризен', farm_id: farmId });
    await Rabbit.create({
      name: 'Буся',
      breed_id: breed.id,
      birth_date: '2025-01-01',
      farm_id: farmId
    });
  });

  afterAll(async () => {
    await closeTestDb();
  });

  describe('выборка', () => {
    it('запрос без условия по ферме не выполняется', async () => {
      await expect(Rabbit.findAll()).rejects.toThrow(/farm_id/);
    });

    it('findByPk отвергается: он не знает про ферму', async () => {
      // Именно так выглядела дыра в разведении: чужого кролика находили
      // по идентификатору и меняли ему статус.
      await expect(Rabbit.findByPk(1)).rejects.toThrow(/farm_id/);
    });

    it('с условием по ферме запрос проходит', async () => {
      const rabbits = await Rabbit.findAll({ where: { farm_id: farmId } });
      expect(rabbits).toHaveLength(1);
    });

    it('условие внутри Op.and засчитывается', async () => {
      const rabbits = await Rabbit.findAll({
        where: { [Op.and]: [{ farm_id: farmId }, { name: 'Буся' }] }
      });
      expect(rabbits).toHaveLength(1);
    });

    it('Op.or без фермы хотя бы в одной ветке отвергается', async () => {
      // Достаточно одной ветки без хозяйства, чтобы запрос выпустил чужие
      // строки: ветки складываются по ИЛИ.
      await expect(Rabbit.findAll({
        where: { [Op.or]: [{ farm_id: farmId }, { name: 'Буся' }] }
      })).rejects.toThrow(/farm_id/);
    });

    it('count проверяется наравне с выборкой', async () => {
      // У count в Sequelize собственный хук. Он выдаёт те же чужие строки,
      // только числом — на главном экране это все сводки разом.
      await expect(Cage.count()).rejects.toThrow(/farm_id/);
      await expect(Cage.count({ where: { farm_id: farmId } })).resolves.toBe(0);
    });

    it('намеренный запрос по всем фермам объявляется явно', async () => {
      const all = await Rabbit.findAll({ tenantScope: 'all' });
      expect(all).toHaveLength(1);
    });
  });

  describe('отключение клиента', () => {
    it('удаление фермы уносит её данные и не трогает соседа', async () => {
      // Отключить клиента, выполнить требование об удалении данных, прибрать
      // брошенную регистрацию — для сервиса это обычные дела, а не редкость.
      // Первая версия схемы делала их невозможными: `farms.owner_id` стоял
      // с RESTRICT, `users.farm_id` — с CASCADE, и MySQL отказывался рвать
      // круг. Ферма не удалялась вовсе.
      const doomed = await Farm.create({ name: 'Ферма на снос' });
      await Breed.create({ name: 'Порода на снос', farm_id: doomed.id });
      await Cage.create({ number: 'Z-1', farm_id: doomed.id });

      await doomed.destroy();

      expect(await Breed.count({ where: { farm_id: doomed.id } })).toBe(0);
      expect(await Cage.count({ where: { farm_id: doomed.id } })).toBe(0);
      // Сосед на месте: у него по-прежнему своя порода и свой кролик.
      expect(await Breed.count({ where: { farm_id: farmId } })).toBe(1);
      expect(await Rabbit.count({ where: { farm_id: farmId } })).toBe(1);
    });
  });

  describe('запись', () => {
    it('создание без фермы не проходит', async () => {
      await expect(Cage.create({ number: 'A-1' })).rejects.toThrow(/farm_id/);
    });

    it('пачкой — тоже', async () => {
      await expect(Cage.bulkCreate([
        { number: 'B-1', farm_id: farmId },
        { number: 'B-2' }
      ])).rejects.toThrow(/farm_id/);
    });
  });
});
