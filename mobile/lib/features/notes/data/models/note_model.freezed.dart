// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NoteModel _$NoteModelFromJson(Map<String, dynamic> json) {
  return _NoteModel.fromJson(json);
}

/// @nodoc
mixin _$NoteModel {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  int? get rabbitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'cage_id')
  @NullableIntConverter()
  int? get cageId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  @NullableDateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  RabbitRef? get rabbit => throw _privateConstructorUsedError;
  CageInfo? get cage => throw _privateConstructorUsedError;
  UserRef? get author => throw _privateConstructorUsedError;

  /// Serializes this NoteModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoteModelCopyWith<NoteModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteModelCopyWith<$Res> {
  factory $NoteModelCopyWith(NoteModel value, $Res Function(NoteModel) then) =
      _$NoteModelCopyWithImpl<$Res, NoteModel>;
  @useResult
  $Res call({
    @IntConverter() int id,
    String content,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() int? rabbitId,
    @JsonKey(name: 'cage_id') @NullableIntConverter() int? cageId,
    @JsonKey(name: 'created_at')
    @NullableDateTimeConverter()
    DateTime? createdAt,
    RabbitRef? rabbit,
    CageInfo? cage,
    UserRef? author,
  });

  $RabbitRefCopyWith<$Res>? get rabbit;
  $CageInfoCopyWith<$Res>? get cage;
  $UserRefCopyWith<$Res>? get author;
}

/// @nodoc
class _$NoteModelCopyWithImpl<$Res, $Val extends NoteModel>
    implements $NoteModelCopyWith<$Res> {
  _$NoteModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? rabbitId = freezed,
    Object? cageId = freezed,
    Object? createdAt = freezed,
    Object? rabbit = freezed,
    Object? cage = freezed,
    Object? author = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            rabbitId: freezed == rabbitId
                ? _value.rabbitId
                : rabbitId // ignore: cast_nullable_to_non_nullable
                      as int?,
            cageId: freezed == cageId
                ? _value.cageId
                : cageId // ignore: cast_nullable_to_non_nullable
                      as int?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            rabbit: freezed == rabbit
                ? _value.rabbit
                : rabbit // ignore: cast_nullable_to_non_nullable
                      as RabbitRef?,
            cage: freezed == cage
                ? _value.cage
                : cage // ignore: cast_nullable_to_non_nullable
                      as CageInfo?,
            author: freezed == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as UserRef?,
          )
          as $Val,
    );
  }

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RabbitRefCopyWith<$Res>? get rabbit {
    if (_value.rabbit == null) {
      return null;
    }

    return $RabbitRefCopyWith<$Res>(_value.rabbit!, (value) {
      return _then(_value.copyWith(rabbit: value) as $Val);
    });
  }

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CageInfoCopyWith<$Res>? get cage {
    if (_value.cage == null) {
      return null;
    }

    return $CageInfoCopyWith<$Res>(_value.cage!, (value) {
      return _then(_value.copyWith(cage: value) as $Val);
    });
  }

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserRefCopyWith<$Res>? get author {
    if (_value.author == null) {
      return null;
    }

    return $UserRefCopyWith<$Res>(_value.author!, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NoteModelImplCopyWith<$Res>
    implements $NoteModelCopyWith<$Res> {
  factory _$$NoteModelImplCopyWith(
    _$NoteModelImpl value,
    $Res Function(_$NoteModelImpl) then,
  ) = __$$NoteModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    String content,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() int? rabbitId,
    @JsonKey(name: 'cage_id') @NullableIntConverter() int? cageId,
    @JsonKey(name: 'created_at')
    @NullableDateTimeConverter()
    DateTime? createdAt,
    RabbitRef? rabbit,
    CageInfo? cage,
    UserRef? author,
  });

  @override
  $RabbitRefCopyWith<$Res>? get rabbit;
  @override
  $CageInfoCopyWith<$Res>? get cage;
  @override
  $UserRefCopyWith<$Res>? get author;
}

/// @nodoc
class __$$NoteModelImplCopyWithImpl<$Res>
    extends _$NoteModelCopyWithImpl<$Res, _$NoteModelImpl>
    implements _$$NoteModelImplCopyWith<$Res> {
  __$$NoteModelImplCopyWithImpl(
    _$NoteModelImpl _value,
    $Res Function(_$NoteModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? rabbitId = freezed,
    Object? cageId = freezed,
    Object? createdAt = freezed,
    Object? rabbit = freezed,
    Object? cage = freezed,
    Object? author = freezed,
  }) {
    return _then(
      _$NoteModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        rabbitId: freezed == rabbitId
            ? _value.rabbitId
            : rabbitId // ignore: cast_nullable_to_non_nullable
                  as int?,
        cageId: freezed == cageId
            ? _value.cageId
            : cageId // ignore: cast_nullable_to_non_nullable
                  as int?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        rabbit: freezed == rabbit
            ? _value.rabbit
            : rabbit // ignore: cast_nullable_to_non_nullable
                  as RabbitRef?,
        cage: freezed == cage
            ? _value.cage
            : cage // ignore: cast_nullable_to_non_nullable
                  as CageInfo?,
        author: freezed == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as UserRef?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NoteModelImpl implements _NoteModel {
  const _$NoteModelImpl({
    @IntConverter() required this.id,
    required this.content,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() this.rabbitId,
    @JsonKey(name: 'cage_id') @NullableIntConverter() this.cageId,
    @JsonKey(name: 'created_at') @NullableDateTimeConverter() this.createdAt,
    this.rabbit,
    this.cage,
    this.author,
  });

  factory _$NoteModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoteModelImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  final String content;
  @override
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  final int? rabbitId;
  @override
  @JsonKey(name: 'cage_id')
  @NullableIntConverter()
  final int? cageId;
  @override
  @JsonKey(name: 'created_at')
  @NullableDateTimeConverter()
  final DateTime? createdAt;
  @override
  final RabbitRef? rabbit;
  @override
  final CageInfo? cage;
  @override
  final UserRef? author;

  @override
  String toString() {
    return 'NoteModel(id: $id, content: $content, rabbitId: $rabbitId, cageId: $cageId, createdAt: $createdAt, rabbit: $rabbit, cage: $cage, author: $author)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.rabbitId, rabbitId) ||
                other.rabbitId == rabbitId) &&
            (identical(other.cageId, cageId) || other.cageId == cageId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.rabbit, rabbit) || other.rabbit == rabbit) &&
            (identical(other.cage, cage) || other.cage == cage) &&
            (identical(other.author, author) || other.author == author));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    content,
    rabbitId,
    cageId,
    createdAt,
    rabbit,
    cage,
    author,
  );

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteModelImplCopyWith<_$NoteModelImpl> get copyWith =>
      __$$NoteModelImplCopyWithImpl<_$NoteModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoteModelImplToJson(this);
  }
}

abstract class _NoteModel implements NoteModel {
  const factory _NoteModel({
    @IntConverter() required final int id,
    required final String content,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() final int? rabbitId,
    @JsonKey(name: 'cage_id') @NullableIntConverter() final int? cageId,
    @JsonKey(name: 'created_at')
    @NullableDateTimeConverter()
    final DateTime? createdAt,
    final RabbitRef? rabbit,
    final CageInfo? cage,
    final UserRef? author,
  }) = _$NoteModelImpl;

  factory _NoteModel.fromJson(Map<String, dynamic> json) =
      _$NoteModelImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  String get content;
  @override
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  int? get rabbitId;
  @override
  @JsonKey(name: 'cage_id')
  @NullableIntConverter()
  int? get cageId;
  @override
  @JsonKey(name: 'created_at')
  @NullableDateTimeConverter()
  DateTime? get createdAt;
  @override
  RabbitRef? get rabbit;
  @override
  CageInfo? get cage;
  @override
  UserRef? get author;

  /// Create a copy of NoteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoteModelImplCopyWith<_$NoteModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NoteCreate _$NoteCreateFromJson(Map<String, dynamic> json) {
  return _NoteCreate.fromJson(json);
}

/// @nodoc
mixin _$NoteCreate {
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'rabbit_id')
  int? get rabbitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'cage_id')
  int? get cageId => throw _privateConstructorUsedError;

  /// Serializes this NoteCreate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NoteCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoteCreateCopyWith<NoteCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteCreateCopyWith<$Res> {
  factory $NoteCreateCopyWith(
    NoteCreate value,
    $Res Function(NoteCreate) then,
  ) = _$NoteCreateCopyWithImpl<$Res, NoteCreate>;
  @useResult
  $Res call({
    String content,
    @JsonKey(name: 'rabbit_id') int? rabbitId,
    @JsonKey(name: 'cage_id') int? cageId,
  });
}

/// @nodoc
class _$NoteCreateCopyWithImpl<$Res, $Val extends NoteCreate>
    implements $NoteCreateCopyWith<$Res> {
  _$NoteCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NoteCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? rabbitId = freezed,
    Object? cageId = freezed,
  }) {
    return _then(
      _value.copyWith(
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            rabbitId: freezed == rabbitId
                ? _value.rabbitId
                : rabbitId // ignore: cast_nullable_to_non_nullable
                      as int?,
            cageId: freezed == cageId
                ? _value.cageId
                : cageId // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NoteCreateImplCopyWith<$Res>
    implements $NoteCreateCopyWith<$Res> {
  factory _$$NoteCreateImplCopyWith(
    _$NoteCreateImpl value,
    $Res Function(_$NoteCreateImpl) then,
  ) = __$$NoteCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String content,
    @JsonKey(name: 'rabbit_id') int? rabbitId,
    @JsonKey(name: 'cage_id') int? cageId,
  });
}

/// @nodoc
class __$$NoteCreateImplCopyWithImpl<$Res>
    extends _$NoteCreateCopyWithImpl<$Res, _$NoteCreateImpl>
    implements _$$NoteCreateImplCopyWith<$Res> {
  __$$NoteCreateImplCopyWithImpl(
    _$NoteCreateImpl _value,
    $Res Function(_$NoteCreateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NoteCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? rabbitId = freezed,
    Object? cageId = freezed,
  }) {
    return _then(
      _$NoteCreateImpl(
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        rabbitId: freezed == rabbitId
            ? _value.rabbitId
            : rabbitId // ignore: cast_nullable_to_non_nullable
                  as int?,
        cageId: freezed == cageId
            ? _value.cageId
            : cageId // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NoteCreateImpl implements _NoteCreate {
  const _$NoteCreateImpl({
    required this.content,
    @JsonKey(name: 'rabbit_id') this.rabbitId,
    @JsonKey(name: 'cage_id') this.cageId,
  });

  factory _$NoteCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoteCreateImplFromJson(json);

  @override
  final String content;
  @override
  @JsonKey(name: 'rabbit_id')
  final int? rabbitId;
  @override
  @JsonKey(name: 'cage_id')
  final int? cageId;

  @override
  String toString() {
    return 'NoteCreate(content: $content, rabbitId: $rabbitId, cageId: $cageId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteCreateImpl &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.rabbitId, rabbitId) ||
                other.rabbitId == rabbitId) &&
            (identical(other.cageId, cageId) || other.cageId == cageId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, content, rabbitId, cageId);

  /// Create a copy of NoteCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteCreateImplCopyWith<_$NoteCreateImpl> get copyWith =>
      __$$NoteCreateImplCopyWithImpl<_$NoteCreateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoteCreateImplToJson(this);
  }
}

abstract class _NoteCreate implements NoteCreate {
  const factory _NoteCreate({
    required final String content,
    @JsonKey(name: 'rabbit_id') final int? rabbitId,
    @JsonKey(name: 'cage_id') final int? cageId,
  }) = _$NoteCreateImpl;

  factory _NoteCreate.fromJson(Map<String, dynamic> json) =
      _$NoteCreateImpl.fromJson;

  @override
  String get content;
  @override
  @JsonKey(name: 'rabbit_id')
  int? get rabbitId;
  @override
  @JsonKey(name: 'cage_id')
  int? get cageId;

  /// Create a copy of NoteCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoteCreateImplCopyWith<_$NoteCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NoteUpdate _$NoteUpdateFromJson(Map<String, dynamic> json) {
  return _NoteUpdate.fromJson(json);
}

/// @nodoc
mixin _$NoteUpdate {
  String? get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'rabbit_id')
  int? get rabbitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'cage_id')
  int? get cageId => throw _privateConstructorUsedError;

  /// Serializes this NoteUpdate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NoteUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoteUpdateCopyWith<NoteUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteUpdateCopyWith<$Res> {
  factory $NoteUpdateCopyWith(
    NoteUpdate value,
    $Res Function(NoteUpdate) then,
  ) = _$NoteUpdateCopyWithImpl<$Res, NoteUpdate>;
  @useResult
  $Res call({
    String? content,
    @JsonKey(name: 'rabbit_id') int? rabbitId,
    @JsonKey(name: 'cage_id') int? cageId,
  });
}

/// @nodoc
class _$NoteUpdateCopyWithImpl<$Res, $Val extends NoteUpdate>
    implements $NoteUpdateCopyWith<$Res> {
  _$NoteUpdateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NoteUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = freezed,
    Object? rabbitId = freezed,
    Object? cageId = freezed,
  }) {
    return _then(
      _value.copyWith(
            content: freezed == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String?,
            rabbitId: freezed == rabbitId
                ? _value.rabbitId
                : rabbitId // ignore: cast_nullable_to_non_nullable
                      as int?,
            cageId: freezed == cageId
                ? _value.cageId
                : cageId // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NoteUpdateImplCopyWith<$Res>
    implements $NoteUpdateCopyWith<$Res> {
  factory _$$NoteUpdateImplCopyWith(
    _$NoteUpdateImpl value,
    $Res Function(_$NoteUpdateImpl) then,
  ) = __$$NoteUpdateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? content,
    @JsonKey(name: 'rabbit_id') int? rabbitId,
    @JsonKey(name: 'cage_id') int? cageId,
  });
}

/// @nodoc
class __$$NoteUpdateImplCopyWithImpl<$Res>
    extends _$NoteUpdateCopyWithImpl<$Res, _$NoteUpdateImpl>
    implements _$$NoteUpdateImplCopyWith<$Res> {
  __$$NoteUpdateImplCopyWithImpl(
    _$NoteUpdateImpl _value,
    $Res Function(_$NoteUpdateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NoteUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = freezed,
    Object? rabbitId = freezed,
    Object? cageId = freezed,
  }) {
    return _then(
      _$NoteUpdateImpl(
        content: freezed == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String?,
        rabbitId: freezed == rabbitId
            ? _value.rabbitId
            : rabbitId // ignore: cast_nullable_to_non_nullable
                  as int?,
        cageId: freezed == cageId
            ? _value.cageId
            : cageId // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NoteUpdateImpl implements _NoteUpdate {
  const _$NoteUpdateImpl({
    this.content,
    @JsonKey(name: 'rabbit_id') this.rabbitId,
    @JsonKey(name: 'cage_id') this.cageId,
  });

  factory _$NoteUpdateImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoteUpdateImplFromJson(json);

  @override
  final String? content;
  @override
  @JsonKey(name: 'rabbit_id')
  final int? rabbitId;
  @override
  @JsonKey(name: 'cage_id')
  final int? cageId;

  @override
  String toString() {
    return 'NoteUpdate(content: $content, rabbitId: $rabbitId, cageId: $cageId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteUpdateImpl &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.rabbitId, rabbitId) ||
                other.rabbitId == rabbitId) &&
            (identical(other.cageId, cageId) || other.cageId == cageId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, content, rabbitId, cageId);

  /// Create a copy of NoteUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteUpdateImplCopyWith<_$NoteUpdateImpl> get copyWith =>
      __$$NoteUpdateImplCopyWithImpl<_$NoteUpdateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoteUpdateImplToJson(this);
  }
}

abstract class _NoteUpdate implements NoteUpdate {
  const factory _NoteUpdate({
    final String? content,
    @JsonKey(name: 'rabbit_id') final int? rabbitId,
    @JsonKey(name: 'cage_id') final int? cageId,
  }) = _$NoteUpdateImpl;

  factory _NoteUpdate.fromJson(Map<String, dynamic> json) =
      _$NoteUpdateImpl.fromJson;

  @override
  String? get content;
  @override
  @JsonKey(name: 'rabbit_id')
  int? get rabbitId;
  @override
  @JsonKey(name: 'cage_id')
  int? get cageId;

  /// Create a copy of NoteUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoteUpdateImplCopyWith<_$NoteUpdateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
