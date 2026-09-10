const Joi = require('joi');
const { normalizeTjPhone, isTjPhone } = require('../utils/phone');

/**
 * Authentication validation schemas
 */

const otpPhone = Joi.string()
  .custom((value, helpers) => {
    const normalized = normalizeTjPhone(value);
    return isTjPhone(normalized) ? normalized : helpers.error('string.pattern.base');
  })
  .messages({
    'string.pattern.base': 'Телефон должен быть таджикским номером: +992XXXXXXXXX',
    'any.required': 'Телефон обязателен'
  });

// Запрос кода входа по телефону
const requestOtpSchema = Joi.object({
  phone: otpPhone.required()
});

// Проверка кода входа по телефону
const verifyOtpSchema = Joi.object({
  phone: otpPhone.required(),
  code: Joi.string()
    .pattern(/^\d{6}$/)
    .required()
    .messages({
      'string.pattern.base': 'Код должен состоять из 6 цифр',
      'any.required': 'Код обязателен'
    })
});

// Первичная установка пароля тому, кто вошёл по OTP и ни разу его не задавал
const setPasswordSchema = Joi.object({
  new_password: Joi.string()
    .min(8)
    .max(100)
    .required()
    .messages({
      'string.min': 'Пароль должен быть минимум 8 символов',
      'string.max': 'Пароль должен быть максимум 100 символов',
      'any.required': 'Пароль обязателен'
    })
});

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

  // Не обязателен при регистрации — email+пароль сам по себе рабочий способ
  // входа (запасной, но полноценный). Кто хочет войти по SMS-коду, добавит
  // телефон позже через профиль (`updateProfileSchema` ниже) — заставлять
  // указывать его прямо на форме регистрации незачем.
  phone: otpPhone.optional().allow(null, ''),

  // Название хозяйства. Не обязательно: если его не прислали, ферма
  // называется по имени владельца — пустое название читалось бы в списках
  // как сбой, а не как «человек просто не заполнил».
  farm_name: Joi.string()
    .min(2)
    .max(255)
    .optional()
    .allow(null, '')
    .messages({
      'string.min': 'Название хозяйства должно быть минимум 2 символа',
      'string.max': 'Название хозяйства должно быть максимум 255 символов'
    }),

  // Роль здесь не принимается намеренно: её назначает сервис (регистрация
  // заводит новую ферму и делает регистрирующегося её владельцем, работники
  // приходят по приглашению). Схема раньше её принимала и по умолчанию
  // подставляла 'worker', создавая впечатление, что роль можно выбрать.
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
    }),

  // Единственная настройка уведомлений на сейчас (см.
  // notificationDigestJob.js) — включён/выключен ежедневный дайджест
  // (просроченные вакцинации, низкий остаток корма, задачи без исполнителя).
  // Персональный пуш по своей же задаче этим не выключается.
  digest_enabled: Joi.boolean().optional()
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

// Восстановление пароля по почте
const forgotPasswordSchema = Joi.object({
  email: Joi.string()
    .email()
    .required()
    .messages({
      'string.email': 'Неверный формат email',
      'any.required': 'Email обязателен'
    })
});

// Установка нового пароля по коду из SMS/email.
// Раньше маршрут шёл без валидации вовсе: пароль можно было задать любой
// длины в обход правила восьми символов, а запрос без токена уходил в 500.
const resetPasswordSchema = Joi.object({
  email: Joi.string()
    .email()
    .required()
    .messages({
      'string.email': 'Неверный формат email',
      'any.required': 'Email обязателен'
    }),

  code: Joi.string()
    .pattern(/^\d{6}$/)
    .required()
    .messages({
      'string.pattern.base': 'Код должен состоять из 6 цифр',
      'any.required': 'Код обязателен'
    }),

  new_password: Joi.string()
    .min(8)
    .max(100)
    .required()
    .messages({
      'string.min': 'Новый пароль должен быть минимум 8 символов',
      'string.max': 'Новый пароль должен быть максимум 100 символов',
      'any.required': 'Новый пароль обязателен'
    })
});

module.exports = {
  registerSchema,
  loginSchema,
  refreshTokenSchema,
  updateProfileSchema,
  changePasswordSchema,
  forgotPasswordSchema,
  resetPasswordSchema,
  requestOtpSchema,
  verifyOtpSchema,
  setPasswordSchema
};
