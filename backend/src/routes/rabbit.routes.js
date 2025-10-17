const express = require('express');
const router = express.Router();
const rabbitController = require('../controllers/rabbitController');
const { authenticate, authorize } = require('../middleware/auth');
const validate = require('../middleware/validation');
const upload = require('../config/multer');
const {
  createRabbitSchema,
  updateRabbitSchema,
  listRabbitsQuerySchema,
  addWeightSchema
} = require('../validators/rabbitValidator');

/**
 * Rabbit routes
 * All routes require authentication
 */

// Apply authentication to all routes
router.use(authenticate);

/**
 * @route   GET /api/v1/rabbits/statistics
 * @desc    Get rabbit statistics
 * @access  Private
 */
router.get('/statistics', rabbitController.getStatistics);

/**
 * @route   GET /api/v1/rabbits
 * @desc    Get list of rabbits with filters
 * @access  Private
 */
router.get(
  '/',
  validate(listRabbitsQuerySchema, 'query'),
  rabbitController.list
);

/**
 * @route   POST /api/v1/rabbits
 * @desc    Create new rabbit
 * @access  Private (Manager, Owner)
 */
router.post(
  '/',
  authorize(['manager', 'owner']),
  upload.single('photo'),
  validate(createRabbitSchema),
  rabbitController.create
);

/**
 * @route   GET /api/v1/rabbits/:id
 * @desc    Get rabbit by ID
 * @access  Private
 */
router.get('/:id', rabbitController.getById);

/**
 * @route   PUT /api/v1/rabbits/:id
 * @desc    Update rabbit
 * @access  Private (Manager, Owner)
 */
router.put(
  '/:id',
  authorize(['manager', 'owner']),
  upload.single('photo'),
  validate(updateRabbitSchema),
  rabbitController.update
);

/**
 * @route   DELETE /api/v1/rabbits/:id
 * @desc    Delete rabbit
 * @access  Private (Owner only)
 */
router.delete(
  '/:id',
  authorize(['owner']),
  rabbitController.delete
);

/**
 * @route   GET /api/v1/rabbits/:id/weights
 * @desc    Get weight history
 * @access  Private
 */
router.get('/:id/weights', rabbitController.getWeightHistory);

/**
 * @route   POST /api/v1/rabbits/:id/weights
 * @desc    Add weight record
 * @access  Private (Manager, Owner)
 */
router.post(
  '/:id/weights',
  authorize(['manager', 'owner']),
  validate(addWeightSchema),
  rabbitController.addWeight
);

/**
 * @route   GET /api/v1/rabbits/:id/pedigree
 * @desc    Get rabbit pedigree
 * @access  Private
 */
router.get('/:id/pedigree', rabbitController.getPedigree);

/**
 * @route   POST /api/v1/rabbits/:id/photo
 * @desc    Upload rabbit photo
 * @access  Private (Manager, Owner)
 */
router.post(
  '/:id/photo',
  authorize(['manager', 'owner']),
  upload.single('photo'),
  rabbitController.uploadPhoto
);

/**
 * @route   DELETE /api/v1/rabbits/:id/photo
 * @desc    Delete rabbit photo
 * @access  Private (Manager, Owner)
 */
router.delete(
  '/:id/photo',
  authorize(['manager', 'owner']),
  rabbitController.deletePhoto
);

module.exports = router;
