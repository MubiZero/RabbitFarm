/// Строка журнала фермы человеческим языком.
///
/// Сервер пишет машинные коды (`feeding_record.updated`) и сырые снимки полей
/// (`before`/`after`). Показывать их как есть значит оставить разбор человеку,
/// который пришёл с вопросом «кто исправил мою запись».
///
/// Незнакомое действие не скрывается и не ломает список: у него остаётся сам
/// код — сервер заводит новые действия раньше приложения.
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../data/models/staff_models.dart';


/// Что сделали — словами.
String auditActionText(BuildContext context, FarmAuditEntry entry) {
  final l10n = context.l10n;
  return switch (entry.action) {
    'staff.role_changed' => l10n.farmAuditActionRoleChanged,
    'staff.deactivated' => l10n.farmAuditActionDeactivated,
    'staff.activated' => l10n.farmAuditActionActivated,
    'staff.ownership_transferred' => l10n.farmAuditActionOwnership,
    _ when entry.action.endsWith('.updated') => l10n.farmAuditActionUpdated,
    _ when entry.action.endsWith('.deleted') => l10n.farmAuditActionDeleted,
    _ => l10n.farmAuditActionUnknown(entry.action),
  };
}

/// Какая это запись — кролик, клетка, кормление.
///
/// Слова берутся из заголовков тех самых форм, где эти записи и правят:
/// один и тот же предмет должен называться на всех экранах одинаково.
String? auditEntityName(BuildContext context, String? entityType) {
  final l10n = context.l10n;
  return switch (entityType) {
    'rabbit' => l10n.rabbitFormEditTitle,
    'cage' => l10n.cageFormEditTitle,
    'breed' => l10n.breedFormEditTitle,
    'feed' => l10n.feedFormEditTitle,
    'feeding_record' => l10n.feedingFormEditTitle,
    'medical_record' => l10n.medFormEditTitle,
    'vaccination' => l10n.vaccFormEditTitle,
    'task' => l10n.taskFormEditTitle,
    'note' => l10n.noteFormEditTitle,
    'transaction' => l10n.txFormEditTitle,
    'birth' => l10n.birthFormEditTitle,
    'breeding' => l10n.breedingFormEditTitle,
    _ => null,
  };
}

IconData auditActionIcon(FarmAuditEntry entry) {
  if (entry.isStaffAction) return Icons.people_outline;
  return entry.isUpdate ? Icons.edit_outlined : Icons.delete_outline;
}

/// Что именно изменилось — по строке на поле.
///
/// Показываются только поля, которым в приложении есть имя: подписи берутся
/// из форм, а не заводятся заново. Незнакомое поле пропускается молча —
/// строка «feed_id: 3 → 7» не сообщает человеку ничего, а сама запись в
/// журнале остаётся на месте.
///
/// Ссылочные поля (`cage_id`, `rabbit_id`) — особый случай: в снимке лежат
/// номера, за именами идти уже некуда, и честнее сказать «изменена клетка»,
/// чем показать «3 → 7».
List<String> auditChangeLines(BuildContext context, FarmAuditEntry entry) {
  final l10n = context.l10n;
  final after = entry.after;
  if (after == null || after.isEmpty) return const [];

  final before = entry.before ?? const {};
  final lines = <String>[];

  for (final field in after.keys) {
    final name = _fieldName(context, field);
    if (name == null) continue;

    if (field.endsWith('_id')) {
      lines.add(l10n.farmAuditChanged(name));
      continue;
    }

    lines.add(l10n.farmAuditChange(
      name,
      _value(context, before[field]),
      _value(context, after[field]),
    ));
  }

  return lines;
}

/// Имя поля. Берётся из подписей тех же форм, где это поле и заполняют.
String? _fieldName(BuildContext context, String field) {
  final l10n = context.l10n;
  return switch (field) {
    'quantity' => l10n.feedingFormQuantity,
    'fed_at' => l10n.feedingFormWhen,
    'feed_id' => l10n.feedingFormFeed,
    'cage_id' => l10n.rabbitCage,
    'notes' => l10n.rabbitNotes,
    'name' => l10n.rabbitFormName,
    'tag_id' => l10n.rabbitFormTag,
    'weight' => l10n.rabbitWeight,
    'status' => l10n.rabbitStatus,
    'sex' => l10n.rabbitSex,
    'birth_date' => l10n.rabbitBirthDate,
    'breed_id' => l10n.rabbitBreed,
    'diagnosis' => l10n.medDiagnosis,
    'treatment' => l10n.medTreatment,
    'medication' => l10n.medMedication,
    'veterinarian' => l10n.medVet,
    'outcome' => l10n.medFormOutcome,
    'started_at' => l10n.medStarted,
    'ended_at' => l10n.medFormEndedDate,
    'vaccination_date' => l10n.vaccFormDate,
    'amount' => l10n.txFormAmount,
    'description' => l10n.txFormDescription,
    'category' => l10n.financeCategory,
    'title' => l10n.taskFormTitleLabel,
    'due_date' => l10n.taskFormDueLabel,
    _ => null,
  };
}

final _dayFormat = DateFormat('dd.MM.yyyy');

/// Значение для показа: дата — днём, число — без хвоста из нулей.
String _value(BuildContext context, Object? raw) {
  if (raw == null) return context.l10n.farmAuditNoValue;

  final text = raw.toString().trim();
  if (text.isEmpty) return context.l10n.farmAuditNoValue;

  final date = DateTime.tryParse(text);
  if (date != null) return _dayFormat.format(date.toLocal());

  final number = num.tryParse(text);
  if (number != null) {
    return number == number.roundToDouble()
        ? number.toInt().toString()
        : number.toString();
  }

  return text;
}
