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

  // Cages endpoints
  static const String cages = '/cages';

  // Feed endpoints
  static const String feeds = '/feeds';

  // Vaccinations endpoints
  static const String vaccinations = '/vaccinations';
  static const String vaccinationStatistics = '/vaccinations/statistics';
  static const String vaccinationsUpcoming = '/vaccinations/upcoming';
  static const String vaccinationsOverdue = '/vaccinations/overdue';

  // Medical Records endpoints
  static const String medicalRecords = '/medical-records';
  static String rabbitMedicalRecords(int rabbitId) =>
      '/rabbits/$rabbitId/medical-records';
}
