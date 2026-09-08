import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/api_providers.dart';
import '../../../../core/providers/session.dart';
import '../../data/models/platform_admin_models.dart';
import '../../data/repositories/platform_admin_repository.dart';

final platformAdminRepositoryProvider = Provider<PlatformAdminRepository>((ref) {
  ref.watch(sessionRevisionProvider);
  return PlatformAdminRepository(ref.watch(apiClientProvider));
});

/// Тарифы сервиса. Нужны и на вкладке тарифов, и на вкладке ферм — там из
/// них собирается список выбора.
final platformPlansProvider =
    FutureProvider.autoDispose<List<Plan>>((ref) async {
  return ref.watch(platformAdminRepositoryProvider).getPlans();
});

/// Фильтр списка ферм — одно значение сразу, а не набор галочек: сервер
/// принимает единственный `filter`, и совмещать «без тарифа» с «упёрлась в
/// предел» всё равно было бы нечего — это взаимоисключающие срезы.
enum PlatformFarmFilter { noPlan, atLimit, inactiveDays }

extension on PlatformFarmFilter {
  String get apiValue => switch (this) {
        PlatformFarmFilter.noPlan => 'no_plan',
        PlatformFarmFilter.atLimit => 'at_limit',
        PlatformFarmFilter.inactiveDays => 'inactive_days',
      };
}

/// Список ферм платформы с постраничной подгрузкой, поиском и фильтром.
class PlatformFarmsState {
  const PlatformFarmsState({
    this.farms = const [],
    this.isLoading = false,
    this.error,
    this.page = 1,
    this.totalPages = 1,
    this.total = 0,
    this.searchQuery = '',
    this.filter,
  });

  final List<PlatformFarm> farms;
  final bool isLoading;
  final Object? error;
  final int page;
  final int totalPages;
  final int total;
  final String searchQuery;
  final PlatformFarmFilter? filter;

  bool get hasMore => page < totalPages;
  bool get hasFilters => searchQuery.isNotEmpty || filter != null;

  PlatformFarmsState copyWith({
    List<PlatformFarm>? farms,
    bool? isLoading,
    Object? error,
    int? page,
    int? totalPages,
    int? total,
    String? searchQuery,
    PlatformFarmFilter? filter,
    bool clearFilter = false,
  }) {
    return PlatformFarmsState(
      farms: farms ?? this.farms,
      isLoading: isLoading ?? this.isLoading,
      // Ошибка присваивается напрямую: с `?? this.error` сообщение залипало
      // бы в состоянии и после успешной загрузки.
      error: error,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      total: total ?? this.total,
      searchQuery: searchQuery ?? this.searchQuery,
      filter: clearFilter ? null : (filter ?? this.filter),
    );
  }
}

class PlatformFarmsNotifier extends StateNotifier<PlatformFarmsState> {
  PlatformFarmsNotifier(this._repository) : super(const PlatformFarmsState()) {
    load();
  }

  final PlatformAdminRepository _repository;

  static const _pageSize = 20;

  /// Первая страница по текущим поиску и фильтру — она же обновление жестом.
  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _repository.getFarms(
        page: 1,
        limit: _pageSize,
        search: state.searchQuery,
        filter: state.filter?.apiValue,
      );
      state = state.copyWith(
        farms: result.items,
        isLoading: false,
        page: result.page.page,
        totalPages: result.page.totalPages,
        total: result.page.total,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _repository.getFarms(
        page: state.page + 1,
        limit: _pageSize,
        search: state.searchQuery,
        filter: state.filter?.apiValue,
      );
      state = state.copyWith(
        farms: [...state.farms, ...result.items],
        isLoading: false,
        page: result.page.page,
        totalPages: result.page.totalPages,
        total: result.page.total,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  /// Поиск идёт на сервере: искать среди подгруженной страницы значило бы
  /// «не находить» ферму, которая ещё не приехала.
  Future<void> setSearchQuery(String query) async {
    state = state.copyWith(searchQuery: query);
    await load();
  }

  /// Выбрать фильтр или, если он уже выбран, снять — чип работает как
  /// переключатель, а не как радиокнопка с обязательным выбором.
  Future<void> toggleFilter(PlatformFarmFilter filter) async {
    state = state.filter == filter
        ? state.copyWith(clearFilter: true)
        : state.copyWith(filter: filter);
    await load();
  }

  /// Сбросить поиск и фильтр.
  Future<void> resetFilters() async {
    state = state.copyWith(searchQuery: '', clearFilter: true);
    await load();
  }

  /// Назначить ферме тариф или снять его. Возвращает причину неудачи или
  /// `null`, если всё получилось.
  ///
  /// Обновляется одна карточка, а не весь список: сервер отдаёт ферму вместе
  /// с потреблением, поэтому перечитывать страницу незачем — и уже
  /// догруженные страницы при этом не теряются.
  Future<Object?> assignPlan(int farmId, int? planId) async {
    try {
      final updated = await _repository.assignPlan(farmId, planId);
      state = state.copyWith(
        farms: [
          for (final farm in state.farms)
            if (farm.id == updated.id) updated else farm,
        ],
      );
      return null;
    } catch (e) {
      return e;
    }
  }
}

final platformFarmsProvider = StateNotifierProvider.autoDispose<
    PlatformFarmsNotifier, PlatformFarmsState>((ref) {
  return PlatformFarmsNotifier(ref.watch(platformAdminRepositoryProvider));
});
