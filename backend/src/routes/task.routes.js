const express = require('express');
const router = express.Router();
const taskController = require('../controllers/taskController');
const { createTaskSchema, updateTaskSchema } = require('../validators/taskValidator');
const { authenticate } = require('../middleware/auth');
const validate = require('../middleware/validation');

/**
 * @swagger
 * tags:
 *   name: Tasks
 *   description: Управление задачами
 *
 * /tasks:
 *   get:
 *     summary: Список задач
 *     tags: [Tasks]
 *     parameters:
 *       - in: query
 *         name: status
 *         schema: { type: string, enum: [pending, in_progress, completed, cancelled] }
 *       - in: query
 *         name: priority
 *         schema: { type: string, enum: [low, medium, high, urgent] }
 *       - in: query
 *         name: page
 *         schema: { type: integer, default: 1 }
 *     responses:
 *       200:
 *         description: Список задач с пагинацией
 *   post:
 *     summary: Создать задачу
 *     tags: [Tasks]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [title, type, due_date]
 *             properties:
 *               title: { type: string }
 *               type: { type: string }
 *               priority: { type: string, enum: [low, medium, high, urgent] }
 *               due_date: { type: string, format: date }
 *               assigned_to: { type: integer }
 *     responses:
 *       201:
 *         description: Задача создана
 *
 * /tasks/{id}:
 *   get:
 *     summary: Получить задачу по ID
 *     tags: [Tasks]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Данные задачи
 *       404:
 *         description: Задача не найдена
 *   put:
 *     summary: Обновить задачу
 *     tags: [Tasks]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Задача обновлена
 *   delete:
 *     summary: Удалить задачу
 *     tags: [Tasks]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Задача удалена
 *
 * /tasks/{id}/complete:
 *   post:
 *     summary: Отметить задачу выполненной
 *     tags: [Tasks]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Задача выполнена
 *
 * /tasks/statistics:
 *   get:
 *     summary: Статистика задач
 *     tags: [Tasks]
 *     responses:
 *       200:
 *         description: Статистика по задачам
 *
 * /tasks/upcoming:
 *   get:
 *     summary: Предстоящие задачи
 *     tags: [Tasks]
 *     responses:
 *       200:
 *         description: Список предстоящих задач
 */

// Apply authentication to all routes
router.use(authenticate);
const idempotency = require('../middleware/idempotency');
router.use(idempotency);

// Statistics and special queries (before :id routes)
router.get('/statistics', taskController.getStatistics);
router.get('/upcoming', taskController.getUpcoming);

// CRUD routes
router.post('/', validate(createTaskSchema), taskController.create);
router.get('/', taskController.list);
router.get('/:id', taskController.getById);
router.put('/:id', validate(updateTaskSchema), taskController.update);
router.delete('/:id', taskController.delete);

// Complete task
router.post('/:id/complete', taskController.completeTask);

module.exports = router;
