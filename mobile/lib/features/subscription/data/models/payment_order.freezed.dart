// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentOrder {

@JsonKey(name: 'invoice_id') String get invoiceId;@DoubleConverter() double get amount; String? get qr;@JsonKey(name: 'invoice_url') String? get invoiceUrl;@JsonKey(name: 'deep_link') String? get deepLink;
/// Create a copy of PaymentOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentOrderCopyWith<PaymentOrder> get copyWith => _$PaymentOrderCopyWithImpl<PaymentOrder>(this as PaymentOrder, _$identity);

  /// Serializes this PaymentOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaymentOrder;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentOrder&&(identical(other.invoiceId, _this.invoiceId) || other.invoiceId == _this.invoiceId)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.qr, _this.qr) || other.qr == _this.qr)&&(identical(other.invoiceUrl, _this.invoiceUrl) || other.invoiceUrl == _this.invoiceUrl)&&(identical(other.deepLink, _this.deepLink) || other.deepLink == _this.deepLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaymentOrder;
  return Object.hash(runtimeType,_this.invoiceId,_this.amount,_this.qr,_this.invoiceUrl,_this.deepLink);
}

@override
String toString() {
  final _this = this as PaymentOrder;
  return 'PaymentOrder(invoiceId: ${_this.invoiceId}, amount: ${_this.amount}, qr: ${_this.qr}, invoiceUrl: ${_this.invoiceUrl}, deepLink: ${_this.deepLink})';
}


}

/// @nodoc
abstract mixin class $PaymentOrderCopyWith<$Res>  {
  factory $PaymentOrderCopyWith(PaymentOrder value, $Res Function(PaymentOrder) _then) = _$PaymentOrderCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'invoice_id') String invoiceId,@DoubleConverter() double amount, String? qr,@JsonKey(name: 'invoice_url') String? invoiceUrl,@JsonKey(name: 'deep_link') String? deepLink
});




}
/// @nodoc
class _$PaymentOrderCopyWithImpl<$Res>
    implements $PaymentOrderCopyWith<$Res> {
  _$PaymentOrderCopyWithImpl(this._self, this._then);

  final PaymentOrder _self;
  final $Res Function(PaymentOrder) _then;

/// Create a copy of PaymentOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? invoiceId = null,Object? amount = null,Object? qr = freezed,Object? invoiceUrl = freezed,Object? deepLink = freezed,}) {
  return _then(PaymentOrder(
invoiceId: null == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,qr: freezed == qr ? _self.qr : qr // ignore: cast_nullable_to_non_nullable
as String?,invoiceUrl: freezed == invoiceUrl ? _self.invoiceUrl : invoiceUrl // ignore: cast_nullable_to_non_nullable
as String?,deepLink: freezed == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentOrder].
extension PaymentOrderPatterns on PaymentOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentOrder value)  $default,){
final _that = this;
switch (_that) {
case _PaymentOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentOrder value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'invoice_id')  String invoiceId, @DoubleConverter()  double amount,  String? qr, @JsonKey(name: 'invoice_url')  String? invoiceUrl, @JsonKey(name: 'deep_link')  String? deepLink)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentOrder() when $default != null:
return $default(_that.invoiceId,_that.amount,_that.qr,_that.invoiceUrl,_that.deepLink);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'invoice_id')  String invoiceId, @DoubleConverter()  double amount,  String? qr, @JsonKey(name: 'invoice_url')  String? invoiceUrl, @JsonKey(name: 'deep_link')  String? deepLink)  $default,) {final _that = this;
switch (_that) {
case _PaymentOrder():
return $default(_that.invoiceId,_that.amount,_that.qr,_that.invoiceUrl,_that.deepLink);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'invoice_id')  String invoiceId, @DoubleConverter()  double amount,  String? qr, @JsonKey(name: 'invoice_url')  String? invoiceUrl, @JsonKey(name: 'deep_link')  String? deepLink)?  $default,) {final _that = this;
switch (_that) {
case _PaymentOrder() when $default != null:
return $default(_that.invoiceId,_that.amount,_that.qr,_that.invoiceUrl,_that.deepLink);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentOrder implements PaymentOrder {
  const _PaymentOrder({@JsonKey(name: 'invoice_id') required this.invoiceId, @DoubleConverter() required this.amount, this.qr, @JsonKey(name: 'invoice_url') this.invoiceUrl, @JsonKey(name: 'deep_link') this.deepLink});
  factory _PaymentOrder.fromJson(Map<String, dynamic> json) => _$PaymentOrderFromJson(json);

@override@JsonKey(name: 'invoice_id') final  String invoiceId;
@override@DoubleConverter() final  double amount;
@override final  String? qr;
@override@JsonKey(name: 'invoice_url') final  String? invoiceUrl;
@override@JsonKey(name: 'deep_link') final  String? deepLink;

/// Create a copy of PaymentOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentOrderCopyWith<_PaymentOrder> get copyWith => __$PaymentOrderCopyWithImpl<_PaymentOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentOrderToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentOrder&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.qr, qr) || other.qr == qr)&&(identical(other.invoiceUrl, invoiceUrl) || other.invoiceUrl == invoiceUrl)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,invoiceId,amount,qr,invoiceUrl,deepLink);
}

@override
String toString() {
    return 'PaymentOrder(invoiceId: $invoiceId, amount: $amount, qr: $qr, invoiceUrl: $invoiceUrl, deepLink: $deepLink)';
}


}

/// @nodoc
abstract mixin class _$PaymentOrderCopyWith<$Res> implements $PaymentOrderCopyWith<$Res> {
  factory _$PaymentOrderCopyWith(_PaymentOrder value, $Res Function(_PaymentOrder) _then) = __$PaymentOrderCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'invoice_id') String invoiceId,@DoubleConverter() double amount, String? qr,@JsonKey(name: 'invoice_url') String? invoiceUrl,@JsonKey(name: 'deep_link') String? deepLink
});




}
/// @nodoc
class __$PaymentOrderCopyWithImpl<$Res>
    implements _$PaymentOrderCopyWith<$Res> {
  __$PaymentOrderCopyWithImpl(this._self, this._then);

  final _PaymentOrder _self;
  final $Res Function(_PaymentOrder) _then;

/// Create a copy of PaymentOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? invoiceId = null,Object? amount = null,Object? qr = freezed,Object? invoiceUrl = freezed,Object? deepLink = freezed,}) {
  return _then(_PaymentOrder(
invoiceId: null == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,qr: freezed == qr ? _self.qr : qr // ignore: cast_nullable_to_non_nullable
as String?,invoiceUrl: freezed == invoiceUrl ? _self.invoiceUrl : invoiceUrl // ignore: cast_nullable_to_non_nullable
as String?,deepLink: freezed == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
