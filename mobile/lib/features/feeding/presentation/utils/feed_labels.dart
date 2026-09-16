import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/feed_model.dart';

/// Подписи типов корма и единиц измерения.
///
/// Раньше они жили в модели данных расширением `displayName` и были написаны
/// по-русски прямо в коде: на таджикском и узбекском экране «Гранулы» и «кг»
/// оставались русскими — а это самый частый раздел, куда заходят каждый день.
String feedTypeLabel(BuildContext context, FeedType type) => switch (type) {
      FeedType.pellets => context.l10n.feedTypePellets,
      FeedType.hay => context.l10n.feedTypeHay,
      FeedType.vegetables => context.l10n.feedTypeVegetables,
      FeedType.grain => context.l10n.feedTypeGrain,
      FeedType.supplements => context.l10n.feedTypeSupplements,
      FeedType.other => context.l10n.feedTypeOther,
    };

String feedUnitLabel(BuildContext context, FeedUnit unit) => switch (unit) {
      FeedUnit.kg => context.l10n.feedUnitKg,
      FeedUnit.liter => context.l10n.feedUnitLiter,
      FeedUnit.piece => context.l10n.feedUnitPiece,
    };

/// Визуальные признаки типов корма.
extension FeedTypeVisuals on FeedType {
  Color get color => switch (this) {
        FeedType.pellets => AppColors.accentSunset,
        FeedType.hay => AppColors.warning,
        FeedType.vegetables => AppColors.accentEmerald,
        FeedType.grain => AppColors.accentOcean,
        FeedType.supplements => AppColors.accentViolet,
        FeedType.other => AppColors.info,
      };

  IconData get icon => switch (this) {
        FeedType.pellets => Icons.grain,
        FeedType.hay => Icons.grass,
        FeedType.vegetables => Icons.eco,
        FeedType.grain => Icons.agriculture,
        FeedType.supplements => Icons.medication,
        FeedType.other => Icons.inventory_2,
      };
}

/// Коды с сервера (`kg`, `pellets`) — там, где значение приходит ключом карты
/// и его не разбирает json_serializable. Неизвестный код не роняет экран:
/// вернём `null`, а подписью станет сам код.
FeedType? feedTypeFromCode(String code) => switch (code) {
      'pellets' => FeedType.pellets,
      'hay' => FeedType.hay,
      'vegetables' => FeedType.vegetables,
      'grain' => FeedType.grain,
      'supplements' => FeedType.supplements,
      'other' => FeedType.other,
      _ => null,
    };

FeedUnit? feedUnitFromCode(String code) => switch (code) {
      'kg' => FeedUnit.kg,
      'liter' => FeedUnit.liter,
      'piece' => FeedUnit.piece,
      _ => null,
    };

/// «kg» → «кг». Незнакомую единицу показываем как есть: код с сервера
/// понятнее пустоты.
String unitLabel(BuildContext context, String code) {
  final unit = feedUnitFromCode(code);
  return unit == null ? code : feedUnitLabel(context, unit);
}
