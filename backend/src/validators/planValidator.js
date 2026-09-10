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

// Точная дата, а не «плюс месяц» — ручное продление (4.1), не автоматическое
// по оплате.
const extendPlanSchema = Joi.object({
  plan_expires_at: Joi.date().iso().required()
});

// Причина обязательна — это единственное, что отличает в журнале осмысленный
// вход под клиентом от «зашёл посмотреть от скуки» (см. 3.2).
const impersonateFarmSchema = Joi.object({
  reason: Joi.string().min(1).max(500).required()
});

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

// Оба поля можно обнулить явным null — «канала пока нет», а не оставлять
// прежнее значение.
const updateSupportContactSchema = Joi.object({
  email: Joi.string().trim().email().allow(null),
  phone: Joi.string().trim().pattern(/^\+[0-9 ]{6,20}$/).allow(null).messages({
    'string.pattern.base': 'Телефон должен начинаться с "+" и содержать только цифры и пробелы'
  })
}).min(1);

module.exports = {
  createPlanSchema,
  updatePlanSchema,
  assignPlanSchema,
  updateFarmStatusSchema,
  updateFarmExtrasSchema,
  extendPlanSchema,
  impersonateFarmSchema,
  deleteFarmSchema,
  createAnnouncementSchema,
  updateSupportContactSchema
};
