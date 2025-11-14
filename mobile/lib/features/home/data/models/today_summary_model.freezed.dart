// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'today_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TodaySummary _$TodaySummaryFromJson(Map<String, dynamic> json) {
  return _TodaySummary.fromJson(json);
}

/// @nodoc
mixin _$TodaySummary {
  TasksSummary get tasks => throw _privateConstructorUsedError;
  FeedingSummary get feeding => throw _privateConstructorUsedError;
  List<Alert> get alerts => throw _privateConstructorUsedError;
  List<Task> get todayTasks => throw _privateConstructorUsedError;

  /// Serializes this TodaySummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TodaySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TodaySummaryCopyWith<TodaySummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodaySummaryCopyWith<$Res> {
  factory $TodaySummaryCopyWith(
    TodaySummary value,
    $Res Function(TodaySummary) then,
  ) = _$TodaySummaryCopyWithImpl<$Res, TodaySummary>;
  @useResult
  $Res call({
    TasksSummary tasks,
    FeedingSummary feeding,
    List<Alert> alerts,
    List<Task> todayTasks,
  });

  $TasksSummaryCopyWith<$Res> get tasks;
  $FeedingSummaryCopyWith<$Res> get feeding;
}

/// @nodoc
class _$TodaySummaryCopyWithImpl<$Res, $Val extends TodaySummary>
    implements $TodaySummaryCopyWith<$Res> {
  _$TodaySummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TodaySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tasks = null,
    Object? feeding = null,
    Object? alerts = null,
    Object? todayTasks = null,
  }) {
    return _then(
      _value.copyWith(
            tasks: null == tasks
                ? _value.tasks
                : tasks // ignore: cast_nullable_to_non_nullable
                      as TasksSummary,
            feeding: null == feeding
                ? _value.feeding
                : feeding // ignore: cast_nullable_to_non_nullable
                      as FeedingSummary,
            alerts: null == alerts
                ? _value.alerts
                : alerts // ignore: cast_nullable_to_non_nullable
                      as List<Alert>,
            todayTasks: null == todayTasks
                ? _value.todayTasks
                : todayTasks // ignore: cast_nullable_to_non_nullable
                      as List<Task>,
          )
          as $Val,
    );
  }

  /// Create a copy of TodaySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TasksSummaryCopyWith<$Res> get tasks {
    return $TasksSummaryCopyWith<$Res>(_value.tasks, (value) {
      return _then(_value.copyWith(tasks: value) as $Val);
    });
  }

  /// Create a copy of TodaySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FeedingSummaryCopyWith<$Res> get feeding {
    return $FeedingSummaryCopyWith<$Res>(_value.feeding, (value) {
      return _then(_value.copyWith(feeding: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TodaySummaryImplCopyWith<$Res>
    implements $TodaySummaryCopyWith<$Res> {
  factory _$$TodaySummaryImplCopyWith(
    _$TodaySummaryImpl value,
    $Res Function(_$TodaySummaryImpl) then,
  ) = __$$TodaySummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    TasksSummary tasks,
    FeedingSummary feeding,
    List<Alert> alerts,
    List<Task> todayTasks,
  });

  @override
  $TasksSummaryCopyWith<$Res> get tasks;
  @override
  $FeedingSummaryCopyWith<$Res> get feeding;
}

/// @nodoc
class __$$TodaySummaryImplCopyWithImpl<$Res>
    extends _$TodaySummaryCopyWithImpl<$Res, _$TodaySummaryImpl>
    implements _$$TodaySummaryImplCopyWith<$Res> {
  __$$TodaySummaryImplCopyWithImpl(
    _$TodaySummaryImpl _value,
    $Res Function(_$TodaySummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TodaySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tasks = null,
    Object? feeding = null,
    Object? alerts = null,
    Object? todayTasks = null,
  }) {
    return _then(
      _$TodaySummaryImpl(
        tasks: null == tasks
            ? _value.tasks
            : tasks // ignore: cast_nullable_to_non_nullable
                  as TasksSummary,
        feeding: null == feeding
            ? _value.feeding
            : feeding // ignore: cast_nullable_to_non_nullable
                  as FeedingSummary,
        alerts: null == alerts
            ? _value._alerts
            : alerts // ignore: cast_nullable_to_non_nullable
                  as List<Alert>,
        todayTasks: null == todayTasks
            ? _value._todayTasks
            : todayTasks // ignore: cast_nullable_to_non_nullable
                  as List<Task>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TodaySummaryImpl implements _TodaySummary {
  const _$TodaySummaryImpl({
    required this.tasks,
    required this.feeding,
    required final List<Alert> alerts,
    required final List<Task> todayTasks,
  }) : _alerts = alerts,
       _todayTasks = todayTasks;

  factory _$TodaySummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TodaySummaryImplFromJson(json);

  @override
  final TasksSummary tasks;
  @override
  final FeedingSummary feeding;
  final List<Alert> _alerts;
  @override
  List<Alert> get alerts {
    if (_alerts is EqualUnmodifiableListView) return _alerts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alerts);
  }

  final List<Task> _todayTasks;
  @override
  List<Task> get todayTasks {
    if (_todayTasks is EqualUnmodifiableListView) return _todayTasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_todayTasks);
  }

  @override
  String toString() {
    return 'TodaySummary(tasks: $tasks, feeding: $feeding, alerts: $alerts, todayTasks: $todayTasks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TodaySummaryImpl &&
            (identical(other.tasks, tasks) || other.tasks == tasks) &&
            (identical(other.feeding, feeding) || other.feeding == feeding) &&
            const DeepCollectionEquality().equals(other._alerts, _alerts) &&
            const DeepCollectionEquality().equals(
              other._todayTasks,
              _todayTasks,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    tasks,
    feeding,
    const DeepCollectionEquality().hash(_alerts),
    const DeepCollectionEquality().hash(_todayTasks),
  );

  /// Create a copy of TodaySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TodaySummaryImplCopyWith<_$TodaySummaryImpl> get copyWith =>
      __$$TodaySummaryImplCopyWithImpl<_$TodaySummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TodaySummaryImplToJson(this);
  }
}

abstract class _TodaySummary implements TodaySummary {
  const factory _TodaySummary({
    required final TasksSummary tasks,
    required final FeedingSummary feeding,
    required final List<Alert> alerts,
    required final List<Task> todayTasks,
  }) = _$TodaySummaryImpl;

  factory _TodaySummary.fromJson(Map<String, dynamic> json) =
      _$TodaySummaryImpl.fromJson;

  @override
  TasksSummary get tasks;
  @override
  FeedingSummary get feeding;
  @override
  List<Alert> get alerts;
  @override
  List<Task> get todayTasks;

  /// Create a copy of TodaySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TodaySummaryImplCopyWith<_$TodaySummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TasksSummary _$TasksSummaryFromJson(Map<String, dynamic> json) {
  return _TasksSummary.fromJson(json);
}

/// @nodoc
mixin _$TasksSummary {
  @JsonKey(name: 'total_today')
  @IntConverter()
  int get totalToday => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_today')
  @IntConverter()
  int get completedToday => throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_today')
  @IntConverter()
  int get pendingToday => throw _privateConstructorUsedError;

  /// Serializes this TasksSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TasksSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TasksSummaryCopyWith<TasksSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TasksSummaryCopyWith<$Res> {
  factory $TasksSummaryCopyWith(
    TasksSummary value,
    $Res Function(TasksSummary) then,
  ) = _$TasksSummaryCopyWithImpl<$Res, TasksSummary>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_today') @IntConverter() int totalToday,
    @JsonKey(name: 'completed_today') @IntConverter() int completedToday,
    @JsonKey(name: 'pending_today') @IntConverter() int pendingToday,
  });
}

/// @nodoc
class _$TasksSummaryCopyWithImpl<$Res, $Val extends TasksSummary>
    implements $TasksSummaryCopyWith<$Res> {
  _$TasksSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TasksSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalToday = null,
    Object? completedToday = null,
    Object? pendingToday = null,
  }) {
    return _then(
      _value.copyWith(
            totalToday: null == totalToday
                ? _value.totalToday
                : totalToday // ignore: cast_nullable_to_non_nullable
                      as int,
            completedToday: null == completedToday
                ? _value.completedToday
                : completedToday // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingToday: null == pendingToday
                ? _value.pendingToday
                : pendingToday // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TasksSummaryImplCopyWith<$Res>
    implements $TasksSummaryCopyWith<$Res> {
  factory _$$TasksSummaryImplCopyWith(
    _$TasksSummaryImpl value,
    $Res Function(_$TasksSummaryImpl) then,
  ) = __$$TasksSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_today') @IntConverter() int totalToday,
    @JsonKey(name: 'completed_today') @IntConverter() int completedToday,
    @JsonKey(name: 'pending_today') @IntConverter() int pendingToday,
  });
}

/// @nodoc
class __$$TasksSummaryImplCopyWithImpl<$Res>
    extends _$TasksSummaryCopyWithImpl<$Res, _$TasksSummaryImpl>
    implements _$$TasksSummaryImplCopyWith<$Res> {
  __$$TasksSummaryImplCopyWithImpl(
    _$TasksSummaryImpl _value,
    $Res Function(_$TasksSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TasksSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalToday = null,
    Object? completedToday = null,
    Object? pendingToday = null,
  }) {
    return _then(
      _$TasksSummaryImpl(
        totalToday: null == totalToday
            ? _value.totalToday
            : totalToday // ignore: cast_nullable_to_non_nullable
                  as int,
        completedToday: null == completedToday
            ? _value.completedToday
            : completedToday // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingToday: null == pendingToday
            ? _value.pendingToday
            : pendingToday // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TasksSummaryImpl implements _TasksSummary {
  const _$TasksSummaryImpl({
    @JsonKey(name: 'total_today') @IntConverter() required this.totalToday,
    @JsonKey(name: 'completed_today')
    @IntConverter()
    required this.completedToday,
    @JsonKey(name: 'pending_today') @IntConverter() required this.pendingToday,
  });

  factory _$TasksSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TasksSummaryImplFromJson(json);

  @override
  @JsonKey(name: 'total_today')
  @IntConverter()
  final int totalToday;
  @override
  @JsonKey(name: 'completed_today')
  @IntConverter()
  final int completedToday;
  @override
  @JsonKey(name: 'pending_today')
  @IntConverter()
  final int pendingToday;

  @override
  String toString() {
    return 'TasksSummary(totalToday: $totalToday, completedToday: $completedToday, pendingToday: $pendingToday)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TasksSummaryImpl &&
            (identical(other.totalToday, totalToday) ||
                other.totalToday == totalToday) &&
            (identical(other.completedToday, completedToday) ||
                other.completedToday == completedToday) &&
            (identical(other.pendingToday, pendingToday) ||
                other.pendingToday == pendingToday));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, totalToday, completedToday, pendingToday);

  /// Create a copy of TasksSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TasksSummaryImplCopyWith<_$TasksSummaryImpl> get copyWith =>
      __$$TasksSummaryImplCopyWithImpl<_$TasksSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TasksSummaryImplToJson(this);
  }
}

abstract class _TasksSummary implements TasksSummary {
  const factory _TasksSummary({
    @JsonKey(name: 'total_today') @IntConverter() required final int totalToday,
    @JsonKey(name: 'completed_today')
    @IntConverter()
    required final int completedToday,
    @JsonKey(name: 'pending_today')
    @IntConverter()
    required final int pendingToday,
  }) = _$TasksSummaryImpl;

  factory _TasksSummary.fromJson(Map<String, dynamic> json) =
      _$TasksSummaryImpl.fromJson;

  @override
  @JsonKey(name: 'total_today')
  @IntConverter()
  int get totalToday;
  @override
  @JsonKey(name: 'completed_today')
  @IntConverter()
  int get completedToday;
  @override
  @JsonKey(name: 'pending_today')
  @IntConverter()
  int get pendingToday;

  /// Create a copy of TasksSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TasksSummaryImplCopyWith<_$TasksSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedingSummary _$FeedingSummaryFromJson(Map<String, dynamic> json) {
  return _FeedingSummary.fromJson(json);
}

/// @nodoc
mixin _$FeedingSummary {
  @JsonKey(name: 'count_today')
  @IntConverter()
  int get countToday => throw _privateConstructorUsedError;

  /// Serializes this FeedingSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeedingSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedingSummaryCopyWith<FeedingSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedingSummaryCopyWith<$Res> {
  factory $FeedingSummaryCopyWith(
    FeedingSummary value,
    $Res Function(FeedingSummary) then,
  ) = _$FeedingSummaryCopyWithImpl<$Res, FeedingSummary>;
  @useResult
  $Res call({@JsonKey(name: 'count_today') @IntConverter() int countToday});
}

/// @nodoc
class _$FeedingSummaryCopyWithImpl<$Res, $Val extends FeedingSummary>
    implements $FeedingSummaryCopyWith<$Res> {
  _$FeedingSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedingSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? countToday = null}) {
    return _then(
      _value.copyWith(
            countToday: null == countToday
                ? _value.countToday
                : countToday // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeedingSummaryImplCopyWith<$Res>
    implements $FeedingSummaryCopyWith<$Res> {
  factory _$$FeedingSummaryImplCopyWith(
    _$FeedingSummaryImpl value,
    $Res Function(_$FeedingSummaryImpl) then,
  ) = __$$FeedingSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'count_today') @IntConverter() int countToday});
}

/// @nodoc
class __$$FeedingSummaryImplCopyWithImpl<$Res>
    extends _$FeedingSummaryCopyWithImpl<$Res, _$FeedingSummaryImpl>
    implements _$$FeedingSummaryImplCopyWith<$Res> {
  __$$FeedingSummaryImplCopyWithImpl(
    _$FeedingSummaryImpl _value,
    $Res Function(_$FeedingSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedingSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? countToday = null}) {
    return _then(
      _$FeedingSummaryImpl(
        countToday: null == countToday
            ? _value.countToday
            : countToday // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedingSummaryImpl implements _FeedingSummary {
  const _$FeedingSummaryImpl({
    @JsonKey(name: 'count_today') @IntConverter() required this.countToday,
  });

  factory _$FeedingSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedingSummaryImplFromJson(json);

  @override
  @JsonKey(name: 'count_today')
  @IntConverter()
  final int countToday;

  @override
  String toString() {
    return 'FeedingSummary(countToday: $countToday)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedingSummaryImpl &&
            (identical(other.countToday, countToday) ||
                other.countToday == countToday));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, countToday);

  /// Create a copy of FeedingSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedingSummaryImplCopyWith<_$FeedingSummaryImpl> get copyWith =>
      __$$FeedingSummaryImplCopyWithImpl<_$FeedingSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedingSummaryImplToJson(this);
  }
}

abstract class _FeedingSummary implements FeedingSummary {
  const factory _FeedingSummary({
    @JsonKey(name: 'count_today') @IntConverter() required final int countToday,
  }) = _$FeedingSummaryImpl;

  factory _FeedingSummary.fromJson(Map<String, dynamic> json) =
      _$FeedingSummaryImpl.fromJson;

  @override
  @JsonKey(name: 'count_today')
  @IntConverter()
  int get countToday;

  /// Create a copy of FeedingSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedingSummaryImplCopyWith<_$FeedingSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Alert _$AlertFromJson(Map<String, dynamic> json) {
  return _Alert.fromJson(json);
}

/// @nodoc
mixin _$Alert {
  AlertType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  AlertPriority get priority => throw _privateConstructorUsedError;
  String? get route => throw _privateConstructorUsedError;

  /// Serializes this Alert to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertCopyWith<Alert> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertCopyWith<$Res> {
  factory $AlertCopyWith(Alert value, $Res Function(Alert) then) =
      _$AlertCopyWithImpl<$Res, Alert>;
  @useResult
  $Res call({
    AlertType type,
    String title,
    String message,
    AlertPriority priority,
    String? route,
  });
}

/// @nodoc
class _$AlertCopyWithImpl<$Res, $Val extends Alert>
    implements $AlertCopyWith<$Res> {
  _$AlertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? message = null,
    Object? priority = null,
    Object? route = freezed,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as AlertType,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as AlertPriority,
            route: freezed == route
                ? _value.route
                : route // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AlertImplCopyWith<$Res> implements $AlertCopyWith<$Res> {
  factory _$$AlertImplCopyWith(
    _$AlertImpl value,
    $Res Function(_$AlertImpl) then,
  ) = __$$AlertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AlertType type,
    String title,
    String message,
    AlertPriority priority,
    String? route,
  });
}

/// @nodoc
class __$$AlertImplCopyWithImpl<$Res>
    extends _$AlertCopyWithImpl<$Res, _$AlertImpl>
    implements _$$AlertImplCopyWith<$Res> {
  __$$AlertImplCopyWithImpl(
    _$AlertImpl _value,
    $Res Function(_$AlertImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? message = null,
    Object? priority = null,
    Object? route = freezed,
  }) {
    return _then(
      _$AlertImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as AlertType,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as AlertPriority,
        route: freezed == route
            ? _value.route
            : route // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AlertImpl implements _Alert {
  const _$AlertImpl({
    required this.type,
    required this.title,
    required this.message,
    required this.priority,
    this.route,
  });

  factory _$AlertImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertImplFromJson(json);

  @override
  final AlertType type;
  @override
  final String title;
  @override
  final String message;
  @override
  final AlertPriority priority;
  @override
  final String? route;

  @override
  String toString() {
    return 'Alert(type: $type, title: $title, message: $message, priority: $priority, route: $route)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.route, route) || other.route == route));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, type, title, message, priority, route);

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertImplCopyWith<_$AlertImpl> get copyWith =>
      __$$AlertImplCopyWithImpl<_$AlertImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertImplToJson(this);
  }
}

abstract class _Alert implements Alert {
  const factory _Alert({
    required final AlertType type,
    required final String title,
    required final String message,
    required final AlertPriority priority,
    final String? route,
  }) = _$AlertImpl;

  factory _Alert.fromJson(Map<String, dynamic> json) = _$AlertImpl.fromJson;

  @override
  AlertType get type;
  @override
  String get title;
  @override
  String get message;
  @override
  AlertPriority get priority;
  @override
  String? get route;

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertImplCopyWith<_$AlertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
