const express = require('express');
const router = express.Router();
const taskController = require('../controllers/taskController');
const { validateCreate, validateUpdate } = require('../validators/taskValidator');
const { authenticate } = require('../middleware/auth');

// Apply authentication to all routes
router.use(authenticate);

// Statistics and special queries (before :id routes)
router.get('/statistics', taskController.getStatistics);
router.get('/upcoming', taskController.getUpcoming);

// CRUD routes
router.post('/', validateCreate, taskController.create);
router.get('/', taskController.list);
router.get('/:id', taskController.getById);
router.put('/:id', validateUpdate, taskController.update);
router.delete('/:id', taskController.delete);

// Complete task
router.post('/:id/complete', taskController.completeTask);

module.exports = router;
