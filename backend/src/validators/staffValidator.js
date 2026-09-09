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
  role: Joi.string().valid('manager', 'worker').default('worker')
})
  .xor('email', 'phone')
  .messages({
    'object.missing': 'Укажите email или телефон работника',
    'object.xor': 'Укажите что-то одно — email или телефон'
  });

const updateMemberSchema = Joi.object({
  role: Joi.string().valid('manager', 'worker'),
  is_active: Joi.boolean()
}).min(1);

/**
 * Вступление по коду. Email обязателен только для приглашения по телефону:
 * вход в сервис пока по адресу, и у такого приглашения его взять неоткуда.
 * Для приглашения по email присланный адрес не используется — иначе кодом,
 * выписанным на один адрес, заводили бы учётку на любой другой.
 */
const acceptInvitationSchema = Joi.object({
  code: Joi.string().required(),
  password: Joi.string().min(8).required(),
  full_name: Joi.string().max(255).required(),
  email: Joi.string().email().allow(null, ''),
  phone: Joi.string().max(20).allow(null, '')
});

const listAuditQuerySchema = Joi.object({
  page: listQuery.page,
  limit: listQuery.limit
});

module.exports = {
  createInvitationSchema,
  updateMemberSchema,
  acceptInvitationSchema,
  listAuditQuerySchema
};
