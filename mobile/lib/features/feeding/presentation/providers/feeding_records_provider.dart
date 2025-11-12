import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/providers/api_providers.dart';
import '../../data/models/feeding_record_model.dart';
import '../../data/repositories/feeding_records_repository.dart';

/// Provider for FeedingRecordsRepository
final feedingRecordsRepositoryProvider = Provider<FeedingRecordsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FeedingRecordsRepository(apiClient);
});

/// State class for feeding records list
class FeedingRecordsState {
  final List<FeedingRecord> records;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int currentPage;

  const FeedingRecordsState({
    this.records = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
  });

  FeedingRecordsState copyWith({
    List<FeedingRecord>? records,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? currentPage,
  }) {
    return FeedingRecordsState(
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// Notifier for managing feeding records list state
class FeedingRecordsNotifier extends StateNotifier<FeedingRecordsState> {
  final FeedingRecordsRepository _repository;

  FeedingRecordsNotifier(this._repository) : super(const FeedingRecordsState());

  /// Load feeding records with optional filters
  Future<void> loadFeedingRecords({
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
    int? rabbitId,
    int? feedId,
    int? cageId,
    DateTime? fromDate,
    DateTime? toDate,
    bool refresh = false,
  }) async {
    if (state.isLoading) return;

    if (refresh) {
      state = const FeedingRecordsState(isLoading: true);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final records = await _repository.getFeedingRecords(
        page: page ?? state.currentPage,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
        rabbitId: rabbitId,
        feedId: feedId,
        cageId: cageId,
        fromDate: fromDate,
        toDate: toDate,
      );

      if (refresh) {
        state = FeedingRecordsState(
          records: records,
          isLoading: false,
          hasMore: records.length >= (limit ?? 10),
          currentPage: page ?? 1,
        );
      } else {
        state = state.copyWith(
          records: [...state.records, ...records],
          isLoading: false,
          hasMore: records.length >= (limit ?? 10),
          currentPage: (page ?? state.currentPage) + 1,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Refresh feeding records list
  Future<void> refresh() async {
    await loadFeedingRecords(refresh: true);
  }

  /// Load more feeding records (pagination)
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    await loadFeedingRecords(page: state.currentPage);
  }

  /// Add new feeding record to the list
  void addRecord(FeedingRecord record) {
    state = state.copyWith(
      records: [record, ...state.records],
    );
  }

  /// Update feeding record in the list
  void updateRecord(FeedingRecord record) {
    final updatedRecords = state.records.map((r) {
      return r.id == record.id ? record : r;
    }).toList();

    state = state.copyWith(records: updatedRecords);
  }

  /// Remove feeding record from the list
  void removeRecord(int recordId) {
    final updatedRecords = state.records.where((r) => r.id != recordId).toList();
    state = state.copyWith(records: updatedRecords);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for feeding records list state
final feedingRecordsProvider =
    StateNotifierProvider<FeedingRecordsNotifier, FeedingRecordsState>((ref) {
  final repository = ref.watch(feedingRecordsRepositoryProvider);
  return FeedingRecordsNotifier(repository);
});

/// Provider for single feeding record by ID
final feedingRecordByIdProvider =
    FutureProvider.autoDispose.family<FeedingRecord, int>((ref, id) async {
  final repository = ref.watch(feedingRecordsRepositoryProvider);
  return repository.getFeedingRecordById(id);
});

/// Provider for feeding records by rabbit ID
final rabbitFeedingRecordsProvider =
    FutureProvider.autoDispose.family<List<FeedingRecord>, int>((ref, rabbitId) async {
  final repository = ref.watch(feedingRecordsRepositoryProvider);
  return repository.getRabbitFeedingRecords(rabbitId);
});

/// Provider for creating a feeding record
final createFeedingRecordProvider = FutureProvider.autoDispose
    .family<FeedingRecord, FeedingRecordCreate>((ref, recordCreate) async {
  final repository = ref.watch(feedingRecordsRepositoryProvider);
  final record = await repository.createFeedingRecord(recordCreate);

  // Add to feeding records list
  ref.read(feedingRecordsProvider.notifier).addRecord(record);

  return record;
});

/// Provider for updating a feeding record
final updateFeedingRecordProvider = FutureProvider.autoDispose
    .family<FeedingRecord, ({int id, FeedingRecordUpdate update})>((ref, params) async {
  final repository = ref.watch(feedingRecordsRepositoryProvider);
  final record = await repository.updateFeedingRecord(params.id, params.update);

  // Update in feeding records list
  ref.read(feedingRecordsProvider.notifier).updateRecord(record);

  return record;
});

/// Provider for deleting a feeding record
final deleteFeedingRecordProvider =
    FutureProvider.autoDispose.family<void, int>((ref, id) async {
  final repository = ref.watch(feedingRecordsRepositoryProvider);
  await repository.deleteFeedingRecord(id);

  // Remove from feeding records list
  ref.read(feedingRecordsProvider.notifier).removeRecord(id);
});

/// Provider for feeding statistics
final feedingStatisticsProvider = FutureProvider.autoDispose
    .family<FeedingStatistics, ({DateTime? fromDate, DateTime? toDate})>((ref, params) async {
  final repository = ref.watch(feedingRecordsRepositoryProvider);
  return repository.getStatistics(
    fromDate: params.fromDate,
    toDate: params.toDate,
  );
});

/// Provider for recent feeding records
final recentFeedingRecordsProvider =
    FutureProvider.autoDispose.family<List<FeedingRecord>, int?>((ref, limit) async {
  final repository = ref.watch(feedingRecordsRepositoryProvider);
  return repository.getRecentFeedingRecords(limit: limit);
});

/// Provider for filtering feeding records by rabbit ID
final feedingRecordsByRabbitProvider =
    Provider.autoDispose.family<List<FeedingRecord>, int?>((ref, rabbitId) {
  final recordsState = ref.watch(feedingRecordsProvider);

  if (rabbitId == null) {
    return recordsState.records;
  }

  return recordsState.records.where((record) => record.rabbitId == rabbitId).toList();
});

/// Provider for filtering feeding records by feed ID
final feedingRecordsByFeedProvider =
    Provider.autoDispose.family<List<FeedingRecord>, int?>((ref, feedId) {
  final recordsState = ref.watch(feedingRecordsProvider);

  if (feedId == null) {
    return recordsState.records;
  }

  return recordsState.records.where((record) => record.feedId == feedId).toList();
});

/// Provider for filtering feeding records by cage ID
final feedingRecordsByCageProvider =
    Provider.autoDispose.family<List<FeedingRecord>, int?>((ref, cageId) {
  final recordsState = ref.watch(feedingRecordsProvider);

  if (cageId == null) {
    return recordsState.records;
  }

  return recordsState.records.where((record) => record.cageId == cageId).toList();
});

/// Provider for filtering feeding records by date range
final feedingRecordsByDateRangeProvider = Provider.autoDispose
    .family<List<FeedingRecord>, ({DateTime? fromDate, DateTime? toDate})>((ref, params) {
  final recordsState = ref.watch(feedingRecordsProvider);

  if (params.fromDate == null && params.toDate == null) {
    return recordsState.records;
  }

  return recordsState.records.where((record) {
    if (params.fromDate != null && record.fedAt.isBefore(params.fromDate!)) {
      return false;
    }
    if (params.toDate != null && record.fedAt.isAfter(params.toDate!)) {
      return false;
    }
    return true;
  }).toList();
});
