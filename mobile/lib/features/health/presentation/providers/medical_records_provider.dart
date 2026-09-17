import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/providers/session.dart';
import '../../../../core/providers/api_providers.dart';
import '../../data/models/medical_record_model.dart';
import '../../data/repositories/medical_records_repository.dart';
import '../../../../shared/models/api_response.dart';

/// Provider for medical records repository
final medicalRecordsRepositoryProvider =
    Provider<MedicalRecordsRepository>((ref) {
  ref.watch(sessionRevisionProvider);
  final apiClient = ref.watch(apiClientProvider);
  return MedicalRecordsRepository(apiClient);
});

/// Список лечений вместе с тем, есть ли ещё страницы.
///
/// Раньше состояние было просто списком: экран показывал первую сотню и
/// выглядел полным — на ферме, где лечение идёт третий год, остальное
/// увидеть было нельзя.
class MedicalRecordsState {
  final List<MedicalRecord> records;
  final bool isLoading;
  final Object? error;
  final int currentPage;
  final bool hasMore;

  const MedicalRecordsState({
    this.records = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = false,
  });

  MedicalRecordsState copyWith({
    List<MedicalRecord>? records,
    bool? isLoading,
    Object? error,
    int? currentPage,
    bool? hasMore,
  }) =>
      MedicalRecordsState(
        records: records ?? this.records,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        currentPage: currentPage ?? this.currentPage,
        hasMore: hasMore ?? this.hasMore,
      );
}

/// State notifier for managing medical records list
class MedicalRecordsNotifier extends StateNotifier<MedicalRecordsState> {
  final MedicalRecordsRepository _repository;

  MedicalRecordsNotifier(this._repository)
      : super(const MedicalRecordsState());

  /// Размер страницы — тот же, что у прививок: списки здоровья читают
  /// прокруткой.
  static const _pageSize = 30;

  /// Отбор, которым загружен текущий список. Нужен догрузке: следующая
  /// страница должна прийти по тем же условиям, что и первая.
  Map<String, dynamic> _filters = const {};

  /// Load medical records with optional filters — первая страница.
  Future<void> loadMedicalRecords({
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
    int? rabbitId,
    String? outcome,
    DateTime? fromDate,
    DateTime? toDate,
    bool? ongoing,
  }) async {
    _filters = {
      'sortBy': sortBy,
      'sortOrder': sortOrder,
      'rabbitId': rabbitId,
      'outcome': outcome,
      'fromDate': fromDate,
      'toDate': toDate,
      'ongoing': ongoing,
      'limit': limit ?? _pageSize,
    };

    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _fetch(page ?? 1);
      state = MedicalRecordsState(
        records: result.items,
        currentPage: result.page,
        hasMore: result.page < result.totalPages,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Догрузить следующую страницу.
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _fetch(state.currentPage + 1);
      state = state.copyWith(
        records: [...state.records, ...result.items],
        isLoading: false,
        currentPage: result.page,
        hasMore: result.page < result.totalPages,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<PaginatedResponse<MedicalRecord>> _fetch(int page) =>
      _repository.getMedicalRecords(
        page: page,
        limit: _filters['limit'] as int?,
        sortBy: _filters['sortBy'] as String?,
        sortOrder: _filters['sortOrder'] as String?,
        rabbitId: _filters['rabbitId'] as int?,
        outcome: _filters['outcome'] as String?,
        fromDate: _filters['fromDate'] as DateTime?,
        toDate: _filters['toDate'] as DateTime?,
        ongoing: _filters['ongoing'] as bool?,
      );

  /// Add new medical record
  Future<void> addMedicalRecord(MedicalRecordCreate medicalRecord) async {
    final result = await _repository.createMedicalRecord(medicalRecord);
    state = state.copyWith(records: [result, ...state.records]);
  }

  /// Update existing medical record
  Future<void> updateMedicalRecord(
      int id, MedicalRecordUpdate medicalRecord) async {
    final result = await _repository.updateMedicalRecord(id, medicalRecord);
    final index = state.records.indexWhere((r) => r.id == id);
    if (index != -1) {
      final updated = List<MedicalRecord>.from(state.records);
      updated[index] = result;
      state = state.copyWith(records: updated);
    }
  }

  /// Убрать запись из списка, не трогая сервер.
  ///
  /// Удаление идёт с окном на отмену: строка должна исчезнуть сразу, а запрос
  /// уходит только когда окно закрылось. Вернуть строку на место —
  /// `refresh()`.
  void removeMedicalRecord(int id) {
    state = state.copyWith(
      records: state.records.where((r) => r.id != id).toList(),
    );
  }

  /// Delete medical record
  Future<void> deleteMedicalRecord(int id) async {
    await _repository.deleteMedicalRecord(id);
    state = state.copyWith(
      records: state.records.where((r) => r.id != id).toList(),
    );
  }

  /// Refresh the list
  Future<void> refresh({
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
    int? rabbitId,
    String? outcome,
    DateTime? fromDate,
    DateTime? toDate,
    bool? ongoing,
  }) async {
    await loadMedicalRecords(
      page: page,
      limit: limit,
      sortBy: sortBy,
      sortOrder: sortOrder,
      rabbitId: rabbitId,
      outcome: outcome,
      fromDate: fromDate,
      toDate: toDate,
      ongoing: ongoing,
    );
  }
}

/// Provider for medical records state
final medicalRecordsProvider =
    StateNotifierProvider<MedicalRecordsNotifier, MedicalRecordsState>(
  (ref) {
    final repository = ref.watch(medicalRecordsRepositoryProvider);
    return MedicalRecordsNotifier(repository);
  },
);

/// Provider for single medical record by ID
final medicalRecordByIdProvider =
    FutureProvider.family<MedicalRecord, int>((ref, id) async {
  final repository = ref.watch(medicalRecordsRepositoryProvider);
  return repository.getMedicalRecordById(id);
});

/// Provider for rabbit medical records
final rabbitMedicalRecordsProvider =
    FutureProvider.family<List<MedicalRecord>, int>((ref, rabbitId) async {
  final repository = ref.watch(medicalRecordsRepositoryProvider);
  return repository.getRabbitMedicalRecords(rabbitId);
});

/// Provider for medical records statistics
final medicalStatisticsProvider =
    FutureProvider<MedicalStatistics>((ref) async {
  final repository = ref.watch(medicalRecordsRepositoryProvider);
  return repository.getStatistics();
});

/// Provider for ongoing treatments
final ongoingTreatmentsProvider =
    FutureProvider<List<MedicalRecordWithDays>>((ref) async {
  final repository = ref.watch(medicalRecordsRepositoryProvider);
  return repository.getOngoingTreatments();
});

/// Provider for cost report with date filters
final costReportProvider = FutureProvider.family<CostReport, CostReportParams>(
  (ref, params) async {
    final repository = ref.watch(medicalRecordsRepositoryProvider);
    return repository.getCostReport(
      fromDate: params.fromDate,
      toDate: params.toDate,
    );
  },
);

/// Parameters for cost report provider
class CostReportParams {
  final DateTime? fromDate;
  final DateTime? toDate;

  CostReportParams({this.fromDate, this.toDate});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CostReportParams &&
          runtimeType == other.runtimeType &&
          fromDate == other.fromDate &&
          toDate == other.toDate;

  @override
  int get hashCode => fromDate.hashCode ^ toDate.hashCode;
}

/// Provider for filtered medical records by outcome
final medicalRecordsByOutcomeProvider =
    FutureProvider.family<List<MedicalRecord>, String>((ref, outcome) async {
  final repository = ref.watch(medicalRecordsRepositoryProvider);
  final page = await repository.getMedicalRecords(outcome: outcome);
  return page.items;
});

/// Provider for ongoing medical records only
final ongoingMedicalRecordsProvider =
    FutureProvider<List<MedicalRecord>>((ref) async {
  final repository = ref.watch(medicalRecordsRepositoryProvider);
  final page = await repository.getMedicalRecords(ongoing: true);
  return page.items;
});

/// Provider for recent medical records (last 30 days)
final recentMedicalRecordsProvider =
    FutureProvider<List<MedicalRecord>>((ref) async {
  final repository = ref.watch(medicalRecordsRepositoryProvider);
  final now = DateTime.now();
  final thirtyDaysAgo = now.subtract(const Duration(days: 30));
  final page = await repository.getMedicalRecords(
    fromDate: thirtyDaysAgo,
    toDate: now,
    sortBy: 'started_at',
    sortOrder: 'DESC',
  );
  return page.items;
});
