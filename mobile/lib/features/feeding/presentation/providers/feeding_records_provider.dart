import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/providers/session.dart';
import '../../../../core/providers/api_providers.dart';
import '../../data/models/feeding_record_model.dart';
import '../../data/repositories/feeding_records_repository.dart';

/// Provider for FeedingRecordsRepository
final feedingRecordsRepositoryProvider = Provider<FeedingRecordsRepository>((ref) {
  ref.watch(sessionRevisionProvider);
  final apiClient = ref.watch(apiClientProvider);
  return FeedingRecordsRepository(apiClient);
});

/// State class for feeding records list
class FeedingRecordsState {
  final List<FeedingRecord> records;
  final bool isLoading;
  final Object? error;
  final bool hasMore;
  final int currentPage;

  /// Выбранный период. Фильтр живёт в состоянии, а не в экране: обновление
  /// жестом и подгрузка следующей страницы вызывали загрузку без него, и
  /// список незаметно показывал записи за всё время.
  final DateTime? fromDate;
  final DateTime? toDate;

  const FeedingRecordsState({
    this.records = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
    this.fromDate,
    this.toDate,
  });

  bool get hasFilters => fromDate != null || toDate != null;

  FeedingRecordsState copyWith({
    List<FeedingRecord>? records,
    bool? isLoading,
    Object? error,
    bool? hasMore,
    int? currentPage,
    DateTime? fromDate,
    bool clearFromDate = false,
    DateTime? toDate,
    bool clearToDate = false,
  }) {
    // clearError передаёт сюда null, а «?? this.error» его игнорировал —
    // сообщение об ошибке залипало в состоянии до перезапуска приложения,
    // переживая любые успешные загрузки. В остальных фичах принято
    // присваивать error напрямую; приводим к тому же виду.
    return FeedingRecordsState(
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      fromDate: clearFromDate ? null : (fromDate ?? this.fromDate),
      toDate: clearToDate ? null : (toDate ?? this.toDate),
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
    bool refresh = false,
  }) async {
    if (state.isLoading) return;

    if (refresh) {
      state = FeedingRecordsState(
        isLoading: true,
        fromDate: state.fromDate,
        toDate: state.toDate,
      );
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
        fromDate: state.fromDate,
        toDate: state.toDate,
      );

      if (refresh) {
        state = FeedingRecordsState(
          records: records,
          isLoading: false,
          hasMore: records.length >= (limit ?? 10),
          currentPage: page ?? 1,
          fromDate: state.fromDate,
          toDate: state.toDate,
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

  /// Задать период и перезагрузить список.
  Future<void> setPeriod(DateTime? from, DateTime? to) async {
    state = state.copyWith(
      fromDate: from,
      clearFromDate: from == null,
      toDate: to,
      clearToDate: to == null,
    );
    await loadFeedingRecords(refresh: true);
  }

  /// Удалить запись о кормлении. Возвращает текст ошибки или `null`.
  Future<Object?> deleteRecord(int id) async {
    try {
      await _repository.deleteFeedingRecord(id);
      state = state.copyWith(
        records: state.records.where((r) => r.id != id).toList(),
      );
      return null;
    } catch (e) {
      return e;
    }
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

  return record;
});

/// Provider for updating a feeding record
final updateFeedingRecordProvider = FutureProvider.autoDispose
    .family<FeedingRecord, ({int id, FeedingRecordUpdate update})>((ref, params) async {
  final repository = ref.watch(feedingRecordsRepositoryProvider);
  final record = await repository.updateFeedingRecord(params.id, params.update);

  return record;
});

/// Provider for deleting a feeding record
final deleteFeedingRecordProvider =
    FutureProvider.autoDispose.family<void, int>((ref, id) async {
  final repository = ref.watch(feedingRecordsRepositoryProvider);
  await repository.deleteFeedingRecord(id);
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
