import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/date_labels.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../staff/presentation/providers/staff_provider.dart';
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
      s.todayOnly ||
      s.assignedToFilter != null;

  Future<void> _complete(BuildContext context, WidgetRef ref, Task task) async {
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
          if (state.assignedToFilter != null)
            _FilterChip(
              label: _assigneeChipLabel(context, ref, state.assignedToFilter!),
              onRemove: () => notifier.setFilters(clearAssignedTo: true),
            ),
        ],
      ),
    );
  }
}

/// Кем подписан фильтр по исполнителю.
///
/// Свои задачи называются «мои», а не собственным именем: человек и так
/// знает, кто он. Чужое имя берётся из состава фермы, а если состав ещё не
/// приехал или работника уже убрали — остаётся общее слово, но фильтр при
/// этом виден и снимается.
String _assigneeChipLabel(BuildContext context, WidgetRef ref, int userId) {
  if (userId == ref.watch(currentUserIdProvider)) {
    return context.l10n.tasksAssigneeMineChip;
  }

  final name = ref
      .watch(farmMembersProvider)
      .value
      ?.where((m) => m.id == userId)
      .firstOrNull
      ?.fullName;

  return name ?? context.l10n.tasksFilterAssignee;
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
  late int? _assignedTo;

  @override
  void initState() {
    super.initState();
    final state = ref.read(tasksListProvider);
    _type = state.typeFilter;
    _status = state.statusFilter;
    _priority = state.priorityFilter;
    _overdueOnly = state.overdueOnly;
    _todayOnly = state.todayOnly;
    _assignedTo = state.assignedToFilter;
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
              isExpanded: true,
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
              isExpanded: true,
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
              isExpanded: true,
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
            const SizedBox(height: AppSpacing.md),
            _AssigneeFilterField(
              value: _assignedTo,
              onChanged: (v) => setState(() => _assignedTo = v),
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
                            assignedTo: _assignedTo,
                            clearAssignedTo: _assignedTo == null,
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

/// Выбор, чьи задачи показывать.
///
/// Работнику хватает «моих»: состава фермы он не видит, и подставлять ему
/// пустой список не за чем. Владельцу и управляющему список нужен целиком —
/// вопрос «что на Иване» они задают чаще, чем «что на мне».
class _AssigneeFilterField extends ConsumerWidget {
  final int? value;
  final ValueChanged<int?> onChanged;

  const _AssigneeFilterField({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final myId = ref.watch(currentUserIdProvider);
    final canSeeStaff = ref.watch(canProvider(FarmCapability.viewStaff));
    final members = canSeeStaff
        ? (ref.watch(farmMembersProvider).value ?? const [])
        : const [];

    return DropdownButtonFormField<int?>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: l10n.tasksFilterAssignee,
        prefixIcon: const Icon(Icons.person_outline),
      ),
      items: [
        DropdownMenuItem(value: null, child: Text(l10n.tasksFilterAssigneeAny)),
        if (myId != null)
          DropdownMenuItem(
            value: myId,
            child: Text(l10n.tasksFilterAssigneeMine),
          ),
        for (final member in members)
          if (member.isActive && member.id != myId)
            DropdownMenuItem(
              value: member.id,
              child: Text(member.fullName),
            ),
      ],
      onChanged: onChanged,
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

    final rabbit = task.rabbit;
    final cage = task.cage;
    final target = rabbit != null
        ? context.l10n.feedingForRabbit(rabbit.label)
        : cage != null
            ? context.l10n.feedingForCage(cage.number)
            : null;

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
            child:
                Icon(taskTypeIcon(task.type), color: priorityColor, size: 20),
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
                // К кому относится дело. Сервер присылает кролика и клетку
                // вместе с задачей, но модель их отбрасывала — и «Осмотр»
                // в списке не говорил, кого осматривать. Подписи те же, что
                // в журнале и кормлениях: строка читается одинаково везде.
                if (target != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    target,
                    style: AppTypography.bodyMd
                        .copyWith(color: context.colors.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(
                      overdue
                          ? Icons.event_busy_outlined
                          : Icons.event_outlined,
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
                // Чьё это дело. Сервер кладёт исполнителя в каждый ответ и
                // шлёт ему личный пуш, а список об этом молчал: на ферме с
                // работниками нельзя было понять, кому поручено.
                if (task.assignee != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 14,
                        color: context.colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          task.assignee!.fullName,
                          style: AppTypography.labelSm.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
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
