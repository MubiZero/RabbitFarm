import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/vaccination_model.dart';
import '../../data/repositories/vaccinations_repository.dart';

/// Состояние списка вакцинаций
class VaccinationsState {
  final List<Vaccination> vaccinations;
  final bool isLoading;
  final String? error;
  final int? rabbitIdFilter;
  final VaccineType? typeFilter;
  final DateTime? fromDateFilter;
  final DateTime? toDateFilter;

  VaccinationsState({
    this.vaccinations = const [],
    this.isLoading = false,
    this.error,
    this.rabbitIdFilter,
    this.typeFilter,
    this.fromDateFilter,
    this.toDateFilter,
  });

  VaccinationsState copyWith({
    List<Vaccination>? vaccinations,
    bool? isLoading,
    String? error,
    int? rabbitIdFilter,
    VaccineType? typeFilter,
    DateTime? fromDateFilter,
    DateTime? toDateFilter,
    bool clearFilters = false,
  }) {
    return VaccinationsState(
      vaccinations: vaccinations ?? this.vaccinations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      rabbitIdFilter: clearFilters ? null : (rabbitIdFilter ?? this.rabbitIdFilter),
      typeFilter: clearFilters ? null : (typeFilter ?? this.typeFilter),
      fromDateFilter: clearFilters ? null : (fromDateFilter ?? this.fromDateFilter),
      toDateFilter: clearFilters ? null : (toDateFilter ?? this.toDateFilter),
    );
  }
}

/// StateNotifier для управления вакцинациями
class VaccinationsNotifier extends StateNotifier<VaccinationsState> {
  final VaccinationsRepository _repository;

  VaccinationsNotifier(this._repository) : super(VaccinationsState());

  /// Загрузить список вакцинаций
  Future<void> loadVaccinations({
    int page = 1,
    int limit = 50,
    int? rabbitId,
    VaccineType? vaccineType,
    DateTime? fromDate,
    DateTime? toDate,
    bool? upcoming,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final vaccinations = await _repository.getVaccinations(
        page: page,
        limit: limit,
        rabbitId: rabbitId ?? state.rabbitIdFilter,
        vaccineType: vaccineType ?? state.typeFilter,
        fromDate: fromDate ?? state.fromDateFilter,
        toDate: toDate ?? state.toDateFilter,
        upcoming: upcoming,
      );

      state = state.copyWith(
        vaccinations: vaccinations,
        isLoading: false,
        rabbitIdFilter: rabbitId,
        typeFilter: vaccineType,
        fromDateFilter: fromDate,
        toDateFilter: toDate,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Загрузить вакцинации конкретного кролика
  Future<void> loadRabbitVaccinations(int rabbitId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final vaccinations = await _repository.getRabbitVaccinations(rabbitId);

      state = state.copyWith(
        vaccinations: vaccinations,
        isLoading: false,
        rabbitIdFilter: rabbitId,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Создать новую запись о вакцинации
  Future<bool> createVaccination(VaccinationRequest request) async {
    try {
      await _repository.createVaccination(request);
      // Обновляем список
      await loadVaccinations();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Обновить запись о вакцинации
  Future<bool> updateVaccination(int id, VaccinationRequest request) async {
    try {
      await _repository.updateVaccination(id, request);
      // Обновляем список
      await loadVaccinations();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Удалить запись о вакцинации
  Future<bool> deleteVaccination(int id) async {
    try {
      await _repository.deleteVaccination(id);
      // Удаляем из списка
      state = state.copyWith(
        vaccinations: state.vaccinations.where((v) => v.id != id).toList(),
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Установить фильтр по типу вакцины
  void setTypeFilter(VaccineType? type) {
    state = state.copyWith(typeFilter: type);
    loadVaccinations();
  }

  /// Установить фильтр по дате
  void setDateFilter(DateTime? fromDate, DateTime? toDate) {
    state = state.copyWith(
      fromDateFilter: fromDate,
      toDateFilter: toDate,
    );
    loadVaccinations();
  }

  /// Очистить все фильтры
  void clearFilters() {
    state = state.copyWith(clearFilters: true);
    loadVaccinations();
  }

  /// Очистить ошибку
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider для Notifier вакцинаций
final vaccinationsProvider =
    StateNotifierProvider<VaccinationsNotifier, VaccinationsState>((ref) {
  final repository = ref.watch(vaccinationsRepositoryProvider);
  return VaccinationsNotifier(repository);
});

/// Provider для статистики вакцинаций
final vaccinationStatisticsProvider =
    FutureProvider<VaccinationStatistics>((ref) async {
  final repository = ref.watch(vaccinationsRepositoryProvider);
  return await repository.getStatistics();
});

/// Provider для предстоящих вакцинаций
final upcomingVaccinationsProvider =
    FutureProvider.family<List<Vaccination>, int>((ref, days) async {
  final repository = ref.watch(vaccinationsRepositoryProvider);
  return await repository.getUpcomingVaccinations(days: days);
});

/// Provider для просроченных вакцинаций
final overdueVaccinationsProvider =
    FutureProvider<List<Vaccination>>((ref) async {
  final repository = ref.watch(vaccinationsRepositoryProvider);
  return await repository.getOverdueVaccinations();
});

/// Provider для истории вакцинаций конкретного кролика
final rabbitVaccinationsProvider =
    FutureProvider.family<List<Vaccination>, int>((ref, rabbitId) async {
  final repository = ref.watch(vaccinationsRepositoryProvider);
  return await repository.getRabbitVaccinations(rabbitId);
});
