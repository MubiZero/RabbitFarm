// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pedigree_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PedigreeModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get tagId => throw _privateConstructorUsedError;
  String get sex => throw _privateConstructorUsedError;
  String? get birthDate => throw _privateConstructorUsedError;
  String? get breed => throw _privateConstructorUsedError;
  PedigreeModel? get father => throw _privateConstructorUsedError;
  PedigreeModel? get mother => throw _privateConstructorUsedError;

  /// Create a copy of PedigreeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PedigreeModelCopyWith<PedigreeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PedigreeModelCopyWith<$Res> {
  factory $PedigreeModelCopyWith(
    PedigreeModel value,
    $Res Function(PedigreeModel) then,
  ) = _$PedigreeModelCopyWithImpl<$Res, PedigreeModel>;
  @useResult
  $Res call({
    int id,
    String name,
    String? tagId,
    String sex,
    String? birthDate,
    String? breed,
    PedigreeModel? father,
    PedigreeModel? mother,
  });

  $PedigreeModelCopyWith<$Res>? get father;
  $PedigreeModelCopyWith<$Res>? get mother;
}

/// @nodoc
class _$PedigreeModelCopyWithImpl<$Res, $Val extends PedigreeModel>
    implements $PedigreeModelCopyWith<$Res> {
  _$PedigreeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PedigreeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? tagId = freezed,
    Object? sex = null,
    Object? birthDate = freezed,
    Object? breed = freezed,
    Object? father = freezed,
    Object? mother = freezed,
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
            tagId: freezed == tagId
                ? _value.tagId
                : tagId // ignore: cast_nullable_to_non_nullable
                      as String?,
            sex: null == sex
                ? _value.sex
                : sex // ignore: cast_nullable_to_non_nullable
                      as String,
            birthDate: freezed == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            breed: freezed == breed
                ? _value.breed
                : breed // ignore: cast_nullable_to_non_nullable
                      as String?,
            father: freezed == father
                ? _value.father
                : father // ignore: cast_nullable_to_non_nullable
                      as PedigreeModel?,
            mother: freezed == mother
                ? _value.mother
                : mother // ignore: cast_nullable_to_non_nullable
                      as PedigreeModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of PedigreeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PedigreeModelCopyWith<$Res>? get father {
    if (_value.father == null) {
      return null;
    }

    return $PedigreeModelCopyWith<$Res>(_value.father!, (value) {
      return _then(_value.copyWith(father: value) as $Val);
    });
  }

  /// Create a copy of PedigreeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PedigreeModelCopyWith<$Res>? get mother {
    if (_value.mother == null) {
      return null;
    }

    return $PedigreeModelCopyWith<$Res>(_value.mother!, (value) {
      return _then(_value.copyWith(mother: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PedigreeModelImplCopyWith<$Res>
    implements $PedigreeModelCopyWith<$Res> {
  factory _$$PedigreeModelImplCopyWith(
    _$PedigreeModelImpl value,
    $Res Function(_$PedigreeModelImpl) then,
  ) = __$$PedigreeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String? tagId,
    String sex,
    String? birthDate,
    String? breed,
    PedigreeModel? father,
    PedigreeModel? mother,
  });

  @override
  $PedigreeModelCopyWith<$Res>? get father;
  @override
  $PedigreeModelCopyWith<$Res>? get mother;
}

/// @nodoc
class __$$PedigreeModelImplCopyWithImpl<$Res>
    extends _$PedigreeModelCopyWithImpl<$Res, _$PedigreeModelImpl>
    implements _$$PedigreeModelImplCopyWith<$Res> {
  __$$PedigreeModelImplCopyWithImpl(
    _$PedigreeModelImpl _value,
    $Res Function(_$PedigreeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PedigreeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? tagId = freezed,
    Object? sex = null,
    Object? birthDate = freezed,
    Object? breed = freezed,
    Object? father = freezed,
    Object? mother = freezed,
  }) {
    return _then(
      _$PedigreeModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        tagId: freezed == tagId
            ? _value.tagId
            : tagId // ignore: cast_nullable_to_non_nullable
                  as String?,
        sex: null == sex
            ? _value.sex
            : sex // ignore: cast_nullable_to_non_nullable
                  as String,
        birthDate: freezed == birthDate
            ? _value.birthDate
            : birthDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        breed: freezed == breed
            ? _value.breed
            : breed // ignore: cast_nullable_to_non_nullable
                  as String?,
        father: freezed == father
            ? _value.father
            : father // ignore: cast_nullable_to_non_nullable
                  as PedigreeModel?,
        mother: freezed == mother
            ? _value.mother
            : mother // ignore: cast_nullable_to_non_nullable
                  as PedigreeModel?,
      ),
    );
  }
}

/// @nodoc

class _$PedigreeModelImpl implements _PedigreeModel {
  const _$PedigreeModelImpl({
    required this.id,
    required this.name,
    this.tagId,
    required this.sex,
    this.birthDate,
    this.breed,
    this.father,
    this.mother,
  });

  @override
  final int id;
  @override
  final String name;
  @override
  final String? tagId;
  @override
  final String sex;
  @override
  final String? birthDate;
  @override
  final String? breed;
  @override
  final PedigreeModel? father;
  @override
  final PedigreeModel? mother;

  @override
  String toString() {
    return 'PedigreeModel(id: $id, name: $name, tagId: $tagId, sex: $sex, birthDate: $birthDate, breed: $breed, father: $father, mother: $mother)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PedigreeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.tagId, tagId) || other.tagId == tagId) &&
            (identical(other.sex, sex) || other.sex == sex) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.breed, breed) || other.breed == breed) &&
            (identical(other.father, father) || other.father == father) &&
            (identical(other.mother, mother) || other.mother == mother));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    tagId,
    sex,
    birthDate,
    breed,
    father,
    mother,
  );

  /// Create a copy of PedigreeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PedigreeModelImplCopyWith<_$PedigreeModelImpl> get copyWith =>
      __$$PedigreeModelImplCopyWithImpl<_$PedigreeModelImpl>(this, _$identity);
}

abstract class _PedigreeModel implements PedigreeModel {
  const factory _PedigreeModel({
    required final int id,
    required final String name,
    final String? tagId,
    required final String sex,
    final String? birthDate,
    final String? breed,
    final PedigreeModel? father,
    final PedigreeModel? mother,
  }) = _$PedigreeModelImpl;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get tagId;
  @override
  String get sex;
  @override
  String? get birthDate;
  @override
  String? get breed;
  @override
  PedigreeModel? get father;
  @override
  PedigreeModel? get mother;

  /// Create a copy of PedigreeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PedigreeModelImplCopyWith<_$PedigreeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
