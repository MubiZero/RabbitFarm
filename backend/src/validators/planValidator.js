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

// SMS сюда не входит — шлюз Payom принимает только заранее одобренные
// шаблоны, свободный текст объявления через него не отправить (см.
// announcementService.js).
const createAnnouncementSchema = Joi.object({
  title: Joi.string().min(1).max(255).required(),
  body: Joi.string().min(1).max(4000).required(),
  channels: Joi.array().items(Joi.string().valid('push', 'email')).min(1).required(),
  target_type: Joi.string().valid('all', 'farm', 'filter').required(),
  target_farm_id: Joi.number().integer().positive()
    .when('target_type', { is: 'farm', then: Joi.required(), otherwise: Joi.forbidden() }),
  target_filter: Joi.string().valid('no_plan', 'at_limit', 'suspended', 'expired', 'inactive_days')
    .when('target_type', { is: 'filter', then: Joi.required(), otherwise: Joi.forbidden() })
});

module.exports = {
  createPlanSchema,
  updatePlanSchema,
  assignPlanSchema,
  updateFarmStatusSchema,
  updateFarmExtrasSchema,
  deleteFarmSchema,
  createAnnouncementSchema
};
