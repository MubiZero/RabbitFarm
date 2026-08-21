const Joi = require('joi');

const createInvitationSchema = Joi.object({
  email: Joi.string().email().required(),
  role: Joi.string().valid('manager', 'worker').default('worker')
});

const updateMemberSchema = Joi.object({
  role: Joi.string().valid('manager', 'worker'),
  is_active: Joi.boolean()
}).min(1);

const acceptInvitationSchema = Joi.object({
  code: Joi.string().required(),
  password: Joi.string().min(8).required(),
  full_name: Joi.string().max(255).required(),
  phone: Joi.string().max(20).allow(null, '')
});

module.exports = { createInvitationSchema, updateMemberSchema, acceptInvitationSchema };
