const crypto = require('crypto');

function generateOtp() {
  return String(crypto.randomInt(0, 1_000_000)).padStart(6, '0');
}

function hashOtp(code) {
  return crypto.createHash('sha256').update(code).digest('hex');
}

module.exports = { generateOtp, hashOtp };
