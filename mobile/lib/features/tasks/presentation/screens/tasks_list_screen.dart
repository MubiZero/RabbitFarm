import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/date_labels.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/task_model.dart';
import '../providers/tasks_provider.dart';
import '../utils/task_labels.dart';

/// Список дел фермы.
class TasksListScreen extends ConsumerWidget {
  const TasksListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tasksListProvider);
    final notifier = ref.read(tasksListProvider.notifier);
    final filtered = _hasFilters(state);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.tasksTitle),
        actions: [
          IconButton(
            tooltip: context.l10n.commonFilters,
            icon: Icon(filtered ? Icons.filter_list_alt : Icons.filter_list),
            onPressed: () => _showFilters(context, ref),
          ),
        ],
      ),
      body: PagedListView<Task>(
        items: state.tasks,
        isLoading: state.isLoading,
        error: state.error,
        hasMore: state.hasMore,
        onRefresh: notifier.refresh,
        onLoadMore: notifier.loadMore,
        header: filtered ? _ActiveFilters(state: state) : null,
        // Пустой список из-за фильтров и пустой список на новой ферме — разные
        // ситуации, и совет в них нужен разный. Раньше обеим показывалось
        // «Попробуйте изменить фильтры», даже когда фильтров не было вовсе.
        empty: filtered
            ? AppEmptyState(
                icon: Icons.filter_alt_off_outlined,
                title: context.l10n.tasksNothingMatchesTitle,
                subtitle: context.l10n.tasksNothingMatchesBody,
                actionLabel: context.l10n.commonReset,
                onAction: notifier.clearFilters,
              )
            : AppEmptyState(
                icon: Icons.task_alt_outlined,
                title: context.l10n.tasksEmptyTitle,
                subtitle: context.l10n.tasksEmptyBody,
                actionLabel: context.l10n.tasksEmptyAction,
                onAction: () => context.push('/tasks/form'),
              ),
        itemBuilder: (context, task, _) => _TaskCard(
          task: task,
          onTap: () => context.push('/tasks/form', extra: task),
          onComplete: () => _complete(context, ref, task),
        ),
      ),
    );
  }

  bool _hasFilters(TasksListState s) =>
      s.typeFilter != null ||
      s.statusFilter != null ||
      s.priorityFilter != null ||
      s.overdueOnly ||
      s.todayOnly;

  Future<void> _complete(
      BuildContext context, WidgetRef ref, Task task) async {
    final messenger = ScaffoldMessenger.of(context);
    final done = context.l10n.tasksCompleted;
    final failed = context.l10n.tasksCompleteFailed;
    try {
      await ref.read(taskActionsProvider).completeTask(task.id);
      messenger.showSnackBar(SnackBar(content: Text(done)));
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(failed), backgroundColor: AppColors.error),
      );
    }
  }

  void _showFilters(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _FiltersSheet(),
    );
  }
}

class _ActiveFilters extends ConsumerWidget {
  final TasksListState state;

  const _ActiveFilters({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(tasksListProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.md,
        AppSpacing.screenH,
        0,
      ),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          if (state.typeFilter != null)
            _FilterChip(
              label: taskTypeLabel(context, state.typeFilter!),
              onRemove: () => notifier.setFilters(clearType: true),
            ),
          if (state.statusFilter != null)
            _FilterChip(
              label: taskStatusLabel(context, state.statusFilter!),
              onRemove: () => notifier.setFilters(clearStatus: true),
            ),
          if (state.priorityFilter != null)
            _FilterChip(
              label: taskPriorityLabel(context, state.priorityFilter!),
              onRemove: () => notifier.setFilters(clearPriority: true),
            ),
          if (state.overdueOnly)
            _FilterChip(
              label: context.l10n.tasksOverdueChip,
              onRemove: () => notifier.setFilters(overdueOnly: false),
            ),
          if (state.todayOnly)
            _FilterChip(
              label: context.l10n.tasksTodayChip,
              onRemove: () => notifier.setFilters(todayOnly: false),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _FilterChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text(label),
      onDeleted: onRemove,
      deleteIcon: const Icon(Icons.close, size: 16),
    );
  }
}

class _FiltersSheet extends ConsumerStatefulWidget {
  const _FiltersSheet();

  @override
  ConsumerState<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends ConsumerState<_FiltersSheet> {
  late TaskType? _type;
  late TaskStatus? _status;
  late TaskPriority? _priority;
  late bool _overdueOnly;
  late bool _todayOnly;

  @override
  void initState() {
    super.initState();
    final state = ref.read(tasksListProvider);
    _type = state.typeFilter;
    _status = state.statusFilter;
    _priority = state.priorityFilter;
    _overdueOnly = state.overdueOnly;
    _todayOnly = state.todayOnly;
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
            DropdownButtonFormField<TaskType>(
              initialValue: _type,
              decoration:
                  InputDecoration(labelText: context.l10n.tasksFilterType),
              items: [
                for (final type in TaskType.values)
                  DropdownMenuItem(
                    value: type,
                    child: Text(taskTypeLabel(context, type)),
                  ),
              ],
              onChanged: (v) => setState(() => _type = v),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<TaskStatus>(
              initialValue: _status,
              decoration:
                  InputDecoration(labelText: context.l10n.tasksFilterStatus),
              items: [
                for (final status in TaskStatus.values)
                  DropdownMenuItem(
                    value: status,
                    child: Text(taskStatusLabel(context, status)),
                  ),
              ],
              onChanged: (v) => setState(() => _status = v),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<TaskPriority>(
              initialValue: _priority,
              decoration:
                  InputDecoration(labelText: context.l10n.tasksFilterPriority),
              items: [
                for (final priority in TaskPriority.values)
                  DropdownMenuItem(
                    value: priority,
                    child: Text(taskPriorityLabel(context, priority)),
                  ),
              ],
              onChanged: (v) => setState(() => _priority = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.l10n.tasksFilterOverdueOnly),
              value: _overdueOnly,
              onChanged: (v) => setState(() => _overdueOnly = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.l10n.tasksFilterTodayOnly),
              value: _todayOnly,
              onChanged: (v) => setState(() => _todayOnly = v),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(tasksListProvider.notifier).clearFilters();
                      Navigator.pop(context);
                    },
                    child: Text(context.l10n.commonReset),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      ref.read(tasksListProvider.notifier).setFilters(
                            type: _type,
                            clearType: _type == null,
                            status: _status,
                            clearStatus: _status == null,
                            priority: _priority,
                            clearPriority: _priority == null,
                            overdueOnly: _overdueOnly,
                            todayOnly: _todayOnly,
                          );
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

class _TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onComplete;

  const _TaskCard({
    required this.task,
    required this.onTap,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final done = task.status == TaskStatus.completed;
    final overdue = !done && isOverdue(task.dueDate);
    final priorityColor = taskPriorityColor(context, task.priority);

    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: priorityColor.withValues(alpha: 0.12),
              borderRadius: AppRadius.smAll,
            ),
            child: Icon(taskTypeIcon(task.type), color: priorityColor, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: AppTypography.titleMd.copyWith(
                    color: done
                        ? context.colors.onSurfaceVariant
                        : context.colors.onSurface,
                    decoration: done ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Text(
                      taskTypeLabel(context, task.type),
                      style: AppTypography.labelSm
                          .copyWith(color: context.colors.onSurfaceVariant),
                    ),
                    Text(
                      '  ·  ',
                      style: AppTypography.labelSm
                          .copyWith(color: context.colors.onSurfaceVariant),
                    ),
                    // Приоритет назван словом, а не только цветом: цветную
                    // полоску отличит не каждый глаз.
                    Text(
                      taskPriorityLabel(context, task.priority),
                      style: AppTypography.labelSm.copyWith(
                        color: priorityColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(
                      overdue ? Icons.event_busy_outlined : Icons.event_outlined,
                      size: 14,
                      color: overdue
                          ? AppColors.error
                          : context.colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      humanDueDate(context, task.dueDate),
                      style: AppTypography.labelSm.copyWith(
                        color: overdue
                            ? AppColors.error
                            : context.colors.onSurfaceVariant,
                        fontWeight: overdue ? FontWeight.w600 : null,
                      ),
                    ),
                  ],
                ),
                if (task.description?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    task.description!.trim(),
                    style: AppTypography.bodyMd
                        .copyWith(color: context.colors.onSurfaceVariant),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (done)
            const Padding(
              padding: EdgeInsets.only(left: AppSpacing.sm),
              child: Icon(Icons.check_circle, color: AppColors.success),
            )
          else
            IconButton(
              tooltip: context.l10n.tasksComplete,
              icon: const Icon(Icons.check_circle_outline),
              onPressed: onComplete,
            ),
        ],
      ),
    );
  }
}
