const rateLimit = require('express-rate-limit');
const ApiResponse = require('../utils/apiResponse');

/**
 * General API rate limiter
 */
const generalLimiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000, // 15 minutes
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100,
  message: 'Too many requests from this IP, please try again later',
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req, res) => {
    ApiResponse.error(res, 'Too many requests, please try again later', 429, 'RATE_LIMIT_EXCEEDED');
  }
});

/**
 * Strict rate limiter for auth endpoints
 */
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // 5 requests per window
  message: 'Too many authentication attempts, please try again later',
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req, res) => {
    ApiResponse.error(res, 'Too many authentication attempts, please try again later', 429, 'AUTH_RATE_LIMIT_EXCEEDED');
  }
});

/**
 * Upload rate limiter
 */
const uploadLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 20,
  message: 'Too many upload requests, please try again later',
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req, res) => {
    ApiResponse.error(res, 'Too many upload requests, please try again later', 429, 'UPLOAD_RATE_LIMIT_EXCEEDED');
  }
});

module.exports = {
  generalLimiter,
  authLimiter,
  uploadLimiter
};
