import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// Подписи и цвета клеток.
///
/// Раньше эти же switch-и жили внутри экранов списка и карточки клетки. Копии
/// успели разойтись: в форме создания тип `maternity` назывался «Для окрола»,
/// а в фильтрах списка — «Маточник».
String cageTypeLabel(String type) => switch (type) {
      'single' => 'Одиночная',
      'group' => 'Групповая',
      'maternity' => 'Для окрола',
      _ => type,
    };

String cageConditionLabel(String condition) => switch (condition) {
      'good' => 'В порядке',
      'needs_repair' => 'Нужен ремонт',
      'broken' => 'Сломана',
      _ => condition,
    };

Color cageConditionColor(BuildContext context, String condition) =>
    switch (condition) {
      'good' => AppColors.success,
      'needs_repair' => AppColors.warning,
      'broken' => AppColors.error,
      _ => context.colors.onSurfaceVariant,
    };

IconData cageTypeIcon(String type) => switch (type) {
      'single' => Icons.crop_square,
      'group' => Icons.grid_view,
      'maternity' => Icons.child_friendly,
      _ => Icons.grid_view_outlined,
    };
