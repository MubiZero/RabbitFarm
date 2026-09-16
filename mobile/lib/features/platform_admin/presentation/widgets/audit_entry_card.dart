import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/platform_admin_models.dart';
import 'audit_entry_labels.dart';

final _momentFormat = DateFormat('dd.MM.yyyy HH:mm');

/// Одно действие админа в журнале: кто, когда, что сделал и над какой фермой.
///
/// Запись неизменяема — тапать не по чему и править нечего, поэтому карточка
/// без действий.
///
/// Имён здесь нет намеренно: сервер отдаёт журнал с одними идентификаторами
/// (`admin_id`, `farm_id`), и подставить вместо них название фермы было бы
/// догадкой. Честный номер лучше выдуманного имени.
class AuditEntryCard extends StatelessWidget {
  const AuditEntryCard({super.key, required this.entry, this.plans = const []});

  final AdminAuditEntry entry;

  /// Тарифы сервиса — чтобы «Тариф: 1 → 2» превратить в «Базовый →
  /// Расширенный». Пустой список не беда: тогда останутся номера.
  final List<Plan> plans;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final accentColor = auditActionColor(entry.action);
    final titleColor = accentColor ?? context.colors.onSurface;
    final lines = auditChangeLines(context, entry, plans: plans);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(auditActionIcon(entry.action), size: 18, color: titleColor),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  auditActionTitle(context, entry.action),
                  style: AppTypography.titleMd.copyWith(color: titleColor),
                  maxLines: 2,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                _momentFormat.format(entry.createdAt.toLocal()),
                style: AppTypography.labelSm
                    .copyWith(color: context.colors.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            [
              // Имя человека говорит само за себя — слово «Админ» перед
              // ним лишнее. Оно нужно только там, где имени нет и остался
              // один номер.
              entry.admin?.fullName ??
                  l10n.platformAuditAdmin(entry.adminFallback),
              // Действие над всем сервисом (правка тарифа, контакт поддержки)
              // фермы не касается — и молчать об этом нельзя: пустое место
              // читалось бы как «ферму забыли записать».
              entry.isAboutFarm
                  ? (entry.farm?.name ??
                      l10n.platformAuditFarm(entry.farmFallback))
                  : l10n.platformAuditWholeService,
            ].join(' · '),
            style: AppTypography.labelSm
                .copyWith(color: context.colors.onSurfaceVariant),
          ),
          if (lines.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Text(
                  line,
                  style: AppTypography.bodyMd
                      .copyWith(color: context.colors.onSurface),
                ),
              ),
          ],
          if (entry.ip != null && entry.ip!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.platformAuditIp(entry.ip!),
              style: AppTypography.labelSm
                  .copyWith(color: context.colors.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}
