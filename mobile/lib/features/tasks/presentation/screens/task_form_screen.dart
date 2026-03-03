import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/task_model.dart';
import '../providers/tasks_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_date_field.dart';
import '../../../../core/widgets/app_form_section.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _notesController;

  TaskType _type = TaskType.other;
  TaskStatus _status = TaskStatus.pending;
  TaskPriority _priority = TaskPriority.medium;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  int? _rabbitId;
  int? _cageId;
  bool _isRecurring = false;
  String? _recurrenceRule;
  int? _reminderBefore;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title);
    _descriptionController = TextEditingController(text: widget.task?.description);
    _notesController = TextEditingController(text: widget.task?.notes);

    if (widget.task != null) {
      _type = widget.task!.type;
      _status = widget.task!.status;
      _priority = widget.task!.priority;
      _dueDate = widget.task!.dueDate;
      _rabbitId = widget.task!.rabbitId;
      _cageId = widget.task!.cageId;
      _isRecurring = widget.task!.isRecurring ?? false;
      _recurrenceRule = widget.task!.recurrenceRule;
      _reminderBefore = widget.task!.reminderBefore;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Новая задача' : 'Редактировать задачу'),
        actions: [
          if (widget.task != null)
            IconButton(
              icon: const Icon(Icons.delete),
              color: AppColors.error,
              onPressed: _deleteTask,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            AppFormSection(
              title: 'Основное',
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Название *',
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите название';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Описание',
                    prefixIcon: Icon(Icons.notes),
                  ),
                  maxLines: 3,
                ),
                AppDateField(
                  label: 'Срок выполнения *',
                  value: _dueDate,
                  onChanged: (date) => setState(() => _dueDate = date),
                  prefixIcon: Icons.calendar_today,
                  firstDate: DateTime.now(),
                  showTime: true,
                ),
              ],
            ),
            AppFormSection(
              title: 'Параметры',
              children: [
                DropdownButtonFormField<TaskType>(
                  value: _type,
                  decoration: const InputDecoration(
                    labelText: 'Тип *',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: TaskType.values
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(_taskTypeToString(type)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _type = value);
                  },
                ),
                DropdownButtonFormField<TaskStatus>(
                  value: _status,
                  decoration: const InputDecoration(
                    labelText: 'Статус *',
                    prefixIcon: Icon(Icons.flag_outlined),
                  ),
                  items: TaskStatus.values
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(_taskStatusToString(status)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _status = value);
                  },
                ),
                DropdownButtonFormField<TaskPriority>(
                  value: _priority,
                  decoration: const InputDecoration(
                    labelText: 'Приоритет *',
                    prefixIcon: Icon(Icons.priority_high),
                  ),
                  items: TaskPriority.values
                      .map((priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(_taskPriorityToString(priority)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _priority = value);
                  },
                ),
                SwitchListTile(
                  title: const Text('Повторяющаяся задача'),
                  value: _isRecurring,
                  onChanged: (value) => setState(() => _isRecurring = value),
                ),
              ],
            ),
            AppFormSection(
              title: 'Заметки',
              children: [
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Примечания',
                    prefixIcon: Icon(Icons.note_outlined),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveTask,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.task == null ? 'Создать' : 'Сохранить'),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final taskActions = ref.read(taskActionsProvider);

      if (widget.task == null) {
        final taskCreate = TaskCreate(
          title: _titleController.text,
          description: _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
          type: _type,
          status: _status,
          priority: _priority,
          dueDate: _dueDate,
          rabbitId: _rabbitId,
          cageId: _cageId,
          isRecurring: _isRecurring,
          recurrenceRule: _recurrenceRule,
          reminderBefore: _reminderBefore,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );

        await taskActions.createTask(taskCreate);
      } else {
        final taskUpdate = TaskUpdate(
          title: _titleController.text,
          description: _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
          type: _type,
          status: _status,
          priority: _priority,
          dueDate: _dueDate,
          rabbitId: _rabbitId,
          cageId: _cageId,
          isRecurring: _isRecurring,
          recurrenceRule: _recurrenceRule,
          reminderBefore: _reminderBefore,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );

        await taskActions.updateTask(widget.task!.id, taskUpdate);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.task == null ? 'Задача создана' : 'Задача обновлена'),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteTask() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить задачу?'),
        content: const Text('Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(taskActionsProvider).deleteTask(widget.task!.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Задача удалена')),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
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
