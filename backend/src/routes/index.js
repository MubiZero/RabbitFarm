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
      medical_records: '/medical-records'
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

module.exports = router;
