import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/date_locale.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/staff_models.dart';
import '../providers/staff_provider.dart';
import '../widgets/farm_audit_labels.dart';

/// Кто и что менял в хозяйстве.
///
/// Владельцы называют страх «помощник испортит мои записи» вторым после
/// пропущенного окрола. Удаления сервер записывал давно, но показывать их
/// приложение умело только в ленте «Журнал» за выбранный срок, а правки не
/// записывались вовсе: после правки запись оставалась подписана тем, кто
/// завёл её изначально.
class FarmAuditScreen extends ConsumerWidget {
  const FarmAuditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(farmAuditProvider);
    final notifier = ref.read(farmAuditProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.farmAuditTitle)),
      body: PagedListView<FarmAuditEntry>(
        items: state.entries,
        isLoading: state.isLoading,
        error: state.error,
        hasMore: state.hasMore,
        onRefresh: notifier.load,
        onLoadMore: notifier.loadMore,
        empty: AppEmptyState(
          icon: Icons.history,
          title: context.l10n.farmAuditEmptyTitle,
          subtitle: context.l10n.farmAuditEmptyBody,
        ),
        itemBuilder: (context, entry, _) => _AuditCard(entry),
      ),
    );
  }
}

class _AuditCard extends StatelessWidget {
  const _AuditCard(this.entry);

  final FarmAuditEntry entry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Удаление подкрашено, остальное — обычная работа. Красить и правки
    // значило бы приучить глаз скользить мимо красного.
    final accent = entry.isStaffAction || entry.isUpdate
        ? colors.onSurfaceVariant
        : AppColors.error;

    final subject = entry.isStaffAction
        ? entry.target?.fullName
        : entry.entityLabel ?? auditEntityName(context, entry.entityType);

    final changes = auditChangeLines(context, entry);

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: AppRadius.smAll,
            ),
            child: Icon(auditActionIcon(entry), color: accent, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject ?? auditActionText(context, entry),
                  style: AppTypography.titleMd.copyWith(color: colors.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                // Действие названо словом, а не только значком: примерно
                // каждый двенадцатый мужчина не отличит один цветной кружок
                // от другого, а на ферме таких пользователей большинство.
                Text(
                  _what(context),
                  style: AppTypography.bodyMd
                      .copyWith(color: colors.onSurfaceVariant),
                ),
                for (final line in changes) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    line,
                    style: AppTypography.bodyMd
                        .copyWith(color: colors.onSurfaceVariant),
                  ),
                ],
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(Icons.schedule,
                        size: 14, color: colors.onSurfaceVariant),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      DateFormat(
                        'd MMM, HH:mm',
                        dateSymbolsLocale(Localizations.localeOf(context)),
                      ).format(entry.at),
                      style: AppTypography.labelSm
                          .copyWith(color: colors.onSurfaceVariant),
                    ),
                    if (entry.actor != null) ...[
                      const SizedBox(width: AppSpacing.lg),
                      Icon(Icons.person_outline,
                          size: 14, color: colors.onSurfaceVariant),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          entry.actor!.fullName,
                          style: AppTypography.labelSm
                              .copyWith(color: colors.onSurfaceVariant),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// «Исправлено · Кормление» — что сделали и с чем.
  String _what(BuildContext context) {
    final action = auditActionText(context, entry);
    final entity = auditEntityName(context, entry.entityType);
    return entity == null ? action : '$action · $entity';
  }
}
