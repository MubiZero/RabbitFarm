// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rabbit_photo_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RabbitPhoto {

@IntConverter() int get id; String get url; String? get caption;@JsonKey(name: 'taken_at')@NullableDateTimeConverter() DateTime? get takenAt;@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? get createdAt; UserRef? get author;@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? get rabbitId; RabbitRef? get rabbit;
/// Create a copy of RabbitPhoto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RabbitPhotoCopyWith<RabbitPhoto> get copyWith => _$RabbitPhotoCopyWithImpl<RabbitPhoto>(this as RabbitPhoto, _$identity);

  /// Serializes this RabbitPhoto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RabbitPhoto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RabbitPhoto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.caption, _this.caption) || other.caption == _this.caption)&&(identical(other.takenAt, _this.takenAt) || other.takenAt == _this.takenAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.rabbitId, _this.rabbitId) || other.rabbitId == _this.rabbitId)&&(identical(other.rabbit, _this.rabbit) || other.rabbit == _this.rabbit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RabbitPhoto;
  return Object.hash(runtimeType,_this.id,_this.url,_this.caption,_this.takenAt,_this.createdAt,_this.author,_this.rabbitId,_this.rabbit);
}

@override
String toString() {
  final _this = this as RabbitPhoto;
  return 'RabbitPhoto(id: ${_this.id}, url: ${_this.url}, caption: ${_this.caption}, takenAt: ${_this.takenAt}, createdAt: ${_this.createdAt}, author: ${_this.author}, rabbitId: ${_this.rabbitId}, rabbit: ${_this.rabbit})';
}


}

/// @nodoc
abstract mixin class $RabbitPhotoCopyWith<$Res>  {
  factory $RabbitPhotoCopyWith(RabbitPhoto value, $Res Function(RabbitPhoto) _then) = _$RabbitPhotoCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id, String url, String? caption,@JsonKey(name: 'taken_at')@NullableDateTimeConverter() DateTime? takenAt,@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? createdAt, UserRef? author,@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? rabbitId, RabbitRef? rabbit
});


$UserRefCopyWith<$Res>? get author;$RabbitRefCopyWith<$Res>? get rabbit;

}
/// @nodoc
class _$RabbitPhotoCopyWithImpl<$Res>
    implements $RabbitPhotoCopyWith<$Res> {
  _$RabbitPhotoCopyWithImpl(this._self, this._then);

  final RabbitPhoto _self;
  final $Res Function(RabbitPhoto) _then;

/// Create a copy of RabbitPhoto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? url = null,Object? caption = freezed,Object? takenAt = freezed,Object? createdAt = freezed,Object? author = freezed,Object? rabbitId = freezed,Object? rabbit = freezed,}) {
  return _then(RabbitPhoto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,takenAt: freezed == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserRef?,rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,rabbit: freezed == rabbit ? _self.rabbit : rabbit // ignore: cast_nullable_to_non_nullable
as RabbitRef?,
  ));
}
/// Create a copy of RabbitPhoto
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
}/// Create a copy of RabbitPhoto
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
}
}


/// Adds pattern-matching-related methods to [RabbitPhoto].
extension RabbitPhotoPatterns on RabbitPhoto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RabbitPhoto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RabbitPhoto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RabbitPhoto value)  $default,){
final _that = this;
switch (_that) {
case _RabbitPhoto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RabbitPhoto value)?  $default,){
final _that = this;
switch (_that) {
case _RabbitPhoto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String url,  String? caption, @JsonKey(name: 'taken_at')@NullableDateTimeConverter()  DateTime? takenAt, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt,  UserRef? author, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId,  RabbitRef? rabbit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RabbitPhoto() when $default != null:
return $default(_that.id,_that.url,_that.caption,_that.takenAt,_that.createdAt,_that.author,_that.rabbitId,_that.rabbit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String url,  String? caption, @JsonKey(name: 'taken_at')@NullableDateTimeConverter()  DateTime? takenAt, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt,  UserRef? author, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId,  RabbitRef? rabbit)  $default,) {final _that = this;
switch (_that) {
case _RabbitPhoto():
return $default(_that.id,_that.url,_that.caption,_that.takenAt,_that.createdAt,_that.author,_that.rabbitId,_that.rabbit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id,  String url,  String? caption, @JsonKey(name: 'taken_at')@NullableDateTimeConverter()  DateTime? takenAt, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt,  UserRef? author, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId,  RabbitRef? rabbit)?  $default,) {final _that = this;
switch (_that) {
case _RabbitPhoto() when $default != null:
return $default(_that.id,_that.url,_that.caption,_that.takenAt,_that.createdAt,_that.author,_that.rabbitId,_that.rabbit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RabbitPhoto implements RabbitPhoto {
  const _RabbitPhoto({@IntConverter() required this.id, required this.url, this.caption, @JsonKey(name: 'taken_at')@NullableDateTimeConverter() this.takenAt, @JsonKey(name: 'created_at')@NullableDateTimeConverter() this.createdAt, this.author, @JsonKey(name: 'rabbit_id')@NullableIntConverter() this.rabbitId, this.rabbit});
  factory _RabbitPhoto.fromJson(Map<String, dynamic> json) => _$RabbitPhotoFromJson(json);

@override@IntConverter() final  int id;
@override final  String url;
@override final  String? caption;
@override@JsonKey(name: 'taken_at')@NullableDateTimeConverter() final  DateTime? takenAt;
@override@JsonKey(name: 'created_at')@NullableDateTimeConverter() final  DateTime? createdAt;
@override final  UserRef? author;
@override@JsonKey(name: 'rabbit_id')@NullableIntConverter() final  int? rabbitId;
@override final  RabbitRef? rabbit;

/// Create a copy of RabbitPhoto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RabbitPhotoCopyWith<_RabbitPhoto> get copyWith => __$RabbitPhotoCopyWithImpl<_RabbitPhoto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RabbitPhotoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RabbitPhoto&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.author, author) || other.author == author)&&(identical(other.rabbitId, rabbitId) || other.rabbitId == rabbitId)&&(identical(other.rabbit, rabbit) || other.rabbit == rabbit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,url,caption,takenAt,createdAt,author,rabbitId,rabbit);
}

@override
String toString() {
    return 'RabbitPhoto(id: $id, url: $url, caption: $caption, takenAt: $takenAt, createdAt: $createdAt, author: $author, rabbitId: $rabbitId, rabbit: $rabbit)';
}


}

/// @nodoc
abstract mixin class _$RabbitPhotoCopyWith<$Res> implements $RabbitPhotoCopyWith<$Res> {
  factory _$RabbitPhotoCopyWith(_RabbitPhoto value, $Res Function(_RabbitPhoto) _then) = __$RabbitPhotoCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id, String url, String? caption,@JsonKey(name: 'taken_at')@NullableDateTimeConverter() DateTime? takenAt,@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? createdAt, UserRef? author,@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? rabbitId, RabbitRef? rabbit
});


@override $UserRefCopyWith<$Res>? get author;@override $RabbitRefCopyWith<$Res>? get rabbit;

}
/// @nodoc
class __$RabbitPhotoCopyWithImpl<$Res>
    implements _$RabbitPhotoCopyWith<$Res> {
  __$RabbitPhotoCopyWithImpl(this._self, this._then);

  final _RabbitPhoto _self;
  final $Res Function(_RabbitPhoto) _then;

/// Create a copy of RabbitPhoto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? url = null,Object? caption = freezed,Object? takenAt = freezed,Object? createdAt = freezed,Object? author = freezed,Object? rabbitId = freezed,Object? rabbit = freezed,}) {
  return _then(_RabbitPhoto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,takenAt: freezed == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserRef?,rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,rabbit: freezed == rabbit ? _self.rabbit : rabbit // ignore: cast_nullable_to_non_nullable
as RabbitRef?,
  ));
}

/// Create a copy of RabbitPhoto
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
}/// Create a copy of RabbitPhoto
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
}
}

// dart format on
