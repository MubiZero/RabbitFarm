const { currentContext } = require('./requestContext');
const logger = require('./logger');

/**
 * Журнал удалений: кто и что стёр внутри фермы.
 *
 * Второй названный владельцами страх после «не успею поставить маточник» —
 * «помощник сотрёт мои записи». До сих пор удаление не оставляло следа
 * нигде: запись просто переставала существовать, и даже установить, была ли
 * она вообще, было нельзя. Добавления в ленте «Журнал» и так подписаны
 * автором — здесь тот же вопрос закрывается для обратной стороны.
 *
 * Вешается хуками на модели, а не вызовами по сервисам, по одной причине:
 * забытый вызов в журнале неотличим от «никто ничего не удалял», а это
 * хуже, чем не вести журнал вовсе.
 */

/// Подпись сущности собирается из того, что уже есть в самой строке —
/// дополнительных запросов на удалённую запись делать некуда и незачем.
const LABEL_FIELDS = [
  'name',
  'number',
  'title',
  'vaccine_name',
  'diagnosis',
  'description',
  'tag_id'
];

const DATE_FIELDS = ['fed_at', 'birth_date', 'breeding_date', 'date', 'due_date'];

function labelOf(instance) {
  for (const field of LABEL_FIELDS) {
    const value = instance.get?.(field);
    if (typeof value === 'string' && value.trim()) return value.trim().slice(0, 120);
  }
  for (const field of DATE_FIELDS) {
    const value = instance.get?.(field);
    if (value) return String(value).slice(0, 120);
  }
  return `#${instance.get?.('id')}`;
}

/** `FeedingRecord` -> `feeding_record`: то же имя, что видит мобильное приложение. */
function entityTypeOf(model) {
  return model.name.replace(/([a-z0-9])([A-Z])/g, '$1_$2').toLowerCase();
}

/**
 * Какие удаления записываем.
 *
 * Только то, что человек вносит руками и о чём может пожалеть. Служебные
 * таблицы (токены, коды входа, устройства) сюда не попадают: их чистит сам
 * сервер, и в журнале это был бы шум, за которым не видно настоящих
 * удалений.
 */
const AUDITED_MODELS = [
  'Rabbit',
  'Cage',
  'Breed',
  'Feed',
  'FeedingRecord',
  'MedicalRecord',
  'Vaccination',
  'Task',
  'Note',
  'Transaction',
  'Birth',
  'Breeding'
];

function attachDeletionAudit(models) {
  for (const name of AUDITED_MODELS) {
    const model = models[name];
    if (!model) continue;

    model.addHook('afterDestroy', async (instance) => {
      const context = currentContext();
      // Без контекста запроса это не человек, а уборка сервером (снос
      // удалённой фермы, чистка по расписанию). Писать её в журнал фермы
      // значило бы залить его тысячами строк без автора.
      if (!context) return;

      const farmId = instance.get?.('farm_id') || context.farmId;
      if (!farmId) return;

      try {
        // Ленивый require: `models/index` подключает этот файл сам, и
        // обратная ссылка на верхнем уровне замкнула бы круг.
        const { FarmAuditLog } = require('../models');
        await FarmAuditLog.create({
          farm_id: farmId,
          actor_id: context.userId,
          action: `${entityTypeOf(model)}.deleted`,
          entity_type: entityTypeOf(model),
          entity_id: instance.get?.('id'),
          entity_label: labelOf(instance)
        });
      } catch (error) {
        // Запись в журнал не должна ронять само удаление — тот же принцип,
        // что в `services/farmAuditService`.
        logger.error('Failed to write deletion audit', {
          error: error.message,
          model: model.name
        });
      }
    });
  }
}

module.exports = { attachDeletionAudit, entityTypeOf, AUDITED_MODELS };
