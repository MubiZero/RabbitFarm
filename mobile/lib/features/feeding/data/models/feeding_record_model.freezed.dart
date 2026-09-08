// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feeding_record_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedingRecord {

@IntConverter() int get id;@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? get rabbitId;@JsonKey(name: 'feed_id')@IntConverter() int get feedId;@JsonKey(name: 'cage_id')@NullableIntConverter() int? get cageId;@DoubleConverter() double get quantity;@JsonKey(name: 'fed_at')@DateTimeConverter() DateTime get fedAt;@JsonKey(name: 'fed_by')@NullableIntConverter() int? get fedBy; String? get notes;@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? get createdAt; Feed? get feed; RabbitModel? get rabbit; CageModel? get cage;@JsonKey(name: 'fedBy') UserRef? get author;
/// Create a copy of FeedingRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedingRecordCopyWith<FeedingRecord> get copyWith => _$FeedingRecordCopyWithImpl<FeedingRecord>(this as FeedingRecord, _$identity);

  /// Serializes this FeedingRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeedingRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedingRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.rabbitId, _this.rabbitId) || other.rabbitId == _this.rabbitId)&&(identical(other.feedId, _this.feedId) || other.feedId == _this.feedId)&&(identical(other.cageId, _this.cageId) || other.cageId == _this.cageId)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.fedAt, _this.fedAt) || other.fedAt == _this.fedAt)&&(identical(other.fedBy, _this.fedBy) || other.fedBy == _this.fedBy)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.feed, _this.feed) || other.feed == _this.feed)&&(identical(other.rabbit, _this.rabbit) || other.rabbit == _this.rabbit)&&(identical(other.cage, _this.cage) || other.cage == _this.cage)&&(identical(other.author, _this.author) || other.author == _this.author));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeedingRecord;
  return Object.hash(runtimeType,_this.id,_this.rabbitId,_this.feedId,_this.cageId,_this.quantity,_this.fedAt,_this.fedBy,_this.notes,_this.createdAt,_this.feed,_this.rabbit,_this.cage,_this.author);
}

@override
String toString() {
  final _this = this as FeedingRecord;
  return 'FeedingRecord(id: ${_this.id}, rabbitId: ${_this.rabbitId}, feedId: ${_this.feedId}, cageId: ${_this.cageId}, quantity: ${_this.quantity}, fedAt: ${_this.fedAt}, fedBy: ${_this.fedBy}, notes: ${_this.notes}, createdAt: ${_this.createdAt}, feed: ${_this.feed}, rabbit: ${_this.rabbit}, cage: ${_this.cage}, author: ${_this.author})';
}


}

/// @nodoc
abstract mixin class $FeedingRecordCopyWith<$Res>  {
  factory $FeedingRecordCopyWith(FeedingRecord value, $Res Function(FeedingRecord) _then) = _$FeedingRecordCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id,@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? rabbitId,@JsonKey(name: 'feed_id')@IntConverter() int feedId,@JsonKey(name: 'cage_id')@NullableIntConverter() int? cageId,@DoubleConverter() double quantity,@JsonKey(name: 'fed_at')@DateTimeConverter() DateTime fedAt,@JsonKey(name: 'fed_by')@NullableIntConverter() int? fedBy, String? notes,@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? createdAt, Feed? feed, RabbitModel? rabbit, CageModel? cage,@JsonKey(name: 'fedBy') UserRef? author
});


$FeedCopyWith<$Res>? get feed;$RabbitModelCopyWith<$Res>? get rabbit;$CageModelCopyWith<$Res>? get cage;$UserRefCopyWith<$Res>? get author;

}
/// @nodoc
class _$FeedingRecordCopyWithImpl<$Res>
    implements $FeedingRecordCopyWith<$Res> {
  _$FeedingRecordCopyWithImpl(this._self, this._then);

  final FeedingRecord _self;
  final $Res Function(FeedingRecord) _then;

/// Create a copy of FeedingRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? rabbitId = freezed,Object? feedId = null,Object? cageId = freezed,Object? quantity = null,Object? fedAt = null,Object? fedBy = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? feed = freezed,Object? rabbit = freezed,Object? cage = freezed,Object? author = freezed,}) {
  return _then(FeedingRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,feedId: null == feedId ? _self.feedId : feedId // ignore: cast_nullable_to_non_nullable
as int,cageId: freezed == cageId ? _self.cageId : cageId // ignore: cast_nullable_to_non_nullable
as int?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,fedAt: null == fedAt ? _self.fedAt : fedAt // ignore: cast_nullable_to_non_nullable
as DateTime,fedBy: freezed == fedBy ? _self.fedBy : fedBy // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,feed: freezed == feed ? _self.feed : feed // ignore: cast_nullable_to_non_nullable
as Feed?,rabbit: freezed == rabbit ? _self.rabbit : rabbit // ignore: cast_nullable_to_non_nullable
as RabbitModel?,cage: freezed == cage ? _self.cage : cage // ignore: cast_nullable_to_non_nullable
as CageModel?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserRef?,
  ));
}
/// Create a copy of FeedingRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedCopyWith<$Res>? get feed {
    if (_self.feed == null) {
    return null;
  }

  return $FeedCopyWith<$Res>(_self.feed!, (value) {
    return _then(_self.copyWith(feed: value));
  });
}/// Create a copy of FeedingRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RabbitModelCopyWith<$Res>? get rabbit {
    if (_self.rabbit == null) {
    return null;
  }

  return $RabbitModelCopyWith<$Res>(_self.rabbit!, (value) {
    return _then(_self.copyWith(rabbit: value));
  });
}/// Create a copy of FeedingRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CageModelCopyWith<$Res>? get cage {
    if (_self.cage == null) {
    return null;
  }

  return $CageModelCopyWith<$Res>(_self.cage!, (value) {
    return _then(_self.copyWith(cage: value));
  });
}/// Create a copy of FeedingRecord
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


/// Adds pattern-matching-related methods to [FeedingRecord].
extension FeedingRecordPatterns on FeedingRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedingRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedingRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedingRecord value)  $default,){
final _that = this;
switch (_that) {
case _FeedingRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedingRecord value)?  $default,){
final _that = this;
switch (_that) {
case _FeedingRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId, @JsonKey(name: 'feed_id')@IntConverter()  int feedId, @JsonKey(name: 'cage_id')@NullableIntConverter()  int? cageId, @DoubleConverter()  double quantity, @JsonKey(name: 'fed_at')@DateTimeConverter()  DateTime fedAt, @JsonKey(name: 'fed_by')@NullableIntConverter()  int? fedBy,  String? notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt,  Feed? feed,  RabbitModel? rabbit,  CageModel? cage, @JsonKey(name: 'fedBy')  UserRef? author)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedingRecord() when $default != null:
return $default(_that.id,_that.rabbitId,_that.feedId,_that.cageId,_that.quantity,_that.fedAt,_that.fedBy,_that.notes,_that.createdAt,_that.feed,_that.rabbit,_that.cage,_that.author);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId, @JsonKey(name: 'feed_id')@IntConverter()  int feedId, @JsonKey(name: 'cage_id')@NullableIntConverter()  int? cageId, @DoubleConverter()  double quantity, @JsonKey(name: 'fed_at')@DateTimeConverter()  DateTime fedAt, @JsonKey(name: 'fed_by')@NullableIntConverter()  int? fedBy,  String? notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt,  Feed? feed,  RabbitModel? rabbit,  CageModel? cage, @JsonKey(name: 'fedBy')  UserRef? author)  $default,) {final _that = this;
switch (_that) {
case _FeedingRecord():
return $default(_that.id,_that.rabbitId,_that.feedId,_that.cageId,_that.quantity,_that.fedAt,_that.fedBy,_that.notes,_that.createdAt,_that.feed,_that.rabbit,_that.cage,_that.author);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId, @JsonKey(name: 'feed_id')@IntConverter()  int feedId, @JsonKey(name: 'cage_id')@NullableIntConverter()  int? cageId, @DoubleConverter()  double quantity, @JsonKey(name: 'fed_at')@DateTimeConverter()  DateTime fedAt, @JsonKey(name: 'fed_by')@NullableIntConverter()  int? fedBy,  String? notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt,  Feed? feed,  RabbitModel? rabbit,  CageModel? cage, @JsonKey(name: 'fedBy')  UserRef? author)?  $default,) {final _that = this;
switch (_that) {
case _FeedingRecord() when $default != null:
return $default(_that.id,_that.rabbitId,_that.feedId,_that.cageId,_that.quantity,_that.fedAt,_that.fedBy,_that.notes,_that.createdAt,_that.feed,_that.rabbit,_that.cage,_that.author);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedingRecord implements FeedingRecord {
  const _FeedingRecord({@IntConverter() required this.id, @JsonKey(name: 'rabbit_id')@NullableIntConverter() this.rabbitId, @JsonKey(name: 'feed_id')@IntConverter() required this.feedId, @JsonKey(name: 'cage_id')@NullableIntConverter() this.cageId, @DoubleConverter() required this.quantity, @JsonKey(name: 'fed_at')@DateTimeConverter() required this.fedAt, @JsonKey(name: 'fed_by')@NullableIntConverter() this.fedBy, this.notes, @JsonKey(name: 'created_at')@NullableDateTimeConverter() this.createdAt, this.feed, this.rabbit, this.cage, @JsonKey(name: 'fedBy') this.author});
  factory _FeedingRecord.fromJson(Map<String, dynamic> json) => _$FeedingRecordFromJson(json);

@override@IntConverter() final  int id;
@override@JsonKey(name: 'rabbit_id')@NullableIntConverter() final  int? rabbitId;
@override@JsonKey(name: 'feed_id')@IntConverter() final  int feedId;
@override@JsonKey(name: 'cage_id')@NullableIntConverter() final  int? cageId;
@override@DoubleConverter() final  double quantity;
@override@JsonKey(name: 'fed_at')@DateTimeConverter() final  DateTime fedAt;
@override@JsonKey(name: 'fed_by')@NullableIntConverter() final  int? fedBy;
@override final  String? notes;
@override@JsonKey(name: 'created_at')@NullableDateTimeConverter() final  DateTime? createdAt;
@override final  Feed? feed;
@override final  RabbitModel? rabbit;
@override final  CageModel? cage;
@override@JsonKey(name: 'fedBy') final  UserRef? author;

/// Create a copy of FeedingRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedingRecordCopyWith<_FeedingRecord> get copyWith => __$FeedingRecordCopyWithImpl<_FeedingRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedingRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedingRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.rabbitId, rabbitId) || other.rabbitId == rabbitId)&&(identical(other.feedId, feedId) || other.feedId == feedId)&&(identical(other.cageId, cageId) || other.cageId == cageId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.fedAt, fedAt) || other.fedAt == fedAt)&&(identical(other.fedBy, fedBy) || other.fedBy == fedBy)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.feed, feed) || other.feed == feed)&&(identical(other.rabbit, rabbit) || other.rabbit == rabbit)&&(identical(other.cage, cage) || other.cage == cage)&&(identical(other.author, author) || other.author == author));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,rabbitId,feedId,cageId,quantity,fedAt,fedBy,notes,createdAt,feed,rabbit,cage,author);
}

@override
String toString() {
    return 'FeedingRecord(id: $id, rabbitId: $rabbitId, feedId: $feedId, cageId: $cageId, quantity: $quantity, fedAt: $fedAt, fedBy: $fedBy, notes: $notes, createdAt: $createdAt, feed: $feed, rabbit: $rabbit, cage: $cage, author: $author)';
}


}

/// @nodoc
abstract mixin class _$FeedingRecordCopyWith<$Res> implements $FeedingRecordCopyWith<$Res> {
  factory _$FeedingRecordCopyWith(_FeedingRecord value, $Res Function(_FeedingRecord) _then) = __$FeedingRecordCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id,@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? rabbitId,@JsonKey(name: 'feed_id')@IntConverter() int feedId,@JsonKey(name: 'cage_id')@NullableIntConverter() int? cageId,@DoubleConverter() double quantity,@JsonKey(name: 'fed_at')@DateTimeConverter() DateTime fedAt,@JsonKey(name: 'fed_by')@NullableIntConverter() int? fedBy, String? notes,@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? createdAt, Feed? feed, RabbitModel? rabbit, CageModel? cage,@JsonKey(name: 'fedBy') UserRef? author
});


@override $FeedCopyWith<$Res>? get feed;@override $RabbitModelCopyWith<$Res>? get rabbit;@override $CageModelCopyWith<$Res>? get cage;@override $UserRefCopyWith<$Res>? get author;

}
/// @nodoc
class __$FeedingRecordCopyWithImpl<$Res>
    implements _$FeedingRecordCopyWith<$Res> {
  __$FeedingRecordCopyWithImpl(this._self, this._then);

  final _FeedingRecord _self;
  final $Res Function(_FeedingRecord) _then;

/// Create a copy of FeedingRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? rabbitId = freezed,Object? feedId = null,Object? cageId = freezed,Object? quantity = null,Object? fedAt = null,Object? fedBy = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? feed = freezed,Object? rabbit = freezed,Object? cage = freezed,Object? author = freezed,}) {
  return _then(_FeedingRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,feedId: null == feedId ? _self.feedId : feedId // ignore: cast_nullable_to_non_nullable
as int,cageId: freezed == cageId ? _self.cageId : cageId // ignore: cast_nullable_to_non_nullable
as int?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,fedAt: null == fedAt ? _self.fedAt : fedAt // ignore: cast_nullable_to_non_nullable
as DateTime,fedBy: freezed == fedBy ? _self.fedBy : fedBy // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,feed: freezed == feed ? _self.feed : feed // ignore: cast_nullable_to_non_nullable
as Feed?,rabbit: freezed == rabbit ? _self.rabbit : rabbit // ignore: cast_nullable_to_non_nullable
as RabbitModel?,cage: freezed == cage ? _self.cage : cage // ignore: cast_nullable_to_non_nullable
as CageModel?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserRef?,
  ));
}

/// Create a copy of FeedingRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedCopyWith<$Res>? get feed {
    if (_self.feed == null) {
    return null;
  }

  return $FeedCopyWith<$Res>(_self.feed!, (value) {
    return _then(_self.copyWith(feed: value));
  });
}/// Create a copy of FeedingRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RabbitModelCopyWith<$Res>? get rabbit {
    if (_self.rabbit == null) {
    return null;
  }

  return $RabbitModelCopyWith<$Res>(_self.rabbit!, (value) {
    return _then(_self.copyWith(rabbit: value));
  });
}/// Create a copy of FeedingRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CageModelCopyWith<$Res>? get cage {
    if (_self.cage == null) {
    return null;
  }

  return $CageModelCopyWith<$Res>(_self.cage!, (value) {
    return _then(_self.copyWith(cage: value));
  });
}/// Create a copy of FeedingRecord
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
mixin _$FeedingRecordCreate {

@JsonKey(name: 'rabbit_id') int? get rabbitId;@JsonKey(name: 'feed_id') int get feedId;@JsonKey(name: 'cage_id') int? get cageId; double get quantity;@JsonKey(name: 'fed_at')@DateTimeConverter() DateTime get fedAt; String? get notes;
/// Create a copy of FeedingRecordCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedingRecordCreateCopyWith<FeedingRecordCreate> get copyWith => _$FeedingRecordCreateCopyWithImpl<FeedingRecordCreate>(this as FeedingRecordCreate, _$identity);

  /// Serializes this FeedingRecordCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeedingRecordCreate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedingRecordCreate&&(identical(other.rabbitId, _this.rabbitId) || other.rabbitId == _this.rabbitId)&&(identical(other.feedId, _this.feedId) || other.feedId == _this.feedId)&&(identical(other.cageId, _this.cageId) || other.cageId == _this.cageId)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.fedAt, _this.fedAt) || other.fedAt == _this.fedAt)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeedingRecordCreate;
  return Object.hash(runtimeType,_this.rabbitId,_this.feedId,_this.cageId,_this.quantity,_this.fedAt,_this.notes);
}

@override
String toString() {
  final _this = this as FeedingRecordCreate;
  return 'FeedingRecordCreate(rabbitId: ${_this.rabbitId}, feedId: ${_this.feedId}, cageId: ${_this.cageId}, quantity: ${_this.quantity}, fedAt: ${_this.fedAt}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $FeedingRecordCreateCopyWith<$Res>  {
  factory $FeedingRecordCreateCopyWith(FeedingRecordCreate value, $Res Function(FeedingRecordCreate) _then) = _$FeedingRecordCreateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'rabbit_id') int? rabbitId,@JsonKey(name: 'feed_id') int feedId,@JsonKey(name: 'cage_id') int? cageId, double quantity,@JsonKey(name: 'fed_at')@DateTimeConverter() DateTime fedAt, String? notes
});




}
/// @nodoc
class _$FeedingRecordCreateCopyWithImpl<$Res>
    implements $FeedingRecordCreateCopyWith<$Res> {
  _$FeedingRecordCreateCopyWithImpl(this._self, this._then);

  final FeedingRecordCreate _self;
  final $Res Function(FeedingRecordCreate) _then;

/// Create a copy of FeedingRecordCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rabbitId = freezed,Object? feedId = null,Object? cageId = freezed,Object? quantity = null,Object? fedAt = null,Object? notes = freezed,}) {
  return _then(FeedingRecordCreate(
rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,feedId: null == feedId ? _self.feedId : feedId // ignore: cast_nullable_to_non_nullable
as int,cageId: freezed == cageId ? _self.cageId : cageId // ignore: cast_nullable_to_non_nullable
as int?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,fedAt: null == fedAt ? _self.fedAt : fedAt // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedingRecordCreate].
extension FeedingRecordCreatePatterns on FeedingRecordCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedingRecordCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedingRecordCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedingRecordCreate value)  $default,){
final _that = this;
switch (_that) {
case _FeedingRecordCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedingRecordCreate value)?  $default,){
final _that = this;
switch (_that) {
case _FeedingRecordCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'rabbit_id')  int? rabbitId, @JsonKey(name: 'feed_id')  int feedId, @JsonKey(name: 'cage_id')  int? cageId,  double quantity, @JsonKey(name: 'fed_at')@DateTimeConverter()  DateTime fedAt,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedingRecordCreate() when $default != null:
return $default(_that.rabbitId,_that.feedId,_that.cageId,_that.quantity,_that.fedAt,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'rabbit_id')  int? rabbitId, @JsonKey(name: 'feed_id')  int feedId, @JsonKey(name: 'cage_id')  int? cageId,  double quantity, @JsonKey(name: 'fed_at')@DateTimeConverter()  DateTime fedAt,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _FeedingRecordCreate():
return $default(_that.rabbitId,_that.feedId,_that.cageId,_that.quantity,_that.fedAt,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'rabbit_id')  int? rabbitId, @JsonKey(name: 'feed_id')  int feedId, @JsonKey(name: 'cage_id')  int? cageId,  double quantity, @JsonKey(name: 'fed_at')@DateTimeConverter()  DateTime fedAt,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _FeedingRecordCreate() when $default != null:
return $default(_that.rabbitId,_that.feedId,_that.cageId,_that.quantity,_that.fedAt,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedingRecordCreate implements FeedingRecordCreate {
  const _FeedingRecordCreate({@JsonKey(name: 'rabbit_id') this.rabbitId, @JsonKey(name: 'feed_id') required this.feedId, @JsonKey(name: 'cage_id') this.cageId, required this.quantity, @JsonKey(name: 'fed_at')@DateTimeConverter() required this.fedAt, this.notes});
  factory _FeedingRecordCreate.fromJson(Map<String, dynamic> json) => _$FeedingRecordCreateFromJson(json);

@override@JsonKey(name: 'rabbit_id') final  int? rabbitId;
@override@JsonKey(name: 'feed_id') final  int feedId;
@override@JsonKey(name: 'cage_id') final  int? cageId;
@override final  double quantity;
@override@JsonKey(name: 'fed_at')@DateTimeConverter() final  DateTime fedAt;
@override final  String? notes;

/// Create a copy of FeedingRecordCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedingRecordCreateCopyWith<_FeedingRecordCreate> get copyWith => __$FeedingRecordCreateCopyWithImpl<_FeedingRecordCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedingRecordCreateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedingRecordCreate&&(identical(other.rabbitId, rabbitId) || other.rabbitId == rabbitId)&&(identical(other.feedId, feedId) || other.feedId == feedId)&&(identical(other.cageId, cageId) || other.cageId == cageId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.fedAt, fedAt) || other.fedAt == fedAt)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,rabbitId,feedId,cageId,quantity,fedAt,notes);
}

@override
String toString() {
    return 'FeedingRecordCreate(rabbitId: $rabbitId, feedId: $feedId, cageId: $cageId, quantity: $quantity, fedAt: $fedAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$FeedingRecordCreateCopyWith<$Res> implements $FeedingRecordCreateCopyWith<$Res> {
  factory _$FeedingRecordCreateCopyWith(_FeedingRecordCreate value, $Res Function(_FeedingRecordCreate) _then) = __$FeedingRecordCreateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'rabbit_id') int? rabbitId,@JsonKey(name: 'feed_id') int feedId,@JsonKey(name: 'cage_id') int? cageId, double quantity,@JsonKey(name: 'fed_at')@DateTimeConverter() DateTime fedAt, String? notes
});




}
/// @nodoc
class __$FeedingRecordCreateCopyWithImpl<$Res>
    implements _$FeedingRecordCreateCopyWith<$Res> {
  __$FeedingRecordCreateCopyWithImpl(this._self, this._then);

  final _FeedingRecordCreate _self;
  final $Res Function(_FeedingRecordCreate) _then;

/// Create a copy of FeedingRecordCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rabbitId = freezed,Object? feedId = null,Object? cageId = freezed,Object? quantity = null,Object? fedAt = null,Object? notes = freezed,}) {
  return _then(_FeedingRecordCreate(
rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,feedId: null == feedId ? _self.feedId : feedId // ignore: cast_nullable_to_non_nullable
as int,cageId: freezed == cageId ? _self.cageId : cageId // ignore: cast_nullable_to_non_nullable
as int?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,fedAt: null == fedAt ? _self.fedAt : fedAt // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$FeedingRecordUpdate {

@JsonKey(name: 'rabbit_id') int? get rabbitId;@JsonKey(name: 'feed_id') int? get feedId;@JsonKey(name: 'cage_id') int? get cageId; double? get quantity;@JsonKey(name: 'fed_at')@NullableDateTimeConverter() DateTime? get fedAt; String? get notes;
/// Create a copy of FeedingRecordUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedingRecordUpdateCopyWith<FeedingRecordUpdate> get copyWith => _$FeedingRecordUpdateCopyWithImpl<FeedingRecordUpdate>(this as FeedingRecordUpdate, _$identity);

  /// Serializes this FeedingRecordUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeedingRecordUpdate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedingRecordUpdate&&(identical(other.rabbitId, _this.rabbitId) || other.rabbitId == _this.rabbitId)&&(identical(other.feedId, _this.feedId) || other.feedId == _this.feedId)&&(identical(other.cageId, _this.cageId) || other.cageId == _this.cageId)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.fedAt, _this.fedAt) || other.fedAt == _this.fedAt)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeedingRecordUpdate;
  return Object.hash(runtimeType,_this.rabbitId,_this.feedId,_this.cageId,_this.quantity,_this.fedAt,_this.notes);
}

@override
String toString() {
  final _this = this as FeedingRecordUpdate;
  return 'FeedingRecordUpdate(rabbitId: ${_this.rabbitId}, feedId: ${_this.feedId}, cageId: ${_this.cageId}, quantity: ${_this.quantity}, fedAt: ${_this.fedAt}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $FeedingRecordUpdateCopyWith<$Res>  {
  factory $FeedingRecordUpdateCopyWith(FeedingRecordUpdate value, $Res Function(FeedingRecordUpdate) _then) = _$FeedingRecordUpdateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'rabbit_id') int? rabbitId,@JsonKey(name: 'feed_id') int? feedId,@JsonKey(name: 'cage_id') int? cageId, double? quantity,@JsonKey(name: 'fed_at')@NullableDateTimeConverter() DateTime? fedAt, String? notes
});




}
/// @nodoc
class _$FeedingRecordUpdateCopyWithImpl<$Res>
    implements $FeedingRecordUpdateCopyWith<$Res> {
  _$FeedingRecordUpdateCopyWithImpl(this._self, this._then);

  final FeedingRecordUpdate _self;
  final $Res Function(FeedingRecordUpdate) _then;

/// Create a copy of FeedingRecordUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rabbitId = freezed,Object? feedId = freezed,Object? cageId = freezed,Object? quantity = freezed,Object? fedAt = freezed,Object? notes = freezed,}) {
  return _then(FeedingRecordUpdate(
rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,feedId: freezed == feedId ? _self.feedId : feedId // ignore: cast_nullable_to_non_nullable
as int?,cageId: freezed == cageId ? _self.cageId : cageId // ignore: cast_nullable_to_non_nullable
as int?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,fedAt: freezed == fedAt ? _self.fedAt : fedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedingRecordUpdate].
extension FeedingRecordUpdatePatterns on FeedingRecordUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedingRecordUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedingRecordUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedingRecordUpdate value)  $default,){
final _that = this;
switch (_that) {
case _FeedingRecordUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedingRecordUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _FeedingRecordUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'rabbit_id')  int? rabbitId, @JsonKey(name: 'feed_id')  int? feedId, @JsonKey(name: 'cage_id')  int? cageId,  double? quantity, @JsonKey(name: 'fed_at')@NullableDateTimeConverter()  DateTime? fedAt,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedingRecordUpdate() when $default != null:
return $default(_that.rabbitId,_that.feedId,_that.cageId,_that.quantity,_that.fedAt,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'rabbit_id')  int? rabbitId, @JsonKey(name: 'feed_id')  int? feedId, @JsonKey(name: 'cage_id')  int? cageId,  double? quantity, @JsonKey(name: 'fed_at')@NullableDateTimeConverter()  DateTime? fedAt,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _FeedingRecordUpdate():
return $default(_that.rabbitId,_that.feedId,_that.cageId,_that.quantity,_that.fedAt,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'rabbit_id')  int? rabbitId, @JsonKey(name: 'feed_id')  int? feedId, @JsonKey(name: 'cage_id')  int? cageId,  double? quantity, @JsonKey(name: 'fed_at')@NullableDateTimeConverter()  DateTime? fedAt,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _FeedingRecordUpdate() when $default != null:
return $default(_that.rabbitId,_that.feedId,_that.cageId,_that.quantity,_that.fedAt,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedingRecordUpdate implements FeedingRecordUpdate {
  const _FeedingRecordUpdate({@JsonKey(name: 'rabbit_id') this.rabbitId, @JsonKey(name: 'feed_id') this.feedId, @JsonKey(name: 'cage_id') this.cageId, this.quantity, @JsonKey(name: 'fed_at')@NullableDateTimeConverter() this.fedAt, this.notes});
  factory _FeedingRecordUpdate.fromJson(Map<String, dynamic> json) => _$FeedingRecordUpdateFromJson(json);

@override@JsonKey(name: 'rabbit_id') final  int? rabbitId;
@override@JsonKey(name: 'feed_id') final  int? feedId;
@override@JsonKey(name: 'cage_id') final  int? cageId;
@override final  double? quantity;
@override@JsonKey(name: 'fed_at')@NullableDateTimeConverter() final  DateTime? fedAt;
@override final  String? notes;

/// Create a copy of FeedingRecordUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedingRecordUpdateCopyWith<_FeedingRecordUpdate> get copyWith => __$FeedingRecordUpdateCopyWithImpl<_FeedingRecordUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedingRecordUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedingRecordUpdate&&(identical(other.rabbitId, rabbitId) || other.rabbitId == rabbitId)&&(identical(other.feedId, feedId) || other.feedId == feedId)&&(identical(other.cageId, cageId) || other.cageId == cageId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.fedAt, fedAt) || other.fedAt == fedAt)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,rabbitId,feedId,cageId,quantity,fedAt,notes);
}

@override
String toString() {
    return 'FeedingRecordUpdate(rabbitId: $rabbitId, feedId: $feedId, cageId: $cageId, quantity: $quantity, fedAt: $fedAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$FeedingRecordUpdateCopyWith<$Res> implements $FeedingRecordUpdateCopyWith<$Res> {
  factory _$FeedingRecordUpdateCopyWith(_FeedingRecordUpdate value, $Res Function(_FeedingRecordUpdate) _then) = __$FeedingRecordUpdateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'rabbit_id') int? rabbitId,@JsonKey(name: 'feed_id') int? feedId,@JsonKey(name: 'cage_id') int? cageId, double? quantity,@JsonKey(name: 'fed_at')@NullableDateTimeConverter() DateTime? fedAt, String? notes
});




}
/// @nodoc
class __$FeedingRecordUpdateCopyWithImpl<$Res>
    implements _$FeedingRecordUpdateCopyWith<$Res> {
  __$FeedingRecordUpdateCopyWithImpl(this._self, this._then);

  final _FeedingRecordUpdate _self;
  final $Res Function(_FeedingRecordUpdate) _then;

/// Create a copy of FeedingRecordUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rabbitId = freezed,Object? feedId = freezed,Object? cageId = freezed,Object? quantity = freezed,Object? fedAt = freezed,Object? notes = freezed,}) {
  return _then(_FeedingRecordUpdate(
rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,feedId: freezed == feedId ? _self.feedId : feedId // ignore: cast_nullable_to_non_nullable
as int?,cageId: freezed == cageId ? _self.cageId : cageId // ignore: cast_nullable_to_non_nullable
as int?,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,fedAt: freezed == fedAt ? _self.fedAt : fedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$FeedingStatistics {

@JsonKey(name: 'total_feedings') int get totalFeedings;@JsonKey(name: 'quantity_by_unit') Map<String, double> get quantityByUnit;@JsonKey(name: 'by_feed_type') Map<String, Map<String, double>> get byFeedType;@JsonKey(name: 'by_feed') Map<String, FeedingByFeed> get byFeed;@JsonKey(name: 'total_cost') double get totalCost;
/// Create a copy of FeedingStatistics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedingStatisticsCopyWith<FeedingStatistics> get copyWith => _$FeedingStatisticsCopyWithImpl<FeedingStatistics>(this as FeedingStatistics, _$identity);

  /// Serializes this FeedingStatistics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeedingStatistics;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedingStatistics&&(identical(other.totalFeedings, _this.totalFeedings) || other.totalFeedings == _this.totalFeedings)&&const DeepCollectionEquality().equals(other.quantityByUnit, _this.quantityByUnit)&&const DeepCollectionEquality().equals(other.byFeedType, _this.byFeedType)&&const DeepCollectionEquality().equals(other.byFeed, _this.byFeed)&&(identical(other.totalCost, _this.totalCost) || other.totalCost == _this.totalCost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeedingStatistics;
  return Object.hash(runtimeType,_this.totalFeedings,const DeepCollectionEquality().hash(_this.quantityByUnit),const DeepCollectionEquality().hash(_this.byFeedType),const DeepCollectionEquality().hash(_this.byFeed),_this.totalCost);
}

@override
String toString() {
  final _this = this as FeedingStatistics;
  return 'FeedingStatistics(totalFeedings: ${_this.totalFeedings}, quantityByUnit: ${_this.quantityByUnit}, byFeedType: ${_this.byFeedType}, byFeed: ${_this.byFeed}, totalCost: ${_this.totalCost})';
}


}

/// @nodoc
abstract mixin class $FeedingStatisticsCopyWith<$Res>  {
  factory $FeedingStatisticsCopyWith(FeedingStatistics value, $Res Function(FeedingStatistics) _then) = _$FeedingStatisticsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_feedings') int totalFeedings,@JsonKey(name: 'quantity_by_unit') Map<String, double> quantityByUnit,@JsonKey(name: 'by_feed_type') Map<String, Map<String, double>> byFeedType,@JsonKey(name: 'by_feed') Map<String, FeedingByFeed> byFeed,@JsonKey(name: 'total_cost') double totalCost
});




}
/// @nodoc
class _$FeedingStatisticsCopyWithImpl<$Res>
    implements $FeedingStatisticsCopyWith<$Res> {
  _$FeedingStatisticsCopyWithImpl(this._self, this._then);

  final FeedingStatistics _self;
  final $Res Function(FeedingStatistics) _then;

/// Create a copy of FeedingStatistics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalFeedings = null,Object? quantityByUnit = null,Object? byFeedType = null,Object? byFeed = null,Object? totalCost = null,}) {
  return _then(FeedingStatistics(
totalFeedings: null == totalFeedings ? _self.totalFeedings : totalFeedings // ignore: cast_nullable_to_non_nullable
as int,quantityByUnit: null == quantityByUnit ? _self.quantityByUnit : quantityByUnit // ignore: cast_nullable_to_non_nullable
as Map<String, double>,byFeedType: null == byFeedType ? _self.byFeedType : byFeedType // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, double>>,byFeed: null == byFeed ? _self.byFeed : byFeed // ignore: cast_nullable_to_non_nullable
as Map<String, FeedingByFeed>,totalCost: null == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedingStatistics].
extension FeedingStatisticsPatterns on FeedingStatistics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedingStatistics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedingStatistics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedingStatistics value)  $default,){
final _that = this;
switch (_that) {
case _FeedingStatistics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedingStatistics value)?  $default,){
final _that = this;
switch (_that) {
case _FeedingStatistics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_feedings')  int totalFeedings, @JsonKey(name: 'quantity_by_unit')  Map<String, double> quantityByUnit, @JsonKey(name: 'by_feed_type')  Map<String, Map<String, double>> byFeedType, @JsonKey(name: 'by_feed')  Map<String, FeedingByFeed> byFeed, @JsonKey(name: 'total_cost')  double totalCost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedingStatistics() when $default != null:
return $default(_that.totalFeedings,_that.quantityByUnit,_that.byFeedType,_that.byFeed,_that.totalCost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_feedings')  int totalFeedings, @JsonKey(name: 'quantity_by_unit')  Map<String, double> quantityByUnit, @JsonKey(name: 'by_feed_type')  Map<String, Map<String, double>> byFeedType, @JsonKey(name: 'by_feed')  Map<String, FeedingByFeed> byFeed, @JsonKey(name: 'total_cost')  double totalCost)  $default,) {final _that = this;
switch (_that) {
case _FeedingStatistics():
return $default(_that.totalFeedings,_that.quantityByUnit,_that.byFeedType,_that.byFeed,_that.totalCost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_feedings')  int totalFeedings, @JsonKey(name: 'quantity_by_unit')  Map<String, double> quantityByUnit, @JsonKey(name: 'by_feed_type')  Map<String, Map<String, double>> byFeedType, @JsonKey(name: 'by_feed')  Map<String, FeedingByFeed> byFeed, @JsonKey(name: 'total_cost')  double totalCost)?  $default,) {final _that = this;
switch (_that) {
case _FeedingStatistics() when $default != null:
return $default(_that.totalFeedings,_that.quantityByUnit,_that.byFeedType,_that.byFeed,_that.totalCost);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedingStatistics implements FeedingStatistics {
  const _FeedingStatistics({@JsonKey(name: 'total_feedings') required this.totalFeedings, @JsonKey(name: 'quantity_by_unit')  Map<String, double> quantityByUnit = const {}, @JsonKey(name: 'by_feed_type')  Map<String, Map<String, double>> byFeedType = const {}, @JsonKey(name: 'by_feed')  Map<String, FeedingByFeed> byFeed = const {}, @JsonKey(name: 'total_cost') required this.totalCost}): _quantityByUnit = quantityByUnit,_byFeedType = byFeedType,_byFeed = byFeed;
  factory _FeedingStatistics.fromJson(Map<String, dynamic> json) => _$FeedingStatisticsFromJson(json);

@override@JsonKey(name: 'total_feedings') final  int totalFeedings;
 final  Map<String, double> _quantityByUnit;
@override@JsonKey(name: 'quantity_by_unit') Map<String, double> get quantityByUnit {
  if (_quantityByUnit is EqualUnmodifiableMapView) return _quantityByUnit;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_quantityByUnit);
}

 final  Map<String, Map<String, double>> _byFeedType;
@override@JsonKey(name: 'by_feed_type') Map<String, Map<String, double>> get byFeedType {
  if (_byFeedType is EqualUnmodifiableMapView) return _byFeedType;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_byFeedType);
}

 final  Map<String, FeedingByFeed> _byFeed;
@override@JsonKey(name: 'by_feed') Map<String, FeedingByFeed> get byFeed {
  if (_byFeed is EqualUnmodifiableMapView) return _byFeed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_byFeed);
}

@override@JsonKey(name: 'total_cost') final  double totalCost;

/// Create a copy of FeedingStatistics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedingStatisticsCopyWith<_FeedingStatistics> get copyWith => __$FeedingStatisticsCopyWithImpl<_FeedingStatistics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedingStatisticsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedingStatistics&&(identical(other.totalFeedings, totalFeedings) || other.totalFeedings == totalFeedings)&&const DeepCollectionEquality().equals(other.quantityByUnit, _quantityByUnit)&&const DeepCollectionEquality().equals(other.byFeedType, _byFeedType)&&const DeepCollectionEquality().equals(other.byFeed, _byFeed)&&(identical(other.totalCost, totalCost) || other.totalCost == totalCost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalFeedings,const DeepCollectionEquality().hash(_quantityByUnit),const DeepCollectionEquality().hash(_byFeedType),const DeepCollectionEquality().hash(_byFeed),totalCost);
}

@override
String toString() {
    return 'FeedingStatistics(totalFeedings: $totalFeedings, quantityByUnit: $quantityByUnit, byFeedType: $byFeedType, byFeed: $byFeed, totalCost: $totalCost)';
}


}

/// @nodoc
abstract mixin class _$FeedingStatisticsCopyWith<$Res> implements $FeedingStatisticsCopyWith<$Res> {
  factory _$FeedingStatisticsCopyWith(_FeedingStatistics value, $Res Function(_FeedingStatistics) _then) = __$FeedingStatisticsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_feedings') int totalFeedings,@JsonKey(name: 'quantity_by_unit') Map<String, double> quantityByUnit,@JsonKey(name: 'by_feed_type') Map<String, Map<String, double>> byFeedType,@JsonKey(name: 'by_feed') Map<String, FeedingByFeed> byFeed,@JsonKey(name: 'total_cost') double totalCost
});




}
/// @nodoc
class __$FeedingStatisticsCopyWithImpl<$Res>
    implements _$FeedingStatisticsCopyWith<$Res> {
  __$FeedingStatisticsCopyWithImpl(this._self, this._then);

  final _FeedingStatistics _self;
  final $Res Function(_FeedingStatistics) _then;

/// Create a copy of FeedingStatistics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalFeedings = null,Object? quantityByUnit = null,Object? byFeedType = null,Object? byFeed = null,Object? totalCost = null,}) {
  return _then(_FeedingStatistics(
totalFeedings: null == totalFeedings ? _self.totalFeedings : totalFeedings // ignore: cast_nullable_to_non_nullable
as int,quantityByUnit: null == quantityByUnit ? _self._quantityByUnit : quantityByUnit // ignore: cast_nullable_to_non_nullable
as Map<String, double>,byFeedType: null == byFeedType ? _self._byFeedType : byFeedType // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, double>>,byFeed: null == byFeed ? _self._byFeed : byFeed // ignore: cast_nullable_to_non_nullable
as Map<String, FeedingByFeed>,totalCost: null == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$FeedingByFeed {

 double get quantity; String get unit; double get cost;
/// Create a copy of FeedingByFeed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedingByFeedCopyWith<FeedingByFeed> get copyWith => _$FeedingByFeedCopyWithImpl<FeedingByFeed>(this as FeedingByFeed, _$identity);

  /// Serializes this FeedingByFeed to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeedingByFeed;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedingByFeed&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.cost, _this.cost) || other.cost == _this.cost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeedingByFeed;
  return Object.hash(runtimeType,_this.quantity,_this.unit,_this.cost);
}

@override
String toString() {
  final _this = this as FeedingByFeed;
  return 'FeedingByFeed(quantity: ${_this.quantity}, unit: ${_this.unit}, cost: ${_this.cost})';
}


}

/// @nodoc
abstract mixin class $FeedingByFeedCopyWith<$Res>  {
  factory $FeedingByFeedCopyWith(FeedingByFeed value, $Res Function(FeedingByFeed) _then) = _$FeedingByFeedCopyWithImpl;
@useResult
$Res call({
 double quantity, String unit, double cost
});




}
/// @nodoc
class _$FeedingByFeedCopyWithImpl<$Res>
    implements $FeedingByFeedCopyWith<$Res> {
  _$FeedingByFeedCopyWithImpl(this._self, this._then);

  final FeedingByFeed _self;
  final $Res Function(FeedingByFeed) _then;

/// Create a copy of FeedingByFeed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quantity = null,Object? unit = null,Object? cost = null,}) {
  return _then(FeedingByFeed(
quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedingByFeed].
extension FeedingByFeedPatterns on FeedingByFeed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedingByFeed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedingByFeed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedingByFeed value)  $default,){
final _that = this;
switch (_that) {
case _FeedingByFeed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedingByFeed value)?  $default,){
final _that = this;
switch (_that) {
case _FeedingByFeed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double quantity,  String unit,  double cost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedingByFeed() when $default != null:
return $default(_that.quantity,_that.unit,_that.cost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double quantity,  String unit,  double cost)  $default,) {final _that = this;
switch (_that) {
case _FeedingByFeed():
return $default(_that.quantity,_that.unit,_that.cost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double quantity,  String unit,  double cost)?  $default,) {final _that = this;
switch (_that) {
case _FeedingByFeed() when $default != null:
return $default(_that.quantity,_that.unit,_that.cost);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedingByFeed implements FeedingByFeed {
  const _FeedingByFeed({required this.quantity, required this.unit, required this.cost});
  factory _FeedingByFeed.fromJson(Map<String, dynamic> json) => _$FeedingByFeedFromJson(json);

@override final  double quantity;
@override final  String unit;
@override final  double cost;

/// Create a copy of FeedingByFeed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedingByFeedCopyWith<_FeedingByFeed> get copyWith => __$FeedingByFeedCopyWithImpl<_FeedingByFeed>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedingByFeedToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedingByFeed&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.cost, cost) || other.cost == cost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,quantity,unit,cost);
}

@override
String toString() {
    return 'FeedingByFeed(quantity: $quantity, unit: $unit, cost: $cost)';
}


}

/// @nodoc
abstract mixin class _$FeedingByFeedCopyWith<$Res> implements $FeedingByFeedCopyWith<$Res> {
  factory _$FeedingByFeedCopyWith(_FeedingByFeed value, $Res Function(_FeedingByFeed) _then) = __$FeedingByFeedCopyWithImpl;
@override @useResult
$Res call({
 double quantity, String unit, double cost
});




}
/// @nodoc
class __$FeedingByFeedCopyWithImpl<$Res>
    implements _$FeedingByFeedCopyWith<$Res> {
  __$FeedingByFeedCopyWithImpl(this._self, this._then);

  final _FeedingByFeed _self;
  final $Res Function(_FeedingByFeed) _then;

/// Create a copy of FeedingByFeed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quantity = null,Object? unit = null,Object? cost = null,}) {
  return _then(_FeedingByFeed(
quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
