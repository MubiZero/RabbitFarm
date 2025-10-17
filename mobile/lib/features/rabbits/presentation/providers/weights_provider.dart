import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/rabbit_weight_model.dart';
import '../../data/repositories/rabbits_repository.dart';
import 'rabbits_provider.dart';

/// Provider for weight history of a specific rabbit
final weightHistoryProvider =
    FutureProvider.family<List<RabbitWeight>, int>((ref, rabbitId) async {
  final repository = ref.watch(rabbitsRepositoryProvider);
  return repository.getWeightHistory(rabbitId);
});

/// Provider for managing weight operations
final weightsNotifierProvider =
    StateNotifierProvider<WeightsNotifier, AsyncValue<void>>((ref) {
  return WeightsNotifier(ref);
});

class WeightsNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  WeightsNotifier(this._ref) : super(const AsyncData(null));

  /// Add new weight record
  Future<void> addWeightRecord(int rabbitId, AddWeightRequest request) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = _ref.read(rabbitsRepositoryProvider);
      await repository.addWeightRecord(rabbitId, request);

      // Invalidate weight history to refresh
      _ref.invalidate(weightHistoryProvider(rabbitId));

      // Also invalidate rabbit details to update current weight
      _ref.invalidate(rabbitDetailProvider(rabbitId));
    });
  }
}
