import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/platform_admin_models.dart';
import '../providers/platform_admin_provider.dart';
import '../widgets/farm_filter_labels.dart';

/// Сводка платформы целиком (см. docs/plans/PLATFORM-ADMIN.md, этап 5).
///
/// Список ферм отвечает на «кому пора менять тариф», а этот экран — на «как
/// дела у сервиса в целом»: сколько ферм и на каком они тарифе, много ли
/// просроченных или приостановленных, растёт ли база и сколько она занимает
/// места. Один агрегирующий запрос, а не подсчёт по загруженным страницам
/// списка ферм — иначе «12 ферм» означало бы «столько успело догрузиться».
class PlatformSummaryTab extends ConsumerWidget {
  const PlatformSummaryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(platformSummaryProvider);

    Future<void> refresh() async {
      ref.invalidate(platformSummaryProvider);
      try {
        await ref.read(platformSummaryProvider.future);
      } catch (_) {
        // Об ошибке расскажет AppAsyncView — здесь только снять индикатор.
      }
    }

    return RefreshIndicator(
      onRefresh: refresh,
      child: AppAsyncView<PlatformSummary>(
        value: summaryAsync,
        onRetry: refresh,
        skeleton: (_) => const _SummarySkeleton(),
        builder: (summary) => _SummaryContent(summary: summary),
      ),
    );
  }
}

class _SummaryContent extends StatelessWidget {
  const _SummaryContent({required this.summary});

  final PlatformSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final farms = summary.farms;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.lg,
        AppSpacing.screenH,
        AppSpacing.fabSafeBottom,
      ),
      children: [
        AppSectionTitle(l10n.platformSummarySectionFarms),
        StatTile(
          icon: Icons.holiday_village_outlined,
          label: l10n.platformSummaryTotalFarms,
          value: formatQuantity(farms.total),
        ),
        const SizedBox(height: AppSpacing.md),
        // Три плитки в сумме и дают «Всего ферм» выше — каждая ферма попадает
        // ровно в одну из них (см. PlatformFarmsSummary), поэтому они стоят
        // одним рядом, как и независимые срезы в «Состоянии» ниже, а не
        // парами вперемешку с итогом.
        StatTileRow(tiles: [
          StatTile(
            icon: Icons.card_giftcard_outlined,
            label: l10n.platformSummaryFree,
            value: formatQuantity(farms.free),
          ),
          StatTile(
            icon: Icons.payments_outlined,
            label: l10n.platformSummaryPaid,
            value: formatQuantity(farms.paid),
            accent: AppColors.success,
          ),
          StatTile(
            icon: Icons.block_outlined,
            label: l10n.platformNoPlan,
            value: formatQuantity(farms.noPlan),
          ),
        ]),
        const SizedBox(height: AppSpacing.xl),

        // Смысл каждого среза и его цвет — общие с фильтрами списка ферм
        // (см. farm_filter_labels.dart): одно состояние должно и называться,
        // и подсвечиваться одинаково везде, а не по-разному на разных
        // экранах. Подписи здесь свои — «Просрочка тарифа» вместо «Просрочен
        // тариф»: под числом-счётчиком это существительное, а не фраза,
        // согласованная с подразумеваемой единственной фермой.
        AppSectionTitle(l10n.platformSummarySectionStatus),
        StatTileRow(tiles: [
          StatTile(
            icon: Icons.event_busy_outlined,
            label: l10n.platformSummaryExpired,
            value: formatQuantity(farms.expired),
            accent: farms.expired > 0
                ? farmFilterColor(PlatformFarmFilter.expired)
                : null,
          ),
          StatTile(
            icon: Icons.do_not_disturb_on_outlined,
            label: l10n.platformFarmStatusSuspended,
            value: formatQuantity(farms.suspended),
            accent: farms.suspended > 0
                ? farmFilterColor(PlatformFarmFilter.suspended)
                : null,
          ),
          StatTile(
            icon: Icons.warning_amber_outlined,
            label: l10n.platformSummaryAtLimit,
            value: formatQuantity(farms.atLimit),
            accent: farms.atLimit > 0
                ? farmFilterColor(PlatformFarmFilter.atLimit)
                : null,
          ),
        ]),
        const SizedBox(height: AppSpacing.xl),

        AppSectionTitle(l10n.platformSummarySectionActivity),
        StatTileRow(tiles: [
          StatTile(
            icon: Icons.person_add_alt_outlined,
            label: l10n.platformSummaryRegistrations30d,
            value: formatQuantity(summary.registrations30d),
          ),
          StatTile(
            icon: Icons.person_off_outlined,
            label: l10n.platformFilterInactive(30),
            value: formatQuantity(summary.inactive30d),
          ),
        ]),
        const SizedBox(height: AppSpacing.xl),

        AppSectionTitle(l10n.platformSummarySectionData),
        StatTileRow(tiles: [
          StatTile(
            icon: Icons.pets_outlined,
            label: l10n.platformSummaryRabbitsTotal,
            // Сумма по всей платформе, не по одной ферме — реалистично
            // растёт до пяти-шести знаков, поэтому с разделителями разрядов,
            // как и везде, где число не гарантированно маленькое.
            value: formatQuantity(summary.rabbitsTotal),
            accent: AppColors.domainLivestock,
          ),
          StatTile(
            icon: Icons.storage_outlined,
            label: l10n.platformSummaryStorageTotal,
            value: storageLabel(context, summary.storageBytes),
          ),
        ]),
      ],
    );
  }
}

/// Каркас первой загрузки — четыре блока «заголовок + ряд плиток», как и в
/// готовой сводке, чтобы при подстановке чисел ничего не прыгало.
class _SummarySkeleton extends StatelessWidget {
  const _SummarySkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.lg,
        AppSpacing.screenH,
        AppSpacing.fabSafeBottom,
      ),
      children: const [
        SkeletonBox(width: 120, height: 12),
        SizedBox(height: AppSpacing.md),
        SkeletonBox(height: 116, borderRadius: AppRadius.lgAll),
        SizedBox(height: AppSpacing.md),
        SkeletonStatRow(count: 3),
        SizedBox(height: AppSpacing.xl),
        SkeletonBox(width: 120, height: 12),
        SizedBox(height: AppSpacing.md),
        SkeletonStatRow(count: 3),
        SizedBox(height: AppSpacing.xl),
        SkeletonBox(width: 120, height: 12),
        SizedBox(height: AppSpacing.md),
        SkeletonStatRow(),
        SizedBox(height: AppSpacing.xl),
        SkeletonBox(width: 120, height: 12),
        SizedBox(height: AppSpacing.md),
        SkeletonStatRow(),
      ],
    );
  }
}
