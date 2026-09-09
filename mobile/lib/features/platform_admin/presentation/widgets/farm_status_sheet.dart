import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/farm_status_labels.dart';

/// Выбор уровня доступа фермы.
///
/// Возвращает выбранное состояние или `null`, если лист закрыли, ничего не
/// выбрав. Само применение здесь не происходит: последствия ощутимы для
/// клиента, поэтому между выбором и запросом стоит подтверждение — его
/// показывает вызывающий экран.
Future<String?> showFarmStatusPicker(
  BuildContext context, {
  required String farmName,
  required String currentStatus,
}) {
  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => _FarmStatusSheet(
      farmName: farmName,
      currentStatus: currentStatus,
    ),
  );
}

class _FarmStatusSheet extends StatelessWidget {
  const _FarmStatusSheet({
    required this.farmName,
    required this.currentStatus,
  });

  final String farmName;
  final String currentStatus;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                0,
                AppSpacing.screenH,
                AppSpacing.md,
              ),
              child: Text(
                context.l10n.platformFarmStatusSheetTitle(farmName),
                style: AppTypography.titleMd
                    .copyWith(color: context.colors.onSurface),
              ),
            ),
            for (final status in kFarmStatuses)
              ListTile(
                leading: Icon(
                  status == currentStatus
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: status == currentStatus
                      ? farmStatusColor(context, status)
                      : context.colors.onSurfaceVariant,
                ),
                title: Text(farmStatusLabel(context, status)),
                subtitle: Text(farmStatusHint(context, status)),
                onTap: () => Navigator.pop(context, status),
              ),
          ],
        ),
      ),
    );
  }
}
