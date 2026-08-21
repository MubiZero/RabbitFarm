const Joi = require('joi');
const listQuery = require('./listQuery');

/**
 * Feeding Record validation schemas
 */

/**
 * Create feeding record validation schema
 */
const createFeedingRecordSchema = Joi.object({
  rabbit_id: Joi.number()
    .integer()
    .positive()
    .allow(null)
    .messages({
      'number.base': 'ID кролика должен быть числом',
      'number.positive': 'ID кролика должен быть положительным'
    }),

  feed_id: Joi.number()
    .integer()
    .positive()
    .required()
    .messages({
      'number.base': 'ID корма должен быть числом',
      'number.positive': 'ID корма должен быть положительным',
      'any.required': 'ID корма обязателен'
    }),

  cage_id: Joi.number()
    .integer()
    .positive()
    .allow(null)
    .messages({
      'number.base': 'ID клетки должен быть числом',
      'number.positive': 'ID клетки должен быть положительным'
    }),

  quantity: Joi.number()
    .precision(2)
    .positive()
    .required()
    .messages({
      'number.base': 'Количество должно быть числом',
      'number.positive': 'Количество должно быть положительным',
      'number.precision': 'Количество может иметь до 2 знаков после запятой',
      'any.required': 'Количество обязательно'
    }),

  fed_at: Joi.date()
    .max('now')
    .required()
    .messages({
      'date.base': 'Дата кормления должна быть корректной датой',
      'date.max': 'Дата кормления не может быть в будущем',
      'any.required': 'Дата кормления обязательна'
    }),

  notes: Joi.string()
    .max(1000)
    .allow(null, '')
    .messages({
      'string.base': 'Примечания должны быть строкой',
      'string.max': 'Примечания не могут превышать 1000 символов'
    })
})
  // Кормление относится либо к кролику, либо к клетке.
  //
  // Раньше проверка была написана через helpers.error('any.custom', {message}):
  // встроенный шаблон any.custom подставляет #error.message, которого в
  // переданном объекте нет, поэтому клиент получал пустую английскую фразу
  // «value failed custom validation because » без имени поля.
  .or('rabbit_id', 'cage_id')
  .messages({
    'object.missing': 'Необходимо указать либо кролика, либо клетку'
  });

/**
 * Update feeding record validation schema
 * All fields are optional for update
 */
const updateFeedingRecordSchema = Joi.object({
  rabbit_id: Joi.number()
    .integer()
    .positive()
    .allow(null)
    .messages({
      'number.base': 'ID кролика должен быть числом',
      'number.positive': 'ID кролика должен быть положительным'
    }),

  feed_id: Joi.number()
    .integer()
    .positive()
    .messages({
      'number.base': 'ID корма должен быть числом',
      'number.positive': 'ID корма должен быть положительным'
    }),

  cage_id: Joi.number()
    .integer()
    .positive()
    .allow(null)
    .messages({
      'number.base': 'ID клетки должен быть числом',
      'number.positive': 'ID клетки должен быть положительным'
    }),

  quantity: Joi.number()
    .precision(2)
    .positive()
    .messages({
      'number.base': 'Количество должно быть числом',
      'number.positive': 'Количество должно быть положительным',
      'number.precision': 'Количество может иметь до 2 знаков после запятой'
    }),

  fed_at: Joi.date()
    .max('now')
    .messages({
      'date.base': 'Дата кормления должна быть корректной датой',
      'date.max': 'Дата кормления не может быть в будущем'
    }),

  notes: Joi.string()
    .max(1000)
    .allow(null, '')
    .messages({
      'string.base': 'Примечания должны быть строкой',
      'string.max': 'Примечания не могут превышать 1000 символов'
    })
}).min(1).messages({
  'object.min': 'Необходимо указать хотя бы одно поле для обновления'
});

/** Параметры списка кормлений. */
const listFeedingRecordsQuerySchema = Joi.object({
  page: listQuery.page,
  limit: listQuery.limit,
  sort_by: listQuery.sortBy(
    ['fed_at', 'quantity', 'created_at'], 'fed_at'),
  sort_order: listQuery.sortOrder,
  rabbit_id: Joi.number().integer().optional(),
  feed_id: Joi.number().integer().optional(),
  cage_id: Joi.number().integer().optional(),
  from_date: listQuery.fromDate,
  to_date: listQuery.toDate
});

module.exports = {
  createFeedingRecordSchema,
  updateFeedingRecordSchema
,
  listFeedingRecordsQuerySchema
};
