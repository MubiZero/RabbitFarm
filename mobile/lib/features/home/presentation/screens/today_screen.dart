import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/widgets/coach_mark.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../onboarding/presentation/providers/onboarding_provider.dart';
import '../../../onboarding/presentation/providers/tour_provider.dart';
import '../../../reports/data/models/report_model.dart';
import '../../../reports/presentation/providers/reports_provider.dart';

/// Экран «Сегодня» — с чего начинается рабочий день.
///
/// Отвечает ровно на два вопроса: что горит прямо сейчас и в каком состоянии
/// ферма. Раньше экран показывал одни и те же три числа по три раза — в
/// сводке, в уведомлении и в «быстрых действиях», — а два из трёх «быстрых
/// действий» вели на вкладки, до которых можно дотянуться внизу этого же
/// экрана. Зато число просроченных задач, самое важное для фермы, не
/// показывалось нигде.
class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  final _alertsKey = GlobalKey();
  final _statsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStartTour());
  }

  /// Шаги обучения собираются в build, а не в initState: переводы берутся из
  /// дерева виджетов и в initState ещё недоступны.
  List<CoachMarkStep> _tourSteps(BuildContext context) => [
        CoachMarkStep(
          targetKey: _alertsKey,
          title: context.l10n.todayTourAlertsTitle,
          description: context.l10n.todayTourAlertsBody,
        ),
        CoachMarkStep(
          targetKey: _statsKey,
          title: context.l10n.todayTourStatsTitle,
          description: context.l10n.todayTourStatsBody,
        ),
      ];

  Future<void> _maybeStartTour() async {
    final onboarding = await ref.read(onboardingProvider.future);
    if (!onboarding.tourDone && mounted) {
      ref.read(tourProvider.notifier).start();
    }
  }

  Future<void> _refresh() async {
    ref.invalidate(dashboardReportProvider);
    await ref.read(dashboardReportProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(dashboardReportProvider);
    final tourState = ref.watch(tourProvider);
    final tourSteps = _tourSteps(context);

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: AppAsyncView<DashboardReport>(
                value: dashboardAsync,
                onRetry: _refresh,
                skeleton: (_) => const _TodaySkeleton(),
                builder: (dashboard) => _content(dashboard),
              ),
            ),
          ),
          if (tourState.isActive && tourState.step < tourSteps.length)
            Positioned.fill(
              child: CoachMarkOverlay(
                steps: tourSteps,
                currentStep: tourState.step,
                onNext: () =>
                    ref.read(tourProvider.notifier).advance(tourSteps.length),
                onSkip: () => ref.read(tourProvider.notifier).skip(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _content(DashboardReport d) {
    final alerts = _alerts(d);

    return ListView(
      // Тянуть для обновления нужно и на коротком содержимом.
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.xl,
        AppSpacing.screenH,
        AppSpacing.fabSafeBottom,
      ),
      children: [
        const _Greeting(),
        const SizedBox(height: AppSpacing.xl),

        Column(
          key: _alertsKey,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (alerts.isEmpty)
              const _AllClearCard()
            else ...[
              AppSectionTitle(context.l10n.todayNeedsAttention),
              for (var i = 0; i < alerts.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.sm),
                alerts[i],
              ],
            ],
          ],
        ),

        const SizedBox(height: AppSpacing.xl),

        Column(
          key: _statsKey,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSectionTitle(context.l10n.todayFarmNow),
            Row(
              children: [
                Expanded(
                  child: StatTile(
                    icon: Icons.pets_outlined,
                    label: context.l10n.todayStatLivestock,
                    value: '${d.rabbits.total}',
                    accent: AppColors.domainLivestock,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: StatTile(
                    icon: Icons.check_circle_outline,
                    label: context.l10n.todayStatTasks,
                    value: '${d.tasks.pending}',
                    accent: AppColors.domainTasks,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: StatTile(
                    icon: Icons.grid_view_outlined,
                    label: context.l10n.todayStatFreeCages,
                    value: '${d.cages.available}',
                    accent: AppColors.domainLivestock,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.xl),

        AppSectionTitle(context.l10n.todayLast30Days),
        Row(
          children: [
            Expanded(
              child: StatTile(
                icon: Icons.child_care_outlined,
                label: context.l10n.todayStatBirths,
                value: '${d.breeding.recentBirths}',
                accent: AppColors.domainBreeding,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: StatTile(
                icon: Icons.trending_up,
                label: context.l10n.todayStatIncome,
                value: formatMoney(d.finance.income30days),
                accent: AppColors.success,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: StatTile(
                icon: Icons.trending_down,
                label: context.l10n.todayStatExpenses,
                value: formatMoney(d.finance.expenses30days),
                accent: AppColors.error,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Срочное — сверху. Просроченное важнее предстоящего, поэтому порядок
  /// здесь фиксированный, а не «в каком порядке пришли поля».
  List<Widget> _alerts(DashboardReport d) {
    return [
      if (d.tasks.overdue > 0)
        AlertCard(
          title: context.l10n.todayAlertOverdueTasks,
          description: context.l10n.countTasks(d.tasks.overdue),
          icon: Icons.event_busy_outlined,
          color: AppColors.error,
          onTap: () => context.go('/tasks'),
        ),
      if (d.health.overdueVaccinations > 0)
        AlertCard(
          title: context.l10n.todayAlertOverdueVaccination,
          description:
              context.l10n.countVaccinations(d.health.overdueVaccinations),
          icon: Icons.vaccines_outlined,
          color: AppColors.error,
          onTap: () => context.push('/vaccinations'),
        ),
      if (d.tasks.urgent > 0)
        AlertCard(
          title: context.l10n.todayAlertUrgentTasks,
          description: context.l10n.countTasks(d.tasks.urgent),
          icon: Icons.priority_high,
          color: AppColors.warning,
          onTap: () => context.go('/tasks'),
        ),
      if (d.inventory.lowStockFeeds > 0)
        AlertCard(
          title: context.l10n.todayAlertLowFeed,
          description:
              context.l10n.countFeedKinds(d.inventory.lowStockFeeds),
          icon: Icons.inventory_2_outlined,
          color: AppColors.warning,
          onTap: () => context.push('/feeds'),
        ),
      if (d.health.upcomingVaccinations > 0)
        AlertCard(
          title: context.l10n.todayAlertUpcomingVaccination,
          description:
              context.l10n.countVaccinations(d.health.upcomingVaccinations),
          icon: Icons.event_available_outlined,
          color: AppColors.info,
          onTap: () => context.push('/vaccinations'),
        ),
    ];
  }
}

class _Greeting extends ConsumerWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final name = ref.watch(authProvider).user?.fullName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _greeting(context, now.hour, name),
          style:
              AppTypography.displayMd.copyWith(color: context.colors.onSurface),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          DateFormat('d MMMM, EEEE', 'ru').format(now),
          style: AppTypography.bodyMd
              .copyWith(color: context.colors.onSurfaceVariant),
        ),
      ],
    );
  }

  String _greeting(BuildContext context, int hour, String? name) {
    final l10n = context.l10n;
    final base = switch (hour) {
      >= 6 && < 12 => l10n.todayGreetingMorning,
      >= 12 && < 18 => l10n.todayGreetingDay,
      >= 18 && < 23 => l10n.todayGreetingEvening,
      _ => l10n.todayGreetingNight,
    };
    final firstName = name?.trim().split(' ').first;
    return firstName == null || firstName.isEmpty
        ? l10n.todayGreetingPlain(base)
        : l10n.todayGreetingNamed(base, firstName);
  }
}

class _AllClearCard extends StatelessWidget {
  const _AllClearCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline,
              color: AppColors.success, size: 28),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              context.l10n.todayAllClear,
              style: AppTypography.bodyLg
                  .copyWith(color: context.colors.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

/// Заглушка в геометрии готового экрана: заголовок, блок уведомлений и две
/// строки плиток. Когда данные приезжают, ничего не подпрыгивает.
class _TodaySkeleton extends StatelessWidget {
  const _TodaySkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.xl,
        AppSpacing.screenH,
        AppSpacing.fabSafeBottom,
      ),
      children: const [
        SkeletonBox(width: 220, height: 28),
        SizedBox(height: AppSpacing.sm),
        SkeletonBox(width: 140, height: 16),
        SizedBox(height: AppSpacing.xl),
        SkeletonCard(height: 76),
        SizedBox(height: AppSpacing.xl),
        SkeletonBox(width: 160, height: 20),
        SizedBox(height: AppSpacing.md),
        SkeletonStatRow(count: 3),
        SizedBox(height: AppSpacing.xl),
        SkeletonBox(width: 120, height: 20),
        SizedBox(height: AppSpacing.md),
        SkeletonStatRow(count: 3),
      ],
    );
  }
}
