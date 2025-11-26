const express = require('express');
const router = express.Router();
const breedingController = require('../controllers/breedingController');
const { authenticate, authorize } = require('../middleware/auth');
const validate = require('../middleware/validation');
const {
    createBreedingSchema,
    updateBreedingSchema,
    listBreedingsQuerySchema
} = require('../validators/breedingValidator');

/**
 * Breeding routes
 * All routes require authentication
 */

router.use(authenticate);

/**
 * @route   GET /api/v1/breeding/statistics
 * @desc    Get breeding statistics
 * @access  Private
 */
router.get('/statistics', breedingController.getStatistics);

/**
 * @route   GET /api/v1/breeding
 * @desc    Get list of breedings
 * @access  Private
 */
router.get(
    '/',
    validate(listBreedingsQuerySchema, 'query'),
    breedingController.list
);

/**
 * @route   GET /api/v1/breeding/:id
 * @desc    Get breeding details
 * @access  Private
 */
router.get('/:id', breedingController.getById);

/**
 * @route   POST /api/v1/breeding
 * @desc    Create new breeding record
 * @access  Private (Manager, Owner)
 */
router.post(
    '/',
    authorize(['manager', 'owner']),
    validate(createBreedingSchema),
    breedingController.create
);

/**
 * @route   PUT /api/v1/breeding/:id
 * @desc    Update breeding record
 * @access  Private (Manager, Owner)
 */
router.put(
    '/:id',
    authorize(['manager', 'owner']),
    validate(updateBreedingSchema),
    breedingController.update
);

/**
 * @route   DELETE /api/v1/breeding/:id
 * @desc    Delete breeding record
 * @access  Private (Owner only)
 */
router.delete(
    '/:id',
    authorize(['owner']),
    breedingController.delete
);

module.exports = router;
