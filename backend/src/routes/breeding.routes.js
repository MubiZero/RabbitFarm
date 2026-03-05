const express = require('express');
const router = express.Router();
const breedingController = require('../controllers/breedingController');
const { authenticate, authorize } = require('../middleware/auth');
const validate = require('../middleware/validation');
const {
    createBreedingSchema,
    updateBreedingSchema,
    listBreedingsQuerySchema
} = require('../validators/breedingValidator');

/**
 * @swagger
 * tags:
 *   name: Breeding
 *   description: Управление случками
 *
 * /breeding:
 *   get:
 *     summary: Список случек
 *     tags: [Breeding]
 *     parameters:
 *       - in: query
 *         name: status
 *         schema: { type: string, enum: [planned, completed, failed, cancelled] }
 *     responses:
 *       200:
 *         description: Список случек с пагинацией
 *   post:
 *     summary: Создать запись о случке
 *     tags: [Breeding]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [male_id, female_id, breeding_date]
 *             properties:
 *               male_id: { type: integer }
 *               female_id: { type: integer }
 *               breeding_date: { type: string, format: date }
 *               status: { type: string, enum: [planned, completed, failed, cancelled] }
 *     responses:
 *       201:
 *         description: Случка зарегистрирована
 *       400:
 *         description: Неверный пол кролика
 *       404:
 *         description: Кролик не найден
 *
 * /breeding/{id}:
 *   get:
 *     summary: Получить случку по ID
 *     tags: [Breeding]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Данные случки
 *       404:
 *         description: Случка не найдена
 *
 * /breeding/statistics:
 *   get:
 *     summary: Статистика случек
 *     tags: [Breeding]
 *     responses:
 *       200:
 *         description: Общая статистика по случкам
 */

/**
 * Breeding routes
 * All routes require authentication
 */

router.use(authenticate);
const idempotency = require('../middleware/idempotency');
router.use(idempotency);

/**
 * @route   GET /api/v1/breeding/statistics
 * @desc    Get breeding statistics
 * @access  Private
 */
router.get('/statistics', breedingController.getStatistics);

/**
 * @route   GET /api/v1/breeding
 * @desc    Get list of breedings
 * @access  Private
 */
router.get(
    '/',
    validate(listBreedingsQuerySchema, 'query'),
    breedingController.list
);

/**
 * @route   GET /api/v1/breeding/:id
 * @desc    Get breeding details
 * @access  Private
 */
router.get('/:id', breedingController.getById);

/**
 * @route   POST /api/v1/breeding
 * @desc    Create new breeding record
 * @access  Private (Manager, Owner)
 */
router.post(
    '/',
    authorize(['manager', 'owner']),
    validate(createBreedingSchema),
    breedingController.create
);

/**
 * @route   PUT /api/v1/breeding/:id
 * @desc    Update breeding record
 * @access  Private (Manager, Owner)
 */
router.put(
    '/:id',
    authorize(['manager', 'owner']),
    validate(updateBreedingSchema),
    breedingController.update
);

/**
 * @route   DELETE /api/v1/breeding/:id
 * @desc    Delete breeding record
 * @access  Private (Owner only)
 */
router.delete(
    '/:id',
    authorize(['owner']),
    breedingController.delete
);

module.exports = router;
