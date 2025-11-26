import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../rabbits/data/models/breeding_model.dart';
import '../../data/repositories/breeding_repository.dart';

// Breeding Repository provider
final breedingRepositoryProvider = Provider<BreedingRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BreedingRepository(apiClient: apiClient);
});

// Breeding List State
class BreedingListState {
  final List<BreedingModel> breedings;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int totalPages;
  final int total;
  final bool hasMore;

  BreedingListState({
    this.breedings = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.total = 0,
    this.hasMore = false,
  });

  BreedingListState copyWith({
    List<BreedingModel>? breedings,
    bool? isLoading,
    String? error,
    int? currentPage,
    int? totalPages,
    int? total,
    bool? hasMore,
  }) {
    return BreedingListState(
      breedings: breedings ?? this.breedings,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

// Breeding List Notifier
class BreedingListNotifier extends StateNotifier<BreedingListState> {
  final BreedingRepository _repository;

  BreedingListNotifier(this._repository) : super(BreedingListState()) {
    loadBreedings();
  }

  // Load breedings (first page or refresh)
  Future<void> loadBreedings({
    String? status,
    int? maleId,
    int? femaleId,
    String? fromDate,
    String? toDate,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _repository.getBreedings(
        page: 1,
        limit: 20,
        status: status,
        maleId: maleId,
        femaleId: femaleId,
        fromDate: fromDate,
        toDate: toDate,
      );

      state = state.copyWith(
        breedings: result.items,
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

  // Load more breedings (pagination)
  Future<void> loadMore({
    String? status,
    int? maleId,
    int? femaleId,
    String? fromDate,
    String? toDate,
  }) async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final result = await _repository.getBreedings(
        page: state.currentPage + 1,
        limit: 20,
        status: status,
        maleId: maleId,
        femaleId: femaleId,
        fromDate: fromDate,
        toDate: toDate,
      );

      state = state.copyWith(
        breedings: [...state.breedings, ...result.items],
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
    await loadBreedings();
  }

  // Delete breeding
  Future<void> deleteBreeding(int id) async {
    try {
      await _repository.deleteBreeding(id);
      state = state.copyWith(
        breedings: state.breedings.where((b) => b.id != id).toList(),
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

// Breeding List Provider
final breedingListProvider =
    StateNotifierProvider<BreedingListNotifier, BreedingListState>((ref) {
  final repository = ref.watch(breedingRepositoryProvider);
  return BreedingListNotifier(repository);
});

// Single Breeding Provider (for detail screen)
final breedingDetailProvider =
    FutureProvider.family<BreedingModel, int>((ref, id) async {
  final repository = ref.watch(breedingRepositoryProvider);
  return repository.getBreedingById(id);
});

// Breeding Statistics Provider
final breedingStatisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repository = ref.watch(breedingRepositoryProvider);
  return repository.getStatistics();
});
