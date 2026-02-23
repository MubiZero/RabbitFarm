const express = require('express');
const router = express.Router();
const vaccinationController = require('../controllers/vaccinationController');
const { authenticate } = require('../middleware/auth');
const validate = require('../middleware/validation');
const {
  createVaccinationSchema,
  updateVaccinationSchema,
  listVaccinationsQuerySchema,
  upcomingVaccinationsQuerySchema
} = require('../validators/vaccinationValidator');

/**
 * @swagger
 * tags:
 *   name: Vaccinations
 *   description: Управление вакцинациями кроликов
 *
 * /vaccinations:
 *   get:
 *     summary: Список вакцинаций
 *     tags: [Vaccinations]
 *     parameters:
 *       - in: query
 *         name: rabbit_id
 *         schema: { type: integer }
 *       - in: query
 *         name: status
 *         schema: { type: string, enum: [scheduled, completed, missed] }
 *       - in: query
 *         name: page
 *         schema: { type: integer, default: 1 }
 *     responses:
 *       200:
 *         description: Список вакцинаций с пагинацией
 *   post:
 *     summary: Создать запись о вакцинации
 *     tags: [Vaccinations]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [rabbit_id, vaccine_name, vaccination_date]
 *             properties:
 *               rabbit_id: { type: integer }
 *               vaccine_name: { type: string }
 *               vaccination_date: { type: string, format: date }
 *               next_date: { type: string, format: date }
 *               notes: { type: string }
 *     responses:
 *       201:
 *         description: Вакцинация зарегистрирована
 *
 * /vaccinations/{id}:
 *   get:
 *     summary: Получить вакцинацию по ID
 *     tags: [Vaccinations]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Данные вакцинации
 *       404:
 *         description: Вакцинация не найдена
 *   put:
 *     summary: Обновить вакцинацию
 *     tags: [Vaccinations]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Вакцинация обновлена
 *   delete:
 *     summary: Удалить вакцинацию
 *     tags: [Vaccinations]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema: { type: integer }
 *     responses:
 *       200:
 *         description: Вакцинация удалена
 *
 * /vaccinations/statistics:
 *   get:
 *     summary: Статистика вакцинаций
 *     tags: [Vaccinations]
 *     responses:
 *       200:
 *         description: Общая статистика вакцинаций
 *
 * /vaccinations/upcoming:
 *   get:
 *     summary: Предстоящие вакцинации
 *     tags: [Vaccinations]
 *     responses:
 *       200:
 *         description: Список предстоящих вакцинаций
 *
 * /vaccinations/overdue:
 *   get:
 *     summary: Просроченные вакцинации
 *     tags: [Vaccinations]
 *     responses:
 *       200:
 *         description: Список просроченных вакцинаций
 */

// Apply authentication to all routes
router.use(authenticate);

// Statistics (before :id to avoid conflict)
router.get('/statistics', vaccinationController.getStatistics);

// Upcoming vaccinations
router.get('/upcoming', validate(upcomingVaccinationsQuerySchema, 'query'), vaccinationController.getUpcoming);

// Overdue vaccinations
router.get('/overdue', vaccinationController.getOverdue);

// CRUD operations
router.post('/', validate(createVaccinationSchema), vaccinationController.create);
router.get('/', validate(listVaccinationsQuerySchema, 'query'), vaccinationController.list);
router.get('/:id', vaccinationController.getById);
router.put('/:id', validate(updateVaccinationSchema), vaccinationController.update);
router.delete('/:id', vaccinationController.delete);

module.exports = router;
