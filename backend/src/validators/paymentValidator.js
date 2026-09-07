const Joi = require('joi');

const createPaymentSchema = Joi.object({
  amount: Joi.number()
    .positive()
    .precision(2)
    .required()
    .messages({
      'number.base': 'Сумма должна быть числом',
      'number.positive': 'Сумма должна быть положительной',
      'any.required': 'Сумма обязательна'
    }),

  description: Joi.string()
    .max(255)
    .allow('')
    .messages({
      'string.max': 'Описание слишком длинное'
    })
});

module.exports = { createPaymentSchema };
