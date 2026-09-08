import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../providers/auth_provider.dart';

/// Плашка входа под клиентом (см. docs/plans/PLATFORM-ADMIN.md, 3.2) — на
/// весь сеанс просмотра, поверх любого экрана, а не только карточки фермы:
/// именно поэтому она оборачивает всё приложение в `main.dart`, а не живёт
/// внутри одного маршрута.
///
/// Когда сеанс кончается сам (истёк 15-минутный токен), плашка на несколько
/// секунд переключается на предупреждение вместо того, чтобы молча исчезнуть
/// — иначе админ решил бы, что подвисло приложение, а не что оно вернуло его
/// в собственный аккаунт.
class ImpersonationBanner extends ConsumerStatefulWidget {
  const ImpersonationBanner({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ImpersonationBanner> createState() =>
      _ImpersonationBannerState();
}

class _ImpersonationBannerState extends ConsumerState<ImpersonationBanner> {
  Timer? _expiredNoticeTimer;
  bool _showExpiredNotice = false;

  @override
  void dispose() {
    _expiredNoticeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.impersonationJustExpired &&
          previous?.impersonationJustExpired != true) {
        ref.read(authProvider.notifier).clearImpersonationExpiredNotice();
        setState(() => _showExpiredNotice = true);
        _expiredNoticeTimer?.cancel();
        _expiredNoticeTimer = Timer(const Duration(seconds: 4), () {
          if (mounted) setState(() => _showExpiredNotice = false);
        });
      }
    });

    final auth = ref.watch(authProvider);

    if (!auth.isImpersonating && !_showExpiredNotice) {
      return widget.child;
    }

    final l10n = context.l10n;

    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: Material(
            color: _showExpiredNotice ? AppColors.warning : AppColors.info,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenH,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  const Icon(Icons.visibility_outlined,
                      size: 18, color: Colors.white),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      _showExpiredNotice
                          ? l10n.impersonationExpired
                          : l10n.impersonationBanner(
                              auth.impersonatedFarmName ?? ''),
                      style: AppTypography.labelLg
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  if (auth.isImpersonating)
                    TextButton(
                      onPressed: () =>
                          ref.read(authProvider.notifier).exitImpersonation(),
                      style: TextButton.styleFrom(foregroundColor: Colors.white),
                      child: Text(l10n.impersonationExit),
                    ),
                ],
              ),
            ),
          ),
        ),
        Expanded(child: widget.child),
      ],
    );
  }
}
