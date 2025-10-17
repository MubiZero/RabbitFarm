const express = require('express');
const router = express.Router();
const birthController = require('../controllers/birthController');
const { authenticate } = require('../middleware/auth');

// Все маршруты требуют аутентификации
router.use(authenticate);

// CRUD операции для окролов
router.get('/', birthController.getBirths);
router.get('/:id', birthController.getBirthById);
router.post('/', birthController.createBirth);
router.put('/:id', birthController.updateBirth);
router.delete('/:id', birthController.deleteBirth);

// Специальный эндпоинт для создания крольчат
router.post('/:id/create-kits', birthController.createKitsFromBirth);

module.exports = router;
