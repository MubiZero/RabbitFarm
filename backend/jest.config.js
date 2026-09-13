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
    '!src/config/minio.js',
    '!src/config/swagger.js',
    '!src/routes/**',
    '!src/validators/**'
  ],
  coverageThreshold: {
    global: { branches: 70, functions: 80, lines: 80, statements: 80 }
  },
  // 60 с, а не 30: тяжёлая подготовка изоляционных наборов (две фермы со
  // всей обвязкой) занимает ~9 с на здоровом раннере, но 2026-09-13 на
  // медленном упёрлась в 30 с и уронила 44 теста разом. Перезапуск того же
  // коммита прошёл за 9,3 с — это разброс раннера, а не поведение кода.
  testTimeout: 60000
};
