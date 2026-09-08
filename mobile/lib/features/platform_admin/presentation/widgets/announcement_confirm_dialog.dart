import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';

/// Подтверждение отправки объявления.
///
/// Отправка необратима и уходит наружу — людям на почту и в телефон, — поэтому
/// между кнопкой «Отправить» и запросом всегда стоит этот вопрос. Ввод текста
/// здесь не нужен, в отличие от удаления фермы: ошибка обойдётся неловким
/// письмом, а не потерей данных, — но сводка «кому и чем» обязана быть перед
/// глазами, потому что именно в ней и ошибаются.
///
/// Возвращает `true`, только если админ подтвердил.
Future<bool> confirmAnnouncementSend(
  BuildContext context, {
  required String audience,
  required String channels,
}) async {
  final l10n = context.l10n;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: const Icon(Icons.campaign_outlined, color: AppColors.warning),
      title: Text(l10n.platformAnnouncementConfirmTitle),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.platformAnnouncementConfirmBody,
            style: AppTypography.bodyMd
                .copyWith(color: context.colors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.platformAnnouncementConfirmAudience(audience),
            style:
                AppTypography.bodyMd.copyWith(color: context.colors.onSurface),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.platformAnnouncementConfirmChannels(channels),
            style:
                AppTypography.bodyMd.copyWith(color: context.colors.onSurface),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          style: TextButton.styleFrom(foregroundColor: AppColors.warning),
          child: Text(l10n.platformAnnouncementSend),
        ),
      ],
    ),
  );

  return confirmed ?? false;
}
