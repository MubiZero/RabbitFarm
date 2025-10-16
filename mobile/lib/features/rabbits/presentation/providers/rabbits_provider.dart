import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/rabbit_model.dart';
import '../../data/models/rabbit_statistics.dart';
import '../../data/repositories/rabbits_repository.dart';
import '../../../../shared/models/api_response.dart';

// Rabbits Repository provider
final rabbitsRepositoryProvider = Provider<RabbitsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RabbitsRepository(apiClient: apiClient);
});

// Rabbits List State
class RabbitsListState {
  final List<RabbitModel> rabbits;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int totalPages;
  final int total;
  final bool hasMore;

  RabbitsListState({
    this.rabbits = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.total = 0,
    this.hasMore = false,
  });

  RabbitsListState copyWith({
    List<RabbitModel>? rabbits,
    bool? isLoading,
    String? error,
    int? currentPage,
    int? totalPages,
    int? total,
    bool? hasMore,
  }) {
    return RabbitsListState(
      rabbits: rabbits ?? this.rabbits,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

// Rabbits List Notifier
class RabbitsListNotifier extends StateNotifier<RabbitsListState> {
  final RabbitsRepository _repository;

  RabbitsListNotifier(this._repository) : super(RabbitsListState()) {
    loadRabbits();
  }

  // Load rabbits (first page or refresh)
  Future<void> loadRabbits({
    String? search,
    String? sex,
    String? status,
    int? breedId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _repository.getRabbits(
        page: 1,
        limit: 10,
        search: search,
        sex: sex,
        status: status,
        breedId: breedId,
      );

      state = state.copyWith(
        rabbits: result.items,
        isLoading: false,
        currentPage: result.page,
        totalPages: result.totalPages,
        total: result.total,
        hasMore: result.page < result.totalPages,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  // Load more rabbits (pagination)
  Future<void> loadMore({
    String? search,
    String? sex,
    String? status,
    int? breedId,
  }) async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final result = await _repository.getRabbits(
        page: state.currentPage + 1,
        limit: 10,
        search: search,
        sex: sex,
        status: status,
        breedId: breedId,
      );

      state = state.copyWith(
        rabbits: [...state.rabbits, ...result.items],
        isLoading: false,
        currentPage: result.page,
        totalPages: result.totalPages,
        total: result.total,
        hasMore: result.page < result.totalPages,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  // Refresh
  Future<void> refresh() async {
    await loadRabbits();
  }

  // Delete rabbit
  Future<void> deleteRabbit(int id) async {
    try {
      await _repository.deleteRabbit(id);
      state = state.copyWith(
        rabbits: state.rabbits.where((r) => r.id != id).toList(),
        total: state.total - 1,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString().replaceAll('Exception: ', ''),
      );
      rethrow;
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Rabbits List Provider
final rabbitsListProvider =
    StateNotifierProvider<RabbitsListNotifier, RabbitsListState>((ref) {
  final repository = ref.watch(rabbitsRepositoryProvider);
  return RabbitsListNotifier(repository);
});

// Statistics State
class StatisticsState {
  final RabbitStatistics? statistics;
  final bool isLoading;
  final String? error;

  StatisticsState({
    this.statistics,
    this.isLoading = false,
    this.error,
  });

  StatisticsState copyWith({
    RabbitStatistics? statistics,
    bool? isLoading,
    String? error,
  }) {
    return StatisticsState(
      statistics: statistics ?? this.statistics,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Statistics Notifier
class StatisticsNotifier extends StateNotifier<StatisticsState> {
  final RabbitsRepository _repository;

  StatisticsNotifier(this._repository) : super(StatisticsState()) {
    loadStatistics();
  }

  Future<void> loadStatistics() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final statistics = await _repository.getStatistics();
      state = state.copyWith(
        statistics: statistics,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> refresh() async {
    await loadStatistics();
  }
}

// Statistics Provider
final statisticsProvider =
    StateNotifierProvider<StatisticsNotifier, StatisticsState>((ref) {
  final repository = ref.watch(rabbitsRepositoryProvider);
  return StatisticsNotifier(repository);
});

// Single Rabbit Provider (for detail screen)
final rabbitDetailProvider =
    FutureProvider.family<RabbitModel, int>((ref, id) async {
  final repository = ref.watch(rabbitsRepositoryProvider);
  return repository.getRabbitById(id);
});
