const Joi = require('joi');

/**
 * Medical Record validation schemas
 */

/**
 * Create medical record validation schema
 */
const createMedicalRecordSchema = Joi.object({
  rabbit_id: Joi.number()
    .integer()
    .positive()
    .required()
    .messages({
      'number.base': 'ID кролика должен быть числом',
      'number.positive': 'ID кролика должен быть положительным',
      'any.required': 'ID кролика обязателен'
    }),

  symptoms: Joi.string()
    .max(1000)
    .required()
    .messages({
      'string.base': 'Симптомы должны быть строкой',
      'string.max': 'Симптомы не могут превышать 1000 символов',
      'any.required': 'Симптомы обязательны'
    }),

  diagnosis: Joi.string()
    .max(500)
    .allow(null, '')
    .messages({
      'string.base': 'Диагноз должен быть строкой',
      'string.max': 'Диагноз не может превышать 500 символов'
    }),

  treatment: Joi.string()
    .max(1000)
    .allow(null, '')
    .messages({
      'string.base': 'Лечение должно быть строкой',
      'string.max': 'Лечение не может превышать 1000 символов'
    }),

  medication: Joi.string()
    .max(500)
    .allow(null, '')
    .messages({
      'string.base': 'Препараты должны быть строкой',
      'string.max': 'Препараты не могут превышать 500 символов'
    }),

  dosage: Joi.string()
    .max(255)
    .allow(null, '')
    .messages({
      'string.base': 'Дозировка должна быть строкой',
      'string.max': 'Дозировка не может превышать 255 символов'
    }),

  started_at: Joi.date()
    .max('now')
    .required()
    .messages({
      'date.base': 'Дата начала должна быть корректной датой',
      'date.max': 'Дата начала не может быть в будущем',
      'any.required': 'Дата начала обязательна'
    }),

  ended_at: Joi.date()
    .min(Joi.ref('started_at'))
    .allow(null)
    .messages({
      'date.base': 'Дата окончания должна быть корректной датой',
      'date.min': 'Дата окончания не может быть раньше даты начала'
    }),

  outcome: Joi.string()
    .valid('recovered', 'ongoing', 'died', 'euthanized')
    .default('ongoing')
    .messages({
      'string.base': 'Исход должен быть строкой',
      'any.only': 'Исход должен быть одним из: recovered, ongoing, died, euthanized'
    }),

  cost: Joi.number()
    .precision(2)
    .min(0)
    .allow(null)
    .messages({
      'number.base': 'Стоимость должна быть числом',
      'number.min': 'Стоимость не может быть отрицательной',
      'number.precision': 'Стоимость может иметь до 2 знаков после запятой'
    }),

  veterinarian: Joi.string()
    .max(255)
    .allow(null, '')
    .messages({
      'string.base': 'Ветеринар должен быть строкой',
      'string.max': 'Ветеринар не может превышать 255 символов'
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
 * Update medical record validation schema
 * All fields are optional for update
 */
const updateMedicalRecordSchema = Joi.object({
  rabbit_id: Joi.number()
    .integer()
    .positive()
    .messages({
      'number.base': 'ID кролика должен быть числом',
      'number.positive': 'ID кролика должен быть положительным'
    }),

  symptoms: Joi.string()
    .max(1000)
    .messages({
      'string.base': 'Симптомы должны быть строкой',
      'string.max': 'Симптомы не могут превышать 1000 символов'
    }),

  diagnosis: Joi.string()
    .max(500)
    .allow(null, '')
    .messages({
      'string.base': 'Диагноз должен быть строкой',
      'string.max': 'Диагноз не может превышать 500 символов'
    }),

  treatment: Joi.string()
    .max(1000)
    .allow(null, '')
    .messages({
      'string.base': 'Лечение должно быть строкой',
      'string.max': 'Лечение не может превышать 1000 символов'
    }),

  medication: Joi.string()
    .max(500)
    .allow(null, '')
    .messages({
      'string.base': 'Препараты должны быть строкой',
      'string.max': 'Препараты не могут превышать 500 символов'
    }),

  dosage: Joi.string()
    .max(255)
    .allow(null, '')
    .messages({
      'string.base': 'Дозировка должна быть строкой',
      'string.max': 'Дозировка не может превышать 255 символов'
    }),

  started_at: Joi.date()
    .max('now')
    .messages({
      'date.base': 'Дата начала должна быть корректной датой',
      'date.max': 'Дата начала не может быть в будущем'
    }),

  ended_at: Joi.date()
    .when('started_at', {
      is: Joi.exist(),
      then: Joi.date().min(Joi.ref('started_at')),
      otherwise: Joi.date()
    })
    .allow(null)
    .messages({
      'date.base': 'Дата окончания должна быть корректной датой',
      'date.min': 'Дата окончания не может быть раньше даты начала'
    }),

  outcome: Joi.string()
    .valid('recovered', 'ongoing', 'died', 'euthanized')
    .messages({
      'string.base': 'Исход должен быть строкой',
      'any.only': 'Исход должен быть одним из: recovered, ongoing, died, euthanized'
    }),

  cost: Joi.number()
    .precision(2)
    .min(0)
    .allow(null)
    .messages({
      'number.base': 'Стоимость должна быть числом',
      'number.min': 'Стоимость не может быть отрицательной',
      'number.precision': 'Стоимость может иметь до 2 знаков после запятой'
    }),

  veterinarian: Joi.string()
    .max(255)
    .allow(null, '')
    .messages({
      'string.base': 'Ветеринар должен быть строкой',
      'string.max': 'Ветеринар не может превышать 255 символов'
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
 * Validation middleware for creating medical record
 */
const validateCreate = (req, res, next) => {
  const { error } = createMedicalRecordSchema.validate(req.body, {
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
 * Validation middleware for updating medical record
 */
const validateUpdate = (req, res, next) => {
  const { error } = updateMedicalRecordSchema.validate(req.body, {
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
  createMedicalRecordSchema,
  updateMedicalRecordSchema
};
