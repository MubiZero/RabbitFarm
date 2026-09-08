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

/// Список ферм платформы с постраничной подгрузкой.
class PlatformFarmsState {
  const PlatformFarmsState({
    this.farms = const [],
    this.isLoading = false,
    this.error,
    this.page = 1,
    this.totalPages = 1,
    this.total = 0,
  });

  final List<PlatformFarm> farms;
  final bool isLoading;
  final Object? error;
  final int page;
  final int totalPages;
  final int total;

  bool get hasMore => page < totalPages;

  PlatformFarmsState copyWith({
    List<PlatformFarm>? farms,
    bool? isLoading,
    Object? error,
    int? page,
    int? totalPages,
    int? total,
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
    );
  }
}

class PlatformFarmsNotifier extends StateNotifier<PlatformFarmsState> {
  PlatformFarmsNotifier(this._repository) : super(const PlatformFarmsState()) {
    load();
  }

  final PlatformAdminRepository _repository;

  static const _pageSize = 20;

  /// Первая страница — она же обновление жестом.
  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _repository.getFarms(page: 1, limit: _pageSize);
      state = PlatformFarmsState(
        farms: result.items,
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
      final result =
          await _repository.getFarms(page: state.page + 1, limit: _pageSize);
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
