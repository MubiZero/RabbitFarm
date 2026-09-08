// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Task {

@IntConverter() int get id; String get title; String? get description; TaskType get type; TaskStatus get status; TaskPriority get priority;@JsonKey(name: 'due_date')@DateTimeConverter() DateTime get dueDate;@JsonKey(name: 'completed_at')@NullableDateTimeConverter() DateTime? get completedAt;@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? get rabbitId;@JsonKey(name: 'cage_id')@NullableIntConverter() int? get cageId;@JsonKey(name: 'assigned_to')@NullableIntConverter() int? get assignedTo;@JsonKey(name: 'created_by')@NullableIntConverter() int? get createdBy;@JsonKey(name: 'is_recurring') bool? get isRecurring;@JsonKey(name: 'recurrence_rule') String? get recurrenceRule;@JsonKey(name: 'reminder_before')@NullableIntConverter() int? get reminderBefore; String? get notes;@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? get createdAt;@JsonKey(name: 'updated_at')@NullableDateTimeConverter() DateTime? get updatedAt; RabbitRef? get rabbit; CageInfo? get cage;@JsonKey(name: 'creator') UserRef? get author;
/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCopyWith<Task> get copyWith => _$TaskCopyWithImpl<Task>(this as Task, _$identity);

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Task;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Task&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.priority, _this.priority) || other.priority == _this.priority)&&(identical(other.dueDate, _this.dueDate) || other.dueDate == _this.dueDate)&&(identical(other.completedAt, _this.completedAt) || other.completedAt == _this.completedAt)&&(identical(other.rabbitId, _this.rabbitId) || other.rabbitId == _this.rabbitId)&&(identical(other.cageId, _this.cageId) || other.cageId == _this.cageId)&&(identical(other.assignedTo, _this.assignedTo) || other.assignedTo == _this.assignedTo)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.isRecurring, _this.isRecurring) || other.isRecurring == _this.isRecurring)&&(identical(other.recurrenceRule, _this.recurrenceRule) || other.recurrenceRule == _this.recurrenceRule)&&(identical(other.reminderBefore, _this.reminderBefore) || other.reminderBefore == _this.reminderBefore)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.rabbit, _this.rabbit) || other.rabbit == _this.rabbit)&&(identical(other.cage, _this.cage) || other.cage == _this.cage)&&(identical(other.author, _this.author) || other.author == _this.author));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Task;
  return Object.hashAll([runtimeType,_this.id,_this.title,_this.description,_this.type,_this.status,_this.priority,_this.dueDate,_this.completedAt,_this.rabbitId,_this.cageId,_this.assignedTo,_this.createdBy,_this.isRecurring,_this.recurrenceRule,_this.reminderBefore,_this.notes,_this.createdAt,_this.updatedAt,_this.rabbit,_this.cage,_this.author]);
}

@override
String toString() {
  final _this = this as Task;
  return 'Task(id: ${_this.id}, title: ${_this.title}, description: ${_this.description}, type: ${_this.type}, status: ${_this.status}, priority: ${_this.priority}, dueDate: ${_this.dueDate}, completedAt: ${_this.completedAt}, rabbitId: ${_this.rabbitId}, cageId: ${_this.cageId}, assignedTo: ${_this.assignedTo}, createdBy: ${_this.createdBy}, isRecurring: ${_this.isRecurring}, recurrenceRule: ${_this.recurrenceRule}, reminderBefore: ${_this.reminderBefore}, notes: ${_this.notes}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, rabbit: ${_this.rabbit}, cage: ${_this.cage}, author: ${_this.author})';
}


}

/// @nodoc
abstract mixin class $TaskCopyWith<$Res>  {
  factory $TaskCopyWith(Task value, $Res Function(Task) _then) = _$TaskCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id, String title, String? description, TaskType type, TaskStatus status, TaskPriority priority,@JsonKey(name: 'due_date')@DateTimeConverter() DateTime dueDate,@JsonKey(name: 'completed_at')@NullableDateTimeConverter() DateTime? completedAt,@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? rabbitId,@JsonKey(name: 'cage_id')@NullableIntConverter() int? cageId,@JsonKey(name: 'assigned_to')@NullableIntConverter() int? assignedTo,@JsonKey(name: 'created_by')@NullableIntConverter() int? createdBy,@JsonKey(name: 'is_recurring') bool? isRecurring,@JsonKey(name: 'recurrence_rule') String? recurrenceRule,@JsonKey(name: 'reminder_before')@NullableIntConverter() int? reminderBefore, String? notes,@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@NullableDateTimeConverter() DateTime? updatedAt, RabbitRef? rabbit, CageInfo? cage,@JsonKey(name: 'creator') UserRef? author
});


$RabbitRefCopyWith<$Res>? get rabbit;$CageInfoCopyWith<$Res>? get cage;$UserRefCopyWith<$Res>? get author;

}
/// @nodoc
class _$TaskCopyWithImpl<$Res>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._self, this._then);

  final Task _self;
  final $Res Function(Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? type = null,Object? status = null,Object? priority = null,Object? dueDate = null,Object? completedAt = freezed,Object? rabbitId = freezed,Object? cageId = freezed,Object? assignedTo = freezed,Object? createdBy = freezed,Object? isRecurring = freezed,Object? recurrenceRule = freezed,Object? reminderBefore = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rabbit = freezed,Object? cage = freezed,Object? author = freezed,}) {
  return _then(Task(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,cageId: freezed == cageId ? _self.cageId : cageId // ignore: cast_nullable_to_non_nullable
as int?,assignedTo: freezed == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as int?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as int?,isRecurring: freezed == isRecurring ? _self.isRecurring : isRecurring // ignore: cast_nullable_to_non_nullable
as bool?,recurrenceRule: freezed == recurrenceRule ? _self.recurrenceRule : recurrenceRule // ignore: cast_nullable_to_non_nullable
as String?,reminderBefore: freezed == reminderBefore ? _self.reminderBefore : reminderBefore // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rabbit: freezed == rabbit ? _self.rabbit : rabbit // ignore: cast_nullable_to_non_nullable
as RabbitRef?,cage: freezed == cage ? _self.cage : cage // ignore: cast_nullable_to_non_nullable
as CageInfo?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserRef?,
  ));
}
/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RabbitRefCopyWith<$Res>? get rabbit {
    if (_self.rabbit == null) {
    return null;
  }

  return $RabbitRefCopyWith<$Res>(_self.rabbit!, (value) {
    return _then(_self.copyWith(rabbit: value));
  });
}/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CageInfoCopyWith<$Res>? get cage {
    if (_self.cage == null) {
    return null;
  }

  return $CageInfoCopyWith<$Res>(_self.cage!, (value) {
    return _then(_self.copyWith(cage: value));
  });
}/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserRefCopyWith<$Res>? get author {
    if (_self.author == null) {
    return null;
  }

  return $UserRefCopyWith<$Res>(_self.author!, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [Task].
extension TaskPatterns on Task {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Task value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Task value)  $default,){
final _that = this;
switch (_that) {
case _Task():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Task value)?  $default,){
final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String title,  String? description,  TaskType type,  TaskStatus status,  TaskPriority priority, @JsonKey(name: 'due_date')@DateTimeConverter()  DateTime dueDate, @JsonKey(name: 'completed_at')@NullableDateTimeConverter()  DateTime? completedAt, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId, @JsonKey(name: 'cage_id')@NullableIntConverter()  int? cageId, @JsonKey(name: 'assigned_to')@NullableIntConverter()  int? assignedTo, @JsonKey(name: 'created_by')@NullableIntConverter()  int? createdBy, @JsonKey(name: 'is_recurring')  bool? isRecurring, @JsonKey(name: 'recurrence_rule')  String? recurrenceRule, @JsonKey(name: 'reminder_before')@NullableIntConverter()  int? reminderBefore,  String? notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter()  DateTime? updatedAt,  RabbitRef? rabbit,  CageInfo? cage, @JsonKey(name: 'creator')  UserRef? author)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.type,_that.status,_that.priority,_that.dueDate,_that.completedAt,_that.rabbitId,_that.cageId,_that.assignedTo,_that.createdBy,_that.isRecurring,_that.recurrenceRule,_that.reminderBefore,_that.notes,_that.createdAt,_that.updatedAt,_that.rabbit,_that.cage,_that.author);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String title,  String? description,  TaskType type,  TaskStatus status,  TaskPriority priority, @JsonKey(name: 'due_date')@DateTimeConverter()  DateTime dueDate, @JsonKey(name: 'completed_at')@NullableDateTimeConverter()  DateTime? completedAt, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId, @JsonKey(name: 'cage_id')@NullableIntConverter()  int? cageId, @JsonKey(name: 'assigned_to')@NullableIntConverter()  int? assignedTo, @JsonKey(name: 'created_by')@NullableIntConverter()  int? createdBy, @JsonKey(name: 'is_recurring')  bool? isRecurring, @JsonKey(name: 'recurrence_rule')  String? recurrenceRule, @JsonKey(name: 'reminder_before')@NullableIntConverter()  int? reminderBefore,  String? notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter()  DateTime? updatedAt,  RabbitRef? rabbit,  CageInfo? cage, @JsonKey(name: 'creator')  UserRef? author)  $default,) {final _that = this;
switch (_that) {
case _Task():
return $default(_that.id,_that.title,_that.description,_that.type,_that.status,_that.priority,_that.dueDate,_that.completedAt,_that.rabbitId,_that.cageId,_that.assignedTo,_that.createdBy,_that.isRecurring,_that.recurrenceRule,_that.reminderBefore,_that.notes,_that.createdAt,_that.updatedAt,_that.rabbit,_that.cage,_that.author);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id,  String title,  String? description,  TaskType type,  TaskStatus status,  TaskPriority priority, @JsonKey(name: 'due_date')@DateTimeConverter()  DateTime dueDate, @JsonKey(name: 'completed_at')@NullableDateTimeConverter()  DateTime? completedAt, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId, @JsonKey(name: 'cage_id')@NullableIntConverter()  int? cageId, @JsonKey(name: 'assigned_to')@NullableIntConverter()  int? assignedTo, @JsonKey(name: 'created_by')@NullableIntConverter()  int? createdBy, @JsonKey(name: 'is_recurring')  bool? isRecurring, @JsonKey(name: 'recurrence_rule')  String? recurrenceRule, @JsonKey(name: 'reminder_before')@NullableIntConverter()  int? reminderBefore,  String? notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter()  DateTime? updatedAt,  RabbitRef? rabbit,  CageInfo? cage, @JsonKey(name: 'creator')  UserRef? author)?  $default,) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.type,_that.status,_that.priority,_that.dueDate,_that.completedAt,_that.rabbitId,_that.cageId,_that.assignedTo,_that.createdBy,_that.isRecurring,_that.recurrenceRule,_that.reminderBefore,_that.notes,_that.createdAt,_that.updatedAt,_that.rabbit,_that.cage,_that.author);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Task implements Task {
  const _Task({@IntConverter() required this.id, required this.title, this.description, required this.type, required this.status, required this.priority, @JsonKey(name: 'due_date')@DateTimeConverter() required this.dueDate, @JsonKey(name: 'completed_at')@NullableDateTimeConverter() this.completedAt, @JsonKey(name: 'rabbit_id')@NullableIntConverter() this.rabbitId, @JsonKey(name: 'cage_id')@NullableIntConverter() this.cageId, @JsonKey(name: 'assigned_to')@NullableIntConverter() this.assignedTo, @JsonKey(name: 'created_by')@NullableIntConverter() this.createdBy, @JsonKey(name: 'is_recurring') this.isRecurring, @JsonKey(name: 'recurrence_rule') this.recurrenceRule, @JsonKey(name: 'reminder_before')@NullableIntConverter() this.reminderBefore, this.notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter() this.createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter() this.updatedAt, this.rabbit, this.cage, @JsonKey(name: 'creator') this.author});
  factory _Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

@override@IntConverter() final  int id;
@override final  String title;
@override final  String? description;
@override final  TaskType type;
@override final  TaskStatus status;
@override final  TaskPriority priority;
@override@JsonKey(name: 'due_date')@DateTimeConverter() final  DateTime dueDate;
@override@JsonKey(name: 'completed_at')@NullableDateTimeConverter() final  DateTime? completedAt;
@override@JsonKey(name: 'rabbit_id')@NullableIntConverter() final  int? rabbitId;
@override@JsonKey(name: 'cage_id')@NullableIntConverter() final  int? cageId;
@override@JsonKey(name: 'assigned_to')@NullableIntConverter() final  int? assignedTo;
@override@JsonKey(name: 'created_by')@NullableIntConverter() final  int? createdBy;
@override@JsonKey(name: 'is_recurring') final  bool? isRecurring;
@override@JsonKey(name: 'recurrence_rule') final  String? recurrenceRule;
@override@JsonKey(name: 'reminder_before')@NullableIntConverter() final  int? reminderBefore;
@override final  String? notes;
@override@JsonKey(name: 'created_at')@NullableDateTimeConverter() final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at')@NullableDateTimeConverter() final  DateTime? updatedAt;
@override final  RabbitRef? rabbit;
@override final  CageInfo? cage;
@override@JsonKey(name: 'creator') final  UserRef? author;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskCopyWith<_Task> get copyWith => __$TaskCopyWithImpl<_Task>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Task&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.rabbitId, rabbitId) || other.rabbitId == rabbitId)&&(identical(other.cageId, cageId) || other.cageId == cageId)&&(identical(other.assignedTo, assignedTo) || other.assignedTo == assignedTo)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.isRecurring, isRecurring) || other.isRecurring == isRecurring)&&(identical(other.recurrenceRule, recurrenceRule) || other.recurrenceRule == recurrenceRule)&&(identical(other.reminderBefore, reminderBefore) || other.reminderBefore == reminderBefore)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rabbit, rabbit) || other.rabbit == rabbit)&&(identical(other.cage, cage) || other.cage == cage)&&(identical(other.author, author) || other.author == author));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,title,description,type,status,priority,dueDate,completedAt,rabbitId,cageId,assignedTo,createdBy,isRecurring,recurrenceRule,reminderBefore,notes,createdAt,updatedAt,rabbit,cage,author]);
}

@override
String toString() {
    return 'Task(id: $id, title: $title, description: $description, type: $type, status: $status, priority: $priority, dueDate: $dueDate, completedAt: $completedAt, rabbitId: $rabbitId, cageId: $cageId, assignedTo: $assignedTo, createdBy: $createdBy, isRecurring: $isRecurring, recurrenceRule: $recurrenceRule, reminderBefore: $reminderBefore, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, rabbit: $rabbit, cage: $cage, author: $author)';
}


}

/// @nodoc
abstract mixin class _$TaskCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$TaskCopyWith(_Task value, $Res Function(_Task) _then) = __$TaskCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id, String title, String? description, TaskType type, TaskStatus status, TaskPriority priority,@JsonKey(name: 'due_date')@DateTimeConverter() DateTime dueDate,@JsonKey(name: 'completed_at')@NullableDateTimeConverter() DateTime? completedAt,@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? rabbitId,@JsonKey(name: 'cage_id')@NullableIntConverter() int? cageId,@JsonKey(name: 'assigned_to')@NullableIntConverter() int? assignedTo,@JsonKey(name: 'created_by')@NullableIntConverter() int? createdBy,@JsonKey(name: 'is_recurring') bool? isRecurring,@JsonKey(name: 'recurrence_rule') String? recurrenceRule,@JsonKey(name: 'reminder_before')@NullableIntConverter() int? reminderBefore, String? notes,@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@NullableDateTimeConverter() DateTime? updatedAt, RabbitRef? rabbit, CageInfo? cage,@JsonKey(name: 'creator') UserRef? author
});


@override $RabbitRefCopyWith<$Res>? get rabbit;@override $CageInfoCopyWith<$Res>? get cage;@override $UserRefCopyWith<$Res>? get author;

}
/// @nodoc
class __$TaskCopyWithImpl<$Res>
    implements _$TaskCopyWith<$Res> {
  __$TaskCopyWithImpl(this._self, this._then);

  final _Task _self;
  final $Res Function(_Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? type = null,Object? status = null,Object? priority = null,Object? dueDate = null,Object? completedAt = freezed,Object? rabbitId = freezed,Object? cageId = freezed,Object? assignedTo = freezed,Object? createdBy = freezed,Object? isRecurring = freezed,Object? recurrenceRule = freezed,Object? reminderBefore = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rabbit = freezed,Object? cage = freezed,Object? author = freezed,}) {
  return _then(_Task(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,cageId: freezed == cageId ? _self.cageId : cageId // ignore: cast_nullable_to_non_nullable
as int?,assignedTo: freezed == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as int?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as int?,isRecurring: freezed == isRecurring ? _self.isRecurring : isRecurring // ignore: cast_nullable_to_non_nullable
as bool?,recurrenceRule: freezed == recurrenceRule ? _self.recurrenceRule : recurrenceRule // ignore: cast_nullable_to_non_nullable
as String?,reminderBefore: freezed == reminderBefore ? _self.reminderBefore : reminderBefore // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rabbit: freezed == rabbit ? _self.rabbit : rabbit // ignore: cast_nullable_to_non_nullable
as RabbitRef?,cage: freezed == cage ? _self.cage : cage // ignore: cast_nullable_to_non_nullable
as CageInfo?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserRef?,
  ));
}

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RabbitRefCopyWith<$Res>? get rabbit {
    if (_self.rabbit == null) {
    return null;
  }

  return $RabbitRefCopyWith<$Res>(_self.rabbit!, (value) {
    return _then(_self.copyWith(rabbit: value));
  });
}/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CageInfoCopyWith<$Res>? get cage {
    if (_self.cage == null) {
    return null;
  }

  return $CageInfoCopyWith<$Res>(_self.cage!, (value) {
    return _then(_self.copyWith(cage: value));
  });
}/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserRefCopyWith<$Res>? get author {
    if (_self.author == null) {
    return null;
  }

  return $UserRefCopyWith<$Res>(_self.author!, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// @nodoc
mixin _$TaskCreate {

 String get title; String? get description; TaskType get type; TaskStatus? get status; TaskPriority? get priority;@JsonKey(name: 'due_date')@DateTimeConverter() DateTime get dueDate;@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? get rabbitId;@JsonKey(name: 'cage_id')@NullableIntConverter() int? get cageId;@JsonKey(name: 'assigned_to')@NullableIntConverter() int? get assignedTo;@JsonKey(name: 'is_recurring') bool? get isRecurring;@JsonKey(name: 'recurrence_rule') String? get recurrenceRule;@JsonKey(name: 'reminder_before')@NullableIntConverter() int? get reminderBefore; String? get notes;
/// Create a copy of TaskCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCreateCopyWith<TaskCreate> get copyWith => _$TaskCreateCopyWithImpl<TaskCreate>(this as TaskCreate, _$identity);

  /// Serializes this TaskCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TaskCreate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskCreate&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.priority, _this.priority) || other.priority == _this.priority)&&(identical(other.dueDate, _this.dueDate) || other.dueDate == _this.dueDate)&&(identical(other.rabbitId, _this.rabbitId) || other.rabbitId == _this.rabbitId)&&(identical(other.cageId, _this.cageId) || other.cageId == _this.cageId)&&(identical(other.assignedTo, _this.assignedTo) || other.assignedTo == _this.assignedTo)&&(identical(other.isRecurring, _this.isRecurring) || other.isRecurring == _this.isRecurring)&&(identical(other.recurrenceRule, _this.recurrenceRule) || other.recurrenceRule == _this.recurrenceRule)&&(identical(other.reminderBefore, _this.reminderBefore) || other.reminderBefore == _this.reminderBefore)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TaskCreate;
  return Object.hash(runtimeType,_this.title,_this.description,_this.type,_this.status,_this.priority,_this.dueDate,_this.rabbitId,_this.cageId,_this.assignedTo,_this.isRecurring,_this.recurrenceRule,_this.reminderBefore,_this.notes);
}

@override
String toString() {
  final _this = this as TaskCreate;
  return 'TaskCreate(title: ${_this.title}, description: ${_this.description}, type: ${_this.type}, status: ${_this.status}, priority: ${_this.priority}, dueDate: ${_this.dueDate}, rabbitId: ${_this.rabbitId}, cageId: ${_this.cageId}, assignedTo: ${_this.assignedTo}, isRecurring: ${_this.isRecurring}, recurrenceRule: ${_this.recurrenceRule}, reminderBefore: ${_this.reminderBefore}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $TaskCreateCopyWith<$Res>  {
  factory $TaskCreateCopyWith(TaskCreate value, $Res Function(TaskCreate) _then) = _$TaskCreateCopyWithImpl;
@useResult
$Res call({
 String title, String? description, TaskType type, TaskStatus? status, TaskPriority? priority,@JsonKey(name: 'due_date')@DateTimeConverter() DateTime dueDate,@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? rabbitId,@JsonKey(name: 'cage_id')@NullableIntConverter() int? cageId,@JsonKey(name: 'assigned_to')@NullableIntConverter() int? assignedTo,@JsonKey(name: 'is_recurring') bool? isRecurring,@JsonKey(name: 'recurrence_rule') String? recurrenceRule,@JsonKey(name: 'reminder_before')@NullableIntConverter() int? reminderBefore, String? notes
});




}
/// @nodoc
class _$TaskCreateCopyWithImpl<$Res>
    implements $TaskCreateCopyWith<$Res> {
  _$TaskCreateCopyWithImpl(this._self, this._then);

  final TaskCreate _self;
  final $Res Function(TaskCreate) _then;

/// Create a copy of TaskCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = freezed,Object? type = null,Object? status = freezed,Object? priority = freezed,Object? dueDate = null,Object? rabbitId = freezed,Object? cageId = freezed,Object? assignedTo = freezed,Object? isRecurring = freezed,Object? recurrenceRule = freezed,Object? reminderBefore = freezed,Object? notes = freezed,}) {
  return _then(TaskCreate(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskType,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,cageId: freezed == cageId ? _self.cageId : cageId // ignore: cast_nullable_to_non_nullable
as int?,assignedTo: freezed == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as int?,isRecurring: freezed == isRecurring ? _self.isRecurring : isRecurring // ignore: cast_nullable_to_non_nullable
as bool?,recurrenceRule: freezed == recurrenceRule ? _self.recurrenceRule : recurrenceRule // ignore: cast_nullable_to_non_nullable
as String?,reminderBefore: freezed == reminderBefore ? _self.reminderBefore : reminderBefore // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskCreate].
extension TaskCreatePatterns on TaskCreate {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskCreate() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskCreate value)  $default,){
final _that = this;
switch (_that) {
case _TaskCreate():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskCreate value)?  $default,){
final _that = this;
switch (_that) {
case _TaskCreate() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String? description,  TaskType type,  TaskStatus? status,  TaskPriority? priority, @JsonKey(name: 'due_date')@DateTimeConverter()  DateTime dueDate, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId, @JsonKey(name: 'cage_id')@NullableIntConverter()  int? cageId, @JsonKey(name: 'assigned_to')@NullableIntConverter()  int? assignedTo, @JsonKey(name: 'is_recurring')  bool? isRecurring, @JsonKey(name: 'recurrence_rule')  String? recurrenceRule, @JsonKey(name: 'reminder_before')@NullableIntConverter()  int? reminderBefore,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskCreate() when $default != null:
return $default(_that.title,_that.description,_that.type,_that.status,_that.priority,_that.dueDate,_that.rabbitId,_that.cageId,_that.assignedTo,_that.isRecurring,_that.recurrenceRule,_that.reminderBefore,_that.notes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String? description,  TaskType type,  TaskStatus? status,  TaskPriority? priority, @JsonKey(name: 'due_date')@DateTimeConverter()  DateTime dueDate, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId, @JsonKey(name: 'cage_id')@NullableIntConverter()  int? cageId, @JsonKey(name: 'assigned_to')@NullableIntConverter()  int? assignedTo, @JsonKey(name: 'is_recurring')  bool? isRecurring, @JsonKey(name: 'recurrence_rule')  String? recurrenceRule, @JsonKey(name: 'reminder_before')@NullableIntConverter()  int? reminderBefore,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _TaskCreate():
return $default(_that.title,_that.description,_that.type,_that.status,_that.priority,_that.dueDate,_that.rabbitId,_that.cageId,_that.assignedTo,_that.isRecurring,_that.recurrenceRule,_that.reminderBefore,_that.notes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String? description,  TaskType type,  TaskStatus? status,  TaskPriority? priority, @JsonKey(name: 'due_date')@DateTimeConverter()  DateTime dueDate, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId, @JsonKey(name: 'cage_id')@NullableIntConverter()  int? cageId, @JsonKey(name: 'assigned_to')@NullableIntConverter()  int? assignedTo, @JsonKey(name: 'is_recurring')  bool? isRecurring, @JsonKey(name: 'recurrence_rule')  String? recurrenceRule, @JsonKey(name: 'reminder_before')@NullableIntConverter()  int? reminderBefore,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _TaskCreate() when $default != null:
return $default(_that.title,_that.description,_that.type,_that.status,_that.priority,_that.dueDate,_that.rabbitId,_that.cageId,_that.assignedTo,_that.isRecurring,_that.recurrenceRule,_that.reminderBefore,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskCreate implements TaskCreate {
  const _TaskCreate({required this.title, this.description, required this.type, this.status, this.priority, @JsonKey(name: 'due_date')@DateTimeConverter() required this.dueDate, @JsonKey(name: 'rabbit_id')@NullableIntConverter() this.rabbitId, @JsonKey(name: 'cage_id')@NullableIntConverter() this.cageId, @JsonKey(name: 'assigned_to')@NullableIntConverter() this.assignedTo, @JsonKey(name: 'is_recurring') this.isRecurring, @JsonKey(name: 'recurrence_rule') this.recurrenceRule, @JsonKey(name: 'reminder_before')@NullableIntConverter() this.reminderBefore, this.notes});
  factory _TaskCreate.fromJson(Map<String, dynamic> json) => _$TaskCreateFromJson(json);

@override final  String title;
@override final  String? description;
@override final  TaskType type;
@override final  TaskStatus? status;
@override final  TaskPriority? priority;
@override@JsonKey(name: 'due_date')@DateTimeConverter() final  DateTime dueDate;
@override@JsonKey(name: 'rabbit_id')@NullableIntConverter() final  int? rabbitId;
@override@JsonKey(name: 'cage_id')@NullableIntConverter() final  int? cageId;
@override@JsonKey(name: 'assigned_to')@NullableIntConverter() final  int? assignedTo;
@override@JsonKey(name: 'is_recurring') final  bool? isRecurring;
@override@JsonKey(name: 'recurrence_rule') final  String? recurrenceRule;
@override@JsonKey(name: 'reminder_before')@NullableIntConverter() final  int? reminderBefore;
@override final  String? notes;

/// Create a copy of TaskCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskCreateCopyWith<_TaskCreate> get copyWith => __$TaskCreateCopyWithImpl<_TaskCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskCreateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskCreate&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.rabbitId, rabbitId) || other.rabbitId == rabbitId)&&(identical(other.cageId, cageId) || other.cageId == cageId)&&(identical(other.assignedTo, assignedTo) || other.assignedTo == assignedTo)&&(identical(other.isRecurring, isRecurring) || other.isRecurring == isRecurring)&&(identical(other.recurrenceRule, recurrenceRule) || other.recurrenceRule == recurrenceRule)&&(identical(other.reminderBefore, reminderBefore) || other.reminderBefore == reminderBefore)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,description,type,status,priority,dueDate,rabbitId,cageId,assignedTo,isRecurring,recurrenceRule,reminderBefore,notes);
}

@override
String toString() {
    return 'TaskCreate(title: $title, description: $description, type: $type, status: $status, priority: $priority, dueDate: $dueDate, rabbitId: $rabbitId, cageId: $cageId, assignedTo: $assignedTo, isRecurring: $isRecurring, recurrenceRule: $recurrenceRule, reminderBefore: $reminderBefore, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$TaskCreateCopyWith<$Res> implements $TaskCreateCopyWith<$Res> {
  factory _$TaskCreateCopyWith(_TaskCreate value, $Res Function(_TaskCreate) _then) = __$TaskCreateCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description, TaskType type, TaskStatus? status, TaskPriority? priority,@JsonKey(name: 'due_date')@DateTimeConverter() DateTime dueDate,@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? rabbitId,@JsonKey(name: 'cage_id')@NullableIntConverter() int? cageId,@JsonKey(name: 'assigned_to')@NullableIntConverter() int? assignedTo,@JsonKey(name: 'is_recurring') bool? isRecurring,@JsonKey(name: 'recurrence_rule') String? recurrenceRule,@JsonKey(name: 'reminder_before')@NullableIntConverter() int? reminderBefore, String? notes
});




}
/// @nodoc
class __$TaskCreateCopyWithImpl<$Res>
    implements _$TaskCreateCopyWith<$Res> {
  __$TaskCreateCopyWithImpl(this._self, this._then);

  final _TaskCreate _self;
  final $Res Function(_TaskCreate) _then;

/// Create a copy of TaskCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? type = null,Object? status = freezed,Object? priority = freezed,Object? dueDate = null,Object? rabbitId = freezed,Object? cageId = freezed,Object? assignedTo = freezed,Object? isRecurring = freezed,Object? recurrenceRule = freezed,Object? reminderBefore = freezed,Object? notes = freezed,}) {
  return _then(_TaskCreate(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskType,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,cageId: freezed == cageId ? _self.cageId : cageId // ignore: cast_nullable_to_non_nullable
as int?,assignedTo: freezed == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as int?,isRecurring: freezed == isRecurring ? _self.isRecurring : isRecurring // ignore: cast_nullable_to_non_nullable
as bool?,recurrenceRule: freezed == recurrenceRule ? _self.recurrenceRule : recurrenceRule // ignore: cast_nullable_to_non_nullable
as String?,reminderBefore: freezed == reminderBefore ? _self.reminderBefore : reminderBefore // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TaskUpdate {

 String? get title; String? get description; TaskType? get type; TaskStatus? get status; TaskPriority? get priority;@JsonKey(name: 'due_date')@NullableDateTimeConverter() DateTime? get dueDate;@JsonKey(name: 'completed_at')@NullableDateTimeConverter() DateTime? get completedAt;@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? get rabbitId;@JsonKey(name: 'cage_id')@NullableIntConverter() int? get cageId;@JsonKey(name: 'assigned_to')@NullableIntConverter() int? get assignedTo;@JsonKey(name: 'is_recurring') bool? get isRecurring;@JsonKey(name: 'recurrence_rule') String? get recurrenceRule;@JsonKey(name: 'reminder_before')@NullableIntConverter() int? get reminderBefore; String? get notes;
/// Create a copy of TaskUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskUpdateCopyWith<TaskUpdate> get copyWith => _$TaskUpdateCopyWithImpl<TaskUpdate>(this as TaskUpdate, _$identity);

  /// Serializes this TaskUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TaskUpdate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskUpdate&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.priority, _this.priority) || other.priority == _this.priority)&&(identical(other.dueDate, _this.dueDate) || other.dueDate == _this.dueDate)&&(identical(other.completedAt, _this.completedAt) || other.completedAt == _this.completedAt)&&(identical(other.rabbitId, _this.rabbitId) || other.rabbitId == _this.rabbitId)&&(identical(other.cageId, _this.cageId) || other.cageId == _this.cageId)&&(identical(other.assignedTo, _this.assignedTo) || other.assignedTo == _this.assignedTo)&&(identical(other.isRecurring, _this.isRecurring) || other.isRecurring == _this.isRecurring)&&(identical(other.recurrenceRule, _this.recurrenceRule) || other.recurrenceRule == _this.recurrenceRule)&&(identical(other.reminderBefore, _this.reminderBefore) || other.reminderBefore == _this.reminderBefore)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TaskUpdate;
  return Object.hash(runtimeType,_this.title,_this.description,_this.type,_this.status,_this.priority,_this.dueDate,_this.completedAt,_this.rabbitId,_this.cageId,_this.assignedTo,_this.isRecurring,_this.recurrenceRule,_this.reminderBefore,_this.notes);
}

@override
String toString() {
  final _this = this as TaskUpdate;
  return 'TaskUpdate(title: ${_this.title}, description: ${_this.description}, type: ${_this.type}, status: ${_this.status}, priority: ${_this.priority}, dueDate: ${_this.dueDate}, completedAt: ${_this.completedAt}, rabbitId: ${_this.rabbitId}, cageId: ${_this.cageId}, assignedTo: ${_this.assignedTo}, isRecurring: ${_this.isRecurring}, recurrenceRule: ${_this.recurrenceRule}, reminderBefore: ${_this.reminderBefore}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $TaskUpdateCopyWith<$Res>  {
  factory $TaskUpdateCopyWith(TaskUpdate value, $Res Function(TaskUpdate) _then) = _$TaskUpdateCopyWithImpl;
@useResult
$Res call({
 String? title, String? description, TaskType? type, TaskStatus? status, TaskPriority? priority,@JsonKey(name: 'due_date')@NullableDateTimeConverter() DateTime? dueDate,@JsonKey(name: 'completed_at')@NullableDateTimeConverter() DateTime? completedAt,@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? rabbitId,@JsonKey(name: 'cage_id')@NullableIntConverter() int? cageId,@JsonKey(name: 'assigned_to')@NullableIntConverter() int? assignedTo,@JsonKey(name: 'is_recurring') bool? isRecurring,@JsonKey(name: 'recurrence_rule') String? recurrenceRule,@JsonKey(name: 'reminder_before')@NullableIntConverter() int? reminderBefore, String? notes
});




}
/// @nodoc
class _$TaskUpdateCopyWithImpl<$Res>
    implements $TaskUpdateCopyWith<$Res> {
  _$TaskUpdateCopyWithImpl(this._self, this._then);

  final TaskUpdate _self;
  final $Res Function(TaskUpdate) _then;

/// Create a copy of TaskUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? description = freezed,Object? type = freezed,Object? status = freezed,Object? priority = freezed,Object? dueDate = freezed,Object? completedAt = freezed,Object? rabbitId = freezed,Object? cageId = freezed,Object? assignedTo = freezed,Object? isRecurring = freezed,Object? recurrenceRule = freezed,Object? reminderBefore = freezed,Object? notes = freezed,}) {
  return _then(TaskUpdate(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskType?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,cageId: freezed == cageId ? _self.cageId : cageId // ignore: cast_nullable_to_non_nullable
as int?,assignedTo: freezed == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as int?,isRecurring: freezed == isRecurring ? _self.isRecurring : isRecurring // ignore: cast_nullable_to_non_nullable
as bool?,recurrenceRule: freezed == recurrenceRule ? _self.recurrenceRule : recurrenceRule // ignore: cast_nullable_to_non_nullable
as String?,reminderBefore: freezed == reminderBefore ? _self.reminderBefore : reminderBefore // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskUpdate].
extension TaskUpdatePatterns on TaskUpdate {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskUpdate() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskUpdate value)  $default,){
final _that = this;
switch (_that) {
case _TaskUpdate():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _TaskUpdate() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? description,  TaskType? type,  TaskStatus? status,  TaskPriority? priority, @JsonKey(name: 'due_date')@NullableDateTimeConverter()  DateTime? dueDate, @JsonKey(name: 'completed_at')@NullableDateTimeConverter()  DateTime? completedAt, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId, @JsonKey(name: 'cage_id')@NullableIntConverter()  int? cageId, @JsonKey(name: 'assigned_to')@NullableIntConverter()  int? assignedTo, @JsonKey(name: 'is_recurring')  bool? isRecurring, @JsonKey(name: 'recurrence_rule')  String? recurrenceRule, @JsonKey(name: 'reminder_before')@NullableIntConverter()  int? reminderBefore,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskUpdate() when $default != null:
return $default(_that.title,_that.description,_that.type,_that.status,_that.priority,_that.dueDate,_that.completedAt,_that.rabbitId,_that.cageId,_that.assignedTo,_that.isRecurring,_that.recurrenceRule,_that.reminderBefore,_that.notes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? description,  TaskType? type,  TaskStatus? status,  TaskPriority? priority, @JsonKey(name: 'due_date')@NullableDateTimeConverter()  DateTime? dueDate, @JsonKey(name: 'completed_at')@NullableDateTimeConverter()  DateTime? completedAt, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId, @JsonKey(name: 'cage_id')@NullableIntConverter()  int? cageId, @JsonKey(name: 'assigned_to')@NullableIntConverter()  int? assignedTo, @JsonKey(name: 'is_recurring')  bool? isRecurring, @JsonKey(name: 'recurrence_rule')  String? recurrenceRule, @JsonKey(name: 'reminder_before')@NullableIntConverter()  int? reminderBefore,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _TaskUpdate():
return $default(_that.title,_that.description,_that.type,_that.status,_that.priority,_that.dueDate,_that.completedAt,_that.rabbitId,_that.cageId,_that.assignedTo,_that.isRecurring,_that.recurrenceRule,_that.reminderBefore,_that.notes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? description,  TaskType? type,  TaskStatus? status,  TaskPriority? priority, @JsonKey(name: 'due_date')@NullableDateTimeConverter()  DateTime? dueDate, @JsonKey(name: 'completed_at')@NullableDateTimeConverter()  DateTime? completedAt, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId, @JsonKey(name: 'cage_id')@NullableIntConverter()  int? cageId, @JsonKey(name: 'assigned_to')@NullableIntConverter()  int? assignedTo, @JsonKey(name: 'is_recurring')  bool? isRecurring, @JsonKey(name: 'recurrence_rule')  String? recurrenceRule, @JsonKey(name: 'reminder_before')@NullableIntConverter()  int? reminderBefore,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _TaskUpdate() when $default != null:
return $default(_that.title,_that.description,_that.type,_that.status,_that.priority,_that.dueDate,_that.completedAt,_that.rabbitId,_that.cageId,_that.assignedTo,_that.isRecurring,_that.recurrenceRule,_that.reminderBefore,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskUpdate implements TaskUpdate {
  const _TaskUpdate({this.title, this.description, this.type, this.status, this.priority, @JsonKey(name: 'due_date')@NullableDateTimeConverter() this.dueDate, @JsonKey(name: 'completed_at')@NullableDateTimeConverter() this.completedAt, @JsonKey(name: 'rabbit_id')@NullableIntConverter() this.rabbitId, @JsonKey(name: 'cage_id')@NullableIntConverter() this.cageId, @JsonKey(name: 'assigned_to')@NullableIntConverter() this.assignedTo, @JsonKey(name: 'is_recurring') this.isRecurring, @JsonKey(name: 'recurrence_rule') this.recurrenceRule, @JsonKey(name: 'reminder_before')@NullableIntConverter() this.reminderBefore, this.notes});
  factory _TaskUpdate.fromJson(Map<String, dynamic> json) => _$TaskUpdateFromJson(json);

@override final  String? title;
@override final  String? description;
@override final  TaskType? type;
@override final  TaskStatus? status;
@override final  TaskPriority? priority;
@override@JsonKey(name: 'due_date')@NullableDateTimeConverter() final  DateTime? dueDate;
@override@JsonKey(name: 'completed_at')@NullableDateTimeConverter() final  DateTime? completedAt;
@override@JsonKey(name: 'rabbit_id')@NullableIntConverter() final  int? rabbitId;
@override@JsonKey(name: 'cage_id')@NullableIntConverter() final  int? cageId;
@override@JsonKey(name: 'assigned_to')@NullableIntConverter() final  int? assignedTo;
@override@JsonKey(name: 'is_recurring') final  bool? isRecurring;
@override@JsonKey(name: 'recurrence_rule') final  String? recurrenceRule;
@override@JsonKey(name: 'reminder_before')@NullableIntConverter() final  int? reminderBefore;
@override final  String? notes;

/// Create a copy of TaskUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskUpdateCopyWith<_TaskUpdate> get copyWith => __$TaskUpdateCopyWithImpl<_TaskUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskUpdate&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.rabbitId, rabbitId) || other.rabbitId == rabbitId)&&(identical(other.cageId, cageId) || other.cageId == cageId)&&(identical(other.assignedTo, assignedTo) || other.assignedTo == assignedTo)&&(identical(other.isRecurring, isRecurring) || other.isRecurring == isRecurring)&&(identical(other.recurrenceRule, recurrenceRule) || other.recurrenceRule == recurrenceRule)&&(identical(other.reminderBefore, reminderBefore) || other.reminderBefore == reminderBefore)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,description,type,status,priority,dueDate,completedAt,rabbitId,cageId,assignedTo,isRecurring,recurrenceRule,reminderBefore,notes);
}

@override
String toString() {
    return 'TaskUpdate(title: $title, description: $description, type: $type, status: $status, priority: $priority, dueDate: $dueDate, completedAt: $completedAt, rabbitId: $rabbitId, cageId: $cageId, assignedTo: $assignedTo, isRecurring: $isRecurring, recurrenceRule: $recurrenceRule, reminderBefore: $reminderBefore, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$TaskUpdateCopyWith<$Res> implements $TaskUpdateCopyWith<$Res> {
  factory _$TaskUpdateCopyWith(_TaskUpdate value, $Res Function(_TaskUpdate) _then) = __$TaskUpdateCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? description, TaskType? type, TaskStatus? status, TaskPriority? priority,@JsonKey(name: 'due_date')@NullableDateTimeConverter() DateTime? dueDate,@JsonKey(name: 'completed_at')@NullableDateTimeConverter() DateTime? completedAt,@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? rabbitId,@JsonKey(name: 'cage_id')@NullableIntConverter() int? cageId,@JsonKey(name: 'assigned_to')@NullableIntConverter() int? assignedTo,@JsonKey(name: 'is_recurring') bool? isRecurring,@JsonKey(name: 'recurrence_rule') String? recurrenceRule,@JsonKey(name: 'reminder_before')@NullableIntConverter() int? reminderBefore, String? notes
});




}
/// @nodoc
class __$TaskUpdateCopyWithImpl<$Res>
    implements _$TaskUpdateCopyWith<$Res> {
  __$TaskUpdateCopyWithImpl(this._self, this._then);

  final _TaskUpdate _self;
  final $Res Function(_TaskUpdate) _then;

/// Create a copy of TaskUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? description = freezed,Object? type = freezed,Object? status = freezed,Object? priority = freezed,Object? dueDate = freezed,Object? completedAt = freezed,Object? rabbitId = freezed,Object? cageId = freezed,Object? assignedTo = freezed,Object? isRecurring = freezed,Object? recurrenceRule = freezed,Object? reminderBefore = freezed,Object? notes = freezed,}) {
  return _then(_TaskUpdate(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskType?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,cageId: freezed == cageId ? _self.cageId : cageId // ignore: cast_nullable_to_non_nullable
as int?,assignedTo: freezed == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as int?,isRecurring: freezed == isRecurring ? _self.isRecurring : isRecurring // ignore: cast_nullable_to_non_nullable
as bool?,recurrenceRule: freezed == recurrenceRule ? _self.recurrenceRule : recurrenceRule // ignore: cast_nullable_to_non_nullable
as String?,reminderBefore: freezed == reminderBefore ? _self.reminderBefore : reminderBefore // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TaskStatistics {

@JsonKey(name: 'total_pending')@IntConverter() int get totalPending;@JsonKey(name: 'total_in_progress')@IntConverter() int get totalInProgress;@JsonKey(name: 'total_completed')@IntConverter() int get totalCompleted;@JsonKey(name: 'total_cancelled')@IntConverter() int get totalCancelled;@JsonKey(name: 'overdue_count')@IntConverter() int get overdueCount;@JsonKey(name: 'today_count')@IntConverter() int get todayCount;@JsonKey(name: 'tasks_by_type') List<TaskTypeCount> get tasksByType;@JsonKey(name: 'tasks_by_priority') List<TaskPriorityCount> get tasksByPriority;
/// Create a copy of TaskStatistics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskStatisticsCopyWith<TaskStatistics> get copyWith => _$TaskStatisticsCopyWithImpl<TaskStatistics>(this as TaskStatistics, _$identity);

  /// Serializes this TaskStatistics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TaskStatistics;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskStatistics&&(identical(other.totalPending, _this.totalPending) || other.totalPending == _this.totalPending)&&(identical(other.totalInProgress, _this.totalInProgress) || other.totalInProgress == _this.totalInProgress)&&(identical(other.totalCompleted, _this.totalCompleted) || other.totalCompleted == _this.totalCompleted)&&(identical(other.totalCancelled, _this.totalCancelled) || other.totalCancelled == _this.totalCancelled)&&(identical(other.overdueCount, _this.overdueCount) || other.overdueCount == _this.overdueCount)&&(identical(other.todayCount, _this.todayCount) || other.todayCount == _this.todayCount)&&const DeepCollectionEquality().equals(other.tasksByType, _this.tasksByType)&&const DeepCollectionEquality().equals(other.tasksByPriority, _this.tasksByPriority));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TaskStatistics;
  return Object.hash(runtimeType,_this.totalPending,_this.totalInProgress,_this.totalCompleted,_this.totalCancelled,_this.overdueCount,_this.todayCount,const DeepCollectionEquality().hash(_this.tasksByType),const DeepCollectionEquality().hash(_this.tasksByPriority));
}

@override
String toString() {
  final _this = this as TaskStatistics;
  return 'TaskStatistics(totalPending: ${_this.totalPending}, totalInProgress: ${_this.totalInProgress}, totalCompleted: ${_this.totalCompleted}, totalCancelled: ${_this.totalCancelled}, overdueCount: ${_this.overdueCount}, todayCount: ${_this.todayCount}, tasksByType: ${_this.tasksByType}, tasksByPriority: ${_this.tasksByPriority})';
}


}

/// @nodoc
abstract mixin class $TaskStatisticsCopyWith<$Res>  {
  factory $TaskStatisticsCopyWith(TaskStatistics value, $Res Function(TaskStatistics) _then) = _$TaskStatisticsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_pending')@IntConverter() int totalPending,@JsonKey(name: 'total_in_progress')@IntConverter() int totalInProgress,@JsonKey(name: 'total_completed')@IntConverter() int totalCompleted,@JsonKey(name: 'total_cancelled')@IntConverter() int totalCancelled,@JsonKey(name: 'overdue_count')@IntConverter() int overdueCount,@JsonKey(name: 'today_count')@IntConverter() int todayCount,@JsonKey(name: 'tasks_by_type') List<TaskTypeCount> tasksByType,@JsonKey(name: 'tasks_by_priority') List<TaskPriorityCount> tasksByPriority
});




}
/// @nodoc
class _$TaskStatisticsCopyWithImpl<$Res>
    implements $TaskStatisticsCopyWith<$Res> {
  _$TaskStatisticsCopyWithImpl(this._self, this._then);

  final TaskStatistics _self;
  final $Res Function(TaskStatistics) _then;

/// Create a copy of TaskStatistics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalPending = null,Object? totalInProgress = null,Object? totalCompleted = null,Object? totalCancelled = null,Object? overdueCount = null,Object? todayCount = null,Object? tasksByType = null,Object? tasksByPriority = null,}) {
  return _then(TaskStatistics(
totalPending: null == totalPending ? _self.totalPending : totalPending // ignore: cast_nullable_to_non_nullable
as int,totalInProgress: null == totalInProgress ? _self.totalInProgress : totalInProgress // ignore: cast_nullable_to_non_nullable
as int,totalCompleted: null == totalCompleted ? _self.totalCompleted : totalCompleted // ignore: cast_nullable_to_non_nullable
as int,totalCancelled: null == totalCancelled ? _self.totalCancelled : totalCancelled // ignore: cast_nullable_to_non_nullable
as int,overdueCount: null == overdueCount ? _self.overdueCount : overdueCount // ignore: cast_nullable_to_non_nullable
as int,todayCount: null == todayCount ? _self.todayCount : todayCount // ignore: cast_nullable_to_non_nullable
as int,tasksByType: null == tasksByType ? _self.tasksByType : tasksByType // ignore: cast_nullable_to_non_nullable
as List<TaskTypeCount>,tasksByPriority: null == tasksByPriority ? _self.tasksByPriority : tasksByPriority // ignore: cast_nullable_to_non_nullable
as List<TaskPriorityCount>,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskStatistics].
extension TaskStatisticsPatterns on TaskStatistics {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskStatistics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskStatistics() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskStatistics value)  $default,){
final _that = this;
switch (_that) {
case _TaskStatistics():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskStatistics value)?  $default,){
final _that = this;
switch (_that) {
case _TaskStatistics() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_pending')@IntConverter()  int totalPending, @JsonKey(name: 'total_in_progress')@IntConverter()  int totalInProgress, @JsonKey(name: 'total_completed')@IntConverter()  int totalCompleted, @JsonKey(name: 'total_cancelled')@IntConverter()  int totalCancelled, @JsonKey(name: 'overdue_count')@IntConverter()  int overdueCount, @JsonKey(name: 'today_count')@IntConverter()  int todayCount, @JsonKey(name: 'tasks_by_type')  List<TaskTypeCount> tasksByType, @JsonKey(name: 'tasks_by_priority')  List<TaskPriorityCount> tasksByPriority)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskStatistics() when $default != null:
return $default(_that.totalPending,_that.totalInProgress,_that.totalCompleted,_that.totalCancelled,_that.overdueCount,_that.todayCount,_that.tasksByType,_that.tasksByPriority);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_pending')@IntConverter()  int totalPending, @JsonKey(name: 'total_in_progress')@IntConverter()  int totalInProgress, @JsonKey(name: 'total_completed')@IntConverter()  int totalCompleted, @JsonKey(name: 'total_cancelled')@IntConverter()  int totalCancelled, @JsonKey(name: 'overdue_count')@IntConverter()  int overdueCount, @JsonKey(name: 'today_count')@IntConverter()  int todayCount, @JsonKey(name: 'tasks_by_type')  List<TaskTypeCount> tasksByType, @JsonKey(name: 'tasks_by_priority')  List<TaskPriorityCount> tasksByPriority)  $default,) {final _that = this;
switch (_that) {
case _TaskStatistics():
return $default(_that.totalPending,_that.totalInProgress,_that.totalCompleted,_that.totalCancelled,_that.overdueCount,_that.todayCount,_that.tasksByType,_that.tasksByPriority);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_pending')@IntConverter()  int totalPending, @JsonKey(name: 'total_in_progress')@IntConverter()  int totalInProgress, @JsonKey(name: 'total_completed')@IntConverter()  int totalCompleted, @JsonKey(name: 'total_cancelled')@IntConverter()  int totalCancelled, @JsonKey(name: 'overdue_count')@IntConverter()  int overdueCount, @JsonKey(name: 'today_count')@IntConverter()  int todayCount, @JsonKey(name: 'tasks_by_type')  List<TaskTypeCount> tasksByType, @JsonKey(name: 'tasks_by_priority')  List<TaskPriorityCount> tasksByPriority)?  $default,) {final _that = this;
switch (_that) {
case _TaskStatistics() when $default != null:
return $default(_that.totalPending,_that.totalInProgress,_that.totalCompleted,_that.totalCancelled,_that.overdueCount,_that.todayCount,_that.tasksByType,_that.tasksByPriority);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskStatistics implements TaskStatistics {
  const _TaskStatistics({@JsonKey(name: 'total_pending')@IntConverter() required this.totalPending, @JsonKey(name: 'total_in_progress')@IntConverter() required this.totalInProgress, @JsonKey(name: 'total_completed')@IntConverter() required this.totalCompleted, @JsonKey(name: 'total_cancelled')@IntConverter() required this.totalCancelled, @JsonKey(name: 'overdue_count')@IntConverter() required this.overdueCount, @JsonKey(name: 'today_count')@IntConverter() required this.todayCount, @JsonKey(name: 'tasks_by_type') required  List<TaskTypeCount> tasksByType, @JsonKey(name: 'tasks_by_priority') required  List<TaskPriorityCount> tasksByPriority}): _tasksByType = tasksByType,_tasksByPriority = tasksByPriority;
  factory _TaskStatistics.fromJson(Map<String, dynamic> json) => _$TaskStatisticsFromJson(json);

@override@JsonKey(name: 'total_pending')@IntConverter() final  int totalPending;
@override@JsonKey(name: 'total_in_progress')@IntConverter() final  int totalInProgress;
@override@JsonKey(name: 'total_completed')@IntConverter() final  int totalCompleted;
@override@JsonKey(name: 'total_cancelled')@IntConverter() final  int totalCancelled;
@override@JsonKey(name: 'overdue_count')@IntConverter() final  int overdueCount;
@override@JsonKey(name: 'today_count')@IntConverter() final  int todayCount;
 final  List<TaskTypeCount> _tasksByType;
@override@JsonKey(name: 'tasks_by_type') List<TaskTypeCount> get tasksByType {
  if (_tasksByType is EqualUnmodifiableListView) return _tasksByType;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasksByType);
}

 final  List<TaskPriorityCount> _tasksByPriority;
@override@JsonKey(name: 'tasks_by_priority') List<TaskPriorityCount> get tasksByPriority {
  if (_tasksByPriority is EqualUnmodifiableListView) return _tasksByPriority;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasksByPriority);
}


/// Create a copy of TaskStatistics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskStatisticsCopyWith<_TaskStatistics> get copyWith => __$TaskStatisticsCopyWithImpl<_TaskStatistics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskStatisticsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskStatistics&&(identical(other.totalPending, totalPending) || other.totalPending == totalPending)&&(identical(other.totalInProgress, totalInProgress) || other.totalInProgress == totalInProgress)&&(identical(other.totalCompleted, totalCompleted) || other.totalCompleted == totalCompleted)&&(identical(other.totalCancelled, totalCancelled) || other.totalCancelled == totalCancelled)&&(identical(other.overdueCount, overdueCount) || other.overdueCount == overdueCount)&&(identical(other.todayCount, todayCount) || other.todayCount == todayCount)&&const DeepCollectionEquality().equals(other.tasksByType, _tasksByType)&&const DeepCollectionEquality().equals(other.tasksByPriority, _tasksByPriority));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalPending,totalInProgress,totalCompleted,totalCancelled,overdueCount,todayCount,const DeepCollectionEquality().hash(_tasksByType),const DeepCollectionEquality().hash(_tasksByPriority));
}

@override
String toString() {
    return 'TaskStatistics(totalPending: $totalPending, totalInProgress: $totalInProgress, totalCompleted: $totalCompleted, totalCancelled: $totalCancelled, overdueCount: $overdueCount, todayCount: $todayCount, tasksByType: $tasksByType, tasksByPriority: $tasksByPriority)';
}


}

/// @nodoc
abstract mixin class _$TaskStatisticsCopyWith<$Res> implements $TaskStatisticsCopyWith<$Res> {
  factory _$TaskStatisticsCopyWith(_TaskStatistics value, $Res Function(_TaskStatistics) _then) = __$TaskStatisticsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_pending')@IntConverter() int totalPending,@JsonKey(name: 'total_in_progress')@IntConverter() int totalInProgress,@JsonKey(name: 'total_completed')@IntConverter() int totalCompleted,@JsonKey(name: 'total_cancelled')@IntConverter() int totalCancelled,@JsonKey(name: 'overdue_count')@IntConverter() int overdueCount,@JsonKey(name: 'today_count')@IntConverter() int todayCount,@JsonKey(name: 'tasks_by_type') List<TaskTypeCount> tasksByType,@JsonKey(name: 'tasks_by_priority') List<TaskPriorityCount> tasksByPriority
});




}
/// @nodoc
class __$TaskStatisticsCopyWithImpl<$Res>
    implements _$TaskStatisticsCopyWith<$Res> {
  __$TaskStatisticsCopyWithImpl(this._self, this._then);

  final _TaskStatistics _self;
  final $Res Function(_TaskStatistics) _then;

/// Create a copy of TaskStatistics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalPending = null,Object? totalInProgress = null,Object? totalCompleted = null,Object? totalCancelled = null,Object? overdueCount = null,Object? todayCount = null,Object? tasksByType = null,Object? tasksByPriority = null,}) {
  return _then(_TaskStatistics(
totalPending: null == totalPending ? _self.totalPending : totalPending // ignore: cast_nullable_to_non_nullable
as int,totalInProgress: null == totalInProgress ? _self.totalInProgress : totalInProgress // ignore: cast_nullable_to_non_nullable
as int,totalCompleted: null == totalCompleted ? _self.totalCompleted : totalCompleted // ignore: cast_nullable_to_non_nullable
as int,totalCancelled: null == totalCancelled ? _self.totalCancelled : totalCancelled // ignore: cast_nullable_to_non_nullable
as int,overdueCount: null == overdueCount ? _self.overdueCount : overdueCount // ignore: cast_nullable_to_non_nullable
as int,todayCount: null == todayCount ? _self.todayCount : todayCount // ignore: cast_nullable_to_non_nullable
as int,tasksByType: null == tasksByType ? _self._tasksByType : tasksByType // ignore: cast_nullable_to_non_nullable
as List<TaskTypeCount>,tasksByPriority: null == tasksByPriority ? _self._tasksByPriority : tasksByPriority // ignore: cast_nullable_to_non_nullable
as List<TaskPriorityCount>,
  ));
}


}


/// @nodoc
mixin _$TaskTypeCount {

 TaskType get type;@IntConverter() int get count;
/// Create a copy of TaskTypeCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskTypeCountCopyWith<TaskTypeCount> get copyWith => _$TaskTypeCountCopyWithImpl<TaskTypeCount>(this as TaskTypeCount, _$identity);

  /// Serializes this TaskTypeCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TaskTypeCount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskTypeCount&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.count, _this.count) || other.count == _this.count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TaskTypeCount;
  return Object.hash(runtimeType,_this.type,_this.count);
}

@override
String toString() {
  final _this = this as TaskTypeCount;
  return 'TaskTypeCount(type: ${_this.type}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $TaskTypeCountCopyWith<$Res>  {
  factory $TaskTypeCountCopyWith(TaskTypeCount value, $Res Function(TaskTypeCount) _then) = _$TaskTypeCountCopyWithImpl;
@useResult
$Res call({
 TaskType type,@IntConverter() int count
});




}
/// @nodoc
class _$TaskTypeCountCopyWithImpl<$Res>
    implements $TaskTypeCountCopyWith<$Res> {
  _$TaskTypeCountCopyWithImpl(this._self, this._then);

  final TaskTypeCount _self;
  final $Res Function(TaskTypeCount) _then;

/// Create a copy of TaskTypeCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? count = null,}) {
  return _then(TaskTypeCount(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskType,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskTypeCount].
extension TaskTypeCountPatterns on TaskTypeCount {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskTypeCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskTypeCount() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskTypeCount value)  $default,){
final _that = this;
switch (_that) {
case _TaskTypeCount():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskTypeCount value)?  $default,){
final _that = this;
switch (_that) {
case _TaskTypeCount() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TaskType type, @IntConverter()  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskTypeCount() when $default != null:
return $default(_that.type,_that.count);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TaskType type, @IntConverter()  int count)  $default,) {final _that = this;
switch (_that) {
case _TaskTypeCount():
return $default(_that.type,_that.count);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TaskType type, @IntConverter()  int count)?  $default,) {final _that = this;
switch (_that) {
case _TaskTypeCount() when $default != null:
return $default(_that.type,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskTypeCount implements TaskTypeCount {
  const _TaskTypeCount({required this.type, @IntConverter() required this.count});
  factory _TaskTypeCount.fromJson(Map<String, dynamic> json) => _$TaskTypeCountFromJson(json);

@override final  TaskType type;
@override@IntConverter() final  int count;

/// Create a copy of TaskTypeCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskTypeCountCopyWith<_TaskTypeCount> get copyWith => __$TaskTypeCountCopyWithImpl<_TaskTypeCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskTypeCountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskTypeCount&&(identical(other.type, type) || other.type == type)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,count);
}

@override
String toString() {
    return 'TaskTypeCount(type: $type, count: $count)';
}


}

/// @nodoc
abstract mixin class _$TaskTypeCountCopyWith<$Res> implements $TaskTypeCountCopyWith<$Res> {
  factory _$TaskTypeCountCopyWith(_TaskTypeCount value, $Res Function(_TaskTypeCount) _then) = __$TaskTypeCountCopyWithImpl;
@override @useResult
$Res call({
 TaskType type,@IntConverter() int count
});




}
/// @nodoc
class __$TaskTypeCountCopyWithImpl<$Res>
    implements _$TaskTypeCountCopyWith<$Res> {
  __$TaskTypeCountCopyWithImpl(this._self, this._then);

  final _TaskTypeCount _self;
  final $Res Function(_TaskTypeCount) _then;

/// Create a copy of TaskTypeCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? count = null,}) {
  return _then(_TaskTypeCount(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskType,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TaskPriorityCount {

 TaskPriority get priority;@IntConverter() int get count;
/// Create a copy of TaskPriorityCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskPriorityCountCopyWith<TaskPriorityCount> get copyWith => _$TaskPriorityCountCopyWithImpl<TaskPriorityCount>(this as TaskPriorityCount, _$identity);

  /// Serializes this TaskPriorityCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TaskPriorityCount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskPriorityCount&&(identical(other.priority, _this.priority) || other.priority == _this.priority)&&(identical(other.count, _this.count) || other.count == _this.count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TaskPriorityCount;
  return Object.hash(runtimeType,_this.priority,_this.count);
}

@override
String toString() {
  final _this = this as TaskPriorityCount;
  return 'TaskPriorityCount(priority: ${_this.priority}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $TaskPriorityCountCopyWith<$Res>  {
  factory $TaskPriorityCountCopyWith(TaskPriorityCount value, $Res Function(TaskPriorityCount) _then) = _$TaskPriorityCountCopyWithImpl;
@useResult
$Res call({
 TaskPriority priority,@IntConverter() int count
});




}
/// @nodoc
class _$TaskPriorityCountCopyWithImpl<$Res>
    implements $TaskPriorityCountCopyWith<$Res> {
  _$TaskPriorityCountCopyWithImpl(this._self, this._then);

  final TaskPriorityCount _self;
  final $Res Function(TaskPriorityCount) _then;

/// Create a copy of TaskPriorityCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? priority = null,Object? count = null,}) {
  return _then(TaskPriorityCount(
priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskPriorityCount].
extension TaskPriorityCountPatterns on TaskPriorityCount {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskPriorityCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskPriorityCount() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskPriorityCount value)  $default,){
final _that = this;
switch (_that) {
case _TaskPriorityCount():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskPriorityCount value)?  $default,){
final _that = this;
switch (_that) {
case _TaskPriorityCount() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TaskPriority priority, @IntConverter()  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskPriorityCount() when $default != null:
return $default(_that.priority,_that.count);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TaskPriority priority, @IntConverter()  int count)  $default,) {final _that = this;
switch (_that) {
case _TaskPriorityCount():
return $default(_that.priority,_that.count);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TaskPriority priority, @IntConverter()  int count)?  $default,) {final _that = this;
switch (_that) {
case _TaskPriorityCount() when $default != null:
return $default(_that.priority,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskPriorityCount implements TaskPriorityCount {
  const _TaskPriorityCount({required this.priority, @IntConverter() required this.count});
  factory _TaskPriorityCount.fromJson(Map<String, dynamic> json) => _$TaskPriorityCountFromJson(json);

@override final  TaskPriority priority;
@override@IntConverter() final  int count;

/// Create a copy of TaskPriorityCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskPriorityCountCopyWith<_TaskPriorityCount> get copyWith => __$TaskPriorityCountCopyWithImpl<_TaskPriorityCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskPriorityCountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskPriorityCount&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,priority,count);
}

@override
String toString() {
    return 'TaskPriorityCount(priority: $priority, count: $count)';
}


}

/// @nodoc
abstract mixin class _$TaskPriorityCountCopyWith<$Res> implements $TaskPriorityCountCopyWith<$Res> {
  factory _$TaskPriorityCountCopyWith(_TaskPriorityCount value, $Res Function(_TaskPriorityCount) _then) = __$TaskPriorityCountCopyWithImpl;
@override @useResult
$Res call({
 TaskPriority priority,@IntConverter() int count
});




}
/// @nodoc
class __$TaskPriorityCountCopyWithImpl<$Res>
    implements _$TaskPriorityCountCopyWith<$Res> {
  __$TaskPriorityCountCopyWithImpl(this._self, this._then);

  final _TaskPriorityCount _self;
  final $Res Function(_TaskPriorityCount) _then;

/// Create a copy of TaskPriorityCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? priority = null,Object? count = null,}) {
  return _then(_TaskPriorityCount(
priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
