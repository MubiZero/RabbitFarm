// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'breed_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BreedModel _$BreedModelFromJson(Map<String, dynamic> json) {
  return _BreedModel.fromJson(json);
}

/// @nodoc
mixin _$BreedModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_weight')
  double? get averageWeight => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_litter_size')
  int? get averageLitterSize => throw _privateConstructorUsedError;
  String? get purpose => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_url')
  String? get photoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this BreedModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BreedModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BreedModelCopyWith<BreedModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreedModelCopyWith<$Res> {
  factory $BreedModelCopyWith(
    BreedModel value,
    $Res Function(BreedModel) then,
  ) = _$BreedModelCopyWithImpl<$Res, BreedModel>;
  @useResult
  $Res call({
    int id,
    String name,
    String? description,
    @JsonKey(name: 'average_weight') double? averageWeight,
    @JsonKey(name: 'average_litter_size') int? averageLitterSize,
    String? purpose,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$BreedModelCopyWithImpl<$Res, $Val extends BreedModel>
    implements $BreedModelCopyWith<$Res> {
  _$BreedModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BreedModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? averageWeight = freezed,
    Object? averageLitterSize = freezed,
    Object? purpose = freezed,
    Object? photoUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            averageWeight: freezed == averageWeight
                ? _value.averageWeight
                : averageWeight // ignore: cast_nullable_to_non_nullable
                      as double?,
            averageLitterSize: freezed == averageLitterSize
                ? _value.averageLitterSize
                : averageLitterSize // ignore: cast_nullable_to_non_nullable
                      as int?,
            purpose: freezed == purpose
                ? _value.purpose
                : purpose // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoUrl: freezed == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BreedModelImplCopyWith<$Res>
    implements $BreedModelCopyWith<$Res> {
  factory _$$BreedModelImplCopyWith(
    _$BreedModelImpl value,
    $Res Function(_$BreedModelImpl) then,
  ) = __$$BreedModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String? description,
    @JsonKey(name: 'average_weight') double? averageWeight,
    @JsonKey(name: 'average_litter_size') int? averageLitterSize,
    String? purpose,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$BreedModelImplCopyWithImpl<$Res>
    extends _$BreedModelCopyWithImpl<$Res, _$BreedModelImpl>
    implements _$$BreedModelImplCopyWith<$Res> {
  __$$BreedModelImplCopyWithImpl(
    _$BreedModelImpl _value,
    $Res Function(_$BreedModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BreedModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? averageWeight = freezed,
    Object? averageLitterSize = freezed,
    Object? purpose = freezed,
    Object? photoUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$BreedModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        averageWeight: freezed == averageWeight
            ? _value.averageWeight
            : averageWeight // ignore: cast_nullable_to_non_nullable
                  as double?,
        averageLitterSize: freezed == averageLitterSize
            ? _value.averageLitterSize
            : averageLitterSize // ignore: cast_nullable_to_non_nullable
                  as int?,
        purpose: freezed == purpose
            ? _value.purpose
            : purpose // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoUrl: freezed == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BreedModelImpl implements _BreedModel {
  const _$BreedModelImpl({
    required this.id,
    required this.name,
    this.description,
    @JsonKey(name: 'average_weight') this.averageWeight,
    @JsonKey(name: 'average_litter_size') this.averageLitterSize,
    this.purpose,
    @JsonKey(name: 'photo_url') this.photoUrl,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  });

  factory _$BreedModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BreedModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'average_weight')
  final double? averageWeight;
  @override
  @JsonKey(name: 'average_litter_size')
  final int? averageLitterSize;
  @override
  final String? purpose;
  @override
  @JsonKey(name: 'photo_url')
  final String? photoUrl;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'BreedModel(id: $id, name: $name, description: $description, averageWeight: $averageWeight, averageLitterSize: $averageLitterSize, purpose: $purpose, photoUrl: $photoUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreedModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.averageWeight, averageWeight) ||
                other.averageWeight == averageWeight) &&
            (identical(other.averageLitterSize, averageLitterSize) ||
                other.averageLitterSize == averageLitterSize) &&
            (identical(other.purpose, purpose) || other.purpose == purpose) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    averageWeight,
    averageLitterSize,
    purpose,
    photoUrl,
    createdAt,
    updatedAt,
  );

  /// Create a copy of BreedModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BreedModelImplCopyWith<_$BreedModelImpl> get copyWith =>
      __$$BreedModelImplCopyWithImpl<_$BreedModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BreedModelImplToJson(this);
  }
}

abstract class _BreedModel implements BreedModel {
  const factory _BreedModel({
    required final int id,
    required final String name,
    final String? description,
    @JsonKey(name: 'average_weight') final double? averageWeight,
    @JsonKey(name: 'average_litter_size') final int? averageLitterSize,
    final String? purpose,
    @JsonKey(name: 'photo_url') final String? photoUrl,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$BreedModelImpl;

  factory _BreedModel.fromJson(Map<String, dynamic> json) =
      _$BreedModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'average_weight')
  double? get averageWeight;
  @override
  @JsonKey(name: 'average_litter_size')
  int? get averageLitterSize;
  @override
  String? get purpose;
  @override
  @JsonKey(name: 'photo_url')
  String? get photoUrl;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of BreedModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BreedModelImplCopyWith<_$BreedModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
