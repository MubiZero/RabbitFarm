const express = require('express');
const router = express.Router();
const reportController = require('../controllers/reportController');
const { authenticate } = require('../middleware/auth');

/**
 * @swagger
 * tags:
 *   name: Reports
 *   description: Отчёты и аналитика
 *
 * /reports/dashboard:
 *   get:
 *     summary: Обзор дашборда
 *     tags: [Reports]
 *     responses:
 *       200:
 *         description: Ключевые метрики фермы для дашборда
 *
 * /reports/farm:
 *   get:
 *     summary: Общий отчёт по ферме
 *     tags: [Reports]
 *     parameters:
 *       - in: query
 *         name: from_date
 *         schema: { type: string, format: date }
 *       - in: query
 *         name: to_date
 *         schema: { type: string, format: date }
 *     responses:
 *       200:
 *         description: Сводный отчёт по ферме
 *
 * /reports/health:
 *   get:
 *     summary: Отчёт по здоровью
 *     tags: [Reports]
 *     parameters:
 *       - in: query
 *         name: from_date
 *         schema: { type: string, format: date }
 *       - in: query
 *         name: to_date
 *         schema: { type: string, format: date }
 *     responses:
 *       200:
 *         description: Отчёт по вакцинациям и медзаписям
 *
 * /reports/financial:
 *   get:
 *     summary: Финансовый отчёт
 *     tags: [Reports]
 *     parameters:
 *       - in: query
 *         name: from_date
 *         schema: { type: string, format: date }
 *       - in: query
 *         name: to_date
 *         schema: { type: string, format: date }
 *       - in: query
 *         name: groupBy
 *         schema: { type: string, enum: [day, month, year] }
 *     responses:
 *       200:
 *         description: Финансовый отчёт по периоду
 */

// Apply authentication to all routes
router.use(authenticate);
const idempotency = require('../middleware/idempotency');
router.use(idempotency);

/**
 * @route   GET /api/v1/reports/dashboard
 * @desc    Get dashboard overview with key metrics
 * @access  Private
 */
router.get('/dashboard', reportController.getDashboard);

/**
 * @route   GET /api/v1/reports/farm
 * @desc    Get comprehensive farm report
 * @query   from_date, to_date
 * @access  Private
 */
router.get('/farm', reportController.getFarmReport);

/**
 * @route   GET /api/v1/reports/health
 * @desc    Get health report (vaccinations, medical records)
 * @query   from_date, to_date
 * @access  Private
 */
router.get('/health', reportController.getHealthReport);

/**
 * @route   GET /api/v1/reports/financial
 * @desc    Get financial report
 * @query   from_date, to_date, groupBy
 * @access  Private
 */
router.get('/financial', reportController.getFinancialReport);

module.exports = router;
