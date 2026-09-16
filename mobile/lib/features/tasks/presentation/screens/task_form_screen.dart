import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/access/farm_access.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../staff/data/models/staff_models.dart';
import '../../../staff/presentation/providers/staff_provider.dart';
import '../../data/models/task_model.dart';
import '../providers/tasks_provider.dart';
import '../utils/task_labels.dart';
import '../../../../core/l10n/error_text.dart';

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

/// За сколько предупредить о сроке.
///
/// Набор фиксированный, как в календарях: произвольное число минут человек
/// вводить не станет, а серверу нужно ровно оно (`reminder_before`).
///
/// Поле в базе было с самого начала, но выбрать значение было негде, и никто
/// его не читал: единственным сигналом оставалась утренняя сводка про уже
/// просроченное — то есть приложение сообщало, что срок пропущен, вместо
/// того чтобы помочь его не пропустить.
enum TaskReminder {
  quarterHour(15),
  hour(60),
  threeHours(180),
  day(1440),
  twoDays(2880);

  final int minutes;
  const TaskReminder(this.minutes);

  static TaskReminder? fromMinutes(int? minutes) {
    if (minutes == null) return null;
    for (final option in TaskReminder.values) {
      if (option.minutes == minutes) return option;
    }
    // Значение не из набора (например, заведённое раньше): напоминание
    // остаётся рабочим, просто в списке его нет — подменять его ближайшим
    // значило бы молча передвинуть срок.
    return null;
  }

  String label(BuildContext context) => switch (this) {
        TaskReminder.quarterHour => context.l10n.taskReminder15m,
        TaskReminder.hour => context.l10n.taskReminder1h,
        TaskReminder.threeHours => context.l10n.taskReminder3h,
        TaskReminder.day => context.l10n.taskReminder1d,
        TaskReminder.twoDays => context.l10n.taskReminder2d,
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
  TaskReminder? _reminder;
  int? _assignedTo;

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
    _reminder = TaskReminder.fromMinutes(_task?.reminderBefore);
    _assignedTo = _task?.assignedTo;

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
    final l10n = context.l10n;
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
            assignedTo: _assignedTo,
            isRecurring: _repeat != null,
            recurrenceRule: _repeat?.value,
            reminderBefore: _reminder?.minutes,
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
            assignedTo: _assignedTo,
            isRecurring: _repeat != null,
            recurrenceRule: _repeat?.value,
            reminderBefore: _reminder?.minutes,
            notes: _optional(_notes),
          ),
        );
      }
      return null;
    } catch (e) {
      return errorText(l10n, e);
    }
  }

  /// Удаление без вопроса «точно удалить?», но с окном на отмену: в перчатках
  /// диалог подтверждения ничего не защищает, а несколько секунд на отмену —
  /// защищают.
  Future<void> _delete() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final failed = context.l10n.taskFormDeleteFailed;
    // Действия и список забираем сразу: запрос уйдёт уже после того, как
    // экран закроется.
    final actions = ref.read(taskActionsProvider);
    final list = ref.read(tasksListProvider.notifier);
    final taskId = _task!.id;

    list.removeTask(taskId);

    var failedToDelete = false;
    // Окно отмены открываем, пока форма ещё на экране: `deleteWithUndo`
    // забирает всё нужное из контекста сразу, до первого ожидания. Саму форму
    // закрываем, не дожидаясь окна, — подсказка живёт выше экрана и переживёт
    // его закрытие.
    final pending = deleteWithUndo(
      context,
      message: context.l10n.taskFormDeleted,
      commit: () async {
        try {
          await actions.deleteTask(taskId);
        } catch (_) {
          failedToDelete = true;
        }
      },
      onUndo: list.refresh,
    );
    if (navigator.canPop()) navigator.pop();
    await pending;

    if (failedToDelete) {
      messenger.showSnackBar(
        SnackBar(content: Text(failed), backgroundColor: AppColors.error),
      );
      await list.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final canDelete = ref.watch(canProvider(FarmCapability.deleteDailyRecords));

    return AppFormScaffold(
      title: _isEditing
          ? context.l10n.taskFormEditTitle
          : context.l10n.taskFormNewTitle,
      formKey: _formKey,
      submitLabel:
          _isEditing ? context.l10n.commonSave : context.l10n.taskFormCreate,
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
              isExpanded: true,
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
              isExpanded: true,
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
                isExpanded: true,
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
            _AssigneeField(
              value: _assignedTo,
              // Имя из самой задачи: если исполнителя с фермы уже убрали,
              // список его не вернёт, а показать, на ком дело висит, надо.
              currentName: _task?.assignee?.fullName,
              onChanged: (v) => setState(() {
                _assignedTo = v;
                _touched = true;
              }),
            ),
            DropdownButtonFormField<TaskRepeat?>(
              isExpanded: true,
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
            DropdownButtonFormField<TaskReminder?>(
              isExpanded: true,
              initialValue: _reminder,
              decoration: InputDecoration(
                labelText: context.l10n.taskReminderLabel,
                prefixIcon: const Icon(Icons.notifications_active_outlined),
              ),
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(context.l10n.taskReminderNone),
                ),
                for (final reminder in TaskReminder.values)
                  DropdownMenuItem(
                    value: reminder,
                    child: Text(reminder.label(context)),
                  ),
              ],
              onChanged: (v) => setState(() {
                _reminder = v;
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

/// Кому поручено дело.
///
/// Показываем только тем, кто вправе видеть состав фермы: работнику сервер
/// список людей не отдаёт (`GET /staff` — manager и owner), и выпадающий
/// список у него всё равно остался бы пустым. Сам работник исполнителя себе
/// не выбирает — задачу ему поручают.
class _AssigneeField extends ConsumerWidget {
  final int? value;
  final String? currentName;
  final ValueChanged<int?> onChanged;

  const _AssigneeField({
    required this.value,
    required this.currentName,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(canProvider(FarmCapability.viewStaff))) {
      return const SizedBox.shrink();
    }

    final members = ref.watch(farmMembersProvider);

    return members.when(
      // Пока состав едет, поле стоит на месте и не прыгает: показываем его
      // недоступным с тем исполнителем, который уже записан.
      loading: () => _dropdown(context, const [], enabled: false),
      // Не приехал — прячем: выбор, который нечем наполнить, хуже отсутствия.
      error: (_, __) => const SizedBox.shrink(),
      data: (list) => _dropdown(
        context,
        [
          for (final m in list)
            if (m.isActive) m
        ],
      ),
    );
  }

  Widget _dropdown(
    BuildContext context,
    List<FarmMember> members, {
    bool enabled = true,
  }) {
    final known = members.any((m) => m.id == value);

    return DropdownButtonFormField<int?>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: context.l10n.taskFormAssignee,
        prefixIcon: const Icon(Icons.person_outline),
        helperText: context.l10n.taskFormAssigneeHelp,
        helperMaxLines: 2,
      ),
      items: [
        DropdownMenuItem(
          value: null,
          child: Text(context.l10n.taskFormAssigneeNobody),
        ),
        // Исполнитель, которого больше нет в составе: уволенный работник или
        // ещё не приехавший список. Без этого пункта Dropdown не нашёл бы
        // своего значения, а тихая подстановка «не назначен» стёрла бы
        // поручение при первом же сохранении формы.
        if (value != null && !known)
          DropdownMenuItem(
            value: value,
            child: Text(currentName ?? context.l10n.taskFormAssignee),
          ),
        for (final member in members)
          DropdownMenuItem(
            value: member.id,
            child: Text(
              member.fullName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: enabled ? onChanged : null,
    );
  }
}
