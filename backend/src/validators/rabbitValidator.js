const Joi = require('joi');

/**
 * Rabbit validation schemas
 */

// Create rabbit validation
const createRabbitSchema = Joi.object({
  tag_id: Joi.string()
    .max(50)
    .optional()
    .allow(null, '')
    .messages({
      'string.max': 'ID клейма должен быть максимум 50 символов'
    }),

  name: Joi.string()
    .max(100)
    .optional()
    .allow(null, '')
    .messages({
      'string.max': 'Имя должно быть максимум 100 символов'
    }),

  breed_id: Joi.number()
    .integer()
    .positive()
    .required()
    .messages({
      'number.base': 'ID породы должен быть числом',
      'number.positive': 'ID породы должен быть положительным',
      'any.required': 'Порода обязательна'
    }),

  sex: Joi.string()
    .valid('male', 'female')
    .required()
    .messages({
      'any.only': 'Пол должен быть: male или female',
      'any.required': 'Пол обязателен'
    }),

  birth_date: Joi.date()
    .max('now')
    .required()
    .messages({
      'date.base': 'Неверная дата рождения',
      'date.max': 'Дата рождения не может быть в будущем',
      'any.required': 'Дата рождения обязательна'
    }),

  color: Joi.string()
    .max(100)
    .optional()
    .allow(null, '')
    .messages({
      'string.max': 'Окрас должен быть максимум 100 символов'
    }),

  cage_id: Joi.number()
    .integer()
    .positive()
    .optional()
    .allow(null)
    .messages({
      'number.base': 'ID клетки должен быть числом',
      'number.positive': 'ID клетки должен быть положительным'
    }),

  father_id: Joi.number()
    .integer()
    .positive()
    .optional()
    .allow(null)
    .messages({
      'number.base': 'ID отца должен быть числом',
      'number.positive': 'ID отца должен быть положительным'
    }),

  mother_id: Joi.number()
    .integer()
    .positive()
    .optional()
    .allow(null)
    .messages({
      'number.base': 'ID матери должен быть числом',
      'number.positive': 'ID матери должен быть положительным'
    }),

  status: Joi.string()
    .valid('healthy', 'sick', 'quarantine', 'pregnant', 'sold', 'dead')
    .default('healthy')
    .messages({
      'any.only': 'Статус должен быть: healthy, sick, quarantine, pregnant, sold или dead'
    }),

  purpose: Joi.string()
    .valid('breeding', 'meat', 'sale', 'show')
    .default('breeding')
    .messages({
      'any.only': 'Назначение должно быть: breeding, meat, sale или show'
    }),

  acquired_date: Joi.date()
    .max('now')
    .optional()
    .allow(null)
    .messages({
      'date.base': 'Неверная дата приобретения',
      'date.max': 'Дата приобретения не может быть в будущем'
    }),

  current_weight: Joi.number()
    .positive()
    .max(20)
    .optional()
    .allow(null)
    .messages({
      'number.base': 'Вес должен быть числом',
      'number.positive': 'Вес должен быть положительным',
      'number.max': 'Вес не может быть больше 20 кг'
    }),

  temperament: Joi.string()
    .max(100)
    .optional()
    .allow(null, '')
    .messages({
      'string.max': 'Характер должен быть максимум 100 символов'
    }),

  notes: Joi.string()
    .optional()
    .allow(null, '')
});

// Update rabbit validation (все поля опциональны)
const updateRabbitSchema = Joi.object({
  tag_id: Joi.string()
    .max(50)
    .optional()
    .allow(null, ''),

  name: Joi.string()
    .max(100)
    .optional()
    .allow(null, ''),

  breed_id: Joi.number()
    .integer()
    .positive()
    .optional(),

  sex: Joi.string()
    .valid('male', 'female')
    .optional(),

  birth_date: Joi.date()
    .max('now')
    .optional(),

  color: Joi.string()
    .max(100)
    .optional()
    .allow(null, ''),

  cage_id: Joi.number()
    .integer()
    .positive()
    .optional()
    .allow(null),

  father_id: Joi.number()
    .integer()
    .positive()
    .optional()
    .allow(null),

  mother_id: Joi.number()
    .integer()
    .positive()
    .optional()
    .allow(null),

  status: Joi.string()
    .valid('healthy', 'sick', 'quarantine', 'pregnant', 'sold', 'dead')
    .optional(),

  purpose: Joi.string()
    .valid('breeding', 'meat', 'sale', 'show')
    .optional(),

  acquired_date: Joi.date()
    .max('now')
    .optional()
    .allow(null),

  sold_date: Joi.date()
    .max('now')
    .optional()
    .allow(null),

  death_date: Joi.date()
    .max('now')
    .optional()
    .allow(null),

  death_reason: Joi.string()
    .max(255)
    .optional()
    .allow(null, ''),

  current_weight: Joi.number()
    .positive()
    .max(20)
    .optional()
    .allow(null),

  temperament: Joi.string()
    .max(100)
    .optional()
    .allow(null, ''),

  notes: Joi.string()
    .optional()
    .allow(null, '')
});

// Query parameters for listing rabbits
const listRabbitsQuerySchema = Joi.object({
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
    .default(20)
    .messages({
      'number.base': 'Лимит должен быть числом',
      'number.min': 'Лимит должен быть минимум 1',
      'number.max': 'Лимит должен быть максимум 100'
    }),

  breed_id: Joi.number()
    .integer()
    .positive()
    .optional()
    .messages({
      'number.base': 'ID породы должен быть числом'
    }),

  sex: Joi.string()
    .valid('male', 'female')
    .optional()
    .messages({
      'any.only': 'Пол должен быть: male или female'
    }),

  status: Joi.string()
    .valid('healthy', 'sick', 'quarantine', 'pregnant', 'sold', 'dead')
    .optional()
    .messages({
      'any.only': 'Неверный статус'
    }),

  purpose: Joi.string()
    .valid('breeding', 'meat', 'sale', 'show')
    .optional()
    .messages({
      'any.only': 'Неверное назначение'
    }),

  cage_id: Joi.number()
    .integer()
    .positive()
    .optional()
    .messages({
      'number.base': 'ID клетки должен быть числом'
    }),

  search: Joi.string()
    .max(100)
    .optional()
    .messages({
      'string.max': 'Поиск должен быть максимум 100 символов'
    }),

  sort_by: Joi.string()
    .valid('birth_date', 'name', 'created_at', 'current_weight')
    .default('created_at')
    .messages({
      'any.only': 'Сортировка должна быть: birth_date, name, created_at или current_weight'
    }),

  sort_order: Joi.string()
    .valid('asc', 'desc')
    .default('desc')
    .messages({
      'any.only': 'Порядок должен быть: asc или desc'
    })
});

// Add weight record validation
const addWeightSchema = Joi.object({
  weight: Joi.number()
    .positive()
    .max(20)
    .required()
    .messages({
      'number.base': 'Вес должен быть числом',
      'number.positive': 'Вес должен быть положительным',
      'number.max': 'Вес не может быть больше 20 кг',
      'any.required': 'Вес обязателен'
    }),

  measured_at: Joi.date()
    .max('now')
    .default(new Date())
    .messages({
      'date.base': 'Неверная дата измерения',
      'date.max': 'Дата измерения не может быть в будущем'
    }),

  notes: Joi.string()
    .optional()
    .allow(null, '')
});

module.exports = {
  createRabbitSchema,
  updateRabbitSchema,
  listRabbitsQuerySchema,
  addWeightSchema
};
