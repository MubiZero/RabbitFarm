// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardConfig _$DashboardConfigFromJson(Map<String, dynamic> json) {
  return _DashboardConfig.fromJson(json);
}

/// @nodoc
mixin _$DashboardConfig {
  List<WidgetConfig> get widgets => throw _privateConstructorUsedError;
  List<QuickActionConfig> get quickActions =>
      throw _privateConstructorUsedError;

  /// Serializes this DashboardConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardConfigCopyWith<DashboardConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardConfigCopyWith<$Res> {
  factory $DashboardConfigCopyWith(
    DashboardConfig value,
    $Res Function(DashboardConfig) then,
  ) = _$DashboardConfigCopyWithImpl<$Res, DashboardConfig>;
  @useResult
  $Res call({List<WidgetConfig> widgets, List<QuickActionConfig> quickActions});
}

/// @nodoc
class _$DashboardConfigCopyWithImpl<$Res, $Val extends DashboardConfig>
    implements $DashboardConfigCopyWith<$Res> {
  _$DashboardConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? widgets = null, Object? quickActions = null}) {
    return _then(
      _value.copyWith(
            widgets: null == widgets
                ? _value.widgets
                : widgets // ignore: cast_nullable_to_non_nullable
                      as List<WidgetConfig>,
            quickActions: null == quickActions
                ? _value.quickActions
                : quickActions // ignore: cast_nullable_to_non_nullable
                      as List<QuickActionConfig>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardConfigImplCopyWith<$Res>
    implements $DashboardConfigCopyWith<$Res> {
  factory _$$DashboardConfigImplCopyWith(
    _$DashboardConfigImpl value,
    $Res Function(_$DashboardConfigImpl) then,
  ) = __$$DashboardConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<WidgetConfig> widgets, List<QuickActionConfig> quickActions});
}

/// @nodoc
class __$$DashboardConfigImplCopyWithImpl<$Res>
    extends _$DashboardConfigCopyWithImpl<$Res, _$DashboardConfigImpl>
    implements _$$DashboardConfigImplCopyWith<$Res> {
  __$$DashboardConfigImplCopyWithImpl(
    _$DashboardConfigImpl _value,
    $Res Function(_$DashboardConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? widgets = null, Object? quickActions = null}) {
    return _then(
      _$DashboardConfigImpl(
        widgets: null == widgets
            ? _value._widgets
            : widgets // ignore: cast_nullable_to_non_nullable
                  as List<WidgetConfig>,
        quickActions: null == quickActions
            ? _value._quickActions
            : quickActions // ignore: cast_nullable_to_non_nullable
                  as List<QuickActionConfig>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardConfigImpl implements _DashboardConfig {
  const _$DashboardConfigImpl({
    final List<WidgetConfig> widgets = const [],
    final List<QuickActionConfig> quickActions = const [],
  }) : _widgets = widgets,
       _quickActions = quickActions;

  factory _$DashboardConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardConfigImplFromJson(json);

  final List<WidgetConfig> _widgets;
  @override
  @JsonKey()
  List<WidgetConfig> get widgets {
    if (_widgets is EqualUnmodifiableListView) return _widgets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_widgets);
  }

  final List<QuickActionConfig> _quickActions;
  @override
  @JsonKey()
  List<QuickActionConfig> get quickActions {
    if (_quickActions is EqualUnmodifiableListView) return _quickActions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_quickActions);
  }

  @override
  String toString() {
    return 'DashboardConfig(widgets: $widgets, quickActions: $quickActions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardConfigImpl &&
            const DeepCollectionEquality().equals(other._widgets, _widgets) &&
            const DeepCollectionEquality().equals(
              other._quickActions,
              _quickActions,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_widgets),
    const DeepCollectionEquality().hash(_quickActions),
  );

  /// Create a copy of DashboardConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardConfigImplCopyWith<_$DashboardConfigImpl> get copyWith =>
      __$$DashboardConfigImplCopyWithImpl<_$DashboardConfigImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardConfigImplToJson(this);
  }
}

abstract class _DashboardConfig implements DashboardConfig {
  const factory _DashboardConfig({
    final List<WidgetConfig> widgets,
    final List<QuickActionConfig> quickActions,
  }) = _$DashboardConfigImpl;

  factory _DashboardConfig.fromJson(Map<String, dynamic> json) =
      _$DashboardConfigImpl.fromJson;

  @override
  List<WidgetConfig> get widgets;
  @override
  List<QuickActionConfig> get quickActions;

  /// Create a copy of DashboardConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardConfigImplCopyWith<_$DashboardConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WidgetConfig _$WidgetConfigFromJson(Map<String, dynamic> json) {
  return _WidgetConfig.fromJson(json);
}

/// @nodoc
mixin _$WidgetConfig {
  WidgetType get type => throw _privateConstructorUsedError;
  bool get isVisible => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;

  /// Serializes this WidgetConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WidgetConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WidgetConfigCopyWith<WidgetConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WidgetConfigCopyWith<$Res> {
  factory $WidgetConfigCopyWith(
    WidgetConfig value,
    $Res Function(WidgetConfig) then,
  ) = _$WidgetConfigCopyWithImpl<$Res, WidgetConfig>;
  @useResult
  $Res call({WidgetType type, bool isVisible, int order});
}

/// @nodoc
class _$WidgetConfigCopyWithImpl<$Res, $Val extends WidgetConfig>
    implements $WidgetConfigCopyWith<$Res> {
  _$WidgetConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WidgetConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? isVisible = null,
    Object? order = null,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as WidgetType,
            isVisible: null == isVisible
                ? _value.isVisible
                : isVisible // ignore: cast_nullable_to_non_nullable
                      as bool,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WidgetConfigImplCopyWith<$Res>
    implements $WidgetConfigCopyWith<$Res> {
  factory _$$WidgetConfigImplCopyWith(
    _$WidgetConfigImpl value,
    $Res Function(_$WidgetConfigImpl) then,
  ) = __$$WidgetConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({WidgetType type, bool isVisible, int order});
}

/// @nodoc
class __$$WidgetConfigImplCopyWithImpl<$Res>
    extends _$WidgetConfigCopyWithImpl<$Res, _$WidgetConfigImpl>
    implements _$$WidgetConfigImplCopyWith<$Res> {
  __$$WidgetConfigImplCopyWithImpl(
    _$WidgetConfigImpl _value,
    $Res Function(_$WidgetConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WidgetConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? isVisible = null,
    Object? order = null,
  }) {
    return _then(
      _$WidgetConfigImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as WidgetType,
        isVisible: null == isVisible
            ? _value.isVisible
            : isVisible // ignore: cast_nullable_to_non_nullable
                  as bool,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WidgetConfigImpl implements _WidgetConfig {
  const _$WidgetConfigImpl({
    required this.type,
    required this.isVisible,
    required this.order,
  });

  factory _$WidgetConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$WidgetConfigImplFromJson(json);

  @override
  final WidgetType type;
  @override
  final bool isVisible;
  @override
  final int order;

  @override
  String toString() {
    return 'WidgetConfig(type: $type, isVisible: $isVisible, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WidgetConfigImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, isVisible, order);

  /// Create a copy of WidgetConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WidgetConfigImplCopyWith<_$WidgetConfigImpl> get copyWith =>
      __$$WidgetConfigImplCopyWithImpl<_$WidgetConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WidgetConfigImplToJson(this);
  }
}

abstract class _WidgetConfig implements WidgetConfig {
  const factory _WidgetConfig({
    required final WidgetType type,
    required final bool isVisible,
    required final int order,
  }) = _$WidgetConfigImpl;

  factory _WidgetConfig.fromJson(Map<String, dynamic> json) =
      _$WidgetConfigImpl.fromJson;

  @override
  WidgetType get type;
  @override
  bool get isVisible;
  @override
  int get order;

  /// Create a copy of WidgetConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WidgetConfigImplCopyWith<_$WidgetConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuickActionConfig _$QuickActionConfigFromJson(Map<String, dynamic> json) {
  return _QuickActionConfig.fromJson(json);
}

/// @nodoc
mixin _$QuickActionConfig {
  QuickActionType get type => throw _privateConstructorUsedError;
  bool get isVisible => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;

  /// Serializes this QuickActionConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuickActionConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuickActionConfigCopyWith<QuickActionConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuickActionConfigCopyWith<$Res> {
  factory $QuickActionConfigCopyWith(
    QuickActionConfig value,
    $Res Function(QuickActionConfig) then,
  ) = _$QuickActionConfigCopyWithImpl<$Res, QuickActionConfig>;
  @useResult
  $Res call({QuickActionType type, bool isVisible, int order});
}

/// @nodoc
class _$QuickActionConfigCopyWithImpl<$Res, $Val extends QuickActionConfig>
    implements $QuickActionConfigCopyWith<$Res> {
  _$QuickActionConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuickActionConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? isVisible = null,
    Object? order = null,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as QuickActionType,
            isVisible: null == isVisible
                ? _value.isVisible
                : isVisible // ignore: cast_nullable_to_non_nullable
                      as bool,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuickActionConfigImplCopyWith<$Res>
    implements $QuickActionConfigCopyWith<$Res> {
  factory _$$QuickActionConfigImplCopyWith(
    _$QuickActionConfigImpl value,
    $Res Function(_$QuickActionConfigImpl) then,
  ) = __$$QuickActionConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({QuickActionType type, bool isVisible, int order});
}

/// @nodoc
class __$$QuickActionConfigImplCopyWithImpl<$Res>
    extends _$QuickActionConfigCopyWithImpl<$Res, _$QuickActionConfigImpl>
    implements _$$QuickActionConfigImplCopyWith<$Res> {
  __$$QuickActionConfigImplCopyWithImpl(
    _$QuickActionConfigImpl _value,
    $Res Function(_$QuickActionConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuickActionConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? isVisible = null,
    Object? order = null,
  }) {
    return _then(
      _$QuickActionConfigImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as QuickActionType,
        isVisible: null == isVisible
            ? _value.isVisible
            : isVisible // ignore: cast_nullable_to_non_nullable
                  as bool,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuickActionConfigImpl implements _QuickActionConfig {
  const _$QuickActionConfigImpl({
    required this.type,
    required this.isVisible,
    required this.order,
  });

  factory _$QuickActionConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuickActionConfigImplFromJson(json);

  @override
  final QuickActionType type;
  @override
  final bool isVisible;
  @override
  final int order;

  @override
  String toString() {
    return 'QuickActionConfig(type: $type, isVisible: $isVisible, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuickActionConfigImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, isVisible, order);

  /// Create a copy of QuickActionConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuickActionConfigImplCopyWith<_$QuickActionConfigImpl> get copyWith =>
      __$$QuickActionConfigImplCopyWithImpl<_$QuickActionConfigImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$QuickActionConfigImplToJson(this);
  }
}

abstract class _QuickActionConfig implements QuickActionConfig {
  const factory _QuickActionConfig({
    required final QuickActionType type,
    required final bool isVisible,
    required final int order,
  }) = _$QuickActionConfigImpl;

  factory _QuickActionConfig.fromJson(Map<String, dynamic> json) =
      _$QuickActionConfigImpl.fromJson;

  @override
  QuickActionType get type;
  @override
  bool get isVisible;
  @override
  int get order;

  /// Create a copy of QuickActionConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuickActionConfigImplCopyWith<_$QuickActionConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
