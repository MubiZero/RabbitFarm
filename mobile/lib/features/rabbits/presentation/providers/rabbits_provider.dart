import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/cache/cache_scope.dart';
import '../../../../core/cache/list_cache.dart';
import '../../../../core/providers/session.dart';
import '../../../../core/providers/api_providers.dart';
import '../../../../shared/models/api_response.dart';
import '../../data/models/rabbit_model.dart';
import '../../data/models/rabbit_statistics.dart';
import '../../data/repositories/rabbits_repository.dart';

// Rabbits Repository provider
final rabbitsRepositoryProvider = Provider<RabbitsRepository>((ref) {
  ref.watch(sessionRevisionProvider);
  final apiClient = ref.watch(apiClientProvider);
  return RabbitsRepository(apiClient: apiClient);
});

/// Отбор, которым сейчас смотрят на поголовье.
///
/// Живёт рядом со списком, а не в каждом экране по отдельности. Раньше отбор
/// хранил экран и передавал его в каждый вызов — и любой, кто вызывал список
/// мимо экрана, тихо сбрасывал фильтры: после добавления кролика форма звала
/// `refresh()`, список приезжал целиком, а ярлыки над ним продолжали
/// показывать выбранный отбор.
class RabbitsFilter {
  final String? search;
  final String? sex;
  final String? status;
  final String? purpose;
  final int? breedId;

  const RabbitsFilter({
    this.search,
    this.sex,
    this.status,
    this.purpose,
    this.breedId,
  });

  bool get isEmpty =>
      search == null &&
      sex == null &&
      status == null &&
      purpose == null &&
      breedId == null;

  /// Заменяют по одному полю. Обычный `copyWith` здесь не годится: снять
  /// фильтр — значит передать null, а `??` вернул бы прежнее значение.
  RabbitsFilter withSearch(String? value) => RabbitsFilter(
      search: value, sex: sex, status: status, purpose: purpose, breedId: breedId);

  RabbitsFilter withSex(String? value) => RabbitsFilter(
      search: search, sex: value, status: status, purpose: purpose, breedId: breedId);

  RabbitsFilter withStatus(String? value) => RabbitsFilter(
      search: search, sex: sex, status: value, purpose: purpose, breedId: breedId);

  RabbitsFilter withPurpose(String? value) => RabbitsFilter(
      search: search, sex: sex, status: status, purpose: value, breedId: breedId);
}

// Rabbits List State
class RabbitsListState {
  final List<RabbitModel> rabbits;
  final bool isLoading;
  final Object? error;
  final int currentPage;
  final int totalPages;
  final int total;
  final bool hasMore;
  final RabbitsFilter filter;

  RabbitsListState({
    this.rabbits = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.total = 0,
    this.hasMore = false,
    this.filter = const RabbitsFilter(),
  });

  RabbitsListState copyWith({
    List<RabbitModel>? rabbits,
    bool? isLoading,
    Object? error,
    int? currentPage,
    int? totalPages,
    int? total,
    bool? hasMore,
    RabbitsFilter? filter,
  }) {
    return RabbitsListState(
      rabbits: rabbits ?? this.rabbits,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
      filter: filter ?? this.filter,
    );
  }
}

/// Последнее виденное поголовье на диске.
const rabbitsCache = ListCache<RabbitModel>(
  boxName: ListCacheBoxes.rabbits,
  fromJson: RabbitModel.fromJson,
  toJson: _rabbitToJson,
);

Map<String, dynamic> _rabbitToJson(RabbitModel rabbit) => rabbit.toJson();

// Rabbits List Notifier
class RabbitsListNotifier extends StateNotifier<RabbitsListState> {
  final RabbitsRepository _repository;
  final String? _cacheScope;

  /// Свежий ответ уже приходил — прошлому списку с диска здесь больше не место.
  bool _hasFreshData = false;

  RabbitsListNotifier(this._repository, this._cacheScope)
      : super(RabbitsListState()) {
    _restoreFromCache();
    loadRabbits();
  }

  static const _pageSize = 10;

  /// Показать то, что человек видел в прошлый раз, не дожидаясь сервера.
  ///
  /// В сарае без связи это разница между списком месячной фермы и пустым
  /// экраном с кнопкой «Повторить». Как только запрос провалится, над списком
  /// появится полоса «данные устарели» — за это отвечает `PagedListView`, ему
  /// достаточно непустого списка и ошибки.
  Future<void> _restoreFromCache() async {
    final cached = await rabbitsCache.read(_cacheScope);
    if (!mounted || cached.isEmpty) return;

    // Пока читали диск, могло приехать что угодно: свежая страница, отбор,
    // добавленный кролик. Подставлять прошлый список поверх нельзя.
    if (_hasFreshData || state.rabbits.isNotEmpty || !state.filter.isEmpty) {
      return;
    }

    // Ошибку переносим руками: `copyWith` без неё сбрасывает ошибку в null, а
    // именно она вместе с непустым списком включает полосу «данные устарели».
    state = state.copyWith(rabbits: cached, error: state.error);
  }

  /// Сменить отбор и перечитать список с первой страницы.
  Future<void> applyFilter(RabbitsFilter filter) {
    state = state.copyWith(filter: filter);
    return loadRabbits();
  }

  // Load rabbits (first page or refresh)
  Future<void> loadRabbits() async {
    final filter = state.filter;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _load(page: 1);

      _hasFreshData = true;
      state = state.copyWith(
        rabbits: result.items,
        isLoading: false,
        currentPage: result.page,
        totalPages: result.totalPages,
        total: result.total,
        hasMore: result.page < result.totalPages,
      );

      // На диск кладётся только список без отбора: иначе после «самцы,
      // на племя» человек при следующем запуске увидел бы эту выборку как
      // всё поголовье.
      if (filter.isEmpty) {
        unawaited(rabbitsCache.write(_cacheScope, result.items));
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e,
      );
    }
  }

  // Load more rabbits (pagination)
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final result = await _load(page: state.currentPage + 1);

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
        error: e,
      );
    }
  }

  /// Отбор уходит на сервер целиком — и в первую страницу, и в подгрузку.
  /// Отбирать назначение среди приехавшей страницы значило бы показать
  /// «племя» ровно в том количестве, в каком оно попало в первые десять
  /// записей.
  Future<PaginatedResponse<RabbitModel>> _load({required int page}) {
    final filter = state.filter;
    return _repository.getRabbits(
      page: page,
      limit: _pageSize,
      search: filter.search,
      sex: filter.sex,
      status: filter.status,
      purpose: filter.purpose,
      breedId: filter.breedId,
    );
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
        error: e,
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
  // Владелец кэша читается один раз при создании списка: следить за ним
  // незачем — сменился пользователь, значит поднялся номер сессии, и список
  // пересоздался целиком.
  return RabbitsListNotifier(repository, ref.read(cacheScopeProvider));
});

// Statistics State
class StatisticsState {
  final RabbitStatistics? statistics;
  final bool isLoading;
  final Object? error;

  StatisticsState({
    this.statistics,
    this.isLoading = false,
    this.error,
  });

  StatisticsState copyWith({
    RabbitStatistics? statistics,
    bool? isLoading,
    Object? error,
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
        error: e,
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
