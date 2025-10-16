import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../shared/models/api_response.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/breed_model.dart';

// Breeds provider
final breedsProvider = FutureProvider<List<BreedModel>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);

  try {
    final response = await apiClient.getBreeds();

    // API returns structure: {success: true, data: [...], message: "..."}
    if (response.data == null) {
      throw Exception('Нет данных от сервера');
    }

    final responseData = response.data as Map<String, dynamic>;

    if (responseData['success'] != true) {
      throw Exception(responseData['message'] ?? 'Ошибка загрузки пород');
    }

    final breedsData = responseData['data'] as List<dynamic>;

    return breedsData
        .map((item) => BreedModel.fromJson(item as Map<String, dynamic>))
        .toList();
  } catch (e) {
    print('Ошибка загрузки пород: $e');
    throw Exception('Ошибка загрузки пород: ${e.toString()}');
  }
});
