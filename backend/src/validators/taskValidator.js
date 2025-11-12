const Joi = require('joi');

/**
 * Task validation schemas
 */

const TASK_TYPES = ['feeding', 'cleaning', 'vaccination', 'checkup', 'breeding', 'other'];
const TASK_STATUSES = ['pending', 'in_progress', 'completed', 'cancelled'];
const TASK_PRIORITIES = ['low', 'medium', 'high', 'urgent'];

/**
 * Create task validation schema
 */
const createTaskSchema = Joi.object({
  title: Joi.string()
    .max(255)
    .required()
    .messages({
      'string.base': 'Название должно быть строкой',
      'string.max': 'Название не может превышать 255 символов',
      'any.required': 'Название обязательно'
    }),

  description: Joi.string()
    .allow(null, '')
    .messages({
      'string.base': 'Описание должно быть строкой'
    }),

  type: Joi.string()
    .valid(...TASK_TYPES)
    .required()
    .messages({
      'string.base': 'Тип должен быть строкой',
      'any.only': 'Неверный тип задачи',
      'any.required': 'Тип задачи обязателен'
    }),

  status: Joi.string()
    .valid(...TASK_STATUSES)
    .default('pending')
    .messages({
      'string.base': 'Статус должен быть строкой',
      'any.only': 'Неверный статус задачи'
    }),

  priority: Joi.string()
    .valid(...TASK_PRIORITIES)
    .default('medium')
    .messages({
      'string.base': 'Приоритет должен быть строкой',
      'any.only': 'Неверный приоритет'
    }),

  due_date: Joi.date()
    .required()
    .messages({
      'date.base': 'Срок выполнения должен быть корректной датой',
      'any.required': 'Срок выполнения обязателен'
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
    }),

  assigned_to: Joi.number()
    .integer()
    .positive()
    .allow(null)
    .messages({
      'number.base': 'ID исполнителя должен быть числом',
      'number.positive': 'ID исполнителя должен быть положительным'
    }),

  is_recurring: Joi.boolean()
    .default(false)
    .messages({
      'boolean.base': 'Повторяемость должна быть boolean'
    }),

  recurrence_rule: Joi.string()
    .max(255)
    .allow(null, '')
    .messages({
      'string.base': 'Правило повторения должно быть строкой',
      'string.max': 'Правило повторения не может превышать 255 символов'
    }),

  reminder_before: Joi.number()
    .integer()
    .positive()
    .allow(null)
    .messages({
      'number.base': 'Напоминание должно быть числом',
      'number.positive': 'Напоминание должно быть положительным'
    }),

  notes: Joi.string()
    .allow(null, '')
    .messages({
      'string.base': 'Примечания должны быть строкой'
    })
});

/**
 * Update task validation schema
 * All fields are optional for update
 */
const updateTaskSchema = Joi.object({
  title: Joi.string()
    .max(255)
    .messages({
      'string.base': 'Название должно быть строкой',
      'string.max': 'Название не может превышать 255 символов'
    }),

  description: Joi.string()
    .allow(null, '')
    .messages({
      'string.base': 'Описание должно быть строкой'
    }),

  type: Joi.string()
    .valid(...TASK_TYPES)
    .messages({
      'string.base': 'Тип должен быть строкой',
      'any.only': 'Неверный тип задачи'
    }),

  status: Joi.string()
    .valid(...TASK_STATUSES)
    .messages({
      'string.base': 'Статус должен быть строкой',
      'any.only': 'Неверный статус задачи'
    }),

  priority: Joi.string()
    .valid(...TASK_PRIORITIES)
    .messages({
      'string.base': 'Приоритет должен быть строкой',
      'any.only': 'Неверный приоритет'
    }),

  due_date: Joi.date()
    .messages({
      'date.base': 'Срок выполнения должен быть корректной датой'
    }),

  completed_at: Joi.date()
    .allow(null)
    .messages({
      'date.base': 'Дата выполнения должна быть корректной датой'
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
    }),

  assigned_to: Joi.number()
    .integer()
    .positive()
    .allow(null)
    .messages({
      'number.base': 'ID исполнителя должен быть числом',
      'number.positive': 'ID исполнителя должен быть положительным'
    }),

  is_recurring: Joi.boolean()
    .messages({
      'boolean.base': 'Повторяемость должна быть boolean'
    }),

  recurrence_rule: Joi.string()
    .max(255)
    .allow(null, '')
    .messages({
      'string.base': 'Правило повторения должно быть строкой',
      'string.max': 'Правило повторения не может превышать 255 символов'
    }),

  reminder_before: Joi.number()
    .integer()
    .positive()
    .allow(null)
    .messages({
      'number.base': 'Напоминание должно быть числом',
      'number.positive': 'Напоминание должно быть положительным'
    }),

  notes: Joi.string()
    .allow(null, '')
    .messages({
      'string.base': 'Примечания должны быть строкой'
    })
}).min(1).messages({
  'object.min': 'Необходимо указать хотя бы одно поле для обновления'
});

/**
 * Validation middleware for creating task
 */
const validateCreate = (req, res, next) => {
  const { error } = createTaskSchema.validate(req.body, {
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
 * Validation middleware for updating task
 */
const validateUpdate = (req, res, next) => {
  const { error } = updateTaskSchema.validate(req.body, {
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
  createTaskSchema,
  updateTaskSchema,
  TASK_TYPES,
  TASK_STATUSES,
  TASK_PRIORITIES
};
