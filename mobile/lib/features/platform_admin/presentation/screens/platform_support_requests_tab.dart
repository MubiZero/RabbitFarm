import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/error_text.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/platform_admin_models.dart';
import '../providers/platform_admin_provider.dart';
import '../widgets/support_request_card.dart';

/// Обращения ферм в поддержку: необработанные сверху (сортировка на сервере,
/// см. `supportRequestService.list`).
///
/// Заменяет голое «обратитесь в поддержку», за которым раньше не было
/// никакого канала — теперь то же обращение видно здесь, а не только в
/// голове фермера.
class PlatformSupportRequestsTab extends ConsumerWidget {
  const PlatformSupportRequestsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(platformSupportRequestsProvider);
    final notifier = ref.read(platformSupportRequestsProvider.notifier);
    final l10n = context.l10n;

    return PagedListView<SupportRequest>(
      items: state.items,
      isLoading: state.isLoading,
      error: state.error,
      hasMore: state.hasMore,
      onRefresh: notifier.load,
      onLoadMore: notifier.loadMore,
      header: state.items.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenH,
                AppSpacing.lg,
                AppSpacing.screenH,
                0,
              ),
              child: AppGroupLabel(l10n.countSupportRequests(state.total)),
            ),
      empty: AppEmptyState(
        icon: Icons.support_agent_outlined,
        title: l10n.platformSupportRequestsEmptyTitle,
        subtitle: l10n.platformSupportRequestsEmptyBody,
      ),
      itemBuilder: (context, request, _) => SupportRequestCard(
        request: request,
        onResolve: () async {
          final error = await notifier.resolve(request.id);
          if (error != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorText(l10n, error)),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
      ),
    );
  }
}
