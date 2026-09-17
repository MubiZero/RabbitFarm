// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'farm_ref.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FarmRef {

@IntConverter() int get id; String get status;/// Кого это хозяйство держит: назначение, которое форма подставляет
/// новому кролику. Пусто — хозяйство ещё не сказало, и действует
/// «племя», как и на сервере.
@JsonKey(name: 'default_purpose') String? get defaultPurpose;/// Страна хозяйства и то, что из неё следует. Валюта нужна, чтобы суммы
/// показывались своим знаком, а не одним на весь сервис; страна — чтобы
/// экран подписки знал, принимаем ли мы здесь оплату картой.
///
/// Значений может не быть у ответа старого сервера — тогда действуют
/// таджикские умолчания, как и было до появления выбора страны.
 String? get country; String? get currency; String? get timezone;
/// Create a copy of FarmRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FarmRefCopyWith<FarmRef> get copyWith => _$FarmRefCopyWithImpl<FarmRef>(this as FarmRef, _$identity);

  /// Serializes this FarmRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FarmRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FarmRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.defaultPurpose, _this.defaultPurpose) || other.defaultPurpose == _this.defaultPurpose)&&(identical(other.country, _this.country) || other.country == _this.country)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FarmRef;
  return Object.hash(runtimeType,_this.id,_this.status,_this.defaultPurpose,_this.country,_this.currency,_this.timezone);
}

@override
String toString() {
  final _this = this as FarmRef;
  return 'FarmRef(id: ${_this.id}, status: ${_this.status}, defaultPurpose: ${_this.defaultPurpose}, country: ${_this.country}, currency: ${_this.currency}, timezone: ${_this.timezone})';
}


}

/// @nodoc
abstract mixin class $FarmRefCopyWith<$Res>  {
  factory $FarmRefCopyWith(FarmRef value, $Res Function(FarmRef) _then) = _$FarmRefCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id, String status,@JsonKey(name: 'default_purpose') String? defaultPurpose, String? country, String? currency, String? timezone
});




}
/// @nodoc
class _$FarmRefCopyWithImpl<$Res>
    implements $FarmRefCopyWith<$Res> {
  _$FarmRefCopyWithImpl(this._self, this._then);

  final FarmRef _self;
  final $Res Function(FarmRef) _then;

/// Create a copy of FarmRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? defaultPurpose = freezed,Object? country = freezed,Object? currency = freezed,Object? timezone = freezed,}) {
  return _then(FarmRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,defaultPurpose: freezed == defaultPurpose ? _self.defaultPurpose : defaultPurpose // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FarmRef].
extension FarmRefPatterns on FarmRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FarmRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FarmRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FarmRef value)  $default,){
final _that = this;
switch (_that) {
case _FarmRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FarmRef value)?  $default,){
final _that = this;
switch (_that) {
case _FarmRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String status, @JsonKey(name: 'default_purpose')  String? defaultPurpose,  String? country,  String? currency,  String? timezone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FarmRef() when $default != null:
return $default(_that.id,_that.status,_that.defaultPurpose,_that.country,_that.currency,_that.timezone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String status, @JsonKey(name: 'default_purpose')  String? defaultPurpose,  String? country,  String? currency,  String? timezone)  $default,) {final _that = this;
switch (_that) {
case _FarmRef():
return $default(_that.id,_that.status,_that.defaultPurpose,_that.country,_that.currency,_that.timezone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id,  String status, @JsonKey(name: 'default_purpose')  String? defaultPurpose,  String? country,  String? currency,  String? timezone)?  $default,) {final _that = this;
switch (_that) {
case _FarmRef() when $default != null:
return $default(_that.id,_that.status,_that.defaultPurpose,_that.country,_that.currency,_that.timezone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FarmRef implements FarmRef {
  const _FarmRef({@IntConverter() required this.id, required this.status, @JsonKey(name: 'default_purpose') this.defaultPurpose, this.country, this.currency, this.timezone});
  factory _FarmRef.fromJson(Map<String, dynamic> json) => _$FarmRefFromJson(json);

@override@IntConverter() final  int id;
@override final  String status;
/// Кого это хозяйство держит: назначение, которое форма подставляет
/// новому кролику. Пусто — хозяйство ещё не сказало, и действует
/// «племя», как и на сервере.
@override@JsonKey(name: 'default_purpose') final  String? defaultPurpose;
/// Страна хозяйства и то, что из неё следует. Валюта нужна, чтобы суммы
/// показывались своим знаком, а не одним на весь сервис; страна — чтобы
/// экран подписки знал, принимаем ли мы здесь оплату картой.
///
/// Значений может не быть у ответа старого сервера — тогда действуют
/// таджикские умолчания, как и было до появления выбора страны.
@override final  String? country;
@override final  String? currency;
@override final  String? timezone;

/// Create a copy of FarmRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FarmRefCopyWith<_FarmRef> get copyWith => __$FarmRefCopyWithImpl<_FarmRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FarmRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FarmRef&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.defaultPurpose, defaultPurpose) || other.defaultPurpose == defaultPurpose)&&(identical(other.country, country) || other.country == country)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,status,defaultPurpose,country,currency,timezone);
}

@override
String toString() {
    return 'FarmRef(id: $id, status: $status, defaultPurpose: $defaultPurpose, country: $country, currency: $currency, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class _$FarmRefCopyWith<$Res> implements $FarmRefCopyWith<$Res> {
  factory _$FarmRefCopyWith(_FarmRef value, $Res Function(_FarmRef) _then) = __$FarmRefCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id, String status,@JsonKey(name: 'default_purpose') String? defaultPurpose, String? country, String? currency, String? timezone
});




}
/// @nodoc
class __$FarmRefCopyWithImpl<$Res>
    implements _$FarmRefCopyWith<$Res> {
  __$FarmRefCopyWithImpl(this._self, this._then);

  final _FarmRef _self;
  final $Res Function(_FarmRef) _then;

/// Create a copy of FarmRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? defaultPurpose = freezed,Object? country = freezed,Object? currency = freezed,Object? timezone = freezed,}) {
  return _then(_FarmRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,defaultPurpose: freezed == defaultPurpose ? _self.defaultPurpose : defaultPurpose // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
