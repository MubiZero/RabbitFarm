/**
 * Quick API Test Script
 * Run this after server is started to test basic functionality
 */

require('dotenv').config();
const axios = require('axios');

const BASE_URL = `http://localhost:${process.env.PORT || 3000}/api/${process.env.API_VERSION || 'v1'}`;
let accessToken = '';
let rabbitId = '';

// Colors for console output
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m'
};

function log(message, color = 'reset') {
  console.log(`${colors[color]}${message}${colors.reset}`);
}

function success(message) {
  log(`✅ ${message}`, 'green');
}

function error(message) {
  log(`❌ ${message}`, 'red');
}

function info(message) {
  log(`ℹ️  ${message}`, 'blue');
}

function section(message) {
  log(`\n${'='.repeat(60)}`, 'cyan');
  log(`  ${message}`, 'cyan');
  log('='.repeat(60), 'cyan');
}

async function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

// Test functions
async function testHealthCheck() {
  section('Test 1: Health Check');
  try {
    const response = await axios.get('http://localhost:' + (process.env.PORT || 3000) + '/health');
    if (response.data.status === 'healthy') {
      success('Health check passed');
      info(`Uptime: ${response.data.uptime}s`);
      return true;
    }
  } catch (err) {
    error(`Health check failed: ${err.message}`);
    return false;
  }
}

async function testLogin() {
  section('Test 2: Login');
  try {
    const response = await axios.post(`${BASE_URL}/auth/login`, {
      email: 'admin@rabbitfarm.com',
      password: 'admin123'
    });

    if (response.data.success && response.data.data.access_token) {
      accessToken = response.data.data.access_token;
      success('Login successful');
      info(`User: ${response.data.data.user.full_name} (${response.data.data.user.role})`);
      info(`Token: ${accessToken.substring(0, 20)}...`);
      return true;
    }
  } catch (err) {
    error(`Login failed: ${err.response?.data?.error?.message || err.message}`);
    return false;
  }
}

async function testGetProfile() {
  section('Test 3: Get Profile');
  try {
    const response = await axios.get(`${BASE_URL}/auth/me`, {
      headers: { Authorization: `Bearer ${accessToken}` }
    });

    if (response.data.success) {
      success('Get profile successful');
      info(`Name: ${response.data.data.full_name}`);
      info(`Email: ${response.data.data.email}`);
      info(`Role: ${response.data.data.role}`);
      return true;
    }
  } catch (err) {
    error(`Get profile failed: ${err.response?.data?.error?.message || err.message}`);
    return false;
  }
}

async function testGetStatistics() {
  section('Test 4: Get Statistics');
  try {
    const response = await axios.get(`${BASE_URL}/rabbits/statistics`, {
      headers: { Authorization: `Bearer ${accessToken}` }
    });

    if (response.data.success) {
      success('Get statistics successful');
      const stats = response.data.data;
      info(`Total rabbits: ${stats.total}`);
      info(`Alive: ${stats.alive}`);
      info(`Males: ${stats.males}`);
      info(`Females: ${stats.females}`);
      return true;
    }
  } catch (err) {
    error(`Get statistics failed: ${err.response?.data?.error?.message || err.message}`);
    return false;
  }
}

async function testCreateRabbit() {
  section('Test 5: Create Rabbit');
  try {
    const response = await axios.post(`${BASE_URL}/rabbits`, {
      tag_id: `TEST-${Date.now()}`,
      name: 'Тестовый кролик',
      breed_id: 1,
      sex: 'male',
      birth_date: '2024-01-15',
      status: 'healthy',
      purpose: 'breeding',
      current_weight: 4.5
    }, {
      headers: { Authorization: `Bearer ${accessToken}` }
    });

    if (response.data.success) {
      rabbitId = response.data.data.id;
      success('Create rabbit successful');
      info(`Rabbit ID: ${rabbitId}`);
      info(`Name: ${response.data.data.name}`);
      info(`Tag: ${response.data.data.tag_id}`);
      return true;
    }
  } catch (err) {
    error(`Create rabbit failed: ${err.response?.data?.error?.message || err.message}`);
    return false;
  }
}

async function testGetRabbit() {
  section('Test 6: Get Rabbit by ID');
  try {
    const response = await axios.get(`${BASE_URL}/rabbits/${rabbitId}`, {
      headers: { Authorization: `Bearer ${accessToken}` }
    });

    if (response.data.success) {
      success('Get rabbit successful');
      info(`Name: ${response.data.data.name}`);
      info(`Breed: ${response.data.data.Breed.name}`);
      info(`Age: ${Math.floor((new Date() - new Date(response.data.data.birth_date)) / (1000 * 60 * 60 * 24 * 30))} months`);
      return true;
    }
  } catch (err) {
    error(`Get rabbit failed: ${err.response?.data?.error?.message || err.message}`);
    return false;
  }
}

async function testListRabbits() {
  section('Test 7: List Rabbits');
  try {
    const response = await axios.get(`${BASE_URL}/rabbits?page=1&limit=10`, {
      headers: { Authorization: `Bearer ${accessToken}` }
    });

    if (response.data.success) {
      success('List rabbits successful');
      info(`Total: ${response.data.data.pagination.total}`);
      info(`Page: ${response.data.data.pagination.page}/${response.data.data.pagination.totalPages}`);
      info(`Items: ${response.data.data.items.length}`);
      return true;
    }
  } catch (err) {
    error(`List rabbits failed: ${err.response?.data?.error?.message || err.message}`);
    return false;
  }
}

async function testUpdateRabbit() {
  section('Test 8: Update Rabbit');
  try {
    const response = await axios.put(`${BASE_URL}/rabbits/${rabbitId}`, {
      name: 'Обновленный кролик',
      current_weight: 5.0
    }, {
      headers: { Authorization: `Bearer ${accessToken}` }
    });

    if (response.data.success) {
      success('Update rabbit successful');
      info(`New name: ${response.data.data.name}`);
      info(`New weight: ${response.data.data.current_weight} kg`);
      return true;
    }
  } catch (err) {
    error(`Update rabbit failed: ${err.response?.data?.error?.message || err.message}`);
    return false;
  }
}

async function testAddWeight() {
  section('Test 9: Add Weight Record');
  try {
    const response = await axios.post(`${BASE_URL}/rabbits/${rabbitId}/weights`, {
      weight: 5.2,
      notes: 'Тестовое взвешивание'
    }, {
      headers: { Authorization: `Bearer ${accessToken}` }
    });

    if (response.data.success) {
      success('Add weight successful');
      info(`Weight: ${response.data.data.weight} kg`);
      return true;
    }
  } catch (err) {
    error(`Add weight failed: ${err.response?.data?.error?.message || err.message}`);
    return false;
  }
}

async function testDeleteRabbit() {
  section('Test 10: Delete Rabbit');
  try {
    const response = await axios.delete(`${BASE_URL}/rabbits/${rabbitId}`, {
      headers: { Authorization: `Bearer ${accessToken}` }
    });

    if (response.data.success) {
      success('Delete rabbit successful');
      return true;
    }
  } catch (err) {
    error(`Delete rabbit failed: ${err.response?.data?.error?.message || err.message}`);
    return false;
  }
}

// Main test runner
async function runTests() {
  log('\n' + '═'.repeat(60), 'cyan');
  log('  🧪 RabbitFarm API Test Suite', 'cyan');
  log('═'.repeat(60) + '\n', 'cyan');

  info(`Testing API at: ${BASE_URL}`);
  await sleep(1000);

  const tests = [
    testHealthCheck,
    testLogin,
    testGetProfile,
    testGetStatistics,
    testCreateRabbit,
    testGetRabbit,
    testListRabbits,
    testUpdateRabbit,
    testAddWeight,
    testDeleteRabbit
  ];

  let passed = 0;
  let failed = 0;

  for (const test of tests) {
    try {
      const result = await test();
      if (result) {
        passed++;
      } else {
        failed++;
      }
      await sleep(500);
    } catch (err) {
      error(`Test error: ${err.message}`);
      failed++;
    }
  }

  // Summary
  section('Test Summary');
  log(`\nTotal Tests: ${tests.length}`, 'cyan');
  success(`Passed: ${passed}`);
  if (failed > 0) {
    error(`Failed: ${failed}`);
  }
  log(`\nSuccess Rate: ${Math.round((passed / tests.length) * 100)}%\n`, 'yellow');

  if (passed === tests.length) {
    success('🎉 All tests passed! Backend is working perfectly!');
  } else {
    error('⚠️  Some tests failed. Please check the errors above.');
  }

  process.exit(failed > 0 ? 1 : 0);
}

// Run tests
runTests().catch(err => {
  error(`Fatal error: ${err.message}`);
  process.exit(1);
});
