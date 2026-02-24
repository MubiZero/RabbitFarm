/**
 * Validates required environment variables at startup.
 * Throws an error with a clear message if any are missing or insecure.
 */
function validateEnv() {
  const errors = [];

  // Required variables
  const required = [
    'DB_HOST',
    'DB_NAME',
    'DB_USER',
    'DB_PASSWORD',
    'JWT_SECRET',
    'JWT_REFRESH_SECRET'
  ];

  for (const key of required) {
    if (!process.env[key]) {
      errors.push(`Missing required env var: ${key}`);
    }
  }

  // Security checks (only in production)
  if (process.env.NODE_ENV === 'production') {
    if (process.env.JWT_SECRET && process.env.JWT_SECRET.length < 32) {
      errors.push('JWT_SECRET must be at least 32 characters in production');
    }
    if (process.env.JWT_REFRESH_SECRET && process.env.JWT_REFRESH_SECRET.length < 32) {
      errors.push('JWT_REFRESH_SECRET must be at least 32 characters in production');
    }
    const insecureDefaults = [
      'your_super_secret_jwt_key_change_this_in_production',
      'your_super_secret_refresh_key_change_this_in_production'
    ];
    if (insecureDefaults.includes(process.env.JWT_SECRET)) {
      errors.push('JWT_SECRET must not use the default value in production');
    }
    if (insecureDefaults.includes(process.env.JWT_REFRESH_SECRET)) {
      errors.push('JWT_REFRESH_SECRET must not use the default value in production');
    }
  }

  if (errors.length > 0) {
    throw new Error(`Environment validation failed:\n${errors.map(e => `  - ${e}`).join('\n')}`);
  }
}

module.exports = validateEnv;
