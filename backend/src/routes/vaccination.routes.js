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
 * Vaccination routes
 * All routes require authentication
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
