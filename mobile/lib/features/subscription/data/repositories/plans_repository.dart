import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_error.dart';
import '../models/plan_option.dart';

/// Список тарифов — открыт, без входа: цену спрашивают до регистрации, а не
/// после трёхсот записей.
class PlansRepository {
  final ApiClient _apiClient;

  PlansRepository(this._apiClient);

  Future<List<PlanOption>> getPlans() async {
    return guardRequest(() async {
      final response = await _apiClient.get(ApiEndpoints.plans);
      final items = response.data['data']['plans'] as List<dynamic>;
      return items
          .map((item) => PlanOption.fromJson(item as Map<String, dynamic>))
          .toList();
    }, 'Не удалось загрузить тарифы');
  }
}
