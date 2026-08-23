const express = require('express');
const router = express.Router();
const birthController = require('../controllers/birthController');
const { authenticate, authorize } = require('../middleware/auth');
const validate = require('../middleware/validation');
const {
  createBirthSchema,
  updateBirthSchema,
  createKitsSchema,
  listBirthsQuerySchema
} = require('../validators/birthValidator');

/**
 * @swagger
 * tags:
 *   name: Births
 *   description: Управление окролами
 *
 * /births:
 *   get:
 *     summary: Список окролов
 *     tags: [Births]
 *     parameters:
 *       - in: query
 *         name: mother_id
 *         schema: { type: integer }
 *       - in: query
 *         name: from_date
 *         schema: { type: string, format: date }
 *       - in: query
 *         name: to_date
 *         schema: { type: string, format: date }
 *       - in: query
 *         name: page
 *         schema: { type: integer, default: 1 }
 *       - in: query
 *         name: limit
 *         schema: { type: integer, default: 50, maximum: 100 }
 *     responses:
 *       200:
 *         description: Список окролов с пагинацией
 *   post:
 *     summary: Зарегистрировать окрол
 *     tags: [Births]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [mother_id, birth_date]
 *             properties:
 *               mother_id: { type: integer }
 *               breeding_id: { type: integer, nullable: true }
 *               birth_date: { type: string, format: date }
 *               kits_born_alive: { type: integer, default: 0 }
 *               kits_born_dead: { type: integer, default: 0 }
 *               complications: { type: string }
 *               notes: { type: string }
 *     responses:
 *       201:
 *         description: Окрол зарегистрирован
 *
 * /births/{id}:
 *   get:
 *     summary: Получить окрол по ID
 *     tags: [Births]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Данные окрола
 *       404:
 *         description: Окрол не найден
 *   put:
 *     summary: Обновить окрол
 *     tags: [Births]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Окрол обновлён
 *   delete:
 *     summary: Удалить окрол
 *     tags: [Births]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Окрол удалён
 *
 * /births/{id}/create-kits:
 *   post:
 *     summary: Создать записи крольчат из окрола
 *     tags: [Births]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       201:
 *         description: Крольчата созданы
 */

// Все маршруты требуют аутентификации
router.use(authenticate);

// CRUD операции для окролов
router.get('/', validate(listBirthsQuerySchema, 'query'), birthController.getBirths);
router.get('/:id', birthController.getBirthById);
router.post('/', authorize(['manager', 'owner']), validate(createBirthSchema), birthController.createBirth);
router.put('/:id', authorize(['manager', 'owner']), validate(updateBirthSchema), birthController.updateBirth);
router.delete('/:id', authorize(['owner']), birthController.deleteBirth);

// Специальный эндпоинт для создания крольчат
router.post('/:id/create-kits', authorize(['manager', 'owner']), validate(createKitsSchema), birthController.createKitsFromBirth);

module.exports = router;
