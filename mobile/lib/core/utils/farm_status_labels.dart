import 'package:flutter/material.dart';

import '../l10n/l10n_context.dart';
import '../theme/theme.dart';

/// Подписи и цвета уровней доступа фермы.
///
/// Общие для обеих сторон: платформенный админ видит их на карточке фермы
/// (выбор статуса, подтверждение), а сама ферма — на баннере о собственном
/// доступе (`FarmStatusBanner`). Расходиться эти места не должны — отсюда
/// одно место в `core`, а не дублирование текста в каждой фиче.

/// Уровни доступа в том порядке, в котором их предлагают админу: от обычной
/// работы к полному закрытию.
const List<String> kFarmStatuses = ['active', 'read_only', 'suspended'];

String farmStatusLabel(BuildContext context, String status) {
  final l10n = context.l10n;
  return switch (status) {
    'active' => l10n.platformFarmStatusActive,
    'read_only' => l10n.platformFarmStatusReadOnly,
    'suspended' => l10n.platformFarmStatusSuspended,
    // Сервер мог обзавестись новым состоянием раньше приложения. Показать код
    // как есть честнее, чем выдать незнакомое за «работает как обычно».
    _ => l10n.platformFarmStatusUnknown(status),
  };
}

/// Что состояние означает для самой фермы. Без этой строки «только чтение»
/// приходится держать в голове.
String farmStatusHint(BuildContext context, String status) {
  final l10n = context.l10n;
  return switch (status) {
    'active' => l10n.platformFarmStatusActiveHint,
    'read_only' => l10n.platformFarmStatusReadOnlyHint,
    'suspended' => l10n.platformFarmStatusSuspendedHint,
    _ => '',
  };
}

Color farmStatusColor(BuildContext context, String status) => switch (status) {
      'active' => AppColors.success,
      'read_only' => AppColors.warning,
      'suspended' => AppColors.error,
      _ => context.colors.onSurfaceVariant,
    };

IconData farmStatusIcon(String status) => switch (status) {
      'active' => Icons.check_circle_outline,
      'read_only' => Icons.visibility_outlined,
      'suspended' => Icons.block_outlined,
      _ => Icons.help_outline,
    };
