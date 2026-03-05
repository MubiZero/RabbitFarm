const express = require('express');
const router = express.Router();
const cageController = require('../controllers/cageController');
const { authenticate } = require('../middleware/auth');
const validate = require('../middleware/validation');
const {
  createCageSchema,
  updateCageSchema,
  listCagesQuerySchema
} = require('../validators/cageValidator');

/**
 * @swagger
 * tags:
 *   name: Cages
 *   description: Управление клетками
 *
 * /cages:
 *   get:
 *     summary: Список клеток
 *     tags: [Cages]
 *     parameters:
 *       - in: query
 *         name: type
 *         schema: { type: string, enum: [single, group, maternity] }
 *       - in: query
 *         name: condition
 *         schema: { type: string, enum: [good, needs_repair, broken] }
 *     responses:
 *       200:
 *         description: Список клеток с пагинацией
 *   post:
 *     summary: Создать клетку
 *     tags: [Cages]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [number]
 *             properties:
 *               number: { type: string }
 *               type: { type: string, enum: [single, group, maternity] }
 *               capacity: { type: integer }
 *               location: { type: string }
 *     responses:
 *       201:
 *         description: Клетка создана
 *
 * /cages/{id}:
 *   get:
 *     summary: Получить клетку по ID
 *     tags: [Cages]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Данные клетки
 *       404:
 *         description: Клетка не найдена
 *   put:
 *     summary: Обновить клетку
 *     tags: [Cages]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Клетка обновлена
 *   delete:
 *     summary: Удалить клетку
 *     tags: [Cages]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Клетка удалена
 *
 * /cages/statistics:
 *   get:
 *     summary: Статистика клеток
 *     tags: [Cages]
 *     responses:
 *       200:
 *         description: Статистика по клеткам и заполненности
 */

/**
 * Cage routes
 * All routes require authentication
 */

// Apply authentication to all routes
router.use(authenticate);
const idempotency = require('../middleware/idempotency');
router.use(idempotency);

// Statistics (before :id to avoid conflict)
router.get('/statistics', cageController.getStatistics);

// Layout/map
router.get('/layout', cageController.getLayout);

// CRUD operations
router.post('/', validate(createCageSchema), cageController.create);
router.get('/', validate(listCagesQuerySchema, 'query'), cageController.list);
router.get('/:id', cageController.getById);
router.put('/:id', validate(updateCageSchema), cageController.update);
router.delete('/:id', cageController.delete);

// Mark as cleaned
router.patch('/:id/clean', cageController.markCleaned);

module.exports = router;
