const express = require('express');
const router = express.Router();
const transactionController = require('../controllers/transactionController');
const { validateCreate, validateUpdate } = require('../validators/transactionValidator');
const { authenticate } = require('../middleware/auth');

// Apply authentication to all routes
router.use(authenticate);

// Statistics and special queries (before :id routes)
router.get('/statistics', transactionController.getStatistics);
router.get('/monthly-report', transactionController.getMonthlyReport);

// CRUD routes
router.post('/', validateCreate, transactionController.create);
router.get('/', transactionController.list);
router.get('/:id', transactionController.getById);
router.put('/:id', validateUpdate, transactionController.update);
router.delete('/:id', transactionController.delete);

module.exports = router;
