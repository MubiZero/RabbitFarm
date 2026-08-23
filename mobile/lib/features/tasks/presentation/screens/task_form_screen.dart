import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/task_model.dart';
import '../providers/tasks_provider.dart';
import '../utils/task_labels.dart';

/// Правило повторения задачи.
///
/// Значения совпадают с теми, что понимает сервер: он сам создаёт следующую
/// задачу, когда текущую отмечают выполненной. Раньше в форме стоял простой
/// переключатель «Повторяющаяся задача», который включал признак повтора, но
/// не задавал период, — сервер такую задачу не повторял, и переключатель
/// молча ничего не делал.
enum TaskRepeat {
  daily('daily'),
  weekly('weekly'),
  biweekly('biweekly'),
  monthly('monthly'),
  quarterly('quarterly'),
  yearly('yearly');

  final String value;
  const TaskRepeat(this.value);

  static TaskRepeat? fromValue(String? raw) {
    if (raw == null) return null;
    final lower = raw.toLowerCase();
    for (final r in TaskRepeat.values) {
      if (r.value == lower) return r;
    }
    return null;
  }

  String label(BuildContext context) => switch (this) {
        TaskRepeat.daily => context.l10n.repeatDaily,
        TaskRepeat.weekly => context.l10n.repeatWeekly,
        TaskRepeat.biweekly => context.l10n.repeatBiweekly,
        TaskRepeat.monthly => context.l10n.repeatMonthly,
        TaskRepeat.quarterly => context.l10n.repeatQuarterly,
        TaskRepeat.yearly => context.l10n.repeatYearly,
      };
}

class TaskFormScreen extends ConsumerStatefulWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _notes;

  late TaskType _type;
  late TaskStatus _status;
  late TaskPriority _priority;
  late DateTime _dueDate;
  TaskRepeat? _repeat;

  bool _touched = false;

  Task? get _task => widget.task;
  bool get _isEditing => _task != null;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: _task?.title);
    _description = TextEditingController(text: _task?.description);
    _notes = TextEditingController(text: _task?.notes);

    _type = _task?.type ?? TaskType.other;
    _status = _task?.status ?? TaskStatus.pending;
    _priority = _task?.priority ?? TaskPriority.medium;
    _dueDate = _task?.dueDate ?? DateTime.now().add(const Duration(days: 1));
    _repeat = TaskRepeat.fromValue(_task?.recurrenceRule);

    for (final c in [_title, _description, _notes]) {
      c.addListener(_markTouched);
    }
  }

  void _markTouched() {
    if (!_touched) _touched = true;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _notes.dispose();
    super.dispose();
  }

  String? _optional(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  Future<String?> _save() async {
    final actions = ref.read(taskActionsProvider);
    try {
      if (_isEditing) {
        await actions.updateTask(
          _task!.id,
          TaskUpdate(
            title: _title.text.trim(),
            description: _optional(_description),
            type: _type,
            status: _status,
            priority: _priority,
            dueDate: _dueDate,
            rabbitId: _task!.rabbitId,
            cageId: _task!.cageId,
            isRecurring: _repeat != null,
            recurrenceRule: _repeat?.value,
            reminderBefore: _task!.reminderBefore,
            notes: _optional(_notes),
          ),
        );
      } else {
        await actions.createTask(
          TaskCreate(
            title: _title.text.trim(),
            description: _optional(_description),
            type: _type,
            status: _status,
            priority: _priority,
            dueDate: _dueDate,
            isRecurring: _repeat != null,
            recurrenceRule: _repeat?.value,
            notes: _optional(_notes),
          ),
        );
      }
      return null;
    } catch (e) {
      return e.toString().replaceAll('Exception: ', '');
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.taskFormDeleteTitle),
        content: Text(context.l10n.taskFormDeleteBody),
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
    if (confirmed != true || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final done = context.l10n.taskFormDeleted;
    final failed = context.l10n.taskFormDeleteFailed;

    try {
      await ref.read(taskActionsProvider).deleteTask(_task!.id);
      messenger.showSnackBar(SnackBar(content: Text(done)));
      if (navigator.canPop()) navigator.pop();
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(failed), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canDelete = ref.watch(canProvider(FarmCapability.deleteRecords));

    return AppFormScaffold(
      title: _isEditing
          ? context.l10n.taskFormEditTitle
          : context.l10n.taskFormNewTitle,
      formKey: _formKey,
      submitLabel: _isEditing
          ? context.l10n.commonSave
          : context.l10n.taskFormCreate,
      successMessage: _isEditing
          ? context.l10n.taskFormUpdated
          : context.l10n.taskFormCreated,
      onSubmit: _save,
      isDirty: () => _touched,
      actions: [
        if (_isEditing && canDelete)
          IconButton(
            tooltip: context.l10n.commonDelete,
            icon: const Icon(Icons.delete_outline),
            color: AppColors.error,
            onPressed: _delete,
          ),
      ],
      children: [
        AppFormSection(
          title: context.l10n.taskFormSectionMain,
          children: [
            TextFormField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: context.l10n.taskFormTitleLabel,
                prefixIcon: const Icon(Icons.title),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? context.l10n.taskFormTitleEmpty
                  : null,
            ),
            TextFormField(
              controller: _description,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: context.l10n.taskFormDescriptionLabel,
                prefixIcon: const Icon(Icons.notes),
              ),
            ),
            AppDateField(
              label: context.l10n.taskFormDueLabel,
              value: _dueDate,
              onChanged: (date) => setState(() {
                _dueDate = date;
                _touched = true;
              }),
              prefixIcon: Icons.event_outlined,
              showTime: true,
            ),
          ],
        ),
        AppFormSection(
          title: context.l10n.taskFormSectionParams,
          children: [
            DropdownButtonFormField<TaskType>(
              initialValue: _type,
              decoration: InputDecoration(
                labelText: context.l10n.tasksFilterType,
                prefixIcon: Icon(taskTypeIcon(_type)),
              ),
              items: [
                for (final type in TaskType.values)
                  DropdownMenuItem(
                    value: type,
                    child: Text(taskTypeLabel(context, type)),
                  ),
              ],
              onChanged: (v) => setState(() {
                if (v != null) _type = v;
                _touched = true;
              }),
            ),
            DropdownButtonFormField<TaskPriority>(
              initialValue: _priority,
              decoration: InputDecoration(
                labelText: context.l10n.tasksFilterPriority,
                prefixIcon: const Icon(Icons.priority_high),
              ),
              items: [
                for (final priority in TaskPriority.values)
                  DropdownMenuItem(
                    value: priority,
                    child: Text(taskPriorityLabel(context, priority)),
                  ),
              ],
              onChanged: (v) => setState(() {
                if (v != null) _priority = v;
                _touched = true;
              }),
            ),
            if (_isEditing)
              DropdownButtonFormField<TaskStatus>(
                initialValue: _status,
                decoration: InputDecoration(
                  labelText: context.l10n.tasksFilterStatus,
                  prefixIcon: const Icon(Icons.flag_outlined),
                ),
                items: [
                  for (final status in TaskStatus.values)
                    DropdownMenuItem(
                      value: status,
                      child: Text(taskStatusLabel(context, status)),
                    ),
                ],
                onChanged: (v) => setState(() {
                  if (v != null) _status = v;
                  _touched = true;
                }),
              ),
            DropdownButtonFormField<TaskRepeat?>(
              initialValue: _repeat,
              decoration: InputDecoration(
                labelText: context.l10n.taskFormRepeat,
                prefixIcon: const Icon(Icons.repeat),
                helperText: context.l10n.taskFormRepeatHelp,
                helperMaxLines: 2,
              ),
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(context.l10n.taskFormRepeatNever),
                ),
                for (final repeat in TaskRepeat.values)
                  DropdownMenuItem(
                    value: repeat,
                    child: Text(repeat.label(context)),
                  ),
              ],
              onChanged: (v) => setState(() {
                _repeat = v;
                _touched = true;
              }),
            ),
          ],
        ),
        AppFormSection(
          title: context.l10n.taskFormSectionNotes,
          children: [
            TextFormField(
              controller: _notes,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: context.l10n.taskFormNotesLabel,
                prefixIcon: const Icon(Icons.sticky_note_2_outlined),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
