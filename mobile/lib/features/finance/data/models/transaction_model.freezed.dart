// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return _Transaction.fromJson(json);
}

/// @nodoc
mixin _$Transaction {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  TransactionType get type => throw _privateConstructorUsedError;
  TransactionCategory get category => throw _privateConstructorUsedError;
  @DoubleConverter()
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_date')
  DateTime get transactionDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  int? get rabbitId => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'receipt_url')
  String? get receiptUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  @NullableIntConverter()
  int? get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError; // Relationships (not included in JSON serialization by default)
  @JsonKey(includeFromJson: false, includeToJson: false)
  RabbitModel? get rabbit => throw _privateConstructorUsedError;

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCopyWith<Transaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
    Transaction value,
    $Res Function(Transaction) then,
  ) = _$TransactionCopyWithImpl<$Res, Transaction>;
  @useResult
  $Res call({
    @IntConverter() int id,
    TransactionType type,
    TransactionCategory category,
    @DoubleConverter() double amount,
    @JsonKey(name: 'transaction_date') DateTime transactionDate,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() int? rabbitId,
    String? description,
    @JsonKey(name: 'receipt_url') String? receiptUrl,
    @JsonKey(name: 'created_by') @NullableIntConverter() int? createdBy,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false) RabbitModel? rabbit,
  });

  $RabbitModelCopyWith<$Res>? get rabbit;
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res, $Val extends Transaction>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? category = null,
    Object? amount = null,
    Object? transactionDate = null,
    Object? rabbitId = freezed,
    Object? description = freezed,
    Object? receiptUrl = freezed,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? rabbit = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as TransactionType,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as TransactionCategory,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            transactionDate: null == transactionDate
                ? _value.transactionDate
                : transactionDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            rabbitId: freezed == rabbitId
                ? _value.rabbitId
                : rabbitId // ignore: cast_nullable_to_non_nullable
                      as int?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            receiptUrl: freezed == receiptUrl
                ? _value.receiptUrl
                : receiptUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdBy: freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as int?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            rabbit: freezed == rabbit
                ? _value.rabbit
                : rabbit // ignore: cast_nullable_to_non_nullable
                      as RabbitModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of Transaction
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
}

/// @nodoc
abstract class _$$TransactionImplCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$$TransactionImplCopyWith(
    _$TransactionImpl value,
    $Res Function(_$TransactionImpl) then,
  ) = __$$TransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    TransactionType type,
    TransactionCategory category,
    @DoubleConverter() double amount,
    @JsonKey(name: 'transaction_date') DateTime transactionDate,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() int? rabbitId,
    String? description,
    @JsonKey(name: 'receipt_url') String? receiptUrl,
    @JsonKey(name: 'created_by') @NullableIntConverter() int? createdBy,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false) RabbitModel? rabbit,
  });

  @override
  $RabbitModelCopyWith<$Res>? get rabbit;
}

/// @nodoc
class __$$TransactionImplCopyWithImpl<$Res>
    extends _$TransactionCopyWithImpl<$Res, _$TransactionImpl>
    implements _$$TransactionImplCopyWith<$Res> {
  __$$TransactionImplCopyWithImpl(
    _$TransactionImpl _value,
    $Res Function(_$TransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? category = null,
    Object? amount = null,
    Object? transactionDate = null,
    Object? rabbitId = freezed,
    Object? description = freezed,
    Object? receiptUrl = freezed,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? rabbit = freezed,
  }) {
    return _then(
      _$TransactionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as TransactionType,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as TransactionCategory,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        transactionDate: null == transactionDate
            ? _value.transactionDate
            : transactionDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        rabbitId: freezed == rabbitId
            ? _value.rabbitId
            : rabbitId // ignore: cast_nullable_to_non_nullable
                  as int?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        receiptUrl: freezed == receiptUrl
            ? _value.receiptUrl
            : receiptUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdBy: freezed == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as int?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        rabbit: freezed == rabbit
            ? _value.rabbit
            : rabbit // ignore: cast_nullable_to_non_nullable
                  as RabbitModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionImpl implements _Transaction {
  const _$TransactionImpl({
    @IntConverter() required this.id,
    required this.type,
    required this.category,
    @DoubleConverter() required this.amount,
    @JsonKey(name: 'transaction_date') required this.transactionDate,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() this.rabbitId,
    this.description,
    @JsonKey(name: 'receipt_url') this.receiptUrl,
    @JsonKey(name: 'created_by') @NullableIntConverter() this.createdBy,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false) this.rabbit,
  });

  factory _$TransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  final TransactionType type;
  @override
  final TransactionCategory category;
  @override
  @DoubleConverter()
  final double amount;
  @override
  @JsonKey(name: 'transaction_date')
  final DateTime transactionDate;
  @override
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  final int? rabbitId;
  @override
  final String? description;
  @override
  @JsonKey(name: 'receipt_url')
  final String? receiptUrl;
  @override
  @JsonKey(name: 'created_by')
  @NullableIntConverter()
  final int? createdBy;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  // Relationships (not included in JSON serialization by default)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final RabbitModel? rabbit;

  @override
  String toString() {
    return 'Transaction(id: $id, type: $type, category: $category, amount: $amount, transactionDate: $transactionDate, rabbitId: $rabbitId, description: $description, receiptUrl: $receiptUrl, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, rabbit: $rabbit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.rabbitId, rabbitId) ||
                other.rabbitId == rabbitId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.receiptUrl, receiptUrl) ||
                other.receiptUrl == receiptUrl) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.rabbit, rabbit) || other.rabbit == rabbit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    category,
    amount,
    transactionDate,
    rabbitId,
    description,
    receiptUrl,
    createdBy,
    createdAt,
    updatedAt,
    rabbit,
  );

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      __$$TransactionImplCopyWithImpl<_$TransactionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionImplToJson(this);
  }
}

abstract class _Transaction implements Transaction {
  const factory _Transaction({
    @IntConverter() required final int id,
    required final TransactionType type,
    required final TransactionCategory category,
    @DoubleConverter() required final double amount,
    @JsonKey(name: 'transaction_date') required final DateTime transactionDate,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() final int? rabbitId,
    final String? description,
    @JsonKey(name: 'receipt_url') final String? receiptUrl,
    @JsonKey(name: 'created_by') @NullableIntConverter() final int? createdBy,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final RabbitModel? rabbit,
  }) = _$TransactionImpl;

  factory _Transaction.fromJson(Map<String, dynamic> json) =
      _$TransactionImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  TransactionType get type;
  @override
  TransactionCategory get category;
  @override
  @DoubleConverter()
  double get amount;
  @override
  @JsonKey(name: 'transaction_date')
  DateTime get transactionDate;
  @override
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  int? get rabbitId;
  @override
  String? get description;
  @override
  @JsonKey(name: 'receipt_url')
  String? get receiptUrl;
  @override
  @JsonKey(name: 'created_by')
  @NullableIntConverter()
  int? get createdBy;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt; // Relationships (not included in JSON serialization by default)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  RabbitModel? get rabbit;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransactionCreate _$TransactionCreateFromJson(Map<String, dynamic> json) {
  return _TransactionCreate.fromJson(json);
}

/// @nodoc
mixin _$TransactionCreate {
  TransactionType get type => throw _privateConstructorUsedError;
  TransactionCategory get category => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_date')
  DateTime get transactionDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  int? get rabbitId => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'receipt_url')
  String? get receiptUrl => throw _privateConstructorUsedError;

  /// Serializes this TransactionCreate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCreateCopyWith<TransactionCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCreateCopyWith<$Res> {
  factory $TransactionCreateCopyWith(
    TransactionCreate value,
    $Res Function(TransactionCreate) then,
  ) = _$TransactionCreateCopyWithImpl<$Res, TransactionCreate>;
  @useResult
  $Res call({
    TransactionType type,
    TransactionCategory category,
    double amount,
    @JsonKey(name: 'transaction_date') DateTime transactionDate,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() int? rabbitId,
    String? description,
    @JsonKey(name: 'receipt_url') String? receiptUrl,
  });
}

/// @nodoc
class _$TransactionCreateCopyWithImpl<$Res, $Val extends TransactionCreate>
    implements $TransactionCreateCopyWith<$Res> {
  _$TransactionCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? category = null,
    Object? amount = null,
    Object? transactionDate = null,
    Object? rabbitId = freezed,
    Object? description = freezed,
    Object? receiptUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as TransactionType,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as TransactionCategory,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            transactionDate: null == transactionDate
                ? _value.transactionDate
                : transactionDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            rabbitId: freezed == rabbitId
                ? _value.rabbitId
                : rabbitId // ignore: cast_nullable_to_non_nullable
                      as int?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            receiptUrl: freezed == receiptUrl
                ? _value.receiptUrl
                : receiptUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionCreateImplCopyWith<$Res>
    implements $TransactionCreateCopyWith<$Res> {
  factory _$$TransactionCreateImplCopyWith(
    _$TransactionCreateImpl value,
    $Res Function(_$TransactionCreateImpl) then,
  ) = __$$TransactionCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    TransactionType type,
    TransactionCategory category,
    double amount,
    @JsonKey(name: 'transaction_date') DateTime transactionDate,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() int? rabbitId,
    String? description,
    @JsonKey(name: 'receipt_url') String? receiptUrl,
  });
}

/// @nodoc
class __$$TransactionCreateImplCopyWithImpl<$Res>
    extends _$TransactionCreateCopyWithImpl<$Res, _$TransactionCreateImpl>
    implements _$$TransactionCreateImplCopyWith<$Res> {
  __$$TransactionCreateImplCopyWithImpl(
    _$TransactionCreateImpl _value,
    $Res Function(_$TransactionCreateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? category = null,
    Object? amount = null,
    Object? transactionDate = null,
    Object? rabbitId = freezed,
    Object? description = freezed,
    Object? receiptUrl = freezed,
  }) {
    return _then(
      _$TransactionCreateImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as TransactionType,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as TransactionCategory,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        transactionDate: null == transactionDate
            ? _value.transactionDate
            : transactionDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        rabbitId: freezed == rabbitId
            ? _value.rabbitId
            : rabbitId // ignore: cast_nullable_to_non_nullable
                  as int?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        receiptUrl: freezed == receiptUrl
            ? _value.receiptUrl
            : receiptUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionCreateImpl implements _TransactionCreate {
  const _$TransactionCreateImpl({
    required this.type,
    required this.category,
    required this.amount,
    @JsonKey(name: 'transaction_date') required this.transactionDate,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() this.rabbitId,
    this.description,
    @JsonKey(name: 'receipt_url') this.receiptUrl,
  });

  factory _$TransactionCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionCreateImplFromJson(json);

  @override
  final TransactionType type;
  @override
  final TransactionCategory category;
  @override
  final double amount;
  @override
  @JsonKey(name: 'transaction_date')
  final DateTime transactionDate;
  @override
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  final int? rabbitId;
  @override
  final String? description;
  @override
  @JsonKey(name: 'receipt_url')
  final String? receiptUrl;

  @override
  String toString() {
    return 'TransactionCreate(type: $type, category: $category, amount: $amount, transactionDate: $transactionDate, rabbitId: $rabbitId, description: $description, receiptUrl: $receiptUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionCreateImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.rabbitId, rabbitId) ||
                other.rabbitId == rabbitId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.receiptUrl, receiptUrl) ||
                other.receiptUrl == receiptUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    category,
    amount,
    transactionDate,
    rabbitId,
    description,
    receiptUrl,
  );

  /// Create a copy of TransactionCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionCreateImplCopyWith<_$TransactionCreateImpl> get copyWith =>
      __$$TransactionCreateImplCopyWithImpl<_$TransactionCreateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionCreateImplToJson(this);
  }
}

abstract class _TransactionCreate implements TransactionCreate {
  const factory _TransactionCreate({
    required final TransactionType type,
    required final TransactionCategory category,
    required final double amount,
    @JsonKey(name: 'transaction_date') required final DateTime transactionDate,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() final int? rabbitId,
    final String? description,
    @JsonKey(name: 'receipt_url') final String? receiptUrl,
  }) = _$TransactionCreateImpl;

  factory _TransactionCreate.fromJson(Map<String, dynamic> json) =
      _$TransactionCreateImpl.fromJson;

  @override
  TransactionType get type;
  @override
  TransactionCategory get category;
  @override
  double get amount;
  @override
  @JsonKey(name: 'transaction_date')
  DateTime get transactionDate;
  @override
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  int? get rabbitId;
  @override
  String? get description;
  @override
  @JsonKey(name: 'receipt_url')
  String? get receiptUrl;

  /// Create a copy of TransactionCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionCreateImplCopyWith<_$TransactionCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransactionUpdate _$TransactionUpdateFromJson(Map<String, dynamic> json) {
  return _TransactionUpdate.fromJson(json);
}

/// @nodoc
mixin _$TransactionUpdate {
  TransactionType? get type => throw _privateConstructorUsedError;
  TransactionCategory? get category => throw _privateConstructorUsedError;
  double? get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_date')
  DateTime? get transactionDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  int? get rabbitId => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'receipt_url')
  String? get receiptUrl => throw _privateConstructorUsedError;

  /// Serializes this TransactionUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionUpdateCopyWith<TransactionUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionUpdateCopyWith<$Res> {
  factory $TransactionUpdateCopyWith(
    TransactionUpdate value,
    $Res Function(TransactionUpdate) then,
  ) = _$TransactionUpdateCopyWithImpl<$Res, TransactionUpdate>;
  @useResult
  $Res call({
    TransactionType? type,
    TransactionCategory? category,
    double? amount,
    @JsonKey(name: 'transaction_date') DateTime? transactionDate,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() int? rabbitId,
    String? description,
    @JsonKey(name: 'receipt_url') String? receiptUrl,
  });
}

/// @nodoc
class _$TransactionUpdateCopyWithImpl<$Res, $Val extends TransactionUpdate>
    implements $TransactionUpdateCopyWith<$Res> {
  _$TransactionUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? category = freezed,
    Object? amount = freezed,
    Object? transactionDate = freezed,
    Object? rabbitId = freezed,
    Object? description = freezed,
    Object? receiptUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as TransactionType?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as TransactionCategory?,
            amount: freezed == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double?,
            transactionDate: freezed == transactionDate
                ? _value.transactionDate
                : transactionDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            rabbitId: freezed == rabbitId
                ? _value.rabbitId
                : rabbitId // ignore: cast_nullable_to_non_nullable
                      as int?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            receiptUrl: freezed == receiptUrl
                ? _value.receiptUrl
                : receiptUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionUpdateImplCopyWith<$Res>
    implements $TransactionUpdateCopyWith<$Res> {
  factory _$$TransactionUpdateImplCopyWith(
    _$TransactionUpdateImpl value,
    $Res Function(_$TransactionUpdateImpl) then,
  ) = __$$TransactionUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    TransactionType? type,
    TransactionCategory? category,
    double? amount,
    @JsonKey(name: 'transaction_date') DateTime? transactionDate,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() int? rabbitId,
    String? description,
    @JsonKey(name: 'receipt_url') String? receiptUrl,
  });
}

/// @nodoc
class __$$TransactionUpdateImplCopyWithImpl<$Res>
    extends _$TransactionUpdateCopyWithImpl<$Res, _$TransactionUpdateImpl>
    implements _$$TransactionUpdateImplCopyWith<$Res> {
  __$$TransactionUpdateImplCopyWithImpl(
    _$TransactionUpdateImpl _value,
    $Res Function(_$TransactionUpdateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? category = freezed,
    Object? amount = freezed,
    Object? transactionDate = freezed,
    Object? rabbitId = freezed,
    Object? description = freezed,
    Object? receiptUrl = freezed,
  }) {
    return _then(
      _$TransactionUpdateImpl(
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as TransactionType?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as TransactionCategory?,
        amount: freezed == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double?,
        transactionDate: freezed == transactionDate
            ? _value.transactionDate
            : transactionDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        rabbitId: freezed == rabbitId
            ? _value.rabbitId
            : rabbitId // ignore: cast_nullable_to_non_nullable
                  as int?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        receiptUrl: freezed == receiptUrl
            ? _value.receiptUrl
            : receiptUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionUpdateImpl implements _TransactionUpdate {
  const _$TransactionUpdateImpl({
    this.type,
    this.category,
    this.amount,
    @JsonKey(name: 'transaction_date') this.transactionDate,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() this.rabbitId,
    this.description,
    @JsonKey(name: 'receipt_url') this.receiptUrl,
  });

  factory _$TransactionUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionUpdateImplFromJson(json);

  @override
  final TransactionType? type;
  @override
  final TransactionCategory? category;
  @override
  final double? amount;
  @override
  @JsonKey(name: 'transaction_date')
  final DateTime? transactionDate;
  @override
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  final int? rabbitId;
  @override
  final String? description;
  @override
  @JsonKey(name: 'receipt_url')
  final String? receiptUrl;

  @override
  String toString() {
    return 'TransactionUpdate(type: $type, category: $category, amount: $amount, transactionDate: $transactionDate, rabbitId: $rabbitId, description: $description, receiptUrl: $receiptUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionUpdateImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.rabbitId, rabbitId) ||
                other.rabbitId == rabbitId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.receiptUrl, receiptUrl) ||
                other.receiptUrl == receiptUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    category,
    amount,
    transactionDate,
    rabbitId,
    description,
    receiptUrl,
  );

  /// Create a copy of TransactionUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionUpdateImplCopyWith<_$TransactionUpdateImpl> get copyWith =>
      __$$TransactionUpdateImplCopyWithImpl<_$TransactionUpdateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionUpdateImplToJson(this);
  }
}

abstract class _TransactionUpdate implements TransactionUpdate {
  const factory _TransactionUpdate({
    final TransactionType? type,
    final TransactionCategory? category,
    final double? amount,
    @JsonKey(name: 'transaction_date') final DateTime? transactionDate,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() final int? rabbitId,
    final String? description,
    @JsonKey(name: 'receipt_url') final String? receiptUrl,
  }) = _$TransactionUpdateImpl;

  factory _TransactionUpdate.fromJson(Map<String, dynamic> json) =
      _$TransactionUpdateImpl.fromJson;

  @override
  TransactionType? get type;
  @override
  TransactionCategory? get category;
  @override
  double? get amount;
  @override
  @JsonKey(name: 'transaction_date')
  DateTime? get transactionDate;
  @override
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  int? get rabbitId;
  @override
  String? get description;
  @override
  @JsonKey(name: 'receipt_url')
  String? get receiptUrl;

  /// Create a copy of TransactionUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionUpdateImplCopyWith<_$TransactionUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FinancialStatistics _$FinancialStatisticsFromJson(Map<String, dynamic> json) {
  return _FinancialStatistics.fromJson(json);
}

/// @nodoc
mixin _$FinancialStatistics {
  @JsonKey(name: 'total_income')
  @DoubleConverter()
  double get totalIncome => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_expenses')
  @DoubleConverter()
  double get totalExpenses => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_profit')
  @DoubleConverter()
  double get netProfit => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_transactions')
  @IntConverter()
  int get totalTransactions => throw _privateConstructorUsedError;
  @JsonKey(name: 'income_by_category')
  List<CategoryStatistics> get incomeByCategory =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'expenses_by_category')
  List<CategoryStatistics> get expensesByCategory =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'recent_transactions')
  List<Transaction> get recentTransactions =>
      throw _privateConstructorUsedError;

  /// Serializes this FinancialStatistics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FinancialStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancialStatisticsCopyWith<FinancialStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialStatisticsCopyWith<$Res> {
  factory $FinancialStatisticsCopyWith(
    FinancialStatistics value,
    $Res Function(FinancialStatistics) then,
  ) = _$FinancialStatisticsCopyWithImpl<$Res, FinancialStatistics>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_income') @DoubleConverter() double totalIncome,
    @JsonKey(name: 'total_expenses') @DoubleConverter() double totalExpenses,
    @JsonKey(name: 'net_profit') @DoubleConverter() double netProfit,
    @JsonKey(name: 'total_transactions') @IntConverter() int totalTransactions,
    @JsonKey(name: 'income_by_category')
    List<CategoryStatistics> incomeByCategory,
    @JsonKey(name: 'expenses_by_category')
    List<CategoryStatistics> expensesByCategory,
    @JsonKey(name: 'recent_transactions') List<Transaction> recentTransactions,
  });
}

/// @nodoc
class _$FinancialStatisticsCopyWithImpl<$Res, $Val extends FinancialStatistics>
    implements $FinancialStatisticsCopyWith<$Res> {
  _$FinancialStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancialStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpenses = null,
    Object? netProfit = null,
    Object? totalTransactions = null,
    Object? incomeByCategory = null,
    Object? expensesByCategory = null,
    Object? recentTransactions = null,
  }) {
    return _then(
      _value.copyWith(
            totalIncome: null == totalIncome
                ? _value.totalIncome
                : totalIncome // ignore: cast_nullable_to_non_nullable
                      as double,
            totalExpenses: null == totalExpenses
                ? _value.totalExpenses
                : totalExpenses // ignore: cast_nullable_to_non_nullable
                      as double,
            netProfit: null == netProfit
                ? _value.netProfit
                : netProfit // ignore: cast_nullable_to_non_nullable
                      as double,
            totalTransactions: null == totalTransactions
                ? _value.totalTransactions
                : totalTransactions // ignore: cast_nullable_to_non_nullable
                      as int,
            incomeByCategory: null == incomeByCategory
                ? _value.incomeByCategory
                : incomeByCategory // ignore: cast_nullable_to_non_nullable
                      as List<CategoryStatistics>,
            expensesByCategory: null == expensesByCategory
                ? _value.expensesByCategory
                : expensesByCategory // ignore: cast_nullable_to_non_nullable
                      as List<CategoryStatistics>,
            recentTransactions: null == recentTransactions
                ? _value.recentTransactions
                : recentTransactions // ignore: cast_nullable_to_non_nullable
                      as List<Transaction>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FinancialStatisticsImplCopyWith<$Res>
    implements $FinancialStatisticsCopyWith<$Res> {
  factory _$$FinancialStatisticsImplCopyWith(
    _$FinancialStatisticsImpl value,
    $Res Function(_$FinancialStatisticsImpl) then,
  ) = __$$FinancialStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_income') @DoubleConverter() double totalIncome,
    @JsonKey(name: 'total_expenses') @DoubleConverter() double totalExpenses,
    @JsonKey(name: 'net_profit') @DoubleConverter() double netProfit,
    @JsonKey(name: 'total_transactions') @IntConverter() int totalTransactions,
    @JsonKey(name: 'income_by_category')
    List<CategoryStatistics> incomeByCategory,
    @JsonKey(name: 'expenses_by_category')
    List<CategoryStatistics> expensesByCategory,
    @JsonKey(name: 'recent_transactions') List<Transaction> recentTransactions,
  });
}

/// @nodoc
class __$$FinancialStatisticsImplCopyWithImpl<$Res>
    extends _$FinancialStatisticsCopyWithImpl<$Res, _$FinancialStatisticsImpl>
    implements _$$FinancialStatisticsImplCopyWith<$Res> {
  __$$FinancialStatisticsImplCopyWithImpl(
    _$FinancialStatisticsImpl _value,
    $Res Function(_$FinancialStatisticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FinancialStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpenses = null,
    Object? netProfit = null,
    Object? totalTransactions = null,
    Object? incomeByCategory = null,
    Object? expensesByCategory = null,
    Object? recentTransactions = null,
  }) {
    return _then(
      _$FinancialStatisticsImpl(
        totalIncome: null == totalIncome
            ? _value.totalIncome
            : totalIncome // ignore: cast_nullable_to_non_nullable
                  as double,
        totalExpenses: null == totalExpenses
            ? _value.totalExpenses
            : totalExpenses // ignore: cast_nullable_to_non_nullable
                  as double,
        netProfit: null == netProfit
            ? _value.netProfit
            : netProfit // ignore: cast_nullable_to_non_nullable
                  as double,
        totalTransactions: null == totalTransactions
            ? _value.totalTransactions
            : totalTransactions // ignore: cast_nullable_to_non_nullable
                  as int,
        incomeByCategory: null == incomeByCategory
            ? _value._incomeByCategory
            : incomeByCategory // ignore: cast_nullable_to_non_nullable
                  as List<CategoryStatistics>,
        expensesByCategory: null == expensesByCategory
            ? _value._expensesByCategory
            : expensesByCategory // ignore: cast_nullable_to_non_nullable
                  as List<CategoryStatistics>,
        recentTransactions: null == recentTransactions
            ? _value._recentTransactions
            : recentTransactions // ignore: cast_nullable_to_non_nullable
                  as List<Transaction>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialStatisticsImpl implements _FinancialStatistics {
  const _$FinancialStatisticsImpl({
    @JsonKey(name: 'total_income') @DoubleConverter() required this.totalIncome,
    @JsonKey(name: 'total_expenses')
    @DoubleConverter()
    required this.totalExpenses,
    @JsonKey(name: 'net_profit') @DoubleConverter() required this.netProfit,
    @JsonKey(name: 'total_transactions')
    @IntConverter()
    required this.totalTransactions,
    @JsonKey(name: 'income_by_category')
    required final List<CategoryStatistics> incomeByCategory,
    @JsonKey(name: 'expenses_by_category')
    required final List<CategoryStatistics> expensesByCategory,
    @JsonKey(name: 'recent_transactions')
    required final List<Transaction> recentTransactions,
  }) : _incomeByCategory = incomeByCategory,
       _expensesByCategory = expensesByCategory,
       _recentTransactions = recentTransactions;

  factory _$FinancialStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialStatisticsImplFromJson(json);

  @override
  @JsonKey(name: 'total_income')
  @DoubleConverter()
  final double totalIncome;
  @override
  @JsonKey(name: 'total_expenses')
  @DoubleConverter()
  final double totalExpenses;
  @override
  @JsonKey(name: 'net_profit')
  @DoubleConverter()
  final double netProfit;
  @override
  @JsonKey(name: 'total_transactions')
  @IntConverter()
  final int totalTransactions;
  final List<CategoryStatistics> _incomeByCategory;
  @override
  @JsonKey(name: 'income_by_category')
  List<CategoryStatistics> get incomeByCategory {
    if (_incomeByCategory is EqualUnmodifiableListView)
      return _incomeByCategory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_incomeByCategory);
  }

  final List<CategoryStatistics> _expensesByCategory;
  @override
  @JsonKey(name: 'expenses_by_category')
  List<CategoryStatistics> get expensesByCategory {
    if (_expensesByCategory is EqualUnmodifiableListView)
      return _expensesByCategory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expensesByCategory);
  }

  final List<Transaction> _recentTransactions;
  @override
  @JsonKey(name: 'recent_transactions')
  List<Transaction> get recentTransactions {
    if (_recentTransactions is EqualUnmodifiableListView)
      return _recentTransactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentTransactions);
  }

  @override
  String toString() {
    return 'FinancialStatistics(totalIncome: $totalIncome, totalExpenses: $totalExpenses, netProfit: $netProfit, totalTransactions: $totalTransactions, incomeByCategory: $incomeByCategory, expensesByCategory: $expensesByCategory, recentTransactions: $recentTransactions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialStatisticsImpl &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpenses, totalExpenses) ||
                other.totalExpenses == totalExpenses) &&
            (identical(other.netProfit, netProfit) ||
                other.netProfit == netProfit) &&
            (identical(other.totalTransactions, totalTransactions) ||
                other.totalTransactions == totalTransactions) &&
            const DeepCollectionEquality().equals(
              other._incomeByCategory,
              _incomeByCategory,
            ) &&
            const DeepCollectionEquality().equals(
              other._expensesByCategory,
              _expensesByCategory,
            ) &&
            const DeepCollectionEquality().equals(
              other._recentTransactions,
              _recentTransactions,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalIncome,
    totalExpenses,
    netProfit,
    totalTransactions,
    const DeepCollectionEquality().hash(_incomeByCategory),
    const DeepCollectionEquality().hash(_expensesByCategory),
    const DeepCollectionEquality().hash(_recentTransactions),
  );

  /// Create a copy of FinancialStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialStatisticsImplCopyWith<_$FinancialStatisticsImpl> get copyWith =>
      __$$FinancialStatisticsImplCopyWithImpl<_$FinancialStatisticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialStatisticsImplToJson(this);
  }
}

abstract class _FinancialStatistics implements FinancialStatistics {
  const factory _FinancialStatistics({
    @JsonKey(name: 'total_income')
    @DoubleConverter()
    required final double totalIncome,
    @JsonKey(name: 'total_expenses')
    @DoubleConverter()
    required final double totalExpenses,
    @JsonKey(name: 'net_profit')
    @DoubleConverter()
    required final double netProfit,
    @JsonKey(name: 'total_transactions')
    @IntConverter()
    required final int totalTransactions,
    @JsonKey(name: 'income_by_category')
    required final List<CategoryStatistics> incomeByCategory,
    @JsonKey(name: 'expenses_by_category')
    required final List<CategoryStatistics> expensesByCategory,
    @JsonKey(name: 'recent_transactions')
    required final List<Transaction> recentTransactions,
  }) = _$FinancialStatisticsImpl;

  factory _FinancialStatistics.fromJson(Map<String, dynamic> json) =
      _$FinancialStatisticsImpl.fromJson;

  @override
  @JsonKey(name: 'total_income')
  @DoubleConverter()
  double get totalIncome;
  @override
  @JsonKey(name: 'total_expenses')
  @DoubleConverter()
  double get totalExpenses;
  @override
  @JsonKey(name: 'net_profit')
  @DoubleConverter()
  double get netProfit;
  @override
  @JsonKey(name: 'total_transactions')
  @IntConverter()
  int get totalTransactions;
  @override
  @JsonKey(name: 'income_by_category')
  List<CategoryStatistics> get incomeByCategory;
  @override
  @JsonKey(name: 'expenses_by_category')
  List<CategoryStatistics> get expensesByCategory;
  @override
  @JsonKey(name: 'recent_transactions')
  List<Transaction> get recentTransactions;

  /// Create a copy of FinancialStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancialStatisticsImplCopyWith<_$FinancialStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CategoryStatistics _$CategoryStatisticsFromJson(Map<String, dynamic> json) {
  return _CategoryStatistics.fromJson(json);
}

/// @nodoc
mixin _$CategoryStatistics {
  TransactionCategory get category => throw _privateConstructorUsedError;
  @DoubleConverter()
  double get total => throw _privateConstructorUsedError;
  @IntConverter()
  int get count => throw _privateConstructorUsedError;

  /// Serializes this CategoryStatistics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryStatisticsCopyWith<CategoryStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryStatisticsCopyWith<$Res> {
  factory $CategoryStatisticsCopyWith(
    CategoryStatistics value,
    $Res Function(CategoryStatistics) then,
  ) = _$CategoryStatisticsCopyWithImpl<$Res, CategoryStatistics>;
  @useResult
  $Res call({
    TransactionCategory category,
    @DoubleConverter() double total,
    @IntConverter() int count,
  });
}

/// @nodoc
class _$CategoryStatisticsCopyWithImpl<$Res, $Val extends CategoryStatistics>
    implements $CategoryStatisticsCopyWith<$Res> {
  _$CategoryStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? total = null,
    Object? count = null,
  }) {
    return _then(
      _value.copyWith(
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as TransactionCategory,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as double,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CategoryStatisticsImplCopyWith<$Res>
    implements $CategoryStatisticsCopyWith<$Res> {
  factory _$$CategoryStatisticsImplCopyWith(
    _$CategoryStatisticsImpl value,
    $Res Function(_$CategoryStatisticsImpl) then,
  ) = __$$CategoryStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    TransactionCategory category,
    @DoubleConverter() double total,
    @IntConverter() int count,
  });
}

/// @nodoc
class __$$CategoryStatisticsImplCopyWithImpl<$Res>
    extends _$CategoryStatisticsCopyWithImpl<$Res, _$CategoryStatisticsImpl>
    implements _$$CategoryStatisticsImplCopyWith<$Res> {
  __$$CategoryStatisticsImplCopyWithImpl(
    _$CategoryStatisticsImpl _value,
    $Res Function(_$CategoryStatisticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? total = null,
    Object? count = null,
  }) {
    return _then(
      _$CategoryStatisticsImpl(
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as TransactionCategory,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as double,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryStatisticsImpl implements _CategoryStatistics {
  const _$CategoryStatisticsImpl({
    required this.category,
    @DoubleConverter() required this.total,
    @IntConverter() required this.count,
  });

  factory _$CategoryStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryStatisticsImplFromJson(json);

  @override
  final TransactionCategory category;
  @override
  @DoubleConverter()
  final double total;
  @override
  @IntConverter()
  final int count;

  @override
  String toString() {
    return 'CategoryStatistics(category: $category, total: $total, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryStatisticsImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, category, total, count);

  /// Create a copy of CategoryStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryStatisticsImplCopyWith<_$CategoryStatisticsImpl> get copyWith =>
      __$$CategoryStatisticsImplCopyWithImpl<_$CategoryStatisticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryStatisticsImplToJson(this);
  }
}

abstract class _CategoryStatistics implements CategoryStatistics {
  const factory _CategoryStatistics({
    required final TransactionCategory category,
    @DoubleConverter() required final double total,
    @IntConverter() required final int count,
  }) = _$CategoryStatisticsImpl;

  factory _CategoryStatistics.fromJson(Map<String, dynamic> json) =
      _$CategoryStatisticsImpl.fromJson;

  @override
  TransactionCategory get category;
  @override
  @DoubleConverter()
  double get total;
  @override
  @IntConverter()
  int get count;

  /// Create a copy of CategoryStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryStatisticsImplCopyWith<_$CategoryStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MonthlyReport _$MonthlyReportFromJson(Map<String, dynamic> json) {
  return _MonthlyReport.fromJson(json);
}

/// @nodoc
mixin _$MonthlyReport {
  ReportPeriod get period => throw _privateConstructorUsedError;
  ReportSummary get summary => throw _privateConstructorUsedError;
  List<Transaction> get transactions => throw _privateConstructorUsedError;

  /// Serializes this MonthlyReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyReportCopyWith<MonthlyReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyReportCopyWith<$Res> {
  factory $MonthlyReportCopyWith(
    MonthlyReport value,
    $Res Function(MonthlyReport) then,
  ) = _$MonthlyReportCopyWithImpl<$Res, MonthlyReport>;
  @useResult
  $Res call({
    ReportPeriod period,
    ReportSummary summary,
    List<Transaction> transactions,
  });

  $ReportPeriodCopyWith<$Res> get period;
  $ReportSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$MonthlyReportCopyWithImpl<$Res, $Val extends MonthlyReport>
    implements $MonthlyReportCopyWith<$Res> {
  _$MonthlyReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? summary = null,
    Object? transactions = null,
  }) {
    return _then(
      _value.copyWith(
            period: null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                      as ReportPeriod,
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as ReportSummary,
            transactions: null == transactions
                ? _value.transactions
                : transactions // ignore: cast_nullable_to_non_nullable
                      as List<Transaction>,
          )
          as $Val,
    );
  }

  /// Create a copy of MonthlyReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReportPeriodCopyWith<$Res> get period {
    return $ReportPeriodCopyWith<$Res>(_value.period, (value) {
      return _then(_value.copyWith(period: value) as $Val);
    });
  }

  /// Create a copy of MonthlyReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReportSummaryCopyWith<$Res> get summary {
    return $ReportSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MonthlyReportImplCopyWith<$Res>
    implements $MonthlyReportCopyWith<$Res> {
  factory _$$MonthlyReportImplCopyWith(
    _$MonthlyReportImpl value,
    $Res Function(_$MonthlyReportImpl) then,
  ) = __$$MonthlyReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ReportPeriod period,
    ReportSummary summary,
    List<Transaction> transactions,
  });

  @override
  $ReportPeriodCopyWith<$Res> get period;
  @override
  $ReportSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$MonthlyReportImplCopyWithImpl<$Res>
    extends _$MonthlyReportCopyWithImpl<$Res, _$MonthlyReportImpl>
    implements _$$MonthlyReportImplCopyWith<$Res> {
  __$$MonthlyReportImplCopyWithImpl(
    _$MonthlyReportImpl _value,
    $Res Function(_$MonthlyReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MonthlyReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
    Object? summary = null,
    Object? transactions = null,
  }) {
    return _then(
      _$MonthlyReportImpl(
        period: null == period
            ? _value.period
            : period // ignore: cast_nullable_to_non_nullable
                  as ReportPeriod,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as ReportSummary,
        transactions: null == transactions
            ? _value._transactions
            : transactions // ignore: cast_nullable_to_non_nullable
                  as List<Transaction>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlyReportImpl implements _MonthlyReport {
  const _$MonthlyReportImpl({
    required this.period,
    required this.summary,
    required final List<Transaction> transactions,
  }) : _transactions = transactions;

  factory _$MonthlyReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlyReportImplFromJson(json);

  @override
  final ReportPeriod period;
  @override
  final ReportSummary summary;
  final List<Transaction> _transactions;
  @override
  List<Transaction> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  @override
  String toString() {
    return 'MonthlyReport(period: $period, summary: $summary, transactions: $transactions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyReportImpl &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(
              other._transactions,
              _transactions,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    period,
    summary,
    const DeepCollectionEquality().hash(_transactions),
  );

  /// Create a copy of MonthlyReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyReportImplCopyWith<_$MonthlyReportImpl> get copyWith =>
      __$$MonthlyReportImplCopyWithImpl<_$MonthlyReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyReportImplToJson(this);
  }
}

abstract class _MonthlyReport implements MonthlyReport {
  const factory _MonthlyReport({
    required final ReportPeriod period,
    required final ReportSummary summary,
    required final List<Transaction> transactions,
  }) = _$MonthlyReportImpl;

  factory _MonthlyReport.fromJson(Map<String, dynamic> json) =
      _$MonthlyReportImpl.fromJson;

  @override
  ReportPeriod get period;
  @override
  ReportSummary get summary;
  @override
  List<Transaction> get transactions;

  /// Create a copy of MonthlyReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyReportImplCopyWith<_$MonthlyReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportPeriod _$ReportPeriodFromJson(Map<String, dynamic> json) {
  return _ReportPeriod.fromJson(json);
}

/// @nodoc
mixin _$ReportPeriod {
  @IntConverter()
  int get year => throw _privateConstructorUsedError;
  @IntConverter()
  int get month => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date')
  DateTime get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  DateTime get endDate => throw _privateConstructorUsedError;

  /// Serializes this ReportPeriod to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportPeriod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportPeriodCopyWith<ReportPeriod> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportPeriodCopyWith<$Res> {
  factory $ReportPeriodCopyWith(
    ReportPeriod value,
    $Res Function(ReportPeriod) then,
  ) = _$ReportPeriodCopyWithImpl<$Res, ReportPeriod>;
  @useResult
  $Res call({
    @IntConverter() int year,
    @IntConverter() int month,
    @JsonKey(name: 'start_date') DateTime startDate,
    @JsonKey(name: 'end_date') DateTime endDate,
  });
}

/// @nodoc
class _$ReportPeriodCopyWithImpl<$Res, $Val extends ReportPeriod>
    implements $ReportPeriodCopyWith<$Res> {
  _$ReportPeriodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportPeriod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(
      _value.copyWith(
            year: null == year
                ? _value.year
                : year // ignore: cast_nullable_to_non_nullable
                      as int,
            month: null == month
                ? _value.month
                : month // ignore: cast_nullable_to_non_nullable
                      as int,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportPeriodImplCopyWith<$Res>
    implements $ReportPeriodCopyWith<$Res> {
  factory _$$ReportPeriodImplCopyWith(
    _$ReportPeriodImpl value,
    $Res Function(_$ReportPeriodImpl) then,
  ) = __$$ReportPeriodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int year,
    @IntConverter() int month,
    @JsonKey(name: 'start_date') DateTime startDate,
    @JsonKey(name: 'end_date') DateTime endDate,
  });
}

/// @nodoc
class __$$ReportPeriodImplCopyWithImpl<$Res>
    extends _$ReportPeriodCopyWithImpl<$Res, _$ReportPeriodImpl>
    implements _$$ReportPeriodImplCopyWith<$Res> {
  __$$ReportPeriodImplCopyWithImpl(
    _$ReportPeriodImpl _value,
    $Res Function(_$ReportPeriodImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportPeriod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(
      _$ReportPeriodImpl(
        year: null == year
            ? _value.year
            : year // ignore: cast_nullable_to_non_nullable
                  as int,
        month: null == month
            ? _value.month
            : month // ignore: cast_nullable_to_non_nullable
                  as int,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportPeriodImpl implements _ReportPeriod {
  const _$ReportPeriodImpl({
    @IntConverter() required this.year,
    @IntConverter() required this.month,
    @JsonKey(name: 'start_date') required this.startDate,
    @JsonKey(name: 'end_date') required this.endDate,
  });

  factory _$ReportPeriodImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportPeriodImplFromJson(json);

  @override
  @IntConverter()
  final int year;
  @override
  @IntConverter()
  final int month;
  @override
  @JsonKey(name: 'start_date')
  final DateTime startDate;
  @override
  @JsonKey(name: 'end_date')
  final DateTime endDate;

  @override
  String toString() {
    return 'ReportPeriod(year: $year, month: $month, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportPeriodImpl &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, year, month, startDate, endDate);

  /// Create a copy of ReportPeriod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportPeriodImplCopyWith<_$ReportPeriodImpl> get copyWith =>
      __$$ReportPeriodImplCopyWithImpl<_$ReportPeriodImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportPeriodImplToJson(this);
  }
}

abstract class _ReportPeriod implements ReportPeriod {
  const factory _ReportPeriod({
    @IntConverter() required final int year,
    @IntConverter() required final int month,
    @JsonKey(name: 'start_date') required final DateTime startDate,
    @JsonKey(name: 'end_date') required final DateTime endDate,
  }) = _$ReportPeriodImpl;

  factory _ReportPeriod.fromJson(Map<String, dynamic> json) =
      _$ReportPeriodImpl.fromJson;

  @override
  @IntConverter()
  int get year;
  @override
  @IntConverter()
  int get month;
  @override
  @JsonKey(name: 'start_date')
  DateTime get startDate;
  @override
  @JsonKey(name: 'end_date')
  DateTime get endDate;

  /// Create a copy of ReportPeriod
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportPeriodImplCopyWith<_$ReportPeriodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportSummary _$ReportSummaryFromJson(Map<String, dynamic> json) {
  return _ReportSummary.fromJson(json);
}

/// @nodoc
mixin _$ReportSummary {
  @JsonKey(name: 'total_income')
  @DoubleConverter()
  double get totalIncome => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_expenses')
  @DoubleConverter()
  double get totalExpenses => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_profit')
  @DoubleConverter()
  double get netProfit => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_count')
  @IntConverter()
  int get transactionCount => throw _privateConstructorUsedError;

  /// Serializes this ReportSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportSummaryCopyWith<ReportSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportSummaryCopyWith<$Res> {
  factory $ReportSummaryCopyWith(
    ReportSummary value,
    $Res Function(ReportSummary) then,
  ) = _$ReportSummaryCopyWithImpl<$Res, ReportSummary>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_income') @DoubleConverter() double totalIncome,
    @JsonKey(name: 'total_expenses') @DoubleConverter() double totalExpenses,
    @JsonKey(name: 'net_profit') @DoubleConverter() double netProfit,
    @JsonKey(name: 'transaction_count') @IntConverter() int transactionCount,
  });
}

/// @nodoc
class _$ReportSummaryCopyWithImpl<$Res, $Val extends ReportSummary>
    implements $ReportSummaryCopyWith<$Res> {
  _$ReportSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpenses = null,
    Object? netProfit = null,
    Object? transactionCount = null,
  }) {
    return _then(
      _value.copyWith(
            totalIncome: null == totalIncome
                ? _value.totalIncome
                : totalIncome // ignore: cast_nullable_to_non_nullable
                      as double,
            totalExpenses: null == totalExpenses
                ? _value.totalExpenses
                : totalExpenses // ignore: cast_nullable_to_non_nullable
                      as double,
            netProfit: null == netProfit
                ? _value.netProfit
                : netProfit // ignore: cast_nullable_to_non_nullable
                      as double,
            transactionCount: null == transactionCount
                ? _value.transactionCount
                : transactionCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportSummaryImplCopyWith<$Res>
    implements $ReportSummaryCopyWith<$Res> {
  factory _$$ReportSummaryImplCopyWith(
    _$ReportSummaryImpl value,
    $Res Function(_$ReportSummaryImpl) then,
  ) = __$$ReportSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_income') @DoubleConverter() double totalIncome,
    @JsonKey(name: 'total_expenses') @DoubleConverter() double totalExpenses,
    @JsonKey(name: 'net_profit') @DoubleConverter() double netProfit,
    @JsonKey(name: 'transaction_count') @IntConverter() int transactionCount,
  });
}

/// @nodoc
class __$$ReportSummaryImplCopyWithImpl<$Res>
    extends _$ReportSummaryCopyWithImpl<$Res, _$ReportSummaryImpl>
    implements _$$ReportSummaryImplCopyWith<$Res> {
  __$$ReportSummaryImplCopyWithImpl(
    _$ReportSummaryImpl _value,
    $Res Function(_$ReportSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpenses = null,
    Object? netProfit = null,
    Object? transactionCount = null,
  }) {
    return _then(
      _$ReportSummaryImpl(
        totalIncome: null == totalIncome
            ? _value.totalIncome
            : totalIncome // ignore: cast_nullable_to_non_nullable
                  as double,
        totalExpenses: null == totalExpenses
            ? _value.totalExpenses
            : totalExpenses // ignore: cast_nullable_to_non_nullable
                  as double,
        netProfit: null == netProfit
            ? _value.netProfit
            : netProfit // ignore: cast_nullable_to_non_nullable
                  as double,
        transactionCount: null == transactionCount
            ? _value.transactionCount
            : transactionCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportSummaryImpl implements _ReportSummary {
  const _$ReportSummaryImpl({
    @JsonKey(name: 'total_income') @DoubleConverter() required this.totalIncome,
    @JsonKey(name: 'total_expenses')
    @DoubleConverter()
    required this.totalExpenses,
    @JsonKey(name: 'net_profit') @DoubleConverter() required this.netProfit,
    @JsonKey(name: 'transaction_count')
    @IntConverter()
    required this.transactionCount,
  });

  factory _$ReportSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportSummaryImplFromJson(json);

  @override
  @JsonKey(name: 'total_income')
  @DoubleConverter()
  final double totalIncome;
  @override
  @JsonKey(name: 'total_expenses')
  @DoubleConverter()
  final double totalExpenses;
  @override
  @JsonKey(name: 'net_profit')
  @DoubleConverter()
  final double netProfit;
  @override
  @JsonKey(name: 'transaction_count')
  @IntConverter()
  final int transactionCount;

  @override
  String toString() {
    return 'ReportSummary(totalIncome: $totalIncome, totalExpenses: $totalExpenses, netProfit: $netProfit, transactionCount: $transactionCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportSummaryImpl &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpenses, totalExpenses) ||
                other.totalExpenses == totalExpenses) &&
            (identical(other.netProfit, netProfit) ||
                other.netProfit == netProfit) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalIncome,
    totalExpenses,
    netProfit,
    transactionCount,
  );

  /// Create a copy of ReportSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportSummaryImplCopyWith<_$ReportSummaryImpl> get copyWith =>
      __$$ReportSummaryImplCopyWithImpl<_$ReportSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportSummaryImplToJson(this);
  }
}

abstract class _ReportSummary implements ReportSummary {
  const factory _ReportSummary({
    @JsonKey(name: 'total_income')
    @DoubleConverter()
    required final double totalIncome,
    @JsonKey(name: 'total_expenses')
    @DoubleConverter()
    required final double totalExpenses,
    @JsonKey(name: 'net_profit')
    @DoubleConverter()
    required final double netProfit,
    @JsonKey(name: 'transaction_count')
    @IntConverter()
    required final int transactionCount,
  }) = _$ReportSummaryImpl;

  factory _ReportSummary.fromJson(Map<String, dynamic> json) =
      _$ReportSummaryImpl.fromJson;

  @override
  @JsonKey(name: 'total_income')
  @DoubleConverter()
  double get totalIncome;
  @override
  @JsonKey(name: 'total_expenses')
  @DoubleConverter()
  double get totalExpenses;
  @override
  @JsonKey(name: 'net_profit')
  @DoubleConverter()
  double get netProfit;
  @override
  @JsonKey(name: 'transaction_count')
  @IntConverter()
  int get transactionCount;

  /// Create a copy of ReportSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportSummaryImplCopyWith<_$ReportSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RabbitTransactionsSummary _$RabbitTransactionsSummaryFromJson(
  Map<String, dynamic> json,
) {
  return _RabbitTransactionsSummary.fromJson(json);
}

/// @nodoc
mixin _$RabbitTransactionsSummary {
  List<Transaction> get transactions => throw _privateConstructorUsedError;
  TransactionSummary get summary => throw _privateConstructorUsedError;

  /// Serializes this RabbitTransactionsSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RabbitTransactionsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RabbitTransactionsSummaryCopyWith<RabbitTransactionsSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RabbitTransactionsSummaryCopyWith<$Res> {
  factory $RabbitTransactionsSummaryCopyWith(
    RabbitTransactionsSummary value,
    $Res Function(RabbitTransactionsSummary) then,
  ) = _$RabbitTransactionsSummaryCopyWithImpl<$Res, RabbitTransactionsSummary>;
  @useResult
  $Res call({List<Transaction> transactions, TransactionSummary summary});

  $TransactionSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$RabbitTransactionsSummaryCopyWithImpl<
  $Res,
  $Val extends RabbitTransactionsSummary
>
    implements $RabbitTransactionsSummaryCopyWith<$Res> {
  _$RabbitTransactionsSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RabbitTransactionsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? transactions = null, Object? summary = null}) {
    return _then(
      _value.copyWith(
            transactions: null == transactions
                ? _value.transactions
                : transactions // ignore: cast_nullable_to_non_nullable
                      as List<Transaction>,
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as TransactionSummary,
          )
          as $Val,
    );
  }

  /// Create a copy of RabbitTransactionsSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransactionSummaryCopyWith<$Res> get summary {
    return $TransactionSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RabbitTransactionsSummaryImplCopyWith<$Res>
    implements $RabbitTransactionsSummaryCopyWith<$Res> {
  factory _$$RabbitTransactionsSummaryImplCopyWith(
    _$RabbitTransactionsSummaryImpl value,
    $Res Function(_$RabbitTransactionsSummaryImpl) then,
  ) = __$$RabbitTransactionsSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Transaction> transactions, TransactionSummary summary});

  @override
  $TransactionSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$RabbitTransactionsSummaryImplCopyWithImpl<$Res>
    extends
        _$RabbitTransactionsSummaryCopyWithImpl<
          $Res,
          _$RabbitTransactionsSummaryImpl
        >
    implements _$$RabbitTransactionsSummaryImplCopyWith<$Res> {
  __$$RabbitTransactionsSummaryImplCopyWithImpl(
    _$RabbitTransactionsSummaryImpl _value,
    $Res Function(_$RabbitTransactionsSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RabbitTransactionsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? transactions = null, Object? summary = null}) {
    return _then(
      _$RabbitTransactionsSummaryImpl(
        transactions: null == transactions
            ? _value._transactions
            : transactions // ignore: cast_nullable_to_non_nullable
                  as List<Transaction>,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as TransactionSummary,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RabbitTransactionsSummaryImpl implements _RabbitTransactionsSummary {
  const _$RabbitTransactionsSummaryImpl({
    required final List<Transaction> transactions,
    required this.summary,
  }) : _transactions = transactions;

  factory _$RabbitTransactionsSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$RabbitTransactionsSummaryImplFromJson(json);

  final List<Transaction> _transactions;
  @override
  List<Transaction> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  @override
  final TransactionSummary summary;

  @override
  String toString() {
    return 'RabbitTransactionsSummary(transactions: $transactions, summary: $summary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RabbitTransactionsSummaryImpl &&
            const DeepCollectionEquality().equals(
              other._transactions,
              _transactions,
            ) &&
            (identical(other.summary, summary) || other.summary == summary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_transactions),
    summary,
  );

  /// Create a copy of RabbitTransactionsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RabbitTransactionsSummaryImplCopyWith<_$RabbitTransactionsSummaryImpl>
  get copyWith =>
      __$$RabbitTransactionsSummaryImplCopyWithImpl<
        _$RabbitTransactionsSummaryImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RabbitTransactionsSummaryImplToJson(this);
  }
}

abstract class _RabbitTransactionsSummary implements RabbitTransactionsSummary {
  const factory _RabbitTransactionsSummary({
    required final List<Transaction> transactions,
    required final TransactionSummary summary,
  }) = _$RabbitTransactionsSummaryImpl;

  factory _RabbitTransactionsSummary.fromJson(Map<String, dynamic> json) =
      _$RabbitTransactionsSummaryImpl.fromJson;

  @override
  List<Transaction> get transactions;
  @override
  TransactionSummary get summary;

  /// Create a copy of RabbitTransactionsSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RabbitTransactionsSummaryImplCopyWith<_$RabbitTransactionsSummaryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

TransactionSummary _$TransactionSummaryFromJson(Map<String, dynamic> json) {
  return _TransactionSummary.fromJson(json);
}

/// @nodoc
mixin _$TransactionSummary {
  @JsonKey(name: 'total_income')
  @DoubleConverter()
  double get totalIncome => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_expenses')
  @DoubleConverter()
  double get totalExpenses => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_profit')
  @DoubleConverter()
  double get netProfit => throw _privateConstructorUsedError;

  /// Serializes this TransactionSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionSummaryCopyWith<TransactionSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionSummaryCopyWith<$Res> {
  factory $TransactionSummaryCopyWith(
    TransactionSummary value,
    $Res Function(TransactionSummary) then,
  ) = _$TransactionSummaryCopyWithImpl<$Res, TransactionSummary>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_income') @DoubleConverter() double totalIncome,
    @JsonKey(name: 'total_expenses') @DoubleConverter() double totalExpenses,
    @JsonKey(name: 'net_profit') @DoubleConverter() double netProfit,
  });
}

/// @nodoc
class _$TransactionSummaryCopyWithImpl<$Res, $Val extends TransactionSummary>
    implements $TransactionSummaryCopyWith<$Res> {
  _$TransactionSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpenses = null,
    Object? netProfit = null,
  }) {
    return _then(
      _value.copyWith(
            totalIncome: null == totalIncome
                ? _value.totalIncome
                : totalIncome // ignore: cast_nullable_to_non_nullable
                      as double,
            totalExpenses: null == totalExpenses
                ? _value.totalExpenses
                : totalExpenses // ignore: cast_nullable_to_non_nullable
                      as double,
            netProfit: null == netProfit
                ? _value.netProfit
                : netProfit // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionSummaryImplCopyWith<$Res>
    implements $TransactionSummaryCopyWith<$Res> {
  factory _$$TransactionSummaryImplCopyWith(
    _$TransactionSummaryImpl value,
    $Res Function(_$TransactionSummaryImpl) then,
  ) = __$$TransactionSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_income') @DoubleConverter() double totalIncome,
    @JsonKey(name: 'total_expenses') @DoubleConverter() double totalExpenses,
    @JsonKey(name: 'net_profit') @DoubleConverter() double netProfit,
  });
}

/// @nodoc
class __$$TransactionSummaryImplCopyWithImpl<$Res>
    extends _$TransactionSummaryCopyWithImpl<$Res, _$TransactionSummaryImpl>
    implements _$$TransactionSummaryImplCopyWith<$Res> {
  __$$TransactionSummaryImplCopyWithImpl(
    _$TransactionSummaryImpl _value,
    $Res Function(_$TransactionSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpenses = null,
    Object? netProfit = null,
  }) {
    return _then(
      _$TransactionSummaryImpl(
        totalIncome: null == totalIncome
            ? _value.totalIncome
            : totalIncome // ignore: cast_nullable_to_non_nullable
                  as double,
        totalExpenses: null == totalExpenses
            ? _value.totalExpenses
            : totalExpenses // ignore: cast_nullable_to_non_nullable
                  as double,
        netProfit: null == netProfit
            ? _value.netProfit
            : netProfit // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionSummaryImpl implements _TransactionSummary {
  const _$TransactionSummaryImpl({
    @JsonKey(name: 'total_income') @DoubleConverter() required this.totalIncome,
    @JsonKey(name: 'total_expenses')
    @DoubleConverter()
    required this.totalExpenses,
    @JsonKey(name: 'net_profit') @DoubleConverter() required this.netProfit,
  });

  factory _$TransactionSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionSummaryImplFromJson(json);

  @override
  @JsonKey(name: 'total_income')
  @DoubleConverter()
  final double totalIncome;
  @override
  @JsonKey(name: 'total_expenses')
  @DoubleConverter()
  final double totalExpenses;
  @override
  @JsonKey(name: 'net_profit')
  @DoubleConverter()
  final double netProfit;

  @override
  String toString() {
    return 'TransactionSummary(totalIncome: $totalIncome, totalExpenses: $totalExpenses, netProfit: $netProfit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionSummaryImpl &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpenses, totalExpenses) ||
                other.totalExpenses == totalExpenses) &&
            (identical(other.netProfit, netProfit) ||
                other.netProfit == netProfit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, totalIncome, totalExpenses, netProfit);

  /// Create a copy of TransactionSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionSummaryImplCopyWith<_$TransactionSummaryImpl> get copyWith =>
      __$$TransactionSummaryImplCopyWithImpl<_$TransactionSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionSummaryImplToJson(this);
  }
}

abstract class _TransactionSummary implements TransactionSummary {
  const factory _TransactionSummary({
    @JsonKey(name: 'total_income')
    @DoubleConverter()
    required final double totalIncome,
    @JsonKey(name: 'total_expenses')
    @DoubleConverter()
    required final double totalExpenses,
    @JsonKey(name: 'net_profit')
    @DoubleConverter()
    required final double netProfit,
  }) = _$TransactionSummaryImpl;

  factory _TransactionSummary.fromJson(Map<String, dynamic> json) =
      _$TransactionSummaryImpl.fromJson;

  @override
  @JsonKey(name: 'total_income')
  @DoubleConverter()
  double get totalIncome;
  @override
  @JsonKey(name: 'total_expenses')
  @DoubleConverter()
  double get totalExpenses;
  @override
  @JsonKey(name: 'net_profit')
  @DoubleConverter()
  double get netProfit;

  /// Create a copy of TransactionSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionSummaryImplCopyWith<_$TransactionSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
