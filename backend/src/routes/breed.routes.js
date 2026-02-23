const express = require('express');
const router = express.Router();
const breedController = require('../controllers/breedController');
const { authenticate, authorize } = require('../middleware/auth');

/**
 * @swagger
 * tags:
 *   name: Breeds
 *   description: Управление породами кроликов
 *
 * /breeds:
 *   get:
 *     summary: Список пород
 *     tags: [Breeds]
 *     responses:
 *       200:
 *         description: Полный список пород
 *   post:
 *     summary: Создать породу
 *     tags: [Breeds]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [name]
 *             properties:
 *               name: { type: string }
 *               description: { type: string }
 *               origin: { type: string }
 *     responses:
 *       201:
 *         description: Порода создана
 *
 * /breeds/{id}:
 *   get:
 *     summary: Получить породу по ID
 *     tags: [Breeds]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Данные породы
 *       404:
 *         description: Порода не найдена
 *   put:
 *     summary: Обновить породу
 *     tags: [Breeds]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Порода обновлена
 *   delete:
 *     summary: Удалить породу
 *     tags: [Breeds]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Порода удалена
 */

// Apply authentication to all routes
router.use(authenticate);

/**
 * @route   GET /api/v1/breeds
 * @desc    Get list of all breeds
 * @access  Private
 */
router.get('/', breedController.list);

/**
 * @route   GET /api/v1/breeds/:id
 * @desc    Get breed by ID
 * @access  Private
 */
router.get('/:id', breedController.getById);

/**
 * @route   POST /api/v1/breeds
 * @desc    Create new breed
 * @access  Private (Manager, Owner)
 */
router.post(
  '/',
  authorize(['manager', 'owner']),
  breedController.create
);

/**
 * @route   PUT /api/v1/breeds/:id
 * @desc    Update breed
 * @access  Private (Manager, Owner)
 */
router.put(
  '/:id',
  authorize(['manager', 'owner']),
  breedController.update
);

/**
 * @route   DELETE /api/v1/breeds/:id
 * @desc    Delete breed
 * @access  Private (Owner only)
 */
router.delete(
  '/:id',
  authorize(['owner']),
  breedController.delete
);

module.exports = router;

