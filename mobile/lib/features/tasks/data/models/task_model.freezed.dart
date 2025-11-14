// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Task _$TaskFromJson(Map<String, dynamic> json) {
  return _Task.fromJson(json);
}

/// @nodoc
mixin _$Task {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  TaskType get type => throw _privateConstructorUsedError;
  TaskStatus get status => throw _privateConstructorUsedError;
  TaskPriority get priority => throw _privateConstructorUsedError;
  @JsonKey(name: 'due_date')
  DateTime get dueDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  int? get rabbitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'cage_id')
  @NullableIntConverter()
  int? get cageId => throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_to')
  @NullableIntConverter()
  int? get assignedTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  @NullableIntConverter()
  int? get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_recurring')
  bool? get isRecurring => throw _privateConstructorUsedError;
  @JsonKey(name: 'recurrence_rule')
  String? get recurrenceRule => throw _privateConstructorUsedError;
  @JsonKey(name: 'reminder_before')
  @NullableIntConverter()
  int? get reminderBefore => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError; // Relationships
  @JsonKey(includeFromJson: false, includeToJson: false)
  RabbitModel? get rabbit => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  CageModel? get cage => throw _privateConstructorUsedError;

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskCopyWith<Task> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) then) =
      _$TaskCopyWithImpl<$Res, Task>;
  @useResult
  $Res call({
    @IntConverter() int id,
    String title,
    String? description,
    TaskType type,
    TaskStatus status,
    TaskPriority priority,
    @JsonKey(name: 'due_date') DateTime dueDate,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() int? rabbitId,
    @JsonKey(name: 'cage_id') @NullableIntConverter() int? cageId,
    @JsonKey(name: 'assigned_to') @NullableIntConverter() int? assignedTo,
    @JsonKey(name: 'created_by') @NullableIntConverter() int? createdBy,
    @JsonKey(name: 'is_recurring') bool? isRecurring,
    @JsonKey(name: 'recurrence_rule') String? recurrenceRule,
    @JsonKey(name: 'reminder_before')
    @NullableIntConverter()
    int? reminderBefore,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false) RabbitModel? rabbit,
    @JsonKey(includeFromJson: false, includeToJson: false) CageModel? cage,
  });

  $RabbitModelCopyWith<$Res>? get rabbit;
  $CageModelCopyWith<$Res>? get cage;
}

/// @nodoc
class _$TaskCopyWithImpl<$Res, $Val extends Task>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? type = null,
    Object? status = null,
    Object? priority = null,
    Object? dueDate = null,
    Object? completedAt = freezed,
    Object? rabbitId = freezed,
    Object? cageId = freezed,
    Object? assignedTo = freezed,
    Object? createdBy = freezed,
    Object? isRecurring = freezed,
    Object? recurrenceRule = freezed,
    Object? reminderBefore = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? rabbit = freezed,
    Object? cage = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as TaskType,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TaskStatus,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as TaskPriority,
            dueDate: null == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            rabbitId: freezed == rabbitId
                ? _value.rabbitId
                : rabbitId // ignore: cast_nullable_to_non_nullable
                      as int?,
            cageId: freezed == cageId
                ? _value.cageId
                : cageId // ignore: cast_nullable_to_non_nullable
                      as int?,
            assignedTo: freezed == assignedTo
                ? _value.assignedTo
                : assignedTo // ignore: cast_nullable_to_non_nullable
                      as int?,
            createdBy: freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as int?,
            isRecurring: freezed == isRecurring
                ? _value.isRecurring
                : isRecurring // ignore: cast_nullable_to_non_nullable
                      as bool?,
            recurrenceRule: freezed == recurrenceRule
                ? _value.recurrenceRule
                : recurrenceRule // ignore: cast_nullable_to_non_nullable
                      as String?,
            reminderBefore: freezed == reminderBefore
                ? _value.reminderBefore
                : reminderBefore // ignore: cast_nullable_to_non_nullable
                      as int?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            rabbit: freezed == rabbit
                ? _value.rabbit
                : rabbit // ignore: cast_nullable_to_non_nullable
                      as RabbitModel?,
            cage: freezed == cage
                ? _value.cage
                : cage // ignore: cast_nullable_to_non_nullable
                      as CageModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RabbitModelCopyWith<$Res>? get rabbit {
    if (_value.rabbit == null) {
      return null;
    }

    return $RabbitModelCopyWith<$Res>(_value.rabbit!, (value) {
      return _then(_value.copyWith(rabbit: value) as $Val);
    });
  }

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CageModelCopyWith<$Res>? get cage {
    if (_value.cage == null) {
      return null;
    }

    return $CageModelCopyWith<$Res>(_value.cage!, (value) {
      return _then(_value.copyWith(cage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TaskImplCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$$TaskImplCopyWith(
    _$TaskImpl value,
    $Res Function(_$TaskImpl) then,
  ) = __$$TaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    String title,
    String? description,
    TaskType type,
    TaskStatus status,
    TaskPriority priority,
    @JsonKey(name: 'due_date') DateTime dueDate,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() int? rabbitId,
    @JsonKey(name: 'cage_id') @NullableIntConverter() int? cageId,
    @JsonKey(name: 'assigned_to') @NullableIntConverter() int? assignedTo,
    @JsonKey(name: 'created_by') @NullableIntConverter() int? createdBy,
    @JsonKey(name: 'is_recurring') bool? isRecurring,
    @JsonKey(name: 'recurrence_rule') String? recurrenceRule,
    @JsonKey(name: 'reminder_before')
    @NullableIntConverter()
    int? reminderBefore,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false) RabbitModel? rabbit,
    @JsonKey(includeFromJson: false, includeToJson: false) CageModel? cage,
  });

  @override
  $RabbitModelCopyWith<$Res>? get rabbit;
  @override
  $CageModelCopyWith<$Res>? get cage;
}

/// @nodoc
class __$$TaskImplCopyWithImpl<$Res>
    extends _$TaskCopyWithImpl<$Res, _$TaskImpl>
    implements _$$TaskImplCopyWith<$Res> {
  __$$TaskImplCopyWithImpl(_$TaskImpl _value, $Res Function(_$TaskImpl) _then)
    : super(_value, _then);

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? type = null,
    Object? status = null,
    Object? priority = null,
    Object? dueDate = null,
    Object? completedAt = freezed,
    Object? rabbitId = freezed,
    Object? cageId = freezed,
    Object? assignedTo = freezed,
    Object? createdBy = freezed,
    Object? isRecurring = freezed,
    Object? recurrenceRule = freezed,
    Object? reminderBefore = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? rabbit = freezed,
    Object? cage = freezed,
  }) {
    return _then(
      _$TaskImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as TaskType,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TaskStatus,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as TaskPriority,
        dueDate: null == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        rabbitId: freezed == rabbitId
            ? _value.rabbitId
            : rabbitId // ignore: cast_nullable_to_non_nullable
                  as int?,
        cageId: freezed == cageId
            ? _value.cageId
            : cageId // ignore: cast_nullable_to_non_nullable
                  as int?,
        assignedTo: freezed == assignedTo
            ? _value.assignedTo
            : assignedTo // ignore: cast_nullable_to_non_nullable
                  as int?,
        createdBy: freezed == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as int?,
        isRecurring: freezed == isRecurring
            ? _value.isRecurring
            : isRecurring // ignore: cast_nullable_to_non_nullable
                  as bool?,
        recurrenceRule: freezed == recurrenceRule
            ? _value.recurrenceRule
            : recurrenceRule // ignore: cast_nullable_to_non_nullable
                  as String?,
        reminderBefore: freezed == reminderBefore
            ? _value.reminderBefore
            : reminderBefore // ignore: cast_nullable_to_non_nullable
                  as int?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        rabbit: freezed == rabbit
            ? _value.rabbit
            : rabbit // ignore: cast_nullable_to_non_nullable
                  as RabbitModel?,
        cage: freezed == cage
            ? _value.cage
            : cage // ignore: cast_nullable_to_non_nullable
                  as CageModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskImpl implements _Task {
  const _$TaskImpl({
    @IntConverter() required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.status,
    required this.priority,
    @JsonKey(name: 'due_date') required this.dueDate,
    @JsonKey(name: 'completed_at') this.completedAt,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() this.rabbitId,
    @JsonKey(name: 'cage_id') @NullableIntConverter() this.cageId,
    @JsonKey(name: 'assigned_to') @NullableIntConverter() this.assignedTo,
    @JsonKey(name: 'created_by') @NullableIntConverter() this.createdBy,
    @JsonKey(name: 'is_recurring') this.isRecurring,
    @JsonKey(name: 'recurrence_rule') this.recurrenceRule,
    @JsonKey(name: 'reminder_before')
    @NullableIntConverter()
    this.reminderBefore,
    this.notes,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false) this.rabbit,
    @JsonKey(includeFromJson: false, includeToJson: false) this.cage,
  });

  factory _$TaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final TaskType type;
  @override
  final TaskStatus status;
  @override
  final TaskPriority priority;
  @override
  @JsonKey(name: 'due_date')
  final DateTime dueDate;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  @override
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  final int? rabbitId;
  @override
  @JsonKey(name: 'cage_id')
  @NullableIntConverter()
  final int? cageId;
  @override
  @JsonKey(name: 'assigned_to')
  @NullableIntConverter()
  final int? assignedTo;
  @override
  @JsonKey(name: 'created_by')
  @NullableIntConverter()
  final int? createdBy;
  @override
  @JsonKey(name: 'is_recurring')
  final bool? isRecurring;
  @override
  @JsonKey(name: 'recurrence_rule')
  final String? recurrenceRule;
  @override
  @JsonKey(name: 'reminder_before')
  @NullableIntConverter()
  final int? reminderBefore;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  // Relationships
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final RabbitModel? rabbit;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final CageModel? cage;

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, type: $type, status: $status, priority: $priority, dueDate: $dueDate, completedAt: $completedAt, rabbitId: $rabbitId, cageId: $cageId, assignedTo: $assignedTo, createdBy: $createdBy, isRecurring: $isRecurring, recurrenceRule: $recurrenceRule, reminderBefore: $reminderBefore, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, rabbit: $rabbit, cage: $cage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.rabbitId, rabbitId) ||
                other.rabbitId == rabbitId) &&
            (identical(other.cageId, cageId) || other.cageId == cageId) &&
            (identical(other.assignedTo, assignedTo) ||
                other.assignedTo == assignedTo) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring) &&
            (identical(other.recurrenceRule, recurrenceRule) ||
                other.recurrenceRule == recurrenceRule) &&
            (identical(other.reminderBefore, reminderBefore) ||
                other.reminderBefore == reminderBefore) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.rabbit, rabbit) || other.rabbit == rabbit) &&
            (identical(other.cage, cage) || other.cage == cage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    description,
    type,
    status,
    priority,
    dueDate,
    completedAt,
    rabbitId,
    cageId,
    assignedTo,
    createdBy,
    isRecurring,
    recurrenceRule,
    reminderBefore,
    notes,
    createdAt,
    updatedAt,
    rabbit,
    cage,
  ]);

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      __$$TaskImplCopyWithImpl<_$TaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskImplToJson(this);
  }
}

abstract class _Task implements Task {
  const factory _Task({
    @IntConverter() required final int id,
    required final String title,
    final String? description,
    required final TaskType type,
    required final TaskStatus status,
    required final TaskPriority priority,
    @JsonKey(name: 'due_date') required final DateTime dueDate,
    @JsonKey(name: 'completed_at') final DateTime? completedAt,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() final int? rabbitId,
    @JsonKey(name: 'cage_id') @NullableIntConverter() final int? cageId,
    @JsonKey(name: 'assigned_to') @NullableIntConverter() final int? assignedTo,
    @JsonKey(name: 'created_by') @NullableIntConverter() final int? createdBy,
    @JsonKey(name: 'is_recurring') final bool? isRecurring,
    @JsonKey(name: 'recurrence_rule') final String? recurrenceRule,
    @JsonKey(name: 'reminder_before')
    @NullableIntConverter()
    final int? reminderBefore,
    final String? notes,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final RabbitModel? rabbit,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final CageModel? cage,
  }) = _$TaskImpl;

  factory _Task.fromJson(Map<String, dynamic> json) = _$TaskImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  TaskType get type;
  @override
  TaskStatus get status;
  @override
  TaskPriority get priority;
  @override
  @JsonKey(name: 'due_date')
  DateTime get dueDate;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;
  @override
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  int? get rabbitId;
  @override
  @JsonKey(name: 'cage_id')
  @NullableIntConverter()
  int? get cageId;
  @override
  @JsonKey(name: 'assigned_to')
  @NullableIntConverter()
  int? get assignedTo;
  @override
  @JsonKey(name: 'created_by')
  @NullableIntConverter()
  int? get createdBy;
  @override
  @JsonKey(name: 'is_recurring')
  bool? get isRecurring;
  @override
  @JsonKey(name: 'recurrence_rule')
  String? get recurrenceRule;
  @override
  @JsonKey(name: 'reminder_before')
  @NullableIntConverter()
  int? get reminderBefore;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt; // Relationships
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  RabbitModel? get rabbit;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  CageModel? get cage;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskCreate _$TaskCreateFromJson(Map<String, dynamic> json) {
  return _TaskCreate.fromJson(json);
}

/// @nodoc
mixin _$TaskCreate {
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  TaskType get type => throw _privateConstructorUsedError;
  TaskStatus? get status => throw _privateConstructorUsedError;
  TaskPriority? get priority => throw _privateConstructorUsedError;
  @JsonKey(name: 'due_date')
  DateTime get dueDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  int? get rabbitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'cage_id')
  @NullableIntConverter()
  int? get cageId => throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_to')
  @NullableIntConverter()
  int? get assignedTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_recurring')
  bool? get isRecurring => throw _privateConstructorUsedError;
  @JsonKey(name: 'recurrence_rule')
  String? get recurrenceRule => throw _privateConstructorUsedError;
  @JsonKey(name: 'reminder_before')
  @NullableIntConverter()
  int? get reminderBefore => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this TaskCreate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskCreateCopyWith<TaskCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCreateCopyWith<$Res> {
  factory $TaskCreateCopyWith(
    TaskCreate value,
    $Res Function(TaskCreate) then,
  ) = _$TaskCreateCopyWithImpl<$Res, TaskCreate>;
  @useResult
  $Res call({
    String title,
    String? description,
    TaskType type,
    TaskStatus? status,
    TaskPriority? priority,
    @JsonKey(name: 'due_date') DateTime dueDate,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() int? rabbitId,
    @JsonKey(name: 'cage_id') @NullableIntConverter() int? cageId,
    @JsonKey(name: 'assigned_to') @NullableIntConverter() int? assignedTo,
    @JsonKey(name: 'is_recurring') bool? isRecurring,
    @JsonKey(name: 'recurrence_rule') String? recurrenceRule,
    @JsonKey(name: 'reminder_before')
    @NullableIntConverter()
    int? reminderBefore,
    String? notes,
  });
}

/// @nodoc
class _$TaskCreateCopyWithImpl<$Res, $Val extends TaskCreate>
    implements $TaskCreateCopyWith<$Res> {
  _$TaskCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? type = null,
    Object? status = freezed,
    Object? priority = freezed,
    Object? dueDate = null,
    Object? rabbitId = freezed,
    Object? cageId = freezed,
    Object? assignedTo = freezed,
    Object? isRecurring = freezed,
    Object? recurrenceRule = freezed,
    Object? reminderBefore = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as TaskType,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TaskStatus?,
            priority: freezed == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as TaskPriority?,
            dueDate: null == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            rabbitId: freezed == rabbitId
                ? _value.rabbitId
                : rabbitId // ignore: cast_nullable_to_non_nullable
                      as int?,
            cageId: freezed == cageId
                ? _value.cageId
                : cageId // ignore: cast_nullable_to_non_nullable
                      as int?,
            assignedTo: freezed == assignedTo
                ? _value.assignedTo
                : assignedTo // ignore: cast_nullable_to_non_nullable
                      as int?,
            isRecurring: freezed == isRecurring
                ? _value.isRecurring
                : isRecurring // ignore: cast_nullable_to_non_nullable
                      as bool?,
            recurrenceRule: freezed == recurrenceRule
                ? _value.recurrenceRule
                : recurrenceRule // ignore: cast_nullable_to_non_nullable
                      as String?,
            reminderBefore: freezed == reminderBefore
                ? _value.reminderBefore
                : reminderBefore // ignore: cast_nullable_to_non_nullable
                      as int?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskCreateImplCopyWith<$Res>
    implements $TaskCreateCopyWith<$Res> {
  factory _$$TaskCreateImplCopyWith(
    _$TaskCreateImpl value,
    $Res Function(_$TaskCreateImpl) then,
  ) = __$$TaskCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String title,
    String? description,
    TaskType type,
    TaskStatus? status,
    TaskPriority? priority,
    @JsonKey(name: 'due_date') DateTime dueDate,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() int? rabbitId,
    @JsonKey(name: 'cage_id') @NullableIntConverter() int? cageId,
    @JsonKey(name: 'assigned_to') @NullableIntConverter() int? assignedTo,
    @JsonKey(name: 'is_recurring') bool? isRecurring,
    @JsonKey(name: 'recurrence_rule') String? recurrenceRule,
    @JsonKey(name: 'reminder_before')
    @NullableIntConverter()
    int? reminderBefore,
    String? notes,
  });
}

/// @nodoc
class __$$TaskCreateImplCopyWithImpl<$Res>
    extends _$TaskCreateCopyWithImpl<$Res, _$TaskCreateImpl>
    implements _$$TaskCreateImplCopyWith<$Res> {
  __$$TaskCreateImplCopyWithImpl(
    _$TaskCreateImpl _value,
    $Res Function(_$TaskCreateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? type = null,
    Object? status = freezed,
    Object? priority = freezed,
    Object? dueDate = null,
    Object? rabbitId = freezed,
    Object? cageId = freezed,
    Object? assignedTo = freezed,
    Object? isRecurring = freezed,
    Object? recurrenceRule = freezed,
    Object? reminderBefore = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$TaskCreateImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as TaskType,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TaskStatus?,
        priority: freezed == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as TaskPriority?,
        dueDate: null == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        rabbitId: freezed == rabbitId
            ? _value.rabbitId
            : rabbitId // ignore: cast_nullable_to_non_nullable
                  as int?,
        cageId: freezed == cageId
            ? _value.cageId
            : cageId // ignore: cast_nullable_to_non_nullable
                  as int?,
        assignedTo: freezed == assignedTo
            ? _value.assignedTo
            : assignedTo // ignore: cast_nullable_to_non_nullable
                  as int?,
        isRecurring: freezed == isRecurring
            ? _value.isRecurring
            : isRecurring // ignore: cast_nullable_to_non_nullable
                  as bool?,
        recurrenceRule: freezed == recurrenceRule
            ? _value.recurrenceRule
            : recurrenceRule // ignore: cast_nullable_to_non_nullable
                  as String?,
        reminderBefore: freezed == reminderBefore
            ? _value.reminderBefore
            : reminderBefore // ignore: cast_nullable_to_non_nullable
                  as int?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskCreateImpl implements _TaskCreate {
  const _$TaskCreateImpl({
    required this.title,
    this.description,
    required this.type,
    this.status,
    this.priority,
    @JsonKey(name: 'due_date') required this.dueDate,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() this.rabbitId,
    @JsonKey(name: 'cage_id') @NullableIntConverter() this.cageId,
    @JsonKey(name: 'assigned_to') @NullableIntConverter() this.assignedTo,
    @JsonKey(name: 'is_recurring') this.isRecurring,
    @JsonKey(name: 'recurrence_rule') this.recurrenceRule,
    @JsonKey(name: 'reminder_before')
    @NullableIntConverter()
    this.reminderBefore,
    this.notes,
  });

  factory _$TaskCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskCreateImplFromJson(json);

  @override
  final String title;
  @override
  final String? description;
  @override
  final TaskType type;
  @override
  final TaskStatus? status;
  @override
  final TaskPriority? priority;
  @override
  @JsonKey(name: 'due_date')
  final DateTime dueDate;
  @override
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  final int? rabbitId;
  @override
  @JsonKey(name: 'cage_id')
  @NullableIntConverter()
  final int? cageId;
  @override
  @JsonKey(name: 'assigned_to')
  @NullableIntConverter()
  final int? assignedTo;
  @override
  @JsonKey(name: 'is_recurring')
  final bool? isRecurring;
  @override
  @JsonKey(name: 'recurrence_rule')
  final String? recurrenceRule;
  @override
  @JsonKey(name: 'reminder_before')
  @NullableIntConverter()
  final int? reminderBefore;
  @override
  final String? notes;

  @override
  String toString() {
    return 'TaskCreate(title: $title, description: $description, type: $type, status: $status, priority: $priority, dueDate: $dueDate, rabbitId: $rabbitId, cageId: $cageId, assignedTo: $assignedTo, isRecurring: $isRecurring, recurrenceRule: $recurrenceRule, reminderBefore: $reminderBefore, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskCreateImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.rabbitId, rabbitId) ||
                other.rabbitId == rabbitId) &&
            (identical(other.cageId, cageId) || other.cageId == cageId) &&
            (identical(other.assignedTo, assignedTo) ||
                other.assignedTo == assignedTo) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring) &&
            (identical(other.recurrenceRule, recurrenceRule) ||
                other.recurrenceRule == recurrenceRule) &&
            (identical(other.reminderBefore, reminderBefore) ||
                other.reminderBefore == reminderBefore) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    description,
    type,
    status,
    priority,
    dueDate,
    rabbitId,
    cageId,
    assignedTo,
    isRecurring,
    recurrenceRule,
    reminderBefore,
    notes,
  );

  /// Create a copy of TaskCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskCreateImplCopyWith<_$TaskCreateImpl> get copyWith =>
      __$$TaskCreateImplCopyWithImpl<_$TaskCreateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskCreateImplToJson(this);
  }
}

abstract class _TaskCreate implements TaskCreate {
  const factory _TaskCreate({
    required final String title,
    final String? description,
    required final TaskType type,
    final TaskStatus? status,
    final TaskPriority? priority,
    @JsonKey(name: 'due_date') required final DateTime dueDate,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() final int? rabbitId,
    @JsonKey(name: 'cage_id') @NullableIntConverter() final int? cageId,
    @JsonKey(name: 'assigned_to') @NullableIntConverter() final int? assignedTo,
    @JsonKey(name: 'is_recurring') final bool? isRecurring,
    @JsonKey(name: 'recurrence_rule') final String? recurrenceRule,
    @JsonKey(name: 'reminder_before')
    @NullableIntConverter()
    final int? reminderBefore,
    final String? notes,
  }) = _$TaskCreateImpl;

  factory _TaskCreate.fromJson(Map<String, dynamic> json) =
      _$TaskCreateImpl.fromJson;

  @override
  String get title;
  @override
  String? get description;
  @override
  TaskType get type;
  @override
  TaskStatus? get status;
  @override
  TaskPriority? get priority;
  @override
  @JsonKey(name: 'due_date')
  DateTime get dueDate;
  @override
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  int? get rabbitId;
  @override
  @JsonKey(name: 'cage_id')
  @NullableIntConverter()
  int? get cageId;
  @override
  @JsonKey(name: 'assigned_to')
  @NullableIntConverter()
  int? get assignedTo;
  @override
  @JsonKey(name: 'is_recurring')
  bool? get isRecurring;
  @override
  @JsonKey(name: 'recurrence_rule')
  String? get recurrenceRule;
  @override
  @JsonKey(name: 'reminder_before')
  @NullableIntConverter()
  int? get reminderBefore;
  @override
  String? get notes;

  /// Create a copy of TaskCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskCreateImplCopyWith<_$TaskCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskUpdate _$TaskUpdateFromJson(Map<String, dynamic> json) {
  return _TaskUpdate.fromJson(json);
}

/// @nodoc
mixin _$TaskUpdate {
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  TaskType? get type => throw _privateConstructorUsedError;
  TaskStatus? get status => throw _privateConstructorUsedError;
  TaskPriority? get priority => throw _privateConstructorUsedError;
  @JsonKey(name: 'due_date')
  DateTime? get dueDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  int? get rabbitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'cage_id')
  @NullableIntConverter()
  int? get cageId => throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_to')
  @NullableIntConverter()
  int? get assignedTo => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_recurring')
  bool? get isRecurring => throw _privateConstructorUsedError;
  @JsonKey(name: 'recurrence_rule')
  String? get recurrenceRule => throw _privateConstructorUsedError;
  @JsonKey(name: 'reminder_before')
  @NullableIntConverter()
  int? get reminderBefore => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this TaskUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskUpdateCopyWith<TaskUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskUpdateCopyWith<$Res> {
  factory $TaskUpdateCopyWith(
    TaskUpdate value,
    $Res Function(TaskUpdate) then,
  ) = _$TaskUpdateCopyWithImpl<$Res, TaskUpdate>;
  @useResult
  $Res call({
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
    @JsonKey(name: 'reminder_before')
    @NullableIntConverter()
    int? reminderBefore,
    String? notes,
  });
}

/// @nodoc
class _$TaskUpdateCopyWithImpl<$Res, $Val extends TaskUpdate>
    implements $TaskUpdateCopyWith<$Res> {
  _$TaskUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? type = freezed,
    Object? status = freezed,
    Object? priority = freezed,
    Object? dueDate = freezed,
    Object? completedAt = freezed,
    Object? rabbitId = freezed,
    Object? cageId = freezed,
    Object? assignedTo = freezed,
    Object? isRecurring = freezed,
    Object? recurrenceRule = freezed,
    Object? reminderBefore = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as TaskType?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TaskStatus?,
            priority: freezed == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as TaskPriority?,
            dueDate: freezed == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            rabbitId: freezed == rabbitId
                ? _value.rabbitId
                : rabbitId // ignore: cast_nullable_to_non_nullable
                      as int?,
            cageId: freezed == cageId
                ? _value.cageId
                : cageId // ignore: cast_nullable_to_non_nullable
                      as int?,
            assignedTo: freezed == assignedTo
                ? _value.assignedTo
                : assignedTo // ignore: cast_nullable_to_non_nullable
                      as int?,
            isRecurring: freezed == isRecurring
                ? _value.isRecurring
                : isRecurring // ignore: cast_nullable_to_non_nullable
                      as bool?,
            recurrenceRule: freezed == recurrenceRule
                ? _value.recurrenceRule
                : recurrenceRule // ignore: cast_nullable_to_non_nullable
                      as String?,
            reminderBefore: freezed == reminderBefore
                ? _value.reminderBefore
                : reminderBefore // ignore: cast_nullable_to_non_nullable
                      as int?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskUpdateImplCopyWith<$Res>
    implements $TaskUpdateCopyWith<$Res> {
  factory _$$TaskUpdateImplCopyWith(
    _$TaskUpdateImpl value,
    $Res Function(_$TaskUpdateImpl) then,
  ) = __$$TaskUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
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
    @JsonKey(name: 'reminder_before')
    @NullableIntConverter()
    int? reminderBefore,
    String? notes,
  });
}

/// @nodoc
class __$$TaskUpdateImplCopyWithImpl<$Res>
    extends _$TaskUpdateCopyWithImpl<$Res, _$TaskUpdateImpl>
    implements _$$TaskUpdateImplCopyWith<$Res> {
  __$$TaskUpdateImplCopyWithImpl(
    _$TaskUpdateImpl _value,
    $Res Function(_$TaskUpdateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? type = freezed,
    Object? status = freezed,
    Object? priority = freezed,
    Object? dueDate = freezed,
    Object? completedAt = freezed,
    Object? rabbitId = freezed,
    Object? cageId = freezed,
    Object? assignedTo = freezed,
    Object? isRecurring = freezed,
    Object? recurrenceRule = freezed,
    Object? reminderBefore = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$TaskUpdateImpl(
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as TaskType?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TaskStatus?,
        priority: freezed == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as TaskPriority?,
        dueDate: freezed == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        rabbitId: freezed == rabbitId
            ? _value.rabbitId
            : rabbitId // ignore: cast_nullable_to_non_nullable
                  as int?,
        cageId: freezed == cageId
            ? _value.cageId
            : cageId // ignore: cast_nullable_to_non_nullable
                  as int?,
        assignedTo: freezed == assignedTo
            ? _value.assignedTo
            : assignedTo // ignore: cast_nullable_to_non_nullable
                  as int?,
        isRecurring: freezed == isRecurring
            ? _value.isRecurring
            : isRecurring // ignore: cast_nullable_to_non_nullable
                  as bool?,
        recurrenceRule: freezed == recurrenceRule
            ? _value.recurrenceRule
            : recurrenceRule // ignore: cast_nullable_to_non_nullable
                  as String?,
        reminderBefore: freezed == reminderBefore
            ? _value.reminderBefore
            : reminderBefore // ignore: cast_nullable_to_non_nullable
                  as int?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskUpdateImpl implements _TaskUpdate {
  const _$TaskUpdateImpl({
    this.title,
    this.description,
    this.type,
    this.status,
    this.priority,
    @JsonKey(name: 'due_date') this.dueDate,
    @JsonKey(name: 'completed_at') this.completedAt,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() this.rabbitId,
    @JsonKey(name: 'cage_id') @NullableIntConverter() this.cageId,
    @JsonKey(name: 'assigned_to') @NullableIntConverter() this.assignedTo,
    @JsonKey(name: 'is_recurring') this.isRecurring,
    @JsonKey(name: 'recurrence_rule') this.recurrenceRule,
    @JsonKey(name: 'reminder_before')
    @NullableIntConverter()
    this.reminderBefore,
    this.notes,
  });

  factory _$TaskUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskUpdateImplFromJson(json);

  @override
  final String? title;
  @override
  final String? description;
  @override
  final TaskType? type;
  @override
  final TaskStatus? status;
  @override
  final TaskPriority? priority;
  @override
  @JsonKey(name: 'due_date')
  final DateTime? dueDate;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  @override
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  final int? rabbitId;
  @override
  @JsonKey(name: 'cage_id')
  @NullableIntConverter()
  final int? cageId;
  @override
  @JsonKey(name: 'assigned_to')
  @NullableIntConverter()
  final int? assignedTo;
  @override
  @JsonKey(name: 'is_recurring')
  final bool? isRecurring;
  @override
  @JsonKey(name: 'recurrence_rule')
  final String? recurrenceRule;
  @override
  @JsonKey(name: 'reminder_before')
  @NullableIntConverter()
  final int? reminderBefore;
  @override
  final String? notes;

  @override
  String toString() {
    return 'TaskUpdate(title: $title, description: $description, type: $type, status: $status, priority: $priority, dueDate: $dueDate, completedAt: $completedAt, rabbitId: $rabbitId, cageId: $cageId, assignedTo: $assignedTo, isRecurring: $isRecurring, recurrenceRule: $recurrenceRule, reminderBefore: $reminderBefore, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskUpdateImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.rabbitId, rabbitId) ||
                other.rabbitId == rabbitId) &&
            (identical(other.cageId, cageId) || other.cageId == cageId) &&
            (identical(other.assignedTo, assignedTo) ||
                other.assignedTo == assignedTo) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring) &&
            (identical(other.recurrenceRule, recurrenceRule) ||
                other.recurrenceRule == recurrenceRule) &&
            (identical(other.reminderBefore, reminderBefore) ||
                other.reminderBefore == reminderBefore) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    description,
    type,
    status,
    priority,
    dueDate,
    completedAt,
    rabbitId,
    cageId,
    assignedTo,
    isRecurring,
    recurrenceRule,
    reminderBefore,
    notes,
  );

  /// Create a copy of TaskUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskUpdateImplCopyWith<_$TaskUpdateImpl> get copyWith =>
      __$$TaskUpdateImplCopyWithImpl<_$TaskUpdateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskUpdateImplToJson(this);
  }
}

abstract class _TaskUpdate implements TaskUpdate {
  const factory _TaskUpdate({
    final String? title,
    final String? description,
    final TaskType? type,
    final TaskStatus? status,
    final TaskPriority? priority,
    @JsonKey(name: 'due_date') final DateTime? dueDate,
    @JsonKey(name: 'completed_at') final DateTime? completedAt,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() final int? rabbitId,
    @JsonKey(name: 'cage_id') @NullableIntConverter() final int? cageId,
    @JsonKey(name: 'assigned_to') @NullableIntConverter() final int? assignedTo,
    @JsonKey(name: 'is_recurring') final bool? isRecurring,
    @JsonKey(name: 'recurrence_rule') final String? recurrenceRule,
    @JsonKey(name: 'reminder_before')
    @NullableIntConverter()
    final int? reminderBefore,
    final String? notes,
  }) = _$TaskUpdateImpl;

  factory _TaskUpdate.fromJson(Map<String, dynamic> json) =
      _$TaskUpdateImpl.fromJson;

  @override
  String? get title;
  @override
  String? get description;
  @override
  TaskType? get type;
  @override
  TaskStatus? get status;
  @override
  TaskPriority? get priority;
  @override
  @JsonKey(name: 'due_date')
  DateTime? get dueDate;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;
  @override
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  int? get rabbitId;
  @override
  @JsonKey(name: 'cage_id')
  @NullableIntConverter()
  int? get cageId;
  @override
  @JsonKey(name: 'assigned_to')
  @NullableIntConverter()
  int? get assignedTo;
  @override
  @JsonKey(name: 'is_recurring')
  bool? get isRecurring;
  @override
  @JsonKey(name: 'recurrence_rule')
  String? get recurrenceRule;
  @override
  @JsonKey(name: 'reminder_before')
  @NullableIntConverter()
  int? get reminderBefore;
  @override
  String? get notes;

  /// Create a copy of TaskUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskUpdateImplCopyWith<_$TaskUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskStatistics _$TaskStatisticsFromJson(Map<String, dynamic> json) {
  return _TaskStatistics.fromJson(json);
}

/// @nodoc
mixin _$TaskStatistics {
  @JsonKey(name: 'total_pending')
  @IntConverter()
  int get totalPending => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_in_progress')
  @IntConverter()
  int get totalInProgress => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_completed')
  @IntConverter()
  int get totalCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_cancelled')
  @IntConverter()
  int get totalCancelled => throw _privateConstructorUsedError;
  @JsonKey(name: 'overdue_count')
  @IntConverter()
  int get overdueCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'today_count')
  @IntConverter()
  int get todayCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'tasks_by_type')
  List<TaskTypeCount> get tasksByType => throw _privateConstructorUsedError;
  @JsonKey(name: 'tasks_by_priority')
  List<TaskPriorityCount> get tasksByPriority =>
      throw _privateConstructorUsedError;

  /// Serializes this TaskStatistics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskStatisticsCopyWith<TaskStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskStatisticsCopyWith<$Res> {
  factory $TaskStatisticsCopyWith(
    TaskStatistics value,
    $Res Function(TaskStatistics) then,
  ) = _$TaskStatisticsCopyWithImpl<$Res, TaskStatistics>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_pending') @IntConverter() int totalPending,
    @JsonKey(name: 'total_in_progress') @IntConverter() int totalInProgress,
    @JsonKey(name: 'total_completed') @IntConverter() int totalCompleted,
    @JsonKey(name: 'total_cancelled') @IntConverter() int totalCancelled,
    @JsonKey(name: 'overdue_count') @IntConverter() int overdueCount,
    @JsonKey(name: 'today_count') @IntConverter() int todayCount,
    @JsonKey(name: 'tasks_by_type') List<TaskTypeCount> tasksByType,
    @JsonKey(name: 'tasks_by_priority') List<TaskPriorityCount> tasksByPriority,
  });
}

/// @nodoc
class _$TaskStatisticsCopyWithImpl<$Res, $Val extends TaskStatistics>
    implements $TaskStatisticsCopyWith<$Res> {
  _$TaskStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPending = null,
    Object? totalInProgress = null,
    Object? totalCompleted = null,
    Object? totalCancelled = null,
    Object? overdueCount = null,
    Object? todayCount = null,
    Object? tasksByType = null,
    Object? tasksByPriority = null,
  }) {
    return _then(
      _value.copyWith(
            totalPending: null == totalPending
                ? _value.totalPending
                : totalPending // ignore: cast_nullable_to_non_nullable
                      as int,
            totalInProgress: null == totalInProgress
                ? _value.totalInProgress
                : totalInProgress // ignore: cast_nullable_to_non_nullable
                      as int,
            totalCompleted: null == totalCompleted
                ? _value.totalCompleted
                : totalCompleted // ignore: cast_nullable_to_non_nullable
                      as int,
            totalCancelled: null == totalCancelled
                ? _value.totalCancelled
                : totalCancelled // ignore: cast_nullable_to_non_nullable
                      as int,
            overdueCount: null == overdueCount
                ? _value.overdueCount
                : overdueCount // ignore: cast_nullable_to_non_nullable
                      as int,
            todayCount: null == todayCount
                ? _value.todayCount
                : todayCount // ignore: cast_nullable_to_non_nullable
                      as int,
            tasksByType: null == tasksByType
                ? _value.tasksByType
                : tasksByType // ignore: cast_nullable_to_non_nullable
                      as List<TaskTypeCount>,
            tasksByPriority: null == tasksByPriority
                ? _value.tasksByPriority
                : tasksByPriority // ignore: cast_nullable_to_non_nullable
                      as List<TaskPriorityCount>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskStatisticsImplCopyWith<$Res>
    implements $TaskStatisticsCopyWith<$Res> {
  factory _$$TaskStatisticsImplCopyWith(
    _$TaskStatisticsImpl value,
    $Res Function(_$TaskStatisticsImpl) then,
  ) = __$$TaskStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_pending') @IntConverter() int totalPending,
    @JsonKey(name: 'total_in_progress') @IntConverter() int totalInProgress,
    @JsonKey(name: 'total_completed') @IntConverter() int totalCompleted,
    @JsonKey(name: 'total_cancelled') @IntConverter() int totalCancelled,
    @JsonKey(name: 'overdue_count') @IntConverter() int overdueCount,
    @JsonKey(name: 'today_count') @IntConverter() int todayCount,
    @JsonKey(name: 'tasks_by_type') List<TaskTypeCount> tasksByType,
    @JsonKey(name: 'tasks_by_priority') List<TaskPriorityCount> tasksByPriority,
  });
}

/// @nodoc
class __$$TaskStatisticsImplCopyWithImpl<$Res>
    extends _$TaskStatisticsCopyWithImpl<$Res, _$TaskStatisticsImpl>
    implements _$$TaskStatisticsImplCopyWith<$Res> {
  __$$TaskStatisticsImplCopyWithImpl(
    _$TaskStatisticsImpl _value,
    $Res Function(_$TaskStatisticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPending = null,
    Object? totalInProgress = null,
    Object? totalCompleted = null,
    Object? totalCancelled = null,
    Object? overdueCount = null,
    Object? todayCount = null,
    Object? tasksByType = null,
    Object? tasksByPriority = null,
  }) {
    return _then(
      _$TaskStatisticsImpl(
        totalPending: null == totalPending
            ? _value.totalPending
            : totalPending // ignore: cast_nullable_to_non_nullable
                  as int,
        totalInProgress: null == totalInProgress
            ? _value.totalInProgress
            : totalInProgress // ignore: cast_nullable_to_non_nullable
                  as int,
        totalCompleted: null == totalCompleted
            ? _value.totalCompleted
            : totalCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        totalCancelled: null == totalCancelled
            ? _value.totalCancelled
            : totalCancelled // ignore: cast_nullable_to_non_nullable
                  as int,
        overdueCount: null == overdueCount
            ? _value.overdueCount
            : overdueCount // ignore: cast_nullable_to_non_nullable
                  as int,
        todayCount: null == todayCount
            ? _value.todayCount
            : todayCount // ignore: cast_nullable_to_non_nullable
                  as int,
        tasksByType: null == tasksByType
            ? _value._tasksByType
            : tasksByType // ignore: cast_nullable_to_non_nullable
                  as List<TaskTypeCount>,
        tasksByPriority: null == tasksByPriority
            ? _value._tasksByPriority
            : tasksByPriority // ignore: cast_nullable_to_non_nullable
                  as List<TaskPriorityCount>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskStatisticsImpl implements _TaskStatistics {
  const _$TaskStatisticsImpl({
    @JsonKey(name: 'total_pending') @IntConverter() required this.totalPending,
    @JsonKey(name: 'total_in_progress')
    @IntConverter()
    required this.totalInProgress,
    @JsonKey(name: 'total_completed')
    @IntConverter()
    required this.totalCompleted,
    @JsonKey(name: 'total_cancelled')
    @IntConverter()
    required this.totalCancelled,
    @JsonKey(name: 'overdue_count') @IntConverter() required this.overdueCount,
    @JsonKey(name: 'today_count') @IntConverter() required this.todayCount,
    @JsonKey(name: 'tasks_by_type')
    required final List<TaskTypeCount> tasksByType,
    @JsonKey(name: 'tasks_by_priority')
    required final List<TaskPriorityCount> tasksByPriority,
  }) : _tasksByType = tasksByType,
       _tasksByPriority = tasksByPriority;

  factory _$TaskStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskStatisticsImplFromJson(json);

  @override
  @JsonKey(name: 'total_pending')
  @IntConverter()
  final int totalPending;
  @override
  @JsonKey(name: 'total_in_progress')
  @IntConverter()
  final int totalInProgress;
  @override
  @JsonKey(name: 'total_completed')
  @IntConverter()
  final int totalCompleted;
  @override
  @JsonKey(name: 'total_cancelled')
  @IntConverter()
  final int totalCancelled;
  @override
  @JsonKey(name: 'overdue_count')
  @IntConverter()
  final int overdueCount;
  @override
  @JsonKey(name: 'today_count')
  @IntConverter()
  final int todayCount;
  final List<TaskTypeCount> _tasksByType;
  @override
  @JsonKey(name: 'tasks_by_type')
  List<TaskTypeCount> get tasksByType {
    if (_tasksByType is EqualUnmodifiableListView) return _tasksByType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasksByType);
  }

  final List<TaskPriorityCount> _tasksByPriority;
  @override
  @JsonKey(name: 'tasks_by_priority')
  List<TaskPriorityCount> get tasksByPriority {
    if (_tasksByPriority is EqualUnmodifiableListView) return _tasksByPriority;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasksByPriority);
  }

  @override
  String toString() {
    return 'TaskStatistics(totalPending: $totalPending, totalInProgress: $totalInProgress, totalCompleted: $totalCompleted, totalCancelled: $totalCancelled, overdueCount: $overdueCount, todayCount: $todayCount, tasksByType: $tasksByType, tasksByPriority: $tasksByPriority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskStatisticsImpl &&
            (identical(other.totalPending, totalPending) ||
                other.totalPending == totalPending) &&
            (identical(other.totalInProgress, totalInProgress) ||
                other.totalInProgress == totalInProgress) &&
            (identical(other.totalCompleted, totalCompleted) ||
                other.totalCompleted == totalCompleted) &&
            (identical(other.totalCancelled, totalCancelled) ||
                other.totalCancelled == totalCancelled) &&
            (identical(other.overdueCount, overdueCount) ||
                other.overdueCount == overdueCount) &&
            (identical(other.todayCount, todayCount) ||
                other.todayCount == todayCount) &&
            const DeepCollectionEquality().equals(
              other._tasksByType,
              _tasksByType,
            ) &&
            const DeepCollectionEquality().equals(
              other._tasksByPriority,
              _tasksByPriority,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalPending,
    totalInProgress,
    totalCompleted,
    totalCancelled,
    overdueCount,
    todayCount,
    const DeepCollectionEquality().hash(_tasksByType),
    const DeepCollectionEquality().hash(_tasksByPriority),
  );

  /// Create a copy of TaskStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskStatisticsImplCopyWith<_$TaskStatisticsImpl> get copyWith =>
      __$$TaskStatisticsImplCopyWithImpl<_$TaskStatisticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskStatisticsImplToJson(this);
  }
}

abstract class _TaskStatistics implements TaskStatistics {
  const factory _TaskStatistics({
    @JsonKey(name: 'total_pending')
    @IntConverter()
    required final int totalPending,
    @JsonKey(name: 'total_in_progress')
    @IntConverter()
    required final int totalInProgress,
    @JsonKey(name: 'total_completed')
    @IntConverter()
    required final int totalCompleted,
    @JsonKey(name: 'total_cancelled')
    @IntConverter()
    required final int totalCancelled,
    @JsonKey(name: 'overdue_count')
    @IntConverter()
    required final int overdueCount,
    @JsonKey(name: 'today_count') @IntConverter() required final int todayCount,
    @JsonKey(name: 'tasks_by_type')
    required final List<TaskTypeCount> tasksByType,
    @JsonKey(name: 'tasks_by_priority')
    required final List<TaskPriorityCount> tasksByPriority,
  }) = _$TaskStatisticsImpl;

  factory _TaskStatistics.fromJson(Map<String, dynamic> json) =
      _$TaskStatisticsImpl.fromJson;

  @override
  @JsonKey(name: 'total_pending')
  @IntConverter()
  int get totalPending;
  @override
  @JsonKey(name: 'total_in_progress')
  @IntConverter()
  int get totalInProgress;
  @override
  @JsonKey(name: 'total_completed')
  @IntConverter()
  int get totalCompleted;
  @override
  @JsonKey(name: 'total_cancelled')
  @IntConverter()
  int get totalCancelled;
  @override
  @JsonKey(name: 'overdue_count')
  @IntConverter()
  int get overdueCount;
  @override
  @JsonKey(name: 'today_count')
  @IntConverter()
  int get todayCount;
  @override
  @JsonKey(name: 'tasks_by_type')
  List<TaskTypeCount> get tasksByType;
  @override
  @JsonKey(name: 'tasks_by_priority')
  List<TaskPriorityCount> get tasksByPriority;

  /// Create a copy of TaskStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskStatisticsImplCopyWith<_$TaskStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskTypeCount _$TaskTypeCountFromJson(Map<String, dynamic> json) {
  return _TaskTypeCount.fromJson(json);
}

/// @nodoc
mixin _$TaskTypeCount {
  TaskType get type => throw _privateConstructorUsedError;
  @IntConverter()
  int get count => throw _privateConstructorUsedError;

  /// Serializes this TaskTypeCount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskTypeCountCopyWith<TaskTypeCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskTypeCountCopyWith<$Res> {
  factory $TaskTypeCountCopyWith(
    TaskTypeCount value,
    $Res Function(TaskTypeCount) then,
  ) = _$TaskTypeCountCopyWithImpl<$Res, TaskTypeCount>;
  @useResult
  $Res call({TaskType type, @IntConverter() int count});
}

/// @nodoc
class _$TaskTypeCountCopyWithImpl<$Res, $Val extends TaskTypeCount>
    implements $TaskTypeCountCopyWith<$Res> {
  _$TaskTypeCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? count = null}) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as TaskType,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskTypeCountImplCopyWith<$Res>
    implements $TaskTypeCountCopyWith<$Res> {
  factory _$$TaskTypeCountImplCopyWith(
    _$TaskTypeCountImpl value,
    $Res Function(_$TaskTypeCountImpl) then,
  ) = __$$TaskTypeCountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TaskType type, @IntConverter() int count});
}

/// @nodoc
class __$$TaskTypeCountImplCopyWithImpl<$Res>
    extends _$TaskTypeCountCopyWithImpl<$Res, _$TaskTypeCountImpl>
    implements _$$TaskTypeCountImplCopyWith<$Res> {
  __$$TaskTypeCountImplCopyWithImpl(
    _$TaskTypeCountImpl _value,
    $Res Function(_$TaskTypeCountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? count = null}) {
    return _then(
      _$TaskTypeCountImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as TaskType,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskTypeCountImpl implements _TaskTypeCount {
  const _$TaskTypeCountImpl({
    required this.type,
    @IntConverter() required this.count,
  });

  factory _$TaskTypeCountImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskTypeCountImplFromJson(json);

  @override
  final TaskType type;
  @override
  @IntConverter()
  final int count;

  @override
  String toString() {
    return 'TaskTypeCount(type: $type, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskTypeCountImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, count);

  /// Create a copy of TaskTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskTypeCountImplCopyWith<_$TaskTypeCountImpl> get copyWith =>
      __$$TaskTypeCountImplCopyWithImpl<_$TaskTypeCountImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskTypeCountImplToJson(this);
  }
}

abstract class _TaskTypeCount implements TaskTypeCount {
  const factory _TaskTypeCount({
    required final TaskType type,
    @IntConverter() required final int count,
  }) = _$TaskTypeCountImpl;

  factory _TaskTypeCount.fromJson(Map<String, dynamic> json) =
      _$TaskTypeCountImpl.fromJson;

  @override
  TaskType get type;
  @override
  @IntConverter()
  int get count;

  /// Create a copy of TaskTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskTypeCountImplCopyWith<_$TaskTypeCountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskPriorityCount _$TaskPriorityCountFromJson(Map<String, dynamic> json) {
  return _TaskPriorityCount.fromJson(json);
}

/// @nodoc
mixin _$TaskPriorityCount {
  TaskPriority get priority => throw _privateConstructorUsedError;
  @IntConverter()
  int get count => throw _privateConstructorUsedError;

  /// Serializes this TaskPriorityCount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskPriorityCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskPriorityCountCopyWith<TaskPriorityCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskPriorityCountCopyWith<$Res> {
  factory $TaskPriorityCountCopyWith(
    TaskPriorityCount value,
    $Res Function(TaskPriorityCount) then,
  ) = _$TaskPriorityCountCopyWithImpl<$Res, TaskPriorityCount>;
  @useResult
  $Res call({TaskPriority priority, @IntConverter() int count});
}

/// @nodoc
class _$TaskPriorityCountCopyWithImpl<$Res, $Val extends TaskPriorityCount>
    implements $TaskPriorityCountCopyWith<$Res> {
  _$TaskPriorityCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskPriorityCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? priority = null, Object? count = null}) {
    return _then(
      _value.copyWith(
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as TaskPriority,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskPriorityCountImplCopyWith<$Res>
    implements $TaskPriorityCountCopyWith<$Res> {
  factory _$$TaskPriorityCountImplCopyWith(
    _$TaskPriorityCountImpl value,
    $Res Function(_$TaskPriorityCountImpl) then,
  ) = __$$TaskPriorityCountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TaskPriority priority, @IntConverter() int count});
}

/// @nodoc
class __$$TaskPriorityCountImplCopyWithImpl<$Res>
    extends _$TaskPriorityCountCopyWithImpl<$Res, _$TaskPriorityCountImpl>
    implements _$$TaskPriorityCountImplCopyWith<$Res> {
  __$$TaskPriorityCountImplCopyWithImpl(
    _$TaskPriorityCountImpl _value,
    $Res Function(_$TaskPriorityCountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskPriorityCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? priority = null, Object? count = null}) {
    return _then(
      _$TaskPriorityCountImpl(
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as TaskPriority,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskPriorityCountImpl implements _TaskPriorityCount {
  const _$TaskPriorityCountImpl({
    required this.priority,
    @IntConverter() required this.count,
  });

  factory _$TaskPriorityCountImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskPriorityCountImplFromJson(json);

  @override
  final TaskPriority priority;
  @override
  @IntConverter()
  final int count;

  @override
  String toString() {
    return 'TaskPriorityCount(priority: $priority, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskPriorityCountImpl &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, priority, count);

  /// Create a copy of TaskPriorityCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskPriorityCountImplCopyWith<_$TaskPriorityCountImpl> get copyWith =>
      __$$TaskPriorityCountImplCopyWithImpl<_$TaskPriorityCountImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskPriorityCountImplToJson(this);
  }
}

abstract class _TaskPriorityCount implements TaskPriorityCount {
  const factory _TaskPriorityCount({
    required final TaskPriority priority,
    @IntConverter() required final int count,
  }) = _$TaskPriorityCountImpl;

  factory _TaskPriorityCount.fromJson(Map<String, dynamic> json) =
      _$TaskPriorityCountImpl.fromJson;

  @override
  TaskPriority get priority;
  @override
  @IntConverter()
  int get count;

  /// Create a copy of TaskPriorityCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskPriorityCountImplCopyWith<_$TaskPriorityCountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
