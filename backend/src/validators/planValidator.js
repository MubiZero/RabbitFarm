const Joi = require('joi');

const createPlanSchema = Joi.object({
  name: Joi.string().min(1).max(100).required(),
  max_rabbits: Joi.number().integer().positive().allow(null),
  max_staff: Joi.number().integer().positive().allow(null),
  price: Joi.number().min(0).allow(null),
  is_active: Joi.boolean(),
  is_default: Joi.boolean()
});

const updatePlanSchema = Joi.object({
  name: Joi.string().min(1).max(100),
  max_rabbits: Joi.number().integer().positive().allow(null),
  max_staff: Joi.number().integer().positive().allow(null),
  price: Joi.number().min(0).allow(null),
  is_active: Joi.boolean(),
  is_default: Joi.boolean()
}).min(1);

const assignPlanSchema = Joi.object({
  plan_id: Joi.number().integer().positive().allow(null).required()
});

module.exports = { createPlanSchema, updatePlanSchema, assignPlanSchema };
