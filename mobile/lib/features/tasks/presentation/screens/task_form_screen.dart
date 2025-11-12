import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/task_model.dart';
import '../providers/tasks_provider.dart';

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
              onPressed: _deleteTask,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Название *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите название';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Описание',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<TaskType>(
              value: _type,
              decoration: const InputDecoration(
                labelText: 'Тип *',
                border: OutlineInputBorder(),
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
            const SizedBox(height: 16),

            DropdownButtonFormField<TaskStatus>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Статус *',
                border: OutlineInputBorder(),
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
            const SizedBox(height: 16),

            DropdownButtonFormField<TaskPriority>(
              value: _priority,
              decoration: const InputDecoration(
                labelText: 'Приоритет *',
                border: OutlineInputBorder(),
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
            const SizedBox(height: 16),

            ListTile(
              title: const Text('Срок выполнения *'),
              subtitle: Text(DateFormat('dd.MM.yyyy HH:mm').format(_dueDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDueDate,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(color: Colors.grey.shade400),
              ),
            ),
            const SizedBox(height: 16),

            SwitchListTile(
              title: const Text('Повторяющаяся задача'),
              value: _isRecurring,
              onChanged: (value) => setState(() => _isRecurring = value),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(color: Colors.grey.shade400),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Примечания',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _isLoading ? null : _saveTask,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.task == null ? 'Создать' : 'Сохранить'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDate),
      );

      if (time != null && mounted) {
        setState(() {
          _dueDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final taskActions = ref.read(taskActionsProvider);

      if (widget.task == null) {
        // Create
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
        // Update
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
            content: Text(widget.task == null
                ? 'Задача создана'
                : 'Задача обновлена'),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Colors.red,
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
              backgroundColor: Colors.red,
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
