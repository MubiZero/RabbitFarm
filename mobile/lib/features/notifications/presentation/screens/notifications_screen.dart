import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/date_locale.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/notification_model.dart';
import '../providers/notifications_provider.dart';

/// Что приложение сообщало, пока человек не смотрел.
///
/// Раньше единственным каналом был пуш: он пропадает со шторки, а до того,
/// кто отказал в разрешении или просто не открыл телефон утром, не доходит
/// вовсе. Просроченные прививки, кончающийся корм и окрол послезавтра
/// оставались в приложении данными, которые надо искать самому.
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Открыл экран — значит увидел. Отдельной кнопки «прочитано» нет: она
    // заставляла бы делать руками то, что и так очевидно из действия.
    WidgetsBinding.instance.addPostFrameCallback((_) => _markRead());
  }

  Future<void> _markRead() async {
    try {
      await ref.read(notificationsRepositoryProvider).markAllRead();
    } catch (_) {
      // Не отметили — сообщения останутся непрочитанными, и человек увидит
      // их снова. Это безобиднее сообщения об ошибке на ровном месте.
      return;
    }
    if (mounted) ref.invalidate(unreadNotificationsProvider);
  }

  Future<void> _refresh() =>
      ref.read(notificationsFeedProvider.notifier).load();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationsFeedProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.notificationsTitle)),
      // Лента догружается прокруткой: раньше она показывала первые тридцать
      // сообщений, и всё, что старше, было не достать.
      body: PagedListView<AppNotification>(
        items: state.items,
        isLoading: state.isLoading,
        error: state.error,
        hasMore: state.hasMore,
        onRefresh: _refresh,
        onLoadMore: ref.read(notificationsFeedProvider.notifier).loadMore,
        empty: AppEmptyState(
          icon: Icons.notifications_none,
          title: context.l10n.notificationsEmptyTitle,
          subtitle: context.l10n.notificationsEmptyBody,
        ),
        itemBuilder: (context, item, _) => _NotificationCard(item),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard(this.notification);

  final AppNotification notification;

  /// Значок по виду сообщения — тот же, которым это дело помечено в разделах.
  IconData get _icon => switch (notification.type) {
        'vaccination_digest' => Icons.vaccines_outlined,
        'feed_digest' => Icons.restaurant_outlined,
        'task_digest' => Icons.check_circle_outline,
        'kindling_soon' => Icons.favorite_outline,
        'payment_receipt' => Icons.payments_outlined,
        'support_answered' => Icons.support_agent_outlined,
        'announcement' => Icons.campaign_outlined,
        _ => Icons.notifications_none,
      };

  @override
  Widget build(BuildContext context) {
    final route = notification.route;
    final colors = context.colors;
    // Непрочитанное выделяется цветом значка, а не фоном карточки: фон уже
    // занят разделением карточек между собой.
    final accent =
        notification.isRead ? colors.onSurfaceVariant : colors.primary;

    return AppCard(
      onTap: route == null ? null : () => context.push(route),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: AppRadius.smAll,
            ),
            child: Icon(_icon, color: accent, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: AppTypography.titleMd.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                if (notification.body.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    notification.body,
                    style: AppTypography.bodyMd.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xs),
                Text(
                  DateFormat(
                    'd MMM, HH:mm',
                    dateSymbolsLocale(Localizations.localeOf(context)),
                  ).format(notification.createdAt),
                  style: AppTypography.labelSm.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (route != null)
            Icon(Icons.chevron_right, color: colors.onSurfaceVariant),
        ],
      ),
    );
  }
}

/// Колокольчик с числом непрочитанных.
///
/// Стоит в шапке «Сегодня» — там же, где человек каждое утро решает, чем
/// заняться. Прячется, когда читать нечего: пустой колокольчик обещает то,
/// чего за ним нет.
class NotificationsBell extends ConsumerWidget {
  const NotificationsBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadNotificationsProvider).value ?? 0;

    return IconButton(
      tooltip: context.l10n.notificationsTitle,
      onPressed: () async {
        await context.push('/notifications');
        ref.invalidate(unreadNotificationsProvider);
      },
      iconSize: 26,
      constraints: const BoxConstraints(
        minWidth: AppSizes.iconButton,
        minHeight: AppSizes.iconButton,
      ),
      icon: Badge(
        isLabelVisible: unread > 0,
        // Точное число важнее круглого значка: «3» и «17» — это разный
        // повод открыть экран.
        label: Text(unread > 99 ? '99+' : '$unread'),
        child: Icon(
          unread > 0 ? Icons.notifications : Icons.notifications_none,
          color: context.colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
