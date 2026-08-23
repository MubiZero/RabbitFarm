import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/l10n/l10n_context.dart';

/// Подписи и цвета клеток.
///
/// Раньше эти же switch-и жили внутри экранов списка и карточки клетки. Копии
/// успели разойтись: в форме создания тип `maternity` назывался «Для окрола»,
/// а в фильтрах списка — «Маточник».
String cageTypeLabel(BuildContext context, String type) => switch (type) {
      'single' => context.l10n.cageTypeSingle,
      'group' => context.l10n.cageTypeGroup,
      'maternity' => context.l10n.cageTypeMaternity,
      _ => type,
    };

String cageConditionLabel(BuildContext context, String condition) =>
    switch (condition) {
      'good' => context.l10n.cageConditionGood,
      'needs_repair' => context.l10n.cageConditionNeedsRepair,
      'broken' => context.l10n.cageConditionBroken,
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
