const express = require('express');
const router = express.Router();
const feedingRecordController = require('../controllers/feedingRecordController');
const { validateCreate, validateUpdate } = require('../validators/feedingRecordValidator');
const { authenticate } = require('../middleware/auth');

// Apply authentication to all routes
router.use(authenticate);

// Statistics and special queries (before :id routes)
router.get('/statistics', feedingRecordController.getStatistics);
router.get('/recent', feedingRecordController.getRecent);

// CRUD routes
router.post('/', validateCreate, feedingRecordController.create);
router.get('/', feedingRecordController.list);
router.get('/:id', feedingRecordController.getById);
router.put('/:id', validateUpdate, feedingRecordController.update);
router.delete('/:id', feedingRecordController.delete);

module.exports = router;
