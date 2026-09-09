const { Op } = require('sequelize');

/**
 * Страховка от забытого фильтра по ферме.
 *
 * Разделение данных между клиентами до сих пор держалось на том, что автор
 * каждого запроса помнил дописать условие. Проверка этого — ревью, а ревью
 * пропускает: так в ведомость пролезла чужая порода, а операции работника
 * пропали из отчёта владельца. Ошибка при этом молчит — запрос отрабатывает
 * успешно и просто возвращает не тот набор строк.
 *
 * Хук ниже превращает молчаливую утечку в громкий отказ: выборка из таблицы,
 * принадлежащей ферме, без условия по `farm_id` не выполняется вовсе. Падение
 * на тестах видно сразу; в бою отказ безопаснее выдачи чужих данных.
 *
 * Запросы, которым ферма и правда не нужна (обслуживание, миграции данных,
 * сама регистрация), объявляют это явно: `{ tenantScope: 'all' }`. Явное
 * исключение видно в diff и на ревью — в отличие от пропущенного условия.
 */

/** Таблицы, у каждой строки которых есть хозяйство. */
const TENANT_MODELS = [
  'Breed', 'Cage', 'Feed', 'Rabbit', 'RabbitWeight', 'Breeding', 'Birth',
  'Vaccination', 'MedicalRecord', 'FeedingRecord', 'Transaction', 'Task',
  'Photo', 'Note', 'Invitation', 'DeviceToken', 'Payment', 'FarmAuditLog'
];

/** Условие могло попасть и в верхний уровень, и внутрь Op.and/Op.or. */
const mentionsFarm = (where) => {
  if (!where || typeof where !== 'object') return false;
  if (Object.prototype.hasOwnProperty.call(where, 'farm_id')) return true;

  for (const key of [Op.and, Op.or]) {
    const branch = where[key];
    if (!branch) continue;
    const parts = Array.isArray(branch) ? branch : [branch];
    // Для Op.or достаточно одной ветки без фермы, чтобы запрос выпустил
    // чужие строки, поэтому там условие обязано быть в каждой.
    const check = key === Op.or ? parts.every : parts.some;
    if (check.call(parts, mentionsFarm)) return true;
  }

  return false;
};

const attach = (models) => {
  for (const name of TENANT_MODELS) {
    const model = models[name];
    if (!model) throw new Error(`tenancy: модель ${name} не найдена`);

    const guard = (options) => {
      if (options.tenantScope === 'all') return;
      if (mentionsFarm(options.where)) return;

      throw new Error(
        `Запрос к ${name} без условия по farm_id. Добавьте farm_id в where — ` +
        'или, если выборка намеренно идёт по всем фермам, передайте ' +
        "{ tenantScope: 'all' }."
      );
    };

    model.addHook('beforeFind', guard);
    // `count` идёт мимо beforeFind — у него собственный хук. Без него
    // подсчёты (а это все сводки на главном экране) оставались бы
    // непроверенными, хотя выдают ровно те же чужие строки, только числом.
    model.addHook('beforeCount', guard);
    // Массовые destroy/update тоже идут мимо beforeFind — у них свои хуки,
    // и без условия по ферме `Model.destroy({ where })` или
    // `Model.update(values, { where })` задели бы чужие строки безвозвратно.
    // Точечные `instance.destroy()`/`instance.update()` сюда не попадают:
    // инстанс уже прошёл через guard на этапе find, которым он был получен.
    model.addHook('beforeBulkDestroy', guard);
    model.addHook('beforeBulkUpdate', guard);

    // sum/max/min идут в обход хуков вовсе — Sequelize реализует их через
    // aggregate(), а aggregate() хуки не запускает (в отличие от count(),
    // который вызывает их вручную). Перехватываем сам aggregate: это разом
    // закрывает все три метода и любые будущие вызовы через них.
    const originalAggregate = model.aggregate;
    model.aggregate = function (attribute, aggregateFunction, options) {
      guard(options || {});
      return originalAggregate.call(this, attribute, aggregateFunction, options);
    };

    const requireFarm = (instance) => {
      if (instance.farm_id === null || instance.farm_id === undefined) {
        throw new Error(`Запись ${name} создаётся без farm_id.`);
      }
    };

    model.addHook('beforeCreate', requireFarm);
    model.addHook('beforeBulkCreate', (instances) => instances.forEach(requireFarm));
  }
};

module.exports = { attach, TENANT_MODELS };
