const express = require('express');
const router = express.Router();
const staffController = require('../controllers/staffController');
const { authenticate, authorize } = require('../middleware/auth');
const validate = require('../middleware/validation');
const {
  createInvitationSchema,
  updateMemberSchema
} = require('../validators/staffValidator');

// Всё, кроме активации приглашения, доступно только внутри фермы.
router.use(authenticate);

/**
 * @swagger
 * /staff:
 *   get:
 *     summary: Состав фермы — владелец и работники
 *     tags: [Staff]
 *     responses:
 *       200:
 *         description: Список участников фермы
 */
router.get('/', authorize(['manager', 'owner']), staffController.listMembers);

/**
 * @swagger
 * /staff/invitations:
 *   get:
 *     summary: Действующие приглашения
 *     tags: [Staff]
 *   post:
 *     summary: Выписать приглашение (код показывается один раз)
 *     tags: [Staff]
 */
router.get('/invitations', authorize(['manager', 'owner']), staffController.listInvitations);
router.post(
  '/invitations',
  authorize(['owner']),
  validate(createInvitationSchema),
  staffController.createInvitation
);
router.delete('/invitations/:id', authorize(['owner']), staffController.revokeInvitation);

/**
 * @swagger
 * /staff/{id}:
 *   patch:
 *     summary: Изменить роль работника или отключить доступ
 *     tags: [Staff]
 */
router.patch(
  '/:id',
  authorize(['owner']),
  validate(updateMemberSchema),
  staffController.updateMember
);

module.exports = router;
