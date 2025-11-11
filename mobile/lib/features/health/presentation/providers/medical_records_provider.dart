import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../data/models/medical_record_model.dart';
import '../../data/repositories/medical_records_repository.dart';

/// Provider for medical records repository
final medicalRecordsRepositoryProvider = Provider<MedicalRecordsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MedicalRecordsRepository(apiClient);
});

/// State notifier for managing medical records list
class MedicalRecordsNotifier extends StateNotifier<AsyncValue<List<MedicalRecord>>> {
  final MedicalRecordsRepository _repository;

  MedicalRecordsNotifier(this._repository) : super(const AsyncValue.loading());

  /// Load medical records with optional filters
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
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getMedicalRecords(
          page: page,
          limit: limit,
          sortBy: sortBy,
          sortOrder: sortOrder,
          rabbitId: rabbitId,
          outcome: outcome,
          fromDate: fromDate,
          toDate: toDate,
          ongoing: ongoing,
        ));
  }

  /// Add new medical record
  Future<void> addMedicalRecord(MedicalRecordCreate medicalRecord) async {
    final result = await _repository.createMedicalRecord(medicalRecord);
    state.whenData((records) {
      state = AsyncValue.data([result, ...records]);
    });
  }

  /// Update existing medical record
  Future<void> updateMedicalRecord(int id, MedicalRecordUpdate medicalRecord) async {
    final result = await _repository.updateMedicalRecord(id, medicalRecord);
    state.whenData((records) {
      final index = records.indexWhere((r) => r.id == id);
      if (index != -1) {
        final updated = List<MedicalRecord>.from(records);
        updated[index] = result;
        state = AsyncValue.data(updated);
      }
    });
  }

  /// Delete medical record
  Future<void> deleteMedicalRecord(int id) async {
    await _repository.deleteMedicalRecord(id);
    state.whenData((records) {
      state = AsyncValue.data(records.where((r) => r.id != id).toList());
    });
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
    StateNotifierProvider<MedicalRecordsNotifier, AsyncValue<List<MedicalRecord>>>(
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
final medicalStatisticsProvider = FutureProvider<MedicalStatistics>((ref) async {
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
  return repository.getMedicalRecords(outcome: outcome);
});

/// Provider for ongoing medical records only
final ongoingMedicalRecordsProvider =
    FutureProvider<List<MedicalRecord>>((ref) async {
  final repository = ref.watch(medicalRecordsRepositoryProvider);
  return repository.getMedicalRecords(ongoing: true);
});

/// Provider for recent medical records (last 30 days)
final recentMedicalRecordsProvider =
    FutureProvider<List<MedicalRecord>>((ref) async {
  final repository = ref.watch(medicalRecordsRepositoryProvider);
  final now = DateTime.now();
  final thirtyDaysAgo = now.subtract(const Duration(days: 30));
  return repository.getMedicalRecords(
    fromDate: thirtyDaysAgo,
    toDate: now,
    sortBy: 'started_at',
    sortOrder: 'DESC',
  );
});
