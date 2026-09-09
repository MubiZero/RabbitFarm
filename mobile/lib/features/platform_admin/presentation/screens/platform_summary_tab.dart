import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/platform_admin_models.dart';
import '../providers/platform_admin_provider.dart';

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
        _TileRow(tiles: [
          StatTile(
            icon: Icons.holiday_village_outlined,
            label: l10n.platformSummaryTotalFarms,
            value: '${farms.total}',
          ),
          StatTile(
            icon: Icons.block_outlined,
            label: l10n.platformNoPlan,
            value: '${farms.noPlan}',
          ),
        ]),
        const SizedBox(height: AppSpacing.md),
        _TileRow(tiles: [
          StatTile(
            icon: Icons.card_giftcard_outlined,
            label: l10n.platformSummaryFree,
            value: '${farms.free}',
          ),
          StatTile(
            icon: Icons.payments_outlined,
            label: l10n.platformSummaryPaid,
            value: '${farms.paid}',
            accent: AppColors.success,
          ),
        ]),
        const SizedBox(height: AppSpacing.xl),

        // Подписи и смысл — те же, что у срезов списка ферм и адресатов
        // объявления (см. farm_filter_labels.dart): одно состояние — одно
        // название везде, а не три версии одного и того же.
        AppSectionTitle(l10n.platformSummarySectionStatus),
        _TileRow(tiles: [
          StatTile(
            icon: Icons.event_busy_outlined,
            label: l10n.platformFilterExpired,
            value: '${farms.expired}',
            accent: farms.expired > 0 ? AppColors.warning : null,
          ),
          StatTile(
            icon: Icons.do_not_disturb_on_outlined,
            label: l10n.platformFarmStatusSuspended,
            value: '${farms.suspended}',
            accent: farms.suspended > 0 ? AppColors.error : null,
          ),
          StatTile(
            icon: Icons.warning_amber_outlined,
            label: l10n.platformAtLimit,
            value: '${farms.atLimit}',
            accent: farms.atLimit > 0 ? AppColors.error : null,
          ),
        ]),
        const SizedBox(height: AppSpacing.xl),

        AppSectionTitle(l10n.platformSummarySectionActivity),
        _TileRow(tiles: [
          StatTile(
            icon: Icons.person_add_alt_outlined,
            label: l10n.platformSummaryRegistrations30d,
            value: '${summary.registrations30d}',
          ),
          StatTile(
            icon: Icons.person_off_outlined,
            label: l10n.platformFilterInactive(30),
            value: '${summary.inactive30d}',
          ),
        ]),
        const SizedBox(height: AppSpacing.xl),

        AppSectionTitle(l10n.platformSummarySectionData),
        _TileRow(tiles: [
          StatTile(
            icon: Icons.pets_outlined,
            label: l10n.platformSummaryRabbitsTotal,
            value: '${summary.rabbitsTotal}',
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

/// Ряд плиток поровну делит ширину — общий макет для строк из двух и трёх
/// значений на этом экране.
class _TileRow extends StatelessWidget {
  const _TileRow({required this.tiles});

  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < tiles.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.md),
          Expanded(child: tiles[i]),
        ],
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
        SkeletonStatRow(),
        SizedBox(height: AppSpacing.md),
        SkeletonStatRow(),
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
