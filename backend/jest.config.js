module.exports = {
  testEnvironment: 'node',
  testMatch: ['**/tests/**/*.test.js'],
  setupFilesAfterEnv: ['./tests/setup.js'],
  coverageDirectory: 'coverage',
  collectCoverageFrom: [
    'src/**/*.js',
    '!src/seeders/**',
    '!src/server.js',
    '!src/jobs/**',
    '!src/utils/logger.js',
    '!src/config/validateEnv.js',
    '!src/config/database.js',
    '!src/config/multer.js',
    '!src/config/swagger.js',
    '!src/routes/**',
    '!src/validators/**'
  ],
  coverageThreshold: {
    global: { branches: 70, functions: 80, lines: 80, statements: 80 }
  },
  testTimeout: 30000
};
