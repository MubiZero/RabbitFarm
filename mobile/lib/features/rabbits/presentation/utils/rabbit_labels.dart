import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';

/// Подписи, значки и цвета пола кролика.
///
/// Эти три ветвления были расписаны прямо в строке карточки списка и
/// повторялись ещё в трёх местах, каждый раз чуть иначе: где-то неизвестный
/// пол назывался «Неизвестно», где-то не показывался вовсе.
String sexLabel(BuildContext context, String? sex) => switch (sex) {
      'male' => context.l10n.sexMale,
      'female' => context.l10n.sexFemale,
      _ => context.l10n.sexUnknown,
    };

IconData rabbitSexIcon(String? sex) => switch (sex) {
      'male' => Icons.male,
      'female' => Icons.female,
      _ => Icons.help_outline,
    };

Color sexColor(BuildContext context, String? sex) => switch (sex) {
      'male' => AppColors.info,
      'female' => AppColors.domainBreeding,
      _ => context.colors.onSurfaceVariant,
    };
