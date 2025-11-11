const express = require('express');
const router = express.Router();
const feedController = require('../controllers/feedController');
const { validateCreate, validateUpdate, validateAdjustStock } = require('../validators/feedValidator');
const { authenticate } = require('../middleware/auth');

// Apply authentication to all routes
router.use(authenticate);

// Statistics and special queries (before :id routes)
router.get('/statistics', feedController.getStatistics);
router.get('/low-stock', feedController.getLowStock);

// CRUD routes
router.post('/', validateCreate, feedController.create);
router.get('/', feedController.list);
router.get('/:id', feedController.getById);
router.put('/:id', validateUpdate, feedController.update);
router.delete('/:id', feedController.delete);

// Stock adjustment
router.post('/:id/adjust-stock', validateAdjustStock, feedController.adjustStock);

module.exports = router;
