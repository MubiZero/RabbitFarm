const Joi = require('joi');

const createBreedingSchema = Joi.object({
  male_id: Joi.number().integer().required().messages({
    'number.base': 'ID самца должен быть числом',
    'any.required': 'ID самца обязателен'
  }),
  female_id: Joi.number().integer().required().messages({
    'number.base': 'ID самки должен быть числом',
    'any.required': 'ID самки обязателен'
  }),
  breeding_date: Joi.date().iso().required().messages({
    'date.base': 'Дата случки должна быть корректной датой',
    'date.format': 'Дата случки должна быть в формате ISO (YYYY-MM-DD)',
    'any.required': 'Дата случки обязательна'
  }),
  status: Joi.string().valid('planned', 'completed', 'failed', 'cancelled').default('planned').messages({
    'any.only': 'Статус должен быть одним из: planned, completed, failed, cancelled'
  }),
  notes: Joi.string().allow('', null).max(1000).messages({
    'string.max': 'Заметки не могут превышать 1000 символов'
  })
});

const updateBreedingSchema = Joi.object({
  male_id: Joi.number().integer(),
  female_id: Joi.number().integer(),
  breeding_date: Joi.date().iso(),
  status: Joi.string().valid('planned', 'completed', 'failed', 'cancelled'),
  palpation_date: Joi.date().iso().allow(null),
  is_pregnant: Joi.boolean().allow(null),
  expected_birth_date: Joi.date().iso().allow(null),
  notes: Joi.string().allow('', null).max(1000)
});

const listBreedingsQuerySchema = Joi.object({
  page: Joi.number().integer().min(1).default(1),
  limit: Joi.number().integer().min(1).max(100).default(20),
  sort_by: Joi.string().valid('breeding_date', 'created_at', 'status').default('created_at'),
  sort_order: Joi.string().valid('asc', 'desc', 'ASC', 'DESC').default('desc'),
  status: Joi.string().valid('planned', 'completed', 'failed', 'cancelled'),
  male_id: Joi.number().integer(),
  female_id: Joi.number().integer(),
  from_date: Joi.date().iso(),
  to_date: Joi.date().iso()
});

module.exports = {
  createBreedingSchema,
  updateBreedingSchema,
  listBreedingsQuerySchema
};
