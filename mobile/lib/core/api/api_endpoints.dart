class ApiEndpoints {
  // Base URL - auto-detect platform
  static const String baseUrl = 'http://localhost:3000/api/v1';

  // For Android emulator, use:
  // static const String baseUrl = 'http://10.0.2.2:3000/api/v1';

  // For physical device, use your PC's IP:
  // static const String baseUrl = 'http://192.168.1.XXX:3000/api/v1';

  // Health check
  static const String health = '/health';

  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String profile = '/auth/me';
  static const String changePassword = '/auth/change-password';

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

  // Reports endpoints
  static const String reportDashboard = '/reports/dashboard';
  static const String reportFarm = '/reports/farm';
  static const String reportHealth = '/reports/health';
  static const String reportFinancial = '/reports/financial';
}
