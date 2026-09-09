import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/l10n_context.dart';
import '../providers/connectivity.dart';
import '../theme/theme.dart';

/// Плашка «нет связи».
///
/// Оборачивает всё приложение в `main.dart`, как `ImpersonationBanner` и
/// `FarmStatusBanner`: отсутствие связи — состояние устройства, а не свойство
/// экрана, на котором это выяснилось. До неё об офлайне сообщала только ошибка
/// очередного запроса — каждый экран узнавал об этом сам и по отдельности,
/// после таймаута.
///
/// Плашка говорит ровно то, что знает: у устройства нет сети. Про доступность
/// сервера она не высказывается — за это по-прежнему отвечают ошибки запросов
/// и полоса «данные устарели» над списком.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Пока состояние сети неизвестно (первый кадр) считаем, что связь есть:
    // мигнуть плашкой на старте у каждого запуска хуже, чем показать её на
    // сотню миллисекунд позже.
    final isOnline = ref.watch(isOnlineProvider).value ?? true;

    if (isOnline) return child;

    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: Material(
            color: AppColors.offline,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenH,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  const Icon(Icons.wifi_off_outlined,
                      size: 18, color: Colors.white),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      context.l10n.offlineBanner,
                      style:
                          AppTypography.labelLg.copyWith(color: Colors.white),
                    ),
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
