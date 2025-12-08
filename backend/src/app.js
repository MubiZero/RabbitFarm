const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const morgan = require('morgan');
const path = require('path');

const logger = require('./utils/logger');
const { errorHandler, notFoundHandler } = require('./middleware/errorHandler');
const { generalLimiter } = require('./middleware/rateLimiter');
const routes = require('./routes');

// Create Express app
const app = express();

// Trust proxy (for rate limiting behind reverse proxy)
app.set('trust proxy', 1);

// Security middleware
app.use(helmet());

// CORS configuration - Allow all origins for better mobile app compatibility
const corsOptions = {
  origin: true, // Accept all origins (required for mobile apps)
  credentials: true,
  optionsSuccessStatus: 200,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'Accept', 'X-Requested-With'],
  exposedHeaders: ['Content-Length', 'X-Total-Count']
};
app.use(cors(corsOptions));

// Compression middleware
app.use(compression());

// Body parsing middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// HTTP request logging
if (process.env.NODE_ENV === 'development') {
  app.use(morgan('dev'));

  // CORS debugging middleware
  app.use((req, res, next) => {
    logger.info('CORS Request', {
      origin: req.headers.origin || 'no-origin',
      method: req.method,
      path: req.path,
      headers: {
        authorization: req.headers.authorization ? 'Bearer ***' : 'none',
        'content-type': req.headers['content-type'] || 'none'
      }
    });
    next();
  });
} else {
  app.use(morgan('combined', {
    stream: {
      write: (message) => logger.info(message.trim())
    }
  }));
}

// Static files (uploads)
app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

// Rate limiting
app.use('/api/', generalLimiter);

// Health check endpoint
app.get('/health', async (req, res) => {
  try {
    // Check database connection
    await require('./models').sequelize.authenticate();
    const dbStatus = 'connected';

    res.status(200).json({
      status: 'healthy',
      database: dbStatus,
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      environment: process.env.NODE_ENV,
      version: process.env.API_VERSION || 'v1'
    });
  } catch (error) {
    res.status(503).json({
      status: 'unhealthy',
      database: 'disconnected',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      environment: process.env.NODE_ENV,
      version: process.env.API_VERSION || 'v1',
      error: error.message
    });
  }
});

// API routes
app.use(`/api/${process.env.API_VERSION || 'v1'}`, routes);

// 404 handler
app.use(notFoundHandler);

// Global error handler (must be last)
app.use(errorHandler);

module.exports = app;
