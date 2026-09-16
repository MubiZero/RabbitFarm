const express = require('express');
const router = express.Router();
const notificationController = require('../controllers/notificationController');
const { authenticateEvenIfFarmBlocked } = require('../middleware/auth');

/**
 * Лента уведомлений.
 *
 * Доступна и заблокированной ферме: именно уведомлениями ей и сообщают, что
 * тариф истёк и что делать дальше, — закрыть их от неё значило бы спрятать
 * объяснение происходящего.
 */
router.use(authenticateEvenIfFarmBlocked);

/**
 * @swagger
 * /notifications:
 *   get:
 *     summary: Свои уведомления, свежие сверху
 *     tags: [Notifications]
 */
router.get('/', notificationController.list);

/**
 * @swagger
 * /notifications/unread-count:
 *   get:
 *     summary: Сколько уведомлений не прочитано
 *     tags: [Notifications]
 */
router.get('/unread-count', notificationController.unreadCount);

/**
 * @swagger
 * /notifications/read:
 *   post:
 *     summary: Отметить прочитанным всё
 *     tags: [Notifications]
 */
router.post('/read', notificationController.markRead);

/**
 * @swagger
 * /notifications/{id}/read:
 *   post:
 *     summary: Отметить прочитанным одно
 *     tags: [Notifications]
 */
router.post('/:id/read', notificationController.markRead);

module.exports = router;
