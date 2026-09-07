import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/birth_model.dart';
import '../../data/models/rabbit_model.dart';
import '../providers/births_provider.dart';
import '../providers/rabbits_provider.dart';
import '../widgets/create_kits_dialog.dart';
import '../../../../core/l10n/error_text.dart';

/// Список окролов.
class BirthsListScreen extends ConsumerWidget {
  const BirthsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(birthsProvider);
    final notifier = ref.read(birthsProvider.notifier);
    final canManage = ref.watch(canProvider(FarmCapability.manageLivestock));
    final canDelete = ref.watch(canProvider(FarmCapability.deleteRecords));

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.birthsTitle)),
      body: PagedListView<BirthModel>(
        items: state.births,
        isLoading: state.isLoading,
        error: state.error,
        onRefresh: notifier.loadBirths,
        empty: AppEmptyState(
          icon: Icons.child_care_outlined,
          title: context.l10n.birthsEmptyTitle,
          subtitle: context.l10n.birthsEmptyBody,
          actionLabel: canManage ? context.l10n.birthsAdd : null,
          onAction: canManage ? () => context.push('/births/new') : null,
        ),
        itemBuilder: (context, birth, _) => _BirthCard(
          birth: birth,
          canManage: canManage,
          canDelete: canDelete,
          onDelete: () => _delete(context, ref, birth),
          onCreateKits: () => _createKits(context, ref, birth),
        ),
      ),
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/births/new'),
              icon: const Icon(Icons.add),
              label: Text(context.l10n.birthsAdd),
            )
          : null,
    );
  }

  Future<void> _delete(
      BuildContext context, WidgetRef ref, BirthModel birth) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final done = l10n.birthsDeleted;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.birthsDeleteTitle),
        content: Text(context.l10n.birthsDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final ok = await ref.read(birthsProvider.notifier).deleteBirth(birth.id);
    messenger.showSnackBar(
      ok
          ? SnackBar(content: Text(done))
          : SnackBar(
              content: Text(errorText(l10n, ref.read(birthsProvider).error)),
              backgroundColor: AppColors.error,
            ),
    );
  }

  Future<void> _createKits(
      BuildContext context, WidgetRef ref, BirthModel birth) async {
    // Мать берётся из самой записи об окроле. Раньше её искали в загруженной
    // странице списка кроликов, и для окрола постарше кнопка отвечала
    // «мать не найдена в списке» — хотя мать, разумеется, существовала.
    final mother = birth.mother ??
        ref
            .read(rabbitsListProvider)
            .rabbits
            .where((r) => r.id == birth.motherId)
            .firstOrNull;

    await showDialog<bool>(
      context: context,
      builder: (_) => CreateKitsDialog(
        birth: birth,
        defaultPrefix: mother == null ? '' : '${mother.name}-',
        breedId: mother?.breedId,
      ),
    );
  }
}

class _BirthCard extends ConsumerWidget {
  final BirthModel birth;
  final bool canManage;
  final bool canDelete;
  final VoidCallback onDelete;
  final VoidCallback onCreateKits;

  const _BirthCard({
    required this.birth,
    required this.canManage,
    required this.canDelete,
    required this.onDelete,
    required this.onCreateKits,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final total = birth.kitsBornAlive + birth.kitsBornDead;
    final survival =
        total > 0 ? (birth.kitsBornAlive / total * 100).round() : 0;

    final mother = birth.mother ??
        ref
            .read(rabbitsListProvider)
            .rabbits
            .where((r) => r.id == birth.motherId)
            .firstOrNull;
    final date = DateTime.tryParse(birth.birthDate);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_outlined,
                  size: 16, color: context.colors.onSurfaceVariant),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  date == null
                      ? birth.birthDate
                      : DateFormat('d MMMM y', 'ru').format(date),
                  style: AppTypography.titleMd
                      .copyWith(color: context.colors.onSurface),
                ),
              ),
              if (canDelete)
                IconButton(
                  tooltip: l10n.commonDelete,
                  icon: const Icon(Icons.delete_outline),
                  color: context.colors.onSurfaceVariant,
                  onPressed: onDelete,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(Icons.female,
                  size: 16, color: AppColors.domainBreeding),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.birthsMotherLine(mother?.name ?? l10n.birthsMotherUnknown),
                  style: AppTypography.bodyLg
                      .copyWith(color: context.colors.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHighest,
              borderRadius: AppRadius.smAll,
            ),
            child: Row(
              children: [
                _Stat(
                  label: l10n.birthsAlive,
                  value: '${birth.kitsBornAlive}',
                  color: AppColors.success,
                ),
                _Stat(
                  label: l10n.birthsDead,
                  value: '${birth.kitsBornDead}',
                  color: birth.kitsBornDead > 0
                      ? AppColors.warning
                      : context.colors.onSurfaceVariant,
                ),
                _Stat(
                  label: l10n.birthsSurvival,
                  value: '$survival%',
                  color: context.colors.onSurface,
                ),
                if (birth.kitsWeaned != null)
                  _Stat(
                    label: l10n.birthsWeaned,
                    value: '${birth.kitsWeaned}',
                    color: context.colors.onSurface,
                  ),
              ],
            ),
          ),
          if (birth.complications?.trim().isNotEmpty == true) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.08),
                borderRadius: AppRadius.smAll,
                border:
                    Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_outlined,
                      size: 16, color: AppColors.warning),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      birth.complications!.trim(),
                      style: AppTypography.labelSm
                          .copyWith(color: AppColors.warning),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (birth.notes?.trim().isNotEmpty == true) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              birth.notes!.trim(),
              style: AppTypography.bodyMd
                  .copyWith(color: context.colors.onSurfaceVariant),
            ),
          ],
          if (canManage && birth.kitsBornAlive > 0) ...[
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: onCreateKits,
              icon: const Icon(Icons.auto_awesome_outlined, size: 18),
              label: Text(l10n.birthsCreateKits),
              style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44)),
            ),
          ],
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _Stat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: AppTypography.titleLg.copyWith(color: color)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.labelSm
                .copyWith(color: context.colors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Оставлено для совместимости с формой окрола: она передаёт модель кролика.
typedef BirthMother = RabbitModel;
