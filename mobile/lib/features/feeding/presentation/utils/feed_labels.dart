import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/feed_model.dart';

/// Визуальные признаки типов корма. Подписи берутся из `displayName`
/// в модели — здесь только то, что относится к отображению.
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

/// «kg» → «кг». Незнакомую единицу показываем как есть.
String unitLabel(String code) => feedUnitFromCode(code)?.displayName ?? code;
