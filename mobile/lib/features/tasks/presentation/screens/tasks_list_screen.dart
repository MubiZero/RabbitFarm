import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/task_model.dart';
import '../providers/tasks_provider.dart';

class TasksListScreen extends ConsumerStatefulWidget {
  const TasksListScreen({super.key});

  @override
  ConsumerState<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends ConsumerState<TasksListScreen> {
  TaskType? _selectedType;
  TaskStatus? _selectedStatus;
  TaskPriority? _selectedPriority;
  bool _overdueOnly = false;
  bool _todayOnly = false;
  int _currentPage = 1;

  TasksQueryParams get _queryParams => TasksQueryParams(
        page: _currentPage,
        limit: 20,
        type: _selectedType,
        status: _selectedStatus,
        priority: _selectedPriority,
        overdueOnly: _overdueOnly ? true : null,
        todayOnly: _todayOnly ? true : null,
        sortBy: 'due_date',
        sortOrder: 'ASC',
      );

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksProvider(_queryParams));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Задачи'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/tasks/form'),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_hasActiveFilters()) _buildActiveFiltersChips(),
          Expanded(
            child: tasksAsync.when(
              data: (data) {
                final tasks = data['tasks'] as List<Task>;
                final pagination = data['pagination'] as Map<String, dynamic>;

                if (tasks.isEmpty) {
                  return const Center(
                    child: Text('Задачи не найдены'),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          ref.invalidate(tasksProvider(_queryParams));
                        },
                        child: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            return _TaskCard(
                              task: tasks[index],
                              onTap: () {
                                // Navigate to task details or edit
                                context.push('/tasks/form', extra: tasks[index]);
                              },
                              onComplete: () async {
                                await ref
                                    .read(taskActionsProvider)
                                    .completeTask(tasks[index].id);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    _buildPagination(pagination),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Ошибка: $error'),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(tasksProvider(_queryParams));
                      },
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasActiveFilters() {
    return _selectedType != null ||
        _selectedStatus != null ||
        _selectedPriority != null ||
        _overdueOnly ||
        _todayOnly;
  }

  Widget _buildActiveFiltersChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: [
          if (_selectedType != null)
            Chip(
              label: Text(_taskTypeToString(_selectedType!)),
              onDeleted: () => setState(() => _selectedType = null),
            ),
          if (_selectedStatus != null)
            Chip(
              label: Text(_taskStatusToString(_selectedStatus!)),
              onDeleted: () => setState(() => _selectedStatus = null),
            ),
          if (_selectedPriority != null)
            Chip(
              label: Text(_taskPriorityToString(_selectedPriority!)),
              onDeleted: () => setState(() => _selectedPriority = null),
            ),
          if (_overdueOnly)
            Chip(
              label: const Text('Просроченные'),
              onDeleted: () => setState(() => _overdueOnly = false),
            ),
          if (_todayOnly)
            Chip(
              label: const Text('Сегодня'),
              onDeleted: () => setState(() => _todayOnly = false),
            ),
        ],
      ),
    );
  }

  Widget _buildPagination(Map<String, dynamic> pagination) {
    final currentPage = pagination['page'] as int;
    final totalPages = pagination['pages'] as int;

    if (totalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: currentPage > 1
                ? () => setState(() => _currentPage = currentPage - 1)
                : null,
          ),
          Text('$currentPage / $totalPages'),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: currentPage < totalPages
                ? () => setState(() => _currentPage = currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }

  void _showFilters() {
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
                      setState(() {
                        _selectedType = null;
                        _selectedStatus = null;
                        _selectedPriority = null;
                        _overdueOnly = false;
                        _todayOnly = false;
                      });
                    },
                    child: const Text('Сбросить'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
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
