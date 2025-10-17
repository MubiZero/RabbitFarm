import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/cage_model.dart';
import '../../data/repositories/cages_repository.dart';

/// Состояние списка клеток
class CagesState {
  final List<CageModel> cages;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String? typeFilter;
  final String? conditionFilter;
  final String? locationFilter;
  final bool onlyAvailable;

  CagesState({
    this.cages = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.typeFilter,
    this.conditionFilter,
    this.locationFilter,
    this.onlyAvailable = false,
  });

  CagesState copyWith({
    List<CageModel>? cages,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? typeFilter,
    String? conditionFilter,
    String? locationFilter,
    bool? onlyAvailable,
  }) {
    return CagesState(
      cages: cages ?? this.cages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      typeFilter: typeFilter ?? this.typeFilter,
      conditionFilter: conditionFilter ?? this.conditionFilter,
      locationFilter: locationFilter ?? this.locationFilter,
      onlyAvailable: onlyAvailable ?? this.onlyAvailable,
    );
  }

  /// Получить отфильтрованный список клеток
  List<CageModel> get filteredCages {
    var result = cages;

    // Поиск
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result.where((cage) {
        return cage.number.toLowerCase().contains(query) ||
            (cage.location?.toLowerCase().contains(query) ?? false) ||
            (cage.notes?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Фильтр по типу
    if (typeFilter != null && typeFilter!.isNotEmpty) {
      result = result.where((cage) => cage.type == typeFilter).toList();
    }

    // Фильтр по состоянию
    if (conditionFilter != null && conditionFilter!.isNotEmpty) {
      result = result.where((cage) => cage.condition == conditionFilter).toList();
    }

    // Фильтр по локации
    if (locationFilter != null && locationFilter!.isNotEmpty) {
      result = result.where((cage) => cage.location == locationFilter).toList();
    }

    // Только доступные
    if (onlyAvailable) {
      result = result.where((cage) => cage.isAvailable ?? false).toList();
    }

    return result;
  }

  /// Получить уникальные локации
  List<String> get uniqueLocations {
    return cages
        .map((cage) => cage.location)
        .where((location) => location != null && location.isNotEmpty)
        .toSet()
        .cast<String>()
        .toList()
      ..sort();
  }
}

/// StateNotifier для управления клетками
class CagesNotifier extends StateNotifier<CagesState> {
  final CagesRepository _repository;

  CagesNotifier(this._repository) : super(CagesState()) {
    loadCages();
  }

  /// Загрузить список клеток
  Future<void> loadCages() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final cages = await _repository.getCages(
        type: state.typeFilter,
        condition: state.conditionFilter,
        location: state.locationFilter,
        search: state.searchQuery.isNotEmpty ? state.searchQuery : null,
        onlyAvailable: state.onlyAvailable ? true : null,
      );
      state = state.copyWith(
        cages: cages,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Обновить поисковый запрос
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Установить фильтр по типу
  void setTypeFilter(String? type) {
    state = state.copyWith(typeFilter: type);
    loadCages();
  }

  /// Установить фильтр по состоянию
  void setConditionFilter(String? condition) {
    state = state.copyWith(conditionFilter: condition);
    loadCages();
  }

  /// Установить фильтр по локации
  void setLocationFilter(String? location) {
    state = state.copyWith(locationFilter: location);
    loadCages();
  }

  /// Переключить фильтр "только доступные"
  void toggleOnlyAvailable() {
    state = state.copyWith(onlyAvailable: !state.onlyAvailable);
    loadCages();
  }

  /// Сбросить все фильтры
  void resetFilters() {
    state = CagesState(cages: state.cages);
    loadCages();
  }

  /// Создать новую клетку
  Future<bool> createCage(Map<String, dynamic> cageData) async {
    try {
      final newCage = await _repository.createCage(cageData);
      state = state.copyWith(
        cages: [...state.cages, newCage],
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Обновить клетку
  Future<bool> updateCage(int id, Map<String, dynamic> cageData) async {
    try {
      final updatedCage = await _repository.updateCage(id, cageData);
      final updatedCages = state.cages.map((cage) {
        return cage.id == id ? updatedCage : cage;
      }).toList();

      state = state.copyWith(cages: updatedCages);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Удалить клетку
  Future<bool> deleteCage(int id) async {
    try {
      await _repository.deleteCage(id);
      final updatedCages = state.cages.where((cage) => cage.id != id).toList();

      state = state.copyWith(cages: updatedCages);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Отметить клетку как убранную
  Future<bool> markCleaned(int id) async {
    try {
      final updatedCage = await _repository.markCleaned(id);
      final updatedCages = state.cages.map((cage) {
        return cage.id == id ? updatedCage : cage;
      }).toList();

      state = state.copyWith(cages: updatedCages);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Очистить ошибку
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider для StateNotifier клеток
final cagesProvider = StateNotifierProvider<CagesNotifier, CagesState>((ref) {
  final repository = ref.watch(cagesRepositoryProvider);
  return CagesNotifier(repository);
});

/// Provider для статистики клеток
final cageStatisticsProvider = FutureProvider<CageStatistics>((ref) async {
  final repository = ref.watch(cagesRepositoryProvider);
  return repository.getStatistics();
});

/// Provider для схемы размещения клеток
final cageLayoutProvider = FutureProvider<Map<String, List<CageModel>>>((ref) async {
  final repository = ref.watch(cagesRepositoryProvider);
  return repository.getLayout();
});
