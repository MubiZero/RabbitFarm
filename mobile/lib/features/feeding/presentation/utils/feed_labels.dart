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
