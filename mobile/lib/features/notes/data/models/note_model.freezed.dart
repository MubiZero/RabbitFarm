// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NoteModel {

@IntConverter() int get id; String get content;@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? get rabbitId;@JsonKey(name: 'cage_id')@NullableIntConverter() int? get cageId;@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? get createdAt; RabbitRef? get rabbit; CageInfo? get cage; UserRef? get author;
/// Create a copy of NoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteModelCopyWith<NoteModel> get copyWith => _$NoteModelCopyWithImpl<NoteModel>(this as NoteModel, _$identity);

  /// Serializes this NoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NoteModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.rabbitId, _this.rabbitId) || other.rabbitId == _this.rabbitId)&&(identical(other.cageId, _this.cageId) || other.cageId == _this.cageId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.rabbit, _this.rabbit) || other.rabbit == _this.rabbit)&&(identical(other.cage, _this.cage) || other.cage == _this.cage)&&(identical(other.author, _this.author) || other.author == _this.author));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NoteModel;
  return Object.hash(runtimeType,_this.id,_this.content,_this.rabbitId,_this.cageId,_this.createdAt,_this.rabbit,_this.cage,_this.author);
}

@override
String toString() {
  final _this = this as NoteModel;
  return 'NoteModel(id: ${_this.id}, content: ${_this.content}, rabbitId: ${_this.rabbitId}, cageId: ${_this.cageId}, createdAt: ${_this.createdAt}, rabbit: ${_this.rabbit}, cage: ${_this.cage}, author: ${_this.author})';
}


}

/// @nodoc
abstract mixin class $NoteModelCopyWith<$Res>  {
  factory $NoteModelCopyWith(NoteModel value, $Res Function(NoteModel) _then) = _$NoteModelCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id, String content,@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? rabbitId,@JsonKey(name: 'cage_id')@NullableIntConverter() int? cageId,@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? createdAt, RabbitRef? rabbit, CageInfo? cage, UserRef? author
});


$RabbitRefCopyWith<$Res>? get rabbit;$CageInfoCopyWith<$Res>? get cage;$UserRefCopyWith<$Res>? get author;

}
/// @nodoc
class _$NoteModelCopyWithImpl<$Res>
    implements $NoteModelCopyWith<$Res> {
  _$NoteModelCopyWithImpl(this._self, this._then);

  final NoteModel _self;
  final $Res Function(NoteModel) _then;

/// Create a copy of NoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? content = null,Object? rabbitId = freezed,Object? cageId = freezed,Object? createdAt = freezed,Object? rabbit = freezed,Object? cage = freezed,Object? author = freezed,}) {
  return _then(NoteModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,cageId: freezed == cageId ? _self.cageId : cageId // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rabbit: freezed == rabbit ? _self.rabbit : rabbit // ignore: cast_nullable_to_non_nullable
as RabbitRef?,cage: freezed == cage ? _self.cage : cage // ignore: cast_nullable_to_non_nullable
as CageInfo?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserRef?,
  ));
}
/// Create a copy of NoteModel
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
}/// Create a copy of NoteModel
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
}/// Create a copy of NoteModel
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


/// Adds pattern-matching-related methods to [NoteModel].
extension NoteModelPatterns on NoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoteModel value)  $default,){
final _that = this;
switch (_that) {
case _NoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _NoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String content, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId, @JsonKey(name: 'cage_id')@NullableIntConverter()  int? cageId, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt,  RabbitRef? rabbit,  CageInfo? cage,  UserRef? author)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoteModel() when $default != null:
return $default(_that.id,_that.content,_that.rabbitId,_that.cageId,_that.createdAt,_that.rabbit,_that.cage,_that.author);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String content, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId, @JsonKey(name: 'cage_id')@NullableIntConverter()  int? cageId, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt,  RabbitRef? rabbit,  CageInfo? cage,  UserRef? author)  $default,) {final _that = this;
switch (_that) {
case _NoteModel():
return $default(_that.id,_that.content,_that.rabbitId,_that.cageId,_that.createdAt,_that.rabbit,_that.cage,_that.author);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id,  String content, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId, @JsonKey(name: 'cage_id')@NullableIntConverter()  int? cageId, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt,  RabbitRef? rabbit,  CageInfo? cage,  UserRef? author)?  $default,) {final _that = this;
switch (_that) {
case _NoteModel() when $default != null:
return $default(_that.id,_that.content,_that.rabbitId,_that.cageId,_that.createdAt,_that.rabbit,_that.cage,_that.author);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NoteModel implements NoteModel {
  const _NoteModel({@IntConverter() required this.id, required this.content, @JsonKey(name: 'rabbit_id')@NullableIntConverter() this.rabbitId, @JsonKey(name: 'cage_id')@NullableIntConverter() this.cageId, @JsonKey(name: 'created_at')@NullableDateTimeConverter() this.createdAt, this.rabbit, this.cage, this.author});
  factory _NoteModel.fromJson(Map<String, dynamic> json) => _$NoteModelFromJson(json);

@override@IntConverter() final  int id;
@override final  String content;
@override@JsonKey(name: 'rabbit_id')@NullableIntConverter() final  int? rabbitId;
@override@JsonKey(name: 'cage_id')@NullableIntConverter() final  int? cageId;
@override@JsonKey(name: 'created_at')@NullableDateTimeConverter() final  DateTime? createdAt;
@override final  RabbitRef? rabbit;
@override final  CageInfo? cage;
@override final  UserRef? author;

/// Create a copy of NoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteModelCopyWith<_NoteModel> get copyWith => __$NoteModelCopyWithImpl<_NoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteModel&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.rabbitId, rabbitId) || other.rabbitId == rabbitId)&&(identical(other.cageId, cageId) || other.cageId == cageId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.rabbit, rabbit) || other.rabbit == rabbit)&&(identical(other.cage, cage) || other.cage == cage)&&(identical(other.author, author) || other.author == author));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,content,rabbitId,cageId,createdAt,rabbit,cage,author);
}

@override
String toString() {
    return 'NoteModel(id: $id, content: $content, rabbitId: $rabbitId, cageId: $cageId, createdAt: $createdAt, rabbit: $rabbit, cage: $cage, author: $author)';
}


}

/// @nodoc
abstract mixin class _$NoteModelCopyWith<$Res> implements $NoteModelCopyWith<$Res> {
  factory _$NoteModelCopyWith(_NoteModel value, $Res Function(_NoteModel) _then) = __$NoteModelCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id, String content,@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? rabbitId,@JsonKey(name: 'cage_id')@NullableIntConverter() int? cageId,@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? createdAt, RabbitRef? rabbit, CageInfo? cage, UserRef? author
});


@override $RabbitRefCopyWith<$Res>? get rabbit;@override $CageInfoCopyWith<$Res>? get cage;@override $UserRefCopyWith<$Res>? get author;

}
/// @nodoc
class __$NoteModelCopyWithImpl<$Res>
    implements _$NoteModelCopyWith<$Res> {
  __$NoteModelCopyWithImpl(this._self, this._then);

  final _NoteModel _self;
  final $Res Function(_NoteModel) _then;

/// Create a copy of NoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? content = null,Object? rabbitId = freezed,Object? cageId = freezed,Object? createdAt = freezed,Object? rabbit = freezed,Object? cage = freezed,Object? author = freezed,}) {
  return _then(_NoteModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,cageId: freezed == cageId ? _self.cageId : cageId // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rabbit: freezed == rabbit ? _self.rabbit : rabbit // ignore: cast_nullable_to_non_nullable
as RabbitRef?,cage: freezed == cage ? _self.cage : cage // ignore: cast_nullable_to_non_nullable
as CageInfo?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserRef?,
  ));
}

/// Create a copy of NoteModel
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
}/// Create a copy of NoteModel
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
}/// Create a copy of NoteModel
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
mixin _$NoteCreate {

 String get content;@JsonKey(name: 'rabbit_id') int? get rabbitId;@JsonKey(name: 'cage_id') int? get cageId;
/// Create a copy of NoteCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteCreateCopyWith<NoteCreate> get copyWith => _$NoteCreateCopyWithImpl<NoteCreate>(this as NoteCreate, _$identity);

  /// Serializes this NoteCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NoteCreate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteCreate&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.rabbitId, _this.rabbitId) || other.rabbitId == _this.rabbitId)&&(identical(other.cageId, _this.cageId) || other.cageId == _this.cageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NoteCreate;
  return Object.hash(runtimeType,_this.content,_this.rabbitId,_this.cageId);
}

@override
String toString() {
  final _this = this as NoteCreate;
  return 'NoteCreate(content: ${_this.content}, rabbitId: ${_this.rabbitId}, cageId: ${_this.cageId})';
}


}

/// @nodoc
abstract mixin class $NoteCreateCopyWith<$Res>  {
  factory $NoteCreateCopyWith(NoteCreate value, $Res Function(NoteCreate) _then) = _$NoteCreateCopyWithImpl;
@useResult
$Res call({
 String content,@JsonKey(name: 'rabbit_id') int? rabbitId,@JsonKey(name: 'cage_id') int? cageId
});




}
/// @nodoc
class _$NoteCreateCopyWithImpl<$Res>
    implements $NoteCreateCopyWith<$Res> {
  _$NoteCreateCopyWithImpl(this._self, this._then);

  final NoteCreate _self;
  final $Res Function(NoteCreate) _then;

/// Create a copy of NoteCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? rabbitId = freezed,Object? cageId = freezed,}) {
  return _then(NoteCreate(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,cageId: freezed == cageId ? _self.cageId : cageId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [NoteCreate].
extension NoteCreatePatterns on NoteCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoteCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoteCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoteCreate value)  $default,){
final _that = this;
switch (_that) {
case _NoteCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoteCreate value)?  $default,){
final _that = this;
switch (_that) {
case _NoteCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String content, @JsonKey(name: 'rabbit_id')  int? rabbitId, @JsonKey(name: 'cage_id')  int? cageId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoteCreate() when $default != null:
return $default(_that.content,_that.rabbitId,_that.cageId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String content, @JsonKey(name: 'rabbit_id')  int? rabbitId, @JsonKey(name: 'cage_id')  int? cageId)  $default,) {final _that = this;
switch (_that) {
case _NoteCreate():
return $default(_that.content,_that.rabbitId,_that.cageId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String content, @JsonKey(name: 'rabbit_id')  int? rabbitId, @JsonKey(name: 'cage_id')  int? cageId)?  $default,) {final _that = this;
switch (_that) {
case _NoteCreate() when $default != null:
return $default(_that.content,_that.rabbitId,_that.cageId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NoteCreate implements NoteCreate {
  const _NoteCreate({required this.content, @JsonKey(name: 'rabbit_id') this.rabbitId, @JsonKey(name: 'cage_id') this.cageId});
  factory _NoteCreate.fromJson(Map<String, dynamic> json) => _$NoteCreateFromJson(json);

@override final  String content;
@override@JsonKey(name: 'rabbit_id') final  int? rabbitId;
@override@JsonKey(name: 'cage_id') final  int? cageId;

/// Create a copy of NoteCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteCreateCopyWith<_NoteCreate> get copyWith => __$NoteCreateCopyWithImpl<_NoteCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoteCreateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteCreate&&(identical(other.content, content) || other.content == content)&&(identical(other.rabbitId, rabbitId) || other.rabbitId == rabbitId)&&(identical(other.cageId, cageId) || other.cageId == cageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,content,rabbitId,cageId);
}

@override
String toString() {
    return 'NoteCreate(content: $content, rabbitId: $rabbitId, cageId: $cageId)';
}


}

/// @nodoc
abstract mixin class _$NoteCreateCopyWith<$Res> implements $NoteCreateCopyWith<$Res> {
  factory _$NoteCreateCopyWith(_NoteCreate value, $Res Function(_NoteCreate) _then) = __$NoteCreateCopyWithImpl;
@override @useResult
$Res call({
 String content,@JsonKey(name: 'rabbit_id') int? rabbitId,@JsonKey(name: 'cage_id') int? cageId
});




}
/// @nodoc
class __$NoteCreateCopyWithImpl<$Res>
    implements _$NoteCreateCopyWith<$Res> {
  __$NoteCreateCopyWithImpl(this._self, this._then);

  final _NoteCreate _self;
  final $Res Function(_NoteCreate) _then;

/// Create a copy of NoteCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? rabbitId = freezed,Object? cageId = freezed,}) {
  return _then(_NoteCreate(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,cageId: freezed == cageId ? _self.cageId : cageId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$NoteUpdate {

 String? get content;@JsonKey(name: 'rabbit_id') int? get rabbitId;@JsonKey(name: 'cage_id') int? get cageId;
/// Create a copy of NoteUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteUpdateCopyWith<NoteUpdate> get copyWith => _$NoteUpdateCopyWithImpl<NoteUpdate>(this as NoteUpdate, _$identity);

  /// Serializes this NoteUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NoteUpdate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteUpdate&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.rabbitId, _this.rabbitId) || other.rabbitId == _this.rabbitId)&&(identical(other.cageId, _this.cageId) || other.cageId == _this.cageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NoteUpdate;
  return Object.hash(runtimeType,_this.content,_this.rabbitId,_this.cageId);
}

@override
String toString() {
  final _this = this as NoteUpdate;
  return 'NoteUpdate(content: ${_this.content}, rabbitId: ${_this.rabbitId}, cageId: ${_this.cageId})';
}


}

/// @nodoc
abstract mixin class $NoteUpdateCopyWith<$Res>  {
  factory $NoteUpdateCopyWith(NoteUpdate value, $Res Function(NoteUpdate) _then) = _$NoteUpdateCopyWithImpl;
@useResult
$Res call({
 String? content,@JsonKey(name: 'rabbit_id') int? rabbitId,@JsonKey(name: 'cage_id') int? cageId
});




}
/// @nodoc
class _$NoteUpdateCopyWithImpl<$Res>
    implements $NoteUpdateCopyWith<$Res> {
  _$NoteUpdateCopyWithImpl(this._self, this._then);

  final NoteUpdate _self;
  final $Res Function(NoteUpdate) _then;

/// Create a copy of NoteUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = freezed,Object? rabbitId = freezed,Object? cageId = freezed,}) {
  return _then(NoteUpdate(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,cageId: freezed == cageId ? _self.cageId : cageId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [NoteUpdate].
extension NoteUpdatePatterns on NoteUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoteUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoteUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoteUpdate value)  $default,){
final _that = this;
switch (_that) {
case _NoteUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoteUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _NoteUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? content, @JsonKey(name: 'rabbit_id')  int? rabbitId, @JsonKey(name: 'cage_id')  int? cageId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoteUpdate() when $default != null:
return $default(_that.content,_that.rabbitId,_that.cageId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? content, @JsonKey(name: 'rabbit_id')  int? rabbitId, @JsonKey(name: 'cage_id')  int? cageId)  $default,) {final _that = this;
switch (_that) {
case _NoteUpdate():
return $default(_that.content,_that.rabbitId,_that.cageId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? content, @JsonKey(name: 'rabbit_id')  int? rabbitId, @JsonKey(name: 'cage_id')  int? cageId)?  $default,) {final _that = this;
switch (_that) {
case _NoteUpdate() when $default != null:
return $default(_that.content,_that.rabbitId,_that.cageId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NoteUpdate implements NoteUpdate {
  const _NoteUpdate({this.content, @JsonKey(name: 'rabbit_id') this.rabbitId, @JsonKey(name: 'cage_id') this.cageId});
  factory _NoteUpdate.fromJson(Map<String, dynamic> json) => _$NoteUpdateFromJson(json);

@override final  String? content;
@override@JsonKey(name: 'rabbit_id') final  int? rabbitId;
@override@JsonKey(name: 'cage_id') final  int? cageId;

/// Create a copy of NoteUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteUpdateCopyWith<_NoteUpdate> get copyWith => __$NoteUpdateCopyWithImpl<_NoteUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NoteUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteUpdate&&(identical(other.content, content) || other.content == content)&&(identical(other.rabbitId, rabbitId) || other.rabbitId == rabbitId)&&(identical(other.cageId, cageId) || other.cageId == cageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,content,rabbitId,cageId);
}

@override
String toString() {
    return 'NoteUpdate(content: $content, rabbitId: $rabbitId, cageId: $cageId)';
}


}

/// @nodoc
abstract mixin class _$NoteUpdateCopyWith<$Res> implements $NoteUpdateCopyWith<$Res> {
  factory _$NoteUpdateCopyWith(_NoteUpdate value, $Res Function(_NoteUpdate) _then) = __$NoteUpdateCopyWithImpl;
@override @useResult
$Res call({
 String? content,@JsonKey(name: 'rabbit_id') int? rabbitId,@JsonKey(name: 'cage_id') int? cageId
});




}
/// @nodoc
class __$NoteUpdateCopyWithImpl<$Res>
    implements _$NoteUpdateCopyWith<$Res> {
  __$NoteUpdateCopyWithImpl(this._self, this._then);

  final _NoteUpdate _self;
  final $Res Function(_NoteUpdate) _then;

/// Create a copy of NoteUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = freezed,Object? rabbitId = freezed,Object? cageId = freezed,}) {
  return _then(_NoteUpdate(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,cageId: freezed == cageId ? _self.cageId : cageId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
