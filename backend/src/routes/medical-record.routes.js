const express = require('express');
const router = express.Router();
const medicalRecordController = require('../controllers/medicalRecordController');
const { validateCreate, validateUpdate } = require('../validators/medicalRecordValidator');
const { authenticate } = require('../middleware/auth');

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
