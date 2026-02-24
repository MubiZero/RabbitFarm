const express = require('express');
const router = express.Router();
const birthController = require('../controllers/birthController');
const { authenticate } = require('../middleware/auth');

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
 *         name: breeding_id
 *         schema: { type: integer }
 *       - in: query
 *         name: page
 *         schema: { type: integer, default: 1 }
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
 *             required: [breeding_id, birth_date, total_kits]
 *             properties:
 *               breeding_id: { type: integer }
 *               birth_date: { type: string, format: date }
 *               total_kits: { type: integer }
 *               alive_kits: { type: integer }
 *               dead_kits: { type: integer }
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
router.get('/', birthController.getBirths);
router.get('/:id', birthController.getBirthById);
router.post('/', birthController.createBirth);
router.put('/:id', birthController.updateBirth);
router.delete('/:id', birthController.deleteBirth);

// Специальный эндпоинт для создания крольчат
router.post('/:id/create-kits', birthController.createKitsFromBirth);

module.exports = router;
