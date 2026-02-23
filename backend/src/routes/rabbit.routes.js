const express = require('express');
const router = express.Router();
const rabbitController = require('../controllers/rabbitController');
const { authenticate, authorize } = require('../middleware/auth');
const validate = require('../middleware/validation');
const upload = require('../config/multer');
const {
  createRabbitSchema,
  updateRabbitSchema,
  listRabbitsQuerySchema,
  addWeightSchema
} = require('../validators/rabbitValidator');
const vaccinationController = require('../controllers/vaccinationController');
const medicalRecordController = require('../controllers/medicalRecordController');
const feedingRecordController = require('../controllers/feedingRecordController');
const transactionController = require('../controllers/transactionController');

/**
 * @swagger
 * tags:
 *   name: Rabbits
 *   description: Управление кроликами
 */

/**
 * @swagger
 * /rabbits:
 *   get:
 *     summary: Список кроликов с фильтрацией и пагинацией
 *     tags: [Rabbits]
 *     parameters:
 *       - in: query
 *         name: page
 *         schema: { type: integer, default: 1 }
 *       - in: query
 *         name: limit
 *         schema: { type: integer, default: 20 }
 *       - in: query
 *         name: sex
 *         schema: { type: string, enum: [male, female] }
 *       - in: query
 *         name: status
 *         schema: { type: string }
 *     responses:
 *       200:
 *         description: Список кроликов с пагинацией
 *   post:
 *     summary: Создать нового кролика
 *     tags: [Rabbits]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [name, breed_id, sex]
 *             properties:
 *               name: { type: string }
 *               breed_id: { type: integer }
 *               sex: { type: string, enum: [male, female] }
 *               birth_date: { type: string, format: date }
 *               status: { type: string }
 *               weight: { type: number }
 *     responses:
 *       201:
 *         description: Кролик создан
 *       404:
 *         description: Порода не найдена
 *
 * /rabbits/{id}:
 *   get:
 *     summary: Получить кролика по ID
 *     tags: [Rabbits]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Данные кролика
 *       404:
 *         description: Кролик не найден
 *   put:
 *     summary: Обновить кролика
 *     tags: [Rabbits]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Кролик обновлён
 *   delete:
 *     summary: Удалить кролика (только Owner)
 *     tags: [Rabbits]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Кролик удалён
 *
 * /rabbits/statistics:
 *   get:
 *     summary: Статистика по кроликам
 *     tags: [Rabbits]
 *     responses:
 *       200:
 *         description: Статистика
 */

/**
 * Rabbit routes
 * All routes require authentication
 */

// Apply authentication to all routes
router.use(authenticate);

/**
 * @route   GET /api/v1/rabbits/statistics
 * @desc    Get rabbit statistics
 * @access  Private
 */
router.get('/statistics', rabbitController.getStatistics);

/**
 * @route   GET /api/v1/rabbits
 * @desc    Get list of rabbits with filters
 * @access  Private
 */
router.get(
  '/',
  validate(listRabbitsQuerySchema, 'query'),
  rabbitController.list
);

/**
 * @route   POST /api/v1/rabbits
 * @desc    Create new rabbit
 * @access  Private (Manager, Owner)
 */
router.post(
  '/',
  authorize(['manager', 'owner']),
  upload.single('photo'),
  validate(createRabbitSchema),
  rabbitController.create
);

/**
 * @route   GET /api/v1/rabbits/:id
 * @desc    Get rabbit by ID
 * @access  Private
 */
router.get('/:id', rabbitController.getById);

/**
 * @route   PUT /api/v1/rabbits/:id
 * @desc    Update rabbit
 * @access  Private (Manager, Owner)
 */
router.put(
  '/:id',
  authorize(['manager', 'owner']),
  upload.single('photo'),
  validate(updateRabbitSchema),
  rabbitController.update
);

/**
 * @route   DELETE /api/v1/rabbits/:id
 * @desc    Delete rabbit
 * @access  Private (Owner only)
 */
router.delete(
  '/:id',
  authorize(['owner']),
  rabbitController.delete
);

/**
 * @route   GET /api/v1/rabbits/:id/weights
 * @desc    Get weight history
 * @access  Private
 */
router.get('/:id/weights', rabbitController.getWeightHistory);

/**
 * @route   POST /api/v1/rabbits/:id/weights
 * @desc    Add weight record
 * @access  Private (Manager, Owner)
 */
router.post(
  '/:id/weights',
  authorize(['manager', 'owner']),
  validate(addWeightSchema),
  rabbitController.addWeight
);

/**
 * @route   GET /api/v1/rabbits/:id/pedigree
 * @desc    Get rabbit pedigree
 * @access  Private
 */
router.get('/:id/pedigree', rabbitController.getPedigree);

/**
 * @route   POST /api/v1/rabbits/:id/photo
 * @desc    Upload rabbit photo
 * @access  Private (Manager, Owner)
 */
router.post(
  '/:id/photo',
  authorize(['manager', 'owner']),
  upload.single('photo'),
  rabbitController.uploadPhoto
);

/**
 * @route   DELETE /api/v1/rabbits/:id/photo
 * @desc    Delete rabbit photo
 * @access  Private (Manager, Owner)
 */
router.delete(
  '/:id/photo',
  authorize(['manager', 'owner']),
  rabbitController.deletePhoto
);

/**
 * @route   GET /api/v1/rabbits/:rabbitId/vaccinations
 * @desc    Get rabbit vaccinations history
 * @access  Private
 */
router.get('/:rabbitId/vaccinations', vaccinationController.getByRabbit);

/**
 * @route   GET /api/v1/rabbits/:rabbitId/medical-records
 * @desc    Get rabbit medical records history
 * @access  Private
 */
router.get('/:rabbitId/medical-records', medicalRecordController.getByRabbit);

/**
 * @route   GET /api/v1/rabbits/:rabbitId/feeding-records
 * @desc    Get rabbit feeding records history
 * @access  Private
 */
router.get('/:rabbitId/feeding-records', feedingRecordController.getByRabbit);

/**
 * @route   GET /api/v1/rabbits/:rabbitId/transactions
 * @desc    Get rabbit financial transactions
 * @access  Private
 */
router.get('/:rabbitId/transactions', transactionController.getRabbitTransactions);

module.exports = router;
