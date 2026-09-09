import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/api/load_all_pages.dart';
import '../../../../core/cache/cache_scope.dart';
import '../../../../core/cache/list_cache.dart';
import '../../data/models/cage_model.dart';
import '../../data/repositories/cages_repository.dart';

/// Состояние списка клеток
class CagesState {
  final List<CageModel> cages;
  final bool isLoading;
  final Object? error;
  final String searchQuery;
  final String? typeFilter;
  final String? conditionFilter;
  final String? locationFilter;
  final bool onlyAvailable;

  /// Постраничная выдача. Раньше загружалась ровно одна страница на пятьдесят
  /// клеток, и на этом список заканчивался: клетки с шестидесятой в приложении
  /// не существовали.
  final int currentPage;
  final bool hasMore;

  CagesState({
    this.cages = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.typeFilter,
    this.conditionFilter,
    this.locationFilter,
    this.onlyAvailable = false,
    this.currentPage = 1,
    this.hasMore = false,
  });

  bool get hasFilters =>
      typeFilter != null ||
      conditionFilter != null ||
      locationFilter != null ||
      onlyAvailable ||
      searchQuery.isNotEmpty;

  /// Флаги `clear*` нужны, чтобы отличить «параметр не передали» от «передали
  /// null»: без них снять фильтр было невозможно — крестик на ярлыке возвращал
  /// прежнее значение.
  CagesState copyWith({
    List<CageModel>? cages,
    bool? isLoading,
    Object? error,
    String? searchQuery,
    String? typeFilter,
    bool clearType = false,
    String? conditionFilter,
    bool clearCondition = false,
    String? locationFilter,
    bool clearLocation = false,
    bool? onlyAvailable,
    int? currentPage,
    bool? hasMore,
  }) {
    return CagesState(
      cages: cages ?? this.cages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      typeFilter: clearType ? null : (typeFilter ?? this.typeFilter),
      conditionFilter:
          clearCondition ? null : (conditionFilter ?? this.conditionFilter),
      locationFilter:
          clearLocation ? null : (locationFilter ?? this.locationFilter),
      onlyAvailable: onlyAvailable ?? this.onlyAvailable,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
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

/// Последние виденные клетки на диске.
const cagesCache = ListCache<CageModel>(
  boxName: ListCacheBoxes.cages,
  fromJson: CageModel.fromJson,
  toJson: _cageToJson,
);

Map<String, dynamic> _cageToJson(CageModel cage) => cage.toJson();

/// StateNotifier для управления клетками
class CagesNotifier extends StateNotifier<CagesState> {
  final CagesRepository _repository;
  final String? _cacheScope;

  /// Свежий ответ уже приходил — прошлому списку с диска здесь больше не место.
  bool _hasFreshData = false;

  CagesNotifier(this._repository, this._cacheScope) : super(CagesState()) {
    _restoreFromCache();
    loadCages();
  }

  static const _pageSize = 30;

  /// Показать клетки, виденные в прошлый раз, не дожидаясь сервера. Полосу
  /// «данные устарели» над ними поставит `PagedListView`, как только запрос
  /// не удастся.
  Future<void> _restoreFromCache() async {
    final cached = await cagesCache.read(_cacheScope);
    if (!mounted || cached.isEmpty) return;

    // Пока читали диск, могли приехать свежие клетки или включиться фильтр.
    if (_hasFreshData || state.cages.isNotEmpty || state.hasFilters) return;

    // Ошибку переносим руками: `copyWith` без неё сбрасывает ошибку в null, а
    // именно она вместе с непустым списком включает полосу «данные устарели».
    state = state.copyWith(cages: cached, error: state.error);
  }

  /// Загрузить первую страницу списка по текущим фильтрам.
  Future<void> loadCages() async {
    final hadFilters = state.hasFilters;
    state = state.copyWith(isLoading: true, error: null, currentPage: 1);

    try {
      final cages = await _repository.getCages(
        page: 1,
        limit: _pageSize,
        type: state.typeFilter,
        condition: state.conditionFilter,
        location: state.locationFilter,
        search: state.searchQuery.isNotEmpty ? state.searchQuery : null,
        onlyAvailable: state.onlyAvailable ? true : null,
      );
      _hasFreshData = true;
      state = state.copyWith(
        cages: cages,
        isLoading: false,
        currentPage: 1,
        hasMore: cages.length >= _pageSize,
      );

      // На диск кладётся только список без фильтров: иначе «только свободные»
      // при следующем запуске выглядели бы как все клетки фермы.
      if (!hadFilters) {
        unawaited(cagesCache.write(_cacheScope, cages));
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Догрузить следующую страницу.
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    final nextPage = state.currentPage + 1;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final cages = await _repository.getCages(
        page: nextPage,
        limit: _pageSize,
        type: state.typeFilter,
        condition: state.conditionFilter,
        location: state.locationFilter,
        search: state.searchQuery.isNotEmpty ? state.searchQuery : null,
        onlyAvailable: state.onlyAvailable ? true : null,
      );
      state = state.copyWith(
        cages: [...state.cages, ...cages],
        isLoading: false,
        currentPage: nextPage,
        hasMore: cages.length >= _pageSize,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Поиск идёт на сервере: искать среди подгруженной страницы значило бы
  /// «не находить» клетки, которые ещё не приехали.
  Future<void> setSearchQuery(String query) async {
    state = state.copyWith(searchQuery: query);
    await loadCages();
  }

  Future<void> setTypeFilter(String? type) async {
    state = state.copyWith(typeFilter: type, clearType: type == null);
    await loadCages();
  }

  Future<void> setConditionFilter(String? condition) async {
    state = state.copyWith(
      conditionFilter: condition,
      clearCondition: condition == null,
    );
    await loadCages();
  }

  Future<void> setLocationFilter(String? location) async {
    state = state.copyWith(
      locationFilter: location,
      clearLocation: location == null,
    );
    await loadCages();
  }

  Future<void> toggleOnlyAvailable() async {
    state = state.copyWith(onlyAvailable: !state.onlyAvailable);
    await loadCages();
  }

  /// Сбросить все фильтры
  Future<void> resetFilters() async {
    state = state.copyWith(
      searchQuery: '',
      clearType: true,
      clearCondition: true,
      clearLocation: true,
      onlyAvailable: false,
    );
    await loadCages();
  }

  /// Создать новую клетку
  Future<bool> createCage(Map<String, dynamic> cageData) async {
    try {
      await _repository.createCage(cageData);
      // Перечитываем список, а не дописываем клетку в конец: список идёт с
      // фильтрами сервера, и при включённой галочке «только свободные»
      // занятая клетка появлялась в списке, который обещает обратное — до
      // первого обновления, после которого она молча исчезала.
      await loadCages();
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
  // Владелец кэша читается один раз при создании списка: сменился
  // пользователь — поднялся номер сессии, и список пересоздался целиком.
  return CagesNotifier(repository, ref.read(cacheScopeProvider));
});

/// Одна клетка со списком жителей.
///
/// Экран клетки раньше искал её в уже загруженной странице списка, а если не
/// находил — рисовал выдуманную клетку с номером «...» и вместимостью ноль.
/// Так выглядел переход по ссылке и открытие клетки со второй страницы:
/// пользователь видел правдоподобный, но полностью ложный экран.
final cageDetailProvider =
    FutureProvider.autoDispose.family<CageModel, int>((ref, id) async {
  final repository = ref.watch(cagesRepositoryProvider);
  return repository.getCageById(id);
});

/// Provider для статистики клеток
final cageStatisticsProvider = FutureProvider<CageStatistics>((ref) async {
  final repository = ref.watch(cagesRepositoryProvider);
  return repository.getStatistics();
});

/// Полный список клеток для выпадающих полей в формах.
final cageOptionsProvider = FutureProvider<List<CageModel>>((ref) async {
  final repository = ref.watch(cagesRepositoryProvider);
  return loadAllPages<CageModel>(
    ({required page, required limit}) =>
        repository.getCages(page: page, limit: limit),
  );
});
