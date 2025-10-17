// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rabbit_weight_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RabbitWeight _$RabbitWeightFromJson(Map<String, dynamic> json) {
  return _RabbitWeight.fromJson(json);
}

/// @nodoc
mixin _$RabbitWeight {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'rabbit_id')
  @IntConverter()
  int get rabbitId => throw _privateConstructorUsedError;
  @WeightConverter()
  double get weight => throw _privateConstructorUsedError;
  @JsonKey(name: 'measured_at')
  DateTime get measuredAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this RabbitWeight to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RabbitWeight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RabbitWeightCopyWith<RabbitWeight> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RabbitWeightCopyWith<$Res> {
  factory $RabbitWeightCopyWith(
    RabbitWeight value,
    $Res Function(RabbitWeight) then,
  ) = _$RabbitWeightCopyWithImpl<$Res, RabbitWeight>;
  @useResult
  $Res call({
    @IntConverter() int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() int rabbitId,
    @WeightConverter() double weight,
    @JsonKey(name: 'measured_at') DateTime measuredAt,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$RabbitWeightCopyWithImpl<$Res, $Val extends RabbitWeight>
    implements $RabbitWeightCopyWith<$Res> {
  _$RabbitWeightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RabbitWeight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rabbitId = null,
    Object? weight = null,
    Object? measuredAt = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            rabbitId: null == rabbitId
                ? _value.rabbitId
                : rabbitId // ignore: cast_nullable_to_non_nullable
                      as int,
            weight: null == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as double,
            measuredAt: null == measuredAt
                ? _value.measuredAt
                : measuredAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RabbitWeightImplCopyWith<$Res>
    implements $RabbitWeightCopyWith<$Res> {
  factory _$$RabbitWeightImplCopyWith(
    _$RabbitWeightImpl value,
    $Res Function(_$RabbitWeightImpl) then,
  ) = __$$RabbitWeightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() int rabbitId,
    @WeightConverter() double weight,
    @JsonKey(name: 'measured_at') DateTime measuredAt,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class __$$RabbitWeightImplCopyWithImpl<$Res>
    extends _$RabbitWeightCopyWithImpl<$Res, _$RabbitWeightImpl>
    implements _$$RabbitWeightImplCopyWith<$Res> {
  __$$RabbitWeightImplCopyWithImpl(
    _$RabbitWeightImpl _value,
    $Res Function(_$RabbitWeightImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RabbitWeight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rabbitId = null,
    Object? weight = null,
    Object? measuredAt = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$RabbitWeightImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        rabbitId: null == rabbitId
            ? _value.rabbitId
            : rabbitId // ignore: cast_nullable_to_non_nullable
                  as int,
        weight: null == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as double,
        measuredAt: null == measuredAt
            ? _value.measuredAt
            : measuredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RabbitWeightImpl implements _RabbitWeight {
  const _$RabbitWeightImpl({
    @IntConverter() required this.id,
    @JsonKey(name: 'rabbit_id') @IntConverter() required this.rabbitId,
    @WeightConverter() required this.weight,
    @JsonKey(name: 'measured_at') required this.measuredAt,
    this.notes,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$RabbitWeightImpl.fromJson(Map<String, dynamic> json) =>
      _$$RabbitWeightImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  @JsonKey(name: 'rabbit_id')
  @IntConverter()
  final int rabbitId;
  @override
  @WeightConverter()
  final double weight;
  @override
  @JsonKey(name: 'measured_at')
  final DateTime measuredAt;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'RabbitWeight(id: $id, rabbitId: $rabbitId, weight: $weight, measuredAt: $measuredAt, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RabbitWeightImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rabbitId, rabbitId) ||
                other.rabbitId == rabbitId) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.measuredAt, measuredAt) ||
                other.measuredAt == measuredAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    rabbitId,
    weight,
    measuredAt,
    notes,
    createdAt,
  );

  /// Create a copy of RabbitWeight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RabbitWeightImplCopyWith<_$RabbitWeightImpl> get copyWith =>
      __$$RabbitWeightImplCopyWithImpl<_$RabbitWeightImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RabbitWeightImplToJson(this);
  }
}

abstract class _RabbitWeight implements RabbitWeight {
  const factory _RabbitWeight({
    @IntConverter() required final int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() required final int rabbitId,
    @WeightConverter() required final double weight,
    @JsonKey(name: 'measured_at') required final DateTime measuredAt,
    final String? notes,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$RabbitWeightImpl;

  factory _RabbitWeight.fromJson(Map<String, dynamic> json) =
      _$RabbitWeightImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  @JsonKey(name: 'rabbit_id')
  @IntConverter()
  int get rabbitId;
  @override
  @WeightConverter()
  double get weight;
  @override
  @JsonKey(name: 'measured_at')
  DateTime get measuredAt;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of RabbitWeight
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RabbitWeightImplCopyWith<_$RabbitWeightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
