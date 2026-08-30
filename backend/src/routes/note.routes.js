const express = require('express');
const router = express.Router();
const noteController = require('../controllers/noteController');
const { createNoteSchema, updateNoteSchema, listNotesQuerySchema } = require('../validators/noteValidator');
const { authenticate, authorize } = require('../middleware/auth');
const validate = require('../middleware/validation');

/**
 * @swagger
 * tags:
 *   name: Notes
 *   description: Заметки по кролику, клетке или ферме в целом
 *
 * /notes:
 *   get:
 *     summary: Список заметок
 *     tags: [Notes]
 *     parameters:
 *       - in: query
 *         name: rabbit_id
 *         schema: { type: integer }
 *       - in: query
 *         name: cage_id
 *         schema: { type: integer }
 *       - in: query
 *         name: page
 *         schema: { type: integer, default: 1 }
 *     responses:
 *       200:
 *         description: Список заметок с пагинацией
 *   post:
 *     summary: Добавить заметку
 *     tags: [Notes]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [content]
 *             properties:
 *               content: { type: string }
 *               rabbit_id: { type: integer }
 *               cage_id: { type: integer }
 *     responses:
 *       201:
 *         description: Заметка добавлена
 *
 * /notes/{id}:
 *   get:
 *     summary: Получить заметку по ID
 *     tags: [Notes]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Данные заметки
 *       404:
 *         description: Заметка не найдена
 *   put:
 *     summary: Обновить заметку
 *     tags: [Notes]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Заметка обновлена
 *   delete:
 *     summary: Удалить заметку
 *     tags: [Notes]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Заметка удалена
 */

router.use(authenticate);

router.post('/', validate(createNoteSchema), noteController.create);
router.get('/', validate(listNotesQuerySchema, 'query'), noteController.list);
router.get('/:id', noteController.getById);
router.put('/:id', validate(updateNoteSchema), noteController.update);
router.delete('/:id', authorize(['manager', 'owner']), noteController.delete);

module.exports = router;
