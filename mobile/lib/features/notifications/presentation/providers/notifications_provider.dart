import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/api_providers.dart';
import '../../../../core/providers/session.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notifications_repository.dart';

final notificationsRepositoryProvider =
    Provider<NotificationsRepository>((ref) {
  ref.watch(sessionRevisionProvider);
  return NotificationsRepository(ref.watch(apiClientProvider));
});

/// Лента вместе с тем, есть ли ещё страницы.
///
/// Раньше это был просто список первых тридцати сообщений: всё, что старше,
/// было не достать — лента дальше не листалась.
class NotificationsFeedState {
  final List<AppNotification> items;
  final bool isLoading;
  final Object? error;
  final int currentPage;
  final bool hasMore;

  const NotificationsFeedState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = false,
  });

  NotificationsFeedState copyWith({
    List<AppNotification>? items,
    bool? isLoading,
    Object? error,
    int? currentPage,
    bool? hasMore,
  }) =>
      NotificationsFeedState(
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        currentPage: currentPage ?? this.currentPage,
        hasMore: hasMore ?? this.hasMore,
      );
}

class NotificationsFeedNotifier extends Notifier<NotificationsFeedState> {
  static const _pageSize = 30;

  late NotificationsRepository _repository;

  @override
  NotificationsFeedState build() {
    _repository = ref.watch(notificationsRepositoryProvider);
    Future.microtask(load);
    return const NotificationsFeedState(isLoading: true);
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final page = await _repository.load(page: 1, limit: _pageSize);
      state = NotificationsFeedState(
        items: page.items,
        currentPage: page.page,
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
      final page = await _repository.load(
        page: state.currentPage + 1,
        limit: _pageSize,
      );
      state = state.copyWith(
        items: [...state.items, ...page.items],
        isLoading: false,
        currentPage: page.page,
        hasMore: page.page < page.totalPages,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }
}

/// Сама лента.
final notificationsFeedProvider =
    NotifierProvider<NotificationsFeedNotifier, NotificationsFeedState>(
  NotificationsFeedNotifier.new,
);

/// Сколько сообщений человек ещё не видел.
///
/// Отдельным запросом, а не подсчётом по ленте: значок с числом висит на
/// «Сегодня», и тянуть ради него всю ленту при каждом открытии экрана —
/// лишний трафик там, где связь и так плохая.
///
/// Ошибку глушим намеренно: не сосчитали — значок просто не покажется.
/// Красная плашка поверх «Сегодня» из-за того, что не удалось узнать число
/// непрочитанных, была бы хуже самой проблемы.
final unreadNotificationsProvider =
    FutureProvider.autoDispose<int>((ref) async {
  try {
    return await ref.watch(notificationsRepositoryProvider).unreadCount();
  } catch (_) {
    return 0;
  }
});
