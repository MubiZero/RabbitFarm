const Joi = require('joi');
const listQuery = require('./listQuery');
const { normalizeTjPhone, isTjPhone } = require('../utils/phone');

/**
 * Телефон приглашаемого. Приводится к `+992XXXXXXXXX` прямо в схеме:
 * middleware валидации подменяет тело запроса разобранным значением, поэтому
 * дальше по коду номер уже в том виде, в котором его примет SMS-шлюз.
 */
const invitePhone = Joi.string()
  .custom((value, helpers) => {
    const normalized = normalizeTjPhone(value);
    return isTjPhone(normalized) ? normalized : helpers.error('string.pattern.base');
  })
  .messages({
    'string.pattern.base': 'Телефон должен быть таджикским номером: +992XXXXXXXXX'
  });

/**
 * Приглашение выписывается на email или на телефон — что-то одно.
 * Телефон нужен, чтобы позвать работника, у которого почты нет: код уходит
 * ему SMS-кой, а не диктуется голосом.
 */
const createInvitationSchema = Joi.object({
  email: Joi.string().email(),
  phone: invitePhone,
  role: Joi.string().valid('manager', 'worker').default('worker'),
  // Имя всегда называет владелец: приглашение активируется кодом прямо на
  // экране входа — что по телефону, что по почте, — и формы, где человек
  // представился бы сам, больше нет.
  full_name: Joi.string().max(255).required()
})
  .xor('email', 'phone')
  .messages({
    'object.missing': 'Укажите email или телефон работника',
    'object.xor': 'Укажите что-то одно — email или телефон',
    'any.required': 'Укажите имя приглашённого'
  });

const updateMemberSchema = Joi.object({
  role: Joi.string().valid('manager', 'worker'),
  is_active: Joi.boolean()
}).min(1);

const listAuditQuerySchema = Joi.object({
  page: listQuery.page,
  limit: listQuery.limit
});

module.exports = {
  createInvitationSchema,
  updateMemberSchema,
  listAuditQuerySchema
};
