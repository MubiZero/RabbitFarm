import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/error_text.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../reports/data/models/report_model.dart';
import '../../../reports/presentation/providers/reports_provider.dart';
import '../../data/models/payment_order.dart';
import '../providers/payment_provider.dart';

final _dayFormat = DateFormat('dd.MM.yyyy');

/// Экран «Тариф» самой фермы (см. docs/plans/PLATFORM-ADMIN.md, 4.1):
/// название тарифа, цена продления, срок, и кнопка оплатить. В отличие от
/// карточки фермы в платформенной админке, здесь нет ни выбора тарифа, ни
/// ручного продления — ферма не назначает себе план сама (см.
/// `Farm.plan_id` на сервере) и может только оплатить уже назначенный.
class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardReportProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.subscriptionTitle)),
      body: AppAsyncView<DashboardReport>(
        value: dashboardAsync,
        onRetry: () => ref.invalidate(dashboardReportProvider),
        skeleton: (_) => const _SubscriptionSkeleton(),
        builder: (dashboard) => _Content(plan: dashboard.planUsage?.plan),
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({required this.plan});

  final PlanUsagePlan? plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final flow = ref.watch(paymentFlowProvider);

    ref.listen<PaymentFlowState>(paymentFlowProvider, (previous, next) {
      if (next.status == PaymentFlowStatus.failed && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorText(l10n, next.error)),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
      // Проверили и банк ещё не подтвердил — не ошибка запроса, а обычный
      // промежуточный исход: без сообщения кнопка просто молча перестаёт
      // крутиться, и непонятно, сработала ли проверка вообще.
      final justChecked = previous?.status == PaymentFlowStatus.checking &&
          next.status == PaymentFlowStatus.awaitingPayment;
      if (justChecked) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.subscriptionPaymentPending)),
        );
      }
    });

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenH),
      children: [
        if (plan == null)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.subscriptionNoPlan,
                  style: AppTypography.titleMd
                      .copyWith(color: context.colors.onSurface),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.subscriptionNoPlanHint,
                  style: AppTypography.bodyMd
                      .copyWith(color: context.colors.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => context.push('/support'),
                    child: Text(l10n.subscriptionContactSupport),
                  ),
                ),
              ],
            ),
          )
        else ...[
          _PlanInfoCard(plan: plan!),
          const SizedBox(height: AppSpacing.lg),
          if (flow.status == PaymentFlowStatus.completed)
            _CompletedCard()
          else if (flow.order != null)
            _PayingCard(order: flow.order!, checking: flow.status == PaymentFlowStatus.checking)
          else if (plan!.price != null)
            _PayButton(loading: flow.status == PaymentFlowStatus.creating),
        ],
      ],
    );
  }
}

class _PlanInfoCard extends StatelessWidget {
  const _PlanInfoCard({required this.plan});

  final PlanUsagePlan plan;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final expires = plan.expiresAt;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  plan.name,
                  style: AppTypography.titleMd
                      .copyWith(color: context.colors.onSurface),
                ),
              ),
              Text(
                plan.price == null
                    ? l10n.subscriptionFree
                    : l10n.subscriptionPricePerPeriod(plan.price!.toStringAsFixed(0)),
                style: AppTypography.labelLg
                    .copyWith(color: context.colors.onSurfaceVariant),
              ),
            ],
          ),
          if (plan.price != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(
                  Icons.event_outlined,
                  size: 16,
                  color: plan.isExpired
                      ? AppColors.warning
                      : context.colors.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  expires == null
                      ? l10n.subscriptionForever
                      : plan.isExpired
                          ? l10n.subscriptionExpired(_dayFormat.format(expires))
                          : l10n.subscriptionExpiresOn(_dayFormat.format(expires)),
                  style: AppTypography.bodyMd.copyWith(
                    color: plan.isExpired
                        ? AppColors.warning
                        : context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PayButton extends ConsumerWidget {
  const _PayButton({required this.loading});

  final bool loading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: loading ? null : () => ref.read(paymentFlowProvider.notifier).pay(),
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(context.l10n.subscriptionPay),
      ),
    );
  }
}

class _PayingCard extends ConsumerWidget {
  const _PayingCard({required this.order, required this.checking});

  final PaymentOrder order;
  final bool checking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final url = order.invoiceUrl;
    final deepLink = order.deepLink;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.subscriptionAfterPayingHint,
            style: AppTypography.bodyMd
                .copyWith(color: context.colors.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (url != null || deepLink != null)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _openPaymentPage(deepLink ?? url!, fallback: url),
                child: Text(l10n.subscriptionOpenPaymentPage),
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: checking
                  ? null
                  : () => ref.read(paymentFlowProvider.notifier).checkPayment(),
              child: checking
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.subscriptionCheckPayment),
            ),
          ),
        ],
      ),
    );
  }

  /// Пробуем открыть диплинк приложения банка; если открыть нечем —
  /// обычная веб-ссылка на ту же оплату.
  Future<void> _openPaymentPage(String primary, {String? fallback}) async {
    final uri = Uri.parse(primary);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && fallback != null && fallback != primary) {
      await launchUrl(Uri.parse(fallback), mode: LaunchMode.externalApplication);
    }
  }
}

class _SubscriptionSkeleton extends StatelessWidget {
  const _SubscriptionSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.screenH),
      children: const [
        SkeletonCard(height: 96),
        SizedBox(height: AppSpacing.lg),
        SkeletonBox(width: double.infinity, height: 44),
      ],
    );
  }
}

class _CompletedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.success),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              context.l10n.subscriptionPaymentCompleted,
              style: AppTypography.bodyLg
                  .copyWith(color: context.colors.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
