import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/json/date_time_converter.dart';
import '../../../../core/json/int_converter.dart';
import 'breed_model.dart';

part 'rabbit_model.freezed.dart';
part 'rabbit_model.g.dart';

@freezed
abstract class RabbitModel with _$RabbitModel {
  const factory RabbitModel({
    @IntConverter() required int id,

    /// Клеймо и кличка необязательны: в базе оба столбца допускают пустоту,
    /// и сервер прямо разрешает завести кролика без них
    /// (`rabbitValidator.js`: `.allow(null, '')`). Пока модель требовала обе,
    /// один такой кролик ронял разбор всей страницы списка — вместе со
    /// «Стадом», выпадающими полями форм и подбором пар.
    @JsonKey(name: 'tag_id') String? tagId,
    String? name,
    @JsonKey(name: 'breed_id') @IntConverter() required int breedId,
    required String sex,
    @JsonKey(name: 'birth_date') @DateOnlyConverter() required DateTime birthDate,
    String? color,
    @JsonKey(name: 'cage_id') @NullableIntConverter() int? cageId,
    @JsonKey(name: 'father_id') @NullableIntConverter() int? fatherId,
    @JsonKey(name: 'mother_id') @NullableIntConverter() int? motherId,
    required String status,
    required String purpose,
    @JsonKey(name: 'acquired_date') @NullableDateOnlyConverter() DateTime? acquiredDate,
    @JsonKey(name: 'sold_date') @NullableDateOnlyConverter() DateTime? soldDate,
    @JsonKey(name: 'death_date') @NullableDateOnlyConverter() DateTime? deathDate,
    @JsonKey(name: 'death_reason') String? deathReason,
    @JsonKey(name: 'current_weight') double? currentWeight,
    String? temperament,
    String? notes,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'created_at') @DateTimeConverter() required DateTime createdAt,
    @JsonKey(name: 'updated_at') @DateTimeConverter() required DateTime updatedAt,
    // Relations
    @JsonKey(name: 'breed') BreedModel? breed,
    @JsonKey(name: 'Cage') CageInfo? cage,
    @JsonKey(name: 'father') RabbitRef? father,
    @JsonKey(name: 'mother') RabbitRef? mother,
  }) = _RabbitModel;

  const RabbitModel._();

  /// Чем назвать кролика в интерфейсе: кличка, иначе клеймо, иначе номер.
  /// Тот же порядок, что у [RabbitRef], — чтобы один кролик не назывался
  /// в списке иначе, чем в задаче или в книге доходов.
  String get label {
    final byName = name?.trim();
    if (byName != null && byName.isNotEmpty) return byName;
    final byTag = tagId?.trim();
    if (byTag != null && byTag.isNotEmpty) return byTag;
    return '#$id';
  }

  factory RabbitModel.fromJson(Map<String, dynamic> json) =>
      _$RabbitModelFromJson(json);
}

@freezed
abstract class CageInfo with _$CageInfo {
  const factory CageInfo({
    @IntConverter() required int id,
    required String number,
    String? type,
    String? location,
  }) = _CageInfo;

  factory CageInfo.fromJson(Map<String, dynamic> json) =>
      _$CageInfoFromJson(json);
}

/// Ссылка на кролика: id и то, чем его называют.
///
/// Раньше называлась `ParentInfo`, потому что первым её завели в родословной.
/// Форма же у неё не «родительская», а «краткая»: тем же тремя полями сервер
/// отдаёт кролика и в задачах, и в других списках, где полная карточка не
/// нужна. Имя по назначению, а не по месту первой прописки.
///
/// Имя и клеймо в базе необязательны, поэтому оба поля могут не приехать —
/// строку для показа собирает [label], чтобы каждый экран не выдумывал свою.
@freezed
abstract class RabbitRef with _$RabbitRef {
  const factory RabbitRef({
    @IntConverter() required int id,
    String? name,
    @JsonKey(name: 'tag_id') String? tagId,
  }) = _RabbitRef;

  const RabbitRef._();

  /// Чем назвать кролика в строке списка: имя, иначе клеймо, иначе номер.
  String get label {
    final byName = name?.trim();
    if (byName != null && byName.isNotEmpty) return byName;
    final byTag = tagId?.trim();
    if (byTag != null && byTag.isNotEmpty) return byTag;
    return '#$id';
  }

  factory RabbitRef.fromJson(Map<String, dynamic> json) =>
      _$RabbitRefFromJson(json);
}
