const express = require('express');
const router = express.Router();
const platformAdminController = require('../controllers/platformAdminController');
const { authenticate, requirePlatformAdmin } = require('../middleware/auth');
const validate = require('../middleware/validation');
const {
  createPlanSchema,
  updatePlanSchema,
  assignPlanSchema,
  updateFarmStatusSchema,
  updateFarmExtrasSchema,
  deleteFarmSchema
} = require('../validators/planValidator');

/**
 * @swagger
 * tags:
 *   name: PlatformAdmin
 *   description: Платформенная админка — тарифы и фермы, доступно только суперадмину
 */

router.use(authenticate, requirePlatformAdmin);

/**
 * @swagger
 * /platform-admin/plans:
 *   get:
 *     summary: Список тарифов
 *     tags: [PlatformAdmin]
 *   post:
 *     summary: Создать тариф
 *     tags: [PlatformAdmin]
 */
router.get('/plans', platformAdminController.listPlans);
router.post('/plans', validate(createPlanSchema), platformAdminController.createPlan);

/**
 * @swagger
 * /platform-admin/plans/{id}:
 *   put:
 *     summary: Обновить тариф
 *     tags: [PlatformAdmin]
 *   delete:
 *     summary: Удалить тариф — фермы на нём становятся безлимитными
 *     tags: [PlatformAdmin]
 */
router.put('/plans/:id', validate(updatePlanSchema), platformAdminController.updatePlan);
router.delete('/plans/:id', platformAdminController.deletePlan);

/**
 * @swagger
 * /platform-admin/farms:
 *   get:
 *     summary: Все фермы платформы с их тарифом и текущим потреблением
 *     tags: [PlatformAdmin]
 */
router.get('/farms', platformAdminController.listFarms);

/**
 * @swagger
 * /platform-admin/farms/{id}:
 *   get:
 *     summary: Одна ферма — тариф, владелец, потребление, последняя активность
 *     tags: [PlatformAdmin]
 */
router.get('/farms/:id', platformAdminController.getFarm);

/**
 * @swagger
 * /platform-admin/farms/{id}/plan:
 *   patch:
 *     summary: Назначить (или снять) тариф ферме
 *     tags: [PlatformAdmin]
 */
router.patch('/farms/:id/plan', validate(assignPlanSchema), platformAdminController.assignPlan);

/**
 * @swagger
 * /platform-admin/farms/{id}/status:
 *   patch:
 *     summary: Приостановить ферму, перевести в режим чтения или вернуть к работе
 *     tags: [PlatformAdmin]
 */
router.patch('/farms/:id/status', validate(updateFarmStatusSchema), platformAdminController.updateStatus);

/**
 * @swagger
 * /platform-admin/farms/{id}/extras:
 *   patch:
 *     summary: Разовая поблажка сверх лимита тарифа — без смены самого тарифа
 *     tags: [PlatformAdmin]
 */
router.patch('/farms/:id/extras', validate(updateFarmExtrasSchema), platformAdminController.updateExtras);

/**
 * @swagger
 * /platform-admin/farms/{id}/export:
 *   get:
 *     summary: Все данные фермы одним JSON — для «отдайте мои данные» и копии перед удалением
 *     tags: [PlatformAdmin]
 */
router.get('/farms/:id/export', platformAdminController.exportFarm);

/**
 * @swagger
 * /platform-admin/farms/{id}:
 *   delete:
 *     summary: Мягко удалить ферму — доступ закрывается сразу, данные очищаются через 30 дней
 *     description: Требует confirm_name с точным названием фермы; сервер перепроверяет совпадение сам
 *     tags: [PlatformAdmin]
 */
router.delete('/farms/:id', validate(deleteFarmSchema), platformAdminController.deleteFarm);

/**
 * @swagger
 * /platform-admin/farms/{id}/restore:
 *   post:
 *     summary: Отменить мягкое удаление, пока физическая зачистка ещё не наступила
 *     tags: [PlatformAdmin]
 */
router.post('/farms/:id/restore', platformAdminController.restoreFarm);

/**
 * @swagger
 * /platform-admin/audit:
 *   get:
 *     summary: Журнал действий платформенного админа, постранично, опционально по ферме
 *     tags: [PlatformAdmin]
 */
router.get('/audit', platformAdminController.listAudit);

module.exports = router;
