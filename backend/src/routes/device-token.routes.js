const express = require('express');
const router = express.Router();
const deviceTokenController = require('../controllers/deviceTokenController');
const { registerDeviceTokenSchema, unregisterDeviceTokenSchema } = require('../validators/deviceTokenValidator');
const { authenticate } = require('../middleware/auth');
const validate = require('../middleware/validation');

/**
 * @swagger
 * tags:
 *   name: DeviceTokens
 *   description: Регистрация устройств для push-уведомлений
 *
 * /device-tokens:
 *   post:
 *     summary: Зарегистрировать FCM-токен устройства
 *     tags: [DeviceTokens]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [token, platform]
 *             properties:
 *               token: { type: string }
 *               platform: { type: string, enum: [android, ios] }
 *     responses:
 *       201:
 *         description: Устройство зарегистрировано
 *   delete:
 *     summary: Отвязать токен устройства (например, при выходе из аккаунта)
 *     tags: [DeviceTokens]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [token]
 *             properties:
 *               token: { type: string }
 *     responses:
 *       200:
 *         description: Устройство отвязано
 */

router.use(authenticate);

router.post('/', validate(registerDeviceTokenSchema), deviceTokenController.register);
router.delete('/', validate(unregisterDeviceTokenSchema), deviceTokenController.unregister);

module.exports = router;
