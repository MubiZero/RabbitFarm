const express = require('express');
const router = express.Router();
const platformAdminController = require('../controllers/platformAdminController');
const { authenticate, requirePlatformAdmin } = require('../middleware/auth');
const validate = require('../middleware/validation');
const {
  createPlanSchema,
  updatePlanSchema,
  assignPlanSchema
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
 * /platform-admin/farms/{id}/plan:
 *   patch:
 *     summary: Назначить (или снять) тариф ферме
 *     tags: [PlatformAdmin]
 */
router.patch('/farms/:id/plan', validate(assignPlanSchema), platformAdminController.assignPlan);

/**
 * @swagger
 * /platform-admin/audit:
 *   get:
 *     summary: Журнал действий платформенного админа, постранично, опционально по ферме
 *     tags: [PlatformAdmin]
 */
router.get('/audit', platformAdminController.listAudit);

module.exports = router;
