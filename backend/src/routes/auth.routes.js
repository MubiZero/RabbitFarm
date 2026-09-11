const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const { authenticate } = require('../middleware/auth');
const validate = require('../middleware/validation');
const { authLimiter, otpLimiter } = require('../middleware/rateLimiter');
const {
  registerSchema,
  refreshTokenSchema,
  updateProfileSchema,
  requestOtpSchema,
  verifyOtpSchema
} = require('../validators/authValidator');

/**
 * @swagger
 * tags:
 *   name: Auth
 *   description: Аутентификация и управление профилем
 */

/**
 * @swagger
 * /auth/register:
 *   post:
 *     summary: Завести ферму (сессию не открывает — отправляет код для входа)
 *     tags: [Auth]
 *     security: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [full_name]
 *             properties:
 *               phone:
 *                 type: string
 *                 description: +992XXXXXXXXX — основной способ входа
 *               email:
 *                 type: string
 *                 format: email
 *                 description: запасной способ входа; нужен хотя бы один контакт
 *               full_name:
 *                 type: string
 *               farm_name:
 *                 type: string
 *     responses:
 *       201:
 *         description: Ферма создана, код для входа отправлен на контакт
 *       400:
 *         description: Невалидные данные
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       409:
 *         description: Пользователь с таким email уже существует (code USER_EXISTS)
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.post(
  '/register',
  authLimiter,
  validate(registerSchema),
  authController.register
);

/**
 * @swagger
 * /auth/otp/request:
 *   post:
 *     summary: Запросить код входа по телефону
 *     tags: [Auth]
 *     security: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [phone]
 *             properties:
 *               phone:
 *                 type: string
 *     responses:
 *       200:
 *         description: Если номер известен, код отправлен
 */
router.post(
  '/otp/request',
  otpLimiter,
  validate(requestOtpSchema),
  authController.requestOtp
);

/**
 * @swagger
 * /auth/otp/verify:
 *   post:
 *     summary: Подтвердить код и войти (или активировать приглашение по телефону)
 *     tags: [Auth]
 *     security: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [phone, code]
 *             properties:
 *               phone:
 *                 type: string
 *               code:
 *                 type: string
 *     responses:
 *       200:
 *         description: Вход выполнен, возвращает токены
 *       400:
 *         description: Неверный или просроченный код
 */
router.post(
  '/otp/verify',
  otpLimiter,
  validate(verifyOtpSchema),
  authController.verifyOtp
);

/**
 * @swagger
 * /auth/refresh:
 *   post:
 *     summary: Обновить access token
 *     tags: [Auth]
 *     security: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [refresh_token]
 *             properties:
 *               refresh_token:
 *                 type: string
 *     responses:
 *       200:
 *         description: Новые токены
 *       401:
 *         description: Недействительный refresh token
 */
router.post(
  '/refresh',
  validate(refreshTokenSchema),
  authController.refresh
);

/**
 * @swagger
 * /auth/logout:
 *   post:
 *     summary: Выход (инвалидировать токены)
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [refresh_token]
 *             properties:
 *               refresh_token:
 *                 type: string
 *     responses:
 *       200:
 *         description: Выход выполнен успешно
 */
router.post(
  '/logout',
  validate(refreshTokenSchema),
  authController.logout
);

/**
 * @swagger
 * /auth/me:
 *   get:
 *     summary: Получить профиль текущего пользователя
 *     tags: [Auth]
 *     responses:
 *       200:
 *         description: Профиль пользователя
 *       401:
 *         description: Не авторизован
 */
router.get(
  '/me',
  authenticate,
  authController.getMe
);

/**
 * @swagger
 * /auth/profile:
 *   put:
 *     summary: Обновить профиль пользователя
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               full_name:
 *                 type: string
 *               phone:
 *                 type: string
 *     responses:
 *       200:
 *         description: Профиль обновлён
 */
router.put(
  '/profile',
  authenticate,
  validate(updateProfileSchema),
  authController.updateProfile
);

module.exports = router;
