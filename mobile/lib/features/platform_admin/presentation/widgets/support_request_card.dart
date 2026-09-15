import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/platform_admin_models.dart';
import 'support_resolve_dialog.dart';

final _momentFormat = DateFormat('dd.MM.yyyy HH:mm');

/// Одно обращение фермы в поддержку — текст, кто и когда написал, как с ним
/// связаться, статус и ответ, если он был.
///
/// Почта и телефон автора показаны нажимаемыми: другого способа связаться с
/// человеком у поддержки нет, а переписывать номер с экрана вручную — это
/// ошибка в одной цифре и звонок не туда.
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

  /// Закрыть обращение. Получает ответ автору или `null`, если админ закрыл
  /// молча. `null` у самого обработчика — пока идёт собственный запрос на
  /// разбор: кнопка сама гасит себя, а не полагается на внешний busy-флаг на
  /// весь список.
  final Future<void> Function(String? answer)? onResolve;

  Future<void> _resolve(BuildContext context) async {
    final choice = await showSupportResolveDialog(context);
    if (choice == null) return;
    await onResolve?.call(choice.answer);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final author = request.author;

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
                  style: AppTypography.titleMd.copyWith(
                    color: context.colors.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatusChip(resolved: request.isResolved),
            ],
          ),
          if (author != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              author.fullName,
              style: AppTypography.labelSm.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            if (author.phone != null)
              _ContactRow(
                icon: Icons.phone_outlined,
                label: author.phone!,
                onTap: () => launchUrl(Uri(scheme: 'tel', path: author.phone)),
              ),
            if (author.email != null)
              _ContactRow(
                icon: Icons.email_outlined,
                label: author.email!,
                onTap: () =>
                    launchUrl(Uri(scheme: 'mailto', path: author.email)),
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
            _AnswerBlock(text: request.answer!.trim()),
          ],
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 14,
                color: context.colors.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  _momentFormat.format(request.createdAt),
                  style: AppTypography.labelSm.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
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
                onPressed: () => _resolve(context),
                child: Text(l10n.platformSupportRequestResolve),
              ),
            ),
        ],
      ),
    );
  }
}

/// Что уже ответили автору — чтобы второй админ не отвечал то же самое
/// заново.
class _AnswerBlock extends StatelessWidget {
  const _AnswerBlock({required this.text});

  final String text;

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
          Text(
            l10n.platformSupportAnswerTitle,
            style: AppTypography.labelSm.copyWith(
              color: context.colors.primary,
            ),
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

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        constraints: const BoxConstraints(minHeight: AppSizes.touchTarget),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(icon, size: 18, color: context.colors.primary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyMd.copyWith(
                  color: context.colors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
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
    final color =
        resolved ? context.colors.onSurfaceVariant : AppColors.warning;

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
