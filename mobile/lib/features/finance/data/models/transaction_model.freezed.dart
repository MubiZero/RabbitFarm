// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Transaction {

@IntConverter() int get id; TransactionType get type; TransactionCategory get category;@DoubleConverter() double get amount;@JsonKey(name: 'transaction_date')@DateOnlyConverter() DateTime get transactionDate;@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? get rabbitId; String? get description;@JsonKey(name: 'receipt_url') String? get receiptUrl;@JsonKey(name: 'created_by')@NullableIntConverter() int? get createdBy;@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? get createdAt;@JsonKey(name: 'updated_at')@NullableDateTimeConverter() DateTime? get updatedAt;/// Кролик, к которому привязана операция.
///
/// Сервер шлёт его урезанным — `id`, кличка и бирка (`TRANSACTION_INCLUDE`
/// в transactionService.js), — и разбор в полную модель упал бы. Раньше
/// связь просто выбрасывали: продажа конкретного кролика приходила с его
/// именем, а в книге стояла безликая строка «Продажа кролика».
@JsonKey(name: 'rabbit') RabbitRef? get rabbit;
/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionCopyWith<Transaction> get copyWith => _$TransactionCopyWithImpl<Transaction>(this as Transaction, _$identity);

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Transaction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Transaction&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.transactionDate, _this.transactionDate) || other.transactionDate == _this.transactionDate)&&(identical(other.rabbitId, _this.rabbitId) || other.rabbitId == _this.rabbitId)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.receiptUrl, _this.receiptUrl) || other.receiptUrl == _this.receiptUrl)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.rabbit, _this.rabbit) || other.rabbit == _this.rabbit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Transaction;
  return Object.hash(runtimeType,_this.id,_this.type,_this.category,_this.amount,_this.transactionDate,_this.rabbitId,_this.description,_this.receiptUrl,_this.createdBy,_this.createdAt,_this.updatedAt,_this.rabbit);
}

@override
String toString() {
  final _this = this as Transaction;
  return 'Transaction(id: ${_this.id}, type: ${_this.type}, category: ${_this.category}, amount: ${_this.amount}, transactionDate: ${_this.transactionDate}, rabbitId: ${_this.rabbitId}, description: ${_this.description}, receiptUrl: ${_this.receiptUrl}, createdBy: ${_this.createdBy}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, rabbit: ${_this.rabbit})';
}


}

/// @nodoc
abstract mixin class $TransactionCopyWith<$Res>  {
  factory $TransactionCopyWith(Transaction value, $Res Function(Transaction) _then) = _$TransactionCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id, TransactionType type, TransactionCategory category,@DoubleConverter() double amount,@JsonKey(name: 'transaction_date')@DateOnlyConverter() DateTime transactionDate,@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? rabbitId, String? description,@JsonKey(name: 'receipt_url') String? receiptUrl,@JsonKey(name: 'created_by')@NullableIntConverter() int? createdBy,@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@NullableDateTimeConverter() DateTime? updatedAt,@JsonKey(name: 'rabbit') RabbitRef? rabbit
});


$RabbitRefCopyWith<$Res>? get rabbit;

}
/// @nodoc
class _$TransactionCopyWithImpl<$Res>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._self, this._then);

  final Transaction _self;
  final $Res Function(Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? category = null,Object? amount = null,Object? transactionDate = null,Object? rabbitId = freezed,Object? description = freezed,Object? receiptUrl = freezed,Object? createdBy = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rabbit = freezed,}) {
  return _then(Transaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TransactionCategory,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,transactionDate: null == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime,rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rabbit: freezed == rabbit ? _self.rabbit : rabbit // ignore: cast_nullable_to_non_nullable
as RabbitRef?,
  ));
}
/// Create a copy of Transaction
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


/// Adds pattern-matching-related methods to [Transaction].
extension TransactionPatterns on Transaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Transaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Transaction value)  $default,){
final _that = this;
switch (_that) {
case _Transaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Transaction value)?  $default,){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id,  TransactionType type,  TransactionCategory category, @DoubleConverter()  double amount, @JsonKey(name: 'transaction_date')@DateOnlyConverter()  DateTime transactionDate, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId,  String? description, @JsonKey(name: 'receipt_url')  String? receiptUrl, @JsonKey(name: 'created_by')@NullableIntConverter()  int? createdBy, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter()  DateTime? updatedAt, @JsonKey(name: 'rabbit')  RabbitRef? rabbit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that.id,_that.type,_that.category,_that.amount,_that.transactionDate,_that.rabbitId,_that.description,_that.receiptUrl,_that.createdBy,_that.createdAt,_that.updatedAt,_that.rabbit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id,  TransactionType type,  TransactionCategory category, @DoubleConverter()  double amount, @JsonKey(name: 'transaction_date')@DateOnlyConverter()  DateTime transactionDate, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId,  String? description, @JsonKey(name: 'receipt_url')  String? receiptUrl, @JsonKey(name: 'created_by')@NullableIntConverter()  int? createdBy, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter()  DateTime? updatedAt, @JsonKey(name: 'rabbit')  RabbitRef? rabbit)  $default,) {final _that = this;
switch (_that) {
case _Transaction():
return $default(_that.id,_that.type,_that.category,_that.amount,_that.transactionDate,_that.rabbitId,_that.description,_that.receiptUrl,_that.createdBy,_that.createdAt,_that.updatedAt,_that.rabbit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id,  TransactionType type,  TransactionCategory category, @DoubleConverter()  double amount, @JsonKey(name: 'transaction_date')@DateOnlyConverter()  DateTime transactionDate, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId,  String? description, @JsonKey(name: 'receipt_url')  String? receiptUrl, @JsonKey(name: 'created_by')@NullableIntConverter()  int? createdBy, @JsonKey(name: 'created_at')@NullableDateTimeConverter()  DateTime? createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter()  DateTime? updatedAt, @JsonKey(name: 'rabbit')  RabbitRef? rabbit)?  $default,) {final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that.id,_that.type,_that.category,_that.amount,_that.transactionDate,_that.rabbitId,_that.description,_that.receiptUrl,_that.createdBy,_that.createdAt,_that.updatedAt,_that.rabbit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Transaction implements Transaction {
  const _Transaction({@IntConverter() required this.id, required this.type, required this.category, @DoubleConverter() required this.amount, @JsonKey(name: 'transaction_date')@DateOnlyConverter() required this.transactionDate, @JsonKey(name: 'rabbit_id')@NullableIntConverter() this.rabbitId, this.description, @JsonKey(name: 'receipt_url') this.receiptUrl, @JsonKey(name: 'created_by')@NullableIntConverter() this.createdBy, @JsonKey(name: 'created_at')@NullableDateTimeConverter() this.createdAt, @JsonKey(name: 'updated_at')@NullableDateTimeConverter() this.updatedAt, @JsonKey(name: 'rabbit') this.rabbit});
  factory _Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);

@override@IntConverter() final  int id;
@override final  TransactionType type;
@override final  TransactionCategory category;
@override@DoubleConverter() final  double amount;
@override@JsonKey(name: 'transaction_date')@DateOnlyConverter() final  DateTime transactionDate;
@override@JsonKey(name: 'rabbit_id')@NullableIntConverter() final  int? rabbitId;
@override final  String? description;
@override@JsonKey(name: 'receipt_url') final  String? receiptUrl;
@override@JsonKey(name: 'created_by')@NullableIntConverter() final  int? createdBy;
@override@JsonKey(name: 'created_at')@NullableDateTimeConverter() final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at')@NullableDateTimeConverter() final  DateTime? updatedAt;
/// Кролик, к которому привязана операция.
///
/// Сервер шлёт его урезанным — `id`, кличка и бирка (`TRANSACTION_INCLUDE`
/// в transactionService.js), — и разбор в полную модель упал бы. Раньше
/// связь просто выбрасывали: продажа конкретного кролика приходила с его
/// именем, а в книге стояла безликая строка «Продажа кролика».
@override@JsonKey(name: 'rabbit') final  RabbitRef? rabbit;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionCopyWith<_Transaction> get copyWith => __$TransactionCopyWithImpl<_Transaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Transaction&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.category, category) || other.category == category)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.rabbitId, rabbitId) || other.rabbitId == rabbitId)&&(identical(other.description, description) || other.description == description)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.rabbit, rabbit) || other.rabbit == rabbit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,type,category,amount,transactionDate,rabbitId,description,receiptUrl,createdBy,createdAt,updatedAt,rabbit);
}

@override
String toString() {
    return 'Transaction(id: $id, type: $type, category: $category, amount: $amount, transactionDate: $transactionDate, rabbitId: $rabbitId, description: $description, receiptUrl: $receiptUrl, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, rabbit: $rabbit)';
}


}

/// @nodoc
abstract mixin class _$TransactionCopyWith<$Res> implements $TransactionCopyWith<$Res> {
  factory _$TransactionCopyWith(_Transaction value, $Res Function(_Transaction) _then) = __$TransactionCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id, TransactionType type, TransactionCategory category,@DoubleConverter() double amount,@JsonKey(name: 'transaction_date')@DateOnlyConverter() DateTime transactionDate,@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? rabbitId, String? description,@JsonKey(name: 'receipt_url') String? receiptUrl,@JsonKey(name: 'created_by')@NullableIntConverter() int? createdBy,@JsonKey(name: 'created_at')@NullableDateTimeConverter() DateTime? createdAt,@JsonKey(name: 'updated_at')@NullableDateTimeConverter() DateTime? updatedAt,@JsonKey(name: 'rabbit') RabbitRef? rabbit
});


@override $RabbitRefCopyWith<$Res>? get rabbit;

}
/// @nodoc
class __$TransactionCopyWithImpl<$Res>
    implements _$TransactionCopyWith<$Res> {
  __$TransactionCopyWithImpl(this._self, this._then);

  final _Transaction _self;
  final $Res Function(_Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? category = null,Object? amount = null,Object? transactionDate = null,Object? rabbitId = freezed,Object? description = freezed,Object? receiptUrl = freezed,Object? createdBy = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? rabbit = freezed,}) {
  return _then(_Transaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TransactionCategory,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,transactionDate: null == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime,rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rabbit: freezed == rabbit ? _self.rabbit : rabbit // ignore: cast_nullable_to_non_nullable
as RabbitRef?,
  ));
}

/// Create a copy of Transaction
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


/// @nodoc
mixin _$TransactionCreate {

 TransactionType get type; TransactionCategory get category; double get amount;@JsonKey(name: 'transaction_date')@DateOnlyConverter() DateTime get transactionDate;@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? get rabbitId; String? get description;@JsonKey(name: 'receipt_url') String? get receiptUrl;
/// Create a copy of TransactionCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionCreateCopyWith<TransactionCreate> get copyWith => _$TransactionCreateCopyWithImpl<TransactionCreate>(this as TransactionCreate, _$identity);

  /// Serializes this TransactionCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransactionCreate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionCreate&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.transactionDate, _this.transactionDate) || other.transactionDate == _this.transactionDate)&&(identical(other.rabbitId, _this.rabbitId) || other.rabbitId == _this.rabbitId)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.receiptUrl, _this.receiptUrl) || other.receiptUrl == _this.receiptUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransactionCreate;
  return Object.hash(runtimeType,_this.type,_this.category,_this.amount,_this.transactionDate,_this.rabbitId,_this.description,_this.receiptUrl);
}

@override
String toString() {
  final _this = this as TransactionCreate;
  return 'TransactionCreate(type: ${_this.type}, category: ${_this.category}, amount: ${_this.amount}, transactionDate: ${_this.transactionDate}, rabbitId: ${_this.rabbitId}, description: ${_this.description}, receiptUrl: ${_this.receiptUrl})';
}


}

/// @nodoc
abstract mixin class $TransactionCreateCopyWith<$Res>  {
  factory $TransactionCreateCopyWith(TransactionCreate value, $Res Function(TransactionCreate) _then) = _$TransactionCreateCopyWithImpl;
@useResult
$Res call({
 TransactionType type, TransactionCategory category, double amount,@JsonKey(name: 'transaction_date')@DateOnlyConverter() DateTime transactionDate,@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? rabbitId, String? description,@JsonKey(name: 'receipt_url') String? receiptUrl
});




}
/// @nodoc
class _$TransactionCreateCopyWithImpl<$Res>
    implements $TransactionCreateCopyWith<$Res> {
  _$TransactionCreateCopyWithImpl(this._self, this._then);

  final TransactionCreate _self;
  final $Res Function(TransactionCreate) _then;

/// Create a copy of TransactionCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? category = null,Object? amount = null,Object? transactionDate = null,Object? rabbitId = freezed,Object? description = freezed,Object? receiptUrl = freezed,}) {
  return _then(TransactionCreate(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TransactionCategory,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,transactionDate: null == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime,rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionCreate].
extension TransactionCreatePatterns on TransactionCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionCreate value)  $default,){
final _that = this;
switch (_that) {
case _TransactionCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionCreate value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TransactionType type,  TransactionCategory category,  double amount, @JsonKey(name: 'transaction_date')@DateOnlyConverter()  DateTime transactionDate, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId,  String? description, @JsonKey(name: 'receipt_url')  String? receiptUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionCreate() when $default != null:
return $default(_that.type,_that.category,_that.amount,_that.transactionDate,_that.rabbitId,_that.description,_that.receiptUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TransactionType type,  TransactionCategory category,  double amount, @JsonKey(name: 'transaction_date')@DateOnlyConverter()  DateTime transactionDate, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId,  String? description, @JsonKey(name: 'receipt_url')  String? receiptUrl)  $default,) {final _that = this;
switch (_that) {
case _TransactionCreate():
return $default(_that.type,_that.category,_that.amount,_that.transactionDate,_that.rabbitId,_that.description,_that.receiptUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TransactionType type,  TransactionCategory category,  double amount, @JsonKey(name: 'transaction_date')@DateOnlyConverter()  DateTime transactionDate, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId,  String? description, @JsonKey(name: 'receipt_url')  String? receiptUrl)?  $default,) {final _that = this;
switch (_that) {
case _TransactionCreate() when $default != null:
return $default(_that.type,_that.category,_that.amount,_that.transactionDate,_that.rabbitId,_that.description,_that.receiptUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionCreate implements TransactionCreate {
  const _TransactionCreate({required this.type, required this.category, required this.amount, @JsonKey(name: 'transaction_date')@DateOnlyConverter() required this.transactionDate, @JsonKey(name: 'rabbit_id')@NullableIntConverter() this.rabbitId, this.description, @JsonKey(name: 'receipt_url') this.receiptUrl});
  factory _TransactionCreate.fromJson(Map<String, dynamic> json) => _$TransactionCreateFromJson(json);

@override final  TransactionType type;
@override final  TransactionCategory category;
@override final  double amount;
@override@JsonKey(name: 'transaction_date')@DateOnlyConverter() final  DateTime transactionDate;
@override@JsonKey(name: 'rabbit_id')@NullableIntConverter() final  int? rabbitId;
@override final  String? description;
@override@JsonKey(name: 'receipt_url') final  String? receiptUrl;

/// Create a copy of TransactionCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionCreateCopyWith<_TransactionCreate> get copyWith => __$TransactionCreateCopyWithImpl<_TransactionCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionCreateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionCreate&&(identical(other.type, type) || other.type == type)&&(identical(other.category, category) || other.category == category)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.rabbitId, rabbitId) || other.rabbitId == rabbitId)&&(identical(other.description, description) || other.description == description)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,category,amount,transactionDate,rabbitId,description,receiptUrl);
}

@override
String toString() {
    return 'TransactionCreate(type: $type, category: $category, amount: $amount, transactionDate: $transactionDate, rabbitId: $rabbitId, description: $description, receiptUrl: $receiptUrl)';
}


}

/// @nodoc
abstract mixin class _$TransactionCreateCopyWith<$Res> implements $TransactionCreateCopyWith<$Res> {
  factory _$TransactionCreateCopyWith(_TransactionCreate value, $Res Function(_TransactionCreate) _then) = __$TransactionCreateCopyWithImpl;
@override @useResult
$Res call({
 TransactionType type, TransactionCategory category, double amount,@JsonKey(name: 'transaction_date')@DateOnlyConverter() DateTime transactionDate,@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? rabbitId, String? description,@JsonKey(name: 'receipt_url') String? receiptUrl
});




}
/// @nodoc
class __$TransactionCreateCopyWithImpl<$Res>
    implements _$TransactionCreateCopyWith<$Res> {
  __$TransactionCreateCopyWithImpl(this._self, this._then);

  final _TransactionCreate _self;
  final $Res Function(_TransactionCreate) _then;

/// Create a copy of TransactionCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? category = null,Object? amount = null,Object? transactionDate = null,Object? rabbitId = freezed,Object? description = freezed,Object? receiptUrl = freezed,}) {
  return _then(_TransactionCreate(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TransactionCategory,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,transactionDate: null == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime,rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TransactionUpdate {

 TransactionType? get type; TransactionCategory? get category; double? get amount;@JsonKey(name: 'transaction_date')@NullableDateOnlyConverter() DateTime? get transactionDate;@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? get rabbitId; String? get description;@JsonKey(name: 'receipt_url') String? get receiptUrl;
/// Create a copy of TransactionUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionUpdateCopyWith<TransactionUpdate> get copyWith => _$TransactionUpdateCopyWithImpl<TransactionUpdate>(this as TransactionUpdate, _$identity);

  /// Serializes this TransactionUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransactionUpdate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionUpdate&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.transactionDate, _this.transactionDate) || other.transactionDate == _this.transactionDate)&&(identical(other.rabbitId, _this.rabbitId) || other.rabbitId == _this.rabbitId)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.receiptUrl, _this.receiptUrl) || other.receiptUrl == _this.receiptUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransactionUpdate;
  return Object.hash(runtimeType,_this.type,_this.category,_this.amount,_this.transactionDate,_this.rabbitId,_this.description,_this.receiptUrl);
}

@override
String toString() {
  final _this = this as TransactionUpdate;
  return 'TransactionUpdate(type: ${_this.type}, category: ${_this.category}, amount: ${_this.amount}, transactionDate: ${_this.transactionDate}, rabbitId: ${_this.rabbitId}, description: ${_this.description}, receiptUrl: ${_this.receiptUrl})';
}


}

/// @nodoc
abstract mixin class $TransactionUpdateCopyWith<$Res>  {
  factory $TransactionUpdateCopyWith(TransactionUpdate value, $Res Function(TransactionUpdate) _then) = _$TransactionUpdateCopyWithImpl;
@useResult
$Res call({
 TransactionType? type, TransactionCategory? category, double? amount,@JsonKey(name: 'transaction_date')@NullableDateOnlyConverter() DateTime? transactionDate,@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? rabbitId, String? description,@JsonKey(name: 'receipt_url') String? receiptUrl
});




}
/// @nodoc
class _$TransactionUpdateCopyWithImpl<$Res>
    implements $TransactionUpdateCopyWith<$Res> {
  _$TransactionUpdateCopyWithImpl(this._self, this._then);

  final TransactionUpdate _self;
  final $Res Function(TransactionUpdate) _then;

/// Create a copy of TransactionUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? category = freezed,Object? amount = freezed,Object? transactionDate = freezed,Object? rabbitId = freezed,Object? description = freezed,Object? receiptUrl = freezed,}) {
  return _then(TransactionUpdate(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TransactionCategory?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,transactionDate: freezed == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionUpdate].
extension TransactionUpdatePatterns on TransactionUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionUpdate value)  $default,){
final _that = this;
switch (_that) {
case _TransactionUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TransactionType? type,  TransactionCategory? category,  double? amount, @JsonKey(name: 'transaction_date')@NullableDateOnlyConverter()  DateTime? transactionDate, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId,  String? description, @JsonKey(name: 'receipt_url')  String? receiptUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionUpdate() when $default != null:
return $default(_that.type,_that.category,_that.amount,_that.transactionDate,_that.rabbitId,_that.description,_that.receiptUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TransactionType? type,  TransactionCategory? category,  double? amount, @JsonKey(name: 'transaction_date')@NullableDateOnlyConverter()  DateTime? transactionDate, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId,  String? description, @JsonKey(name: 'receipt_url')  String? receiptUrl)  $default,) {final _that = this;
switch (_that) {
case _TransactionUpdate():
return $default(_that.type,_that.category,_that.amount,_that.transactionDate,_that.rabbitId,_that.description,_that.receiptUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TransactionType? type,  TransactionCategory? category,  double? amount, @JsonKey(name: 'transaction_date')@NullableDateOnlyConverter()  DateTime? transactionDate, @JsonKey(name: 'rabbit_id')@NullableIntConverter()  int? rabbitId,  String? description, @JsonKey(name: 'receipt_url')  String? receiptUrl)?  $default,) {final _that = this;
switch (_that) {
case _TransactionUpdate() when $default != null:
return $default(_that.type,_that.category,_that.amount,_that.transactionDate,_that.rabbitId,_that.description,_that.receiptUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionUpdate implements TransactionUpdate {
  const _TransactionUpdate({this.type, this.category, this.amount, @JsonKey(name: 'transaction_date')@NullableDateOnlyConverter() this.transactionDate, @JsonKey(name: 'rabbit_id')@NullableIntConverter() this.rabbitId, this.description, @JsonKey(name: 'receipt_url') this.receiptUrl});
  factory _TransactionUpdate.fromJson(Map<String, dynamic> json) => _$TransactionUpdateFromJson(json);

@override final  TransactionType? type;
@override final  TransactionCategory? category;
@override final  double? amount;
@override@JsonKey(name: 'transaction_date')@NullableDateOnlyConverter() final  DateTime? transactionDate;
@override@JsonKey(name: 'rabbit_id')@NullableIntConverter() final  int? rabbitId;
@override final  String? description;
@override@JsonKey(name: 'receipt_url') final  String? receiptUrl;

/// Create a copy of TransactionUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionUpdateCopyWith<_TransactionUpdate> get copyWith => __$TransactionUpdateCopyWithImpl<_TransactionUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionUpdate&&(identical(other.type, type) || other.type == type)&&(identical(other.category, category) || other.category == category)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.rabbitId, rabbitId) || other.rabbitId == rabbitId)&&(identical(other.description, description) || other.description == description)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,category,amount,transactionDate,rabbitId,description,receiptUrl);
}

@override
String toString() {
    return 'TransactionUpdate(type: $type, category: $category, amount: $amount, transactionDate: $transactionDate, rabbitId: $rabbitId, description: $description, receiptUrl: $receiptUrl)';
}


}

/// @nodoc
abstract mixin class _$TransactionUpdateCopyWith<$Res> implements $TransactionUpdateCopyWith<$Res> {
  factory _$TransactionUpdateCopyWith(_TransactionUpdate value, $Res Function(_TransactionUpdate) _then) = __$TransactionUpdateCopyWithImpl;
@override @useResult
$Res call({
 TransactionType? type, TransactionCategory? category, double? amount,@JsonKey(name: 'transaction_date')@NullableDateOnlyConverter() DateTime? transactionDate,@JsonKey(name: 'rabbit_id')@NullableIntConverter() int? rabbitId, String? description,@JsonKey(name: 'receipt_url') String? receiptUrl
});




}
/// @nodoc
class __$TransactionUpdateCopyWithImpl<$Res>
    implements _$TransactionUpdateCopyWith<$Res> {
  __$TransactionUpdateCopyWithImpl(this._self, this._then);

  final _TransactionUpdate _self;
  final $Res Function(_TransactionUpdate) _then;

/// Create a copy of TransactionUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? category = freezed,Object? amount = freezed,Object? transactionDate = freezed,Object? rabbitId = freezed,Object? description = freezed,Object? receiptUrl = freezed,}) {
  return _then(_TransactionUpdate(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TransactionCategory?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,transactionDate: freezed == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,rabbitId: freezed == rabbitId ? _self.rabbitId : rabbitId // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$FinancialStatistics {

@JsonKey(name: 'total_income')@DoubleConverter() double get totalIncome;@JsonKey(name: 'total_expenses')@DoubleConverter() double get totalExpenses;@JsonKey(name: 'net_profit')@DoubleConverter() double get netProfit;@JsonKey(name: 'total_transactions')@IntConverter() int get totalTransactions;@JsonKey(name: 'income_by_category') List<CategoryStatistics> get incomeByCategory;@JsonKey(name: 'expenses_by_category') List<CategoryStatistics> get expensesByCategory;@JsonKey(name: 'recent_transactions') List<Transaction> get recentTransactions;
/// Create a copy of FinancialStatistics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialStatisticsCopyWith<FinancialStatistics> get copyWith => _$FinancialStatisticsCopyWithImpl<FinancialStatistics>(this as FinancialStatistics, _$identity);

  /// Serializes this FinancialStatistics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FinancialStatistics;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialStatistics&&(identical(other.totalIncome, _this.totalIncome) || other.totalIncome == _this.totalIncome)&&(identical(other.totalExpenses, _this.totalExpenses) || other.totalExpenses == _this.totalExpenses)&&(identical(other.netProfit, _this.netProfit) || other.netProfit == _this.netProfit)&&(identical(other.totalTransactions, _this.totalTransactions) || other.totalTransactions == _this.totalTransactions)&&const DeepCollectionEquality().equals(other.incomeByCategory, _this.incomeByCategory)&&const DeepCollectionEquality().equals(other.expensesByCategory, _this.expensesByCategory)&&const DeepCollectionEquality().equals(other.recentTransactions, _this.recentTransactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FinancialStatistics;
  return Object.hash(runtimeType,_this.totalIncome,_this.totalExpenses,_this.netProfit,_this.totalTransactions,const DeepCollectionEquality().hash(_this.incomeByCategory),const DeepCollectionEquality().hash(_this.expensesByCategory),const DeepCollectionEquality().hash(_this.recentTransactions));
}

@override
String toString() {
  final _this = this as FinancialStatistics;
  return 'FinancialStatistics(totalIncome: ${_this.totalIncome}, totalExpenses: ${_this.totalExpenses}, netProfit: ${_this.netProfit}, totalTransactions: ${_this.totalTransactions}, incomeByCategory: ${_this.incomeByCategory}, expensesByCategory: ${_this.expensesByCategory}, recentTransactions: ${_this.recentTransactions})';
}


}

/// @nodoc
abstract mixin class $FinancialStatisticsCopyWith<$Res>  {
  factory $FinancialStatisticsCopyWith(FinancialStatistics value, $Res Function(FinancialStatistics) _then) = _$FinancialStatisticsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_income')@DoubleConverter() double totalIncome,@JsonKey(name: 'total_expenses')@DoubleConverter() double totalExpenses,@JsonKey(name: 'net_profit')@DoubleConverter() double netProfit,@JsonKey(name: 'total_transactions')@IntConverter() int totalTransactions,@JsonKey(name: 'income_by_category') List<CategoryStatistics> incomeByCategory,@JsonKey(name: 'expenses_by_category') List<CategoryStatistics> expensesByCategory,@JsonKey(name: 'recent_transactions') List<Transaction> recentTransactions
});




}
/// @nodoc
class _$FinancialStatisticsCopyWithImpl<$Res>
    implements $FinancialStatisticsCopyWith<$Res> {
  _$FinancialStatisticsCopyWithImpl(this._self, this._then);

  final FinancialStatistics _self;
  final $Res Function(FinancialStatistics) _then;

/// Create a copy of FinancialStatistics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalIncome = null,Object? totalExpenses = null,Object? netProfit = null,Object? totalTransactions = null,Object? incomeByCategory = null,Object? expensesByCategory = null,Object? recentTransactions = null,}) {
  return _then(FinancialStatistics(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpenses: null == totalExpenses ? _self.totalExpenses : totalExpenses // ignore: cast_nullable_to_non_nullable
as double,netProfit: null == netProfit ? _self.netProfit : netProfit // ignore: cast_nullable_to_non_nullable
as double,totalTransactions: null == totalTransactions ? _self.totalTransactions : totalTransactions // ignore: cast_nullable_to_non_nullable
as int,incomeByCategory: null == incomeByCategory ? _self.incomeByCategory : incomeByCategory // ignore: cast_nullable_to_non_nullable
as List<CategoryStatistics>,expensesByCategory: null == expensesByCategory ? _self.expensesByCategory : expensesByCategory // ignore: cast_nullable_to_non_nullable
as List<CategoryStatistics>,recentTransactions: null == recentTransactions ? _self.recentTransactions : recentTransactions // ignore: cast_nullable_to_non_nullable
as List<Transaction>,
  ));
}

}


/// Adds pattern-matching-related methods to [FinancialStatistics].
extension FinancialStatisticsPatterns on FinancialStatistics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialStatistics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialStatistics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialStatistics value)  $default,){
final _that = this;
switch (_that) {
case _FinancialStatistics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialStatistics value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialStatistics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_income')@DoubleConverter()  double totalIncome, @JsonKey(name: 'total_expenses')@DoubleConverter()  double totalExpenses, @JsonKey(name: 'net_profit')@DoubleConverter()  double netProfit, @JsonKey(name: 'total_transactions')@IntConverter()  int totalTransactions, @JsonKey(name: 'income_by_category')  List<CategoryStatistics> incomeByCategory, @JsonKey(name: 'expenses_by_category')  List<CategoryStatistics> expensesByCategory, @JsonKey(name: 'recent_transactions')  List<Transaction> recentTransactions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinancialStatistics() when $default != null:
return $default(_that.totalIncome,_that.totalExpenses,_that.netProfit,_that.totalTransactions,_that.incomeByCategory,_that.expensesByCategory,_that.recentTransactions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_income')@DoubleConverter()  double totalIncome, @JsonKey(name: 'total_expenses')@DoubleConverter()  double totalExpenses, @JsonKey(name: 'net_profit')@DoubleConverter()  double netProfit, @JsonKey(name: 'total_transactions')@IntConverter()  int totalTransactions, @JsonKey(name: 'income_by_category')  List<CategoryStatistics> incomeByCategory, @JsonKey(name: 'expenses_by_category')  List<CategoryStatistics> expensesByCategory, @JsonKey(name: 'recent_transactions')  List<Transaction> recentTransactions)  $default,) {final _that = this;
switch (_that) {
case _FinancialStatistics():
return $default(_that.totalIncome,_that.totalExpenses,_that.netProfit,_that.totalTransactions,_that.incomeByCategory,_that.expensesByCategory,_that.recentTransactions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_income')@DoubleConverter()  double totalIncome, @JsonKey(name: 'total_expenses')@DoubleConverter()  double totalExpenses, @JsonKey(name: 'net_profit')@DoubleConverter()  double netProfit, @JsonKey(name: 'total_transactions')@IntConverter()  int totalTransactions, @JsonKey(name: 'income_by_category')  List<CategoryStatistics> incomeByCategory, @JsonKey(name: 'expenses_by_category')  List<CategoryStatistics> expensesByCategory, @JsonKey(name: 'recent_transactions')  List<Transaction> recentTransactions)?  $default,) {final _that = this;
switch (_that) {
case _FinancialStatistics() when $default != null:
return $default(_that.totalIncome,_that.totalExpenses,_that.netProfit,_that.totalTransactions,_that.incomeByCategory,_that.expensesByCategory,_that.recentTransactions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinancialStatistics implements FinancialStatistics {
  const _FinancialStatistics({@JsonKey(name: 'total_income')@DoubleConverter() required this.totalIncome, @JsonKey(name: 'total_expenses')@DoubleConverter() required this.totalExpenses, @JsonKey(name: 'net_profit')@DoubleConverter() required this.netProfit, @JsonKey(name: 'total_transactions')@IntConverter() required this.totalTransactions, @JsonKey(name: 'income_by_category') required  List<CategoryStatistics> incomeByCategory, @JsonKey(name: 'expenses_by_category') required  List<CategoryStatistics> expensesByCategory, @JsonKey(name: 'recent_transactions') required  List<Transaction> recentTransactions}): _incomeByCategory = incomeByCategory,_expensesByCategory = expensesByCategory,_recentTransactions = recentTransactions;
  factory _FinancialStatistics.fromJson(Map<String, dynamic> json) => _$FinancialStatisticsFromJson(json);

@override@JsonKey(name: 'total_income')@DoubleConverter() final  double totalIncome;
@override@JsonKey(name: 'total_expenses')@DoubleConverter() final  double totalExpenses;
@override@JsonKey(name: 'net_profit')@DoubleConverter() final  double netProfit;
@override@JsonKey(name: 'total_transactions')@IntConverter() final  int totalTransactions;
 final  List<CategoryStatistics> _incomeByCategory;
@override@JsonKey(name: 'income_by_category') List<CategoryStatistics> get incomeByCategory {
  if (_incomeByCategory is EqualUnmodifiableListView) return _incomeByCategory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_incomeByCategory);
}

 final  List<CategoryStatistics> _expensesByCategory;
@override@JsonKey(name: 'expenses_by_category') List<CategoryStatistics> get expensesByCategory {
  if (_expensesByCategory is EqualUnmodifiableListView) return _expensesByCategory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expensesByCategory);
}

 final  List<Transaction> _recentTransactions;
@override@JsonKey(name: 'recent_transactions') List<Transaction> get recentTransactions {
  if (_recentTransactions is EqualUnmodifiableListView) return _recentTransactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentTransactions);
}


/// Create a copy of FinancialStatistics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialStatisticsCopyWith<_FinancialStatistics> get copyWith => __$FinancialStatisticsCopyWithImpl<_FinancialStatistics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinancialStatisticsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialStatistics&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpenses, totalExpenses) || other.totalExpenses == totalExpenses)&&(identical(other.netProfit, netProfit) || other.netProfit == netProfit)&&(identical(other.totalTransactions, totalTransactions) || other.totalTransactions == totalTransactions)&&const DeepCollectionEquality().equals(other.incomeByCategory, _incomeByCategory)&&const DeepCollectionEquality().equals(other.expensesByCategory, _expensesByCategory)&&const DeepCollectionEquality().equals(other.recentTransactions, _recentTransactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalIncome,totalExpenses,netProfit,totalTransactions,const DeepCollectionEquality().hash(_incomeByCategory),const DeepCollectionEquality().hash(_expensesByCategory),const DeepCollectionEquality().hash(_recentTransactions));
}

@override
String toString() {
    return 'FinancialStatistics(totalIncome: $totalIncome, totalExpenses: $totalExpenses, netProfit: $netProfit, totalTransactions: $totalTransactions, incomeByCategory: $incomeByCategory, expensesByCategory: $expensesByCategory, recentTransactions: $recentTransactions)';
}


}

/// @nodoc
abstract mixin class _$FinancialStatisticsCopyWith<$Res> implements $FinancialStatisticsCopyWith<$Res> {
  factory _$FinancialStatisticsCopyWith(_FinancialStatistics value, $Res Function(_FinancialStatistics) _then) = __$FinancialStatisticsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_income')@DoubleConverter() double totalIncome,@JsonKey(name: 'total_expenses')@DoubleConverter() double totalExpenses,@JsonKey(name: 'net_profit')@DoubleConverter() double netProfit,@JsonKey(name: 'total_transactions')@IntConverter() int totalTransactions,@JsonKey(name: 'income_by_category') List<CategoryStatistics> incomeByCategory,@JsonKey(name: 'expenses_by_category') List<CategoryStatistics> expensesByCategory,@JsonKey(name: 'recent_transactions') List<Transaction> recentTransactions
});




}
/// @nodoc
class __$FinancialStatisticsCopyWithImpl<$Res>
    implements _$FinancialStatisticsCopyWith<$Res> {
  __$FinancialStatisticsCopyWithImpl(this._self, this._then);

  final _FinancialStatistics _self;
  final $Res Function(_FinancialStatistics) _then;

/// Create a copy of FinancialStatistics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalIncome = null,Object? totalExpenses = null,Object? netProfit = null,Object? totalTransactions = null,Object? incomeByCategory = null,Object? expensesByCategory = null,Object? recentTransactions = null,}) {
  return _then(_FinancialStatistics(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpenses: null == totalExpenses ? _self.totalExpenses : totalExpenses // ignore: cast_nullable_to_non_nullable
as double,netProfit: null == netProfit ? _self.netProfit : netProfit // ignore: cast_nullable_to_non_nullable
as double,totalTransactions: null == totalTransactions ? _self.totalTransactions : totalTransactions // ignore: cast_nullable_to_non_nullable
as int,incomeByCategory: null == incomeByCategory ? _self._incomeByCategory : incomeByCategory // ignore: cast_nullable_to_non_nullable
as List<CategoryStatistics>,expensesByCategory: null == expensesByCategory ? _self._expensesByCategory : expensesByCategory // ignore: cast_nullable_to_non_nullable
as List<CategoryStatistics>,recentTransactions: null == recentTransactions ? _self._recentTransactions : recentTransactions // ignore: cast_nullable_to_non_nullable
as List<Transaction>,
  ));
}


}


/// @nodoc
mixin _$CategoryStatistics {

 TransactionCategory get category;@DoubleConverter() double get total;@IntConverter() int get count;
/// Create a copy of CategoryStatistics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryStatisticsCopyWith<CategoryStatistics> get copyWith => _$CategoryStatisticsCopyWithImpl<CategoryStatistics>(this as CategoryStatistics, _$identity);

  /// Serializes this CategoryStatistics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CategoryStatistics;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryStatistics&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.count, _this.count) || other.count == _this.count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CategoryStatistics;
  return Object.hash(runtimeType,_this.category,_this.total,_this.count);
}

@override
String toString() {
  final _this = this as CategoryStatistics;
  return 'CategoryStatistics(category: ${_this.category}, total: ${_this.total}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $CategoryStatisticsCopyWith<$Res>  {
  factory $CategoryStatisticsCopyWith(CategoryStatistics value, $Res Function(CategoryStatistics) _then) = _$CategoryStatisticsCopyWithImpl;
@useResult
$Res call({
 TransactionCategory category,@DoubleConverter() double total,@IntConverter() int count
});




}
/// @nodoc
class _$CategoryStatisticsCopyWithImpl<$Res>
    implements $CategoryStatisticsCopyWith<$Res> {
  _$CategoryStatisticsCopyWithImpl(this._self, this._then);

  final CategoryStatistics _self;
  final $Res Function(CategoryStatistics) _then;

/// Create a copy of CategoryStatistics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? total = null,Object? count = null,}) {
  return _then(CategoryStatistics(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TransactionCategory,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryStatistics].
extension CategoryStatisticsPatterns on CategoryStatistics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryStatistics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryStatistics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryStatistics value)  $default,){
final _that = this;
switch (_that) {
case _CategoryStatistics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryStatistics value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryStatistics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TransactionCategory category, @DoubleConverter()  double total, @IntConverter()  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryStatistics() when $default != null:
return $default(_that.category,_that.total,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TransactionCategory category, @DoubleConverter()  double total, @IntConverter()  int count)  $default,) {final _that = this;
switch (_that) {
case _CategoryStatistics():
return $default(_that.category,_that.total,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TransactionCategory category, @DoubleConverter()  double total, @IntConverter()  int count)?  $default,) {final _that = this;
switch (_that) {
case _CategoryStatistics() when $default != null:
return $default(_that.category,_that.total,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryStatistics implements CategoryStatistics {
  const _CategoryStatistics({required this.category, @DoubleConverter() required this.total, @IntConverter() required this.count});
  factory _CategoryStatistics.fromJson(Map<String, dynamic> json) => _$CategoryStatisticsFromJson(json);

@override final  TransactionCategory category;
@override@DoubleConverter() final  double total;
@override@IntConverter() final  int count;

/// Create a copy of CategoryStatistics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryStatisticsCopyWith<_CategoryStatistics> get copyWith => __$CategoryStatisticsCopyWithImpl<_CategoryStatistics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryStatisticsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryStatistics&&(identical(other.category, category) || other.category == category)&&(identical(other.total, total) || other.total == total)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,category,total,count);
}

@override
String toString() {
    return 'CategoryStatistics(category: $category, total: $total, count: $count)';
}


}

/// @nodoc
abstract mixin class _$CategoryStatisticsCopyWith<$Res> implements $CategoryStatisticsCopyWith<$Res> {
  factory _$CategoryStatisticsCopyWith(_CategoryStatistics value, $Res Function(_CategoryStatistics) _then) = __$CategoryStatisticsCopyWithImpl;
@override @useResult
$Res call({
 TransactionCategory category,@DoubleConverter() double total,@IntConverter() int count
});




}
/// @nodoc
class __$CategoryStatisticsCopyWithImpl<$Res>
    implements _$CategoryStatisticsCopyWith<$Res> {
  __$CategoryStatisticsCopyWithImpl(this._self, this._then);

  final _CategoryStatistics _self;
  final $Res Function(_CategoryStatistics) _then;

/// Create a copy of CategoryStatistics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? total = null,Object? count = null,}) {
  return _then(_CategoryStatistics(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TransactionCategory,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MonthlyReport {

 ReportPeriod get period; ReportSummary get summary; List<Transaction> get transactions;
/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyReportCopyWith<MonthlyReport> get copyWith => _$MonthlyReportCopyWithImpl<MonthlyReport>(this as MonthlyReport, _$identity);

  /// Serializes this MonthlyReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonthlyReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyReport&&(identical(other.period, _this.period) || other.period == _this.period)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&const DeepCollectionEquality().equals(other.transactions, _this.transactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonthlyReport;
  return Object.hash(runtimeType,_this.period,_this.summary,const DeepCollectionEquality().hash(_this.transactions));
}

@override
String toString() {
  final _this = this as MonthlyReport;
  return 'MonthlyReport(period: ${_this.period}, summary: ${_this.summary}, transactions: ${_this.transactions})';
}


}

/// @nodoc
abstract mixin class $MonthlyReportCopyWith<$Res>  {
  factory $MonthlyReportCopyWith(MonthlyReport value, $Res Function(MonthlyReport) _then) = _$MonthlyReportCopyWithImpl;
@useResult
$Res call({
 ReportPeriod period, ReportSummary summary, List<Transaction> transactions
});


$ReportPeriodCopyWith<$Res> get period;$ReportSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class _$MonthlyReportCopyWithImpl<$Res>
    implements $MonthlyReportCopyWith<$Res> {
  _$MonthlyReportCopyWithImpl(this._self, this._then);

  final MonthlyReport _self;
  final $Res Function(MonthlyReport) _then;

/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? period = null,Object? summary = null,Object? transactions = null,}) {
  return _then(MonthlyReport(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as ReportPeriod,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as ReportSummary,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<Transaction>,
  ));
}
/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportPeriodCopyWith<$Res> get period {
  
  return $ReportPeriodCopyWith<$Res>(_self.period, (value) {
    return _then(_self.copyWith(period: value));
  });
}/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportSummaryCopyWith<$Res> get summary {
  
  return $ReportSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [MonthlyReport].
extension MonthlyReportPatterns on MonthlyReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyReport value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyReport value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReportPeriod period,  ReportSummary summary,  List<Transaction> transactions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
return $default(_that.period,_that.summary,_that.transactions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReportPeriod period,  ReportSummary summary,  List<Transaction> transactions)  $default,) {final _that = this;
switch (_that) {
case _MonthlyReport():
return $default(_that.period,_that.summary,_that.transactions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReportPeriod period,  ReportSummary summary,  List<Transaction> transactions)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
return $default(_that.period,_that.summary,_that.transactions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthlyReport implements MonthlyReport {
  const _MonthlyReport({required this.period, required this.summary, required  List<Transaction> transactions}): _transactions = transactions;
  factory _MonthlyReport.fromJson(Map<String, dynamic> json) => _$MonthlyReportFromJson(json);

@override final  ReportPeriod period;
@override final  ReportSummary summary;
 final  List<Transaction> _transactions;
@override List<Transaction> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}


/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyReportCopyWith<_MonthlyReport> get copyWith => __$MonthlyReportCopyWithImpl<_MonthlyReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyReportToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyReport&&(identical(other.period, period) || other.period == period)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.transactions, _transactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,period,summary,const DeepCollectionEquality().hash(_transactions));
}

@override
String toString() {
    return 'MonthlyReport(period: $period, summary: $summary, transactions: $transactions)';
}


}

/// @nodoc
abstract mixin class _$MonthlyReportCopyWith<$Res> implements $MonthlyReportCopyWith<$Res> {
  factory _$MonthlyReportCopyWith(_MonthlyReport value, $Res Function(_MonthlyReport) _then) = __$MonthlyReportCopyWithImpl;
@override @useResult
$Res call({
 ReportPeriod period, ReportSummary summary, List<Transaction> transactions
});


@override $ReportPeriodCopyWith<$Res> get period;@override $ReportSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class __$MonthlyReportCopyWithImpl<$Res>
    implements _$MonthlyReportCopyWith<$Res> {
  __$MonthlyReportCopyWithImpl(this._self, this._then);

  final _MonthlyReport _self;
  final $Res Function(_MonthlyReport) _then;

/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? period = null,Object? summary = null,Object? transactions = null,}) {
  return _then(_MonthlyReport(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as ReportPeriod,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as ReportSummary,transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<Transaction>,
  ));
}

/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportPeriodCopyWith<$Res> get period {
  
  return $ReportPeriodCopyWith<$Res>(_self.period, (value) {
    return _then(_self.copyWith(period: value));
  });
}/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportSummaryCopyWith<$Res> get summary {
  
  return $ReportSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// @nodoc
mixin _$ReportPeriod {

@IntConverter() int get year;@IntConverter() int get month;@JsonKey(name: 'start_date')@DateOnlyConverter() DateTime get startDate;@JsonKey(name: 'end_date')@DateOnlyConverter() DateTime get endDate;
/// Create a copy of ReportPeriod
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportPeriodCopyWith<ReportPeriod> get copyWith => _$ReportPeriodCopyWithImpl<ReportPeriod>(this as ReportPeriod, _$identity);

  /// Serializes this ReportPeriod to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportPeriod;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportPeriod&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.endDate, _this.endDate) || other.endDate == _this.endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportPeriod;
  return Object.hash(runtimeType,_this.year,_this.month,_this.startDate,_this.endDate);
}

@override
String toString() {
  final _this = this as ReportPeriod;
  return 'ReportPeriod(year: ${_this.year}, month: ${_this.month}, startDate: ${_this.startDate}, endDate: ${_this.endDate})';
}


}

/// @nodoc
abstract mixin class $ReportPeriodCopyWith<$Res>  {
  factory $ReportPeriodCopyWith(ReportPeriod value, $Res Function(ReportPeriod) _then) = _$ReportPeriodCopyWithImpl;
@useResult
$Res call({
@IntConverter() int year,@IntConverter() int month,@JsonKey(name: 'start_date')@DateOnlyConverter() DateTime startDate,@JsonKey(name: 'end_date')@DateOnlyConverter() DateTime endDate
});




}
/// @nodoc
class _$ReportPeriodCopyWithImpl<$Res>
    implements $ReportPeriodCopyWith<$Res> {
  _$ReportPeriodCopyWithImpl(this._self, this._then);

  final ReportPeriod _self;
  final $Res Function(ReportPeriod) _then;

/// Create a copy of ReportPeriod
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? startDate = null,Object? endDate = null,}) {
  return _then(ReportPeriod(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportPeriod].
extension ReportPeriodPatterns on ReportPeriod {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportPeriod value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportPeriod() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportPeriod value)  $default,){
final _that = this;
switch (_that) {
case _ReportPeriod():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportPeriod value)?  $default,){
final _that = this;
switch (_that) {
case _ReportPeriod() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int year, @IntConverter()  int month, @JsonKey(name: 'start_date')@DateOnlyConverter()  DateTime startDate, @JsonKey(name: 'end_date')@DateOnlyConverter()  DateTime endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportPeriod() when $default != null:
return $default(_that.year,_that.month,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int year, @IntConverter()  int month, @JsonKey(name: 'start_date')@DateOnlyConverter()  DateTime startDate, @JsonKey(name: 'end_date')@DateOnlyConverter()  DateTime endDate)  $default,) {final _that = this;
switch (_that) {
case _ReportPeriod():
return $default(_that.year,_that.month,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int year, @IntConverter()  int month, @JsonKey(name: 'start_date')@DateOnlyConverter()  DateTime startDate, @JsonKey(name: 'end_date')@DateOnlyConverter()  DateTime endDate)?  $default,) {final _that = this;
switch (_that) {
case _ReportPeriod() when $default != null:
return $default(_that.year,_that.month,_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportPeriod implements ReportPeriod {
  const _ReportPeriod({@IntConverter() required this.year, @IntConverter() required this.month, @JsonKey(name: 'start_date')@DateOnlyConverter() required this.startDate, @JsonKey(name: 'end_date')@DateOnlyConverter() required this.endDate});
  factory _ReportPeriod.fromJson(Map<String, dynamic> json) => _$ReportPeriodFromJson(json);

@override@IntConverter() final  int year;
@override@IntConverter() final  int month;
@override@JsonKey(name: 'start_date')@DateOnlyConverter() final  DateTime startDate;
@override@JsonKey(name: 'end_date')@DateOnlyConverter() final  DateTime endDate;

/// Create a copy of ReportPeriod
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportPeriodCopyWith<_ReportPeriod> get copyWith => __$ReportPeriodCopyWithImpl<_ReportPeriod>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportPeriodToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportPeriod&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,year,month,startDate,endDate);
}

@override
String toString() {
    return 'ReportPeriod(year: $year, month: $month, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$ReportPeriodCopyWith<$Res> implements $ReportPeriodCopyWith<$Res> {
  factory _$ReportPeriodCopyWith(_ReportPeriod value, $Res Function(_ReportPeriod) _then) = __$ReportPeriodCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int year,@IntConverter() int month,@JsonKey(name: 'start_date')@DateOnlyConverter() DateTime startDate,@JsonKey(name: 'end_date')@DateOnlyConverter() DateTime endDate
});




}
/// @nodoc
class __$ReportPeriodCopyWithImpl<$Res>
    implements _$ReportPeriodCopyWith<$Res> {
  __$ReportPeriodCopyWithImpl(this._self, this._then);

  final _ReportPeriod _self;
  final $Res Function(_ReportPeriod) _then;

/// Create a copy of ReportPeriod
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? startDate = null,Object? endDate = null,}) {
  return _then(_ReportPeriod(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ReportSummary {

@JsonKey(name: 'total_income')@DoubleConverter() double get totalIncome;@JsonKey(name: 'total_expenses')@DoubleConverter() double get totalExpenses;@JsonKey(name: 'net_profit')@DoubleConverter() double get netProfit;@JsonKey(name: 'transaction_count')@IntConverter() int get transactionCount;
/// Create a copy of ReportSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportSummaryCopyWith<ReportSummary> get copyWith => _$ReportSummaryCopyWithImpl<ReportSummary>(this as ReportSummary, _$identity);

  /// Serializes this ReportSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReportSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportSummary&&(identical(other.totalIncome, _this.totalIncome) || other.totalIncome == _this.totalIncome)&&(identical(other.totalExpenses, _this.totalExpenses) || other.totalExpenses == _this.totalExpenses)&&(identical(other.netProfit, _this.netProfit) || other.netProfit == _this.netProfit)&&(identical(other.transactionCount, _this.transactionCount) || other.transactionCount == _this.transactionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportSummary;
  return Object.hash(runtimeType,_this.totalIncome,_this.totalExpenses,_this.netProfit,_this.transactionCount);
}

@override
String toString() {
  final _this = this as ReportSummary;
  return 'ReportSummary(totalIncome: ${_this.totalIncome}, totalExpenses: ${_this.totalExpenses}, netProfit: ${_this.netProfit}, transactionCount: ${_this.transactionCount})';
}


}

/// @nodoc
abstract mixin class $ReportSummaryCopyWith<$Res>  {
  factory $ReportSummaryCopyWith(ReportSummary value, $Res Function(ReportSummary) _then) = _$ReportSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_income')@DoubleConverter() double totalIncome,@JsonKey(name: 'total_expenses')@DoubleConverter() double totalExpenses,@JsonKey(name: 'net_profit')@DoubleConverter() double netProfit,@JsonKey(name: 'transaction_count')@IntConverter() int transactionCount
});




}
/// @nodoc
class _$ReportSummaryCopyWithImpl<$Res>
    implements $ReportSummaryCopyWith<$Res> {
  _$ReportSummaryCopyWithImpl(this._self, this._then);

  final ReportSummary _self;
  final $Res Function(ReportSummary) _then;

/// Create a copy of ReportSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalIncome = null,Object? totalExpenses = null,Object? netProfit = null,Object? transactionCount = null,}) {
  return _then(ReportSummary(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpenses: null == totalExpenses ? _self.totalExpenses : totalExpenses // ignore: cast_nullable_to_non_nullable
as double,netProfit: null == netProfit ? _self.netProfit : netProfit // ignore: cast_nullable_to_non_nullable
as double,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportSummary].
extension ReportSummaryPatterns on ReportSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportSummary value)  $default,){
final _that = this;
switch (_that) {
case _ReportSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ReportSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_income')@DoubleConverter()  double totalIncome, @JsonKey(name: 'total_expenses')@DoubleConverter()  double totalExpenses, @JsonKey(name: 'net_profit')@DoubleConverter()  double netProfit, @JsonKey(name: 'transaction_count')@IntConverter()  int transactionCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportSummary() when $default != null:
return $default(_that.totalIncome,_that.totalExpenses,_that.netProfit,_that.transactionCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_income')@DoubleConverter()  double totalIncome, @JsonKey(name: 'total_expenses')@DoubleConverter()  double totalExpenses, @JsonKey(name: 'net_profit')@DoubleConverter()  double netProfit, @JsonKey(name: 'transaction_count')@IntConverter()  int transactionCount)  $default,) {final _that = this;
switch (_that) {
case _ReportSummary():
return $default(_that.totalIncome,_that.totalExpenses,_that.netProfit,_that.transactionCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_income')@DoubleConverter()  double totalIncome, @JsonKey(name: 'total_expenses')@DoubleConverter()  double totalExpenses, @JsonKey(name: 'net_profit')@DoubleConverter()  double netProfit, @JsonKey(name: 'transaction_count')@IntConverter()  int transactionCount)?  $default,) {final _that = this;
switch (_that) {
case _ReportSummary() when $default != null:
return $default(_that.totalIncome,_that.totalExpenses,_that.netProfit,_that.transactionCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportSummary implements ReportSummary {
  const _ReportSummary({@JsonKey(name: 'total_income')@DoubleConverter() required this.totalIncome, @JsonKey(name: 'total_expenses')@DoubleConverter() required this.totalExpenses, @JsonKey(name: 'net_profit')@DoubleConverter() required this.netProfit, @JsonKey(name: 'transaction_count')@IntConverter() required this.transactionCount});
  factory _ReportSummary.fromJson(Map<String, dynamic> json) => _$ReportSummaryFromJson(json);

@override@JsonKey(name: 'total_income')@DoubleConverter() final  double totalIncome;
@override@JsonKey(name: 'total_expenses')@DoubleConverter() final  double totalExpenses;
@override@JsonKey(name: 'net_profit')@DoubleConverter() final  double netProfit;
@override@JsonKey(name: 'transaction_count')@IntConverter() final  int transactionCount;

/// Create a copy of ReportSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportSummaryCopyWith<_ReportSummary> get copyWith => __$ReportSummaryCopyWithImpl<_ReportSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportSummary&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpenses, totalExpenses) || other.totalExpenses == totalExpenses)&&(identical(other.netProfit, netProfit) || other.netProfit == netProfit)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalIncome,totalExpenses,netProfit,transactionCount);
}

@override
String toString() {
    return 'ReportSummary(totalIncome: $totalIncome, totalExpenses: $totalExpenses, netProfit: $netProfit, transactionCount: $transactionCount)';
}


}

/// @nodoc
abstract mixin class _$ReportSummaryCopyWith<$Res> implements $ReportSummaryCopyWith<$Res> {
  factory _$ReportSummaryCopyWith(_ReportSummary value, $Res Function(_ReportSummary) _then) = __$ReportSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_income')@DoubleConverter() double totalIncome,@JsonKey(name: 'total_expenses')@DoubleConverter() double totalExpenses,@JsonKey(name: 'net_profit')@DoubleConverter() double netProfit,@JsonKey(name: 'transaction_count')@IntConverter() int transactionCount
});




}
/// @nodoc
class __$ReportSummaryCopyWithImpl<$Res>
    implements _$ReportSummaryCopyWith<$Res> {
  __$ReportSummaryCopyWithImpl(this._self, this._then);

  final _ReportSummary _self;
  final $Res Function(_ReportSummary) _then;

/// Create a copy of ReportSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalIncome = null,Object? totalExpenses = null,Object? netProfit = null,Object? transactionCount = null,}) {
  return _then(_ReportSummary(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpenses: null == totalExpenses ? _self.totalExpenses : totalExpenses // ignore: cast_nullable_to_non_nullable
as double,netProfit: null == netProfit ? _self.netProfit : netProfit // ignore: cast_nullable_to_non_nullable
as double,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$RabbitTransactionsSummary {

 List<Transaction> get transactions; TransactionSummary get summary;
/// Create a copy of RabbitTransactionsSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RabbitTransactionsSummaryCopyWith<RabbitTransactionsSummary> get copyWith => _$RabbitTransactionsSummaryCopyWithImpl<RabbitTransactionsSummary>(this as RabbitTransactionsSummary, _$identity);

  /// Serializes this RabbitTransactionsSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RabbitTransactionsSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RabbitTransactionsSummary&&const DeepCollectionEquality().equals(other.transactions, _this.transactions)&&(identical(other.summary, _this.summary) || other.summary == _this.summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RabbitTransactionsSummary;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.transactions),_this.summary);
}

@override
String toString() {
  final _this = this as RabbitTransactionsSummary;
  return 'RabbitTransactionsSummary(transactions: ${_this.transactions}, summary: ${_this.summary})';
}


}

/// @nodoc
abstract mixin class $RabbitTransactionsSummaryCopyWith<$Res>  {
  factory $RabbitTransactionsSummaryCopyWith(RabbitTransactionsSummary value, $Res Function(RabbitTransactionsSummary) _then) = _$RabbitTransactionsSummaryCopyWithImpl;
@useResult
$Res call({
 List<Transaction> transactions, TransactionSummary summary
});


$TransactionSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class _$RabbitTransactionsSummaryCopyWithImpl<$Res>
    implements $RabbitTransactionsSummaryCopyWith<$Res> {
  _$RabbitTransactionsSummaryCopyWithImpl(this._self, this._then);

  final RabbitTransactionsSummary _self;
  final $Res Function(RabbitTransactionsSummary) _then;

/// Create a copy of RabbitTransactionsSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transactions = null,Object? summary = null,}) {
  return _then(RabbitTransactionsSummary(
transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<Transaction>,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as TransactionSummary,
  ));
}
/// Create a copy of RabbitTransactionsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionSummaryCopyWith<$Res> get summary {
  
  return $TransactionSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [RabbitTransactionsSummary].
extension RabbitTransactionsSummaryPatterns on RabbitTransactionsSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RabbitTransactionsSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RabbitTransactionsSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RabbitTransactionsSummary value)  $default,){
final _that = this;
switch (_that) {
case _RabbitTransactionsSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RabbitTransactionsSummary value)?  $default,){
final _that = this;
switch (_that) {
case _RabbitTransactionsSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Transaction> transactions,  TransactionSummary summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RabbitTransactionsSummary() when $default != null:
return $default(_that.transactions,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Transaction> transactions,  TransactionSummary summary)  $default,) {final _that = this;
switch (_that) {
case _RabbitTransactionsSummary():
return $default(_that.transactions,_that.summary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Transaction> transactions,  TransactionSummary summary)?  $default,) {final _that = this;
switch (_that) {
case _RabbitTransactionsSummary() when $default != null:
return $default(_that.transactions,_that.summary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RabbitTransactionsSummary implements RabbitTransactionsSummary {
  const _RabbitTransactionsSummary({required  List<Transaction> transactions, required this.summary}): _transactions = transactions;
  factory _RabbitTransactionsSummary.fromJson(Map<String, dynamic> json) => _$RabbitTransactionsSummaryFromJson(json);

 final  List<Transaction> _transactions;
@override List<Transaction> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}

@override final  TransactionSummary summary;

/// Create a copy of RabbitTransactionsSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RabbitTransactionsSummaryCopyWith<_RabbitTransactionsSummary> get copyWith => __$RabbitTransactionsSummaryCopyWithImpl<_RabbitTransactionsSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RabbitTransactionsSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RabbitTransactionsSummary&&const DeepCollectionEquality().equals(other.transactions, _transactions)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_transactions),summary);
}

@override
String toString() {
    return 'RabbitTransactionsSummary(transactions: $transactions, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$RabbitTransactionsSummaryCopyWith<$Res> implements $RabbitTransactionsSummaryCopyWith<$Res> {
  factory _$RabbitTransactionsSummaryCopyWith(_RabbitTransactionsSummary value, $Res Function(_RabbitTransactionsSummary) _then) = __$RabbitTransactionsSummaryCopyWithImpl;
@override @useResult
$Res call({
 List<Transaction> transactions, TransactionSummary summary
});


@override $TransactionSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class __$RabbitTransactionsSummaryCopyWithImpl<$Res>
    implements _$RabbitTransactionsSummaryCopyWith<$Res> {
  __$RabbitTransactionsSummaryCopyWithImpl(this._self, this._then);

  final _RabbitTransactionsSummary _self;
  final $Res Function(_RabbitTransactionsSummary) _then;

/// Create a copy of RabbitTransactionsSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transactions = null,Object? summary = null,}) {
  return _then(_RabbitTransactionsSummary(
transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<Transaction>,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as TransactionSummary,
  ));
}

/// Create a copy of RabbitTransactionsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionSummaryCopyWith<$Res> get summary {
  
  return $TransactionSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// @nodoc
mixin _$TransactionSummary {

@JsonKey(name: 'total_income')@DoubleConverter() double get totalIncome;@JsonKey(name: 'total_expenses')@DoubleConverter() double get totalExpenses;@JsonKey(name: 'net_profit')@DoubleConverter() double get netProfit;
/// Create a copy of TransactionSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionSummaryCopyWith<TransactionSummary> get copyWith => _$TransactionSummaryCopyWithImpl<TransactionSummary>(this as TransactionSummary, _$identity);

  /// Serializes this TransactionSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransactionSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionSummary&&(identical(other.totalIncome, _this.totalIncome) || other.totalIncome == _this.totalIncome)&&(identical(other.totalExpenses, _this.totalExpenses) || other.totalExpenses == _this.totalExpenses)&&(identical(other.netProfit, _this.netProfit) || other.netProfit == _this.netProfit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransactionSummary;
  return Object.hash(runtimeType,_this.totalIncome,_this.totalExpenses,_this.netProfit);
}

@override
String toString() {
  final _this = this as TransactionSummary;
  return 'TransactionSummary(totalIncome: ${_this.totalIncome}, totalExpenses: ${_this.totalExpenses}, netProfit: ${_this.netProfit})';
}


}

/// @nodoc
abstract mixin class $TransactionSummaryCopyWith<$Res>  {
  factory $TransactionSummaryCopyWith(TransactionSummary value, $Res Function(TransactionSummary) _then) = _$TransactionSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_income')@DoubleConverter() double totalIncome,@JsonKey(name: 'total_expenses')@DoubleConverter() double totalExpenses,@JsonKey(name: 'net_profit')@DoubleConverter() double netProfit
});




}
/// @nodoc
class _$TransactionSummaryCopyWithImpl<$Res>
    implements $TransactionSummaryCopyWith<$Res> {
  _$TransactionSummaryCopyWithImpl(this._self, this._then);

  final TransactionSummary _self;
  final $Res Function(TransactionSummary) _then;

/// Create a copy of TransactionSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalIncome = null,Object? totalExpenses = null,Object? netProfit = null,}) {
  return _then(TransactionSummary(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpenses: null == totalExpenses ? _self.totalExpenses : totalExpenses // ignore: cast_nullable_to_non_nullable
as double,netProfit: null == netProfit ? _self.netProfit : netProfit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionSummary].
extension TransactionSummaryPatterns on TransactionSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionSummary value)  $default,){
final _that = this;
switch (_that) {
case _TransactionSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionSummary value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_income')@DoubleConverter()  double totalIncome, @JsonKey(name: 'total_expenses')@DoubleConverter()  double totalExpenses, @JsonKey(name: 'net_profit')@DoubleConverter()  double netProfit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionSummary() when $default != null:
return $default(_that.totalIncome,_that.totalExpenses,_that.netProfit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_income')@DoubleConverter()  double totalIncome, @JsonKey(name: 'total_expenses')@DoubleConverter()  double totalExpenses, @JsonKey(name: 'net_profit')@DoubleConverter()  double netProfit)  $default,) {final _that = this;
switch (_that) {
case _TransactionSummary():
return $default(_that.totalIncome,_that.totalExpenses,_that.netProfit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_income')@DoubleConverter()  double totalIncome, @JsonKey(name: 'total_expenses')@DoubleConverter()  double totalExpenses, @JsonKey(name: 'net_profit')@DoubleConverter()  double netProfit)?  $default,) {final _that = this;
switch (_that) {
case _TransactionSummary() when $default != null:
return $default(_that.totalIncome,_that.totalExpenses,_that.netProfit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionSummary implements TransactionSummary {
  const _TransactionSummary({@JsonKey(name: 'total_income')@DoubleConverter() required this.totalIncome, @JsonKey(name: 'total_expenses')@DoubleConverter() required this.totalExpenses, @JsonKey(name: 'net_profit')@DoubleConverter() required this.netProfit});
  factory _TransactionSummary.fromJson(Map<String, dynamic> json) => _$TransactionSummaryFromJson(json);

@override@JsonKey(name: 'total_income')@DoubleConverter() final  double totalIncome;
@override@JsonKey(name: 'total_expenses')@DoubleConverter() final  double totalExpenses;
@override@JsonKey(name: 'net_profit')@DoubleConverter() final  double netProfit;

/// Create a copy of TransactionSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionSummaryCopyWith<_TransactionSummary> get copyWith => __$TransactionSummaryCopyWithImpl<_TransactionSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionSummary&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpenses, totalExpenses) || other.totalExpenses == totalExpenses)&&(identical(other.netProfit, netProfit) || other.netProfit == netProfit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalIncome,totalExpenses,netProfit);
}

@override
String toString() {
    return 'TransactionSummary(totalIncome: $totalIncome, totalExpenses: $totalExpenses, netProfit: $netProfit)';
}


}

/// @nodoc
abstract mixin class _$TransactionSummaryCopyWith<$Res> implements $TransactionSummaryCopyWith<$Res> {
  factory _$TransactionSummaryCopyWith(_TransactionSummary value, $Res Function(_TransactionSummary) _then) = __$TransactionSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_income')@DoubleConverter() double totalIncome,@JsonKey(name: 'total_expenses')@DoubleConverter() double totalExpenses,@JsonKey(name: 'net_profit')@DoubleConverter() double netProfit
});




}
/// @nodoc
class __$TransactionSummaryCopyWithImpl<$Res>
    implements _$TransactionSummaryCopyWith<$Res> {
  __$TransactionSummaryCopyWithImpl(this._self, this._then);

  final _TransactionSummary _self;
  final $Res Function(_TransactionSummary) _then;

/// Create a copy of TransactionSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalIncome = null,Object? totalExpenses = null,Object? netProfit = null,}) {
  return _then(_TransactionSummary(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpenses: null == totalExpenses ? _self.totalExpenses : totalExpenses // ignore: cast_nullable_to_non_nullable
as double,netProfit: null == netProfit ? _self.netProfit : netProfit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
