/**
 * Ручная проверка отправки SMS через Payom (gateway.payom.tj).
 * Не часть автотестов — одноразовый прогон с реального устройства,
 * чтобы подтвердить, что IP не забанен шлюзом.
 *
 * Перед запуском заполни в backend/.env:
 *   SMS_API_TOKEN, SMS_SENDER_NAME, SMS_TEMPLATE_IDS
 * и передай номер через переменную окружения запуска:
 *
 *   SMS_TEST_PHONE=992186663333 node scripts/test-payom-sms.js
 *
 * Шаблон user.verification_code: «{text-1} - код подтверждения: {code-1}».
 */
require('dotenv').config();
const { sendTemplateSms } = require('../src/services/notifications/payomSmsTransport');

const phone = process.env.SMS_TEST_PHONE;
const templateKey = process.env.SMS_TEST_TEMPLATE_KEY || 'user.verification_code';

if (!phone) {
  console.error('Задай SMS_TEST_PHONE перед запуском.');
  process.exit(1);
}

sendTemplateSms({
  templateKey,
  telephone: phone,
  variables: { 'text-1': 'RabbitFarm', 'code-1': '123456' }
})
  .then((body) => {
    console.log('OK', body);
  })
  .catch((err) => {
    console.error('FAIL', { message: err.message, status: err.status, permanent: err.permanent });
    process.exit(1);
  });
