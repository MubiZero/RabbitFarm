const rateLimit = require('express-rate-limit');
const ApiResponse = require('../utils/apiResponse');

// In test environment, use a no-op middleware to avoid rate limit interference
const noopMiddleware = (req, res, next) => next();
const isTest = process.env.NODE_ENV === 'test';

/**
 * General API rate limiter
 */
const generalLimiter = isTest ? noopMiddleware : rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000, // 15 minutes
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100,
  message: 'Too many requests from this IP, please try again later',
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req, res) => {
    ApiResponse.error(res, 'Слишком много запросов, попробуйте позже', 429, 'RATE_LIMIT_EXCEEDED');
  }
});

/**
 * Strict rate limiter for auth endpoints
 */
const authLimiter = isTest ? noopMiddleware : rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // 5 requests per window
  message: 'Слишком много попыток входа, попробуйте позже',
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req, res) => {
    ApiResponse.error(res, 'Слишком много попыток входа, попробуйте позже', 429, 'AUTH_RATE_LIMIT_EXCEEDED');
  }
});

/**
 * Вход по телефону — отдельный лимит на IP.
 *
 * `authLimiter` (5 запросов на 15 минут) задумывался под вход паролем, где
 * человек делает один-два запроса. Вход по коду из SMS — основной способ для
 * всех, и запросов в нём вдвое больше (запросить код, потом отправить его),
 * а на ферме телефоны сидят за одним Wi-Fi: три работника, вошедшие утром,
 * упирались в общий счётчик и получали «слишком много попыток» на пустом
 * месте — проверено живьём на докере 2026-09-11.
 *
 * Защита от перебора при этом не ослабляется: она и так стоит на самом
 * номере, а не на IP — 3 запроса кода на номер за 10 минут и лок после 5
 * неверных попыток (`otpAuthService`), плюс код живёт 10 минут.
 */
const otpLimiter = isTest ? noopMiddleware : rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 20,
  message: 'Слишком много попыток входа, попробуйте позже',
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req, res) => {
    ApiResponse.error(res, 'Слишком много попыток входа, попробуйте позже', 429, 'AUTH_RATE_LIMIT_EXCEEDED');
  }
});

/**
 * Upload rate limiter
 */
const uploadLimiter = isTest ? noopMiddleware : rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 20,
  message: 'Слишком много загрузок, попробуйте позже',
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req, res) => {
    ApiResponse.error(res, 'Слишком много загрузок, попробуйте позже', 429, 'UPLOAD_RATE_LIMIT_EXCEEDED');
  }
});

module.exports = {
  generalLimiter,
  authLimiter,
  otpLimiter,
  uploadLimiter
};
