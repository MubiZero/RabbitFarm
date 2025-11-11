const Joi = require('joi');

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
}).custom((value, helpers) => {
  // Either rabbit_id or cage_id must be provided
  if (!value.rabbit_id && !value.cage_id) {
    return helpers.error('any.custom', {
      message: 'Необходимо указать либо кролика, либо клетку'
    });
  }
  return value;
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

/**
 * Validation middleware for creating feeding record
 */
const validateCreate = (req, res, next) => {
  const { error } = createFeedingRecordSchema.validate(req.body, {
    abortEarly: false,
    stripUnknown: true
  });

  if (error) {
    return res.status(400).json({
      success: false,
      message: 'Ошибка валидации',
      errors: error.details.map(detail => ({
        field: detail.path.join('.'),
        message: detail.message
      }))
    });
  }

  next();
};

/**
 * Validation middleware for updating feeding record
 */
const validateUpdate = (req, res, next) => {
  const { error } = updateFeedingRecordSchema.validate(req.body, {
    abortEarly: false,
    stripUnknown: true
  });

  if (error) {
    return res.status(400).json({
      success: false,
      message: 'Ошибка валидации',
      errors: error.details.map(detail => ({
        field: detail.path.join('.'),
        message: detail.message
      }))
    });
  }

  next();
};

module.exports = {
  validateCreate,
  validateUpdate,
  createFeedingRecordSchema,
  updateFeedingRecordSchema
};
