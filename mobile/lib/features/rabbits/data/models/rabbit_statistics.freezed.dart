// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rabbit_statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RabbitStatistics {

@IntConverter() int get total;@JsonKey(name: 'alive_count')@IntConverter() int get aliveCount;@JsonKey(name: 'male_count')@IntConverter() int get maleCount;@JsonKey(name: 'female_count')@IntConverter() int get femaleCount;@JsonKey(name: 'pregnant_count')@IntConverter() int get pregnantCount;@JsonKey(name: 'sick_count')@IntConverter() int get sickCount;@JsonKey(name: 'for_sale_count')@IntConverter() int get forSaleCount;@JsonKey(name: 'by_breed') List<BreedStats> get byBreed;@JsonKey(name: 'dead_count')@IntConverter() int get deadCount;
/// Create a copy of RabbitStatistics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RabbitStatisticsCopyWith<RabbitStatistics> get copyWith => _$RabbitStatisticsCopyWithImpl<RabbitStatistics>(this as RabbitStatistics, _$identity);

  /// Serializes this RabbitStatistics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RabbitStatistics;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RabbitStatistics&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.aliveCount, _this.aliveCount) || other.aliveCount == _this.aliveCount)&&(identical(other.maleCount, _this.maleCount) || other.maleCount == _this.maleCount)&&(identical(other.femaleCount, _this.femaleCount) || other.femaleCount == _this.femaleCount)&&(identical(other.pregnantCount, _this.pregnantCount) || other.pregnantCount == _this.pregnantCount)&&(identical(other.sickCount, _this.sickCount) || other.sickCount == _this.sickCount)&&(identical(other.forSaleCount, _this.forSaleCount) || other.forSaleCount == _this.forSaleCount)&&const DeepCollectionEquality().equals(other.byBreed, _this.byBreed)&&(identical(other.deadCount, _this.deadCount) || other.deadCount == _this.deadCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RabbitStatistics;
  return Object.hash(runtimeType,_this.total,_this.aliveCount,_this.maleCount,_this.femaleCount,_this.pregnantCount,_this.sickCount,_this.forSaleCount,const DeepCollectionEquality().hash(_this.byBreed),_this.deadCount);
}

@override
String toString() {
  final _this = this as RabbitStatistics;
  return 'RabbitStatistics(total: ${_this.total}, aliveCount: ${_this.aliveCount}, maleCount: ${_this.maleCount}, femaleCount: ${_this.femaleCount}, pregnantCount: ${_this.pregnantCount}, sickCount: ${_this.sickCount}, forSaleCount: ${_this.forSaleCount}, byBreed: ${_this.byBreed}, deadCount: ${_this.deadCount})';
}


}

/// @nodoc
abstract mixin class $RabbitStatisticsCopyWith<$Res>  {
  factory $RabbitStatisticsCopyWith(RabbitStatistics value, $Res Function(RabbitStatistics) _then) = _$RabbitStatisticsCopyWithImpl;
@useResult
$Res call({
@IntConverter() int total,@JsonKey(name: 'alive_count')@IntConverter() int aliveCount,@JsonKey(name: 'male_count')@IntConverter() int maleCount,@JsonKey(name: 'female_count')@IntConverter() int femaleCount,@JsonKey(name: 'pregnant_count')@IntConverter() int pregnantCount,@JsonKey(name: 'sick_count')@IntConverter() int sickCount,@JsonKey(name: 'for_sale_count')@IntConverter() int forSaleCount,@JsonKey(name: 'by_breed') List<BreedStats> byBreed,@JsonKey(name: 'dead_count')@IntConverter() int deadCount
});




}
/// @nodoc
class _$RabbitStatisticsCopyWithImpl<$Res>
    implements $RabbitStatisticsCopyWith<$Res> {
  _$RabbitStatisticsCopyWithImpl(this._self, this._then);

  final RabbitStatistics _self;
  final $Res Function(RabbitStatistics) _then;

/// Create a copy of RabbitStatistics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? aliveCount = null,Object? maleCount = null,Object? femaleCount = null,Object? pregnantCount = null,Object? sickCount = null,Object? forSaleCount = null,Object? byBreed = null,Object? deadCount = null,}) {
  return _then(RabbitStatistics(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,aliveCount: null == aliveCount ? _self.aliveCount : aliveCount // ignore: cast_nullable_to_non_nullable
as int,maleCount: null == maleCount ? _self.maleCount : maleCount // ignore: cast_nullable_to_non_nullable
as int,femaleCount: null == femaleCount ? _self.femaleCount : femaleCount // ignore: cast_nullable_to_non_nullable
as int,pregnantCount: null == pregnantCount ? _self.pregnantCount : pregnantCount // ignore: cast_nullable_to_non_nullable
as int,sickCount: null == sickCount ? _self.sickCount : sickCount // ignore: cast_nullable_to_non_nullable
as int,forSaleCount: null == forSaleCount ? _self.forSaleCount : forSaleCount // ignore: cast_nullable_to_non_nullable
as int,byBreed: null == byBreed ? _self.byBreed : byBreed // ignore: cast_nullable_to_non_nullable
as List<BreedStats>,deadCount: null == deadCount ? _self.deadCount : deadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RabbitStatistics].
extension RabbitStatisticsPatterns on RabbitStatistics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RabbitStatistics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RabbitStatistics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RabbitStatistics value)  $default,){
final _that = this;
switch (_that) {
case _RabbitStatistics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RabbitStatistics value)?  $default,){
final _that = this;
switch (_that) {
case _RabbitStatistics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int total, @JsonKey(name: 'alive_count')@IntConverter()  int aliveCount, @JsonKey(name: 'male_count')@IntConverter()  int maleCount, @JsonKey(name: 'female_count')@IntConverter()  int femaleCount, @JsonKey(name: 'pregnant_count')@IntConverter()  int pregnantCount, @JsonKey(name: 'sick_count')@IntConverter()  int sickCount, @JsonKey(name: 'for_sale_count')@IntConverter()  int forSaleCount, @JsonKey(name: 'by_breed')  List<BreedStats> byBreed, @JsonKey(name: 'dead_count')@IntConverter()  int deadCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RabbitStatistics() when $default != null:
return $default(_that.total,_that.aliveCount,_that.maleCount,_that.femaleCount,_that.pregnantCount,_that.sickCount,_that.forSaleCount,_that.byBreed,_that.deadCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int total, @JsonKey(name: 'alive_count')@IntConverter()  int aliveCount, @JsonKey(name: 'male_count')@IntConverter()  int maleCount, @JsonKey(name: 'female_count')@IntConverter()  int femaleCount, @JsonKey(name: 'pregnant_count')@IntConverter()  int pregnantCount, @JsonKey(name: 'sick_count')@IntConverter()  int sickCount, @JsonKey(name: 'for_sale_count')@IntConverter()  int forSaleCount, @JsonKey(name: 'by_breed')  List<BreedStats> byBreed, @JsonKey(name: 'dead_count')@IntConverter()  int deadCount)  $default,) {final _that = this;
switch (_that) {
case _RabbitStatistics():
return $default(_that.total,_that.aliveCount,_that.maleCount,_that.femaleCount,_that.pregnantCount,_that.sickCount,_that.forSaleCount,_that.byBreed,_that.deadCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int total, @JsonKey(name: 'alive_count')@IntConverter()  int aliveCount, @JsonKey(name: 'male_count')@IntConverter()  int maleCount, @JsonKey(name: 'female_count')@IntConverter()  int femaleCount, @JsonKey(name: 'pregnant_count')@IntConverter()  int pregnantCount, @JsonKey(name: 'sick_count')@IntConverter()  int sickCount, @JsonKey(name: 'for_sale_count')@IntConverter()  int forSaleCount, @JsonKey(name: 'by_breed')  List<BreedStats> byBreed, @JsonKey(name: 'dead_count')@IntConverter()  int deadCount)?  $default,) {final _that = this;
switch (_that) {
case _RabbitStatistics() when $default != null:
return $default(_that.total,_that.aliveCount,_that.maleCount,_that.femaleCount,_that.pregnantCount,_that.sickCount,_that.forSaleCount,_that.byBreed,_that.deadCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RabbitStatistics implements RabbitStatistics {
  const _RabbitStatistics({@IntConverter() this.total = 0, @JsonKey(name: 'alive_count')@IntConverter() this.aliveCount = 0, @JsonKey(name: 'male_count')@IntConverter() this.maleCount = 0, @JsonKey(name: 'female_count')@IntConverter() this.femaleCount = 0, @JsonKey(name: 'pregnant_count')@IntConverter() this.pregnantCount = 0, @JsonKey(name: 'sick_count')@IntConverter() this.sickCount = 0, @JsonKey(name: 'for_sale_count')@IntConverter() this.forSaleCount = 0, @JsonKey(name: 'by_breed')  List<BreedStats> byBreed = const [], @JsonKey(name: 'dead_count')@IntConverter() this.deadCount = 0}): _byBreed = byBreed;
  factory _RabbitStatistics.fromJson(Map<String, dynamic> json) => _$RabbitStatisticsFromJson(json);

@override@JsonKey()@IntConverter() final  int total;
@override@JsonKey(name: 'alive_count')@IntConverter() final  int aliveCount;
@override@JsonKey(name: 'male_count')@IntConverter() final  int maleCount;
@override@JsonKey(name: 'female_count')@IntConverter() final  int femaleCount;
@override@JsonKey(name: 'pregnant_count')@IntConverter() final  int pregnantCount;
@override@JsonKey(name: 'sick_count')@IntConverter() final  int sickCount;
@override@JsonKey(name: 'for_sale_count')@IntConverter() final  int forSaleCount;
 final  List<BreedStats> _byBreed;
@override@JsonKey(name: 'by_breed') List<BreedStats> get byBreed {
  if (_byBreed is EqualUnmodifiableListView) return _byBreed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_byBreed);
}

@override@JsonKey(name: 'dead_count')@IntConverter() final  int deadCount;

/// Create a copy of RabbitStatistics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RabbitStatisticsCopyWith<_RabbitStatistics> get copyWith => __$RabbitStatisticsCopyWithImpl<_RabbitStatistics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RabbitStatisticsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RabbitStatistics&&(identical(other.total, total) || other.total == total)&&(identical(other.aliveCount, aliveCount) || other.aliveCount == aliveCount)&&(identical(other.maleCount, maleCount) || other.maleCount == maleCount)&&(identical(other.femaleCount, femaleCount) || other.femaleCount == femaleCount)&&(identical(other.pregnantCount, pregnantCount) || other.pregnantCount == pregnantCount)&&(identical(other.sickCount, sickCount) || other.sickCount == sickCount)&&(identical(other.forSaleCount, forSaleCount) || other.forSaleCount == forSaleCount)&&const DeepCollectionEquality().equals(other.byBreed, _byBreed)&&(identical(other.deadCount, deadCount) || other.deadCount == deadCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,aliveCount,maleCount,femaleCount,pregnantCount,sickCount,forSaleCount,const DeepCollectionEquality().hash(_byBreed),deadCount);
}

@override
String toString() {
    return 'RabbitStatistics(total: $total, aliveCount: $aliveCount, maleCount: $maleCount, femaleCount: $femaleCount, pregnantCount: $pregnantCount, sickCount: $sickCount, forSaleCount: $forSaleCount, byBreed: $byBreed, deadCount: $deadCount)';
}


}

/// @nodoc
abstract mixin class _$RabbitStatisticsCopyWith<$Res> implements $RabbitStatisticsCopyWith<$Res> {
  factory _$RabbitStatisticsCopyWith(_RabbitStatistics value, $Res Function(_RabbitStatistics) _then) = __$RabbitStatisticsCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int total,@JsonKey(name: 'alive_count')@IntConverter() int aliveCount,@JsonKey(name: 'male_count')@IntConverter() int maleCount,@JsonKey(name: 'female_count')@IntConverter() int femaleCount,@JsonKey(name: 'pregnant_count')@IntConverter() int pregnantCount,@JsonKey(name: 'sick_count')@IntConverter() int sickCount,@JsonKey(name: 'for_sale_count')@IntConverter() int forSaleCount,@JsonKey(name: 'by_breed') List<BreedStats> byBreed,@JsonKey(name: 'dead_count')@IntConverter() int deadCount
});




}
/// @nodoc
class __$RabbitStatisticsCopyWithImpl<$Res>
    implements _$RabbitStatisticsCopyWith<$Res> {
  __$RabbitStatisticsCopyWithImpl(this._self, this._then);

  final _RabbitStatistics _self;
  final $Res Function(_RabbitStatistics) _then;

/// Create a copy of RabbitStatistics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? aliveCount = null,Object? maleCount = null,Object? femaleCount = null,Object? pregnantCount = null,Object? sickCount = null,Object? forSaleCount = null,Object? byBreed = null,Object? deadCount = null,}) {
  return _then(_RabbitStatistics(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,aliveCount: null == aliveCount ? _self.aliveCount : aliveCount // ignore: cast_nullable_to_non_nullable
as int,maleCount: null == maleCount ? _self.maleCount : maleCount // ignore: cast_nullable_to_non_nullable
as int,femaleCount: null == femaleCount ? _self.femaleCount : femaleCount // ignore: cast_nullable_to_non_nullable
as int,pregnantCount: null == pregnantCount ? _self.pregnantCount : pregnantCount // ignore: cast_nullable_to_non_nullable
as int,sickCount: null == sickCount ? _self.sickCount : sickCount // ignore: cast_nullable_to_non_nullable
as int,forSaleCount: null == forSaleCount ? _self.forSaleCount : forSaleCount // ignore: cast_nullable_to_non_nullable
as int,byBreed: null == byBreed ? _self._byBreed : byBreed // ignore: cast_nullable_to_non_nullable
as List<BreedStats>,deadCount: null == deadCount ? _self.deadCount : deadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BreedStats {

@JsonKey(name: 'breed_id')@IntConverter() int? get breedId;@JsonKey(name: 'breed_name') String? get breedName;@IntConverter() int get count;
/// Create a copy of BreedStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreedStatsCopyWith<BreedStats> get copyWith => _$BreedStatsCopyWithImpl<BreedStats>(this as BreedStats, _$identity);

  /// Serializes this BreedStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BreedStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BreedStats&&(identical(other.breedId, _this.breedId) || other.breedId == _this.breedId)&&(identical(other.breedName, _this.breedName) || other.breedName == _this.breedName)&&(identical(other.count, _this.count) || other.count == _this.count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BreedStats;
  return Object.hash(runtimeType,_this.breedId,_this.breedName,_this.count);
}

@override
String toString() {
  final _this = this as BreedStats;
  return 'BreedStats(breedId: ${_this.breedId}, breedName: ${_this.breedName}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $BreedStatsCopyWith<$Res>  {
  factory $BreedStatsCopyWith(BreedStats value, $Res Function(BreedStats) _then) = _$BreedStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'breed_id')@IntConverter() int? breedId,@JsonKey(name: 'breed_name') String? breedName,@IntConverter() int count
});




}
/// @nodoc
class _$BreedStatsCopyWithImpl<$Res>
    implements $BreedStatsCopyWith<$Res> {
  _$BreedStatsCopyWithImpl(this._self, this._then);

  final BreedStats _self;
  final $Res Function(BreedStats) _then;

/// Create a copy of BreedStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? breedId = freezed,Object? breedName = freezed,Object? count = null,}) {
  return _then(BreedStats(
breedId: freezed == breedId ? _self.breedId : breedId // ignore: cast_nullable_to_non_nullable
as int?,breedName: freezed == breedName ? _self.breedName : breedName // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BreedStats].
extension BreedStatsPatterns on BreedStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BreedStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BreedStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BreedStats value)  $default,){
final _that = this;
switch (_that) {
case _BreedStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BreedStats value)?  $default,){
final _that = this;
switch (_that) {
case _BreedStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'breed_id')@IntConverter()  int? breedId, @JsonKey(name: 'breed_name')  String? breedName, @IntConverter()  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BreedStats() when $default != null:
return $default(_that.breedId,_that.breedName,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'breed_id')@IntConverter()  int? breedId, @JsonKey(name: 'breed_name')  String? breedName, @IntConverter()  int count)  $default,) {final _that = this;
switch (_that) {
case _BreedStats():
return $default(_that.breedId,_that.breedName,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'breed_id')@IntConverter()  int? breedId, @JsonKey(name: 'breed_name')  String? breedName, @IntConverter()  int count)?  $default,) {final _that = this;
switch (_that) {
case _BreedStats() when $default != null:
return $default(_that.breedId,_that.breedName,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BreedStats implements BreedStats {
  const _BreedStats({@JsonKey(name: 'breed_id')@IntConverter() this.breedId, @JsonKey(name: 'breed_name') this.breedName, @IntConverter() this.count = 0});
  factory _BreedStats.fromJson(Map<String, dynamic> json) => _$BreedStatsFromJson(json);

@override@JsonKey(name: 'breed_id')@IntConverter() final  int? breedId;
@override@JsonKey(name: 'breed_name') final  String? breedName;
@override@JsonKey()@IntConverter() final  int count;

/// Create a copy of BreedStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreedStatsCopyWith<_BreedStats> get copyWith => __$BreedStatsCopyWithImpl<_BreedStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BreedStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BreedStats&&(identical(other.breedId, breedId) || other.breedId == breedId)&&(identical(other.breedName, breedName) || other.breedName == breedName)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,breedId,breedName,count);
}

@override
String toString() {
    return 'BreedStats(breedId: $breedId, breedName: $breedName, count: $count)';
}


}

/// @nodoc
abstract mixin class _$BreedStatsCopyWith<$Res> implements $BreedStatsCopyWith<$Res> {
  factory _$BreedStatsCopyWith(_BreedStats value, $Res Function(_BreedStats) _then) = __$BreedStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'breed_id')@IntConverter() int? breedId,@JsonKey(name: 'breed_name') String? breedName,@IntConverter() int count
});




}
/// @nodoc
class __$BreedStatsCopyWithImpl<$Res>
    implements _$BreedStatsCopyWith<$Res> {
  __$BreedStatsCopyWithImpl(this._self, this._then);

  final _BreedStats _self;
  final $Res Function(_BreedStats) _then;

/// Create a copy of BreedStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? breedId = freezed,Object? breedName = freezed,Object? count = null,}) {
  return _then(_BreedStats(
breedId: freezed == breedId ? _self.breedId : breedId // ignore: cast_nullable_to_non_nullable
as int?,breedName: freezed == breedName ? _self.breedName : breedName // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
