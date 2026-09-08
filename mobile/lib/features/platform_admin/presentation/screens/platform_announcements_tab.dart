import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/platform_admin_models.dart';
import '../providers/platform_admin_provider.dart';
import '../widgets/announcement_card.dart';

/// История объявлений: что рассылали, кому и сколько дошло.
///
/// Отправить объявление нельзя дважды и нельзя отозвать, поэтому список — не
/// украшение, а единственный ответ на «мы это уже отправляли?».
class PlatformAnnouncementsTab extends ConsumerWidget {
  const PlatformAnnouncementsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(platformAnnouncementsProvider);
    final notifier = ref.read(platformAnnouncementsProvider.notifier);

    return PagedListView<Announcement>(
      items: state.items,
      isLoading: state.isLoading,
      error: state.error,
      hasMore: state.hasMore,
      onRefresh: notifier.load,
      onLoadMore: notifier.loadMore,
      // Счётчик берётся из пагинации, а не из длины загруженного списка, и
      // прячется при пустом списке — как в списке ферм.
      header: state.items.isEmpty ? null : _Total(total: state.total),
      empty: AppEmptyState(
        icon: Icons.campaign_outlined,
        title: context.l10n.platformAnnouncementsEmptyTitle,
        subtitle: context.l10n.platformAnnouncementsEmptyBody,
        // Та же кнопка, что в правом нижнем углу: на пустой вкладке подсказка
        // без действия заставляла бы искать её глазами.
        actionLabel: context.l10n.platformAnnouncementNew,
        onAction: () => context.push('/platform-admin/announcements/form'),
      ),
      itemBuilder: (context, announcement, _) =>
          AnnouncementCard(announcement: announcement),
    );
  }
}

class _Total extends StatelessWidget {
  const _Total({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.lg,
        AppSpacing.screenH,
        0,
      ),
      child: AppGroupLabel(context.l10n.countAnnouncements(total)),
    );
  }
}
