import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/api_providers.dart';
import '../../../../core/providers/session.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notifications_repository.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  ref.watch(sessionRevisionProvider);
  return NotificationsRepository(ref.watch(apiClientProvider));
});

/// Сама лента.
final notificationsFeedProvider =
    FutureProvider.autoDispose<List<AppNotification>>((ref) async {
  return ref.watch(notificationsRepositoryProvider).load();
});

/// Сколько сообщений человек ещё не видел.
///
/// Отдельным запросом, а не подсчётом по ленте: значок с числом висит на
/// «Сегодня», и тянуть ради него всю ленту при каждом открытии экрана —
/// лишний трафик там, где связь и так плохая.
///
/// Ошибку глушим намеренно: не сосчитали — значок просто не покажется.
/// Красная плашка поверх «Сегодня» из-за того, что не удалось узнать число
/// непрочитанных, была бы хуже самой проблемы.
final unreadNotificationsProvider = FutureProvider.autoDispose<int>((ref) async {
  try {
    return await ref.watch(notificationsRepositoryProvider).unreadCount();
  } catch (_) {
    return 0;
  }
});
