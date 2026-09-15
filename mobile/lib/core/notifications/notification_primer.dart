import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/l10n_context.dart';
import '../theme/theme.dart';
import 'fcm_service.dart';
import 'notification_permission.dart';

/// Объяснение перед системным вопросом о разрешении.
///
/// Говорит выгодой, а не механикой: не «приложение запрашивает разрешение на
/// отправку уведомлений», а что именно человек не пропустит. Ради этого
/// экран и существует — системный диалог такого сказать не умеет.
class NotificationPrimerSheet extends ConsumerStatefulWidget {
  const NotificationPrimerSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => const NotificationPrimerSheet(),
      );

  @override
  ConsumerState<NotificationPrimerSheet> createState() =>
      _NotificationPrimerSheetState();
}

class _NotificationPrimerSheetState
    extends ConsumerState<NotificationPrimerSheet> {
  bool _asking = false;

  Future<void> _allow() async {
    setState(() => _asking = true);
    final permission = ref.read(notificationPermissionProvider);
    final fcm = ref.read(fcmServiceProvider);

    final granted = await permission.requestFromSystem();
    // Токен привязывается только после согласия: раньше регистрация шла
    // вместе с самим запросом разрешения и уезжала на сервер даже тогда,
    // когда человек отказал.
    if (granted) await fcm.registerCurrentToken();

    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _decline() async {
    await ref.read(notificationPermissionProvider).markPrimerSeen();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(
                Icons.notifications_active_outlined,
                size: 28,
                color: colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.notificationPrimerTitle,
                style: context.text.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.notificationPrimerBody,
              style: context.text.bodyLarge?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              height: AppSizes.touchTargetLarge,
              child: FilledButton(
                onPressed: _asking ? null : _allow,
                child: _asking
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.notificationPrimerAllow),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              height: AppSizes.touchTarget,
              child: TextButton(
                onPressed: _asking ? null : _decline,
                child: Text(l10n.notificationPrimerDecline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Невидимый сторож: решает, пора ли показать объяснение.
///
/// Момент выбран не «сразу после входа», а когда на ферме уже есть хотя бы
/// один кролик: до этого напоминать не о чем, и вопрос выглядел бы поборами
/// вперёд.
class NotificationPrimerGate extends ConsumerStatefulWidget {
  const NotificationPrimerGate({super.key, required this.enabled});

  final bool enabled;

  @override
  ConsumerState<NotificationPrimerGate> createState() =>
      _NotificationPrimerGateState();
}

class _NotificationPrimerGateState
    extends ConsumerState<NotificationPrimerGate> {
  /// Одна попытка за жизнь экрана: список «Сегодня» перестраивается при
  /// каждом обновлении, и без этого флага проверка уходила бы заново на
  /// каждый кадр.
  bool _checked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeShow();
  }

  @override
  void didUpdateWidget(NotificationPrimerGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    _maybeShow();
  }

  Future<void> _maybeShow() async {
    if (_checked || !widget.enabled) return;
    _checked = true;

    if (!await ref.read(notificationPermissionProvider).shouldShowPrimer()) {
      return;
    }
    if (!mounted) return;
    await NotificationPrimerSheet.show(context);
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
