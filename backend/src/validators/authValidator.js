const Joi = require('joi');

/**
 * Authentication validation schemas
 */

// Register validation
const registerSchema = Joi.object({
  email: Joi.string()
    .email()
    .required()
    .messages({
      'string.email': 'Неверный формат email',
      'any.required': 'Email обязателен'
    }),

  password: Joi.string()
    .min(8)
    .max(100)
    .required()
    .messages({
      'string.min': 'Пароль должен быть минимум 8 символов',
      'string.max': 'Пароль должен быть максимум 100 символов',
      'any.required': 'Пароль обязателен'
    }),

  full_name: Joi.string()
    .min(2)
    .max(255)
    .required()
    .messages({
      'string.min': 'Имя должно быть минимум 2 символа',
      'string.max': 'Имя должно быть максимум 255 символов',
      'any.required': 'Имя обязательно'
    }),

  phone: Joi.string()
    .pattern(/^[+]?[(]?[0-9]{1,3}[)]?[-\s.]?[(]?[0-9]{1,4}[)]?[-\s.]?[0-9]{1,4}[-\s.]?[0-9]{1,9}$/)
    .optional()
    .allow(null, '')
    .messages({
      'string.pattern.base': 'Неверный формат телефона'
    }),

  role: Joi.string()
    .valid('owner', 'manager', 'worker')
    .default('worker')
    .messages({
      'any.only': 'Роль должна быть: owner, manager или worker'
    })
});

// Login validation
const loginSchema = Joi.object({
  email: Joi.string()
    .email()
    .required()
    .messages({
      'string.email': 'Неверный формат email',
      'any.required': 'Email обязателен'
    }),

  password: Joi.string()
    .required()
    .messages({
      'any.required': 'Пароль обязателен'
    })
});

// Refresh token validation
const refreshTokenSchema = Joi.object({
  refresh_token: Joi.string()
    .required()
    .messages({
      'any.required': 'Refresh token обязателен'
    })
});

// Update profile validation
const updateProfileSchema = Joi.object({
  full_name: Joi.string()
    .min(2)
    .max(255)
    .optional()
    .messages({
      'string.min': 'Имя должно быть минимум 2 символа',
      'string.max': 'Имя должно быть максимум 255 символов'
    }),

  phone: Joi.string()
    .pattern(/^[+]?[(]?[0-9]{1,3}[)]?[-\s.]?[(]?[0-9]{1,4}[)]?[-\s.]?[0-9]{1,4}[-\s.]?[0-9]{1,9}$/)
    .optional()
    .allow(null, '')
    .messages({
      'string.pattern.base': 'Неверный формат телефона'
    }),

  avatar_url: Joi.string()
    .uri()
    .optional()
    .allow(null, '')
    .messages({
      'string.uri': 'Неверный формат URL'
    })
});

// Change password validation
const changePasswordSchema = Joi.object({
  current_password: Joi.string()
    .required()
    .messages({
      'any.required': 'Текущий пароль обязателен'
    }),

  new_password: Joi.string()
    .min(8)
    .max(100)
    .required()
    .invalid(Joi.ref('current_password'))
    .messages({
      'string.min': 'Новый пароль должен быть минимум 8 символов',
      'string.max': 'Новый пароль должен быть максимум 100 символов',
      'any.required': 'Новый пароль обязателен',
      'any.invalid': 'Новый пароль должен отличаться от текущего'
    })
});

module.exports = {
  registerSchema,
  loginSchema,
  refreshTokenSchema,
  updateProfileSchema,
  changePasswordSchema
};
