const express = require('express');
const router = express.Router();
const breedController = require('../controllers/breedController');
const { authenticate, authorize } = require('../middleware/auth');

/**
 * Breed routes
 * All routes require authentication
 */

// Apply authentication to all routes
router.use(authenticate);

/**
 * @route   GET /api/v1/breeds
 * @desc    Get list of all breeds
 * @access  Private
 */
router.get('/', breedController.list);

/**
 * @route   GET /api/v1/breeds/:id
 * @desc    Get breed by ID
 * @access  Private
 */
router.get('/:id', breedController.getById);

/**
 * @route   POST /api/v1/breeds
 * @desc    Create new breed
 * @access  Private (Manager, Owner)
 */
router.post(
  '/',
  authorize(['manager', 'owner']),
  breedController.create
);

/**
 * @route   PUT /api/v1/breeds/:id
 * @desc    Update breed
 * @access  Private (Manager, Owner)
 */
router.put(
  '/:id',
  authorize(['manager', 'owner']),
  breedController.update
);

/**
 * @route   DELETE /api/v1/breeds/:id
 * @desc    Delete breed
 * @access  Private (Owner only)
 */
router.delete(
  '/:id',
  authorize(['owner']),
  breedController.delete
);

module.exports = router;

