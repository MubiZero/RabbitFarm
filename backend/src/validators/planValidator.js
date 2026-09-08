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

const updateFarmStatusSchema = Joi.object({
  status: Joi.string().valid('active', 'read_only', 'suspended').required()
});

// null в любом из полей — снять поблажку по этому ресурсу; пустой
// `extras_until` при ненулевой поблажке означает «бессрочно».
const updateFarmExtrasSchema = Joi.object({
  extra_rabbits: Joi.number().integer().positive().allow(null),
  extra_staff: Joi.number().integer().positive().allow(null),
  extras_until: Joi.date().iso().allow(null)
}).min(1);

// Название фермы набирают руками как подтверждение удаления. Схема требует
// поле, а совпадение проверяет сервис: клиентской проверке здесь доверять
// нельзя — именно она отличает случайный вызов API от намеренного.
const deleteFarmSchema = Joi.object({
  confirm_name: Joi.string().min(1).required()
});

module.exports = {
  createPlanSchema,
  updatePlanSchema,
  assignPlanSchema,
  updateFarmStatusSchema,
  updateFarmExtrasSchema,
  deleteFarmSchema
};
