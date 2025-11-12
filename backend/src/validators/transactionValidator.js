const Joi = require('joi');

/**
 * Transaction validation schemas
 */

const TRANSACTION_TYPES = ['income', 'expense'];
const TRANSACTION_CATEGORIES = [
  'sale_rabbit',
  'sale_meat',
  'sale_fur',
  'breeding_fee',
  'feed',
  'veterinary',
  'equipment',
  'utilities',
  'other'
];

/**
 * Create transaction validation schema
 */
const createTransactionSchema = Joi.object({
  type: Joi.string()
    .valid(...TRANSACTION_TYPES)
    .required()
    .messages({
      'string.base': 'Тип должен быть строкой',
      'any.only': 'Тип должен быть income или expense',
      'any.required': 'Тип обязателен'
    }),

  category: Joi.string()
    .valid(...TRANSACTION_CATEGORIES)
    .required()
    .messages({
      'string.base': 'Категория должна быть строкой',
      'any.only': 'Неверная категория',
      'any.required': 'Категория обязательна'
    }),

  amount: Joi.number()
    .precision(2)
    .positive()
    .required()
    .messages({
      'number.base': 'Сумма должна быть числом',
      'number.positive': 'Сумма должна быть положительной',
      'number.precision': 'Сумма может иметь до 2 знаков после запятой',
      'any.required': 'Сумма обязательна'
    }),

  transaction_date: Joi.date()
    .required()
    .messages({
      'date.base': 'Дата транзакции должна быть корректной датой',
      'any.required': 'Дата транзакции обязательна'
    }),

  rabbit_id: Joi.number()
    .integer()
    .positive()
    .allow(null)
    .messages({
      'number.base': 'ID кролика должен быть числом',
      'number.positive': 'ID кролика должен быть положительным'
    }),

  description: Joi.string()
    .max(2000)
    .allow(null, '')
    .messages({
      'string.base': 'Описание должно быть строкой',
      'string.max': 'Описание не может превышать 2000 символов'
    }),

  receipt_url: Joi.string()
    .uri()
    .max(500)
    .allow(null, '')
    .messages({
      'string.base': 'URL чека должен быть строкой',
      'string.uri': 'URL чека должен быть корректным URL',
      'string.max': 'URL чека не может превышать 500 символов'
    })
});

/**
 * Update transaction validation schema
 * All fields are optional for update
 */
const updateTransactionSchema = Joi.object({
  type: Joi.string()
    .valid(...TRANSACTION_TYPES)
    .messages({
      'string.base': 'Тип должен быть строкой',
      'any.only': 'Тип должен быть income или expense'
    }),

  category: Joi.string()
    .valid(...TRANSACTION_CATEGORIES)
    .messages({
      'string.base': 'Категория должна быть строкой',
      'any.only': 'Неверная категория'
    }),

  amount: Joi.number()
    .precision(2)
    .positive()
    .messages({
      'number.base': 'Сумма должна быть числом',
      'number.positive': 'Сумма должна быть положительной',
      'number.precision': 'Сумма может иметь до 2 знаков после запятой'
    }),

  transaction_date: Joi.date()
    .messages({
      'date.base': 'Дата транзакции должна быть корректной датой'
    }),

  rabbit_id: Joi.number()
    .integer()
    .positive()
    .allow(null)
    .messages({
      'number.base': 'ID кролика должен быть числом',
      'number.positive': 'ID кролика должен быть положительным'
    }),

  description: Joi.string()
    .max(2000)
    .allow(null, '')
    .messages({
      'string.base': 'Описание должно быть строкой',
      'string.max': 'Описание не может превышать 2000 символов'
    }),

  receipt_url: Joi.string()
    .uri()
    .max(500)
    .allow(null, '')
    .messages({
      'string.base': 'URL чека должен быть строкой',
      'string.uri': 'URL чека должен быть корректным URL',
      'string.max': 'URL чека не может превышать 500 символов'
    })
}).min(1).messages({
  'object.min': 'Необходимо указать хотя бы одно поле для обновления'
});

/**
 * Validation middleware for creating transaction
 */
const validateCreate = (req, res, next) => {
  const { error } = createTransactionSchema.validate(req.body, {
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
 * Validation middleware for updating transaction
 */
const validateUpdate = (req, res, next) => {
  const { error } = updateTransactionSchema.validate(req.body, {
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
  createTransactionSchema,
  updateTransactionSchema,
  TRANSACTION_TYPES,
  TRANSACTION_CATEGORIES
};
