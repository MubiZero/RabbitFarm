const { currentContext } = require('./requestContext');
const logger = require('./logger');

/**
 * Журнал изменений: кто и что стёр или исправил внутри фермы.
 *
 * Второй названный владельцами страх после «не успею поставить маточник» —
 * «помощник испортит мои записи». Удаление не оставляло следа нигде: запись
 * просто переставала существовать. Правка — не лучше: после неё запись
 * по-прежнему подписана тем, кто завёл её изначально, и «было 250 г, стало
 * 500 г» не знает никто. Добавления в ленте «Журнал» и так подписаны автором
 * — здесь тот же вопрос закрывается для обратной стороны.
 *
 * Вешается хуками на модели, а не вызовами по сервисам, по одной причине:
 * забытый вызов в журнале неотличим от «никто ничего не трогал», а это хуже,
 * чем не вести журнал вовсе.
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

/// Служебные поля: их меняет сам сервер при любом сохранении, и в журнале
/// они значили бы «кто-то что-то тронул», не говоря что именно.
const TECHNICAL_FIELDS = new Set(['created_at', 'updated_at', 'createdAt', 'updatedAt']);

/// Длинная заметка целиком в журнале не нужна: строку читают списком.
const MAX_VALUE_LENGTH = 200;

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
 * Правка засчитывается той записи, ради которой человек пришёл.
 *
 * В одном запросе меняется не только она: сохранённое кормление списывает
 * корм со склада, проданный кролик меняет остаток. Пиши мы всё подряд —
 * журнал заполнился бы остатками корма, за которыми не видно работы людей.
 * Поэтому смотрим на адрес запроса: `PUT /feeding-records/12` — правка
 * кормления, а изменившийся в том же запросе корм сюда не попадает.
 */
function isRequestSubject(context, entityType) {
  const slug = entityType.replace(/_/g, '-');
  const path = String(context.path || '').split('?')[0];
  return path
    .split('/')
    .some((segment) => segment === slug || segment === `${slug}s`);
}

/** Что именно изменилось — по одному значению до и после, без служебных полей. */
function diffOf(instance) {
  const changed = instance.changed?.() || [];
  const before = {};
  const after = {};

  for (const field of changed) {
    if (TECHNICAL_FIELDS.has(field)) continue;
    before[field] = trim(instance.previous?.(field));
    after[field] = trim(instance.get?.(field));
  }

  return Object.keys(after).length ? { before, after } : null;
}

function trim(value) {
  if (value === null || value === undefined) return null;
  if (typeof value === 'string') return value.slice(0, MAX_VALUE_LENGTH);
  if (value instanceof Date) return value.toISOString();
  if (typeof value === 'object') return String(value).slice(0, MAX_VALUE_LENGTH);
  return value;
}

/**
 * Какие изменения записываем.
 *
 * Только то, что человек вносит руками и о чём может пожалеть. Служебные
 * таблицы (токены, коды входа, устройства) сюда не попадают: их пишет и
 * чистит сам сервер, и в журнале это был бы шум, за которым не видно
 * настоящей работы.
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

/** Общая часть строки журнала — или `null`, если писать её не от чьего имени. */
function rowFor(instance, model, context) {
  const farmId = instance.get?.('farm_id') || context.farmId;
  if (!farmId) return null;

  const entityType = entityTypeOf(model);
  return {
    farm_id: farmId,
    actor_id: context.userId,
    entity_type: entityType,
    entity_id: instance.get?.('id'),
    entity_label: labelOf(instance)
  };
}

async function write(row, model) {
  try {
    // Ленивый require: `models/index` подключает этот файл сам, и
    // обратная ссылка на верхнем уровне замкнула бы круг.
    const { FarmAuditLog } = require('../models');
    await FarmAuditLog.create(row);
  } catch (error) {
    // Запись в журнал не должна ронять само действие — тот же принцип,
    // что в `services/farmAuditService`.
    logger.error('Failed to write change audit', {
      error: error.message,
      model: model.name
    });
  }
}

function attachChangeAudit(models) {
  for (const name of AUDITED_MODELS) {
    const model = models[name];
    if (!model) continue;

    model.addHook('afterDestroy', async (instance) => {
      const context = currentContext();
      // Без контекста запроса это не человек, а уборка сервером (снос
      // удалённой фермы, чистка по расписанию). Писать её в журнал фермы
      // значило бы залить его тысячами строк без автора.
      if (!context) return;

      const row = rowFor(instance, model, context);
      if (!row) return;

      await write({ ...row, action: `${row.entity_type}.deleted` }, model);
    });

    model.addHook('afterUpdate', async (instance) => {
      const context = currentContext();
      if (!context) return;

      const row = rowFor(instance, model, context);
      if (!row) return;
      if (!isRequestSubject(context, row.entity_type)) return;

      const diff = diffOf(instance);
      // Сохранение, ничего не изменившее, — не событие: человек открыл форму
      // и вышел, ничего не тронув.
      if (!diff) return;

      await write({ ...row, action: `${row.entity_type}.updated`, ...diff }, model);
    });
  }
}

module.exports = { attachChangeAudit, entityTypeOf, isRequestSubject, AUDITED_MODELS };
