const express = require('express');
const router = express.Router();

// Import route modules
const authRoutes = require('./auth.routes');
const rabbitRoutes = require('./rabbit.routes');
const breedRoutes = require('./breed.routes');
const birthRoutes = require('./birth.routes');
const cageRoutes = require('./cage.routes');
const vaccinationRoutes = require('./vaccination.routes');
const medicalRecordRoutes = require('./medical-record.routes');
const feedRoutes = require('./feed.routes');
const feedingRecordRoutes = require('./feeding-record.routes');
const transactionRoutes = require('./transaction.routes');
const taskRoutes = require('./task.routes');
const reportRoutes = require('./report.routes');
const breedingRoutes = require('./breeding.routes');

// API Info
router.get('/', (req, res) => {
  res.json({
    message: 'RabbitFarm API',
    version: process.env.API_VERSION || 'v1',
    documentation: '/api-docs',
    endpoints: {
      auth: '/auth',
      rabbits: '/rabbits',
      breeding: '/breeding',
      health: '/health',
      feeding: '/feeding',
      finance: '/finance',
      farm: '/farm',
      tasks: '/tasks',
      reports: '/reports',
      vaccinations: '/vaccinations',
      medical_records: '/medical-records',
      feeds: '/feeds',
      feeding_records: '/feeding-records',
      transactions: '/transactions',
      tasks: '/tasks'
    }
  });
});

// Mount routes
router.use('/auth', authRoutes);
router.use('/rabbits', rabbitRoutes);
router.use('/breeds', breedRoutes);
router.use('/births', birthRoutes);
router.use('/cages', cageRoutes);
router.use('/vaccinations', vaccinationRoutes);
router.use('/medical-records', medicalRecordRoutes);
router.use('/feeds', feedRoutes);
router.use('/feeding-records', feedingRecordRoutes);
router.use('/transactions', transactionRoutes);
router.use('/tasks', taskRoutes);
router.use('/reports', reportRoutes);
router.use('/breeding', breedingRoutes);

module.exports = router;
