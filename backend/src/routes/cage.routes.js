const express = require('express');
const router = express.Router();
const cageController = require('../controllers/cageController');
const { authenticate } = require('../middleware/auth');
const validate = require('../middleware/validation');
const {
  createCageSchema,
  updateCageSchema,
  listCagesQuerySchema
} = require('../validators/cageValidator');

/**
 * Cage routes
 * All routes require authentication
 */

// Apply authentication to all routes
router.use(authenticate);

// Statistics (before :id to avoid conflict)
router.get('/statistics', cageController.getStatistics);

// Layout/map
router.get('/layout', cageController.getLayout);

// CRUD operations
router.post('/', validate(createCageSchema), cageController.create);
router.get('/', validate(listCagesQuerySchema, 'query'), cageController.list);
router.get('/:id', cageController.getById);
router.put('/:id', validate(updateCageSchema), cageController.update);
router.delete('/:id', cageController.delete);

// Mark as cleaned
router.patch('/:id/clean', cageController.markCleaned);

module.exports = router;
