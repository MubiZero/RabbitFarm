import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/l10n_context.dart';
import '../offline_queue/offline_queue.dart';
import '../theme/theme.dart';

/// Держит очередь офлайн-действий живой всё время работы приложения.
///
/// Riverpod-провайдеры ленивые: без постоянного наблюдателя контроллер
/// очереди создавался бы только тогда, когда какой-то экран его читает — и
/// связь, вернувшаяся, пока человек смотрит на список кроликов, никогда не
/// запустила бы отправку.
///
/// Здесь же показывается плашка о записях, которые сервер отверг
/// окончательно. Раньше такая запись исчезала молча: сигнал уходил в Sentry,
/// а человек продолжал считать, что кормление записано. Это ломает сам смысл
/// очереди — ей доверили работу, чтобы не держать её в голове.
class OfflineQueueGate extends ConsumerWidget {
  const OfflineQueueGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(offlineQueueProvider);
    final rejected = ref.watch(offlineRejectedProvider);

    if (rejected.isEmpty) return child;

    return Column(
      children: [
        _RejectedBanner(
          count: rejected.length,
          onDismiss: () =>
              ref.read(offlineRejectedProvider.notifier).clear(),
        ),
        Expanded(child: child),
      ],
    );
  }
}

class _RejectedBanner extends StatelessWidget {
  const _RejectedBanner({required this.count, required this.onDismiss});

  final int count;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Material(
      color: AppColors.error.withValues(alpha: 0.12),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.cloud_off_outlined,
                  size: 20, color: AppColors.error),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.offlineRejectedTitle(count),
                      style: AppTypography.titleMd
                          .copyWith(color: context.colors.onSurface),
                    ),
                    const SizedBox(height: 2),
                    // Не «что-то пошло не так»: человек должен понять, что
                    // делать дальше — записать заново.
                    Text(
                      l10n.offlineRejectedBody,
                      style: AppTypography.labelSm
                          .copyWith(color: context.colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: onDismiss,
                child: Text(l10n.offlineRejectedDismiss),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
