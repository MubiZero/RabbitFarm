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
import '../../../../core/l10n/date_locale.dart';

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
        hasMore: state.hasMore,
        onRefresh: notifier.loadBirths,
        onLoadMore: notifier.loadMore,
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
          onKitDeath: () => _recordKitDeaths(context, ref, birth),
          onWeaning: () => _recordWeaning(context, ref, birth),
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

  /// Отметить, что часть выводка пала.
  ///
  /// Спрашивается количество, а не «кто именно»: на ферме считают выводок
  /// целиком — «из восьми осталось шесть», — и заводить карточку на каждого
  /// крольчонка ради этого никто не станет.
  Future<void> _recordKitDeaths(
    BuildContext context,
    WidgetRef ref,
    BirthModel birth,
  ) async {
    final died = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _KitDeathSheet(alive: birth.kitsAlive),
    );
    if (died == null || died <= 0 || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final notifier = ref.read(birthsProvider.notifier);
    final ok = await notifier.updateBirth(birth.id, {
      'kits_died': birth.kitsDied + died,
    });

    messenger.showSnackBar(
      ok
          ? SnackBar(content: Text(l10n.birthsKitDeathSaved))
          : SnackBar(
              content: Text(
                l10n.commonActionFailed(
                  errorText(l10n, ref.read(birthsProvider).error),
                ),
              ),
              backgroundColor: AppColors.error,
            ),
    );
  }

  /// Отметить, что молодняк отсадили от самки.
  ///
  /// Сервер принимает отсадку с первого дня, лента цикла по ней закрывает
  /// цикл, а задача «Отсадка» приходит на 45-й день — но отправить её до сих
  /// пор было неоткуда.
  Future<void> _recordWeaning(
    BuildContext context,
    WidgetRef ref,
    BirthModel birth,
  ) async {
    final weaned = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _KitWeaningSheet(alive: birth.kitsAlive),
    );
    if (weaned == null || weaned <= 0 || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final notifier = ref.read(birthsProvider.notifier);
    final ok = await notifier.updateBirth(birth.id, {
      'kits_weaned': weaned,
      'weaning_date': DateTime.now().toIso8601String().split('T').first,
    });

    messenger.showSnackBar(
      ok
          ? SnackBar(content: Text(l10n.birthsWeaningSaved))
          : SnackBar(
              content: Text(
                l10n.commonActionFailed(
                  errorText(l10n, ref.read(birthsProvider).error),
                ),
              ),
              backgroundColor: AppColors.error,
            ),
    );
  }

  /// Удаление без вопроса «точно удалить?», но с окном на отмену: в перчатках
  /// диалог подтверждения ничего не защищает, а несколько секунд на отмену —
  /// защищают.
  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    BirthModel birth,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final notifier = ref.read(birthsProvider.notifier);

    notifier.removeBirth(birth.id);

    var ok = true;
    await deleteWithUndo(
      context,
      message: l10n.birthsDeleted,
      commit: () async => ok = await notifier.deleteBirth(birth.id),
      onUndo: notifier.loadBirths,
    );

    if (!ok) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(errorText(l10n, ref.read(birthsProvider).error)),
          backgroundColor: AppColors.error,
        ),
      );
      await notifier.loadBirths();
    }
  }

  Future<void> _createKits(
    BuildContext context,
    WidgetRef ref,
    BirthModel birth,
  ) async {
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
  final VoidCallback onKitDeath;
  final VoidCallback onWeaning;

  const _BirthCard({
    required this.birth,
    required this.canManage,
    required this.canDelete,
    required this.onDelete,
    required this.onCreateKits,
    required this.onKitDeath,
    required this.onWeaning,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    // Выживаемость считается по тем, кто дожил, а не по тем, кто родился
    // живым: павшие после окрола крольчата (kitsDied) в неё не входили, и
    // выводок, из которого половина погибла в первую неделю, показывал те же
    // сто процентов, что и благополучный.
    final total = birth.kitsBornAlive + birth.kitsBornDead;
    final survivors =
        (birth.kitsBornAlive - birth.kitsDied).clamp(0, birth.kitsBornAlive);
    final survival = total > 0 ? (survivors / total * 100).round() : 0;

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
              Icon(
                Icons.event_outlined,
                size: 16,
                color: context.colors.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  date == null
                      ? birth.birthDate
                      : DateFormat('d MMMM y', dateLocaleOf(context)).format(date),
                  style: AppTypography.titleMd.copyWith(
                    color: context.colors.onSurface,
                  ),
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
              const Icon(
                Icons.female,
                size: 16,
                color: AppColors.domainBreeding,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.birthsMotherLine(
                    mother?.name ?? l10n.birthsMotherUnknown,
                  ),
                  style: AppTypography.bodyLg.copyWith(
                    color: context.colors.onSurface,
                  ),
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
                if (birth.kitsDied > 0)
                  _Stat(
                    label: l10n.birthsKitsDied,
                    value: '${birth.kitsDied}',
                    color: AppColors.error,
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
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_outlined,
                    size: 16,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      birth.complications!.trim(),
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.warning,
                      ),
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
              style: AppTypography.bodyMd.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
          // Карточки заведены — крольчата считаются по ним, и здесь делать
          // больше нечего: числа выводка заморожены, а падёж и отсадку
          // отмечают на карточке крольчонка. Раньше обе половины жили
          // независимо: отметка в выводке до карточек не доходила, отметка на
          // карточке — до выводка, и какая из них права, не знал никто.
          if (birth.kitsCarded) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.badge_outlined,
                  size: 16,
                  color: context.colors.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    l10n.birthsKitsCardedHint,
                    style: AppTypography.labelSm.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ] else if (canManage && birth.kitsBornAlive > 0) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                OutlinedButton.icon(
                  onPressed: onCreateKits,
                  icon: const Icon(Icons.auto_awesome_outlined, size: 18),
                  label: Text(l10n.birthsCreateKits),
                ),
                // Крольчонок в приложении — число внутри окрола, а не своя
                // карточка: экран падежа работает со взрослым кроликом, и
                // отметить потерю в выводке до сих пор было негде.
                if (birth.kitsAlive > 0)
                  OutlinedButton.icon(
                    onPressed: onKitDeath,
                    icon: const Icon(Icons.remove_circle_outline, size: 18),
                    label: Text(l10n.birthsKitDeathAction),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                  ),
                // Отсадка бывает один раз за окрол: записанную не переспрашивают,
                // а отсаживать нечего, когда весь выводок пал.
                if (birth.weaningDate == null &&
                    birth.kitsWeaned == null &&
                    birth.kitsAlive > 0)
                  OutlinedButton.icon(
                    onPressed: onWeaning,
                    icon: const Icon(Icons.pets_outlined, size: 18),
                    label: Text(l10n.birthsWeaningAction),
                  ),
              ],
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

  const _Stat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: AppTypography.titleLg.copyWith(color: color)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.labelSm.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Оставлено для совместимости с формой окрола: она передаёт модель кролика.
typedef BirthMother = RabbitModel;

/// Сколько крольчат пало.
///
/// Цифры кнопками, а не поле ввода: отмечают это стоя у клетки, одной рукой
/// и в перчатке, а потери в выводке считаются единицами.
class _KitDeathSheet extends StatelessWidget {
  const _KitDeathSheet({required this.alive});

  final int alive;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.birthsKitDeathTitle, style: context.text.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.birthsKitDeathHint(alive),
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (var n = 1; n <= alive; n++)
                  SizedBox(
                    width: AppSizes.touchTargetLarge,
                    height: AppSizes.touchTargetLarge,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(n),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: const CircleBorder(),
                      ),
                      child: Text('$n', style: context.text.titleMedium),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Сколько крольчат отсадили.
///
/// Обычный случай — «всех», и он стоит отдельной крупной кнопкой: набирать
/// цифру, чтобы подтвердить очевидное, у клетки никто не будет. Меньшее
/// количество рядом — на случай, когда часть выводка оставили под самкой.
class _KitWeaningSheet extends StatelessWidget {
  const _KitWeaningSheet({required this.alive});

  final int alive;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.birthsWeaningTitle, style: context.text.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.birthsWeaningHint(alive),
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(alive),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(AppSizes.touchTargetLarge),
              ),
              child: Text(l10n.birthsWeaningAll(alive)),
            ),
            if (alive > 1) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.birthsWeaningFewer,
                style: AppTypography.labelSm.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (var n = 1; n < alive; n++)
                    SizedBox(
                      width: AppSizes.touchTargetLarge,
                      height: AppSizes.touchTargetLarge,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(n),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: const CircleBorder(),
                        ),
                        child: Text('$n', style: context.text.titleMedium),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
