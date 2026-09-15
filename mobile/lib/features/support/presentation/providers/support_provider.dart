import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/models/support_contact.dart';
import '../../../../core/providers/api_providers.dart';
import '../../data/models/support_request.dart';
import '../../data/repositories/support_repository.dart';

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  return SupportRepository(ref.watch(apiClientProvider));
});

/// Официальный контакт поддержки. Молча падает в пустой контакт при ошибке
/// сети — это дополнение к внутренней фиче «Обращения», а не критичный путь,
/// не стоит перекрывать экран поддержки баннером ошибки из-за него.
final supportContactProvider = FutureProvider<SupportContact>((ref) async {
  try {
    return await ref.watch(supportRepositoryProvider).getContact();
  } catch (_) {
    return const SupportContact();
  }
});

/// Свои обращения фермы с постраничной подгрузкой — тот же приём, что у
/// списка обращений в админке: список сверху вниз, без поиска и фильтров.
class MySupportRequestsState {
  const MySupportRequestsState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.page = 1,
    this.totalPages = 1,
    this.total = 0,
  });

  final List<SupportRequest> items;
  final bool isLoading;
  final Object? error;
  final int page;
  final int totalPages;
  final int total;

  bool get hasMore => page < totalPages;

  MySupportRequestsState copyWith({
    List<SupportRequest>? items,
    bool? isLoading,
    Object? error,
    int? page,
    int? totalPages,
    int? total,
  }) {
    return MySupportRequestsState(
      items: items ?? this.items,
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

class MySupportRequestsNotifier extends StateNotifier<MySupportRequestsState> {
  MySupportRequestsNotifier(this._repository)
    : super(const MySupportRequestsState()) {
    load();
  }

  final SupportRepository _repository;

  static const _pageSize = 20;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _repository.list(page: 1, limit: _pageSize);
      state = state.copyWith(
        items: result.items,
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
      final result = await _repository.list(
        page: state.page + 1,
        limit: _pageSize,
      );
      state = state.copyWith(
        items: [...state.items, ...result.items],
        isLoading: false,
        page: result.page.page,
        totalPages: result.page.totalPages,
        total: result.page.total,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }
}

final mySupportRequestsProvider =
    StateNotifierProvider.autoDispose<
      MySupportRequestsNotifier,
      MySupportRequestsState
    >((ref) {
      return MySupportRequestsNotifier(ref.watch(supportRepositoryProvider));
    });
