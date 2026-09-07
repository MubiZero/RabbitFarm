import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/session.dart';
import '../../../../core/providers/api_providers.dart';
import '../../data/repositories/device_tokens_repository.dart';

final deviceTokensRepositoryProvider = Provider<DeviceTokensRepository>((ref) {
  ref.watch(sessionRevisionProvider);
  final apiClient = ref.watch(apiClientProvider);
  return DeviceTokensRepository(apiClient);
});
