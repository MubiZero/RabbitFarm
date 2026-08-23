import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../data/models/task_model.dart';

/// Подписи, цвета и значки задач.
///
/// В экране списка два одинаковых switch-а по типу задачи стояли рядом друг с
/// другом — `_taskTypeToString` для фильтров и `_getTypeLabel` для карточки.
/// Достаточно поправить один и забыть про второй, чтобы фильтр и карточка
/// начали называть одно и то же по-разному.
String taskTypeLabel(BuildContext context, TaskType type) => switch (type) {
      TaskType.feeding => context.l10n.taskTypeFeeding,
      TaskType.cleaning => context.l10n.taskTypeCleaning,
      TaskType.vaccination => context.l10n.taskTypeVaccination,
      TaskType.checkup => context.l10n.taskTypeCheckup,
      TaskType.breeding => context.l10n.taskTypeBreeding,
      TaskType.other => context.l10n.taskTypeOther,
    };

String taskStatusLabel(BuildContext context, TaskStatus status) =>
    switch (status) {
      TaskStatus.pending => context.l10n.taskStatusPending,
      TaskStatus.inProgress => context.l10n.taskStatusInProgress,
      TaskStatus.completed => context.l10n.taskStatusCompleted,
      TaskStatus.cancelled => context.l10n.taskStatusCancelled,
    };

String taskPriorityLabel(BuildContext context, TaskPriority priority) =>
    switch (priority) {
      TaskPriority.low => context.l10n.taskPriorityLow,
      TaskPriority.medium => context.l10n.taskPriorityMedium,
      TaskPriority.high => context.l10n.taskPriorityHigh,
      TaskPriority.urgent => context.l10n.taskPriorityUrgent,
    };

/// Цвет приоритета. Один цвет ничего не значит без подписи рядом: примерно
/// каждый двенадцатый мужчина не отличит красную полоску от оранжевой, а на
/// ферме таких пользователей большинство.
Color taskPriorityColor(BuildContext context, TaskPriority priority) =>
    switch (priority) {
      TaskPriority.urgent => AppColors.error,
      TaskPriority.high => AppColors.warning,
      TaskPriority.medium => AppColors.info,
      TaskPriority.low => context.colors.onSurfaceVariant,
    };

IconData taskTypeIcon(TaskType type) => switch (type) {
      TaskType.feeding => Icons.restaurant_outlined,
      TaskType.cleaning => Icons.cleaning_services_outlined,
      TaskType.vaccination => Icons.vaccines_outlined,
      TaskType.checkup => Icons.monitor_heart_outlined,
      TaskType.breeding => Icons.favorite_outline,
      TaskType.other => Icons.label_outline,
    };
