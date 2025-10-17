import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../shared/models/api_response.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../models/pedigree_model.dart';

/// Репозиторий для работы с родословной кроликов
class PedigreeRepository {
  final ApiClient _apiClient;

  PedigreeRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Получить родословную кролика
  ///
  /// [rabbitId] - ID кролика
  /// [generations] - количество поколений (по умолчанию 3)
  Future<PedigreeModel> getPedigree(int rabbitId, {int generations = 3}) async {
    try {
      final response = await _apiClient.dio.get(
        '/rabbits/$rabbitId/pedigree',
        queryParameters: {'generations': generations},
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw Exception(apiResponse.message);
      }

      // Добавим логирование для отладки
      print('Pedigree data: ${apiResponse.data}');

      return PedigreeModel.fromJson(apiResponse.data!);
    } on DioException catch (e) {
      print('DioException in getPedigree: ${e.message}');
      throw Exception(e.message ?? 'Ошибка получения родословной');
    } catch (e, stackTrace) {
      print('Error in getPedigree: $e');
      print('StackTrace: $stackTrace');
      throw Exception('Ошибка десериализации: $e');
    }
  }
}

/// Provider для репозитория родословной
final pedigreeRepositoryProvider = Provider<PedigreeRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PedigreeRepository(apiClient: apiClient);
});
