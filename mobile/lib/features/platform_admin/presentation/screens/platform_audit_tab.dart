import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/platform_admin_models.dart';
import '../providers/platform_admin_provider.dart';
import '../widgets/audit_entry_card.dart';

/// Журнал действий платформенного админа: кто, когда, что сделал и над какой
/// фермой.
///
/// Сервер писал сюда строку на каждое админское действие с самого начала, но
/// прочитать её было неоткуда — а при входе под клиентом у админа вдобавок
/// обязательно спрашивают объяснение, и оно уходило туда же, в нечитаемое.
/// Журнал нужен ровно затем, чтобы вопрос «кто закрыл эту ферму и зачем»
/// имел ответ.
class PlatformAuditTab extends ConsumerWidget {
  const PlatformAuditTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(platformAuditProvider);
    final notifier = ref.read(platformAuditProvider.notifier);
    // Тарифы нужны, чтобы смена тарифа читалась названиями, а не номерами.
    // Пока они не приехали (или не приехали вовсе), журнал показывается как
    // есть — ждать их ради подписи было бы хуже, чем показать номер.
    final plans = ref.watch(platformPlansProvider).value ?? const <Plan>[];

    return PagedListView<AdminAuditEntry>(
      items: state.items,
      isLoading: state.isLoading,
      error: state.error,
      hasMore: state.hasMore,
      onRefresh: notifier.load,
      onLoadMore: notifier.loadMore,
      // Счётчик из пагинации, а не из длины загруженного списка, и прячется
      // на пустом списке — как в остальных вкладках админки.
      header: state.items.isEmpty ? null : _Total(total: state.total),
      empty: AppEmptyState(
        icon: Icons.history,
        title: context.l10n.platformAuditEmptyTitle,
        subtitle: context.l10n.platformAuditEmptyBody,
      ),
      itemBuilder: (context, entry, _) =>
          AuditEntryCard(entry: entry, plans: plans),
    );
  }
}

class _Total extends StatelessWidget {
  const _Total({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.lg,
        AppSpacing.screenH,
        0,
      ),
      child: AppGroupLabel(context.l10n.countAuditRecords(total)),
    );
  }
}
