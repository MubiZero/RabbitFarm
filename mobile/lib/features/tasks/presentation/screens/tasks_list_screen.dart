import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/task_model.dart';
import '../providers/tasks_provider.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';

class TasksListScreen extends ConsumerStatefulWidget {
  const TasksListScreen({super.key});

  @override
  ConsumerState<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends ConsumerState<TasksListScreen> {
  final _scrollController = ScrollController();

  // Local filter state for the modal bottom sheet
  TaskType? _selectedType;
  TaskStatus? _selectedStatus;
  TaskPriority? _selectedPriority;
  bool _overdueOnly = false;
  bool _todayOnly = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(tasksListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasksState = ref.watch(tasksListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Задачи'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(tasksListProvider.notifier).refresh();
        },
        child: Column(
          children: [
            if (_hasActiveFilters()) _buildActiveFiltersChips(),
            Expanded(
              child: _buildBody(tasksState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(TasksListState tasksState) {
    if (tasksState.isLoading && tasksState.tasks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (tasksState.error != null && tasksState.tasks.isEmpty) {
      return AppErrorState(
        message: tasksState.error!,
        onRetry: () => ref.read(tasksListProvider.notifier).refresh(),
      );
    }

    if (!tasksState.isLoading && tasksState.tasks.isEmpty) {
      return const AppEmptyState(
        icon: Icons.task_outlined,
        title: 'Задачи не найдены',
        subtitle: 'Попробуйте изменить фильтры',
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: tasksState.tasks.length + (tasksState.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= tasksState.tasks.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final task = tasksState.tasks[index];
        return _TaskCard(
          task: task,
          onTap: () {
            context.push('/tasks/form', extra: task);
          },
          onComplete: () async {
            await ref.read(taskActionsProvider).completeTask(task.id);
            ref.read(tasksListProvider.notifier).refresh();
          },
        );
      },
    );
  }

  bool _hasActiveFilters() {
    final state = ref.read(tasksListProvider);
    return state.typeFilter != null ||
        state.statusFilter != null ||
        state.priorityFilter != null ||
        state.overdueOnly ||
        state.todayOnly;
  }

  Widget _buildActiveFiltersChips() {
    final state = ref.watch(tasksListProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: [
          if (state.typeFilter != null)
            Chip(
              label: Text(_taskTypeToString(state.typeFilter!)),
              onDeleted: () {
                ref.read(tasksListProvider.notifier).setFilters(clearType: true);
                _selectedType = null;
              },
            ),
          if (state.statusFilter != null)
            Chip(
              label: Text(_taskStatusToString(state.statusFilter!)),
              onDeleted: () {
                ref.read(tasksListProvider.notifier).setFilters(clearStatus: true);
                _selectedStatus = null;
              },
            ),
          if (state.priorityFilter != null)
            Chip(
              label: Text(_taskPriorityToString(state.priorityFilter!)),
              onDeleted: () {
                ref.read(tasksListProvider.notifier).setFilters(clearPriority: true);
                _selectedPriority = null;
              },
            ),
          if (state.overdueOnly)
            Chip(
              label: const Text('Просроченные'),
              onDeleted: () {
                ref.read(tasksListProvider.notifier).setFilters(overdueOnly: false);
                _overdueOnly = false;
              },
            ),
          if (state.todayOnly)
            Chip(
              label: const Text('Сегодня'),
              onDeleted: () {
                ref.read(tasksListProvider.notifier).setFilters(todayOnly: false);
                _todayOnly = false;
              },
            ),
        ],
      ),
    );
  }

  void _showFilters() {
    // Sync local filter state from provider
    final currentState = ref.read(tasksListProvider);
    _selectedType = currentState.typeFilter;
    _selectedStatus = currentState.statusFilter;
    _selectedPriority = currentState.priorityFilter;
    _overdueOnly = currentState.overdueOnly;
    _todayOnly = currentState.todayOnly;

    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Фильтры',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskType>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Тип'),
                items: TaskType.values
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(_taskTypeToString(type)),
                        ))
                    .toList(),
                onChanged: (value) => setModalState(() => _selectedType = value),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<TaskStatus>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: 'Статус'),
                items: TaskStatus.values
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(_taskStatusToString(status)),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setModalState(() => _selectedStatus = value),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<TaskPriority>(
                value: _selectedPriority,
                decoration: const InputDecoration(labelText: 'Приоритет'),
                items: TaskPriority.values
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(_taskPriorityToString(priority)),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setModalState(() => _selectedPriority = value),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Только просроченные'),
                value: _overdueOnly,
                onChanged: (value) => setModalState(() => _overdueOnly = value),
              ),
              SwitchListTile(
                title: const Text('Только сегодня'),
                value: _todayOnly,
                onChanged: (value) => setModalState(() => _todayOnly = value),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      setModalState(() {
                        _selectedType = null;
                        _selectedStatus = null;
                        _selectedPriority = null;
                        _overdueOnly = false;
                        _todayOnly = false;
                      });
                      ref.read(tasksListProvider.notifier).clearFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('Сбросить'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(tasksListProvider.notifier).setFilters(
                        type: _selectedType,
                        clearType: _selectedType == null,
                        status: _selectedStatus,
                        clearStatus: _selectedStatus == null,
                        priority: _selectedPriority,
                        clearPriority: _selectedPriority == null,
                        overdueOnly: _overdueOnly,
                        todayOnly: _todayOnly,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Применить'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _taskTypeToString(TaskType type) {
    switch (type) {
      case TaskType.feeding:
        return 'Кормление';
      case TaskType.cleaning:
        return 'Уборка';
      case TaskType.vaccination:
        return 'Вакцинация';
      case TaskType.checkup:
        return 'Осмотр';
      case TaskType.breeding:
        return 'Разведение';
      case TaskType.other:
        return 'Другое';
    }
  }

  String _taskStatusToString(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'Ожидает';
      case TaskStatus.inProgress:
        return 'В процессе';
      case TaskStatus.completed:
        return 'Завершена';
      case TaskStatus.cancelled:
        return 'Отменена';
    }
  }

  String _taskPriorityToString(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Низкий';
      case TaskPriority.medium:
        return 'Средний';
      case TaskPriority.high:
        return 'Высокий';
      case TaskPriority.urgent:
        return 'Срочный';
    }
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
    final isOverdue = task.dueDate.isBefore(DateTime.now()) &&
        task.status != TaskStatus.completed;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: _buildPriorityIndicator(),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.status == TaskStatus.completed
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_getTypeLabel(task.type)),
            Text(
              'Срок: ${DateFormat('dd.MM.yyyy HH:mm').format(task.dueDate)}',
              style: TextStyle(
                color: isOverdue ? Colors.red : null,
                fontWeight: isOverdue ? FontWeight.bold : null,
              ),
            ),
            if (task.description != null && task.description!.isNotEmpty)
              Text(
                task.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: task.status == TaskStatus.completed
            ? const Icon(Icons.check_circle, color: Colors.green)
            : IconButton(
                icon: const Icon(Icons.check),
                onPressed: onComplete,
              ),
      ),
    );
  }

  Widget _buildPriorityIndicator() {
    Color color;
    switch (task.priority) {
      case TaskPriority.urgent:
        color = Colors.red;
        break;
      case TaskPriority.high:
        color = Colors.orange;
        break;
      case TaskPriority.medium:
        color = Colors.blue;
        break;
      case TaskPriority.low:
        color = Colors.grey;
        break;
    }

    return Container(
      width: 4,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  String _getTypeLabel(TaskType type) {
    switch (type) {
      case TaskType.feeding:
        return 'Кормление';
      case TaskType.cleaning:
        return 'Уборка';
      case TaskType.vaccination:
        return 'Вакцинация';
      case TaskType.checkup:
        return 'Осмотр';
      case TaskType.breeding:
        return 'Разведение';
      case TaskType.other:
        return 'Другое';
    }
  }
}
