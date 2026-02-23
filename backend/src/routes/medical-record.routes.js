const express = require('express');
const router = express.Router();
const medicalRecordController = require('../controllers/medicalRecordController');
const { validateCreate, validateUpdate } = require('../validators/medicalRecordValidator');
const { authenticate } = require('../middleware/auth');

/**
 * @swagger
 * tags:
 *   name: MedicalRecords
 *   description: Медицинские записи кроликов
 *
 * /medical-records:
 *   get:
 *     summary: Список медицинских записей
 *     tags: [MedicalRecords]
 *     parameters:
 *       - in: query
 *         name: rabbit_id
 *         schema: { type: integer }
 *       - in: query
 *         name: status
 *         schema: { type: string, enum: [ongoing, completed] }
 *       - in: query
 *         name: page
 *         schema: { type: integer, default: 1 }
 *     responses:
 *       200:
 *         description: Список медзаписей с пагинацией
 *   post:
 *     summary: Создать медицинскую запись
 *     tags: [MedicalRecords]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [rabbit_id, diagnosis, started_at]
 *             properties:
 *               rabbit_id: { type: integer }
 *               diagnosis: { type: string }
 *               treatment: { type: string }
 *               started_at: { type: string, format: date }
 *               ended_at: { type: string, format: date }
 *     responses:
 *       201:
 *         description: Медицинская запись создана
 *
 * /medical-records/{id}:
 *   get:
 *     summary: Получить медзапись по ID
 *     tags: [MedicalRecords]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Данные медзаписи
 *       404:
 *         description: Запись не найдена
 *   put:
 *     summary: Обновить медзапись
 *     tags: [MedicalRecords]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Медзапись обновлена
 *   delete:
 *     summary: Удалить медзапись
 *     tags: [MedicalRecords]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Медзапись удалена
 *
 * /medical-records/statistics:
 *   get:
 *     summary: Статистика по здоровью
 *     tags: [MedicalRecords]
 *     responses:
 *       200:
 *         description: Общая статистика по заболеваниям
 *
 * /medical-records/ongoing:
 *   get:
 *     summary: Текущие лечения
 *     tags: [MedicalRecords]
 *     responses:
 *       200:
 *         description: Список незавершённых лечений
 *
 * /medical-records/costs:
 *   get:
 *     summary: Расходы на лечение
 *     tags: [MedicalRecords]
 *     responses:
 *       200:
 *         description: Затраты на ветеринарное обслуживание
 */

// Apply authentication to all routes
router.use(authenticate);

// Statistics and special queries (before :id routes)
router.get('/statistics', medicalRecordController.getStatistics);
router.get('/ongoing', medicalRecordController.getOngoing);
router.get('/costs', medicalRecordController.getCosts);

// CRUD routes
router.post('/', validateCreate, medicalRecordController.create);
router.get('/', medicalRecordController.list);
router.get('/:id', medicalRecordController.getById);
router.put('/:id', validateUpdate, medicalRecordController.update);
router.delete('/:id', medicalRecordController.delete);

module.exports = router;
