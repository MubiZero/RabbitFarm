// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
  id: const IntConverter().fromJson(json['id']),
  title: json['title'] as String,
  description: json['description'] as String?,
  type: $enumDecode(_$TaskTypeEnumMap, json['type']),
  status: $enumDecode(_$TaskStatusEnumMap, json['status']),
  priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
  dueDate: DateTime.parse(json['due_date'] as String),
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  rabbitId: const IntConverter().fromJson(json['rabbit_id']),
  cageId: const IntConverter().fromJson(json['cage_id']),
  assignedTo: const IntConverter().fromJson(json['assigned_to']),
  createdBy: const IntConverter().fromJson(json['created_by']),
  isRecurring: json['is_recurring'] as bool?,
  recurrenceRule: json['recurrence_rule'] as String?,
  reminderBefore: const IntConverter().fromJson(json['reminder_before']),
  notes: json['notes'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': const IntConverter().toJson(instance.id),
      'title': instance.title,
      'description': instance.description,
      'type': _$TaskTypeEnumMap[instance.type]!,
      'status': _$TaskStatusEnumMap[instance.status]!,
      'priority': _$TaskPriorityEnumMap[instance.priority]!,
      'due_date': instance.dueDate.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'rabbit_id': _$JsonConverterToJson<dynamic, int>(
        instance.rabbitId,
        const IntConverter().toJson,
      ),
      'cage_id': _$JsonConverterToJson<dynamic, int>(
        instance.cageId,
        const IntConverter().toJson,
      ),
      'assigned_to': _$JsonConverterToJson<dynamic, int>(
        instance.assignedTo,
        const IntConverter().toJson,
      ),
      'created_by': _$JsonConverterToJson<dynamic, int>(
        instance.createdBy,
        const IntConverter().toJson,
      ),
      'is_recurring': instance.isRecurring,
      'recurrence_rule': instance.recurrenceRule,
      'reminder_before': _$JsonConverterToJson<dynamic, int>(
        instance.reminderBefore,
        const IntConverter().toJson,
      ),
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$TaskTypeEnumMap = {
  TaskType.feeding: 'feeding',
  TaskType.cleaning: 'cleaning',
  TaskType.vaccination: 'vaccination',
  TaskType.checkup: 'checkup',
  TaskType.breeding: 'breeding',
  TaskType.other: 'other',
};

const _$TaskStatusEnumMap = {
  TaskStatus.pending: 'pending',
  TaskStatus.inProgress: 'in_progress',
  TaskStatus.completed: 'completed',
  TaskStatus.cancelled: 'cancelled',
};

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'low',
  TaskPriority.medium: 'medium',
  TaskPriority.high: 'high',
  TaskPriority.urgent: 'urgent',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_$TaskCreateImpl _$$TaskCreateImplFromJson(Map<String, dynamic> json) =>
    _$TaskCreateImpl(
      title: json['title'] as String,
      description: json['description'] as String?,
      type: $enumDecode(_$TaskTypeEnumMap, json['type']),
      status: $enumDecodeNullable(_$TaskStatusEnumMap, json['status']),
      priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']),
      dueDate: DateTime.parse(json['due_date'] as String),
      rabbitId: (json['rabbit_id'] as num?)?.toInt(),
      cageId: (json['cage_id'] as num?)?.toInt(),
      assignedTo: (json['assigned_to'] as num?)?.toInt(),
      isRecurring: json['is_recurring'] as bool?,
      recurrenceRule: json['recurrence_rule'] as String?,
      reminderBefore: (json['reminder_before'] as num?)?.toInt(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$TaskCreateImplToJson(_$TaskCreateImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'type': _$TaskTypeEnumMap[instance.type]!,
      'status': _$TaskStatusEnumMap[instance.status],
      'priority': _$TaskPriorityEnumMap[instance.priority],
      'due_date': instance.dueDate.toIso8601String(),
      'rabbit_id': instance.rabbitId,
      'cage_id': instance.cageId,
      'assigned_to': instance.assignedTo,
      'is_recurring': instance.isRecurring,
      'recurrence_rule': instance.recurrenceRule,
      'reminder_before': instance.reminderBefore,
      'notes': instance.notes,
    };

_$TaskUpdateImpl _$$TaskUpdateImplFromJson(Map<String, dynamic> json) =>
    _$TaskUpdateImpl(
      title: json['title'] as String?,
      description: json['description'] as String?,
      type: $enumDecodeNullable(_$TaskTypeEnumMap, json['type']),
      status: $enumDecodeNullable(_$TaskStatusEnumMap, json['status']),
      priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']),
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      rabbitId: (json['rabbit_id'] as num?)?.toInt(),
      cageId: (json['cage_id'] as num?)?.toInt(),
      assignedTo: (json['assigned_to'] as num?)?.toInt(),
      isRecurring: json['is_recurring'] as bool?,
      recurrenceRule: json['recurrence_rule'] as String?,
      reminderBefore: (json['reminder_before'] as num?)?.toInt(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$TaskUpdateImplToJson(_$TaskUpdateImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'type': _$TaskTypeEnumMap[instance.type],
      'status': _$TaskStatusEnumMap[instance.status],
      'priority': _$TaskPriorityEnumMap[instance.priority],
      'due_date': instance.dueDate?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'rabbit_id': instance.rabbitId,
      'cage_id': instance.cageId,
      'assigned_to': instance.assignedTo,
      'is_recurring': instance.isRecurring,
      'recurrence_rule': instance.recurrenceRule,
      'reminder_before': instance.reminderBefore,
      'notes': instance.notes,
    };

_$TaskStatisticsImpl _$$TaskStatisticsImplFromJson(Map<String, dynamic> json) =>
    _$TaskStatisticsImpl(
      totalPending: const IntConverter().fromJson(json['total_pending']),
      totalInProgress: const IntConverter().fromJson(json['total_in_progress']),
      totalCompleted: const IntConverter().fromJson(json['total_completed']),
      totalCancelled: const IntConverter().fromJson(json['total_cancelled']),
      overdueCount: const IntConverter().fromJson(json['overdue_count']),
      todayCount: const IntConverter().fromJson(json['today_count']),
      tasksByType: (json['tasks_by_type'] as List<dynamic>)
          .map((e) => TaskTypeCount.fromJson(e as Map<String, dynamic>))
          .toList(),
      tasksByPriority: (json['tasks_by_priority'] as List<dynamic>)
          .map((e) => TaskPriorityCount.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TaskStatisticsImplToJson(
  _$TaskStatisticsImpl instance,
) => <String, dynamic>{
  'total_pending': const IntConverter().toJson(instance.totalPending),
  'total_in_progress': const IntConverter().toJson(instance.totalInProgress),
  'total_completed': const IntConverter().toJson(instance.totalCompleted),
  'total_cancelled': const IntConverter().toJson(instance.totalCancelled),
  'overdue_count': const IntConverter().toJson(instance.overdueCount),
  'today_count': const IntConverter().toJson(instance.todayCount),
  'tasks_by_type': instance.tasksByType,
  'tasks_by_priority': instance.tasksByPriority,
};

_$TaskTypeCountImpl _$$TaskTypeCountImplFromJson(Map<String, dynamic> json) =>
    _$TaskTypeCountImpl(
      type: $enumDecode(_$TaskTypeEnumMap, json['type']),
      count: const IntConverter().fromJson(json['count']),
    );

Map<String, dynamic> _$$TaskTypeCountImplToJson(_$TaskTypeCountImpl instance) =>
    <String, dynamic>{
      'type': _$TaskTypeEnumMap[instance.type]!,
      'count': const IntConverter().toJson(instance.count),
    };

_$TaskPriorityCountImpl _$$TaskPriorityCountImplFromJson(
  Map<String, dynamic> json,
) => _$TaskPriorityCountImpl(
  priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
  count: const IntConverter().fromJson(json['count']),
);

Map<String, dynamic> _$$TaskPriorityCountImplToJson(
  _$TaskPriorityCountImpl instance,
) => <String, dynamic>{
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
  'count': const IntConverter().toJson(instance.count),
};
