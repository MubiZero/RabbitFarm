const Joi = require('joi');
const listQuery = require('./listQuery');

/**
 * Note validation schemas
 */

const createNoteSchema = Joi.object({
  content: Joi.string()
    .min(1)
    .max(2000)
    .required()
    .messages({
      'string.base': 'Текст заметки должен быть строкой',
      'string.min': 'Заметка не может быть пустой',
      'string.max': 'Заметка не может превышать 2000 символов',
      'any.required': 'Текст заметки обязателен'
    }),

  rabbit_id: Joi.number()
    .integer()
    .positive()
    .allow(null)
    .messages({
      'number.base': 'ID кролика должен быть числом',
      'number.positive': 'ID кролика должен быть положительным'
    }),

  cage_id: Joi.number()
    .integer()
    .positive()
    .allow(null)
    .messages({
      'number.base': 'ID клетки должен быть числом',
      'number.positive': 'ID клетки должен быть положительным'
    })
});

const updateNoteSchema = Joi.object({
  content: Joi.string()
    .min(1)
    .max(2000)
    .messages({
      'string.base': 'Текст заметки должен быть строкой',
      'string.min': 'Заметка не может быть пустой',
      'string.max': 'Заметка не может превышать 2000 символов'
    }),

  rabbit_id: Joi.number()
    .integer()
    .positive()
    .allow(null)
    .messages({
      'number.base': 'ID кролика должен быть числом',
      'number.positive': 'ID кролика должен быть положительным'
    }),

  cage_id: Joi.number()
    .integer()
    .positive()
    .allow(null)
    .messages({
      'number.base': 'ID клетки должен быть числом',
      'number.positive': 'ID клетки должен быть положительным'
    })
}).min(1).messages({
  'object.min': 'Необходимо указать хотя бы одно поле для обновления'
});

const listNotesQuerySchema = Joi.object({
  page: listQuery.page,
  limit: listQuery.limit.default(50),
  sort_by: listQuery.sortBy(['created_at'], 'created_at'),
  sort_order: listQuery.sortOrder.default('DESC'),
  rabbit_id: Joi.number().integer().optional(),
  cage_id: Joi.number().integer().optional(),
  from_date: listQuery.fromDate,
  to_date: listQuery.toDate
});

module.exports = { createNoteSchema, updateNoteSchema, listNotesQuerySchema };
