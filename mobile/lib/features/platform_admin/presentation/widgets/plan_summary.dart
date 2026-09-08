import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/utils/format_utils.dart';
import '../../data/models/platform_admin_models.dart';

/// Подписи тарифа человеческим языком.
///
/// Живут отдельно от карточек: одну и ту же строку показывают и список
/// тарифов, и лист выбора тарифа для фермы, и расходиться они не должны.

/// Что тариф разрешает: «до 200 кроликов · до 5 человек».
///
/// Отсутствие предела — это «без ограничений», а не «0»: у тарифа может не
/// быть предела по одному ресурсу и быть по другому.
String planLimitsSummary(BuildContext context, Plan plan) {
  final l10n = context.l10n;
  if (plan.isUnlimited) return l10n.platformPlanUnlimited;

  return [
    if (plan.maxRabbits != null) l10n.platformPlanLimitRabbits(plan.maxRabbits!),
    if (plan.maxStaff != null) l10n.platformPlanLimitStaff(plan.maxStaff!),
  ].join(' · ');
}

/// Цена тарифа. Пусто и ноль — это «бесплатный», и так и написано: пустое
/// место на карточке читалось бы как «цену забыли указать».
String planPriceLabel(BuildContext context, Plan plan) {
  final price = plan.price;
  if (price == null || price == 0) return context.l10n.platformPlanFree;
  return formatMoney(price);
}
