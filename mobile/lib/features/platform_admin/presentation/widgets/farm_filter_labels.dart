import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../providers/platform_admin_provider.dart';

/// Подписи и цвета срезов списка ферм.
///
/// Живут отдельно от вкладки ферм: тот же срез выбирают, когда адресуют
/// объявление, и в истории объявлений его же показывают строкой. Три места с
/// собственным списком подписей разошлись бы при первой же правке
/// формулировки.

String farmFilterLabel(BuildContext context, PlatformFarmFilter filter) {
  final l10n = context.l10n;
  return switch (filter) {
    PlatformFarmFilter.noPlan => l10n.platformNoPlan,
    PlatformFarmFilter.atLimit => l10n.platformAtLimit,
    // Подпись та же, что у состояния фермы на её карточке: одно состояние —
    // одно название, иначе «приостановлена» в списке и «доступ закрыт» в
    // карточке читались бы как разные вещи.
    PlatformFarmFilter.suspended => l10n.platformFarmStatusSuspended,
    PlatformFarmFilter.expired => l10n.platformFilterExpired,
    // Порог фиксирован (30 дней) — чипу не нужен свой пикер, чтобы включить
    // срез одним касанием; сервер это же значение подставляет по умолчанию,
    // если `days` не передан.
    PlatformFarmFilter.inactiveDays => l10n.platformFilterInactive(30),
  };
}

/// Тревожность среза. `null` — обычный, без подкраски: «без тарифа» и «не
/// заходили» сами по себе не беда, а «упёрлась в предел» и «доступ закрыт» —
/// повод вмешаться.
Color? farmFilterColor(PlatformFarmFilter filter) => switch (filter) {
      PlatformFarmFilter.atLimit => AppColors.error,
      PlatformFarmFilter.suspended => AppColors.error,
      PlatformFarmFilter.expired => AppColors.warning,
      PlatformFarmFilter.noPlan => null,
      PlatformFarmFilter.inactiveDays => null,
    };

/// Срез, записанный в объявлении, — словами. Незнакомое значение показываем
/// как есть: сервер мог обзавестись новым срезом раньше приложения.
String farmFilterLabelOf(BuildContext context, String? apiValue) {
  final filter = platformFarmFilterOf(apiValue);
  return filter == null
      ? context.l10n.platformFilterUnknown(apiValue ?? '')
      : farmFilterLabel(context, filter);
}
