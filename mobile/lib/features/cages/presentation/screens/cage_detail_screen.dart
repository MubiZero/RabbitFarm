import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../rabbits/data/models/rabbit_model.dart';
import '../../../rabbits/presentation/providers/rabbits_provider.dart';
import '../../../rabbits/presentation/widgets/rabbit_picker.dart';
import '../../data/models/cage_model.dart';
import '../providers/cages_provider.dart';
import '../utils/cage_labels.dart';
import '../../../../core/l10n/l10n_context.dart';

/// Карточка клетки: состояние, заполненность и кто в ней живёт.
class CageDetailScreen extends ConsumerStatefulWidget {
  final int cageId;

  const CageDetailScreen({super.key, required this.cageId});

  @override
  ConsumerState<CageDetailScreen> createState() => _CageDetailScreenState();
}

class _CageDetailScreenState extends ConsumerState<CageDetailScreen> {
  /// Идёт перемещение кролика. Содержимое экрана при этом остаётся на месте:
  /// раньше вместо него на весь экран разворачивался спиннер, и человек
  /// терял из виду список, с которым только что работал.
  bool _busy = false;

  Future<void> _refresh() async {
    ref.invalidate(cageDetailProvider(widget.cageId));
    await ref.read(cageDetailProvider(widget.cageId).future);
  }

  /// Общая обвязка действий над жителями клетки: занятость, обновление
  /// экрана и сообщение о результате.
  Future<void> _run(Future<void> Function() action, String success) async {
    setState(() => _busy = true);
    // Всё, что зависит от контекста, снимается до ожидания: экран может
    // закрыться, пока ответ идёт с сервера.
    final messenger = ScaffoldMessenger.of(context);
    final failedTemplate = context.l10n.cageActionFailed;
    try {
      await action();
      ref.invalidate(cagesProvider);
      await _refresh();
      messenger.showSnackBar(SnackBar(content: Text(success)));
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
              failedTemplate(e.toString().replaceAll('Exception: ', ''))),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _removeRabbit(RabbitModel rabbit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.cageRemoveTitle),
        content: Text(context.l10n.cageRemoveBody(rabbit.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.cageRemoveConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await _run(
      () => ref
          .read(rabbitsRepositoryProvider)
          .updateRabbit(rabbit.id, {'cage_id': null}),
      context.l10n.cageRemoved(rabbit.name),
    );
  }

  Future<void> _moveRabbit(RabbitModel rabbit) async {
    final target = await showModalBottomSheet<CageModel>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CagePickerSheet(excludeCageId: widget.cageId),
    );
    if (target == null || !mounted) return;

    await _run(
      () => ref
          .read(rabbitsRepositoryProvider)
          .updateRabbit(rabbit.id, {'cage_id': target.id}),
      context.l10n.cageMoved(rabbit.name, target.number),
    );
  }

  Future<void> _addRabbit() async {
    final rabbit = await showModalBottomSheet<RabbitModel>(
      context: context,
      isScrollControlled: true,
      builder: (_) => RabbitPickerSheet(excludeCageId: widget.cageId),
    );
    if (rabbit == null || !mounted) return;

    await _run(
      () => ref
          .read(rabbitsRepositoryProvider)
          .updateRabbit(rabbit.id, {'cage_id': widget.cageId}),
      context.l10n.cageSettled(rabbit.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cageAsync = ref.watch(cageDetailProvider(widget.cageId));
    final canManage = ref.watch(canProvider(FarmCapability.manageLivestock));
    final cage = cageAsync.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(cage == null
            ? context.l10n.cageTitle
            : context.l10n.cageTitleNumbered(cage.number)),
        actions: [
          if (canManage && cage != null)
            IconButton(
              tooltip: context.l10n.cageEdit,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.push('/cages/form', extra: cage),
            ),
        ],
        bottom: _busy
            ? const PreferredSize(
                preferredSize: Size.fromHeight(2),
                child: LinearProgressIndicator(minHeight: 2),
              )
            : null,
      ),
      body: AbsorbPointer(
        absorbing: _busy,
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: AppAsyncView<CageModel>(
            value: cageAsync,
            onRetry: _refresh,
            skeleton: (_) => const SkeletonList(count: 3, itemHeight: 120),
            builder: (cage) => _content(cage, canManage),
          ),
        ),
      ),
      floatingActionButton: _fab(cage, canManage),
    );
  }

  Widget? _fab(CageModel? cage, bool canManage) {
    if (cage == null || !canManage) return null;
    final full = cage.isFull ?? false;

    return FloatingActionButton.extended(
      // Заполненная клетка — не ошибка приложения, поэтому кнопка остаётся на
      // месте и прямо говорит, почему не работает.
      onPressed: full || _busy ? null : _addRabbit,
      icon: Icon(full ? Icons.do_not_disturb_on_outlined : Icons.add),
      label: Text(full ? context.l10n.cageFull : context.l10n.cageAddRabbit),
    );
  }

  Widget _content(CageModel cage, bool canManage) {
    final rabbits = cage.rabbits ?? const <RabbitModel>[];

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.lg,
        AppSpacing.screenH,
        AppSpacing.fabSafeBottom,
      ),
      children: [
        _CageSummary(cage: cage),
        const SizedBox(height: AppSpacing.xl),
        AppSectionTitle(
          context.l10n.cageResidents,
          subtitle: context.l10n.countRabbits(rabbits.length),
        ),
        if (rabbits.isEmpty)
          AppCard(
            child: Row(
              children: [
                Icon(Icons.pets_outlined,
                    color: context.colors.onSurfaceVariant),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    canManage
                        ? context.l10n.cageEmptyManaged
                        : context.l10n.cageEmptyReadOnly,
                    style: AppTypography.bodyMd
                        .copyWith(color: context.colors.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          )
        else
          for (var i = 0; i < rabbits.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.sm),
            _ResidentTile(
              rabbit: rabbits[i],
              canManage: canManage,
              onOpen: () => context.push('/rabbits/${rabbits[i].id}'),
              onMove: () => _moveRabbit(rabbits[i]),
              onRemove: () => _removeRabbit(rabbits[i]),
            ),
          ],
      ],
    );
  }
}

class _CageSummary extends StatelessWidget {
  final CageModel cage;

  const _CageSummary({required this.cage});

  @override
  Widget build(BuildContext context) {
    final occupied = cage.rabbits?.length ?? cage.currentOccupancy ?? 0;
    final conditionColor = cageConditionColor(context, cage.condition);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cageTypeLabel(context, cage.type),
                      style: AppTypography.titleMd
                          .copyWith(color: context.colors.onSurface),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      cageConditionLabel(context, cage.condition),
                      style:
                          AppTypography.labelLg.copyWith(color: conditionColor),
                    ),
                  ],
                ),
              ),
              _Occupancy(occupied: occupied, capacity: cage.capacity),
            ],
          ),
          const Divider(height: AppSpacing.xxl),
          Row(
            children: [
              Icon(Icons.place_outlined,
                  size: 20, color: context.colors.onSurfaceVariant),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  cage.location?.trim().isNotEmpty == true
                      ? cage.location!.trim()
                      : context.l10n.cageNoLocation,
                  style: AppTypography.bodyMd
                      .copyWith(color: context.colors.onSurface),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Occupancy extends StatelessWidget {
  final int occupied;
  final int capacity;

  const _Occupancy({required this.occupied, required this.capacity});

  @override
  Widget build(BuildContext context) {
    final ratio = capacity > 0 ? (occupied / capacity).clamp(0.0, 1.0) : 0.0;
    final color = ratio >= 1 ? AppColors.warning : AppColors.success;

    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: ratio,
            backgroundColor: context.colors.surfaceContainerHighest,
            color: color,
            strokeWidth: 6,
          ),
          Text(
            '$occupied/$capacity',
            style: AppTypography.labelSm.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _ResidentTile extends StatelessWidget {
  final RabbitModel rabbit;
  final bool canManage;
  final VoidCallback onOpen;
  final VoidCallback onMove;
  final VoidCallback onRemove;

  const _ResidentTile({
    required this.rabbit,
    required this.canManage,
    required this.onOpen,
    required this.onMove,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onOpen,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          RabbitAvatar(photoUrl: rabbit.photoUrl),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rabbit.name,
                  style: AppTypography.titleMd
                      .copyWith(color: context.colors.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  rabbit.tagId,
                  style: AppTypography.labelSm
                      .copyWith(color: context.colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          if (canManage)
            PopupMenuButton<_ResidentAction>(
              tooltip: context.l10n.commonActions,
              onSelected: (action) => switch (action) {
                _ResidentAction.move => onMove(),
                _ResidentAction.remove => onRemove(),
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: _ResidentAction.move,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.swap_horiz),
                    title: Text(context.l10n.cageResidentMove),
                  ),
                ),
                PopupMenuItem(
                  value: _ResidentAction.remove,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.logout, color: AppColors.error),
                    title: Text(
                      context.l10n.cageRemoveConfirm,
                      style: AppTypography.bodyLg
                          .copyWith(color: AppColors.error),
                    ),
                  ),
                ),
              ],
            )
          else
            Icon(Icons.chevron_right, color: context.colors.onSurfaceVariant),
        ],
      ),
    );
  }
}

enum _ResidentAction { move, remove }

/// Выбор клетки для переезда.
class _CagePickerSheet extends ConsumerWidget {
  final int excludeCageId;

  const _CagePickerSheet({required this.excludeCageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cagesProvider);
    final available = state.cages
        .where((c) => c.id != excludeCageId && (c.isAvailable ?? false))
        .toList();

    return _PickerSheet(
      title: context.l10n.cagePickCageTitle,
      child: available.isEmpty
          ? AppEmptyState(
              icon: Icons.grid_off_outlined,
              title: context.l10n.cagePickNoFreeCages,
              subtitle: context.l10n.cagePickNoFreeCagesBody,
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                0,
                AppSpacing.screenH,
                AppSpacing.xl,
              ),
              itemCount: available.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, i) {
                final cage = available[i];
                final occupied =
                    cage.rabbits?.length ?? cage.currentOccupancy ?? 0;

                return AppCard(
                  onTap: () => Navigator.pop(context, cage),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.cageTitleNumbered(cage.number),
                              style: AppTypography.titleMd
                                  .copyWith(color: context.colors.onSurface),
                            ),
                            Text(
                              [
                                cageTypeLabel(context, cage.type),
                                if (cage.location?.trim().isNotEmpty == true)
                                  cage.location!.trim(),
                              ].join(' · '),
                              style: AppTypography.labelSm.copyWith(
                                  color: context.colors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '$occupied/${cage.capacity}',
                        style: AppTypography.labelLg
                            .copyWith(color: context.colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

/// Общая рамка модальной шторки выбора: заголовок и высота в три четверти
/// экрана, чтобы список не приходилось листать в щели.
class _PickerSheet extends StatelessWidget {
  final String title;
  final Widget child;

  const _PickerSheet({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.75,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              0,
              AppSpacing.screenH,
              AppSpacing.lg,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: AppTypography.titleLg
                    .copyWith(color: context.colors.onSurface),
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
