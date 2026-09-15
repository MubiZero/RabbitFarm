// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'support_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SupportRequest {

@IntConverter() int get id; String get text; String get status;/// Что ответила поддержка. `null` — ответа ещё нет.
 String? get answer;@JsonKey(name: 'resolved_at')@NullableDateTimeConverter() DateTime? get resolvedAt; UserRef? get author;@JsonKey(name: 'created_at')@DateTimeConverter() DateTime get createdAt;
/// Create a copy of SupportRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupportRequestCopyWith<SupportRequest> get copyWith => _$SupportRequestCopyWithImpl<SupportRequest>(this as SupportRequest, _$identity);

  /// Serializes this SupportRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SupportRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupportRequest&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.answer, _this.answer) || other.answer == _this.answer)&&(identical(other.resolvedAt, _this.resolvedAt) || other.resolvedAt == _this.resolvedAt)&&(identical(other.author, _this.author) || other.author == _this.author)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SupportRequest;
  return Object.hash(runtimeType,_this.id,_this.text,_this.status,_this.answer,_this.resolvedAt,_this.author,_this.createdAt);
}

@override
String toString() {
  final _this = this as SupportRequest;
  return 'SupportRequest(id: ${_this.id}, text: ${_this.text}, status: ${_this.status}, answer: ${_this.answer}, resolvedAt: ${_this.resolvedAt}, author: ${_this.author}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $SupportRequestCopyWith<$Res>  {
  factory $SupportRequestCopyWith(SupportRequest value, $Res Function(SupportRequest) _then) = _$SupportRequestCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id, String text, String status, String? answer,@JsonKey(name: 'resolved_at')@NullableDateTimeConverter() DateTime? resolvedAt, UserRef? author,@JsonKey(name: 'created_at')@DateTimeConverter() DateTime createdAt
});


$UserRefCopyWith<$Res>? get author;

}
/// @nodoc
class _$SupportRequestCopyWithImpl<$Res>
    implements $SupportRequestCopyWith<$Res> {
  _$SupportRequestCopyWithImpl(this._self, this._then);

  final SupportRequest _self;
  final $Res Function(SupportRequest) _then;

/// Create a copy of SupportRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? status = null,Object? answer = freezed,Object? resolvedAt = freezed,Object? author = freezed,Object? createdAt = null,}) {
  return _then(SupportRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,answer: freezed == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String?,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserRef?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of SupportRequest
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


/// Adds pattern-matching-related methods to [SupportRequest].
extension SupportRequestPatterns on SupportRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupportRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupportRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupportRequest value)  $default,){
final _that = this;
switch (_that) {
case _SupportRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupportRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SupportRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String text,  String status,  String? answer, @JsonKey(name: 'resolved_at')@NullableDateTimeConverter()  DateTime? resolvedAt,  UserRef? author, @JsonKey(name: 'created_at')@DateTimeConverter()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupportRequest() when $default != null:
return $default(_that.id,_that.text,_that.status,_that.answer,_that.resolvedAt,_that.author,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String text,  String status,  String? answer, @JsonKey(name: 'resolved_at')@NullableDateTimeConverter()  DateTime? resolvedAt,  UserRef? author, @JsonKey(name: 'created_at')@DateTimeConverter()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SupportRequest():
return $default(_that.id,_that.text,_that.status,_that.answer,_that.resolvedAt,_that.author,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id,  String text,  String status,  String? answer, @JsonKey(name: 'resolved_at')@NullableDateTimeConverter()  DateTime? resolvedAt,  UserRef? author, @JsonKey(name: 'created_at')@DateTimeConverter()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SupportRequest() when $default != null:
return $default(_that.id,_that.text,_that.status,_that.answer,_that.resolvedAt,_that.author,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SupportRequest extends SupportRequest {
  const _SupportRequest({@IntConverter() required this.id, required this.text, this.status = 'new', this.answer, @JsonKey(name: 'resolved_at')@NullableDateTimeConverter() this.resolvedAt, this.author, @JsonKey(name: 'created_at')@DateTimeConverter() required this.createdAt}): super._();
  factory _SupportRequest.fromJson(Map<String, dynamic> json) => _$SupportRequestFromJson(json);

@override@IntConverter() final  int id;
@override final  String text;
@override@JsonKey() final  String status;
/// Что ответила поддержка. `null` — ответа ещё нет.
@override final  String? answer;
@override@JsonKey(name: 'resolved_at')@NullableDateTimeConverter() final  DateTime? resolvedAt;
@override final  UserRef? author;
@override@JsonKey(name: 'created_at')@DateTimeConverter() final  DateTime createdAt;

/// Create a copy of SupportRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupportRequestCopyWith<_SupportRequest> get copyWith => __$SupportRequestCopyWithImpl<_SupportRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupportRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupportRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.status, status) || other.status == status)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt)&&(identical(other.author, author) || other.author == author)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,text,status,answer,resolvedAt,author,createdAt);
}

@override
String toString() {
    return 'SupportRequest(id: $id, text: $text, status: $status, answer: $answer, resolvedAt: $resolvedAt, author: $author, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SupportRequestCopyWith<$Res> implements $SupportRequestCopyWith<$Res> {
  factory _$SupportRequestCopyWith(_SupportRequest value, $Res Function(_SupportRequest) _then) = __$SupportRequestCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id, String text, String status, String? answer,@JsonKey(name: 'resolved_at')@NullableDateTimeConverter() DateTime? resolvedAt, UserRef? author,@JsonKey(name: 'created_at')@DateTimeConverter() DateTime createdAt
});


@override $UserRefCopyWith<$Res>? get author;

}
/// @nodoc
class __$SupportRequestCopyWithImpl<$Res>
    implements _$SupportRequestCopyWith<$Res> {
  __$SupportRequestCopyWithImpl(this._self, this._then);

  final _SupportRequest _self;
  final $Res Function(_SupportRequest) _then;

/// Create a copy of SupportRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? status = null,Object? answer = freezed,Object? resolvedAt = freezed,Object? author = freezed,Object? createdAt = null,}) {
  return _then(_SupportRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,answer: freezed == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String?,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserRef?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of SupportRequest
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

// dart format on
