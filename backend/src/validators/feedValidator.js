const Joi = require('joi');

/**
 * Feed validation schemas
 */

/**
 * Create feed validation schema
 */
const createFeedSchema = Joi.object({
  name: Joi.string()
    .max(255)
    .required()
    .messages({
      'string.base': 'Название должно быть строкой',
      'string.max': 'Название не может превышать 255 символов',
      'any.required': 'Название обязательно'
    }),

  type: Joi.string()
    .valid('pellets', 'hay', 'vegetables', 'grain', 'supplements', 'other')
    .required()
    .messages({
      'string.base': 'Тип должен быть строкой',
      'any.only': 'Тип должен быть одним из: pellets, hay, vegetables, grain, supplements, other',
      'any.required': 'Тип обязателен'
    }),

  brand: Joi.string()
    .max(255)
    .allow(null, '')
    .messages({
      'string.base': 'Бренд должен быть строкой',
      'string.max': 'Бренд не может превышать 255 символов'
    }),

  unit: Joi.string()
    .valid('kg', 'liter', 'piece')
    .default('kg')
    .messages({
      'string.base': 'Единица измерения должна быть строкой',
      'any.only': 'Единица измерения должна быть одной из: kg, liter, piece'
    }),

  current_stock: Joi.number()
    .precision(2)
    .min(0)
    .default(0)
    .messages({
      'number.base': 'Текущий запас должен быть числом',
      'number.min': 'Текущий запас не может быть отрицательным',
      'number.precision': 'Текущий запас может иметь до 2 знаков после запятой'
    }),

  min_stock: Joi.number()
    .precision(2)
    .min(0)
    .default(0)
    .messages({
      'number.base': 'Минимальный запас должен быть числом',
      'number.min': 'Минимальный запас не может быть отрицательным',
      'number.precision': 'Минимальный запас может иметь до 2 знаков после запятой'
    }),

  cost_per_unit: Joi.number()
    .precision(2)
    .min(0)
    .allow(null)
    .messages({
      'number.base': 'Цена за единицу должна быть числом',
      'number.min': 'Цена за единицу не может быть отрицательной',
      'number.precision': 'Цена за единицу может иметь до 2 знаков после запятой'
    }),

  notes: Joi.string()
    .max(2000)
    .allow(null, '')
    .messages({
      'string.base': 'Примечания должны быть строкой',
      'string.max': 'Примечания не могут превышать 2000 символов'
    })
});

/**
 * Update feed validation schema
 * All fields are optional for update
 */
const updateFeedSchema = Joi.object({
  name: Joi.string()
    .max(255)
    .messages({
      'string.base': 'Название должно быть строкой',
      'string.max': 'Название не может превышать 255 символов'
    }),

  type: Joi.string()
    .valid('pellets', 'hay', 'vegetables', 'grain', 'supplements', 'other')
    .messages({
      'string.base': 'Тип должен быть строкой',
      'any.only': 'Тип должен быть одним из: pellets, hay, vegetables, grain, supplements, other'
    }),

  brand: Joi.string()
    .max(255)
    .allow(null, '')
    .messages({
      'string.base': 'Бренд должен быть строкой',
      'string.max': 'Бренд не может превышать 255 символов'
    }),

  unit: Joi.string()
    .valid('kg', 'liter', 'piece')
    .messages({
      'string.base': 'Единица измерения должна быть строкой',
      'any.only': 'Единица измерения должна быть одной из: kg, liter, piece'
    }),

  current_stock: Joi.number()
    .precision(2)
    .min(0)
    .messages({
      'number.base': 'Текущий запас должен быть числом',
      'number.min': 'Текущий запас не может быть отрицательным',
      'number.precision': 'Текущий запас может иметь до 2 знаков после запятой'
    }),

  min_stock: Joi.number()
    .precision(2)
    .min(0)
    .messages({
      'number.base': 'Минимальный запас должен быть числом',
      'number.min': 'Минимальный запас не может быть отрицательным',
      'number.precision': 'Минимальный запас может иметь до 2 знаков после запятой'
    }),

  cost_per_unit: Joi.number()
    .precision(2)
    .min(0)
    .allow(null)
    .messages({
      'number.base': 'Цена за единицу должна быть числом',
      'number.min': 'Цена за единицу не может быть отрицательной',
      'number.precision': 'Цена за единицу может иметь до 2 знаков после запятой'
    }),

  notes: Joi.string()
    .max(2000)
    .allow(null, '')
    .messages({
      'string.base': 'Примечания должны быть строкой',
      'string.max': 'Примечания не могут превышать 2000 символов'
    })
}).min(1).messages({
  'object.min': 'Необходимо указать хотя бы одно поле для обновления'
});

/**
 * Adjust stock validation schema
 */
const adjustStockSchema = Joi.object({
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

  operation: Joi.string()
    .valid('add', 'subtract')
    .required()
    .messages({
      'string.base': 'Операция должна быть строкой',
      'any.only': 'Операция должна быть одной из: add, subtract',
      'any.required': 'Операция обязательна'
    })
});

/**
 * Validation middleware for creating feed
 */
const validateCreate = (req, res, next) => {
  const { error } = createFeedSchema.validate(req.body, {
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
 * Validation middleware for updating feed
 */
const validateUpdate = (req, res, next) => {
  const { error } = updateFeedSchema.validate(req.body, {
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
 * Validation middleware for adjusting stock
 */
const validateAdjustStock = (req, res, next) => {
  const { error } = adjustStockSchema.validate(req.body, {
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
  validateAdjustStock,
  createFeedSchema,
  updateFeedSchema,
  adjustStockSchema
};
