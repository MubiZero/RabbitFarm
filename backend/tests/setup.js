process.env.NODE_ENV = 'test';
// Часть сценариев заводит несколько пользователей (например проверки IDOR),
// поэтому в тестах регистрация открыта. Закрытую проверяем отдельно.
process.env.ALLOW_REGISTRATION = 'true';
process.env.JWT_SECRET = 'test_secret_key_minimum_32_chars_long';
process.env.JWT_REFRESH_SECRET = 'test_refresh_secret_key_minimum_32_chars';
process.env.JWT_EXPIRE = '15m';
process.env.JWT_REFRESH_EXPIRE = '7d';
// Браузерный источник для проверок CORS. Задаётся здесь, а не берётся из
// `.env`: у разработчика он есть, в CI его нет вовсе — и тест, зелёный на
// машине, краснел в сборке.
process.env.CORS_ORIGIN = 'http://localhost:3000';

// Наружу тесты не ходят.
//
// Та же ловушка, что с CORS_ORIGIN, только наизнанку: `dotenv` подтягивает
// `backend/.env`, а у разработчика там боевые `SMS_*` — и регистрация по
// телефону честно ждала настоящий шлюз gateway.payom.tj до 15 секунд на
// каждый вызов (`otpAuthService` ждёт отправку кода, не отпуская ответ).
// Пока шлюз отвечал быстро, этого никто не замечал; стоило сети моргнуть —
// и файл, регистрирующий несколько ферм, переваливал за 60-секундный предел
// jest, роняя себя целиком. Замерено на `auth.test.js`: 1,6 с при живом
// шлюзе и 22 с при недоступном, а в полном прогоне отдельные файлы
// растягивались до 900 с. В CI этих переменных нет вовсе, поэтому там
// набор всегда был зелёным и быстрым — флак жил только на машинах
// разработчиков.
//
// Гасим сами переменные, а не подменяем адрес: так тесты идут ровно той же
// веткой, что и CI («не настроено» — мгновенный отказ), а не выдуманной.
//
// Пустая строка, а не `delete`: конфиги зовут `dotenv.config()` при первом
// require, а он заполняет только отсутствующие ключи. Удалённая переменная
// тут же возвращалась бы из `.env` — проверено, прогон так и оставался
// медленным.
//
// Гасим все внешние интеграции сразу, а не только SMS: у другого
// разработчика в `.env` окажутся ключи платёжки или Firebase, и та же дыра
// откроется через другую дверь. MinIO не трогаем — это не внешний шлюз, а
// часть стенда, и фото-тесты с ним работают по-настоящему.
for (const key of [
  'SMS_API_TOKEN', 'SMS_SENDER_NAME',                       // payom
  'SMTP_HOST', 'SMTP_USERNAME', 'SMTP_PASSWORD', 'SMTP_FROM_ADDRESS',
  'ESKHATA_BASE_URL', 'ESKHATA_COMPANY_ID',                 // платежи
  'ESKHATA_HASH_KEY', 'ESKHATA_MERCHANT_ID',
  'FIREBASE_PROJECT_ID', 'FIREBASE_CLIENT_EMAIL', 'FIREBASE_PRIVATE_KEY',
  'TELEGRAM_ALERT_BOT_TOKEN', 'TELEGRAM_ALERT_CHAT_ID',
  'SENTRY_DSN',
  'REDIS_URL'
]) {
  process.env[key] = '';
}

// Заглушаем логгер чтобы не засорять вывод тестов
jest.mock('../src/utils/logger', () => ({
  info: jest.fn(),
  error: jest.fn(),
  warn: jest.fn(),
  debug: jest.fn()
}));

// Заглушаем console.error/warn из production кода (error paths в контроллерах)
beforeAll(() => {
  jest.spyOn(console, 'error').mockImplementation(() => {});
  jest.spyOn(console, 'warn').mockImplementation(() => {});
});

afterAll(() => {
  jest.restoreAllMocks();
});
