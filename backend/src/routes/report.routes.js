const express = require('express');
const router = express.Router();
const reportController = require('../controllers/reportController');
const { authenticate } = require('../middleware/auth');

/**
 * Report Routes
 * All routes require authentication
 */

// Apply authentication to all routes
router.use(authenticate);

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
