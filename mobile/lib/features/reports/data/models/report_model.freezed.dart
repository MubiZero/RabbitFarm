// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardReport {

 RabbitStats get rabbits; CageStats get cages; HealthStats get health;/// Деньги фермы приходят не всем: работнику сервер их не отдаёт вовсе.
/// Пусто здесь означает «не для этой роли», а не «на ферме ноль» — нули
/// читались бы как пустая касса.
 FinanceStats? get finance; TaskStats get tasks; InventoryStats get inventory; BreedingStats get breeding;/// Потребление фермы против пределов тарифа. Пусто у ферм без тарифа —
/// сервер в этом случае просто не присылает блок целиком.
@JsonKey(name: 'plan_usage') PlanUsage? get planUsage;
/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardReportCopyWith<DashboardReport> get copyWith => _$DashboardReportCopyWithImpl<DashboardReport>(this as DashboardReport, _$identity);

  /// Serializes this DashboardReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DashboardReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardReport&&(identical(other.rabbits, _this.rabbits) || other.rabbits == _this.rabbits)&&(identical(other.cages, _this.cages) || other.cages == _this.cages)&&(identical(other.health, _this.health) || other.health == _this.health)&&(identical(other.finance, _this.finance) || other.finance == _this.finance)&&(identical(other.tasks, _this.tasks) || other.tasks == _this.tasks)&&(identical(other.inventory, _this.inventory) || other.inventory == _this.inventory)&&(identical(other.breeding, _this.breeding) || other.breeding == _this.breeding)&&(identical(other.planUsage, _this.planUsage) || other.planUsage == _this.planUsage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DashboardReport;
  return Object.hash(runtimeType,_this.rabbits,_this.cages,_this.health,_this.finance,_this.tasks,_this.inventory,_this.breeding,_this.planUsage);
}

@override
String toString() {
  final _this = this as DashboardReport;
  return 'DashboardReport(rabbits: ${_this.rabbits}, cages: ${_this.cages}, health: ${_this.health}, finance: ${_this.finance}, tasks: ${_this.tasks}, inventory: ${_this.inventory}, breeding: ${_this.breeding}, planUsage: ${_this.planUsage})';
}


}

/// @nodoc
abstract mixin class $DashboardReportCopyWith<$Res>  {
  factory $DashboardReportCopyWith(DashboardReport value, $Res Function(DashboardReport) _then) = _$DashboardReportCopyWithImpl;
@useResult
$Res call({
 RabbitStats rabbits, CageStats cages, HealthStats health, FinanceStats? finance, TaskStats tasks, InventoryStats inventory, BreedingStats breeding,@JsonKey(name: 'plan_usage') PlanUsage? planUsage
});


$RabbitStatsCopyWith<$Res> get rabbits;$CageStatsCopyWith<$Res> get cages;$HealthStatsCopyWith<$Res> get health;$FinanceStatsCopyWith<$Res>? get finance;$TaskStatsCopyWith<$Res> get tasks;$InventoryStatsCopyWith<$Res> get inventory;$BreedingStatsCopyWith<$Res> get breeding;$PlanUsageCopyWith<$Res>? get planUsage;

}
/// @nodoc
class _$DashboardReportCopyWithImpl<$Res>
    implements $DashboardReportCopyWith<$Res> {
  _$DashboardReportCopyWithImpl(this._self, this._then);

  final DashboardReport _self;
  final $Res Function(DashboardReport) _then;

/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rabbits = null,Object? cages = null,Object? health = null,Object? finance = freezed,Object? tasks = null,Object? inventory = null,Object? breeding = null,Object? planUsage = freezed,}) {
  return _then(DashboardReport(
rabbits: null == rabbits ? _self.rabbits : rabbits // ignore: cast_nullable_to_non_nullable
as RabbitStats,cages: null == cages ? _self.cages : cages // ignore: cast_nullable_to_non_nullable
as CageStats,health: null == health ? _self.health : health // ignore: cast_nullable_to_non_nullable
as HealthStats,finance: freezed == finance ? _self.finance : finance // ignore: cast_nullable_to_non_nullable
as FinanceStats?,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as TaskStats,inventory: null == inventory ? _self.inventory : inventory // ignore: cast_nullable_to_non_nullable
as InventoryStats,breeding: null == breeding ? _self.breeding : breeding // ignore: cast_nullable_to_non_nullable
as BreedingStats,planUsage: freezed == planUsage ? _self.planUsage : planUsage // ignore: cast_nullable_to_non_nullable
as PlanUsage?,
  ));
}
/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RabbitStatsCopyWith<$Res> get rabbits {
  
  return $RabbitStatsCopyWith<$Res>(_self.rabbits, (value) {
    return _then(_self.copyWith(rabbits: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CageStatsCopyWith<$Res> get cages {
  
  return $CageStatsCopyWith<$Res>(_self.cages, (value) {
    return _then(_self.copyWith(cages: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HealthStatsCopyWith<$Res> get health {
  
  return $HealthStatsCopyWith<$Res>(_self.health, (value) {
    return _then(_self.copyWith(health: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FinanceStatsCopyWith<$Res>? get finance {
    if (_self.finance == null) {
    return null;
  }

  return $FinanceStatsCopyWith<$Res>(_self.finance!, (value) {
    return _then(_self.copyWith(finance: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskStatsCopyWith<$Res> get tasks {
  
  return $TaskStatsCopyWith<$Res>(_self.tasks, (value) {
    return _then(_self.copyWith(tasks: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryStatsCopyWith<$Res> get inventory {
  
  return $InventoryStatsCopyWith<$Res>(_self.inventory, (value) {
    return _then(_self.copyWith(inventory: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BreedingStatsCopyWith<$Res> get breeding {
  
  return $BreedingStatsCopyWith<$Res>(_self.breeding, (value) {
    return _then(_self.copyWith(breeding: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanUsageCopyWith<$Res>? get planUsage {
    if (_self.planUsage == null) {
    return null;
  }

  return $PlanUsageCopyWith<$Res>(_self.planUsage!, (value) {
    return _then(_self.copyWith(planUsage: value));
  });
}
}


/// Adds pattern-matching-related methods to [DashboardReport].
extension DashboardReportPatterns on DashboardReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardReport value)  $default,){
final _that = this;
switch (_that) {
case _DashboardReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardReport value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RabbitStats rabbits,  CageStats cages,  HealthStats health,  FinanceStats? finance,  TaskStats tasks,  InventoryStats inventory,  BreedingStats breeding, @JsonKey(name: 'plan_usage')  PlanUsage? planUsage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardReport() when $default != null:
return $default(_that.rabbits,_that.cages,_that.health,_that.finance,_that.tasks,_that.inventory,_that.breeding,_that.planUsage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RabbitStats rabbits,  CageStats cages,  HealthStats health,  FinanceStats? finance,  TaskStats tasks,  InventoryStats inventory,  BreedingStats breeding, @JsonKey(name: 'plan_usage')  PlanUsage? planUsage)  $default,) {final _that = this;
switch (_that) {
case _DashboardReport():
return $default(_that.rabbits,_that.cages,_that.health,_that.finance,_that.tasks,_that.inventory,_that.breeding,_that.planUsage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RabbitStats rabbits,  CageStats cages,  HealthStats health,  FinanceStats? finance,  TaskStats tasks,  InventoryStats inventory,  BreedingStats breeding, @JsonKey(name: 'plan_usage')  PlanUsage? planUsage)?  $default,) {final _that = this;
switch (_that) {
case _DashboardReport() when $default != null:
return $default(_that.rabbits,_that.cages,_that.health,_that.finance,_that.tasks,_that.inventory,_that.breeding,_that.planUsage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardReport implements DashboardReport {
  const _DashboardReport({required this.rabbits, required this.cages, required this.health, this.finance, required this.tasks, required this.inventory, required this.breeding, @JsonKey(name: 'plan_usage') this.planUsage});
  factory _DashboardReport.fromJson(Map<String, dynamic> json) => _$DashboardReportFromJson(json);

@override final  RabbitStats rabbits;
@override final  CageStats cages;
@override final  HealthStats health;
/// Деньги фермы приходят не всем: работнику сервер их не отдаёт вовсе.
/// Пусто здесь означает «не для этой роли», а не «на ферме ноль» — нули
/// читались бы как пустая касса.
@override final  FinanceStats? finance;
@override final  TaskStats tasks;
@override final  InventoryStats inventory;
@override final  BreedingStats breeding;
/// Потребление фермы против пределов тарифа. Пусто у ферм без тарифа —
/// сервер в этом случае просто не присылает блок целиком.
@override@JsonKey(name: 'plan_usage') final  PlanUsage? planUsage;

/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardReportCopyWith<_DashboardReport> get copyWith => __$DashboardReportCopyWithImpl<_DashboardReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardReportToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardReport&&(identical(other.rabbits, rabbits) || other.rabbits == rabbits)&&(identical(other.cages, cages) || other.cages == cages)&&(identical(other.health, health) || other.health == health)&&(identical(other.finance, finance) || other.finance == finance)&&(identical(other.tasks, tasks) || other.tasks == tasks)&&(identical(other.inventory, inventory) || other.inventory == inventory)&&(identical(other.breeding, breeding) || other.breeding == breeding)&&(identical(other.planUsage, planUsage) || other.planUsage == planUsage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,rabbits,cages,health,finance,tasks,inventory,breeding,planUsage);
}

@override
String toString() {
    return 'DashboardReport(rabbits: $rabbits, cages: $cages, health: $health, finance: $finance, tasks: $tasks, inventory: $inventory, breeding: $breeding, planUsage: $planUsage)';
}


}

/// @nodoc
abstract mixin class _$DashboardReportCopyWith<$Res> implements $DashboardReportCopyWith<$Res> {
  factory _$DashboardReportCopyWith(_DashboardReport value, $Res Function(_DashboardReport) _then) = __$DashboardReportCopyWithImpl;
@override @useResult
$Res call({
 RabbitStats rabbits, CageStats cages, HealthStats health, FinanceStats? finance, TaskStats tasks, InventoryStats inventory, BreedingStats breeding,@JsonKey(name: 'plan_usage') PlanUsage? planUsage
});


@override $RabbitStatsCopyWith<$Res> get rabbits;@override $CageStatsCopyWith<$Res> get cages;@override $HealthStatsCopyWith<$Res> get health;@override $FinanceStatsCopyWith<$Res>? get finance;@override $TaskStatsCopyWith<$Res> get tasks;@override $InventoryStatsCopyWith<$Res> get inventory;@override $BreedingStatsCopyWith<$Res> get breeding;@override $PlanUsageCopyWith<$Res>? get planUsage;

}
/// @nodoc
class __$DashboardReportCopyWithImpl<$Res>
    implements _$DashboardReportCopyWith<$Res> {
  __$DashboardReportCopyWithImpl(this._self, this._then);

  final _DashboardReport _self;
  final $Res Function(_DashboardReport) _then;

/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rabbits = null,Object? cages = null,Object? health = null,Object? finance = freezed,Object? tasks = null,Object? inventory = null,Object? breeding = null,Object? planUsage = freezed,}) {
  return _then(_DashboardReport(
rabbits: null == rabbits ? _self.rabbits : rabbits // ignore: cast_nullable_to_non_nullable
as RabbitStats,cages: null == cages ? _self.cages : cages // ignore: cast_nullable_to_non_nullable
as CageStats,health: null == health ? _self.health : health // ignore: cast_nullable_to_non_nullable
as HealthStats,finance: freezed == finance ? _self.finance : finance // ignore: cast_nullable_to_non_nullable
as FinanceStats?,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as TaskStats,inventory: null == inventory ? _self.inventory : inventory // ignore: cast_nullable_to_non_nullable
as InventoryStats,breeding: null == breeding ? _self.breeding : breeding // ignore: cast_nullable_to_non_nullable
as BreedingStats,planUsage: freezed == planUsage ? _self.planUsage : planUsage // ignore: cast_nullable_to_non_nullable
as PlanUsage?,
  ));
}

/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RabbitStatsCopyWith<$Res> get rabbits {
  
  return $RabbitStatsCopyWith<$Res>(_self.rabbits, (value) {
    return _then(_self.copyWith(rabbits: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CageStatsCopyWith<$Res> get cages {
  
  return $CageStatsCopyWith<$Res>(_self.cages, (value) {
    return _then(_self.copyWith(cages: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HealthStatsCopyWith<$Res> get health {
  
  return $HealthStatsCopyWith<$Res>(_self.health, (value) {
    return _then(_self.copyWith(health: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FinanceStatsCopyWith<$Res>? get finance {
    if (_self.finance == null) {
    return null;
  }

  return $FinanceStatsCopyWith<$Res>(_self.finance!, (value) {
    return _then(_self.copyWith(finance: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskStatsCopyWith<$Res> get tasks {
  
  return $TaskStatsCopyWith<$Res>(_self.tasks, (value) {
    return _then(_self.copyWith(tasks: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryStatsCopyWith<$Res> get inventory {
  
  return $InventoryStatsCopyWith<$Res>(_self.inventory, (value) {
    return _then(_self.copyWith(inventory: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BreedingStatsCopyWith<$Res> get breeding {
  
  return $BreedingStatsCopyWith<$Res>(_self.breeding, (value) {
    return _then(_self.copyWith(breeding: value));
  });
}/// Create a copy of DashboardReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanUsageCopyWith<$Res>? get planUsage {
    if (_self.planUsage == null) {
    return null;
  }

  return $PlanUsageCopyWith<$Res>(_self.planUsage!, (value) {
    return _then(_self.copyWith(planUsage: value));
  });
}
}


/// @nodoc
mixin _$PlanUsage {

 ResourceUsage get rabbits; ResourceUsage get staff;/// Сам тариф — название, цена продления, срок (см.
/// docs/plans/PLATFORM-ADMIN.md, 4.1). `null`, если ферме не назначен
/// тариф вовсе.
 PlanUsagePlan? get plan;
/// Create a copy of PlanUsage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanUsageCopyWith<PlanUsage> get copyWith => _$PlanUsageCopyWithImpl<PlanUsage>(this as PlanUsage, _$identity);

  /// Serializes this PlanUsage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlanUsage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanUsage&&(identical(other.rabbits, _this.rabbits) || other.rabbits == _this.rabbits)&&(identical(other.staff, _this.staff) || other.staff == _this.staff)&&(identical(other.plan, _this.plan) || other.plan == _this.plan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlanUsage;
  return Object.hash(runtimeType,_this.rabbits,_this.staff,_this.plan);
}

@override
String toString() {
  final _this = this as PlanUsage;
  return 'PlanUsage(rabbits: ${_this.rabbits}, staff: ${_this.staff}, plan: ${_this.plan})';
}


}

/// @nodoc
abstract mixin class $PlanUsageCopyWith<$Res>  {
  factory $PlanUsageCopyWith(PlanUsage value, $Res Function(PlanUsage) _then) = _$PlanUsageCopyWithImpl;
@useResult
$Res call({
 ResourceUsage rabbits, ResourceUsage staff, PlanUsagePlan? plan
});


$ResourceUsageCopyWith<$Res> get rabbits;$ResourceUsageCopyWith<$Res> get staff;$PlanUsagePlanCopyWith<$Res>? get plan;

}
/// @nodoc
class _$PlanUsageCopyWithImpl<$Res>
    implements $PlanUsageCopyWith<$Res> {
  _$PlanUsageCopyWithImpl(this._self, this._then);

  final PlanUsage _self;
  final $Res Function(PlanUsage) _then;

/// Create a copy of PlanUsage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rabbits = null,Object? staff = null,Object? plan = freezed,}) {
  return _then(PlanUsage(
rabbits: null == rabbits ? _self.rabbits : rabbits // ignore: cast_nullable_to_non_nullable
as ResourceUsage,staff: null == staff ? _self.staff : staff // ignore: cast_nullable_to_non_nullable
as ResourceUsage,plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as PlanUsagePlan?,
  ));
}
/// Create a copy of PlanUsage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResourceUsageCopyWith<$Res> get rabbits {
  
  return $ResourceUsageCopyWith<$Res>(_self.rabbits, (value) {
    return _then(_self.copyWith(rabbits: value));
  });
}/// Create a copy of PlanUsage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResourceUsageCopyWith<$Res> get staff {
  
  return $ResourceUsageCopyWith<$Res>(_self.staff, (value) {
    return _then(_self.copyWith(staff: value));
  });
}/// Create a copy of PlanUsage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanUsagePlanCopyWith<$Res>? get plan {
    if (_self.plan == null) {
    return null;
  }

  return $PlanUsagePlanCopyWith<$Res>(_self.plan!, (value) {
    return _then(_self.copyWith(plan: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlanUsage].
extension PlanUsagePatterns on PlanUsage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanUsage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanUsage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanUsage value)  $default,){
final _that = this;
switch (_that) {
case _PlanUsage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanUsage value)?  $default,){
final _that = this;
switch (_that) {
case _PlanUsage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ResourceUsage rabbits,  ResourceUsage staff,  PlanUsagePlan? plan)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlanUsage() when $default != null:
return $default(_that.rabbits,_that.staff,_that.plan);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ResourceUsage rabbits,  ResourceUsage staff,  PlanUsagePlan? plan)  $default,) {final _that = this;
switch (_that) {
case _PlanUsage():
return $default(_that.rabbits,_that.staff,_that.plan);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ResourceUsage rabbits,  ResourceUsage staff,  PlanUsagePlan? plan)?  $default,) {final _that = this;
switch (_that) {
case _PlanUsage() when $default != null:
return $default(_that.rabbits,_that.staff,_that.plan);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlanUsage implements PlanUsage {
  const _PlanUsage({required this.rabbits, required this.staff, this.plan});
  factory _PlanUsage.fromJson(Map<String, dynamic> json) => _$PlanUsageFromJson(json);

@override final  ResourceUsage rabbits;
@override final  ResourceUsage staff;
/// Сам тариф — название, цена продления, срок (см.
/// docs/plans/PLATFORM-ADMIN.md, 4.1). `null`, если ферме не назначен
/// тариф вовсе.
@override final  PlanUsagePlan? plan;

/// Create a copy of PlanUsage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanUsageCopyWith<_PlanUsage> get copyWith => __$PlanUsageCopyWithImpl<_PlanUsage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanUsageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanUsage&&(identical(other.rabbits, rabbits) || other.rabbits == rabbits)&&(identical(other.staff, staff) || other.staff == staff)&&(identical(other.plan, plan) || other.plan == plan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,rabbits,staff,plan);
}

@override
String toString() {
    return 'PlanUsage(rabbits: $rabbits, staff: $staff, plan: $plan)';
}


}

/// @nodoc
abstract mixin class _$PlanUsageCopyWith<$Res> implements $PlanUsageCopyWith<$Res> {
  factory _$PlanUsageCopyWith(_PlanUsage value, $Res Function(_PlanUsage) _then) = __$PlanUsageCopyWithImpl;
@override @useResult
$Res call({
 ResourceUsage rabbits, ResourceUsage staff, PlanUsagePlan? plan
});


@override $ResourceUsageCopyWith<$Res> get rabbits;@override $ResourceUsageCopyWith<$Res> get staff;@override $PlanUsagePlanCopyWith<$Res>? get plan;

}
/// @nodoc
class __$PlanUsageCopyWithImpl<$Res>
    implements _$PlanUsageCopyWith<$Res> {
  __$PlanUsageCopyWithImpl(this._self, this._then);

  final _PlanUsage _self;
  final $Res Function(_PlanUsage) _then;

/// Create a copy of PlanUsage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rabbits = null,Object? staff = null,Object? plan = freezed,}) {
  return _then(_PlanUsage(
rabbits: null == rabbits ? _self.rabbits : rabbits // ignore: cast_nullable_to_non_nullable
as ResourceUsage,staff: null == staff ? _self.staff : staff // ignore: cast_nullable_to_non_nullable
as ResourceUsage,plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as PlanUsagePlan?,
  ));
}

/// Create a copy of PlanUsage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResourceUsageCopyWith<$Res> get rabbits {
  
  return $ResourceUsageCopyWith<$Res>(_self.rabbits, (value) {
    return _then(_self.copyWith(rabbits: value));
  });
}/// Create a copy of PlanUsage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResourceUsageCopyWith<$Res> get staff {
  
  return $ResourceUsageCopyWith<$Res>(_self.staff, (value) {
    return _then(_self.copyWith(staff: value));
  });
}/// Create a copy of PlanUsage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanUsagePlanCopyWith<$Res>? get plan {
    if (_self.plan == null) {
    return null;
  }

  return $PlanUsagePlanCopyWith<$Res>(_self.plan!, (value) {
    return _then(_self.copyWith(plan: value));
  });
}
}


/// @nodoc
mixin _$PlanUsagePlan {

@IntConverter() int get id; String get name;@DoubleConverter() double? get price;@JsonKey(name: 'expires_at')@NullableDateTimeConverter() DateTime? get expiresAt;@JsonKey(name: 'is_expired') bool get isExpired;
/// Create a copy of PlanUsagePlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanUsagePlanCopyWith<PlanUsagePlan> get copyWith => _$PlanUsagePlanCopyWithImpl<PlanUsagePlan>(this as PlanUsagePlan, _$identity);

  /// Serializes this PlanUsagePlan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlanUsagePlan;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanUsagePlan&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.isExpired, _this.isExpired) || other.isExpired == _this.isExpired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlanUsagePlan;
  return Object.hash(runtimeType,_this.id,_this.name,_this.price,_this.expiresAt,_this.isExpired);
}

@override
String toString() {
  final _this = this as PlanUsagePlan;
  return 'PlanUsagePlan(id: ${_this.id}, name: ${_this.name}, price: ${_this.price}, expiresAt: ${_this.expiresAt}, isExpired: ${_this.isExpired})';
}


}

/// @nodoc
abstract mixin class $PlanUsagePlanCopyWith<$Res>  {
  factory $PlanUsagePlanCopyWith(PlanUsagePlan value, $Res Function(PlanUsagePlan) _then) = _$PlanUsagePlanCopyWithImpl;
@useResult
$Res call({
@IntConverter() int id, String name,@DoubleConverter() double? price,@JsonKey(name: 'expires_at')@NullableDateTimeConverter() DateTime? expiresAt,@JsonKey(name: 'is_expired') bool isExpired
});




}
/// @nodoc
class _$PlanUsagePlanCopyWithImpl<$Res>
    implements $PlanUsagePlanCopyWith<$Res> {
  _$PlanUsagePlanCopyWithImpl(this._self, this._then);

  final PlanUsagePlan _self;
  final $Res Function(PlanUsagePlan) _then;

/// Create a copy of PlanUsagePlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? price = freezed,Object? expiresAt = freezed,Object? isExpired = null,}) {
  return _then(PlanUsagePlan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isExpired: null == isExpired ? _self.isExpired : isExpired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PlanUsagePlan].
extension PlanUsagePlanPatterns on PlanUsagePlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanUsagePlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanUsagePlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanUsagePlan value)  $default,){
final _that = this;
switch (_that) {
case _PlanUsagePlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanUsagePlan value)?  $default,){
final _that = this;
switch (_that) {
case _PlanUsagePlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String name, @DoubleConverter()  double? price, @JsonKey(name: 'expires_at')@NullableDateTimeConverter()  DateTime? expiresAt, @JsonKey(name: 'is_expired')  bool isExpired)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlanUsagePlan() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.expiresAt,_that.isExpired);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int id,  String name, @DoubleConverter()  double? price, @JsonKey(name: 'expires_at')@NullableDateTimeConverter()  DateTime? expiresAt, @JsonKey(name: 'is_expired')  bool isExpired)  $default,) {final _that = this;
switch (_that) {
case _PlanUsagePlan():
return $default(_that.id,_that.name,_that.price,_that.expiresAt,_that.isExpired);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int id,  String name, @DoubleConverter()  double? price, @JsonKey(name: 'expires_at')@NullableDateTimeConverter()  DateTime? expiresAt, @JsonKey(name: 'is_expired')  bool isExpired)?  $default,) {final _that = this;
switch (_that) {
case _PlanUsagePlan() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.expiresAt,_that.isExpired);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlanUsagePlan implements PlanUsagePlan {
  const _PlanUsagePlan({@IntConverter() required this.id, required this.name, @DoubleConverter() this.price, @JsonKey(name: 'expires_at')@NullableDateTimeConverter() this.expiresAt, @JsonKey(name: 'is_expired') this.isExpired = false});
  factory _PlanUsagePlan.fromJson(Map<String, dynamic> json) => _$PlanUsagePlanFromJson(json);

@override@IntConverter() final  int id;
@override final  String name;
@override@DoubleConverter() final  double? price;
@override@JsonKey(name: 'expires_at')@NullableDateTimeConverter() final  DateTime? expiresAt;
@override@JsonKey(name: 'is_expired') final  bool isExpired;

/// Create a copy of PlanUsagePlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanUsagePlanCopyWith<_PlanUsagePlan> get copyWith => __$PlanUsagePlanCopyWithImpl<_PlanUsagePlan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanUsagePlanToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanUsagePlan&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.isExpired, isExpired) || other.isExpired == isExpired));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,price,expiresAt,isExpired);
}

@override
String toString() {
    return 'PlanUsagePlan(id: $id, name: $name, price: $price, expiresAt: $expiresAt, isExpired: $isExpired)';
}


}

/// @nodoc
abstract mixin class _$PlanUsagePlanCopyWith<$Res> implements $PlanUsagePlanCopyWith<$Res> {
  factory _$PlanUsagePlanCopyWith(_PlanUsagePlan value, $Res Function(_PlanUsagePlan) _then) = __$PlanUsagePlanCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int id, String name,@DoubleConverter() double? price,@JsonKey(name: 'expires_at')@NullableDateTimeConverter() DateTime? expiresAt,@JsonKey(name: 'is_expired') bool isExpired
});




}
/// @nodoc
class __$PlanUsagePlanCopyWithImpl<$Res>
    implements _$PlanUsagePlanCopyWith<$Res> {
  __$PlanUsagePlanCopyWithImpl(this._self, this._then);

  final _PlanUsagePlan _self;
  final $Res Function(_PlanUsagePlan) _then;

/// Create a copy of PlanUsagePlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? price = freezed,Object? expiresAt = freezed,Object? isExpired = null,}) {
  return _then(_PlanUsagePlan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isExpired: null == isExpired ? _self.isExpired : isExpired // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ResourceUsage {

@IntConverter() int get used;@NullableIntConverter() int? get limit;
/// Create a copy of ResourceUsage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResourceUsageCopyWith<ResourceUsage> get copyWith => _$ResourceUsageCopyWithImpl<ResourceUsage>(this as ResourceUsage, _$identity);

  /// Serializes this ResourceUsage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ResourceUsage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResourceUsage&&(identical(other.used, _this.used) || other.used == _this.used)&&(identical(other.limit, _this.limit) || other.limit == _this.limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ResourceUsage;
  return Object.hash(runtimeType,_this.used,_this.limit);
}

@override
String toString() {
  final _this = this as ResourceUsage;
  return 'ResourceUsage(used: ${_this.used}, limit: ${_this.limit})';
}


}

/// @nodoc
abstract mixin class $ResourceUsageCopyWith<$Res>  {
  factory $ResourceUsageCopyWith(ResourceUsage value, $Res Function(ResourceUsage) _then) = _$ResourceUsageCopyWithImpl;
@useResult
$Res call({
@IntConverter() int used,@NullableIntConverter() int? limit
});




}
/// @nodoc
class _$ResourceUsageCopyWithImpl<$Res>
    implements $ResourceUsageCopyWith<$Res> {
  _$ResourceUsageCopyWithImpl(this._self, this._then);

  final ResourceUsage _self;
  final $Res Function(ResourceUsage) _then;

/// Create a copy of ResourceUsage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? used = null,Object? limit = freezed,}) {
  return _then(ResourceUsage(
used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as int,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ResourceUsage].
extension ResourceUsagePatterns on ResourceUsage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResourceUsage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResourceUsage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResourceUsage value)  $default,){
final _that = this;
switch (_that) {
case _ResourceUsage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResourceUsage value)?  $default,){
final _that = this;
switch (_that) {
case _ResourceUsage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int used, @NullableIntConverter()  int? limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResourceUsage() when $default != null:
return $default(_that.used,_that.limit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int used, @NullableIntConverter()  int? limit)  $default,) {final _that = this;
switch (_that) {
case _ResourceUsage():
return $default(_that.used,_that.limit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int used, @NullableIntConverter()  int? limit)?  $default,) {final _that = this;
switch (_that) {
case _ResourceUsage() when $default != null:
return $default(_that.used,_that.limit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResourceUsage implements ResourceUsage {
  const _ResourceUsage({@IntConverter() required this.used, @NullableIntConverter() this.limit});
  factory _ResourceUsage.fromJson(Map<String, dynamic> json) => _$ResourceUsageFromJson(json);

@override@IntConverter() final  int used;
@override@NullableIntConverter() final  int? limit;

/// Create a copy of ResourceUsage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResourceUsageCopyWith<_ResourceUsage> get copyWith => __$ResourceUsageCopyWithImpl<_ResourceUsage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResourceUsageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResourceUsage&&(identical(other.used, used) || other.used == used)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,used,limit);
}

@override
String toString() {
    return 'ResourceUsage(used: $used, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$ResourceUsageCopyWith<$Res> implements $ResourceUsageCopyWith<$Res> {
  factory _$ResourceUsageCopyWith(_ResourceUsage value, $Res Function(_ResourceUsage) _then) = __$ResourceUsageCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int used,@NullableIntConverter() int? limit
});




}
/// @nodoc
class __$ResourceUsageCopyWithImpl<$Res>
    implements _$ResourceUsageCopyWith<$Res> {
  __$ResourceUsageCopyWithImpl(this._self, this._then);

  final _ResourceUsage _self;
  final $Res Function(_ResourceUsage) _then;

/// Create a copy of ResourceUsage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? used = null,Object? limit = freezed,}) {
  return _then(_ResourceUsage(
used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as int,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$RabbitStats {

@IntConverter() int get total;@IntConverter() int get male;@IntConverter() int get female; List<int> get history;
/// Create a copy of RabbitStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RabbitStatsCopyWith<RabbitStats> get copyWith => _$RabbitStatsCopyWithImpl<RabbitStats>(this as RabbitStats, _$identity);

  /// Serializes this RabbitStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RabbitStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RabbitStats&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.male, _this.male) || other.male == _this.male)&&(identical(other.female, _this.female) || other.female == _this.female)&&const DeepCollectionEquality().equals(other.history, _this.history));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RabbitStats;
  return Object.hash(runtimeType,_this.total,_this.male,_this.female,const DeepCollectionEquality().hash(_this.history));
}

@override
String toString() {
  final _this = this as RabbitStats;
  return 'RabbitStats(total: ${_this.total}, male: ${_this.male}, female: ${_this.female}, history: ${_this.history})';
}


}

/// @nodoc
abstract mixin class $RabbitStatsCopyWith<$Res>  {
  factory $RabbitStatsCopyWith(RabbitStats value, $Res Function(RabbitStats) _then) = _$RabbitStatsCopyWithImpl;
@useResult
$Res call({
@IntConverter() int total,@IntConverter() int male,@IntConverter() int female, List<int> history
});




}
/// @nodoc
class _$RabbitStatsCopyWithImpl<$Res>
    implements $RabbitStatsCopyWith<$Res> {
  _$RabbitStatsCopyWithImpl(this._self, this._then);

  final RabbitStats _self;
  final $Res Function(RabbitStats) _then;

/// Create a copy of RabbitStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? male = null,Object? female = null,Object? history = null,}) {
  return _then(RabbitStats(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,male: null == male ? _self.male : male // ignore: cast_nullable_to_non_nullable
as int,female: null == female ? _self.female : female // ignore: cast_nullable_to_non_nullable
as int,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [RabbitStats].
extension RabbitStatsPatterns on RabbitStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RabbitStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RabbitStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RabbitStats value)  $default,){
final _that = this;
switch (_that) {
case _RabbitStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RabbitStats value)?  $default,){
final _that = this;
switch (_that) {
case _RabbitStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int total, @IntConverter()  int male, @IntConverter()  int female,  List<int> history)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RabbitStats() when $default != null:
return $default(_that.total,_that.male,_that.female,_that.history);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int total, @IntConverter()  int male, @IntConverter()  int female,  List<int> history)  $default,) {final _that = this;
switch (_that) {
case _RabbitStats():
return $default(_that.total,_that.male,_that.female,_that.history);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int total, @IntConverter()  int male, @IntConverter()  int female,  List<int> history)?  $default,) {final _that = this;
switch (_that) {
case _RabbitStats() when $default != null:
return $default(_that.total,_that.male,_that.female,_that.history);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RabbitStats implements RabbitStats {
  const _RabbitStats({@IntConverter() required this.total, @IntConverter() required this.male, @IntConverter() required this.female,  List<int> history = const []}): _history = history;
  factory _RabbitStats.fromJson(Map<String, dynamic> json) => _$RabbitStatsFromJson(json);

@override@IntConverter() final  int total;
@override@IntConverter() final  int male;
@override@IntConverter() final  int female;
 final  List<int> _history;
@override@JsonKey() List<int> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}


/// Create a copy of RabbitStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RabbitStatsCopyWith<_RabbitStats> get copyWith => __$RabbitStatsCopyWithImpl<_RabbitStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RabbitStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RabbitStats&&(identical(other.total, total) || other.total == total)&&(identical(other.male, male) || other.male == male)&&(identical(other.female, female) || other.female == female)&&const DeepCollectionEquality().equals(other.history, _history));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,male,female,const DeepCollectionEquality().hash(_history));
}

@override
String toString() {
    return 'RabbitStats(total: $total, male: $male, female: $female, history: $history)';
}


}

/// @nodoc
abstract mixin class _$RabbitStatsCopyWith<$Res> implements $RabbitStatsCopyWith<$Res> {
  factory _$RabbitStatsCopyWith(_RabbitStats value, $Res Function(_RabbitStats) _then) = __$RabbitStatsCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int total,@IntConverter() int male,@IntConverter() int female, List<int> history
});




}
/// @nodoc
class __$RabbitStatsCopyWithImpl<$Res>
    implements _$RabbitStatsCopyWith<$Res> {
  __$RabbitStatsCopyWithImpl(this._self, this._then);

  final _RabbitStats _self;
  final $Res Function(_RabbitStats) _then;

/// Create a copy of RabbitStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? male = null,Object? female = null,Object? history = null,}) {
  return _then(_RabbitStats(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,male: null == male ? _self.male : male // ignore: cast_nullable_to_non_nullable
as int,female: null == female ? _self.female : female // ignore: cast_nullable_to_non_nullable
as int,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}


/// @nodoc
mixin _$CageStats {

@IntConverter() int get total;@IntConverter() int get occupied;@IntConverter() int get available;
/// Create a copy of CageStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CageStatsCopyWith<CageStats> get copyWith => _$CageStatsCopyWithImpl<CageStats>(this as CageStats, _$identity);

  /// Serializes this CageStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CageStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CageStats&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.occupied, _this.occupied) || other.occupied == _this.occupied)&&(identical(other.available, _this.available) || other.available == _this.available));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CageStats;
  return Object.hash(runtimeType,_this.total,_this.occupied,_this.available);
}

@override
String toString() {
  final _this = this as CageStats;
  return 'CageStats(total: ${_this.total}, occupied: ${_this.occupied}, available: ${_this.available})';
}


}

/// @nodoc
abstract mixin class $CageStatsCopyWith<$Res>  {
  factory $CageStatsCopyWith(CageStats value, $Res Function(CageStats) _then) = _$CageStatsCopyWithImpl;
@useResult
$Res call({
@IntConverter() int total,@IntConverter() int occupied,@IntConverter() int available
});




}
/// @nodoc
class _$CageStatsCopyWithImpl<$Res>
    implements $CageStatsCopyWith<$Res> {
  _$CageStatsCopyWithImpl(this._self, this._then);

  final CageStats _self;
  final $Res Function(CageStats) _then;

/// Create a copy of CageStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? occupied = null,Object? available = null,}) {
  return _then(CageStats(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,occupied: null == occupied ? _self.occupied : occupied // ignore: cast_nullable_to_non_nullable
as int,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CageStats].
extension CageStatsPatterns on CageStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CageStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CageStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CageStats value)  $default,){
final _that = this;
switch (_that) {
case _CageStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CageStats value)?  $default,){
final _that = this;
switch (_that) {
case _CageStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int total, @IntConverter()  int occupied, @IntConverter()  int available)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CageStats() when $default != null:
return $default(_that.total,_that.occupied,_that.available);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int total, @IntConverter()  int occupied, @IntConverter()  int available)  $default,) {final _that = this;
switch (_that) {
case _CageStats():
return $default(_that.total,_that.occupied,_that.available);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int total, @IntConverter()  int occupied, @IntConverter()  int available)?  $default,) {final _that = this;
switch (_that) {
case _CageStats() when $default != null:
return $default(_that.total,_that.occupied,_that.available);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CageStats implements CageStats {
  const _CageStats({@IntConverter() required this.total, @IntConverter() required this.occupied, @IntConverter() required this.available});
  factory _CageStats.fromJson(Map<String, dynamic> json) => _$CageStatsFromJson(json);

@override@IntConverter() final  int total;
@override@IntConverter() final  int occupied;
@override@IntConverter() final  int available;

/// Create a copy of CageStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CageStatsCopyWith<_CageStats> get copyWith => __$CageStatsCopyWithImpl<_CageStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CageStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CageStats&&(identical(other.total, total) || other.total == total)&&(identical(other.occupied, occupied) || other.occupied == occupied)&&(identical(other.available, available) || other.available == available));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,total,occupied,available);
}

@override
String toString() {
    return 'CageStats(total: $total, occupied: $occupied, available: $available)';
}


}

/// @nodoc
abstract mixin class _$CageStatsCopyWith<$Res> implements $CageStatsCopyWith<$Res> {
  factory _$CageStatsCopyWith(_CageStats value, $Res Function(_CageStats) _then) = __$CageStatsCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int total,@IntConverter() int occupied,@IntConverter() int available
});




}
/// @nodoc
class __$CageStatsCopyWithImpl<$Res>
    implements _$CageStatsCopyWith<$Res> {
  __$CageStatsCopyWithImpl(this._self, this._then);

  final _CageStats _self;
  final $Res Function(_CageStats) _then;

/// Create a copy of CageStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? occupied = null,Object? available = null,}) {
  return _then(_CageStats(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,occupied: null == occupied ? _self.occupied : occupied // ignore: cast_nullable_to_non_nullable
as int,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$HealthStats {

@IntConverter() int get upcomingVaccinations;@IntConverter() int get overdueVaccinations;
/// Create a copy of HealthStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthStatsCopyWith<HealthStats> get copyWith => _$HealthStatsCopyWithImpl<HealthStats>(this as HealthStats, _$identity);

  /// Serializes this HealthStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HealthStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthStats&&(identical(other.upcomingVaccinations, _this.upcomingVaccinations) || other.upcomingVaccinations == _this.upcomingVaccinations)&&(identical(other.overdueVaccinations, _this.overdueVaccinations) || other.overdueVaccinations == _this.overdueVaccinations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HealthStats;
  return Object.hash(runtimeType,_this.upcomingVaccinations,_this.overdueVaccinations);
}

@override
String toString() {
  final _this = this as HealthStats;
  return 'HealthStats(upcomingVaccinations: ${_this.upcomingVaccinations}, overdueVaccinations: ${_this.overdueVaccinations})';
}


}

/// @nodoc
abstract mixin class $HealthStatsCopyWith<$Res>  {
  factory $HealthStatsCopyWith(HealthStats value, $Res Function(HealthStats) _then) = _$HealthStatsCopyWithImpl;
@useResult
$Res call({
@IntConverter() int upcomingVaccinations,@IntConverter() int overdueVaccinations
});




}
/// @nodoc
class _$HealthStatsCopyWithImpl<$Res>
    implements $HealthStatsCopyWith<$Res> {
  _$HealthStatsCopyWithImpl(this._self, this._then);

  final HealthStats _self;
  final $Res Function(HealthStats) _then;

/// Create a copy of HealthStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? upcomingVaccinations = null,Object? overdueVaccinations = null,}) {
  return _then(HealthStats(
upcomingVaccinations: null == upcomingVaccinations ? _self.upcomingVaccinations : upcomingVaccinations // ignore: cast_nullable_to_non_nullable
as int,overdueVaccinations: null == overdueVaccinations ? _self.overdueVaccinations : overdueVaccinations // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthStats].
extension HealthStatsPatterns on HealthStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthStats value)  $default,){
final _that = this;
switch (_that) {
case _HealthStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthStats value)?  $default,){
final _that = this;
switch (_that) {
case _HealthStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int upcomingVaccinations, @IntConverter()  int overdueVaccinations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthStats() when $default != null:
return $default(_that.upcomingVaccinations,_that.overdueVaccinations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int upcomingVaccinations, @IntConverter()  int overdueVaccinations)  $default,) {final _that = this;
switch (_that) {
case _HealthStats():
return $default(_that.upcomingVaccinations,_that.overdueVaccinations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int upcomingVaccinations, @IntConverter()  int overdueVaccinations)?  $default,) {final _that = this;
switch (_that) {
case _HealthStats() when $default != null:
return $default(_that.upcomingVaccinations,_that.overdueVaccinations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthStats implements HealthStats {
  const _HealthStats({@IntConverter() required this.upcomingVaccinations, @IntConverter() required this.overdueVaccinations});
  factory _HealthStats.fromJson(Map<String, dynamic> json) => _$HealthStatsFromJson(json);

@override@IntConverter() final  int upcomingVaccinations;
@override@IntConverter() final  int overdueVaccinations;

/// Create a copy of HealthStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthStatsCopyWith<_HealthStats> get copyWith => __$HealthStatsCopyWithImpl<_HealthStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthStats&&(identical(other.upcomingVaccinations, upcomingVaccinations) || other.upcomingVaccinations == upcomingVaccinations)&&(identical(other.overdueVaccinations, overdueVaccinations) || other.overdueVaccinations == overdueVaccinations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,upcomingVaccinations,overdueVaccinations);
}

@override
String toString() {
    return 'HealthStats(upcomingVaccinations: $upcomingVaccinations, overdueVaccinations: $overdueVaccinations)';
}


}

/// @nodoc
abstract mixin class _$HealthStatsCopyWith<$Res> implements $HealthStatsCopyWith<$Res> {
  factory _$HealthStatsCopyWith(_HealthStats value, $Res Function(_HealthStats) _then) = __$HealthStatsCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int upcomingVaccinations,@IntConverter() int overdueVaccinations
});




}
/// @nodoc
class __$HealthStatsCopyWithImpl<$Res>
    implements _$HealthStatsCopyWith<$Res> {
  __$HealthStatsCopyWithImpl(this._self, this._then);

  final _HealthStats _self;
  final $Res Function(_HealthStats) _then;

/// Create a copy of HealthStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? upcomingVaccinations = null,Object? overdueVaccinations = null,}) {
  return _then(_HealthStats(
upcomingVaccinations: null == upcomingVaccinations ? _self.upcomingVaccinations : upcomingVaccinations // ignore: cast_nullable_to_non_nullable
as int,overdueVaccinations: null == overdueVaccinations ? _self.overdueVaccinations : overdueVaccinations // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$FinanceStats {

@DoubleConverter() double get income30days;@DoubleConverter() double get expenses30days;@DoubleConverter() double get profit30days;
/// Create a copy of FinanceStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinanceStatsCopyWith<FinanceStats> get copyWith => _$FinanceStatsCopyWithImpl<FinanceStats>(this as FinanceStats, _$identity);

  /// Serializes this FinanceStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FinanceStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinanceStats&&(identical(other.income30days, _this.income30days) || other.income30days == _this.income30days)&&(identical(other.expenses30days, _this.expenses30days) || other.expenses30days == _this.expenses30days)&&(identical(other.profit30days, _this.profit30days) || other.profit30days == _this.profit30days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FinanceStats;
  return Object.hash(runtimeType,_this.income30days,_this.expenses30days,_this.profit30days);
}

@override
String toString() {
  final _this = this as FinanceStats;
  return 'FinanceStats(income30days: ${_this.income30days}, expenses30days: ${_this.expenses30days}, profit30days: ${_this.profit30days})';
}


}

/// @nodoc
abstract mixin class $FinanceStatsCopyWith<$Res>  {
  factory $FinanceStatsCopyWith(FinanceStats value, $Res Function(FinanceStats) _then) = _$FinanceStatsCopyWithImpl;
@useResult
$Res call({
@DoubleConverter() double income30days,@DoubleConverter() double expenses30days,@DoubleConverter() double profit30days
});




}
/// @nodoc
class _$FinanceStatsCopyWithImpl<$Res>
    implements $FinanceStatsCopyWith<$Res> {
  _$FinanceStatsCopyWithImpl(this._self, this._then);

  final FinanceStats _self;
  final $Res Function(FinanceStats) _then;

/// Create a copy of FinanceStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? income30days = null,Object? expenses30days = null,Object? profit30days = null,}) {
  return _then(FinanceStats(
income30days: null == income30days ? _self.income30days : income30days // ignore: cast_nullable_to_non_nullable
as double,expenses30days: null == expenses30days ? _self.expenses30days : expenses30days // ignore: cast_nullable_to_non_nullable
as double,profit30days: null == profit30days ? _self.profit30days : profit30days // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FinanceStats].
extension FinanceStatsPatterns on FinanceStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinanceStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinanceStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinanceStats value)  $default,){
final _that = this;
switch (_that) {
case _FinanceStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinanceStats value)?  $default,){
final _that = this;
switch (_that) {
case _FinanceStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DoubleConverter()  double income30days, @DoubleConverter()  double expenses30days, @DoubleConverter()  double profit30days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinanceStats() when $default != null:
return $default(_that.income30days,_that.expenses30days,_that.profit30days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DoubleConverter()  double income30days, @DoubleConverter()  double expenses30days, @DoubleConverter()  double profit30days)  $default,) {final _that = this;
switch (_that) {
case _FinanceStats():
return $default(_that.income30days,_that.expenses30days,_that.profit30days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DoubleConverter()  double income30days, @DoubleConverter()  double expenses30days, @DoubleConverter()  double profit30days)?  $default,) {final _that = this;
switch (_that) {
case _FinanceStats() when $default != null:
return $default(_that.income30days,_that.expenses30days,_that.profit30days);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinanceStats implements FinanceStats {
  const _FinanceStats({@DoubleConverter() required this.income30days, @DoubleConverter() required this.expenses30days, @DoubleConverter() required this.profit30days});
  factory _FinanceStats.fromJson(Map<String, dynamic> json) => _$FinanceStatsFromJson(json);

@override@DoubleConverter() final  double income30days;
@override@DoubleConverter() final  double expenses30days;
@override@DoubleConverter() final  double profit30days;

/// Create a copy of FinanceStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinanceStatsCopyWith<_FinanceStats> get copyWith => __$FinanceStatsCopyWithImpl<_FinanceStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinanceStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinanceStats&&(identical(other.income30days, income30days) || other.income30days == income30days)&&(identical(other.expenses30days, expenses30days) || other.expenses30days == expenses30days)&&(identical(other.profit30days, profit30days) || other.profit30days == profit30days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,income30days,expenses30days,profit30days);
}

@override
String toString() {
    return 'FinanceStats(income30days: $income30days, expenses30days: $expenses30days, profit30days: $profit30days)';
}


}

/// @nodoc
abstract mixin class _$FinanceStatsCopyWith<$Res> implements $FinanceStatsCopyWith<$Res> {
  factory _$FinanceStatsCopyWith(_FinanceStats value, $Res Function(_FinanceStats) _then) = __$FinanceStatsCopyWithImpl;
@override @useResult
$Res call({
@DoubleConverter() double income30days,@DoubleConverter() double expenses30days,@DoubleConverter() double profit30days
});




}
/// @nodoc
class __$FinanceStatsCopyWithImpl<$Res>
    implements _$FinanceStatsCopyWith<$Res> {
  __$FinanceStatsCopyWithImpl(this._self, this._then);

  final _FinanceStats _self;
  final $Res Function(_FinanceStats) _then;

/// Create a copy of FinanceStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? income30days = null,Object? expenses30days = null,Object? profit30days = null,}) {
  return _then(_FinanceStats(
income30days: null == income30days ? _self.income30days : income30days // ignore: cast_nullable_to_non_nullable
as double,expenses30days: null == expenses30days ? _self.expenses30days : expenses30days // ignore: cast_nullable_to_non_nullable
as double,profit30days: null == profit30days ? _self.profit30days : profit30days // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$TaskStats {

@IntConverter() int get pending;@IntConverter() int get overdue;@IntConverter() int get urgent;
/// Create a copy of TaskStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskStatsCopyWith<TaskStats> get copyWith => _$TaskStatsCopyWithImpl<TaskStats>(this as TaskStats, _$identity);

  /// Serializes this TaskStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TaskStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskStats&&(identical(other.pending, _this.pending) || other.pending == _this.pending)&&(identical(other.overdue, _this.overdue) || other.overdue == _this.overdue)&&(identical(other.urgent, _this.urgent) || other.urgent == _this.urgent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TaskStats;
  return Object.hash(runtimeType,_this.pending,_this.overdue,_this.urgent);
}

@override
String toString() {
  final _this = this as TaskStats;
  return 'TaskStats(pending: ${_this.pending}, overdue: ${_this.overdue}, urgent: ${_this.urgent})';
}


}

/// @nodoc
abstract mixin class $TaskStatsCopyWith<$Res>  {
  factory $TaskStatsCopyWith(TaskStats value, $Res Function(TaskStats) _then) = _$TaskStatsCopyWithImpl;
@useResult
$Res call({
@IntConverter() int pending,@IntConverter() int overdue,@IntConverter() int urgent
});




}
/// @nodoc
class _$TaskStatsCopyWithImpl<$Res>
    implements $TaskStatsCopyWith<$Res> {
  _$TaskStatsCopyWithImpl(this._self, this._then);

  final TaskStats _self;
  final $Res Function(TaskStats) _then;

/// Create a copy of TaskStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pending = null,Object? overdue = null,Object? urgent = null,}) {
  return _then(TaskStats(
pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as int,urgent: null == urgent ? _self.urgent : urgent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskStats].
extension TaskStatsPatterns on TaskStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskStats value)  $default,){
final _that = this;
switch (_that) {
case _TaskStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskStats value)?  $default,){
final _that = this;
switch (_that) {
case _TaskStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int pending, @IntConverter()  int overdue, @IntConverter()  int urgent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskStats() when $default != null:
return $default(_that.pending,_that.overdue,_that.urgent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int pending, @IntConverter()  int overdue, @IntConverter()  int urgent)  $default,) {final _that = this;
switch (_that) {
case _TaskStats():
return $default(_that.pending,_that.overdue,_that.urgent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int pending, @IntConverter()  int overdue, @IntConverter()  int urgent)?  $default,) {final _that = this;
switch (_that) {
case _TaskStats() when $default != null:
return $default(_that.pending,_that.overdue,_that.urgent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskStats implements TaskStats {
  const _TaskStats({@IntConverter() required this.pending, @IntConverter() required this.overdue, @IntConverter() required this.urgent});
  factory _TaskStats.fromJson(Map<String, dynamic> json) => _$TaskStatsFromJson(json);

@override@IntConverter() final  int pending;
@override@IntConverter() final  int overdue;
@override@IntConverter() final  int urgent;

/// Create a copy of TaskStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskStatsCopyWith<_TaskStats> get copyWith => __$TaskStatsCopyWithImpl<_TaskStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskStats&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.overdue, overdue) || other.overdue == overdue)&&(identical(other.urgent, urgent) || other.urgent == urgent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,pending,overdue,urgent);
}

@override
String toString() {
    return 'TaskStats(pending: $pending, overdue: $overdue, urgent: $urgent)';
}


}

/// @nodoc
abstract mixin class _$TaskStatsCopyWith<$Res> implements $TaskStatsCopyWith<$Res> {
  factory _$TaskStatsCopyWith(_TaskStats value, $Res Function(_TaskStats) _then) = __$TaskStatsCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int pending,@IntConverter() int overdue,@IntConverter() int urgent
});




}
/// @nodoc
class __$TaskStatsCopyWithImpl<$Res>
    implements _$TaskStatsCopyWith<$Res> {
  __$TaskStatsCopyWithImpl(this._self, this._then);

  final _TaskStats _self;
  final $Res Function(_TaskStats) _then;

/// Create a copy of TaskStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pending = null,Object? overdue = null,Object? urgent = null,}) {
  return _then(_TaskStats(
pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as int,urgent: null == urgent ? _self.urgent : urgent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$InventoryStats {

@IntConverter() int get lowStockFeeds;
/// Create a copy of InventoryStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryStatsCopyWith<InventoryStats> get copyWith => _$InventoryStatsCopyWithImpl<InventoryStats>(this as InventoryStats, _$identity);

  /// Serializes this InventoryStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InventoryStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryStats&&(identical(other.lowStockFeeds, _this.lowStockFeeds) || other.lowStockFeeds == _this.lowStockFeeds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InventoryStats;
  return Object.hash(runtimeType,_this.lowStockFeeds);
}

@override
String toString() {
  final _this = this as InventoryStats;
  return 'InventoryStats(lowStockFeeds: ${_this.lowStockFeeds})';
}


}

/// @nodoc
abstract mixin class $InventoryStatsCopyWith<$Res>  {
  factory $InventoryStatsCopyWith(InventoryStats value, $Res Function(InventoryStats) _then) = _$InventoryStatsCopyWithImpl;
@useResult
$Res call({
@IntConverter() int lowStockFeeds
});




}
/// @nodoc
class _$InventoryStatsCopyWithImpl<$Res>
    implements $InventoryStatsCopyWith<$Res> {
  _$InventoryStatsCopyWithImpl(this._self, this._then);

  final InventoryStats _self;
  final $Res Function(InventoryStats) _then;

/// Create a copy of InventoryStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lowStockFeeds = null,}) {
  return _then(InventoryStats(
lowStockFeeds: null == lowStockFeeds ? _self.lowStockFeeds : lowStockFeeds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryStats].
extension InventoryStatsPatterns on InventoryStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryStats value)  $default,){
final _that = this;
switch (_that) {
case _InventoryStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryStats value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int lowStockFeeds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryStats() when $default != null:
return $default(_that.lowStockFeeds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int lowStockFeeds)  $default,) {final _that = this;
switch (_that) {
case _InventoryStats():
return $default(_that.lowStockFeeds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int lowStockFeeds)?  $default,) {final _that = this;
switch (_that) {
case _InventoryStats() when $default != null:
return $default(_that.lowStockFeeds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryStats implements InventoryStats {
  const _InventoryStats({@IntConverter() required this.lowStockFeeds});
  factory _InventoryStats.fromJson(Map<String, dynamic> json) => _$InventoryStatsFromJson(json);

@override@IntConverter() final  int lowStockFeeds;

/// Create a copy of InventoryStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryStatsCopyWith<_InventoryStats> get copyWith => __$InventoryStatsCopyWithImpl<_InventoryStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryStats&&(identical(other.lowStockFeeds, lowStockFeeds) || other.lowStockFeeds == lowStockFeeds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,lowStockFeeds);
}

@override
String toString() {
    return 'InventoryStats(lowStockFeeds: $lowStockFeeds)';
}


}

/// @nodoc
abstract mixin class _$InventoryStatsCopyWith<$Res> implements $InventoryStatsCopyWith<$Res> {
  factory _$InventoryStatsCopyWith(_InventoryStats value, $Res Function(_InventoryStats) _then) = __$InventoryStatsCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int lowStockFeeds
});




}
/// @nodoc
class __$InventoryStatsCopyWithImpl<$Res>
    implements _$InventoryStatsCopyWith<$Res> {
  __$InventoryStatsCopyWithImpl(this._self, this._then);

  final _InventoryStats _self;
  final $Res Function(_InventoryStats) _then;

/// Create a copy of InventoryStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lowStockFeeds = null,}) {
  return _then(_InventoryStats(
lowStockFeeds: null == lowStockFeeds ? _self.lowStockFeeds : lowStockFeeds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BreedingStats {

@IntConverter() int get recentBirths; List<int> get history;
/// Create a copy of BreedingStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreedingStatsCopyWith<BreedingStats> get copyWith => _$BreedingStatsCopyWithImpl<BreedingStats>(this as BreedingStats, _$identity);

  /// Serializes this BreedingStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BreedingStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BreedingStats&&(identical(other.recentBirths, _this.recentBirths) || other.recentBirths == _this.recentBirths)&&const DeepCollectionEquality().equals(other.history, _this.history));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BreedingStats;
  return Object.hash(runtimeType,_this.recentBirths,const DeepCollectionEquality().hash(_this.history));
}

@override
String toString() {
  final _this = this as BreedingStats;
  return 'BreedingStats(recentBirths: ${_this.recentBirths}, history: ${_this.history})';
}


}

/// @nodoc
abstract mixin class $BreedingStatsCopyWith<$Res>  {
  factory $BreedingStatsCopyWith(BreedingStats value, $Res Function(BreedingStats) _then) = _$BreedingStatsCopyWithImpl;
@useResult
$Res call({
@IntConverter() int recentBirths, List<int> history
});




}
/// @nodoc
class _$BreedingStatsCopyWithImpl<$Res>
    implements $BreedingStatsCopyWith<$Res> {
  _$BreedingStatsCopyWithImpl(this._self, this._then);

  final BreedingStats _self;
  final $Res Function(BreedingStats) _then;

/// Create a copy of BreedingStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recentBirths = null,Object? history = null,}) {
  return _then(BreedingStats(
recentBirths: null == recentBirths ? _self.recentBirths : recentBirths // ignore: cast_nullable_to_non_nullable
as int,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [BreedingStats].
extension BreedingStatsPatterns on BreedingStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BreedingStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BreedingStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BreedingStats value)  $default,){
final _that = this;
switch (_that) {
case _BreedingStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BreedingStats value)?  $default,){
final _that = this;
switch (_that) {
case _BreedingStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int recentBirths,  List<int> history)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BreedingStats() when $default != null:
return $default(_that.recentBirths,_that.history);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int recentBirths,  List<int> history)  $default,) {final _that = this;
switch (_that) {
case _BreedingStats():
return $default(_that.recentBirths,_that.history);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int recentBirths,  List<int> history)?  $default,) {final _that = this;
switch (_that) {
case _BreedingStats() when $default != null:
return $default(_that.recentBirths,_that.history);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BreedingStats implements BreedingStats {
  const _BreedingStats({@IntConverter() required this.recentBirths,  List<int> history = const []}): _history = history;
  factory _BreedingStats.fromJson(Map<String, dynamic> json) => _$BreedingStatsFromJson(json);

@override@IntConverter() final  int recentBirths;
 final  List<int> _history;
@override@JsonKey() List<int> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}


/// Create a copy of BreedingStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreedingStatsCopyWith<_BreedingStats> get copyWith => __$BreedingStatsCopyWithImpl<_BreedingStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BreedingStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BreedingStats&&(identical(other.recentBirths, recentBirths) || other.recentBirths == recentBirths)&&const DeepCollectionEquality().equals(other.history, _history));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,recentBirths,const DeepCollectionEquality().hash(_history));
}

@override
String toString() {
    return 'BreedingStats(recentBirths: $recentBirths, history: $history)';
}


}

/// @nodoc
abstract mixin class _$BreedingStatsCopyWith<$Res> implements $BreedingStatsCopyWith<$Res> {
  factory _$BreedingStatsCopyWith(_BreedingStats value, $Res Function(_BreedingStats) _then) = __$BreedingStatsCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int recentBirths, List<int> history
});




}
/// @nodoc
class __$BreedingStatsCopyWithImpl<$Res>
    implements _$BreedingStatsCopyWith<$Res> {
  __$BreedingStatsCopyWithImpl(this._self, this._then);

  final _BreedingStats _self;
  final $Res Function(_BreedingStats) _then;

/// Create a copy of BreedingStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recentBirths = null,Object? history = null,}) {
  return _then(_BreedingStats(
recentBirths: null == recentBirths ? _self.recentBirths : recentBirths // ignore: cast_nullable_to_non_nullable
as int,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}


/// @nodoc
mixin _$FarmReport {

 ReportPeriod get period; PopulationData get population;/// Как и в сводке «Сегодня»: работнику денежный блок не приходит.
 FinancialData? get financial; HealthData get health; BreedingData get breeding; FeedingData get feeding;
/// Create a copy of FarmReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FarmReportCopyWith<FarmReport> get copyWith => _$FarmReportCopyWithImpl<FarmReport>(this as FarmReport, _$identity);

  /// Serializes this FarmReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FarmReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FarmReport&&(identical(other.period, _this.period) || other.period == _this.period)&&(identical(other.population, _this.population) || other.population == _this.population)&&(identical(other.financial, _this.financial) || other.financial == _this.financial)&&(identical(other.health, _this.health) || other.health == _this.health)&&(identical(other.breeding, _this.breeding) || other.breeding == _this.breeding)&&(identical(other.feeding, _this.feeding) || other.feeding == _this.feeding));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FarmReport;
  return Object.hash(runtimeType,_this.period,_this.population,_this.financial,_this.health,_this.breeding,_this.feeding);
}

@override
String toString() {
  final _this = this as FarmReport;
  return 'FarmReport(period: ${_this.period}, population: ${_this.population}, financial: ${_this.financial}, health: ${_this.health}, breeding: ${_this.breeding}, feeding: ${_this.feeding})';
}


}

/// @nodoc
abstract mixin class $FarmReportCopyWith<$Res>  {
  factory $FarmReportCopyWith(FarmReport value, $Res Function(FarmReport) _then) = _$FarmReportCopyWithImpl;
@useResult
$Res call({
 ReportPeriod period, PopulationData population, FinancialData? financial, HealthData health, BreedingData breeding, FeedingData feeding
});


$ReportPeriodCopyWith<$Res> get period;$PopulationDataCopyWith<$Res> get population;$FinancialDataCopyWith<$Res>? get financial;$HealthDataCopyWith<$Res> get health;$BreedingDataCopyWith<$Res> get breeding;$FeedingDataCopyWith<$Res> get feeding;

}
/// @nodoc
class _$FarmReportCopyWithImpl<$Res>
    implements $FarmReportCopyWith<$Res> {
  _$FarmReportCopyWithImpl(this._self, this._then);

  final FarmReport _self;
  final $Res Function(FarmReport) _then;

/// Create a copy of FarmReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? period = null,Object? population = null,Object? financial = freezed,Object? health = null,Object? breeding = null,Object? feeding = null,}) {
  return _then(FarmReport(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as ReportPeriod,population: null == population ? _self.population : population // ignore: cast_nullable_to_non_nullable
as PopulationData,financial: freezed == financial ? _self.financial : financial // ignore: cast_nullable_to_non_nullable
as FinancialData?,health: null == health ? _self.health : health // ignore: cast_nullable_to_non_nullable
as HealthData,breeding: null == breeding ? _self.breeding : breeding // ignore: cast_nullable_to_non_nullable
as BreedingData,feeding: null == feeding ? _self.feeding : feeding // ignore: cast_nullable_to_non_nullable
as FeedingData,
  ));
}
/// Create a copy of FarmReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportPeriodCopyWith<$Res> get period {
  
  return $ReportPeriodCopyWith<$Res>(_self.period, (value) {
    return _then(_self.copyWith(period: value));
  });
}/// Create a copy of FarmReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PopulationDataCopyWith<$Res> get population {
  
  return $PopulationDataCopyWith<$Res>(_self.population, (value) {
    return _then(_self.copyWith(population: value));
  });
}/// Create a copy of FarmReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FinancialDataCopyWith<$Res>? get financial {
    if (_self.financial == null) {
    return null;
  }

  return $FinancialDataCopyWith<$Res>(_self.financial!, (value) {
    return _then(_self.copyWith(financial: value));
  });
}/// Create a copy of FarmReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HealthDataCopyWith<$Res> get health {
  
  return $HealthDataCopyWith<$Res>(_self.health, (value) {
    return _then(_self.copyWith(health: value));
  });
}/// Create a copy of FarmReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BreedingDataCopyWith<$Res> get breeding {
  
  return $BreedingDataCopyWith<$Res>(_self.breeding, (value) {
    return _then(_self.copyWith(breeding: value));
  });
}/// Create a copy of FarmReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedingDataCopyWith<$Res> get feeding {
  
  return $FeedingDataCopyWith<$Res>(_self.feeding, (value) {
    return _then(_self.copyWith(feeding: value));
  });
}
}


/// Adds pattern-matching-related methods to [FarmReport].
extension FarmReportPatterns on FarmReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FarmReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FarmReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FarmReport value)  $default,){
final _that = this;
switch (_that) {
case _FarmReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FarmReport value)?  $default,){
final _that = this;
switch (_that) {
case _FarmReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReportPeriod period,  PopulationData population,  FinancialData? financial,  HealthData health,  BreedingData breeding,  FeedingData feeding)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FarmReport() when $default != null:
return $default(_that.period,_that.population,_that.financial,_that.health,_that.breeding,_that.feeding);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReportPeriod period,  PopulationData population,  FinancialData? financial,  HealthData health,  BreedingData breeding,  FeedingData feeding)  $default,) {final _that = this;
switch (_that) {
case _FarmReport():
return $default(_that.period,_that.population,_that.financial,_that.health,_that.breeding,_that.feeding);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReportPeriod period,  PopulationData population,  FinancialData? financial,  HealthData health,  BreedingData breeding,  FeedingData feeding)?  $default,) {final _that = this;
switch (_that) {
case _FarmReport() when $default != null:
return $default(_that.period,_that.population,_that.financial,_that.health,_that.breeding,_that.feeding);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FarmReport implements FarmReport {
  const _FarmReport({required this.period, required this.population, this.financial, required this.health, required this.breeding, required this.feeding});
  factory _FarmReport.fromJson(Map<String, dynamic> json) => _$FarmReportFromJson(json);

@override final  ReportPeriod period;
@override final  PopulationData population;
/// Как и в сводке «Сегодня»: работнику денежный блок не приходит.
@override final  FinancialData? financial;
@override final  HealthData health;
@override final  BreedingData breeding;
@override final  FeedingData feeding;

/// Create a copy of FarmReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FarmReportCopyWith<_FarmReport> get copyWith => __$FarmReportCopyWithImpl<_FarmReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FarmReportToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FarmReport&&(identical(other.period, period) || other.period == period)&&(identical(other.population, population) || other.population == population)&&(identical(other.financial, financial) || other.financial == financial)&&(identical(other.health, health) || other.health == health)&&(identical(other.breeding, breeding) || other.breeding == breeding)&&(identical(other.feeding, feeding) || other.feeding == feeding));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,period,population,financial,health,breeding,feeding);
}

@override
String toString() {
    return 'FarmReport(period: $period, population: $population, financial: $financial, health: $health, breeding: $breeding, feeding: $feeding)';
}


}

/// @nodoc
abstract mixin class _$FarmReportCopyWith<$Res> implements $FarmReportCopyWith<$Res> {
  factory _$FarmReportCopyWith(_FarmReport value, $Res Function(_FarmReport) _then) = __$FarmReportCopyWithImpl;
@override @useResult
$Res call({
 ReportPeriod period, PopulationData population, FinancialData? financial, HealthData health, BreedingData breeding, FeedingData feeding
});


@override $ReportPeriodCopyWith<$Res> get period;@override $PopulationDataCopyWith<$Res> get population;@override $FinancialDataCopyWith<$Res>? get financial;@override $HealthDataCopyWith<$Res> get health;@override $BreedingDataCopyWith<$Res> get breeding;@override $FeedingDataCopyWith<$Res> get feeding;

}
/// @nodoc
class __$FarmReportCopyWithImpl<$Res>
    implements _$FarmReportCopyWith<$Res> {
  __$FarmReportCopyWithImpl(this._self, this._then);

  final _FarmReport _self;
  final $Res Function(_FarmReport) _then;

/// Create a copy of FarmReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? period = null,Object? population = null,Object? financial = freezed,Object? health = null,Object? breeding = null,Object? feeding = null,}) {
  return _then(_FarmReport(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as ReportPeriod,population: null == population ? _self.population : population // ignore: cast_nullable_to_non_nullable
as PopulationData,financial: freezed == financial ? _self.financial : financial // ignore: cast_nullable_to_non_nullable
as FinancialData?,health: null == health ? _self.health : health // ignore: cast_nullable_to_non_nullable
as HealthData,breeding: null == breeding ? _self.breeding : breeding // ignore: cast_nullable_to_non_nullable
as BreedingData,feeding: null == feeding ? _self.feeding : feeding // ignore: cast_nullable_to_non_nullable
as FeedingData,
  ));
}

/// Create a copy of FarmReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportPeriodCopyWith<$Res> get period {
  
  return $ReportPeriodCopyWith<$Res>(_self.period, (value) {
    return _then(_self.copyWith(period: value));
  });
}/// Create a copy of FarmReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PopulationDataCopyWith<$Res> get population {
  
  return $PopulationDataCopyWith<$Res>(_self.population, (value) {
    return _then(_self.copyWith(population: value));
  });
}/// Create a copy of FarmReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FinancialDataCopyWith<$Res>? get financial {
    if (_self.financial == null) {
    return null;
  }

  return $FinancialDataCopyWith<$Res>(_self.financial!, (value) {
    return _then(_self.copyWith(financial: value));
  });
}/// Create a copy of FarmReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HealthDataCopyWith<$Res> get health {
  
  return $HealthDataCopyWith<$Res>(_self.health, (value) {
    return _then(_self.copyWith(health: value));
  });
}/// Create a copy of FarmReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BreedingDataCopyWith<$Res> get breeding {
  
  return $BreedingDataCopyWith<$Res>(_self.breeding, (value) {
    return _then(_self.copyWith(breeding: value));
  });
}/// Create a copy of FarmReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FeedingDataCopyWith<$Res> get feeding {
  
  return $FeedingDataCopyWith<$Res>(_self.feeding, (value) {
    return _then(_self.copyWith(feeding: value));
  });
}
}


/// @nodoc
mixin _$ReportPeriod {

 String get from; String get to;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportPeriod&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.to, _this.to) || other.to == _this.to));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReportPeriod;
  return Object.hash(runtimeType,_this.from,_this.to);
}

@override
String toString() {
  final _this = this as ReportPeriod;
  return 'ReportPeriod(from: ${_this.from}, to: ${_this.to})';
}


}

/// @nodoc
abstract mixin class $ReportPeriodCopyWith<$Res>  {
  factory $ReportPeriodCopyWith(ReportPeriod value, $Res Function(ReportPeriod) _then) = _$ReportPeriodCopyWithImpl;
@useResult
$Res call({
 String from, String to
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
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,}) {
  return _then(ReportPeriod(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String from,  String to)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportPeriod() when $default != null:
return $default(_that.from,_that.to);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String from,  String to)  $default,) {final _that = this;
switch (_that) {
case _ReportPeriod():
return $default(_that.from,_that.to);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String from,  String to)?  $default,) {final _that = this;
switch (_that) {
case _ReportPeriod() when $default != null:
return $default(_that.from,_that.to);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReportPeriod implements ReportPeriod {
  const _ReportPeriod({required this.from, required this.to});
  factory _ReportPeriod.fromJson(Map<String, dynamic> json) => _$ReportPeriodFromJson(json);

@override final  String from;
@override final  String to;

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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportPeriod&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,from,to);
}

@override
String toString() {
    return 'ReportPeriod(from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class _$ReportPeriodCopyWith<$Res> implements $ReportPeriodCopyWith<$Res> {
  factory _$ReportPeriodCopyWith(_ReportPeriod value, $Res Function(_ReportPeriod) _then) = __$ReportPeriodCopyWithImpl;
@override @useResult
$Res call({
 String from, String to
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
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,}) {
  return _then(_ReportPeriod(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PopulationData {

@JsonKey(name: 'total_rabbits')@IntConverter() int get totalRabbits;@JsonKey(name: 'by_breed') List<BreedCount> get byBreed;
/// Create a copy of PopulationData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PopulationDataCopyWith<PopulationData> get copyWith => _$PopulationDataCopyWithImpl<PopulationData>(this as PopulationData, _$identity);

  /// Serializes this PopulationData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PopulationData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PopulationData&&(identical(other.totalRabbits, _this.totalRabbits) || other.totalRabbits == _this.totalRabbits)&&const DeepCollectionEquality().equals(other.byBreed, _this.byBreed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PopulationData;
  return Object.hash(runtimeType,_this.totalRabbits,const DeepCollectionEquality().hash(_this.byBreed));
}

@override
String toString() {
  final _this = this as PopulationData;
  return 'PopulationData(totalRabbits: ${_this.totalRabbits}, byBreed: ${_this.byBreed})';
}


}

/// @nodoc
abstract mixin class $PopulationDataCopyWith<$Res>  {
  factory $PopulationDataCopyWith(PopulationData value, $Res Function(PopulationData) _then) = _$PopulationDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_rabbits')@IntConverter() int totalRabbits,@JsonKey(name: 'by_breed') List<BreedCount> byBreed
});




}
/// @nodoc
class _$PopulationDataCopyWithImpl<$Res>
    implements $PopulationDataCopyWith<$Res> {
  _$PopulationDataCopyWithImpl(this._self, this._then);

  final PopulationData _self;
  final $Res Function(PopulationData) _then;

/// Create a copy of PopulationData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalRabbits = null,Object? byBreed = null,}) {
  return _then(PopulationData(
totalRabbits: null == totalRabbits ? _self.totalRabbits : totalRabbits // ignore: cast_nullable_to_non_nullable
as int,byBreed: null == byBreed ? _self.byBreed : byBreed // ignore: cast_nullable_to_non_nullable
as List<BreedCount>,
  ));
}

}


/// Adds pattern-matching-related methods to [PopulationData].
extension PopulationDataPatterns on PopulationData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PopulationData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PopulationData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PopulationData value)  $default,){
final _that = this;
switch (_that) {
case _PopulationData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PopulationData value)?  $default,){
final _that = this;
switch (_that) {
case _PopulationData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_rabbits')@IntConverter()  int totalRabbits, @JsonKey(name: 'by_breed')  List<BreedCount> byBreed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PopulationData() when $default != null:
return $default(_that.totalRabbits,_that.byBreed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_rabbits')@IntConverter()  int totalRabbits, @JsonKey(name: 'by_breed')  List<BreedCount> byBreed)  $default,) {final _that = this;
switch (_that) {
case _PopulationData():
return $default(_that.totalRabbits,_that.byBreed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_rabbits')@IntConverter()  int totalRabbits, @JsonKey(name: 'by_breed')  List<BreedCount> byBreed)?  $default,) {final _that = this;
switch (_that) {
case _PopulationData() when $default != null:
return $default(_that.totalRabbits,_that.byBreed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PopulationData implements PopulationData {
  const _PopulationData({@JsonKey(name: 'total_rabbits')@IntConverter() required this.totalRabbits, @JsonKey(name: 'by_breed') required  List<BreedCount> byBreed}): _byBreed = byBreed;
  factory _PopulationData.fromJson(Map<String, dynamic> json) => _$PopulationDataFromJson(json);

@override@JsonKey(name: 'total_rabbits')@IntConverter() final  int totalRabbits;
 final  List<BreedCount> _byBreed;
@override@JsonKey(name: 'by_breed') List<BreedCount> get byBreed {
  if (_byBreed is EqualUnmodifiableListView) return _byBreed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_byBreed);
}


/// Create a copy of PopulationData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PopulationDataCopyWith<_PopulationData> get copyWith => __$PopulationDataCopyWithImpl<_PopulationData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PopulationDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PopulationData&&(identical(other.totalRabbits, totalRabbits) || other.totalRabbits == totalRabbits)&&const DeepCollectionEquality().equals(other.byBreed, _byBreed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalRabbits,const DeepCollectionEquality().hash(_byBreed));
}

@override
String toString() {
    return 'PopulationData(totalRabbits: $totalRabbits, byBreed: $byBreed)';
}


}

/// @nodoc
abstract mixin class _$PopulationDataCopyWith<$Res> implements $PopulationDataCopyWith<$Res> {
  factory _$PopulationDataCopyWith(_PopulationData value, $Res Function(_PopulationData) _then) = __$PopulationDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_rabbits')@IntConverter() int totalRabbits,@JsonKey(name: 'by_breed') List<BreedCount> byBreed
});




}
/// @nodoc
class __$PopulationDataCopyWithImpl<$Res>
    implements _$PopulationDataCopyWith<$Res> {
  __$PopulationDataCopyWithImpl(this._self, this._then);

  final _PopulationData _self;
  final $Res Function(_PopulationData) _then;

/// Create a copy of PopulationData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalRabbits = null,Object? byBreed = null,}) {
  return _then(_PopulationData(
totalRabbits: null == totalRabbits ? _self.totalRabbits : totalRabbits // ignore: cast_nullable_to_non_nullable
as int,byBreed: null == byBreed ? _self._byBreed : byBreed // ignore: cast_nullable_to_non_nullable
as List<BreedCount>,
  ));
}


}


/// @nodoc
mixin _$BreedCount {

@JsonKey(name: 'breed_id')@IntConverter() int get breedId;@IntConverter() int get count;
/// Create a copy of BreedCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreedCountCopyWith<BreedCount> get copyWith => _$BreedCountCopyWithImpl<BreedCount>(this as BreedCount, _$identity);

  /// Serializes this BreedCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BreedCount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BreedCount&&(identical(other.breedId, _this.breedId) || other.breedId == _this.breedId)&&(identical(other.count, _this.count) || other.count == _this.count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BreedCount;
  return Object.hash(runtimeType,_this.breedId,_this.count);
}

@override
String toString() {
  final _this = this as BreedCount;
  return 'BreedCount(breedId: ${_this.breedId}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $BreedCountCopyWith<$Res>  {
  factory $BreedCountCopyWith(BreedCount value, $Res Function(BreedCount) _then) = _$BreedCountCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'breed_id')@IntConverter() int breedId,@IntConverter() int count
});




}
/// @nodoc
class _$BreedCountCopyWithImpl<$Res>
    implements $BreedCountCopyWith<$Res> {
  _$BreedCountCopyWithImpl(this._self, this._then);

  final BreedCount _self;
  final $Res Function(BreedCount) _then;

/// Create a copy of BreedCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? breedId = null,Object? count = null,}) {
  return _then(BreedCount(
breedId: null == breedId ? _self.breedId : breedId // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BreedCount].
extension BreedCountPatterns on BreedCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BreedCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BreedCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BreedCount value)  $default,){
final _that = this;
switch (_that) {
case _BreedCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BreedCount value)?  $default,){
final _that = this;
switch (_that) {
case _BreedCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'breed_id')@IntConverter()  int breedId, @IntConverter()  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BreedCount() when $default != null:
return $default(_that.breedId,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'breed_id')@IntConverter()  int breedId, @IntConverter()  int count)  $default,) {final _that = this;
switch (_that) {
case _BreedCount():
return $default(_that.breedId,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'breed_id')@IntConverter()  int breedId, @IntConverter()  int count)?  $default,) {final _that = this;
switch (_that) {
case _BreedCount() when $default != null:
return $default(_that.breedId,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BreedCount implements BreedCount {
  const _BreedCount({@JsonKey(name: 'breed_id')@IntConverter() required this.breedId, @IntConverter() required this.count});
  factory _BreedCount.fromJson(Map<String, dynamic> json) => _$BreedCountFromJson(json);

@override@JsonKey(name: 'breed_id')@IntConverter() final  int breedId;
@override@IntConverter() final  int count;

/// Create a copy of BreedCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreedCountCopyWith<_BreedCount> get copyWith => __$BreedCountCopyWithImpl<_BreedCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BreedCountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BreedCount&&(identical(other.breedId, breedId) || other.breedId == breedId)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,breedId,count);
}

@override
String toString() {
    return 'BreedCount(breedId: $breedId, count: $count)';
}


}

/// @nodoc
abstract mixin class _$BreedCountCopyWith<$Res> implements $BreedCountCopyWith<$Res> {
  factory _$BreedCountCopyWith(_BreedCount value, $Res Function(_BreedCount) _then) = __$BreedCountCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'breed_id')@IntConverter() int breedId,@IntConverter() int count
});




}
/// @nodoc
class __$BreedCountCopyWithImpl<$Res>
    implements _$BreedCountCopyWith<$Res> {
  __$BreedCountCopyWithImpl(this._self, this._then);

  final _BreedCount _self;
  final $Res Function(_BreedCount) _then;

/// Create a copy of BreedCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? breedId = null,Object? count = null,}) {
  return _then(_BreedCount(
breedId: null == breedId ? _self.breedId : breedId // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$FinancialData {

 List<dynamic> get transactions; FinancialSummary get summary;
/// Create a copy of FinancialData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialDataCopyWith<FinancialData> get copyWith => _$FinancialDataCopyWithImpl<FinancialData>(this as FinancialData, _$identity);

  /// Serializes this FinancialData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FinancialData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialData&&const DeepCollectionEquality().equals(other.transactions, _this.transactions)&&(identical(other.summary, _this.summary) || other.summary == _this.summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FinancialData;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.transactions),_this.summary);
}

@override
String toString() {
  final _this = this as FinancialData;
  return 'FinancialData(transactions: ${_this.transactions}, summary: ${_this.summary})';
}


}

/// @nodoc
abstract mixin class $FinancialDataCopyWith<$Res>  {
  factory $FinancialDataCopyWith(FinancialData value, $Res Function(FinancialData) _then) = _$FinancialDataCopyWithImpl;
@useResult
$Res call({
 List<dynamic> transactions, FinancialSummary summary
});


$FinancialSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class _$FinancialDataCopyWithImpl<$Res>
    implements $FinancialDataCopyWith<$Res> {
  _$FinancialDataCopyWithImpl(this._self, this._then);

  final FinancialData _self;
  final $Res Function(FinancialData) _then;

/// Create a copy of FinancialData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transactions = null,Object? summary = null,}) {
  return _then(FinancialData(
transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<dynamic>,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as FinancialSummary,
  ));
}
/// Create a copy of FinancialData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FinancialSummaryCopyWith<$Res> get summary {
  
  return $FinancialSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [FinancialData].
extension FinancialDataPatterns on FinancialData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialData value)  $default,){
final _that = this;
switch (_that) {
case _FinancialData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialData value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<dynamic> transactions,  FinancialSummary summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinancialData() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<dynamic> transactions,  FinancialSummary summary)  $default,) {final _that = this;
switch (_that) {
case _FinancialData():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<dynamic> transactions,  FinancialSummary summary)?  $default,) {final _that = this;
switch (_that) {
case _FinancialData() when $default != null:
return $default(_that.transactions,_that.summary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinancialData implements FinancialData {
  const _FinancialData({required  List<dynamic> transactions, required this.summary}): _transactions = transactions;
  factory _FinancialData.fromJson(Map<String, dynamic> json) => _$FinancialDataFromJson(json);

 final  List<dynamic> _transactions;
@override List<dynamic> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}

@override final  FinancialSummary summary;

/// Create a copy of FinancialData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialDataCopyWith<_FinancialData> get copyWith => __$FinancialDataCopyWithImpl<_FinancialData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinancialDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialData&&const DeepCollectionEquality().equals(other.transactions, _transactions)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_transactions),summary);
}

@override
String toString() {
    return 'FinancialData(transactions: $transactions, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$FinancialDataCopyWith<$Res> implements $FinancialDataCopyWith<$Res> {
  factory _$FinancialDataCopyWith(_FinancialData value, $Res Function(_FinancialData) _then) = __$FinancialDataCopyWithImpl;
@override @useResult
$Res call({
 List<dynamic> transactions, FinancialSummary summary
});


@override $FinancialSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class __$FinancialDataCopyWithImpl<$Res>
    implements _$FinancialDataCopyWith<$Res> {
  __$FinancialDataCopyWithImpl(this._self, this._then);

  final _FinancialData _self;
  final $Res Function(_FinancialData) _then;

/// Create a copy of FinancialData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transactions = null,Object? summary = null,}) {
  return _then(_FinancialData(
transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<dynamic>,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as FinancialSummary,
  ));
}

/// Create a copy of FinancialData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FinancialSummaryCopyWith<$Res> get summary {
  
  return $FinancialSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// @nodoc
mixin _$FinancialSummary {

@JsonKey(name: 'total_income')@DoubleConverter() double get totalIncome;@JsonKey(name: 'total_expenses')@DoubleConverter() double get totalExpenses;
/// Create a copy of FinancialSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialSummaryCopyWith<FinancialSummary> get copyWith => _$FinancialSummaryCopyWithImpl<FinancialSummary>(this as FinancialSummary, _$identity);

  /// Serializes this FinancialSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FinancialSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialSummary&&(identical(other.totalIncome, _this.totalIncome) || other.totalIncome == _this.totalIncome)&&(identical(other.totalExpenses, _this.totalExpenses) || other.totalExpenses == _this.totalExpenses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FinancialSummary;
  return Object.hash(runtimeType,_this.totalIncome,_this.totalExpenses);
}

@override
String toString() {
  final _this = this as FinancialSummary;
  return 'FinancialSummary(totalIncome: ${_this.totalIncome}, totalExpenses: ${_this.totalExpenses})';
}


}

/// @nodoc
abstract mixin class $FinancialSummaryCopyWith<$Res>  {
  factory $FinancialSummaryCopyWith(FinancialSummary value, $Res Function(FinancialSummary) _then) = _$FinancialSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_income')@DoubleConverter() double totalIncome,@JsonKey(name: 'total_expenses')@DoubleConverter() double totalExpenses
});




}
/// @nodoc
class _$FinancialSummaryCopyWithImpl<$Res>
    implements $FinancialSummaryCopyWith<$Res> {
  _$FinancialSummaryCopyWithImpl(this._self, this._then);

  final FinancialSummary _self;
  final $Res Function(FinancialSummary) _then;

/// Create a copy of FinancialSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalIncome = null,Object? totalExpenses = null,}) {
  return _then(FinancialSummary(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpenses: null == totalExpenses ? _self.totalExpenses : totalExpenses // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FinancialSummary].
extension FinancialSummaryPatterns on FinancialSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialSummary value)  $default,){
final _that = this;
switch (_that) {
case _FinancialSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialSummary value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_income')@DoubleConverter()  double totalIncome, @JsonKey(name: 'total_expenses')@DoubleConverter()  double totalExpenses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinancialSummary() when $default != null:
return $default(_that.totalIncome,_that.totalExpenses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_income')@DoubleConverter()  double totalIncome, @JsonKey(name: 'total_expenses')@DoubleConverter()  double totalExpenses)  $default,) {final _that = this;
switch (_that) {
case _FinancialSummary():
return $default(_that.totalIncome,_that.totalExpenses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_income')@DoubleConverter()  double totalIncome, @JsonKey(name: 'total_expenses')@DoubleConverter()  double totalExpenses)?  $default,) {final _that = this;
switch (_that) {
case _FinancialSummary() when $default != null:
return $default(_that.totalIncome,_that.totalExpenses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinancialSummary implements FinancialSummary {
  const _FinancialSummary({@JsonKey(name: 'total_income')@DoubleConverter() required this.totalIncome, @JsonKey(name: 'total_expenses')@DoubleConverter() required this.totalExpenses});
  factory _FinancialSummary.fromJson(Map<String, dynamic> json) => _$FinancialSummaryFromJson(json);

@override@JsonKey(name: 'total_income')@DoubleConverter() final  double totalIncome;
@override@JsonKey(name: 'total_expenses')@DoubleConverter() final  double totalExpenses;

/// Create a copy of FinancialSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialSummaryCopyWith<_FinancialSummary> get copyWith => __$FinancialSummaryCopyWithImpl<_FinancialSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinancialSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialSummary&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpenses, totalExpenses) || other.totalExpenses == totalExpenses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalIncome,totalExpenses);
}

@override
String toString() {
    return 'FinancialSummary(totalIncome: $totalIncome, totalExpenses: $totalExpenses)';
}


}

/// @nodoc
abstract mixin class _$FinancialSummaryCopyWith<$Res> implements $FinancialSummaryCopyWith<$Res> {
  factory _$FinancialSummaryCopyWith(_FinancialSummary value, $Res Function(_FinancialSummary) _then) = __$FinancialSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_income')@DoubleConverter() double totalIncome,@JsonKey(name: 'total_expenses')@DoubleConverter() double totalExpenses
});




}
/// @nodoc
class __$FinancialSummaryCopyWithImpl<$Res>
    implements _$FinancialSummaryCopyWith<$Res> {
  __$FinancialSummaryCopyWithImpl(this._self, this._then);

  final _FinancialSummary _self;
  final $Res Function(_FinancialSummary) _then;

/// Create a copy of FinancialSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalIncome = null,Object? totalExpenses = null,}) {
  return _then(_FinancialSummary(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpenses: null == totalExpenses ? _self.totalExpenses : totalExpenses // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$HealthData {

@IntConverter() int get vaccinations;@JsonKey(name: 'medical_records')@IntConverter() int get medicalRecords;
/// Create a copy of HealthData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthDataCopyWith<HealthData> get copyWith => _$HealthDataCopyWithImpl<HealthData>(this as HealthData, _$identity);

  /// Serializes this HealthData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HealthData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthData&&(identical(other.vaccinations, _this.vaccinations) || other.vaccinations == _this.vaccinations)&&(identical(other.medicalRecords, _this.medicalRecords) || other.medicalRecords == _this.medicalRecords));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HealthData;
  return Object.hash(runtimeType,_this.vaccinations,_this.medicalRecords);
}

@override
String toString() {
  final _this = this as HealthData;
  return 'HealthData(vaccinations: ${_this.vaccinations}, medicalRecords: ${_this.medicalRecords})';
}


}

/// @nodoc
abstract mixin class $HealthDataCopyWith<$Res>  {
  factory $HealthDataCopyWith(HealthData value, $Res Function(HealthData) _then) = _$HealthDataCopyWithImpl;
@useResult
$Res call({
@IntConverter() int vaccinations,@JsonKey(name: 'medical_records')@IntConverter() int medicalRecords
});




}
/// @nodoc
class _$HealthDataCopyWithImpl<$Res>
    implements $HealthDataCopyWith<$Res> {
  _$HealthDataCopyWithImpl(this._self, this._then);

  final HealthData _self;
  final $Res Function(HealthData) _then;

/// Create a copy of HealthData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vaccinations = null,Object? medicalRecords = null,}) {
  return _then(HealthData(
vaccinations: null == vaccinations ? _self.vaccinations : vaccinations // ignore: cast_nullable_to_non_nullable
as int,medicalRecords: null == medicalRecords ? _self.medicalRecords : medicalRecords // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthData].
extension HealthDataPatterns on HealthData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthData value)  $default,){
final _that = this;
switch (_that) {
case _HealthData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthData value)?  $default,){
final _that = this;
switch (_that) {
case _HealthData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int vaccinations, @JsonKey(name: 'medical_records')@IntConverter()  int medicalRecords)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthData() when $default != null:
return $default(_that.vaccinations,_that.medicalRecords);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int vaccinations, @JsonKey(name: 'medical_records')@IntConverter()  int medicalRecords)  $default,) {final _that = this;
switch (_that) {
case _HealthData():
return $default(_that.vaccinations,_that.medicalRecords);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int vaccinations, @JsonKey(name: 'medical_records')@IntConverter()  int medicalRecords)?  $default,) {final _that = this;
switch (_that) {
case _HealthData() when $default != null:
return $default(_that.vaccinations,_that.medicalRecords);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthData implements HealthData {
  const _HealthData({@IntConverter() required this.vaccinations, @JsonKey(name: 'medical_records')@IntConverter() required this.medicalRecords});
  factory _HealthData.fromJson(Map<String, dynamic> json) => _$HealthDataFromJson(json);

@override@IntConverter() final  int vaccinations;
@override@JsonKey(name: 'medical_records')@IntConverter() final  int medicalRecords;

/// Create a copy of HealthData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthDataCopyWith<_HealthData> get copyWith => __$HealthDataCopyWithImpl<_HealthData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthData&&(identical(other.vaccinations, vaccinations) || other.vaccinations == vaccinations)&&(identical(other.medicalRecords, medicalRecords) || other.medicalRecords == medicalRecords));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,vaccinations,medicalRecords);
}

@override
String toString() {
    return 'HealthData(vaccinations: $vaccinations, medicalRecords: $medicalRecords)';
}


}

/// @nodoc
abstract mixin class _$HealthDataCopyWith<$Res> implements $HealthDataCopyWith<$Res> {
  factory _$HealthDataCopyWith(_HealthData value, $Res Function(_HealthData) _then) = __$HealthDataCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int vaccinations,@JsonKey(name: 'medical_records')@IntConverter() int medicalRecords
});




}
/// @nodoc
class __$HealthDataCopyWithImpl<$Res>
    implements _$HealthDataCopyWith<$Res> {
  __$HealthDataCopyWithImpl(this._self, this._then);

  final _HealthData _self;
  final $Res Function(_HealthData) _then;

/// Create a copy of HealthData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vaccinations = null,Object? medicalRecords = null,}) {
  return _then(_HealthData(
vaccinations: null == vaccinations ? _self.vaccinations : vaccinations // ignore: cast_nullable_to_non_nullable
as int,medicalRecords: null == medicalRecords ? _self.medicalRecords : medicalRecords // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BreedingData {

@IntConverter() int get breedings;@IntConverter() int get births;
/// Create a copy of BreedingData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreedingDataCopyWith<BreedingData> get copyWith => _$BreedingDataCopyWithImpl<BreedingData>(this as BreedingData, _$identity);

  /// Serializes this BreedingData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BreedingData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BreedingData&&(identical(other.breedings, _this.breedings) || other.breedings == _this.breedings)&&(identical(other.births, _this.births) || other.births == _this.births));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BreedingData;
  return Object.hash(runtimeType,_this.breedings,_this.births);
}

@override
String toString() {
  final _this = this as BreedingData;
  return 'BreedingData(breedings: ${_this.breedings}, births: ${_this.births})';
}


}

/// @nodoc
abstract mixin class $BreedingDataCopyWith<$Res>  {
  factory $BreedingDataCopyWith(BreedingData value, $Res Function(BreedingData) _then) = _$BreedingDataCopyWithImpl;
@useResult
$Res call({
@IntConverter() int breedings,@IntConverter() int births
});




}
/// @nodoc
class _$BreedingDataCopyWithImpl<$Res>
    implements $BreedingDataCopyWith<$Res> {
  _$BreedingDataCopyWithImpl(this._self, this._then);

  final BreedingData _self;
  final $Res Function(BreedingData) _then;

/// Create a copy of BreedingData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? breedings = null,Object? births = null,}) {
  return _then(BreedingData(
breedings: null == breedings ? _self.breedings : breedings // ignore: cast_nullable_to_non_nullable
as int,births: null == births ? _self.births : births // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BreedingData].
extension BreedingDataPatterns on BreedingData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BreedingData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BreedingData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BreedingData value)  $default,){
final _that = this;
switch (_that) {
case _BreedingData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BreedingData value)?  $default,){
final _that = this;
switch (_that) {
case _BreedingData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@IntConverter()  int breedings, @IntConverter()  int births)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BreedingData() when $default != null:
return $default(_that.breedings,_that.births);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@IntConverter()  int breedings, @IntConverter()  int births)  $default,) {final _that = this;
switch (_that) {
case _BreedingData():
return $default(_that.breedings,_that.births);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@IntConverter()  int breedings, @IntConverter()  int births)?  $default,) {final _that = this;
switch (_that) {
case _BreedingData() when $default != null:
return $default(_that.breedings,_that.births);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BreedingData implements BreedingData {
  const _BreedingData({@IntConverter() required this.breedings, @IntConverter() required this.births});
  factory _BreedingData.fromJson(Map<String, dynamic> json) => _$BreedingDataFromJson(json);

@override@IntConverter() final  int breedings;
@override@IntConverter() final  int births;

/// Create a copy of BreedingData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreedingDataCopyWith<_BreedingData> get copyWith => __$BreedingDataCopyWithImpl<_BreedingData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BreedingDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BreedingData&&(identical(other.breedings, breedings) || other.breedings == breedings)&&(identical(other.births, births) || other.births == births));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,breedings,births);
}

@override
String toString() {
    return 'BreedingData(breedings: $breedings, births: $births)';
}


}

/// @nodoc
abstract mixin class _$BreedingDataCopyWith<$Res> implements $BreedingDataCopyWith<$Res> {
  factory _$BreedingDataCopyWith(_BreedingData value, $Res Function(_BreedingData) _then) = __$BreedingDataCopyWithImpl;
@override @useResult
$Res call({
@IntConverter() int breedings,@IntConverter() int births
});




}
/// @nodoc
class __$BreedingDataCopyWithImpl<$Res>
    implements _$BreedingDataCopyWith<$Res> {
  __$BreedingDataCopyWithImpl(this._self, this._then);

  final _BreedingData _self;
  final $Res Function(_BreedingData) _then;

/// Create a copy of BreedingData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? breedings = null,Object? births = null,}) {
  return _then(_BreedingData(
breedings: null == breedings ? _self.breedings : breedings // ignore: cast_nullable_to_non_nullable
as int,births: null == births ? _self.births : births // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$FeedingData {

@JsonKey(name: 'total_feeding_records')@IntConverter() int get totalFeedingRecords;/// Расход по каждой единице измерения отдельно.
///
/// Модель требовала одно общее число `total_feed_consumption`, которого
/// сервер никогда не отдавал, — на настоящем ответе разбор всего отчёта
/// падал. Не отдавал он его намеренно: складывать килограммы со штуками
/// нельзя, сумма получилась бы бессмысленной.
@JsonKey(name: 'consumption_by_unit') List<FeedConsumption> get consumptionByUnit;
/// Create a copy of FeedingData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedingDataCopyWith<FeedingData> get copyWith => _$FeedingDataCopyWithImpl<FeedingData>(this as FeedingData, _$identity);

  /// Serializes this FeedingData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeedingData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedingData&&(identical(other.totalFeedingRecords, _this.totalFeedingRecords) || other.totalFeedingRecords == _this.totalFeedingRecords)&&const DeepCollectionEquality().equals(other.consumptionByUnit, _this.consumptionByUnit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeedingData;
  return Object.hash(runtimeType,_this.totalFeedingRecords,const DeepCollectionEquality().hash(_this.consumptionByUnit));
}

@override
String toString() {
  final _this = this as FeedingData;
  return 'FeedingData(totalFeedingRecords: ${_this.totalFeedingRecords}, consumptionByUnit: ${_this.consumptionByUnit})';
}


}

/// @nodoc
abstract mixin class $FeedingDataCopyWith<$Res>  {
  factory $FeedingDataCopyWith(FeedingData value, $Res Function(FeedingData) _then) = _$FeedingDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_feeding_records')@IntConverter() int totalFeedingRecords,@JsonKey(name: 'consumption_by_unit') List<FeedConsumption> consumptionByUnit
});




}
/// @nodoc
class _$FeedingDataCopyWithImpl<$Res>
    implements $FeedingDataCopyWith<$Res> {
  _$FeedingDataCopyWithImpl(this._self, this._then);

  final FeedingData _self;
  final $Res Function(FeedingData) _then;

/// Create a copy of FeedingData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalFeedingRecords = null,Object? consumptionByUnit = null,}) {
  return _then(FeedingData(
totalFeedingRecords: null == totalFeedingRecords ? _self.totalFeedingRecords : totalFeedingRecords // ignore: cast_nullable_to_non_nullable
as int,consumptionByUnit: null == consumptionByUnit ? _self.consumptionByUnit : consumptionByUnit // ignore: cast_nullable_to_non_nullable
as List<FeedConsumption>,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedingData].
extension FeedingDataPatterns on FeedingData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedingData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedingData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedingData value)  $default,){
final _that = this;
switch (_that) {
case _FeedingData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedingData value)?  $default,){
final _that = this;
switch (_that) {
case _FeedingData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_feeding_records')@IntConverter()  int totalFeedingRecords, @JsonKey(name: 'consumption_by_unit')  List<FeedConsumption> consumptionByUnit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedingData() when $default != null:
return $default(_that.totalFeedingRecords,_that.consumptionByUnit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_feeding_records')@IntConverter()  int totalFeedingRecords, @JsonKey(name: 'consumption_by_unit')  List<FeedConsumption> consumptionByUnit)  $default,) {final _that = this;
switch (_that) {
case _FeedingData():
return $default(_that.totalFeedingRecords,_that.consumptionByUnit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_feeding_records')@IntConverter()  int totalFeedingRecords, @JsonKey(name: 'consumption_by_unit')  List<FeedConsumption> consumptionByUnit)?  $default,) {final _that = this;
switch (_that) {
case _FeedingData() when $default != null:
return $default(_that.totalFeedingRecords,_that.consumptionByUnit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedingData implements FeedingData {
  const _FeedingData({@JsonKey(name: 'total_feeding_records')@IntConverter() required this.totalFeedingRecords, @JsonKey(name: 'consumption_by_unit')  List<FeedConsumption> consumptionByUnit = const []}): _consumptionByUnit = consumptionByUnit;
  factory _FeedingData.fromJson(Map<String, dynamic> json) => _$FeedingDataFromJson(json);

@override@JsonKey(name: 'total_feeding_records')@IntConverter() final  int totalFeedingRecords;
/// Расход по каждой единице измерения отдельно.
///
/// Модель требовала одно общее число `total_feed_consumption`, которого
/// сервер никогда не отдавал, — на настоящем ответе разбор всего отчёта
/// падал. Не отдавал он его намеренно: складывать килограммы со штуками
/// нельзя, сумма получилась бы бессмысленной.
 final  List<FeedConsumption> _consumptionByUnit;
/// Расход по каждой единице измерения отдельно.
///
/// Модель требовала одно общее число `total_feed_consumption`, которого
/// сервер никогда не отдавал, — на настоящем ответе разбор всего отчёта
/// падал. Не отдавал он его намеренно: складывать килограммы со штуками
/// нельзя, сумма получилась бы бессмысленной.
@override@JsonKey(name: 'consumption_by_unit') List<FeedConsumption> get consumptionByUnit {
  if (_consumptionByUnit is EqualUnmodifiableListView) return _consumptionByUnit;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_consumptionByUnit);
}


/// Create a copy of FeedingData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedingDataCopyWith<_FeedingData> get copyWith => __$FeedingDataCopyWithImpl<_FeedingData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedingDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedingData&&(identical(other.totalFeedingRecords, totalFeedingRecords) || other.totalFeedingRecords == totalFeedingRecords)&&const DeepCollectionEquality().equals(other.consumptionByUnit, _consumptionByUnit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalFeedingRecords,const DeepCollectionEquality().hash(_consumptionByUnit));
}

@override
String toString() {
    return 'FeedingData(totalFeedingRecords: $totalFeedingRecords, consumptionByUnit: $consumptionByUnit)';
}


}

/// @nodoc
abstract mixin class _$FeedingDataCopyWith<$Res> implements $FeedingDataCopyWith<$Res> {
  factory _$FeedingDataCopyWith(_FeedingData value, $Res Function(_FeedingData) _then) = __$FeedingDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_feeding_records')@IntConverter() int totalFeedingRecords,@JsonKey(name: 'consumption_by_unit') List<FeedConsumption> consumptionByUnit
});




}
/// @nodoc
class __$FeedingDataCopyWithImpl<$Res>
    implements _$FeedingDataCopyWith<$Res> {
  __$FeedingDataCopyWithImpl(this._self, this._then);

  final _FeedingData _self;
  final $Res Function(_FeedingData) _then;

/// Create a copy of FeedingData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalFeedingRecords = null,Object? consumptionByUnit = null,}) {
  return _then(_FeedingData(
totalFeedingRecords: null == totalFeedingRecords ? _self.totalFeedingRecords : totalFeedingRecords // ignore: cast_nullable_to_non_nullable
as int,consumptionByUnit: null == consumptionByUnit ? _self._consumptionByUnit : consumptionByUnit // ignore: cast_nullable_to_non_nullable
as List<FeedConsumption>,
  ));
}


}


/// @nodoc
mixin _$FeedConsumption {

 String get unit;@DoubleConverter() double get total;
/// Create a copy of FeedConsumption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedConsumptionCopyWith<FeedConsumption> get copyWith => _$FeedConsumptionCopyWithImpl<FeedConsumption>(this as FeedConsumption, _$identity);

  /// Serializes this FeedConsumption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeedConsumption;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedConsumption&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.total, _this.total) || other.total == _this.total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeedConsumption;
  return Object.hash(runtimeType,_this.unit,_this.total);
}

@override
String toString() {
  final _this = this as FeedConsumption;
  return 'FeedConsumption(unit: ${_this.unit}, total: ${_this.total})';
}


}

/// @nodoc
abstract mixin class $FeedConsumptionCopyWith<$Res>  {
  factory $FeedConsumptionCopyWith(FeedConsumption value, $Res Function(FeedConsumption) _then) = _$FeedConsumptionCopyWithImpl;
@useResult
$Res call({
 String unit,@DoubleConverter() double total
});




}
/// @nodoc
class _$FeedConsumptionCopyWithImpl<$Res>
    implements $FeedConsumptionCopyWith<$Res> {
  _$FeedConsumptionCopyWithImpl(this._self, this._then);

  final FeedConsumption _self;
  final $Res Function(FeedConsumption) _then;

/// Create a copy of FeedConsumption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? unit = null,Object? total = null,}) {
  return _then(FeedConsumption(
unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedConsumption].
extension FeedConsumptionPatterns on FeedConsumption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedConsumption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedConsumption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedConsumption value)  $default,){
final _that = this;
switch (_that) {
case _FeedConsumption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedConsumption value)?  $default,){
final _that = this;
switch (_that) {
case _FeedConsumption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String unit, @DoubleConverter()  double total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedConsumption() when $default != null:
return $default(_that.unit,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String unit, @DoubleConverter()  double total)  $default,) {final _that = this;
switch (_that) {
case _FeedConsumption():
return $default(_that.unit,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String unit, @DoubleConverter()  double total)?  $default,) {final _that = this;
switch (_that) {
case _FeedConsumption() when $default != null:
return $default(_that.unit,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedConsumption implements FeedConsumption {
  const _FeedConsumption({required this.unit, @DoubleConverter() required this.total});
  factory _FeedConsumption.fromJson(Map<String, dynamic> json) => _$FeedConsumptionFromJson(json);

@override final  String unit;
@override@DoubleConverter() final  double total;

/// Create a copy of FeedConsumption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedConsumptionCopyWith<_FeedConsumption> get copyWith => __$FeedConsumptionCopyWithImpl<_FeedConsumption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedConsumptionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedConsumption&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,unit,total);
}

@override
String toString() {
    return 'FeedConsumption(unit: $unit, total: $total)';
}


}

/// @nodoc
abstract mixin class _$FeedConsumptionCopyWith<$Res> implements $FeedConsumptionCopyWith<$Res> {
  factory _$FeedConsumptionCopyWith(_FeedConsumption value, $Res Function(_FeedConsumption) _then) = __$FeedConsumptionCopyWithImpl;
@override @useResult
$Res call({
 String unit,@DoubleConverter() double total
});




}
/// @nodoc
class __$FeedConsumptionCopyWithImpl<$Res>
    implements _$FeedConsumptionCopyWith<$Res> {
  __$FeedConsumptionCopyWithImpl(this._self, this._then);

  final _FeedConsumption _self;
  final $Res Function(_FeedConsumption) _then;

/// Create a copy of FeedConsumption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? unit = null,Object? total = null,}) {
  return _then(_FeedConsumption(
unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$HealthReport {

 VaccinationsData get vaccinations;@JsonKey(name: 'medical_records') MedicalRecordsData get medicalRecords;
/// Create a copy of HealthReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthReportCopyWith<HealthReport> get copyWith => _$HealthReportCopyWithImpl<HealthReport>(this as HealthReport, _$identity);

  /// Serializes this HealthReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HealthReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthReport&&(identical(other.vaccinations, _this.vaccinations) || other.vaccinations == _this.vaccinations)&&(identical(other.medicalRecords, _this.medicalRecords) || other.medicalRecords == _this.medicalRecords));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HealthReport;
  return Object.hash(runtimeType,_this.vaccinations,_this.medicalRecords);
}

@override
String toString() {
  final _this = this as HealthReport;
  return 'HealthReport(vaccinations: ${_this.vaccinations}, medicalRecords: ${_this.medicalRecords})';
}


}

/// @nodoc
abstract mixin class $HealthReportCopyWith<$Res>  {
  factory $HealthReportCopyWith(HealthReport value, $Res Function(HealthReport) _then) = _$HealthReportCopyWithImpl;
@useResult
$Res call({
 VaccinationsData vaccinations,@JsonKey(name: 'medical_records') MedicalRecordsData medicalRecords
});


$VaccinationsDataCopyWith<$Res> get vaccinations;$MedicalRecordsDataCopyWith<$Res> get medicalRecords;

}
/// @nodoc
class _$HealthReportCopyWithImpl<$Res>
    implements $HealthReportCopyWith<$Res> {
  _$HealthReportCopyWithImpl(this._self, this._then);

  final HealthReport _self;
  final $Res Function(HealthReport) _then;

/// Create a copy of HealthReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vaccinations = null,Object? medicalRecords = null,}) {
  return _then(HealthReport(
vaccinations: null == vaccinations ? _self.vaccinations : vaccinations // ignore: cast_nullable_to_non_nullable
as VaccinationsData,medicalRecords: null == medicalRecords ? _self.medicalRecords : medicalRecords // ignore: cast_nullable_to_non_nullable
as MedicalRecordsData,
  ));
}
/// Create a copy of HealthReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VaccinationsDataCopyWith<$Res> get vaccinations {
  
  return $VaccinationsDataCopyWith<$Res>(_self.vaccinations, (value) {
    return _then(_self.copyWith(vaccinations: value));
  });
}/// Create a copy of HealthReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicalRecordsDataCopyWith<$Res> get medicalRecords {
  
  return $MedicalRecordsDataCopyWith<$Res>(_self.medicalRecords, (value) {
    return _then(_self.copyWith(medicalRecords: value));
  });
}
}


/// Adds pattern-matching-related methods to [HealthReport].
extension HealthReportPatterns on HealthReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthReport value)  $default,){
final _that = this;
switch (_that) {
case _HealthReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthReport value)?  $default,){
final _that = this;
switch (_that) {
case _HealthReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VaccinationsData vaccinations, @JsonKey(name: 'medical_records')  MedicalRecordsData medicalRecords)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthReport() when $default != null:
return $default(_that.vaccinations,_that.medicalRecords);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VaccinationsData vaccinations, @JsonKey(name: 'medical_records')  MedicalRecordsData medicalRecords)  $default,) {final _that = this;
switch (_that) {
case _HealthReport():
return $default(_that.vaccinations,_that.medicalRecords);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VaccinationsData vaccinations, @JsonKey(name: 'medical_records')  MedicalRecordsData medicalRecords)?  $default,) {final _that = this;
switch (_that) {
case _HealthReport() when $default != null:
return $default(_that.vaccinations,_that.medicalRecords);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthReport implements HealthReport {
  const _HealthReport({required this.vaccinations, @JsonKey(name: 'medical_records') required this.medicalRecords});
  factory _HealthReport.fromJson(Map<String, dynamic> json) => _$HealthReportFromJson(json);

@override final  VaccinationsData vaccinations;
@override@JsonKey(name: 'medical_records') final  MedicalRecordsData medicalRecords;

/// Create a copy of HealthReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthReportCopyWith<_HealthReport> get copyWith => __$HealthReportCopyWithImpl<_HealthReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthReportToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthReport&&(identical(other.vaccinations, vaccinations) || other.vaccinations == vaccinations)&&(identical(other.medicalRecords, medicalRecords) || other.medicalRecords == medicalRecords));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,vaccinations,medicalRecords);
}

@override
String toString() {
    return 'HealthReport(vaccinations: $vaccinations, medicalRecords: $medicalRecords)';
}


}

/// @nodoc
abstract mixin class _$HealthReportCopyWith<$Res> implements $HealthReportCopyWith<$Res> {
  factory _$HealthReportCopyWith(_HealthReport value, $Res Function(_HealthReport) _then) = __$HealthReportCopyWithImpl;
@override @useResult
$Res call({
 VaccinationsData vaccinations,@JsonKey(name: 'medical_records') MedicalRecordsData medicalRecords
});


@override $VaccinationsDataCopyWith<$Res> get vaccinations;@override $MedicalRecordsDataCopyWith<$Res> get medicalRecords;

}
/// @nodoc
class __$HealthReportCopyWithImpl<$Res>
    implements _$HealthReportCopyWith<$Res> {
  __$HealthReportCopyWithImpl(this._self, this._then);

  final _HealthReport _self;
  final $Res Function(_HealthReport) _then;

/// Create a copy of HealthReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vaccinations = null,Object? medicalRecords = null,}) {
  return _then(_HealthReport(
vaccinations: null == vaccinations ? _self.vaccinations : vaccinations // ignore: cast_nullable_to_non_nullable
as VaccinationsData,medicalRecords: null == medicalRecords ? _self.medicalRecords : medicalRecords // ignore: cast_nullable_to_non_nullable
as MedicalRecordsData,
  ));
}

/// Create a copy of HealthReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VaccinationsDataCopyWith<$Res> get vaccinations {
  
  return $VaccinationsDataCopyWith<$Res>(_self.vaccinations, (value) {
    return _then(_self.copyWith(vaccinations: value));
  });
}/// Create a copy of HealthReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MedicalRecordsDataCopyWith<$Res> get medicalRecords {
  
  return $MedicalRecordsDataCopyWith<$Res>(_self.medicalRecords, (value) {
    return _then(_self.copyWith(medicalRecords: value));
  });
}
}


/// @nodoc
mixin _$VaccinationsData {

@JsonKey(name: 'by_type') List<VaccineTypeCount> get byType; List<dynamic> get upcoming;
/// Create a copy of VaccinationsData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VaccinationsDataCopyWith<VaccinationsData> get copyWith => _$VaccinationsDataCopyWithImpl<VaccinationsData>(this as VaccinationsData, _$identity);

  /// Serializes this VaccinationsData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as VaccinationsData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VaccinationsData&&const DeepCollectionEquality().equals(other.byType, _this.byType)&&const DeepCollectionEquality().equals(other.upcoming, _this.upcoming));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VaccinationsData;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.byType),const DeepCollectionEquality().hash(_this.upcoming));
}

@override
String toString() {
  final _this = this as VaccinationsData;
  return 'VaccinationsData(byType: ${_this.byType}, upcoming: ${_this.upcoming})';
}


}

/// @nodoc
abstract mixin class $VaccinationsDataCopyWith<$Res>  {
  factory $VaccinationsDataCopyWith(VaccinationsData value, $Res Function(VaccinationsData) _then) = _$VaccinationsDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'by_type') List<VaccineTypeCount> byType, List<dynamic> upcoming
});




}
/// @nodoc
class _$VaccinationsDataCopyWithImpl<$Res>
    implements $VaccinationsDataCopyWith<$Res> {
  _$VaccinationsDataCopyWithImpl(this._self, this._then);

  final VaccinationsData _self;
  final $Res Function(VaccinationsData) _then;

/// Create a copy of VaccinationsData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? byType = null,Object? upcoming = null,}) {
  return _then(VaccinationsData(
byType: null == byType ? _self.byType : byType // ignore: cast_nullable_to_non_nullable
as List<VaccineTypeCount>,upcoming: null == upcoming ? _self.upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as List<dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [VaccinationsData].
extension VaccinationsDataPatterns on VaccinationsData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VaccinationsData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VaccinationsData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VaccinationsData value)  $default,){
final _that = this;
switch (_that) {
case _VaccinationsData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VaccinationsData value)?  $default,){
final _that = this;
switch (_that) {
case _VaccinationsData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'by_type')  List<VaccineTypeCount> byType,  List<dynamic> upcoming)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VaccinationsData() when $default != null:
return $default(_that.byType,_that.upcoming);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'by_type')  List<VaccineTypeCount> byType,  List<dynamic> upcoming)  $default,) {final _that = this;
switch (_that) {
case _VaccinationsData():
return $default(_that.byType,_that.upcoming);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'by_type')  List<VaccineTypeCount> byType,  List<dynamic> upcoming)?  $default,) {final _that = this;
switch (_that) {
case _VaccinationsData() when $default != null:
return $default(_that.byType,_that.upcoming);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VaccinationsData implements VaccinationsData {
  const _VaccinationsData({@JsonKey(name: 'by_type') required  List<VaccineTypeCount> byType, required  List<dynamic> upcoming}): _byType = byType,_upcoming = upcoming;
  factory _VaccinationsData.fromJson(Map<String, dynamic> json) => _$VaccinationsDataFromJson(json);

 final  List<VaccineTypeCount> _byType;
@override@JsonKey(name: 'by_type') List<VaccineTypeCount> get byType {
  if (_byType is EqualUnmodifiableListView) return _byType;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_byType);
}

 final  List<dynamic> _upcoming;
@override List<dynamic> get upcoming {
  if (_upcoming is EqualUnmodifiableListView) return _upcoming;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_upcoming);
}


/// Create a copy of VaccinationsData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VaccinationsDataCopyWith<_VaccinationsData> get copyWith => __$VaccinationsDataCopyWithImpl<_VaccinationsData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VaccinationsDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VaccinationsData&&const DeepCollectionEquality().equals(other.byType, _byType)&&const DeepCollectionEquality().equals(other.upcoming, _upcoming));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_byType),const DeepCollectionEquality().hash(_upcoming));
}

@override
String toString() {
    return 'VaccinationsData(byType: $byType, upcoming: $upcoming)';
}


}

/// @nodoc
abstract mixin class _$VaccinationsDataCopyWith<$Res> implements $VaccinationsDataCopyWith<$Res> {
  factory _$VaccinationsDataCopyWith(_VaccinationsData value, $Res Function(_VaccinationsData) _then) = __$VaccinationsDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'by_type') List<VaccineTypeCount> byType, List<dynamic> upcoming
});




}
/// @nodoc
class __$VaccinationsDataCopyWithImpl<$Res>
    implements _$VaccinationsDataCopyWith<$Res> {
  __$VaccinationsDataCopyWithImpl(this._self, this._then);

  final _VaccinationsData _self;
  final $Res Function(_VaccinationsData) _then;

/// Create a copy of VaccinationsData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? byType = null,Object? upcoming = null,}) {
  return _then(_VaccinationsData(
byType: null == byType ? _self._byType : byType // ignore: cast_nullable_to_non_nullable
as List<VaccineTypeCount>,upcoming: null == upcoming ? _self._upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as List<dynamic>,
  ));
}


}


/// @nodoc
mixin _$VaccineTypeCount {

@JsonKey(name: 'vaccine_name') String get vaccineName;@IntConverter() int get count;
/// Create a copy of VaccineTypeCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VaccineTypeCountCopyWith<VaccineTypeCount> get copyWith => _$VaccineTypeCountCopyWithImpl<VaccineTypeCount>(this as VaccineTypeCount, _$identity);

  /// Serializes this VaccineTypeCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as VaccineTypeCount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VaccineTypeCount&&(identical(other.vaccineName, _this.vaccineName) || other.vaccineName == _this.vaccineName)&&(identical(other.count, _this.count) || other.count == _this.count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VaccineTypeCount;
  return Object.hash(runtimeType,_this.vaccineName,_this.count);
}

@override
String toString() {
  final _this = this as VaccineTypeCount;
  return 'VaccineTypeCount(vaccineName: ${_this.vaccineName}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $VaccineTypeCountCopyWith<$Res>  {
  factory $VaccineTypeCountCopyWith(VaccineTypeCount value, $Res Function(VaccineTypeCount) _then) = _$VaccineTypeCountCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'vaccine_name') String vaccineName,@IntConverter() int count
});




}
/// @nodoc
class _$VaccineTypeCountCopyWithImpl<$Res>
    implements $VaccineTypeCountCopyWith<$Res> {
  _$VaccineTypeCountCopyWithImpl(this._self, this._then);

  final VaccineTypeCount _self;
  final $Res Function(VaccineTypeCount) _then;

/// Create a copy of VaccineTypeCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vaccineName = null,Object? count = null,}) {
  return _then(VaccineTypeCount(
vaccineName: null == vaccineName ? _self.vaccineName : vaccineName // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [VaccineTypeCount].
extension VaccineTypeCountPatterns on VaccineTypeCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VaccineTypeCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VaccineTypeCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VaccineTypeCount value)  $default,){
final _that = this;
switch (_that) {
case _VaccineTypeCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VaccineTypeCount value)?  $default,){
final _that = this;
switch (_that) {
case _VaccineTypeCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'vaccine_name')  String vaccineName, @IntConverter()  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VaccineTypeCount() when $default != null:
return $default(_that.vaccineName,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'vaccine_name')  String vaccineName, @IntConverter()  int count)  $default,) {final _that = this;
switch (_that) {
case _VaccineTypeCount():
return $default(_that.vaccineName,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'vaccine_name')  String vaccineName, @IntConverter()  int count)?  $default,) {final _that = this;
switch (_that) {
case _VaccineTypeCount() when $default != null:
return $default(_that.vaccineName,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VaccineTypeCount implements VaccineTypeCount {
  const _VaccineTypeCount({@JsonKey(name: 'vaccine_name') required this.vaccineName, @IntConverter() required this.count});
  factory _VaccineTypeCount.fromJson(Map<String, dynamic> json) => _$VaccineTypeCountFromJson(json);

@override@JsonKey(name: 'vaccine_name') final  String vaccineName;
@override@IntConverter() final  int count;

/// Create a copy of VaccineTypeCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VaccineTypeCountCopyWith<_VaccineTypeCount> get copyWith => __$VaccineTypeCountCopyWithImpl<_VaccineTypeCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VaccineTypeCountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VaccineTypeCount&&(identical(other.vaccineName, vaccineName) || other.vaccineName == vaccineName)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,vaccineName,count);
}

@override
String toString() {
    return 'VaccineTypeCount(vaccineName: $vaccineName, count: $count)';
}


}

/// @nodoc
abstract mixin class _$VaccineTypeCountCopyWith<$Res> implements $VaccineTypeCountCopyWith<$Res> {
  factory _$VaccineTypeCountCopyWith(_VaccineTypeCount value, $Res Function(_VaccineTypeCount) _then) = __$VaccineTypeCountCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'vaccine_name') String vaccineName,@IntConverter() int count
});




}
/// @nodoc
class __$VaccineTypeCountCopyWithImpl<$Res>
    implements _$VaccineTypeCountCopyWith<$Res> {
  __$VaccineTypeCountCopyWithImpl(this._self, this._then);

  final _VaccineTypeCount _self;
  final $Res Function(_VaccineTypeCount) _then;

/// Create a copy of VaccineTypeCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vaccineName = null,Object? count = null,}) {
  return _then(_VaccineTypeCount(
vaccineName: null == vaccineName ? _self.vaccineName : vaccineName // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MedicalRecordsData {

@JsonKey(name: 'by_outcome') List<RecordOutcomeCount> get byOutcome;
/// Create a copy of MedicalRecordsData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicalRecordsDataCopyWith<MedicalRecordsData> get copyWith => _$MedicalRecordsDataCopyWithImpl<MedicalRecordsData>(this as MedicalRecordsData, _$identity);

  /// Serializes this MedicalRecordsData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MedicalRecordsData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MedicalRecordsData&&const DeepCollectionEquality().equals(other.byOutcome, _this.byOutcome));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MedicalRecordsData;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.byOutcome));
}

@override
String toString() {
  final _this = this as MedicalRecordsData;
  return 'MedicalRecordsData(byOutcome: ${_this.byOutcome})';
}


}

/// @nodoc
abstract mixin class $MedicalRecordsDataCopyWith<$Res>  {
  factory $MedicalRecordsDataCopyWith(MedicalRecordsData value, $Res Function(MedicalRecordsData) _then) = _$MedicalRecordsDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'by_outcome') List<RecordOutcomeCount> byOutcome
});




}
/// @nodoc
class _$MedicalRecordsDataCopyWithImpl<$Res>
    implements $MedicalRecordsDataCopyWith<$Res> {
  _$MedicalRecordsDataCopyWithImpl(this._self, this._then);

  final MedicalRecordsData _self;
  final $Res Function(MedicalRecordsData) _then;

/// Create a copy of MedicalRecordsData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? byOutcome = null,}) {
  return _then(MedicalRecordsData(
byOutcome: null == byOutcome ? _self.byOutcome : byOutcome // ignore: cast_nullable_to_non_nullable
as List<RecordOutcomeCount>,
  ));
}

}


/// Adds pattern-matching-related methods to [MedicalRecordsData].
extension MedicalRecordsDataPatterns on MedicalRecordsData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MedicalRecordsData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MedicalRecordsData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MedicalRecordsData value)  $default,){
final _that = this;
switch (_that) {
case _MedicalRecordsData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MedicalRecordsData value)?  $default,){
final _that = this;
switch (_that) {
case _MedicalRecordsData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'by_outcome')  List<RecordOutcomeCount> byOutcome)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MedicalRecordsData() when $default != null:
return $default(_that.byOutcome);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'by_outcome')  List<RecordOutcomeCount> byOutcome)  $default,) {final _that = this;
switch (_that) {
case _MedicalRecordsData():
return $default(_that.byOutcome);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'by_outcome')  List<RecordOutcomeCount> byOutcome)?  $default,) {final _that = this;
switch (_that) {
case _MedicalRecordsData() when $default != null:
return $default(_that.byOutcome);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MedicalRecordsData implements MedicalRecordsData {
  const _MedicalRecordsData({@JsonKey(name: 'by_outcome')  List<RecordOutcomeCount> byOutcome = const []}): _byOutcome = byOutcome;
  factory _MedicalRecordsData.fromJson(Map<String, dynamic> json) => _$MedicalRecordsDataFromJson(json);

 final  List<RecordOutcomeCount> _byOutcome;
@override@JsonKey(name: 'by_outcome') List<RecordOutcomeCount> get byOutcome {
  if (_byOutcome is EqualUnmodifiableListView) return _byOutcome;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_byOutcome);
}


/// Create a copy of MedicalRecordsData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicalRecordsDataCopyWith<_MedicalRecordsData> get copyWith => __$MedicalRecordsDataCopyWithImpl<_MedicalRecordsData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicalRecordsDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MedicalRecordsData&&const DeepCollectionEquality().equals(other.byOutcome, _byOutcome));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_byOutcome));
}

@override
String toString() {
    return 'MedicalRecordsData(byOutcome: $byOutcome)';
}


}

/// @nodoc
abstract mixin class _$MedicalRecordsDataCopyWith<$Res> implements $MedicalRecordsDataCopyWith<$Res> {
  factory _$MedicalRecordsDataCopyWith(_MedicalRecordsData value, $Res Function(_MedicalRecordsData) _then) = __$MedicalRecordsDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'by_outcome') List<RecordOutcomeCount> byOutcome
});




}
/// @nodoc
class __$MedicalRecordsDataCopyWithImpl<$Res>
    implements _$MedicalRecordsDataCopyWith<$Res> {
  __$MedicalRecordsDataCopyWithImpl(this._self, this._then);

  final _MedicalRecordsData _self;
  final $Res Function(_MedicalRecordsData) _then;

/// Create a copy of MedicalRecordsData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? byOutcome = null,}) {
  return _then(_MedicalRecordsData(
byOutcome: null == byOutcome ? _self._byOutcome : byOutcome // ignore: cast_nullable_to_non_nullable
as List<RecordOutcomeCount>,
  ));
}


}


/// @nodoc
mixin _$RecordOutcomeCount {

 String? get outcome;@IntConverter() int get count;
/// Create a copy of RecordOutcomeCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecordOutcomeCountCopyWith<RecordOutcomeCount> get copyWith => _$RecordOutcomeCountCopyWithImpl<RecordOutcomeCount>(this as RecordOutcomeCount, _$identity);

  /// Serializes this RecordOutcomeCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RecordOutcomeCount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecordOutcomeCount&&(identical(other.outcome, _this.outcome) || other.outcome == _this.outcome)&&(identical(other.count, _this.count) || other.count == _this.count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RecordOutcomeCount;
  return Object.hash(runtimeType,_this.outcome,_this.count);
}

@override
String toString() {
  final _this = this as RecordOutcomeCount;
  return 'RecordOutcomeCount(outcome: ${_this.outcome}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $RecordOutcomeCountCopyWith<$Res>  {
  factory $RecordOutcomeCountCopyWith(RecordOutcomeCount value, $Res Function(RecordOutcomeCount) _then) = _$RecordOutcomeCountCopyWithImpl;
@useResult
$Res call({
 String? outcome,@IntConverter() int count
});




}
/// @nodoc
class _$RecordOutcomeCountCopyWithImpl<$Res>
    implements $RecordOutcomeCountCopyWith<$Res> {
  _$RecordOutcomeCountCopyWithImpl(this._self, this._then);

  final RecordOutcomeCount _self;
  final $Res Function(RecordOutcomeCount) _then;

/// Create a copy of RecordOutcomeCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? outcome = freezed,Object? count = null,}) {
  return _then(RecordOutcomeCount(
outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RecordOutcomeCount].
extension RecordOutcomeCountPatterns on RecordOutcomeCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecordOutcomeCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecordOutcomeCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecordOutcomeCount value)  $default,){
final _that = this;
switch (_that) {
case _RecordOutcomeCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecordOutcomeCount value)?  $default,){
final _that = this;
switch (_that) {
case _RecordOutcomeCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? outcome, @IntConverter()  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecordOutcomeCount() when $default != null:
return $default(_that.outcome,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? outcome, @IntConverter()  int count)  $default,) {final _that = this;
switch (_that) {
case _RecordOutcomeCount():
return $default(_that.outcome,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? outcome, @IntConverter()  int count)?  $default,) {final _that = this;
switch (_that) {
case _RecordOutcomeCount() when $default != null:
return $default(_that.outcome,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecordOutcomeCount implements RecordOutcomeCount {
  const _RecordOutcomeCount({this.outcome, @IntConverter() required this.count});
  factory _RecordOutcomeCount.fromJson(Map<String, dynamic> json) => _$RecordOutcomeCountFromJson(json);

@override final  String? outcome;
@override@IntConverter() final  int count;

/// Create a copy of RecordOutcomeCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecordOutcomeCountCopyWith<_RecordOutcomeCount> get copyWith => __$RecordOutcomeCountCopyWithImpl<_RecordOutcomeCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecordOutcomeCountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecordOutcomeCount&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,outcome,count);
}

@override
String toString() {
    return 'RecordOutcomeCount(outcome: $outcome, count: $count)';
}


}

/// @nodoc
abstract mixin class _$RecordOutcomeCountCopyWith<$Res> implements $RecordOutcomeCountCopyWith<$Res> {
  factory _$RecordOutcomeCountCopyWith(_RecordOutcomeCount value, $Res Function(_RecordOutcomeCount) _then) = __$RecordOutcomeCountCopyWithImpl;
@override @useResult
$Res call({
 String? outcome,@IntConverter() int count
});




}
/// @nodoc
class __$RecordOutcomeCountCopyWithImpl<$Res>
    implements _$RecordOutcomeCountCopyWith<$Res> {
  __$RecordOutcomeCountCopyWithImpl(this._self, this._then);

  final _RecordOutcomeCount _self;
  final $Res Function(_RecordOutcomeCount) _then;

/// Create a copy of RecordOutcomeCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? outcome = freezed,Object? count = null,}) {
  return _then(_RecordOutcomeCount(
outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String?,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$FinancialReport {

 FinancialReportSummary get summary;@JsonKey(name: 'by_category') List<CategoryData> get byCategory;
/// Create a copy of FinancialReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialReportCopyWith<FinancialReport> get copyWith => _$FinancialReportCopyWithImpl<FinancialReport>(this as FinancialReport, _$identity);

  /// Serializes this FinancialReport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FinancialReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialReport&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&const DeepCollectionEquality().equals(other.byCategory, _this.byCategory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FinancialReport;
  return Object.hash(runtimeType,_this.summary,const DeepCollectionEquality().hash(_this.byCategory));
}

@override
String toString() {
  final _this = this as FinancialReport;
  return 'FinancialReport(summary: ${_this.summary}, byCategory: ${_this.byCategory})';
}


}

/// @nodoc
abstract mixin class $FinancialReportCopyWith<$Res>  {
  factory $FinancialReportCopyWith(FinancialReport value, $Res Function(FinancialReport) _then) = _$FinancialReportCopyWithImpl;
@useResult
$Res call({
 FinancialReportSummary summary,@JsonKey(name: 'by_category') List<CategoryData> byCategory
});


$FinancialReportSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class _$FinancialReportCopyWithImpl<$Res>
    implements $FinancialReportCopyWith<$Res> {
  _$FinancialReportCopyWithImpl(this._self, this._then);

  final FinancialReport _self;
  final $Res Function(FinancialReport) _then;

/// Create a copy of FinancialReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? summary = null,Object? byCategory = null,}) {
  return _then(FinancialReport(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as FinancialReportSummary,byCategory: null == byCategory ? _self.byCategory : byCategory // ignore: cast_nullable_to_non_nullable
as List<CategoryData>,
  ));
}
/// Create a copy of FinancialReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FinancialReportSummaryCopyWith<$Res> get summary {
  
  return $FinancialReportSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [FinancialReport].
extension FinancialReportPatterns on FinancialReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialReport value)  $default,){
final _that = this;
switch (_that) {
case _FinancialReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialReport value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FinancialReportSummary summary, @JsonKey(name: 'by_category')  List<CategoryData> byCategory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinancialReport() when $default != null:
return $default(_that.summary,_that.byCategory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FinancialReportSummary summary, @JsonKey(name: 'by_category')  List<CategoryData> byCategory)  $default,) {final _that = this;
switch (_that) {
case _FinancialReport():
return $default(_that.summary,_that.byCategory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FinancialReportSummary summary, @JsonKey(name: 'by_category')  List<CategoryData> byCategory)?  $default,) {final _that = this;
switch (_that) {
case _FinancialReport() when $default != null:
return $default(_that.summary,_that.byCategory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinancialReport implements FinancialReport {
  const _FinancialReport({required this.summary, @JsonKey(name: 'by_category') required  List<CategoryData> byCategory}): _byCategory = byCategory;
  factory _FinancialReport.fromJson(Map<String, dynamic> json) => _$FinancialReportFromJson(json);

@override final  FinancialReportSummary summary;
 final  List<CategoryData> _byCategory;
@override@JsonKey(name: 'by_category') List<CategoryData> get byCategory {
  if (_byCategory is EqualUnmodifiableListView) return _byCategory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_byCategory);
}


/// Create a copy of FinancialReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialReportCopyWith<_FinancialReport> get copyWith => __$FinancialReportCopyWithImpl<_FinancialReport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinancialReportToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialReport&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.byCategory, _byCategory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(_byCategory));
}

@override
String toString() {
    return 'FinancialReport(summary: $summary, byCategory: $byCategory)';
}


}

/// @nodoc
abstract mixin class _$FinancialReportCopyWith<$Res> implements $FinancialReportCopyWith<$Res> {
  factory _$FinancialReportCopyWith(_FinancialReport value, $Res Function(_FinancialReport) _then) = __$FinancialReportCopyWithImpl;
@override @useResult
$Res call({
 FinancialReportSummary summary,@JsonKey(name: 'by_category') List<CategoryData> byCategory
});


@override $FinancialReportSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class __$FinancialReportCopyWithImpl<$Res>
    implements _$FinancialReportCopyWith<$Res> {
  __$FinancialReportCopyWithImpl(this._self, this._then);

  final _FinancialReport _self;
  final $Res Function(_FinancialReport) _then;

/// Create a copy of FinancialReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? byCategory = null,}) {
  return _then(_FinancialReport(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as FinancialReportSummary,byCategory: null == byCategory ? _self._byCategory : byCategory // ignore: cast_nullable_to_non_nullable
as List<CategoryData>,
  ));
}

/// Create a copy of FinancialReport
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FinancialReportSummaryCopyWith<$Res> get summary {
  
  return $FinancialReportSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// @nodoc
mixin _$FinancialReportSummary {

@JsonKey(name: 'total_income')@DoubleConverter() double get totalIncome;@JsonKey(name: 'total_expenses')@DoubleConverter() double get totalExpenses;@JsonKey(name: 'net_profit')@DoubleConverter() double get netProfit;
/// Create a copy of FinancialReportSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialReportSummaryCopyWith<FinancialReportSummary> get copyWith => _$FinancialReportSummaryCopyWithImpl<FinancialReportSummary>(this as FinancialReportSummary, _$identity);

  /// Serializes this FinancialReportSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FinancialReportSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialReportSummary&&(identical(other.totalIncome, _this.totalIncome) || other.totalIncome == _this.totalIncome)&&(identical(other.totalExpenses, _this.totalExpenses) || other.totalExpenses == _this.totalExpenses)&&(identical(other.netProfit, _this.netProfit) || other.netProfit == _this.netProfit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FinancialReportSummary;
  return Object.hash(runtimeType,_this.totalIncome,_this.totalExpenses,_this.netProfit);
}

@override
String toString() {
  final _this = this as FinancialReportSummary;
  return 'FinancialReportSummary(totalIncome: ${_this.totalIncome}, totalExpenses: ${_this.totalExpenses}, netProfit: ${_this.netProfit})';
}


}

/// @nodoc
abstract mixin class $FinancialReportSummaryCopyWith<$Res>  {
  factory $FinancialReportSummaryCopyWith(FinancialReportSummary value, $Res Function(FinancialReportSummary) _then) = _$FinancialReportSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_income')@DoubleConverter() double totalIncome,@JsonKey(name: 'total_expenses')@DoubleConverter() double totalExpenses,@JsonKey(name: 'net_profit')@DoubleConverter() double netProfit
});




}
/// @nodoc
class _$FinancialReportSummaryCopyWithImpl<$Res>
    implements $FinancialReportSummaryCopyWith<$Res> {
  _$FinancialReportSummaryCopyWithImpl(this._self, this._then);

  final FinancialReportSummary _self;
  final $Res Function(FinancialReportSummary) _then;

/// Create a copy of FinancialReportSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalIncome = null,Object? totalExpenses = null,Object? netProfit = null,}) {
  return _then(FinancialReportSummary(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpenses: null == totalExpenses ? _self.totalExpenses : totalExpenses // ignore: cast_nullable_to_non_nullable
as double,netProfit: null == netProfit ? _self.netProfit : netProfit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FinancialReportSummary].
extension FinancialReportSummaryPatterns on FinancialReportSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialReportSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialReportSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialReportSummary value)  $default,){
final _that = this;
switch (_that) {
case _FinancialReportSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialReportSummary value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialReportSummary() when $default != null:
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
case _FinancialReportSummary() when $default != null:
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
case _FinancialReportSummary():
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
case _FinancialReportSummary() when $default != null:
return $default(_that.totalIncome,_that.totalExpenses,_that.netProfit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinancialReportSummary implements FinancialReportSummary {
  const _FinancialReportSummary({@JsonKey(name: 'total_income')@DoubleConverter() required this.totalIncome, @JsonKey(name: 'total_expenses')@DoubleConverter() required this.totalExpenses, @JsonKey(name: 'net_profit')@DoubleConverter() required this.netProfit});
  factory _FinancialReportSummary.fromJson(Map<String, dynamic> json) => _$FinancialReportSummaryFromJson(json);

@override@JsonKey(name: 'total_income')@DoubleConverter() final  double totalIncome;
@override@JsonKey(name: 'total_expenses')@DoubleConverter() final  double totalExpenses;
@override@JsonKey(name: 'net_profit')@DoubleConverter() final  double netProfit;

/// Create a copy of FinancialReportSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialReportSummaryCopyWith<_FinancialReportSummary> get copyWith => __$FinancialReportSummaryCopyWithImpl<_FinancialReportSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinancialReportSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialReportSummary&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpenses, totalExpenses) || other.totalExpenses == totalExpenses)&&(identical(other.netProfit, netProfit) || other.netProfit == netProfit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalIncome,totalExpenses,netProfit);
}

@override
String toString() {
    return 'FinancialReportSummary(totalIncome: $totalIncome, totalExpenses: $totalExpenses, netProfit: $netProfit)';
}


}

/// @nodoc
abstract mixin class _$FinancialReportSummaryCopyWith<$Res> implements $FinancialReportSummaryCopyWith<$Res> {
  factory _$FinancialReportSummaryCopyWith(_FinancialReportSummary value, $Res Function(_FinancialReportSummary) _then) = __$FinancialReportSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_income')@DoubleConverter() double totalIncome,@JsonKey(name: 'total_expenses')@DoubleConverter() double totalExpenses,@JsonKey(name: 'net_profit')@DoubleConverter() double netProfit
});




}
/// @nodoc
class __$FinancialReportSummaryCopyWithImpl<$Res>
    implements _$FinancialReportSummaryCopyWith<$Res> {
  __$FinancialReportSummaryCopyWithImpl(this._self, this._then);

  final _FinancialReportSummary _self;
  final $Res Function(_FinancialReportSummary) _then;

/// Create a copy of FinancialReportSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalIncome = null,Object? totalExpenses = null,Object? netProfit = null,}) {
  return _then(_FinancialReportSummary(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpenses: null == totalExpenses ? _self.totalExpenses : totalExpenses // ignore: cast_nullable_to_non_nullable
as double,netProfit: null == netProfit ? _self.netProfit : netProfit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$CategoryData {

 String get type; String get category;@DoubleConverter() double get total;@IntConverter() int get count;
/// Create a copy of CategoryData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryDataCopyWith<CategoryData> get copyWith => _$CategoryDataCopyWithImpl<CategoryData>(this as CategoryData, _$identity);

  /// Serializes this CategoryData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CategoryData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryData&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.count, _this.count) || other.count == _this.count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CategoryData;
  return Object.hash(runtimeType,_this.type,_this.category,_this.total,_this.count);
}

@override
String toString() {
  final _this = this as CategoryData;
  return 'CategoryData(type: ${_this.type}, category: ${_this.category}, total: ${_this.total}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $CategoryDataCopyWith<$Res>  {
  factory $CategoryDataCopyWith(CategoryData value, $Res Function(CategoryData) _then) = _$CategoryDataCopyWithImpl;
@useResult
$Res call({
 String type, String category,@DoubleConverter() double total,@IntConverter() int count
});




}
/// @nodoc
class _$CategoryDataCopyWithImpl<$Res>
    implements $CategoryDataCopyWith<$Res> {
  _$CategoryDataCopyWithImpl(this._self, this._then);

  final CategoryData _self;
  final $Res Function(CategoryData) _then;

/// Create a copy of CategoryData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? category = null,Object? total = null,Object? count = null,}) {
  return _then(CategoryData(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryData].
extension CategoryDataPatterns on CategoryData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryData value)  $default,){
final _that = this;
switch (_that) {
case _CategoryData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryData value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String category, @DoubleConverter()  double total, @IntConverter()  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryData() when $default != null:
return $default(_that.type,_that.category,_that.total,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String category, @DoubleConverter()  double total, @IntConverter()  int count)  $default,) {final _that = this;
switch (_that) {
case _CategoryData():
return $default(_that.type,_that.category,_that.total,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String category, @DoubleConverter()  double total, @IntConverter()  int count)?  $default,) {final _that = this;
switch (_that) {
case _CategoryData() when $default != null:
return $default(_that.type,_that.category,_that.total,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryData implements CategoryData {
  const _CategoryData({required this.type, required this.category, @DoubleConverter() required this.total, @IntConverter() required this.count});
  factory _CategoryData.fromJson(Map<String, dynamic> json) => _$CategoryDataFromJson(json);

@override final  String type;
@override final  String category;
@override@DoubleConverter() final  double total;
@override@IntConverter() final  int count;

/// Create a copy of CategoryData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryDataCopyWith<_CategoryData> get copyWith => __$CategoryDataCopyWithImpl<_CategoryData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryDataToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryData&&(identical(other.type, type) || other.type == type)&&(identical(other.category, category) || other.category == category)&&(identical(other.total, total) || other.total == total)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,category,total,count);
}

@override
String toString() {
    return 'CategoryData(type: $type, category: $category, total: $total, count: $count)';
}


}

/// @nodoc
abstract mixin class _$CategoryDataCopyWith<$Res> implements $CategoryDataCopyWith<$Res> {
  factory _$CategoryDataCopyWith(_CategoryData value, $Res Function(_CategoryData) _then) = __$CategoryDataCopyWithImpl;
@override @useResult
$Res call({
 String type, String category,@DoubleConverter() double total,@IntConverter() int count
});




}
/// @nodoc
class __$CategoryDataCopyWithImpl<$Res>
    implements _$CategoryDataCopyWith<$Res> {
  __$CategoryDataCopyWithImpl(this._self, this._then);

  final _CategoryData _self;
  final $Res Function(_CategoryData) _then;

/// Create a copy of CategoryData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? category = null,Object? total = null,Object? count = null,}) {
  return _then(_CategoryData(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
