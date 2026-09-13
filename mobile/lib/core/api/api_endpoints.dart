class ApiEndpoints {
  // Base URL Configuration
  // To use different environments, set environment variable when building:
  // flutter run --dart-define=API_URL=http://localhost:4567/api/v1
  // Production VPS: http://108.181.167.236:4567/api/v1
  // Local Docker: http://localhost:4567/api/v1 (iOS/Web/Desktop)
  // Android Emulator: http://10.0.2.2:4567/api/v1
  
  static const String _defaultBaseUrl = 'http://localhost:4567/api/v1';
  
  // Get base URL from environment or use default
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: _defaultBaseUrl,
  );

  // Alternative URLs for different environments (documented for reference)
  // Production: http://108.181.167.236:4567/api/v1
  // Local development: http://localhost:4567/api/v1
  // Android emulator: http://10.0.2.2:4567/api/v1
  // iOS simulator: http://localhost:4567/api/v1

  // Health check
  // Проверка живости отвечает в корне сервера, вне версии API, поэтому
  // склеивать её с baseUrl нельзя — получался /api/v1/health и 404.
  static const String health = '/health';

  // Auth endpoints
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String profile = '/auth/me';
  // Чтение и запись профиля живут на разных маршрутах: PUT /auth/me на
  // сервере нет, и запрос уходил в 404.
  static const String updateProfile = '/auth/profile';
  // Вход всегда по коду: телефон — основной путь, почта — запасной. Пароля
  // в сервисе нет вовсе (см. README, «Accounts»).
  static const String otpRequest = '/auth/otp/request';
  static const String otpVerify = '/auth/otp/verify';

  // Rabbits endpoints
  static const String rabbits = '/rabbits';
  static const String rabbitStatistics = '/rabbits/statistics';

  // Breeds endpoints
  static const String breeds = '/breeds';
  
  // Breeding endpoints
  static const String breeding = '/breeding';
  static const String breedingStatistics = '/breeding/statistics';

  // Cages endpoints
  static const String cages = '/cages';

  // Feed endpoints
  static const String feeds = '/feeds';
  static const String feedingRecords = '/feeding-records';
  static String rabbitFeedingRecords(int rabbitId) =>
      '/rabbits/$rabbitId/feeding-records';

  // Vaccinations endpoints
  static const String vaccinations = '/vaccinations';
  static const String vaccinationStatistics = '/vaccinations/statistics';
  static const String vaccinationsUpcoming = '/vaccinations/upcoming';
  static const String vaccinationsOverdue = '/vaccinations/overdue';

  // Medical Records endpoints
  static const String medicalRecords = '/medical-records';
  static String rabbitMedicalRecords(int rabbitId) =>
      '/rabbits/$rabbitId/medical-records';

  // Transactions endpoints
  static const String transactions = '/transactions';
  static const String transactionStatistics = '/transactions/statistics';
  static const String monthlyReport = '/transactions/monthly-report';
  static String rabbitTransactions(int rabbitId) =>
      '/rabbits/$rabbitId/transactions';

  // Tasks endpoints
  static const String tasks = '/tasks';
  static const String taskStatistics = '/tasks/statistics';
  static const String tasksUpcoming = '/tasks/upcoming';

  // Notes endpoints
  static const String notes = '/notes';

  // Device tokens (push-уведомления)
  static const String deviceTokens = '/device-tokens';

  // Photos endpoints (farm-wide feed for the Journal)
  static const String photos = '/photos';

  // Платформенная админка (суперадмин): тарифы и все фермы сервиса
  static const String platformSummary = '/platform-admin/summary';
  static const String platformPlans = '/platform-admin/plans';
  static String platformPlan(int id) => '/platform-admin/plans/$id';
  static const String platformFarms = '/platform-admin/farms';
  static String platformFarm(int id) => '/platform-admin/farms/$id';
  static String platformFarmPlan(int id) => '/platform-admin/farms/$id/plan';
  static String platformFarmStatus(int id) => '/platform-admin/farms/$id/status';
  static String platformFarmExtras(int id) => '/platform-admin/farms/$id/extras';
  static String platformFarmPlanExpiry(int id) =>
      '/platform-admin/farms/$id/plan-expiry';
  static String platformFarmExport(int id) => '/platform-admin/farms/$id/export';
  static String platformFarmImpersonate(int id) =>
      '/platform-admin/farms/$id/impersonate';
  static String platformFarmRestore(int id) =>
      '/platform-admin/farms/$id/restore';
  static const String platformAnnouncements = '/platform-admin/announcements';
  static const String platformSupportRequests =
      '/platform-admin/support-requests';
  static String platformSupportRequestResolve(int id) =>
      '/platform-admin/support-requests/$id/resolve';

  // Обращение фермы в поддержку — доступно любой роли, работает даже при
  // закрытом доступе (см. backend/src/middleware/auth.js,
  // authenticateEvenIfFarmBlocked).
  static const String supportRequests = '/support-requests';
  static const String supportContact = '/support-requests/contact';

  // Reports endpoints
  static const String reportDashboard = '/reports/dashboard';
  static const String reportFarm = '/reports/farm';
  static const String reportHealth = '/reports/health';
  static const String reportFinancial = '/reports/financial';

  // Оплата продления тарифа (см. docs/plans/PLATFORM-ADMIN.md, 4.1)
  static const String payments = '/payments';
  static String paymentStatus(String invoiceId) => '/payments/$invoiceId';
}
