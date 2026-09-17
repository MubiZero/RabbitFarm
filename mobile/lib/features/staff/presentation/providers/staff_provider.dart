import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/providers/session.dart';
import '../../../../core/providers/api_providers.dart';
import '../../data/models/staff_models.dart';
import '../../data/repositories/staff_repository.dart';

final staffRepositoryProvider = Provider<StaffRepository>((ref) {
  ref.watch(sessionRevisionProvider);
  return StaffRepository(ref.watch(apiClientProvider));
});

/// Состав фермы.
final farmMembersProvider =
    FutureProvider.autoDispose<List<FarmMember>>((ref) async {
  return ref.watch(staffRepositoryProvider).getMembers();
});

/// Действующие приглашения.
final farmInvitationsProvider =
    FutureProvider.autoDispose<List<FarmInvitation>>((ref) async {
  return ref.watch(staffRepositoryProvider).getInvitations();
});

/// Состояние журнала фермы.
class FarmAuditState {
  const FarmAuditState({
    this.entries = const [],
    this.isLoading = false,
    this.error,
    this.page = 1,
    this.hasMore = false,
  });

  final List<FarmAuditEntry> entries;
  final bool isLoading;
  final Object? error;
  final int page;
  final bool hasMore;

  FarmAuditState copyWith({
    List<FarmAuditEntry>? entries,
    bool? isLoading,
    Object? error,
    int? page,
    bool? hasMore,
  }) =>
      FarmAuditState(
        entries: entries ?? this.entries,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        page: page ?? this.page,
        hasMore: hasMore ?? this.hasMore,
      );
}

/// Журнал фермы страницами, свежее сверху.
///
/// Записей тут накапливается больше, чем в любом другом списке — каждая
/// правка и каждое удаление, — поэтому страницы здесь не украшение.
class FarmAuditNotifier extends StateNotifier<FarmAuditState> {
  FarmAuditNotifier(this._repository) : super(const FarmAuditState()) {
    load();
  }

  final StaffRepository _repository;

  static const _pageSize = 30;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final page = await _repository.getAuditLog(page: 1, limit: _pageSize);
      state = FarmAuditState(
        entries: page.items,
        page: page.page,
        hasMore: page.page < page.totalPages,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final page =
          await _repository.getAuditLog(page: state.page + 1, limit: _pageSize);
      state = FarmAuditState(
        entries: [...state.entries, ...page.items],
        page: page.page,
        hasMore: page.page < page.totalPages,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }
}

final farmAuditProvider =
    StateNotifierProvider.autoDispose<FarmAuditNotifier, FarmAuditState>((ref) {
  return FarmAuditNotifier(ref.watch(staffRepositoryProvider));
});
