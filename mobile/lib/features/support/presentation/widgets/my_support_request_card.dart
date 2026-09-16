import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/date_locale.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/support_request.dart';

/// Одно своё обращение: что написали, когда, ждём ли ещё ответа и сам ответ.
///
/// Ответ поддержки — главное на карточке, ради него экран и появился, поэтому
/// он выделен рамкой и подписан, а не приписан мелочью к тексту обращения.
class MySupportRequestCard extends StatelessWidget {
  const MySupportRequestCard({super.key, required this.request});

  final SupportRequest request;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final moment = DateFormat(
      'd MMM y, HH:mm',
      dateSymbolsLocale(Localizations.localeOf(context)),
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  moment.format(request.createdAt),
                  style: AppTypography.labelSm.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatusChip(answered: request.hasAnswer),
            ],
          ),
          if (request.author != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              request.author!.fullName,
              style: AppTypography.labelSm.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Text(
            request.text,
            style: AppTypography.bodyMd.copyWith(
              color: context.colors.onSurface,
            ),
          ),
          if (request.hasAnswer) ...[
            const SizedBox(height: AppSpacing.md),
            _Answer(
              text: request.answer!.trim(),
              at: request.resolvedAt,
              moment: moment,
            ),
          ] else if (request.isResolved) ...[
            const SizedBox(height: AppSpacing.sm),
            // Обращение закрыли без письменного ответа — молчащая карточка
            // выглядела бы как потерянное обращение.
            Text(
              l10n.supportRequestClosedWithoutAnswer,
              style: AppTypography.labelSm.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Answer extends StatelessWidget {
  const _Answer({required this.text, required this.at, required this.moment});

  final String text;
  final DateTime? at;
  final DateFormat moment;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border(
          left: BorderSide(color: context.colors.primary, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.support_agent_outlined,
                size: 16,
                color: context.colors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  l10n.supportRequestAnswerTitle,
                  style: AppTypography.labelSm.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ),
              if (at != null)
                Text(
                  moment.format(at!),
                  style: AppTypography.labelSm.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            text,
            style: AppTypography.bodyMd.copyWith(
              color: context.colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

/// Состояние глазами фермы, а не базы: важно не «new/resolved», а пришёл ли
/// ответ. Закрытое без ответа обращение честнее оставить «ждём ответа» —
/// объяснение про закрытие карточка даёт отдельной строкой.
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.answered});

  final bool answered;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = answered ? AppColors.success : AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        answered
            ? l10n.supportRequestStatusAnswered
            : l10n.supportRequestStatusWaiting,
        style: AppTypography.labelSm.copyWith(color: color),
      ),
    );
  }
}
