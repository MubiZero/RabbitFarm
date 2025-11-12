// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feeding_record_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FeedingRecord _$FeedingRecordFromJson(Map<String, dynamic> json) {
  return _FeedingRecord.fromJson(json);
}

/// @nodoc
mixin _$FeedingRecord {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'rabbit_id')
  @IntConverter()
  int? get rabbitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'feed_id')
  @IntConverter()
  int get feedId => throw _privateConstructorUsedError;
  @JsonKey(name: 'cage_id')
  @IntConverter()
  int? get cageId => throw _privateConstructorUsedError;
  @DoubleConverter()
  double get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'fed_at')
  DateTime get fedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'fed_by')
  @IntConverter()
  int? get fedBy => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Feed? get feed => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  RabbitModel? get rabbit => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  CageModel? get cage => throw _privateConstructorUsedError;

  /// Serializes this FeedingRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeedingRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedingRecordCopyWith<FeedingRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedingRecordCopyWith<$Res> {
  factory $FeedingRecordCopyWith(
    FeedingRecord value,
    $Res Function(FeedingRecord) then,
  ) = _$FeedingRecordCopyWithImpl<$Res, FeedingRecord>;
  @useResult
  $Res call({
    @IntConverter() int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() int? rabbitId,
    @JsonKey(name: 'feed_id') @IntConverter() int feedId,
    @JsonKey(name: 'cage_id') @IntConverter() int? cageId,
    @DoubleConverter() double quantity,
    @JsonKey(name: 'fed_at') DateTime fedAt,
    @JsonKey(name: 'fed_by') @IntConverter() int? fedBy,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(includeFromJson: false, includeToJson: false) Feed? feed,
    @JsonKey(includeFromJson: false, includeToJson: false) RabbitModel? rabbit,
    @JsonKey(includeFromJson: false, includeToJson: false) CageModel? cage,
  });

  $FeedCopyWith<$Res>? get feed;
  $RabbitModelCopyWith<$Res>? get rabbit;
  $CageModelCopyWith<$Res>? get cage;
}

/// @nodoc
class _$FeedingRecordCopyWithImpl<$Res, $Val extends FeedingRecord>
    implements $FeedingRecordCopyWith<$Res> {
  _$FeedingRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedingRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rabbitId = freezed,
    Object? feedId = null,
    Object? cageId = freezed,
    Object? quantity = null,
    Object? fedAt = null,
    Object? fedBy = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? feed = freezed,
    Object? rabbit = freezed,
    Object? cage = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            rabbitId: freezed == rabbitId
                ? _value.rabbitId
                : rabbitId // ignore: cast_nullable_to_non_nullable
                      as int?,
            feedId: null == feedId
                ? _value.feedId
                : feedId // ignore: cast_nullable_to_non_nullable
                      as int,
            cageId: freezed == cageId
                ? _value.cageId
                : cageId // ignore: cast_nullable_to_non_nullable
                      as int?,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double,
            fedAt: null == fedAt
                ? _value.fedAt
                : fedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            fedBy: freezed == fedBy
                ? _value.fedBy
                : fedBy // ignore: cast_nullable_to_non_nullable
                      as int?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            feed: freezed == feed
                ? _value.feed
                : feed // ignore: cast_nullable_to_non_nullable
                      as Feed?,
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

  /// Create a copy of FeedingRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FeedCopyWith<$Res>? get feed {
    if (_value.feed == null) {
      return null;
    }

    return $FeedCopyWith<$Res>(_value.feed!, (value) {
      return _then(_value.copyWith(feed: value) as $Val);
    });
  }

  /// Create a copy of FeedingRecord
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

  /// Create a copy of FeedingRecord
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
abstract class _$$FeedingRecordImplCopyWith<$Res>
    implements $FeedingRecordCopyWith<$Res> {
  factory _$$FeedingRecordImplCopyWith(
    _$FeedingRecordImpl value,
    $Res Function(_$FeedingRecordImpl) then,
  ) = __$$FeedingRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() int? rabbitId,
    @JsonKey(name: 'feed_id') @IntConverter() int feedId,
    @JsonKey(name: 'cage_id') @IntConverter() int? cageId,
    @DoubleConverter() double quantity,
    @JsonKey(name: 'fed_at') DateTime fedAt,
    @JsonKey(name: 'fed_by') @IntConverter() int? fedBy,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(includeFromJson: false, includeToJson: false) Feed? feed,
    @JsonKey(includeFromJson: false, includeToJson: false) RabbitModel? rabbit,
    @JsonKey(includeFromJson: false, includeToJson: false) CageModel? cage,
  });

  @override
  $FeedCopyWith<$Res>? get feed;
  @override
  $RabbitModelCopyWith<$Res>? get rabbit;
  @override
  $CageModelCopyWith<$Res>? get cage;
}

/// @nodoc
class __$$FeedingRecordImplCopyWithImpl<$Res>
    extends _$FeedingRecordCopyWithImpl<$Res, _$FeedingRecordImpl>
    implements _$$FeedingRecordImplCopyWith<$Res> {
  __$$FeedingRecordImplCopyWithImpl(
    _$FeedingRecordImpl _value,
    $Res Function(_$FeedingRecordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedingRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rabbitId = freezed,
    Object? feedId = null,
    Object? cageId = freezed,
    Object? quantity = null,
    Object? fedAt = null,
    Object? fedBy = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? feed = freezed,
    Object? rabbit = freezed,
    Object? cage = freezed,
  }) {
    return _then(
      _$FeedingRecordImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        rabbitId: freezed == rabbitId
            ? _value.rabbitId
            : rabbitId // ignore: cast_nullable_to_non_nullable
                  as int?,
        feedId: null == feedId
            ? _value.feedId
            : feedId // ignore: cast_nullable_to_non_nullable
                  as int,
        cageId: freezed == cageId
            ? _value.cageId
            : cageId // ignore: cast_nullable_to_non_nullable
                  as int?,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double,
        fedAt: null == fedAt
            ? _value.fedAt
            : fedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        fedBy: freezed == fedBy
            ? _value.fedBy
            : fedBy // ignore: cast_nullable_to_non_nullable
                  as int?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        feed: freezed == feed
            ? _value.feed
            : feed // ignore: cast_nullable_to_non_nullable
                  as Feed?,
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
class _$FeedingRecordImpl implements _FeedingRecord {
  const _$FeedingRecordImpl({
    @IntConverter() required this.id,
    @JsonKey(name: 'rabbit_id') @IntConverter() this.rabbitId,
    @JsonKey(name: 'feed_id') @IntConverter() required this.feedId,
    @JsonKey(name: 'cage_id') @IntConverter() this.cageId,
    @DoubleConverter() required this.quantity,
    @JsonKey(name: 'fed_at') required this.fedAt,
    @JsonKey(name: 'fed_by') @IntConverter() this.fedBy,
    this.notes,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(includeFromJson: false, includeToJson: false) this.feed,
    @JsonKey(includeFromJson: false, includeToJson: false) this.rabbit,
    @JsonKey(includeFromJson: false, includeToJson: false) this.cage,
  });

  factory _$FeedingRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedingRecordImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  @JsonKey(name: 'rabbit_id')
  @IntConverter()
  final int? rabbitId;
  @override
  @JsonKey(name: 'feed_id')
  @IntConverter()
  final int feedId;
  @override
  @JsonKey(name: 'cage_id')
  @IntConverter()
  final int? cageId;
  @override
  @DoubleConverter()
  final double quantity;
  @override
  @JsonKey(name: 'fed_at')
  final DateTime fedAt;
  @override
  @JsonKey(name: 'fed_by')
  @IntConverter()
  final int? fedBy;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Feed? feed;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final RabbitModel? rabbit;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final CageModel? cage;

  @override
  String toString() {
    return 'FeedingRecord(id: $id, rabbitId: $rabbitId, feedId: $feedId, cageId: $cageId, quantity: $quantity, fedAt: $fedAt, fedBy: $fedBy, notes: $notes, createdAt: $createdAt, feed: $feed, rabbit: $rabbit, cage: $cage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedingRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rabbitId, rabbitId) ||
                other.rabbitId == rabbitId) &&
            (identical(other.feedId, feedId) || other.feedId == feedId) &&
            (identical(other.cageId, cageId) || other.cageId == cageId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.fedAt, fedAt) || other.fedAt == fedAt) &&
            (identical(other.fedBy, fedBy) || other.fedBy == fedBy) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.feed, feed) || other.feed == feed) &&
            (identical(other.rabbit, rabbit) || other.rabbit == rabbit) &&
            (identical(other.cage, cage) || other.cage == cage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    rabbitId,
    feedId,
    cageId,
    quantity,
    fedAt,
    fedBy,
    notes,
    createdAt,
    feed,
    rabbit,
    cage,
  );

  /// Create a copy of FeedingRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedingRecordImplCopyWith<_$FeedingRecordImpl> get copyWith =>
      __$$FeedingRecordImplCopyWithImpl<_$FeedingRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedingRecordImplToJson(this);
  }
}

abstract class _FeedingRecord implements FeedingRecord {
  const factory _FeedingRecord({
    @IntConverter() required final int id,
    @JsonKey(name: 'rabbit_id') @IntConverter() final int? rabbitId,
    @JsonKey(name: 'feed_id') @IntConverter() required final int feedId,
    @JsonKey(name: 'cage_id') @IntConverter() final int? cageId,
    @DoubleConverter() required final double quantity,
    @JsonKey(name: 'fed_at') required final DateTime fedAt,
    @JsonKey(name: 'fed_by') @IntConverter() final int? fedBy,
    final String? notes,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(includeFromJson: false, includeToJson: false) final Feed? feed,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final RabbitModel? rabbit,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final CageModel? cage,
  }) = _$FeedingRecordImpl;

  factory _FeedingRecord.fromJson(Map<String, dynamic> json) =
      _$FeedingRecordImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  @JsonKey(name: 'rabbit_id')
  @IntConverter()
  int? get rabbitId;
  @override
  @JsonKey(name: 'feed_id')
  @IntConverter()
  int get feedId;
  @override
  @JsonKey(name: 'cage_id')
  @IntConverter()
  int? get cageId;
  @override
  @DoubleConverter()
  double get quantity;
  @override
  @JsonKey(name: 'fed_at')
  DateTime get fedAt;
  @override
  @JsonKey(name: 'fed_by')
  @IntConverter()
  int? get fedBy;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  Feed? get feed;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  RabbitModel? get rabbit;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  CageModel? get cage;

  /// Create a copy of FeedingRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedingRecordImplCopyWith<_$FeedingRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedingRecordCreate _$FeedingRecordCreateFromJson(Map<String, dynamic> json) {
  return _FeedingRecordCreate.fromJson(json);
}

/// @nodoc
mixin _$FeedingRecordCreate {
  @JsonKey(name: 'rabbit_id')
  int? get rabbitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'feed_id')
  int get feedId => throw _privateConstructorUsedError;
  @JsonKey(name: 'cage_id')
  int? get cageId => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'fed_at')
  DateTime get fedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this FeedingRecordCreate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeedingRecordCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedingRecordCreateCopyWith<FeedingRecordCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedingRecordCreateCopyWith<$Res> {
  factory $FeedingRecordCreateCopyWith(
    FeedingRecordCreate value,
    $Res Function(FeedingRecordCreate) then,
  ) = _$FeedingRecordCreateCopyWithImpl<$Res, FeedingRecordCreate>;
  @useResult
  $Res call({
    @JsonKey(name: 'rabbit_id') int? rabbitId,
    @JsonKey(name: 'feed_id') int feedId,
    @JsonKey(name: 'cage_id') int? cageId,
    double quantity,
    @JsonKey(name: 'fed_at') DateTime fedAt,
    String? notes,
  });
}

/// @nodoc
class _$FeedingRecordCreateCopyWithImpl<$Res, $Val extends FeedingRecordCreate>
    implements $FeedingRecordCreateCopyWith<$Res> {
  _$FeedingRecordCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedingRecordCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rabbitId = freezed,
    Object? feedId = null,
    Object? cageId = freezed,
    Object? quantity = null,
    Object? fedAt = null,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            rabbitId: freezed == rabbitId
                ? _value.rabbitId
                : rabbitId // ignore: cast_nullable_to_non_nullable
                      as int?,
            feedId: null == feedId
                ? _value.feedId
                : feedId // ignore: cast_nullable_to_non_nullable
                      as int,
            cageId: freezed == cageId
                ? _value.cageId
                : cageId // ignore: cast_nullable_to_non_nullable
                      as int?,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double,
            fedAt: null == fedAt
                ? _value.fedAt
                : fedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
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
abstract class _$$FeedingRecordCreateImplCopyWith<$Res>
    implements $FeedingRecordCreateCopyWith<$Res> {
  factory _$$FeedingRecordCreateImplCopyWith(
    _$FeedingRecordCreateImpl value,
    $Res Function(_$FeedingRecordCreateImpl) then,
  ) = __$$FeedingRecordCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'rabbit_id') int? rabbitId,
    @JsonKey(name: 'feed_id') int feedId,
    @JsonKey(name: 'cage_id') int? cageId,
    double quantity,
    @JsonKey(name: 'fed_at') DateTime fedAt,
    String? notes,
  });
}

/// @nodoc
class __$$FeedingRecordCreateImplCopyWithImpl<$Res>
    extends _$FeedingRecordCreateCopyWithImpl<$Res, _$FeedingRecordCreateImpl>
    implements _$$FeedingRecordCreateImplCopyWith<$Res> {
  __$$FeedingRecordCreateImplCopyWithImpl(
    _$FeedingRecordCreateImpl _value,
    $Res Function(_$FeedingRecordCreateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedingRecordCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rabbitId = freezed,
    Object? feedId = null,
    Object? cageId = freezed,
    Object? quantity = null,
    Object? fedAt = null,
    Object? notes = freezed,
  }) {
    return _then(
      _$FeedingRecordCreateImpl(
        rabbitId: freezed == rabbitId
            ? _value.rabbitId
            : rabbitId // ignore: cast_nullable_to_non_nullable
                  as int?,
        feedId: null == feedId
            ? _value.feedId
            : feedId // ignore: cast_nullable_to_non_nullable
                  as int,
        cageId: freezed == cageId
            ? _value.cageId
            : cageId // ignore: cast_nullable_to_non_nullable
                  as int?,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double,
        fedAt: null == fedAt
            ? _value.fedAt
            : fedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
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
class _$FeedingRecordCreateImpl implements _FeedingRecordCreate {
  const _$FeedingRecordCreateImpl({
    @JsonKey(name: 'rabbit_id') this.rabbitId,
    @JsonKey(name: 'feed_id') required this.feedId,
    @JsonKey(name: 'cage_id') this.cageId,
    required this.quantity,
    @JsonKey(name: 'fed_at') required this.fedAt,
    this.notes,
  });

  factory _$FeedingRecordCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedingRecordCreateImplFromJson(json);

  @override
  @JsonKey(name: 'rabbit_id')
  final int? rabbitId;
  @override
  @JsonKey(name: 'feed_id')
  final int feedId;
  @override
  @JsonKey(name: 'cage_id')
  final int? cageId;
  @override
  final double quantity;
  @override
  @JsonKey(name: 'fed_at')
  final DateTime fedAt;
  @override
  final String? notes;

  @override
  String toString() {
    return 'FeedingRecordCreate(rabbitId: $rabbitId, feedId: $feedId, cageId: $cageId, quantity: $quantity, fedAt: $fedAt, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedingRecordCreateImpl &&
            (identical(other.rabbitId, rabbitId) ||
                other.rabbitId == rabbitId) &&
            (identical(other.feedId, feedId) || other.feedId == feedId) &&
            (identical(other.cageId, cageId) || other.cageId == cageId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.fedAt, fedAt) || other.fedAt == fedAt) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    rabbitId,
    feedId,
    cageId,
    quantity,
    fedAt,
    notes,
  );

  /// Create a copy of FeedingRecordCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedingRecordCreateImplCopyWith<_$FeedingRecordCreateImpl> get copyWith =>
      __$$FeedingRecordCreateImplCopyWithImpl<_$FeedingRecordCreateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedingRecordCreateImplToJson(this);
  }
}

abstract class _FeedingRecordCreate implements FeedingRecordCreate {
  const factory _FeedingRecordCreate({
    @JsonKey(name: 'rabbit_id') final int? rabbitId,
    @JsonKey(name: 'feed_id') required final int feedId,
    @JsonKey(name: 'cage_id') final int? cageId,
    required final double quantity,
    @JsonKey(name: 'fed_at') required final DateTime fedAt,
    final String? notes,
  }) = _$FeedingRecordCreateImpl;

  factory _FeedingRecordCreate.fromJson(Map<String, dynamic> json) =
      _$FeedingRecordCreateImpl.fromJson;

  @override
  @JsonKey(name: 'rabbit_id')
  int? get rabbitId;
  @override
  @JsonKey(name: 'feed_id')
  int get feedId;
  @override
  @JsonKey(name: 'cage_id')
  int? get cageId;
  @override
  double get quantity;
  @override
  @JsonKey(name: 'fed_at')
  DateTime get fedAt;
  @override
  String? get notes;

  /// Create a copy of FeedingRecordCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedingRecordCreateImplCopyWith<_$FeedingRecordCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedingRecordUpdate _$FeedingRecordUpdateFromJson(Map<String, dynamic> json) {
  return _FeedingRecordUpdate.fromJson(json);
}

/// @nodoc
mixin _$FeedingRecordUpdate {
  @JsonKey(name: 'rabbit_id')
  int? get rabbitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'feed_id')
  int? get feedId => throw _privateConstructorUsedError;
  @JsonKey(name: 'cage_id')
  int? get cageId => throw _privateConstructorUsedError;
  double? get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'fed_at')
  DateTime? get fedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this FeedingRecordUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeedingRecordUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedingRecordUpdateCopyWith<FeedingRecordUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedingRecordUpdateCopyWith<$Res> {
  factory $FeedingRecordUpdateCopyWith(
    FeedingRecordUpdate value,
    $Res Function(FeedingRecordUpdate) then,
  ) = _$FeedingRecordUpdateCopyWithImpl<$Res, FeedingRecordUpdate>;
  @useResult
  $Res call({
    @JsonKey(name: 'rabbit_id') int? rabbitId,
    @JsonKey(name: 'feed_id') int? feedId,
    @JsonKey(name: 'cage_id') int? cageId,
    double? quantity,
    @JsonKey(name: 'fed_at') DateTime? fedAt,
    String? notes,
  });
}

/// @nodoc
class _$FeedingRecordUpdateCopyWithImpl<$Res, $Val extends FeedingRecordUpdate>
    implements $FeedingRecordUpdateCopyWith<$Res> {
  _$FeedingRecordUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedingRecordUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rabbitId = freezed,
    Object? feedId = freezed,
    Object? cageId = freezed,
    Object? quantity = freezed,
    Object? fedAt = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            rabbitId: freezed == rabbitId
                ? _value.rabbitId
                : rabbitId // ignore: cast_nullable_to_non_nullable
                      as int?,
            feedId: freezed == feedId
                ? _value.feedId
                : feedId // ignore: cast_nullable_to_non_nullable
                      as int?,
            cageId: freezed == cageId
                ? _value.cageId
                : cageId // ignore: cast_nullable_to_non_nullable
                      as int?,
            quantity: freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double?,
            fedAt: freezed == fedAt
                ? _value.fedAt
                : fedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
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
abstract class _$$FeedingRecordUpdateImplCopyWith<$Res>
    implements $FeedingRecordUpdateCopyWith<$Res> {
  factory _$$FeedingRecordUpdateImplCopyWith(
    _$FeedingRecordUpdateImpl value,
    $Res Function(_$FeedingRecordUpdateImpl) then,
  ) = __$$FeedingRecordUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'rabbit_id') int? rabbitId,
    @JsonKey(name: 'feed_id') int? feedId,
    @JsonKey(name: 'cage_id') int? cageId,
    double? quantity,
    @JsonKey(name: 'fed_at') DateTime? fedAt,
    String? notes,
  });
}

/// @nodoc
class __$$FeedingRecordUpdateImplCopyWithImpl<$Res>
    extends _$FeedingRecordUpdateCopyWithImpl<$Res, _$FeedingRecordUpdateImpl>
    implements _$$FeedingRecordUpdateImplCopyWith<$Res> {
  __$$FeedingRecordUpdateImplCopyWithImpl(
    _$FeedingRecordUpdateImpl _value,
    $Res Function(_$FeedingRecordUpdateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedingRecordUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rabbitId = freezed,
    Object? feedId = freezed,
    Object? cageId = freezed,
    Object? quantity = freezed,
    Object? fedAt = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$FeedingRecordUpdateImpl(
        rabbitId: freezed == rabbitId
            ? _value.rabbitId
            : rabbitId // ignore: cast_nullable_to_non_nullable
                  as int?,
        feedId: freezed == feedId
            ? _value.feedId
            : feedId // ignore: cast_nullable_to_non_nullable
                  as int?,
        cageId: freezed == cageId
            ? _value.cageId
            : cageId // ignore: cast_nullable_to_non_nullable
                  as int?,
        quantity: freezed == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double?,
        fedAt: freezed == fedAt
            ? _value.fedAt
            : fedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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
class _$FeedingRecordUpdateImpl implements _FeedingRecordUpdate {
  const _$FeedingRecordUpdateImpl({
    @JsonKey(name: 'rabbit_id') this.rabbitId,
    @JsonKey(name: 'feed_id') this.feedId,
    @JsonKey(name: 'cage_id') this.cageId,
    this.quantity,
    @JsonKey(name: 'fed_at') this.fedAt,
    this.notes,
  });

  factory _$FeedingRecordUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedingRecordUpdateImplFromJson(json);

  @override
  @JsonKey(name: 'rabbit_id')
  final int? rabbitId;
  @override
  @JsonKey(name: 'feed_id')
  final int? feedId;
  @override
  @JsonKey(name: 'cage_id')
  final int? cageId;
  @override
  final double? quantity;
  @override
  @JsonKey(name: 'fed_at')
  final DateTime? fedAt;
  @override
  final String? notes;

  @override
  String toString() {
    return 'FeedingRecordUpdate(rabbitId: $rabbitId, feedId: $feedId, cageId: $cageId, quantity: $quantity, fedAt: $fedAt, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedingRecordUpdateImpl &&
            (identical(other.rabbitId, rabbitId) ||
                other.rabbitId == rabbitId) &&
            (identical(other.feedId, feedId) || other.feedId == feedId) &&
            (identical(other.cageId, cageId) || other.cageId == cageId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.fedAt, fedAt) || other.fedAt == fedAt) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    rabbitId,
    feedId,
    cageId,
    quantity,
    fedAt,
    notes,
  );

  /// Create a copy of FeedingRecordUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedingRecordUpdateImplCopyWith<_$FeedingRecordUpdateImpl> get copyWith =>
      __$$FeedingRecordUpdateImplCopyWithImpl<_$FeedingRecordUpdateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedingRecordUpdateImplToJson(this);
  }
}

abstract class _FeedingRecordUpdate implements FeedingRecordUpdate {
  const factory _FeedingRecordUpdate({
    @JsonKey(name: 'rabbit_id') final int? rabbitId,
    @JsonKey(name: 'feed_id') final int? feedId,
    @JsonKey(name: 'cage_id') final int? cageId,
    final double? quantity,
    @JsonKey(name: 'fed_at') final DateTime? fedAt,
    final String? notes,
  }) = _$FeedingRecordUpdateImpl;

  factory _FeedingRecordUpdate.fromJson(Map<String, dynamic> json) =
      _$FeedingRecordUpdateImpl.fromJson;

  @override
  @JsonKey(name: 'rabbit_id')
  int? get rabbitId;
  @override
  @JsonKey(name: 'feed_id')
  int? get feedId;
  @override
  @JsonKey(name: 'cage_id')
  int? get cageId;
  @override
  double? get quantity;
  @override
  @JsonKey(name: 'fed_at')
  DateTime? get fedAt;
  @override
  String? get notes;

  /// Create a copy of FeedingRecordUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedingRecordUpdateImplCopyWith<_$FeedingRecordUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedingStatistics _$FeedingStatisticsFromJson(Map<String, dynamic> json) {
  return _FeedingStatistics.fromJson(json);
}

/// @nodoc
mixin _$FeedingStatistics {
  @JsonKey(name: 'total_feedings')
  int get totalFeedings => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_quantity')
  double get totalQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'by_feed_type')
  FeedingByType get byFeedType => throw _privateConstructorUsedError;
  @JsonKey(name: 'by_feed')
  Map<String, FeedingByFeed> get byFeed => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_cost')
  double get totalCost => throw _privateConstructorUsedError;

  /// Serializes this FeedingStatistics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeedingStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedingStatisticsCopyWith<FeedingStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedingStatisticsCopyWith<$Res> {
  factory $FeedingStatisticsCopyWith(
    FeedingStatistics value,
    $Res Function(FeedingStatistics) then,
  ) = _$FeedingStatisticsCopyWithImpl<$Res, FeedingStatistics>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_feedings') int totalFeedings,
    @JsonKey(name: 'total_quantity') double totalQuantity,
    @JsonKey(name: 'by_feed_type') FeedingByType byFeedType,
    @JsonKey(name: 'by_feed') Map<String, FeedingByFeed> byFeed,
    @JsonKey(name: 'total_cost') double totalCost,
  });

  $FeedingByTypeCopyWith<$Res> get byFeedType;
}

/// @nodoc
class _$FeedingStatisticsCopyWithImpl<$Res, $Val extends FeedingStatistics>
    implements $FeedingStatisticsCopyWith<$Res> {
  _$FeedingStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedingStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalFeedings = null,
    Object? totalQuantity = null,
    Object? byFeedType = null,
    Object? byFeed = null,
    Object? totalCost = null,
  }) {
    return _then(
      _value.copyWith(
            totalFeedings: null == totalFeedings
                ? _value.totalFeedings
                : totalFeedings // ignore: cast_nullable_to_non_nullable
                      as int,
            totalQuantity: null == totalQuantity
                ? _value.totalQuantity
                : totalQuantity // ignore: cast_nullable_to_non_nullable
                      as double,
            byFeedType: null == byFeedType
                ? _value.byFeedType
                : byFeedType // ignore: cast_nullable_to_non_nullable
                      as FeedingByType,
            byFeed: null == byFeed
                ? _value.byFeed
                : byFeed // ignore: cast_nullable_to_non_nullable
                      as Map<String, FeedingByFeed>,
            totalCost: null == totalCost
                ? _value.totalCost
                : totalCost // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }

  /// Create a copy of FeedingStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FeedingByTypeCopyWith<$Res> get byFeedType {
    return $FeedingByTypeCopyWith<$Res>(_value.byFeedType, (value) {
      return _then(_value.copyWith(byFeedType: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FeedingStatisticsImplCopyWith<$Res>
    implements $FeedingStatisticsCopyWith<$Res> {
  factory _$$FeedingStatisticsImplCopyWith(
    _$FeedingStatisticsImpl value,
    $Res Function(_$FeedingStatisticsImpl) then,
  ) = __$$FeedingStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_feedings') int totalFeedings,
    @JsonKey(name: 'total_quantity') double totalQuantity,
    @JsonKey(name: 'by_feed_type') FeedingByType byFeedType,
    @JsonKey(name: 'by_feed') Map<String, FeedingByFeed> byFeed,
    @JsonKey(name: 'total_cost') double totalCost,
  });

  @override
  $FeedingByTypeCopyWith<$Res> get byFeedType;
}

/// @nodoc
class __$$FeedingStatisticsImplCopyWithImpl<$Res>
    extends _$FeedingStatisticsCopyWithImpl<$Res, _$FeedingStatisticsImpl>
    implements _$$FeedingStatisticsImplCopyWith<$Res> {
  __$$FeedingStatisticsImplCopyWithImpl(
    _$FeedingStatisticsImpl _value,
    $Res Function(_$FeedingStatisticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedingStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalFeedings = null,
    Object? totalQuantity = null,
    Object? byFeedType = null,
    Object? byFeed = null,
    Object? totalCost = null,
  }) {
    return _then(
      _$FeedingStatisticsImpl(
        totalFeedings: null == totalFeedings
            ? _value.totalFeedings
            : totalFeedings // ignore: cast_nullable_to_non_nullable
                  as int,
        totalQuantity: null == totalQuantity
            ? _value.totalQuantity
            : totalQuantity // ignore: cast_nullable_to_non_nullable
                  as double,
        byFeedType: null == byFeedType
            ? _value.byFeedType
            : byFeedType // ignore: cast_nullable_to_non_nullable
                  as FeedingByType,
        byFeed: null == byFeed
            ? _value._byFeed
            : byFeed // ignore: cast_nullable_to_non_nullable
                  as Map<String, FeedingByFeed>,
        totalCost: null == totalCost
            ? _value.totalCost
            : totalCost // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedingStatisticsImpl implements _FeedingStatistics {
  const _$FeedingStatisticsImpl({
    @JsonKey(name: 'total_feedings') required this.totalFeedings,
    @JsonKey(name: 'total_quantity') required this.totalQuantity,
    @JsonKey(name: 'by_feed_type') required this.byFeedType,
    @JsonKey(name: 'by_feed') required final Map<String, FeedingByFeed> byFeed,
    @JsonKey(name: 'total_cost') required this.totalCost,
  }) : _byFeed = byFeed;

  factory _$FeedingStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedingStatisticsImplFromJson(json);

  @override
  @JsonKey(name: 'total_feedings')
  final int totalFeedings;
  @override
  @JsonKey(name: 'total_quantity')
  final double totalQuantity;
  @override
  @JsonKey(name: 'by_feed_type')
  final FeedingByType byFeedType;
  final Map<String, FeedingByFeed> _byFeed;
  @override
  @JsonKey(name: 'by_feed')
  Map<String, FeedingByFeed> get byFeed {
    if (_byFeed is EqualUnmodifiableMapView) return _byFeed;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_byFeed);
  }

  @override
  @JsonKey(name: 'total_cost')
  final double totalCost;

  @override
  String toString() {
    return 'FeedingStatistics(totalFeedings: $totalFeedings, totalQuantity: $totalQuantity, byFeedType: $byFeedType, byFeed: $byFeed, totalCost: $totalCost)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedingStatisticsImpl &&
            (identical(other.totalFeedings, totalFeedings) ||
                other.totalFeedings == totalFeedings) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.byFeedType, byFeedType) ||
                other.byFeedType == byFeedType) &&
            const DeepCollectionEquality().equals(other._byFeed, _byFeed) &&
            (identical(other.totalCost, totalCost) ||
                other.totalCost == totalCost));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalFeedings,
    totalQuantity,
    byFeedType,
    const DeepCollectionEquality().hash(_byFeed),
    totalCost,
  );

  /// Create a copy of FeedingStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedingStatisticsImplCopyWith<_$FeedingStatisticsImpl> get copyWith =>
      __$$FeedingStatisticsImplCopyWithImpl<_$FeedingStatisticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedingStatisticsImplToJson(this);
  }
}

abstract class _FeedingStatistics implements FeedingStatistics {
  const factory _FeedingStatistics({
    @JsonKey(name: 'total_feedings') required final int totalFeedings,
    @JsonKey(name: 'total_quantity') required final double totalQuantity,
    @JsonKey(name: 'by_feed_type') required final FeedingByType byFeedType,
    @JsonKey(name: 'by_feed') required final Map<String, FeedingByFeed> byFeed,
    @JsonKey(name: 'total_cost') required final double totalCost,
  }) = _$FeedingStatisticsImpl;

  factory _FeedingStatistics.fromJson(Map<String, dynamic> json) =
      _$FeedingStatisticsImpl.fromJson;

  @override
  @JsonKey(name: 'total_feedings')
  int get totalFeedings;
  @override
  @JsonKey(name: 'total_quantity')
  double get totalQuantity;
  @override
  @JsonKey(name: 'by_feed_type')
  FeedingByType get byFeedType;
  @override
  @JsonKey(name: 'by_feed')
  Map<String, FeedingByFeed> get byFeed;
  @override
  @JsonKey(name: 'total_cost')
  double get totalCost;

  /// Create a copy of FeedingStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedingStatisticsImplCopyWith<_$FeedingStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedingByType _$FeedingByTypeFromJson(Map<String, dynamic> json) {
  return _FeedingByType.fromJson(json);
}

/// @nodoc
mixin _$FeedingByType {
  @JsonKey(defaultValue: 0.0)
  double get pellets => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: 0.0)
  double get hay => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: 0.0)
  double get vegetables => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: 0.0)
  double get grain => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: 0.0)
  double get supplements => throw _privateConstructorUsedError;
  @JsonKey(defaultValue: 0.0)
  double get other => throw _privateConstructorUsedError;

  /// Serializes this FeedingByType to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeedingByType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedingByTypeCopyWith<FeedingByType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedingByTypeCopyWith<$Res> {
  factory $FeedingByTypeCopyWith(
    FeedingByType value,
    $Res Function(FeedingByType) then,
  ) = _$FeedingByTypeCopyWithImpl<$Res, FeedingByType>;
  @useResult
  $Res call({
    @JsonKey(defaultValue: 0.0) double pellets,
    @JsonKey(defaultValue: 0.0) double hay,
    @JsonKey(defaultValue: 0.0) double vegetables,
    @JsonKey(defaultValue: 0.0) double grain,
    @JsonKey(defaultValue: 0.0) double supplements,
    @JsonKey(defaultValue: 0.0) double other,
  });
}

/// @nodoc
class _$FeedingByTypeCopyWithImpl<$Res, $Val extends FeedingByType>
    implements $FeedingByTypeCopyWith<$Res> {
  _$FeedingByTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedingByType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pellets = null,
    Object? hay = null,
    Object? vegetables = null,
    Object? grain = null,
    Object? supplements = null,
    Object? other = null,
  }) {
    return _then(
      _value.copyWith(
            pellets: null == pellets
                ? _value.pellets
                : pellets // ignore: cast_nullable_to_non_nullable
                      as double,
            hay: null == hay
                ? _value.hay
                : hay // ignore: cast_nullable_to_non_nullable
                      as double,
            vegetables: null == vegetables
                ? _value.vegetables
                : vegetables // ignore: cast_nullable_to_non_nullable
                      as double,
            grain: null == grain
                ? _value.grain
                : grain // ignore: cast_nullable_to_non_nullable
                      as double,
            supplements: null == supplements
                ? _value.supplements
                : supplements // ignore: cast_nullable_to_non_nullable
                      as double,
            other: null == other
                ? _value.other
                : other // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeedingByTypeImplCopyWith<$Res>
    implements $FeedingByTypeCopyWith<$Res> {
  factory _$$FeedingByTypeImplCopyWith(
    _$FeedingByTypeImpl value,
    $Res Function(_$FeedingByTypeImpl) then,
  ) = __$$FeedingByTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(defaultValue: 0.0) double pellets,
    @JsonKey(defaultValue: 0.0) double hay,
    @JsonKey(defaultValue: 0.0) double vegetables,
    @JsonKey(defaultValue: 0.0) double grain,
    @JsonKey(defaultValue: 0.0) double supplements,
    @JsonKey(defaultValue: 0.0) double other,
  });
}

/// @nodoc
class __$$FeedingByTypeImplCopyWithImpl<$Res>
    extends _$FeedingByTypeCopyWithImpl<$Res, _$FeedingByTypeImpl>
    implements _$$FeedingByTypeImplCopyWith<$Res> {
  __$$FeedingByTypeImplCopyWithImpl(
    _$FeedingByTypeImpl _value,
    $Res Function(_$FeedingByTypeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedingByType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pellets = null,
    Object? hay = null,
    Object? vegetables = null,
    Object? grain = null,
    Object? supplements = null,
    Object? other = null,
  }) {
    return _then(
      _$FeedingByTypeImpl(
        pellets: null == pellets
            ? _value.pellets
            : pellets // ignore: cast_nullable_to_non_nullable
                  as double,
        hay: null == hay
            ? _value.hay
            : hay // ignore: cast_nullable_to_non_nullable
                  as double,
        vegetables: null == vegetables
            ? _value.vegetables
            : vegetables // ignore: cast_nullable_to_non_nullable
                  as double,
        grain: null == grain
            ? _value.grain
            : grain // ignore: cast_nullable_to_non_nullable
                  as double,
        supplements: null == supplements
            ? _value.supplements
            : supplements // ignore: cast_nullable_to_non_nullable
                  as double,
        other: null == other
            ? _value.other
            : other // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedingByTypeImpl implements _FeedingByType {
  const _$FeedingByTypeImpl({
    @JsonKey(defaultValue: 0.0) required this.pellets,
    @JsonKey(defaultValue: 0.0) required this.hay,
    @JsonKey(defaultValue: 0.0) required this.vegetables,
    @JsonKey(defaultValue: 0.0) required this.grain,
    @JsonKey(defaultValue: 0.0) required this.supplements,
    @JsonKey(defaultValue: 0.0) required this.other,
  });

  factory _$FeedingByTypeImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedingByTypeImplFromJson(json);

  @override
  @JsonKey(defaultValue: 0.0)
  final double pellets;
  @override
  @JsonKey(defaultValue: 0.0)
  final double hay;
  @override
  @JsonKey(defaultValue: 0.0)
  final double vegetables;
  @override
  @JsonKey(defaultValue: 0.0)
  final double grain;
  @override
  @JsonKey(defaultValue: 0.0)
  final double supplements;
  @override
  @JsonKey(defaultValue: 0.0)
  final double other;

  @override
  String toString() {
    return 'FeedingByType(pellets: $pellets, hay: $hay, vegetables: $vegetables, grain: $grain, supplements: $supplements, other: $other)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedingByTypeImpl &&
            (identical(other.pellets, pellets) || other.pellets == pellets) &&
            (identical(other.hay, hay) || other.hay == hay) &&
            (identical(other.vegetables, vegetables) ||
                other.vegetables == vegetables) &&
            (identical(other.grain, grain) || other.grain == grain) &&
            (identical(other.supplements, supplements) ||
                other.supplements == supplements) &&
            (identical(other.other, this.other) || other.other == this.other));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    pellets,
    hay,
    vegetables,
    grain,
    supplements,
    other,
  );

  /// Create a copy of FeedingByType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedingByTypeImplCopyWith<_$FeedingByTypeImpl> get copyWith =>
      __$$FeedingByTypeImplCopyWithImpl<_$FeedingByTypeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedingByTypeImplToJson(this);
  }
}

abstract class _FeedingByType implements FeedingByType {
  const factory _FeedingByType({
    @JsonKey(defaultValue: 0.0) required final double pellets,
    @JsonKey(defaultValue: 0.0) required final double hay,
    @JsonKey(defaultValue: 0.0) required final double vegetables,
    @JsonKey(defaultValue: 0.0) required final double grain,
    @JsonKey(defaultValue: 0.0) required final double supplements,
    @JsonKey(defaultValue: 0.0) required final double other,
  }) = _$FeedingByTypeImpl;

  factory _FeedingByType.fromJson(Map<String, dynamic> json) =
      _$FeedingByTypeImpl.fromJson;

  @override
  @JsonKey(defaultValue: 0.0)
  double get pellets;
  @override
  @JsonKey(defaultValue: 0.0)
  double get hay;
  @override
  @JsonKey(defaultValue: 0.0)
  double get vegetables;
  @override
  @JsonKey(defaultValue: 0.0)
  double get grain;
  @override
  @JsonKey(defaultValue: 0.0)
  double get supplements;
  @override
  @JsonKey(defaultValue: 0.0)
  double get other;

  /// Create a copy of FeedingByType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedingByTypeImplCopyWith<_$FeedingByTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedingByFeed _$FeedingByFeedFromJson(Map<String, dynamic> json) {
  return _FeedingByFeed.fromJson(json);
}

/// @nodoc
mixin _$FeedingByFeed {
  double get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  double get cost => throw _privateConstructorUsedError;

  /// Serializes this FeedingByFeed to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeedingByFeed
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedingByFeedCopyWith<FeedingByFeed> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedingByFeedCopyWith<$Res> {
  factory $FeedingByFeedCopyWith(
    FeedingByFeed value,
    $Res Function(FeedingByFeed) then,
  ) = _$FeedingByFeedCopyWithImpl<$Res, FeedingByFeed>;
  @useResult
  $Res call({double quantity, String unit, double cost});
}

/// @nodoc
class _$FeedingByFeedCopyWithImpl<$Res, $Val extends FeedingByFeed>
    implements $FeedingByFeedCopyWith<$Res> {
  _$FeedingByFeedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedingByFeed
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quantity = null,
    Object? unit = null,
    Object? cost = null,
  }) {
    return _then(
      _value.copyWith(
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double,
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String,
            cost: null == cost
                ? _value.cost
                : cost // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeedingByFeedImplCopyWith<$Res>
    implements $FeedingByFeedCopyWith<$Res> {
  factory _$$FeedingByFeedImplCopyWith(
    _$FeedingByFeedImpl value,
    $Res Function(_$FeedingByFeedImpl) then,
  ) = __$$FeedingByFeedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double quantity, String unit, double cost});
}

/// @nodoc
class __$$FeedingByFeedImplCopyWithImpl<$Res>
    extends _$FeedingByFeedCopyWithImpl<$Res, _$FeedingByFeedImpl>
    implements _$$FeedingByFeedImplCopyWith<$Res> {
  __$$FeedingByFeedImplCopyWithImpl(
    _$FeedingByFeedImpl _value,
    $Res Function(_$FeedingByFeedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedingByFeed
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quantity = null,
    Object? unit = null,
    Object? cost = null,
  }) {
    return _then(
      _$FeedingByFeedImpl(
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double,
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
        cost: null == cost
            ? _value.cost
            : cost // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedingByFeedImpl implements _FeedingByFeed {
  const _$FeedingByFeedImpl({
    required this.quantity,
    required this.unit,
    required this.cost,
  });

  factory _$FeedingByFeedImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedingByFeedImplFromJson(json);

  @override
  final double quantity;
  @override
  final String unit;
  @override
  final double cost;

  @override
  String toString() {
    return 'FeedingByFeed(quantity: $quantity, unit: $unit, cost: $cost)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedingByFeedImpl &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.cost, cost) || other.cost == cost));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, quantity, unit, cost);

  /// Create a copy of FeedingByFeed
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedingByFeedImplCopyWith<_$FeedingByFeedImpl> get copyWith =>
      __$$FeedingByFeedImplCopyWithImpl<_$FeedingByFeedImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedingByFeedImplToJson(this);
  }
}

abstract class _FeedingByFeed implements FeedingByFeed {
  const factory _FeedingByFeed({
    required final double quantity,
    required final String unit,
    required final double cost,
  }) = _$FeedingByFeedImpl;

  factory _FeedingByFeed.fromJson(Map<String, dynamic> json) =
      _$FeedingByFeedImpl.fromJson;

  @override
  double get quantity;
  @override
  String get unit;
  @override
  double get cost;

  /// Create a copy of FeedingByFeed
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedingByFeedImplCopyWith<_$FeedingByFeedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
