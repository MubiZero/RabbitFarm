const Joi = require('joi');

/**
 * Device token validation schemas
 */

const registerDeviceTokenSchema = Joi.object({
  token: Joi.string()
    .min(1)
    .max(255)
    .required()
    .messages({
      'string.base': 'Токен должен быть строкой',
      'string.max': 'Токен слишком длинный',
      'any.required': 'Токен обязателен'
    }),

  platform: Joi.string()
    .valid('android', 'ios')
    .required()
    .messages({
      'any.only': 'Платформа должна быть android или ios',
      'any.required': 'Платформа обязательна'
    })
});

const unregisterDeviceTokenSchema = Joi.object({
  token: Joi.string()
    .min(1)
    .max(255)
    .required()
    .messages({
      'string.base': 'Токен должен быть строкой',
      'any.required': 'Токен обязателен'
    })
});

module.exports = { registerDeviceTokenSchema, unregisterDeviceTokenSchema };
