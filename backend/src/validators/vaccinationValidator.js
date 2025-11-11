const Joi = require('joi');

/**
 * Vaccination validation schemas
 */

// Create vaccination validation
const createVaccinationSchema = Joi.object({
  rabbit_id: Joi.number()
    .integer()
    .required()
    .messages({
      'number.base': 'ID кролика должен быть числом',
      'any.required': 'ID кролика обязателен'
    }),

  vaccine_name: Joi.string()
    .max(255)
    .required()
    .messages({
      'string.max': 'Название вакцины должно быть максимум 255 символов',
      'any.required': 'Название вакцины обязательно'
    }),

  vaccine_type: Joi.string()
    .valid('vhd', 'myxomatosis', 'pasteurellosis', 'other')
    .required()
    .messages({
      'any.only': 'Тип вакцины должен быть: vhd, myxomatosis, pasteurellosis или other',
      'any.required': 'Тип вакцины обязателен'
    }),

  vaccination_date: Joi.date()
    .max('now')
    .required()
    .messages({
      'date.base': 'Неверная дата вакцинации',
      'date.max': 'Дата вакцинации не может быть в будущем',
      'any.required': 'Дата вакцинации обязательна'
    }),

  next_vaccination_date: Joi.date()
    .min(Joi.ref('vaccination_date'))
    .optional()
    .allow(null)
    .messages({
      'date.base': 'Неверная дата следующей вакцинации',
      'date.min': 'Следующая вакцинация должна быть после текущей'
    }),

  batch_number: Joi.string()
    .max(100)
    .optional()
    .allow(null, '')
    .messages({
      'string.max': 'Номер партии должен быть максимум 100 символов'
    }),

  veterinarian: Joi.string()
    .max(255)
    .optional()
    .allow(null, '')
    .messages({
      'string.max': 'Имя ветеринара должно быть максимум 255 символов'
    }),

  notes: Joi.string()
    .optional()
    .allow(null, '')
});

// Update vaccination validation (все поля опциональны)
const updateVaccinationSchema = Joi.object({
  rabbit_id: Joi.number()
    .integer()
    .optional()
    .messages({
      'number.base': 'ID кролика должен быть числом'
    }),

  vaccine_name: Joi.string()
    .max(255)
    .optional()
    .messages({
      'string.max': 'Название вакцины должно быть максимум 255 символов'
    }),

  vaccine_type: Joi.string()
    .valid('vhd', 'myxomatosis', 'pasteurellosis', 'other')
    .optional()
    .messages({
      'any.only': 'Тип вакцины должен быть: vhd, myxomatosis, pasteurellosis или other'
    }),

  vaccination_date: Joi.date()
    .max('now')
    .optional()
    .messages({
      'date.base': 'Неверная дата вакцинации',
      'date.max': 'Дата вакцинации не может быть в будущем'
    }),

  next_vaccination_date: Joi.date()
    .optional()
    .allow(null)
    .messages({
      'date.base': 'Неверная дата следующей вакцинации'
    }),

  batch_number: Joi.string()
    .max(100)
    .optional()
    .allow(null, '')
    .messages({
      'string.max': 'Номер партии должен быть максимум 100 символов'
    }),

  veterinarian: Joi.string()
    .max(255)
    .optional()
    .allow(null, '')
    .messages({
      'string.max': 'Имя ветеринара должно быть максимум 255 символов'
    }),

  notes: Joi.string()
    .optional()
    .allow(null, '')
});

// Query parameters for listing vaccinations
const listVaccinationsQuerySchema = Joi.object({
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

  rabbit_id: Joi.number()
    .integer()
    .optional()
    .messages({
      'number.base': 'ID кролика должен быть числом'
    }),

  vaccine_type: Joi.string()
    .valid('vhd', 'myxomatosis', 'pasteurellosis', 'other')
    .optional()
    .messages({
      'any.only': 'Тип вакцины должен быть: vhd, myxomatosis, pasteurellosis или other'
    }),

  from_date: Joi.date()
    .optional()
    .messages({
      'date.base': 'Неверная дата начала периода'
    }),

  to_date: Joi.date()
    .min(Joi.ref('from_date'))
    .optional()
    .messages({
      'date.base': 'Неверная дата окончания периода',
      'date.min': 'Дата окончания должна быть после даты начала'
    }),

  upcoming: Joi.boolean()
    .optional()
    .messages({
      'boolean.base': 'upcoming должен быть булевым значением'
    }),

  sort_by: Joi.string()
    .valid('vaccination_date', 'next_vaccination_date', 'vaccine_type', 'vaccine_name', 'created_at')
    .default('vaccination_date')
    .messages({
      'any.only': 'Сортировка должна быть: vaccination_date, next_vaccination_date, vaccine_type, vaccine_name или created_at'
    }),

  sort_order: Joi.string()
    .valid('asc', 'desc', 'ASC', 'DESC')
    .default('DESC')
    .messages({
      'any.only': 'Порядок должен быть: asc или desc'
    })
});

// Query parameters for upcoming vaccinations
const upcomingVaccinationsQuerySchema = Joi.object({
  days: Joi.number()
    .integer()
    .min(1)
    .max(365)
    .default(30)
    .messages({
      'number.base': 'Количество дней должно быть числом',
      'number.min': 'Минимум 1 день',
      'number.max': 'Максимум 365 дней'
    })
});

module.exports = {
  createVaccinationSchema,
  updateVaccinationSchema,
  listVaccinationsQuerySchema,
  upcomingVaccinationsQuerySchema
};
