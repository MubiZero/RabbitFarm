import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/models/support_contact.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/support_request.dart';
import '../providers/support_provider.dart';
import '../widgets/my_support_request_card.dart';
import 'support_request_form_screen.dart';

/// Поддержка: свои обращения и ответы на них.
///
/// Раньше это была дорога в один конец — форма отправки и тишина: человек не
/// узнавал ни что обращение приняли, ни что на него ответили. Теперь экран
/// начинается с истории, а написать новое — кнопка, которая видна всегда:
/// сюда приходят с поломкой, и лишний шаг до формы здесь дороже обычного.
class SupportRequestScreen extends ConsumerWidget {
  const SupportRequestScreen({super.key});

  Future<void> _compose(BuildContext context, WidgetRef ref) async {
    final sent = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const SupportRequestFormScreen()),
    );
    if (sent == true) {
      await ref.read(mySupportRequestsProvider.notifier).load();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(mySupportRequestsProvider);
    final notifier = ref.read(mySupportRequestsProvider.notifier);
    final contact = ref.watch(supportContactProvider).value;

    final header = contact != null && !contact.isEmpty
        ? Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              AppSpacing.lg,
              AppSpacing.screenH,
              0,
            ),
            child: SupportContactCard(contact: contact),
          )
        : null;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.supportRequestTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _compose(context, ref),
        icon: const Icon(Icons.edit_outlined),
        label: Text(l10n.supportRequestNew),
      ),
      body: PagedListView<SupportRequest>(
        items: state.items,
        isLoading: state.isLoading,
        error: state.error,
        hasMore: state.hasMore,
        onRefresh: notifier.load,
        onLoadMore: notifier.loadMore,
        header: header,
        empty: AppEmptyState(
          icon: Icons.support_agent_outlined,
          title: l10n.supportRequestsEmptyTitle,
          subtitle: l10n.supportRequestsEmptyBody,
          // Подпись длиннее, чем на круглой кнопке: посреди пустого экрана
          // «Написать» без продолжения не говорит, кому пишут.
          actionLabel: l10n.supportRequestsEmptyAction,
          onAction: () => _compose(context, ref),
        ),
        itemBuilder: (context, request, _) =>
            MySupportRequestCard(request: request),
      ),
    );
  }
}

/// Официальный email/телефон поддержки — рядом с обращениями, не вместо них:
/// платформенный админ мог их не задать, тогда карточка не показывается вовсе
/// (см. `supportContactProvider`).
class SupportContactCard extends StatelessWidget {
  final SupportContact contact;

  const SupportContactCard({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.supportContactHint,
            style: AppTypography.labelSm.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          if (contact.phone != null)
            _ContactRow(
              icon: Icons.phone_outlined,
              label: contact.phone!,
              onTap: () => launchUrl(Uri(scheme: 'tel', path: contact.phone)),
            ),
          if (contact.email != null)
            _ContactRow(
              icon: Icons.email_outlined,
              label: contact.email!,
              onTap: () =>
                  launchUrl(Uri(scheme: 'mailto', path: contact.email)),
            ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        // Звонят и пишут в поддержку в тех же перчатках, что и работают с
        // остальным приложением, — строка обязана держать общий минимум.
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
