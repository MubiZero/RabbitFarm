import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../rabbits/data/models/rabbit_model.dart';
import '../../../cages/data/models/cage_model.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

/// Task Type enum
enum TaskType {
  @JsonValue('feeding')
  feeding,
  @JsonValue('cleaning')
  cleaning,
  @JsonValue('vaccination')
  vaccination,
  @JsonValue('checkup')
  checkup,
  @JsonValue('breeding')
  breeding,
  @JsonValue('other')
  other,
}

/// Task Status enum
enum TaskStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

/// Task Priority enum
enum TaskPriority {
  @JsonValue('low')
  low,
  @JsonValue('medium')
  medium,
  @JsonValue('high')
  high,
  @JsonValue('urgent')
  urgent,
}

/// Custom converter for int values
class IntConverter implements JsonConverter<int, dynamic> {
  const IntConverter();

  @override
  int fromJson(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    throw ArgumentError('Cannot convert $value to int');
  }

  @override
  int toJson(int value) => value;
}

/// Custom converter for nullable int values
class NullableIntConverter implements JsonConverter<int?, dynamic> {
  const NullableIntConverter();

  @override
  int? fromJson(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      if (value.isEmpty) return null;
      return int.parse(value);
    }
    return null;
  }

  @override
  dynamic toJson(int? value) => value;
}

/// Task model
@freezed
class Task with _$Task {
  const factory Task({
    @IntConverter() required int id,
    required String title,
    String? description,
    required TaskType type,
    required TaskStatus status,
    required TaskPriority priority,
    @JsonKey(name: 'due_date') required DateTime dueDate,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() int? rabbitId,
    @JsonKey(name: 'cage_id') @NullableIntConverter() int? cageId,
    @JsonKey(name: 'assigned_to') @NullableIntConverter() int? assignedTo,
    @JsonKey(name: 'created_by') @NullableIntConverter() int? createdBy,
    @JsonKey(name: 'is_recurring') bool? isRecurring,
    @JsonKey(name: 'recurrence_rule') String? recurrenceRule,
    @JsonKey(name: 'reminder_before') @NullableIntConverter() int? reminderBefore,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    // Relationships
    @JsonKey(includeFromJson: false, includeToJson: false) RabbitModel? rabbit,
    @JsonKey(includeFromJson: false, includeToJson: false) CageModel? cage,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}

/// Task create model
@freezed
class TaskCreate with _$TaskCreate {
  const factory TaskCreate({
    required String title,
    String? description,
    required TaskType type,
    TaskStatus? status,
    TaskPriority? priority,
    @JsonKey(name: 'due_date') required DateTime dueDate,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() int? rabbitId,
    @JsonKey(name: 'cage_id') @NullableIntConverter() int? cageId,
    @JsonKey(name: 'assigned_to') @NullableIntConverter() int? assignedTo,
    @JsonKey(name: 'is_recurring') bool? isRecurring,
    @JsonKey(name: 'recurrence_rule') String? recurrenceRule,
    @JsonKey(name: 'reminder_before') @NullableIntConverter() int? reminderBefore,
    String? notes,
  }) = _TaskCreate;

  factory TaskCreate.fromJson(Map<String, dynamic> json) =>
      _$TaskCreateFromJson(json);
}

/// Task update model
@freezed
class TaskUpdate with _$TaskUpdate {
  const factory TaskUpdate({
    String? title,
    String? description,
    TaskType? type,
    TaskStatus? status,
    TaskPriority? priority,
    @JsonKey(name: 'due_date') DateTime? dueDate,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() int? rabbitId,
    @JsonKey(name: 'cage_id') @NullableIntConverter() int? cageId,
    @JsonKey(name: 'assigned_to') @NullableIntConverter() int? assignedTo,
    @JsonKey(name: 'is_recurring') bool? isRecurring,
    @JsonKey(name: 'recurrence_rule') String? recurrenceRule,
    @JsonKey(name: 'reminder_before') @NullableIntConverter() int? reminderBefore,
    String? notes,
  }) = _TaskUpdate;

  factory TaskUpdate.fromJson(Map<String, dynamic> json) =>
      _$TaskUpdateFromJson(json);
}

/// Task statistics model
@freezed
class TaskStatistics with _$TaskStatistics {
  const factory TaskStatistics({
    @JsonKey(name: 'total_pending') @IntConverter() required int totalPending,
    @JsonKey(name: 'total_in_progress') @IntConverter() required int totalInProgress,
    @JsonKey(name: 'total_completed') @IntConverter() required int totalCompleted,
    @JsonKey(name: 'total_cancelled') @IntConverter() required int totalCancelled,
    @JsonKey(name: 'overdue_count') @IntConverter() required int overdueCount,
    @JsonKey(name: 'today_count') @IntConverter() required int todayCount,
    @JsonKey(name: 'tasks_by_type') required List<TaskTypeCount> tasksByType,
    @JsonKey(name: 'tasks_by_priority') required List<TaskPriorityCount> tasksByPriority,
  }) = _TaskStatistics;

  factory TaskStatistics.fromJson(Map<String, dynamic> json) =>
      _$TaskStatisticsFromJson(json);
}

/// Task type count model
@freezed
class TaskTypeCount with _$TaskTypeCount {
  const factory TaskTypeCount({
    required TaskType type,
    @IntConverter() required int count,
  }) = _TaskTypeCount;

  factory TaskTypeCount.fromJson(Map<String, dynamic> json) =>
      _$TaskTypeCountFromJson(json);
}

/// Task priority count model
@freezed
class TaskPriorityCount with _$TaskPriorityCount {
  const factory TaskPriorityCount({
    required TaskPriority priority,
    @IntConverter() required int count,
  }) = _TaskPriorityCount;

  factory TaskPriorityCount.fromJson(Map<String, dynamic> json) =>
      _$TaskPriorityCountFromJson(json);
}
