import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/farm_status_labels.dart';
import '../providers/auth_provider.dart';

/// Баннер о состоянии доступа хозяйства — `read_only`/`suspended`, не про
/// обычную работу (см. docs/plans/PLATFORM-ADMIN.md, 4.2: пробел,
/// найденный при автоматическом переводе фермы в `read_only` по истечении
/// тарифа — раньше ферма узнавала об этом только по тексту ошибки на
/// попытке что-то записать).
///
/// Оборачивает всё приложение в `main.dart`, а не один экран: причина, по
/// которой не получается сохранить запись, не должна зависеть от того, на
/// каком экране это выяснилось.
class FarmStatusBanner extends ConsumerWidget {
  const FarmStatusBanner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final status = auth.user?.farm?.status;

    if (status == null || status == 'active') {
      return child;
    }

    final l10n = context.l10n;
    final color = farmStatusColor(context, status);
    final message = switch (status) {
      'read_only' => l10n.farmStatusBannerReadOnly,
      'suspended' => l10n.farmStatusBannerSuspended,
      _ => farmStatusHint(context, status),
    };

    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: Material(
            color: color,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenH,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Icon(farmStatusIcon(status), size: 18, color: Colors.white),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      message,
                      style: AppTypography.labelLg.copyWith(color: Colors.white),
                    ),
                  ),
                  // Во время просмотра под клиентом всё и так только для
                  // чтения (см. 3.2) — платить чужим тарифом было бы тупиком,
                  // а не действием.
                  if (status == 'read_only' && !auth.isImpersonating)
                    TextButton(
                      onPressed: () => context.push('/subscription'),
                      style: TextButton.styleFrom(foregroundColor: Colors.white),
                      child: Text(l10n.farmStatusBannerAction),
                    ),
                  // Приостановленной ферме продлевать нечего — доступ закрыт
                  // целиком, поэтому вместо «Тариф» здесь путь к тому, что
                  // единственно доступно: написать и спросить почему.
                  if (status == 'suspended' && !auth.isImpersonating)
                    TextButton(
                      onPressed: () => context.push('/support'),
                      style: TextButton.styleFrom(foregroundColor: Colors.white),
                      child: Text(l10n.farmStatusBannerContactSupport),
                    ),
                ],
              ),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
