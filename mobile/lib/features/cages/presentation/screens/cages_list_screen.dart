import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/cage_model.dart';
import '../providers/cages_provider.dart';
import '../utils/cage_labels.dart';

/// Список клеток фермы.
class CagesListScreen extends ConsumerStatefulWidget {
  const CagesListScreen({super.key});

  @override
  ConsumerState<CagesListScreen> createState() => _CagesListScreenState();
}

class _CagesListScreenState extends ConsumerState<CagesListScreen> {
  final _search = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(
      AppDuration.normal,
      () => ref.read(cagesProvider.notifier).setSearchQuery(query.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cagesProvider);
    final notifier = ref.read(cagesProvider.notifier);
    final canManage = ref.watch(canProvider(FarmCapability.manageLivestock));
    final canDelete = ref.watch(canProvider(FarmCapability.deleteRecords));

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.cagesTitle),
        actions: [
          IconButton(
            tooltip: context.l10n.commonFilters,
            icon: Icon(state.typeFilter != null || state.conditionFilter != null
                ? Icons.filter_list_alt
                : Icons.filter_list),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const _FiltersSheet(),
            ),
          ),
        ],
      ),
      body: PagedListView<CageModel>(
        items: state.cages,
        isLoading: state.isLoading,
        error: state.error,
        hasMore: state.hasMore,
        onRefresh: notifier.loadCages,
        onLoadMore: notifier.loadMore,
        header: _Header(state: state, controller: _search, onSearch: _onSearchChanged),
        empty: state.hasFilters
            ? AppEmptyState(
                icon: Icons.search_off,
                title: context.l10n.cagesNothingFound,
                subtitle: context.l10n.cagesNothingFoundBody,
                actionLabel: context.l10n.commonReset,
                onAction: () {
                  _search.clear();
                  notifier.resetFilters();
                },
              )
            : AppEmptyState(
                icon: Icons.grid_view_outlined,
                title: context.l10n.cagesEmptyTitle,
                subtitle: context.l10n.cagesEmptyBody,
                actionLabel: canManage ? context.l10n.cagesAdd : null,
                onAction: canManage ? () => context.push('/cages/form') : null,
              ),
        itemBuilder: (context, cage, _) => _CageCard(
          cage: cage,
          canManage: canManage,
          canDelete: canDelete,
          onTap: () => context.push('/cages/${cage.id}'),
          onEdit: () => context.push('/cages/form', extra: cage),
          onClean: () => _markCleaned(cage),
          onDelete: () => _delete(cage),
        ),
      ),
      floatingActionButton: canManage
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/cages/form'),
              icon: const Icon(Icons.add),
              label: Text(context.l10n.cagesAdd),
            )
          : null,
    );
  }

  Future<void> _markCleaned(CageModel cage) async {
    final messenger = ScaffoldMessenger.of(context);
    final done = context.l10n.cagesCleaned;
    final failed = context.l10n.cagesCleanFailed;

    final ok = await ref.read(cagesProvider.notifier).markCleaned(cage.id);
    messenger.showSnackBar(
      ok
          ? SnackBar(content: Text(done))
          : SnackBar(content: Text(failed), backgroundColor: AppColors.error),
    );
  }

  Future<void> _delete(CageModel cage) async {
    final messenger = ScaffoldMessenger.of(context);
    final done = context.l10n.cagesDeleted;
    final failed = context.l10n.cagesDeleteFailed;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.cagesDeleteTitle),
        content: Text(context.l10n.cagesDeleteBody(cage.number)),
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

    final ok = await ref.read(cagesProvider.notifier).deleteCage(cage.id);
    messenger.showSnackBar(
      ok
          ? SnackBar(content: Text(done))
          : SnackBar(content: Text(failed), backgroundColor: AppColors.error),
    );
  }
}

class _Header extends ConsumerWidget {
  final CagesState state;
  final TextEditingController controller;
  final ValueChanged<String> onSearch;

  const _Header({
    required this.state,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(cagesProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenH,
            AppSpacing.md,
            AppSpacing.screenH,
            AppSpacing.sm,
          ),
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: context.l10n.cagesSearchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: state.searchQuery.isEmpty
                  ? null
                  : IconButton(
                      tooltip: context.l10n.commonClearSearch,
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.clear();
                        notifier.setSearchQuery('');
                      },
                    ),
            ),
            // Поиск уходит на сервер, а не фильтрует загруженную страницу:
            // иначе клетка со второй страницы «не находилась».
            onChanged: onSearch,
            onSubmitted: (v) => notifier.setSearchQuery(v.trim()),
          ),
        ),
        AppFilterBar(
          chips: [
            AppFilterChipData(
              label: context.l10n.cagesOnlyAvailable,
              isSelected: state.onlyAvailable,
              onTap: notifier.toggleOnlyAvailable,
              color: AppColors.success,
            ),
            if (state.typeFilter != null)
              AppFilterChipData(
                label: cageTypeLabel(context, state.typeFilter!),
                isSelected: true,
                onTap: () => notifier.setTypeFilter(null),
              ),
            if (state.conditionFilter != null)
              AppFilterChipData(
                label: cageConditionLabel(context, state.conditionFilter!),
                isSelected: true,
                onTap: () => notifier.setConditionFilter(null),
                color: cageConditionColor(context, state.conditionFilter!),
              ),
            if (state.locationFilter != null)
              AppFilterChipData(
                label: state.locationFilter!,
                isSelected: true,
                onTap: () => notifier.setLocationFilter(null),
              ),
          ],
        ),
      ],
    );
  }
}

enum _CageAction { edit, clean, delete }

class _CageCard extends StatelessWidget {
  final CageModel cage;
  final bool canManage;
  final bool canDelete;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onClean;
  final VoidCallback onDelete;

  const _CageCard({
    required this.cage,
    required this.canManage,
    required this.canDelete,
    required this.onTap,
    required this.onEdit,
    required this.onClean,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final occupied = cage.currentOccupancy ?? cage.rabbits?.length ?? 0;
    final ratio =
        cage.capacity > 0 ? (occupied / cage.capacity).clamp(0.0, 1.0) : 0.0;

    // Цвет говорит о состоянии клетки, а не о её заполненности: полная
    // исправная клетка — это норма, а не повод для тревожного цвета.
    final conditionColor = cageConditionColor(context, cage.condition);
    final fillColor = ratio >= 1 ? AppColors.warning : AppColors.success;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: conditionColor.withValues(alpha: 0.12),
                  borderRadius: AppRadius.mdAll,
                ),
                child: Icon(cageTypeIcon(cage.type),
                    color: conditionColor, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
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
                      style: AppTypography.labelSm
                          .copyWith(color: context.colors.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (canManage)
                PopupMenuButton<_CageAction>(
                  tooltip: context.l10n.commonActions,
                  onSelected: (action) => switch (action) {
                    _CageAction.edit => onEdit(),
                    _CageAction.clean => onClean(),
                    _CageAction.delete => onDelete(),
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: _CageAction.edit,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.edit_outlined),
                        title: Text(context.l10n.cageEdit),
                      ),
                    ),
                    PopupMenuItem(
                      value: _CageAction.clean,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.cleaning_services_outlined),
                        title: Text(context.l10n.cagesMarkCleaned),
                      ),
                    ),
                    if (canDelete)
                      PopupMenuItem(
                        value: _CageAction.delete,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.delete_outline,
                              color: AppColors.error),
                          title: Text(
                            context.l10n.commonDelete,
                            style: AppTypography.bodyLg
                                .copyWith(color: AppColors.error),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.cagesOccupancy(occupied, cage.capacity),
                  style: AppTypography.labelSm
                      .copyWith(color: context.colors.onSurfaceVariant),
                ),
              ),
              Text(
                cageConditionLabel(context, cage.condition),
                style: AppTypography.labelSm.copyWith(color: conditionColor),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: context.colors.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(fillColor),
              minHeight: 6,
            ),
          ),
          if (cage.lastCleanedAt != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(Icons.cleaning_services_outlined,
                    size: 14, color: context.colors.onSurfaceVariant),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  context.l10n.cagesLastCleaned(
                      DateFormat('d MMMM', 'ru').format(cage.lastCleanedAt!)),
                  style: AppTypography.labelSm
                      .copyWith(color: context.colors.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _FiltersSheet extends ConsumerStatefulWidget {
  const _FiltersSheet();

  @override
  ConsumerState<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends ConsumerState<_FiltersSheet> {
  static const _types = ['single', 'group', 'maternity'];
  static const _conditions = ['good', 'needs_repair', 'broken'];

  String? _type;
  String? _condition;

  @override
  void initState() {
    super.initState();
    final state = ref.read(cagesProvider);
    _type = state.typeFilter;
    _condition = state.conditionFilter;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenH,
          0,
          AppSpacing.screenH,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.commonFilters,
              style: AppTypography.titleLg
                  .copyWith(color: context.colors.onSurface),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppGroupLabel(context.l10n.cageFormType),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final type in _types)
                  ChoiceChip(
                    label: Text(cageTypeLabel(context, type)),
                    selected: _type == type,
                    onSelected: (selected) =>
                        setState(() => _type = selected ? type : null),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            AppGroupLabel(context.l10n.cagesFilterCondition),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final condition in _conditions)
                  ChoiceChip(
                    label: Text(cageConditionLabel(context, condition)),
                    selected: _condition == condition,
                    onSelected: (selected) => setState(
                        () => _condition = selected ? condition : null),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(cagesProvider.notifier).resetFilters();
                      Navigator.pop(context);
                    },
                    child: Text(context.l10n.commonReset),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      final notifier = ref.read(cagesProvider.notifier);
                      notifier.setTypeFilter(_type);
                      notifier.setConditionFilter(_condition);
                      Navigator.pop(context);
                    },
                    child: Text(context.l10n.commonApply),
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
