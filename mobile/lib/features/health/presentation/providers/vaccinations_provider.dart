import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/vaccination_model.dart';
import '../../data/repositories/vaccinations_repository.dart';

/// Что показывает список: всё подряд или выборку.
///
/// Раньше «Просроченные» на экране были кнопкой, которая обновляла совсем
/// другой источник данных: список её не читал, и нажатие ничего не меняло.
/// Теперь выборка — часть состояния списка, и её видно по подсвеченной кнопке.
enum VaccinationView { all, upcoming, overdue, last30Days }

/// Состояние списка вакцинаций
class VaccinationsState {
  final List<Vaccination> vaccinations;
  final bool isLoading;
  final Object? error;
  final int? rabbitIdFilter;
  final VaccineType? typeFilter;
  final DateTime? fromDateFilter;
  final DateTime? toDateFilter;
  final VaccinationView view;

  const VaccinationsState({
    this.vaccinations = const [],
    this.isLoading = false,
    this.error,
    this.rabbitIdFilter,
    this.typeFilter,
    this.fromDateFilter,
    this.toDateFilter,
    this.view = VaccinationView.all,
  });

  bool get hasFilters =>
      typeFilter != null ||
      fromDateFilter != null ||
      toDateFilter != null ||
      view != VaccinationView.all;

  /// Флаги `clear*` нужны, чтобы отличить «параметр не передали» от «передали
  /// null». Без них снять фильтр было невозможно: `setTypeFilter(null)`
  /// возвращал прежнее значение, и крестик на ярлыке фильтра не работал.
  VaccinationsState copyWith({
    List<Vaccination>? vaccinations,
    bool? isLoading,
    Object? error,
    int? rabbitIdFilter,
    bool clearRabbitId = false,
    VaccineType? typeFilter,
    bool clearType = false,
    DateTime? fromDateFilter,
    bool clearFromDate = false,
    DateTime? toDateFilter,
    bool clearToDate = false,
    VaccinationView? view,
  }) {
    return VaccinationsState(
      vaccinations: vaccinations ?? this.vaccinations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      rabbitIdFilter: clearRabbitId ? null : (rabbitIdFilter ?? this.rabbitIdFilter),
      typeFilter: clearType ? null : (typeFilter ?? this.typeFilter),
      fromDateFilter:
          clearFromDate ? null : (fromDateFilter ?? this.fromDateFilter),
      toDateFilter: clearToDate ? null : (toDateFilter ?? this.toDateFilter),
      view: view ?? this.view,
    );
  }
}

/// StateNotifier для управления вакцинациями
class VaccinationsNotifier extends StateNotifier<VaccinationsState> {
  final VaccinationsRepository _repository;

  VaccinationsNotifier(this._repository) : super(const VaccinationsState()) {
    load();
  }

  /// Загрузить список по текущей выборке и фильтрам.
  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final vaccinations = switch (state.view) {
        VaccinationView.overdue => await _repository.getOverdueVaccinations(),
        VaccinationView.upcoming => await _repository.getVaccinations(
            limit: 50,
            rabbitId: state.rabbitIdFilter,
            vaccineType: state.typeFilter,
            upcoming: true,
          ),
        VaccinationView.all || VaccinationView.last30Days =>
          await _repository.getVaccinations(
            limit: 50,
            rabbitId: state.rabbitIdFilter,
            vaccineType: state.typeFilter,
            fromDate: state.fromDateFilter,
            toDate: state.toDateFilter,
          ),
      };

      state = state.copyWith(vaccinations: vaccinations, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Загрузить вакцинации конкретного кролика
  Future<void> loadRabbitVaccinations(int rabbitId) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      rabbitIdFilter: rabbitId,
      view: VaccinationView.all,
    );

    try {
      final vaccinations = await _repository.getRabbitVaccinations(rabbitId);
      state = state.copyWith(vaccinations: vaccinations, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Переключить выборку списка.
  Future<void> setView(VaccinationView view) async {
    final now = DateTime.now();
    state = state.copyWith(
      view: view,
      fromDateFilter: view == VaccinationView.last30Days
          ? now.subtract(const Duration(days: 30))
          : null,
      clearFromDate: view != VaccinationView.last30Days,
      toDateFilter: view == VaccinationView.last30Days ? now : null,
      clearToDate: view != VaccinationView.last30Days,
    );
    await load();
  }

  Future<bool> createVaccination(VaccinationRequest request) async {
    try {
      await _repository.createVaccination(request);
      await load();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> updateVaccination(int id, VaccinationRequest request) async {
    try {
      await _repository.updateVaccination(id, request);
      await load();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteVaccination(int id) async {
    try {
      await _repository.deleteVaccination(id);
      state = state.copyWith(
        vaccinations: state.vaccinations.where((v) => v.id != id).toList(),
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<void> setTypeFilter(VaccineType? type) async {
    state = state.copyWith(typeFilter: type, clearType: type == null);
    await load();
  }

  Future<void> setDateFilter(DateTime? fromDate, DateTime? toDate) async {
    state = state.copyWith(
      fromDateFilter: fromDate,
      clearFromDate: fromDate == null,
      toDateFilter: toDate,
      clearToDate: toDate == null,
      view: VaccinationView.all,
    );
    await load();
  }

  Future<void> clearFilters() async {
    state = state.copyWith(
      clearType: true,
      clearFromDate: true,
      clearToDate: true,
      view: VaccinationView.all,
    );
    await load();
  }

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

/// Provider для истории вакцинаций конкретного кролика
final rabbitVaccinationsProvider =
    FutureProvider.family<List<Vaccination>, int>((ref, rabbitId) async {
  final repository = ref.watch(vaccinationsRepositoryProvider);
  return await repository.getRabbitVaccinations(rabbitId);
});

/// Provider для одной вакцинации по id — переход по тапу из push-уведомления
final vaccinationByIdProvider =
    FutureProvider.autoDispose.family<Vaccination, int>((ref, id) async {
  final repository = ref.watch(vaccinationsRepositoryProvider);
  return await repository.getVaccinationById(id);
});
