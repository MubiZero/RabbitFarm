const Joi = require('joi');

/**
 * Cage validation schemas
 */

// Create cage validation
const createCageSchema = Joi.object({
  number: Joi.string()
    .max(50)
    .required()
    .messages({
      'string.max': 'Номер клетки должен быть максимум 50 символов',
      'any.required': 'Номер клетки обязателен'
    }),

  type: Joi.string()
    .valid('single', 'group', 'maternity')
    .default('single')
    .messages({
      'any.only': 'Тип клетки должен быть: single, group или maternity'
    }),

  size: Joi.string()
    .max(50)
    .optional()
    .allow(null, '')
    .messages({
      'string.max': 'Размер должен быть максимум 50 символов'
    }),

  capacity: Joi.number()
    .integer()
    .min(1)
    .default(1)
    .messages({
      'number.base': 'Вместимость должна быть числом',
      'number.min': 'Вместимость должна быть минимум 1'
    }),

  location: Joi.string()
    .max(255)
    .optional()
    .allow(null, '')
    .messages({
      'string.max': 'Локация должна быть максимум 255 символов'
    }),

  condition: Joi.string()
    .valid('good', 'needs_repair', 'broken')
    .default('good')
    .messages({
      'any.only': 'Состояние должно быть: good, needs_repair или broken'
    }),

  last_cleaned_at: Joi.date()
    .max('now')
    .optional()
    .allow(null)
    .messages({
      'date.base': 'Неверная дата уборки',
      'date.max': 'Дата уборки не может быть в будущем'
    }),

  notes: Joi.string()
    .optional()
    .allow(null, '')
});

// Update cage validation (все поля опциональны)
const updateCageSchema = Joi.object({
  number: Joi.string()
    .max(50)
    .optional()
    .messages({
      'string.max': 'Номер клетки должен быть максимум 50 символов'
    }),

  type: Joi.string()
    .valid('single', 'group', 'maternity')
    .optional()
    .messages({
      'any.only': 'Тип клетки должен быть: single, group или maternity'
    }),

  size: Joi.string()
    .max(50)
    .optional()
    .allow(null, '')
    .messages({
      'string.max': 'Размер должен быть максимум 50 символов'
    }),

  capacity: Joi.number()
    .integer()
    .min(1)
    .optional()
    .messages({
      'number.base': 'Вместимость должна быть числом',
      'number.min': 'Вместимость должна быть минимум 1'
    }),

  location: Joi.string()
    .max(255)
    .optional()
    .allow(null, '')
    .messages({
      'string.max': 'Локация должна быть максимум 255 символов'
    }),

  condition: Joi.string()
    .valid('good', 'needs_repair', 'broken')
    .optional()
    .messages({
      'any.only': 'Состояние должно быть: good, needs_repair или broken'
    }),

  last_cleaned_at: Joi.date()
    .max('now')
    .optional()
    .allow(null)
    .messages({
      'date.base': 'Неверная дата уборки',
      'date.max': 'Дата уборки не может быть в будущем'
    }),

  notes: Joi.string()
    .optional()
    .allow(null, '')
});

// Query parameters for listing cages
const listCagesQuerySchema = Joi.object({
  page: Joi.number()
    .integer()
    .min(1)
    .default(1)
    .messages({
      'number.base': 'Страница должна быть числом',
      'number.min': 'Страница должна быть минимум 1'
    }),

  limit: Joi.number()
    .integer()
    .min(1)
    .max(100)
    .default(50)
    .messages({
      'number.base': 'Лимит должен быть числом',
      'number.min': 'Лимит должен быть минимум 1',
      'number.max': 'Лимит должен быть максимум 100'
    }),

  type: Joi.string()
    .valid('single', 'group', 'maternity')
    .optional()
    .messages({
      'any.only': 'Тип клетки должен быть: single, group или maternity'
    }),

  condition: Joi.string()
    .valid('good', 'needs_repair', 'broken')
    .optional()
    .messages({
      'any.only': 'Состояние должно быть: good, needs_repair или broken'
    }),

  location: Joi.string()
    .max(255)
    .optional()
    .messages({
      'string.max': 'Локация должна быть максимум 255 символов'
    }),

  search: Joi.string()
    .max(100)
    .optional()
    .messages({
      'string.max': 'Поиск должен быть максимум 100 символов'
    }),

  only_available: Joi.boolean()
    .optional()
    .messages({
      'boolean.base': 'only_available должен быть булевым значением'
    }),

  sort_by: Joi.string()
    .valid('number', 'type', 'capacity', 'location', 'condition', 'last_cleaned_at', 'created_at')
    .default('number')
    .messages({
      'any.only': 'Сортировка должна быть: number, type, capacity, location, condition, last_cleaned_at или created_at'
    }),

  sort_order: Joi.string()
    .valid('asc', 'desc', 'ASC', 'DESC')
    .default('ASC')
    .messages({
      'any.only': 'Порядок должен быть: asc или desc'
    })
});

module.exports = {
  createCageSchema,
  updateCageSchema,
  listCagesQuerySchema
};
