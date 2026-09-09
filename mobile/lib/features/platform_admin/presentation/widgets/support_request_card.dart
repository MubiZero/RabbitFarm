import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/platform_admin_models.dart';

final _momentFormat = DateFormat('dd.MM.yyyy HH:mm');

/// Одно обращение фермы в поддержку — текст, кто и когда написал, и статус.
///
/// Кнопка «Отметить разобранным» показана только у необработанных: разобранное
/// уже сказало всё, что могло, — второй раз нажимать там нечего.
class SupportRequestCard extends StatelessWidget {
  const SupportRequestCard({
    super.key,
    required this.request,
    required this.onResolve,
  });

  final SupportRequest request;

  /// `null`, пока идёт собственный запрос на разбор — кнопка сама гасит себя,
  /// а не полагается на внешний busy-флаг на весь список.
  final Future<void> Function()? onResolve;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  request.farm?.name ?? l10n.platformOwnerMissing,
                  style: AppTypography.titleMd
                      .copyWith(color: context.colors.onSurface),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatusChip(resolved: request.isResolved),
            ],
          ),
          if (request.author != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              request.author!.fullName,
              style: AppTypography.labelSm
                  .copyWith(color: context.colors.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Text(
            request.text,
            style: AppTypography.bodyMd.copyWith(color: context.colors.onSurface),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(Icons.schedule, size: 14, color: context.colors.onSurfaceVariant),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  _momentFormat.format(request.createdAt),
                  style: AppTypography.labelSm
                      .copyWith(color: context.colors.onSurfaceVariant),
                ),
              ),
            ],
          ),
          // Кнопка на своей строке, а не в один ряд с датой: с длинной
          // подписью «Отметить разобранным» ряд не помещается на узком
          // экране (см. переполнение в виджет-тесте на 420 px).
          if (!request.isResolved && onResolve != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onResolve,
                child: Text(l10n.platformSupportRequestResolve),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.resolved});

  final bool resolved;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = resolved ? context.colors.onSurfaceVariant : AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        resolved
            ? l10n.platformSupportRequestResolved
            : l10n.platformSupportRequestNew,
        style: AppTypography.labelSm.copyWith(color: color),
      ),
    );
  }
}
