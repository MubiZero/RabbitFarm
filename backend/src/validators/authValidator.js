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

// Почта как контакт для входа: приводится к нижнему регистру там же, где и
// телефон к `+992…`, — иначе `Ivan@Farm.tj` и `ivan@farm.tj` были бы разными
// логинами.
const otpEmail = Joi.string()
  .email()
  .lowercase()
  .trim()
  .messages({
    'string.email': 'Неверный формат почты'
  });

// Контакт для кода: телефон (основной) или почта (запасная), ровно один.
const contactKeys = {
  phone: otpPhone,
  email: otpEmail
};

const contactRules = (schema) => schema
  .xor('phone', 'email')
  .messages({
    'object.missing': 'Укажите телефон или почту',
    'object.xor': 'Укажите что-то одно — телефон или почту'
  });

// Запрос кода входа
const requestOtpSchema = contactRules(Joi.object({ ...contactKeys }));

// Проверка кода входа
const verifyOtpSchema = contactRules(Joi.object({
  ...contactKeys,
  code: Joi.string()
    .pattern(/^\d{6}$/)
    .required()
    .messages({
      'string.pattern.base': 'Код должен состоять из 6 цифр',
      'any.required': 'Код обязателен'
    })
}));

// Register validation
const registerSchema = Joi.object({
  // Хотя бы один контакт: он же и логин, и единственный способ получить код
  // для входа. Телефон — основной путь, почта — запасной.
  phone: otpPhone.optional().allow(null, ''),
  email: otpEmail.optional().allow(null, ''),

  full_name: Joi.string()
    .min(2)
    .max(255)
    .required()
    .messages({
      'string.min': 'Имя должно быть минимум 2 символа',
      'string.max': 'Имя должно быть максимум 255 символов',
      'any.required': 'Имя обязательно'
    }),

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
    })

  // Роль здесь не принимается намеренно: её назначает сервис (регистрация
  // заводит новую ферму и делает регистрирующегося её владельцем, работники
  // приходят по приглашению).
})
  .or('phone', 'email')
  .messages({
    'object.missing': 'Укажите телефон или почту — на него придёт код для входа'
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

  // Тот же контакт, что и на входе: телефон — это логин, и ищется он строго
  // как `+992XXXXXXXXX`. Раньше здесь стоял общий международный шаблон без
  // приведения — номер, сохранённый как «992 18 666 33 33» или «+7…», при
  // входе просто не находился, и человек оставался за дверью собственного
  // аккаунта.
  phone: otpPhone.optional().allow(null, ''),

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

module.exports = {
  registerSchema,
  refreshTokenSchema,
  updateProfileSchema,
  requestOtpSchema,
  verifyOtpSchema
};
