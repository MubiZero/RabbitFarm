// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rabbit_photo_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RabbitPhoto _$RabbitPhotoFromJson(Map<String, dynamic> json) {
  return _RabbitPhoto.fromJson(json);
}

/// @nodoc
mixin _$RabbitPhoto {
  @IntConverter()
  int get id => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  @JsonKey(name: 'taken_at')
  @NullableDateTimeConverter()
  DateTime? get takenAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  @NullableDateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  UserRef? get author =>
      throw _privateConstructorUsedError; // Приходит только в общей по ферме ленте (/photos) — в галерее одного
  // кролика (/rabbits/:id/photos) он и так известен снаружи.
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  int? get rabbitId => throw _privateConstructorUsedError;
  RabbitRef? get rabbit => throw _privateConstructorUsedError;

  /// Serializes this RabbitPhoto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RabbitPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RabbitPhotoCopyWith<RabbitPhoto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RabbitPhotoCopyWith<$Res> {
  factory $RabbitPhotoCopyWith(
    RabbitPhoto value,
    $Res Function(RabbitPhoto) then,
  ) = _$RabbitPhotoCopyWithImpl<$Res, RabbitPhoto>;
  @useResult
  $Res call({
    @IntConverter() int id,
    String url,
    String? caption,
    @JsonKey(name: 'taken_at') @NullableDateTimeConverter() DateTime? takenAt,
    @JsonKey(name: 'created_at')
    @NullableDateTimeConverter()
    DateTime? createdAt,
    UserRef? author,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() int? rabbitId,
    RabbitRef? rabbit,
  });

  $UserRefCopyWith<$Res>? get author;
  $RabbitRefCopyWith<$Res>? get rabbit;
}

/// @nodoc
class _$RabbitPhotoCopyWithImpl<$Res, $Val extends RabbitPhoto>
    implements $RabbitPhotoCopyWith<$Res> {
  _$RabbitPhotoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RabbitPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? caption = freezed,
    Object? takenAt = freezed,
    Object? createdAt = freezed,
    Object? author = freezed,
    Object? rabbitId = freezed,
    Object? rabbit = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            caption: freezed == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String?,
            takenAt: freezed == takenAt
                ? _value.takenAt
                : takenAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            author: freezed == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as UserRef?,
            rabbitId: freezed == rabbitId
                ? _value.rabbitId
                : rabbitId // ignore: cast_nullable_to_non_nullable
                      as int?,
            rabbit: freezed == rabbit
                ? _value.rabbit
                : rabbit // ignore: cast_nullable_to_non_nullable
                      as RabbitRef?,
          )
          as $Val,
    );
  }

  /// Create a copy of RabbitPhoto
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

  /// Create a copy of RabbitPhoto
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
}

/// @nodoc
abstract class _$$RabbitPhotoImplCopyWith<$Res>
    implements $RabbitPhotoCopyWith<$Res> {
  factory _$$RabbitPhotoImplCopyWith(
    _$RabbitPhotoImpl value,
    $Res Function(_$RabbitPhotoImpl) then,
  ) = __$$RabbitPhotoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @IntConverter() int id,
    String url,
    String? caption,
    @JsonKey(name: 'taken_at') @NullableDateTimeConverter() DateTime? takenAt,
    @JsonKey(name: 'created_at')
    @NullableDateTimeConverter()
    DateTime? createdAt,
    UserRef? author,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() int? rabbitId,
    RabbitRef? rabbit,
  });

  @override
  $UserRefCopyWith<$Res>? get author;
  @override
  $RabbitRefCopyWith<$Res>? get rabbit;
}

/// @nodoc
class __$$RabbitPhotoImplCopyWithImpl<$Res>
    extends _$RabbitPhotoCopyWithImpl<$Res, _$RabbitPhotoImpl>
    implements _$$RabbitPhotoImplCopyWith<$Res> {
  __$$RabbitPhotoImplCopyWithImpl(
    _$RabbitPhotoImpl _value,
    $Res Function(_$RabbitPhotoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RabbitPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? caption = freezed,
    Object? takenAt = freezed,
    Object? createdAt = freezed,
    Object? author = freezed,
    Object? rabbitId = freezed,
    Object? rabbit = freezed,
  }) {
    return _then(
      _$RabbitPhotoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        caption: freezed == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String?,
        takenAt: freezed == takenAt
            ? _value.takenAt
            : takenAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        author: freezed == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as UserRef?,
        rabbitId: freezed == rabbitId
            ? _value.rabbitId
            : rabbitId // ignore: cast_nullable_to_non_nullable
                  as int?,
        rabbit: freezed == rabbit
            ? _value.rabbit
            : rabbit // ignore: cast_nullable_to_non_nullable
                  as RabbitRef?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RabbitPhotoImpl implements _RabbitPhoto {
  const _$RabbitPhotoImpl({
    @IntConverter() required this.id,
    required this.url,
    this.caption,
    @JsonKey(name: 'taken_at') @NullableDateTimeConverter() this.takenAt,
    @JsonKey(name: 'created_at') @NullableDateTimeConverter() this.createdAt,
    this.author,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() this.rabbitId,
    this.rabbit,
  });

  factory _$RabbitPhotoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RabbitPhotoImplFromJson(json);

  @override
  @IntConverter()
  final int id;
  @override
  final String url;
  @override
  final String? caption;
  @override
  @JsonKey(name: 'taken_at')
  @NullableDateTimeConverter()
  final DateTime? takenAt;
  @override
  @JsonKey(name: 'created_at')
  @NullableDateTimeConverter()
  final DateTime? createdAt;
  @override
  final UserRef? author;
  // Приходит только в общей по ферме ленте (/photos) — в галерее одного
  // кролика (/rabbits/:id/photos) он и так известен снаружи.
  @override
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  final int? rabbitId;
  @override
  final RabbitRef? rabbit;

  @override
  String toString() {
    return 'RabbitPhoto(id: $id, url: $url, caption: $caption, takenAt: $takenAt, createdAt: $createdAt, author: $author, rabbitId: $rabbitId, rabbit: $rabbit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RabbitPhotoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.takenAt, takenAt) || other.takenAt == takenAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.rabbitId, rabbitId) ||
                other.rabbitId == rabbitId) &&
            (identical(other.rabbit, rabbit) || other.rabbit == rabbit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    url,
    caption,
    takenAt,
    createdAt,
    author,
    rabbitId,
    rabbit,
  );

  /// Create a copy of RabbitPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RabbitPhotoImplCopyWith<_$RabbitPhotoImpl> get copyWith =>
      __$$RabbitPhotoImplCopyWithImpl<_$RabbitPhotoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RabbitPhotoImplToJson(this);
  }
}

abstract class _RabbitPhoto implements RabbitPhoto {
  const factory _RabbitPhoto({
    @IntConverter() required final int id,
    required final String url,
    final String? caption,
    @JsonKey(name: 'taken_at')
    @NullableDateTimeConverter()
    final DateTime? takenAt,
    @JsonKey(name: 'created_at')
    @NullableDateTimeConverter()
    final DateTime? createdAt,
    final UserRef? author,
    @JsonKey(name: 'rabbit_id') @NullableIntConverter() final int? rabbitId,
    final RabbitRef? rabbit,
  }) = _$RabbitPhotoImpl;

  factory _RabbitPhoto.fromJson(Map<String, dynamic> json) =
      _$RabbitPhotoImpl.fromJson;

  @override
  @IntConverter()
  int get id;
  @override
  String get url;
  @override
  String? get caption;
  @override
  @JsonKey(name: 'taken_at')
  @NullableDateTimeConverter()
  DateTime? get takenAt;
  @override
  @JsonKey(name: 'created_at')
  @NullableDateTimeConverter()
  DateTime? get createdAt;
  @override
  UserRef? get author; // Приходит только в общей по ферме ленте (/photos) — в галерее одного
  // кролика (/rabbits/:id/photos) он и так известен снаружи.
  @override
  @JsonKey(name: 'rabbit_id')
  @NullableIntConverter()
  int? get rabbitId;
  @override
  RabbitRef? get rabbit;

  /// Create a copy of RabbitPhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RabbitPhotoImplCopyWith<_$RabbitPhotoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
