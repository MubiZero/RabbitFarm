import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/error_text.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/date_labels.dart';
import '../../../../core/widgets/coach_mark.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../onboarding/presentation/providers/onboarding_provider.dart';
import '../../../onboarding/presentation/providers/tour_provider.dart';
import '../../../reports/data/models/report_model.dart';
import '../../../reports/presentation/providers/reports_provider.dart';
import '../../../tasks/data/models/task_model.dart';
import '../../../tasks/presentation/providers/tasks_provider.dart';

/// Экран «Сегодня» — с чего начинается рабочий день.
///
/// Отвечает ровно на два вопроса: что горит прямо сейчас и в каком состоянии
/// ферма. Раньше экран показывал одни и те же три числа по три раза — в
/// сводке, в уведомлении и в «быстрых действиях», — а два из трёх «быстрых
/// действий» вели на вкладки, до которых можно дотянуться внизу этого же
/// экрана. Зато число просроченных задач, самое важное для фермы, не
/// показывалось нигде.
///
/// Задачи с тех пор переехали сюда целиком: карточка «просроченные задачи»
/// умела только отослать на другой экран, и чтобы поставить галочку, человек
/// уходил с «Сегодня» и терял место, на котором стоял.
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
    ref.invalidate(todayTasksProvider);
    try {
      await Future.wait([
        ref.read(dashboardReportProvider.future),
        ref.read(todayTasksProvider.future),
      ]);
    } catch (_) {
      // Об ошибке рассказывают сами блоки — каждый на своём месте. Здесь
      // ожидание нужно только чтобы вовремя убрать индикатор обновления.
    }
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

        // Всё, что горит сегодня, — один блок: дела, которые можно закрыть
        // отсюда же, и тревоги, за которыми надо идти в другой раздел.
        Column(
          key: _alertsKey,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TodayTasks(quietWhenEmpty: alerts.isNotEmpty),
            if (alerts.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xl),
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
            _rabbitsPlanUsage(d),
          ],
        ),
      ],
    );
  }

  /// Полоса «26 из 30 кроликов» — заранее, до отказа сервера.
  ///
  /// Показывается только когда информативна: у фермы без тарифа (или без
  /// предела на кроликов) лимита попросту нет, а далеко от предела полоса
  /// была бы шумом на каждый день. Порог 80% — тот же, что и в карточке
  /// фермы у платформенного админа.
  Widget _rabbitsPlanUsage(DashboardReport d) {
    final usage = d.planUsage?.rabbits;
    final limit = usage?.limit;
    if (usage == null || limit == null || limit <= 0) {
      return const SizedBox.shrink();
    }

    final fraction = usage.used / limit;
    if (fraction < 0.8) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: MetricBar(
        icon: Icons.pets_outlined,
        label: context.l10n.platformRabbits,
        value: context.l10n.platformUsageOfLimit(usage.used, limit),
        fraction: fraction,
        color: fraction >= 1 ? AppColors.error : AppColors.warning,
      ),
    );
  }

  /// Срочное — сверху. Просроченное важнее предстоящего, поэтому порядок
  /// здесь фиксированный, а не «в каком порядке пришли поля».
  ///
  /// Задач здесь больше нет: их видно строками выше, и там их можно закрыть.
  List<Widget> _alerts(DashboardReport d) {
    return [
      if (d.health.overdueVaccinations > 0)
        AlertCard(
          title: context.l10n.todayAlertOverdueVaccination,
          description:
              context.l10n.countVaccinations(d.health.overdueVaccinations),
          icon: Icons.vaccines_outlined,
          color: AppColors.error,
          onTap: () => context.push('/vaccinations'),
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

/// Дела на сегодня — прямо на «Сегодня», с галочкой на месте.
///
/// Показывает просроченное и сегодняшнее, ранние сроки сверху. Полный список
/// с фильтрами остаётся за ссылкой: на первом экране нужна работа на ближайший
/// час, а не картотека.
class _TodayTasks extends ConsumerWidget {
  /// Пусто, когда рядом есть другие тревоги: «всё под контролем» под карточкой
  /// о просроченной вакцинации — это неправда.
  final bool quietWhenEmpty;

  const _TodayTasks({required this.quietWhenEmpty});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(todayTasksProvider);
    // Правила те же, что в [AppAsyncView], но блоком, а не экраном: ошибка
    // задач не должна съедать сводку по ферме, которая грузится отдельно.
    // Уже показанные строки при обновлении остаются на месте — иначе каждая
    // отметка галочкой сменялась бы миганием заглушек.
    final loaded = tasks.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionTitle(
          context.l10n.todayTasksTitle,
          actionLabel: context.l10n.todayTasksAll,
          onAction: () => context.push('/tasks'),
        ),
        if (loaded == null && tasks.hasError)
          _error(context, ref, tasks.error)
        else if (loaded == null)
          const _TasksSkeleton()
        else if (loaded.isEmpty)
          _empty(context)
        else
          for (var i = 0; i < loaded.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.sm),
            _TaskRow(
              task: loaded[i],
              onComplete: () => _complete(context, ref, loaded[i]),
              onOpen: () => context.push('/tasks/form', extra: loaded[i]),
            ),
          ],
      ],
    );
  }

  Widget _empty(BuildContext context) => quietWhenEmpty
      ? Text(
          context.l10n.todayTasksNone,
          style: AppTypography.bodyMd
              .copyWith(color: context.colors.onSurfaceVariant),
        )
      : const _AllClearCard();

  Widget _error(BuildContext context, WidgetRef ref, Object? error) {
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Text(
              errorText(context.l10n, error),
              style: AppTypography.bodyMd
                  .copyWith(color: context.colors.onSurfaceVariant),
            ),
          ),
          TextButton(
            onPressed: () => ref.invalidate(todayTasksProvider),
            child: Text(context.l10n.commonRetryShort),
          ),
        ],
      ),
    );
  }

  Future<void> _complete(
      BuildContext context, WidgetRef ref, Task task) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    HapticFeedback.selectionClick();

    try {
      await ref.read(todayTasksProvider.notifier).complete(task.id);
      // Счётчик незакрытых задач стоит на том же экране: оставить его прежним
      // — значит дать два разных ответа на один вопрос.
      ref.invalidate(dashboardReportProvider);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(errorText(l10n, e)),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

/// Две строки-заглушки в геометрии будущих задач: когда список приезжает,
/// заголовок фермы под ним не прыгает.
class _TasksSkeleton extends StatelessWidget {
  const _TasksSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SkeletonCard(height: 64),
        SizedBox(height: AppSpacing.sm),
        SkeletonCard(height: 64),
      ],
    );
  }
}

/// Строка задачи: галочка слева, срок под названием.
///
/// Отметить выполненной можно только галочкой, а не нажатием на всю строку:
/// отменить выполнение приложение не умеет, и случайное касание списка стоило
/// бы человеку задачи. Нажатие на строку открывает её целиком.
class _TaskRow extends StatelessWidget {
  final Task task;
  final VoidCallback onComplete;
  final VoidCallback onOpen;

  const _TaskRow({
    required this.task,
    required this.onComplete,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final done = task.status == TaskStatus.completed;
    final overdue = !done && isOverdue(task.dueDate);

    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      onTap: onOpen,
      child: Row(
        children: [
          if (done)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Icon(Icons.check_circle, color: AppColors.success),
            )
          else
            Checkbox(
              value: false,
              semanticLabel: context.l10n.tasksComplete,
              onChanged: (_) => onComplete(),
            ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: AppTypography.titleMd.copyWith(
                    color: done
                        ? context.colors.onSurfaceVariant
                        : context.colors.onSurface,
                    decoration: done ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                // У закрытой задачи срок больше не значит ничего: «просрочена
                // на три дня» под зачёркнутой строкой читается как упрёк за
                // только что сделанную работу.
                Text(
                  done
                      ? context.l10n.todayTaskDone
                      : humanDueDate(context, task.dueDate),
                  style: AppTypography.labelSm.copyWith(
                    color: overdue
                        ? AppColors.error
                        : context.colors.onSurfaceVariant,
                    fontWeight: overdue ? FontWeight.w600 : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

/// Заглушка в геометрии готового экрана: заголовок, строки задач и ряд плиток.
/// Когда данные приезжают, ничего не подпрыгивает.
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
        SkeletonBox(width: 180, height: 20),
        SizedBox(height: AppSpacing.md),
        SkeletonCard(height: 64),
        SizedBox(height: AppSpacing.sm),
        SkeletonCard(height: 64),
        SizedBox(height: AppSpacing.xl),
        SkeletonBox(width: 160, height: 20),
        SizedBox(height: AppSpacing.md),
        SkeletonStatRow(count: 3),
      ],
    );
  }
}
