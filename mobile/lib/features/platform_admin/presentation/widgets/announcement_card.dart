import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/platform_admin_models.dart';
import 'announcement_labels.dart';

final _momentFormat = DateFormat('dd.MM.yyyy HH:mm');

/// Одно отправленное объявление в истории: что ушло, кому и сколько дошло.
///
/// Результат доставки показан по каждому каналу отдельно и числом «дошло из
/// попыток»: одно «отправлено» скрывало бы главное — что до части ферм
/// сообщение не добралось и с ними надо связаться иначе.
class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({super.key, required this.announcement});

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final stats = announcement.stats;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  announcement.title,
                  style: AppTypography.titleMd
                      .copyWith(color: context.colors.onSurface),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                _momentFormat.format(announcement.createdAt),
                style: AppTypography.labelSm
                    .copyWith(color: context.colors.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          // Текст обрезан: история отвечает на «что и кому мы рассылали», а
          // не заменяет само письмо.
          Text(
            announcement.body,
            style: AppTypography.bodyMd
                .copyWith(color: context.colors.onSurfaceVariant),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.md),
          _IconLine(
            icon: announcementTargetIcon(announcement.targetType),
            text: announcementAudience(
              context,
              targetType: announcement.targetType,
              farmName: announcement.targetFarm?.name,
              targetFilter: announcement.targetFilter,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          _IconLine(
            icon: Icons.groups_outlined,
            text: announcement.hasNoRecipients
                ? l10n.platformAnnouncementNobody
                : l10n.platformAnnouncementReach(
                    announcement.farmsCount,
                    announcement.recipientsCount,
                  ),
            color: announcement.hasNoRecipients ? AppColors.warning : null,
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final channel in announcement.channels)
            _ChannelLine(
              channel: channel,
              delivery: stats?.byChannel(channel),
            ),
        ],
      ),
    );
  }
}

/// Строка «значок — подпись». Тревожный цвет — когда сказать нужно не только
/// что, но и что с этим не так.
class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.text, this.color});

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effective = color ?? context.colors.onSurfaceVariant;

    return Row(
      children: [
        Icon(icon, size: 16, color: effective),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTypography.labelSm.copyWith(color: effective),
          ),
        ),
      ],
    );
  }
}

/// Итог по одному каналу.
class _ChannelLine extends StatelessWidget {
  const _ChannelLine({required this.channel, required this.delivery});

  final String channel;
  final ChannelDelivery? delivery;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final failed = delivery?.hasFailures ?? false;
    final color =
        failed ? AppColors.error : context.colors.onSurfaceVariant;

    final result = switch (delivery) {
      // Статистики нет только у записей, сделанных до её появления. Молчать об
      // этом нельзя: «доставлено 0 из 0» соврало бы о провале рассылки.
      null => l10n.platformAnnouncementDeliveryUnknown,
      // Канал был выбран, но отправлять оказалось некому.
      final d when d.attempted == 0 => l10n.platformAnnouncementDeliveredNobody,
      final d => l10n.platformAnnouncementDelivered(d.sent, d.attempted),
    };

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        children: [
          Icon(announcementChannelIcon(channel), size: 16, color: color),
          const SizedBox(width: AppSpacing.sm),
          // Название канала уступает место итогу: «доставлено 30 из 34» —
          // то, зачем на эту строку и смотрят.
          Expanded(
            child: Text(
              announcementChannelLabel(context, channel),
              style: AppTypography.labelSm.copyWith(color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            result,
            style: AppTypography.labelSm.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
