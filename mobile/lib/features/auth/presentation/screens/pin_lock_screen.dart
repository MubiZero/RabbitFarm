import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../data/pin_repository.dart';
import '../providers/pin_provider.dart';
import '../widgets/pin_pad.dart';

/// Замок поверх приложения: пока код не введён, дальше не пускаем.
///
/// Это не маршрут, а слой над всем интерфейсом (см. `PinGate` в main.dart):
/// закрыть нужно и то, что человек оставил открытым, уходя в фон.
class PinLockScreen extends ConsumerStatefulWidget {
  const PinLockScreen({super.key});

  @override
  ConsumerState<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends ConsumerState<PinLockScreen> {
  String _value = '';
  String? _error;
  bool _checking = false;

  Future<void> _onChanged(String value) async {
    setState(() {
      _value = value;
      _error = null;
    });

    if (value.length < PinRepository.pinLength || _checking) return;

    setState(() => _checking = true);
    final ok = await ref.read(pinProvider.notifier).unlock(value);
    if (!mounted) return;

    setState(() {
      _checking = false;
      _value = '';
      _error = ok ? null : context.l10n.pinWrong;
    });
  }

  Future<void> _forgot() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.pinForgotTitle),
        content: Text(context.l10n.pinForgotBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(context.l10n.pinForgotConfirm),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await ref.read(pinProvider.notifier).forgetAndSignOut();
  }

  @override
  Widget build(BuildContext context) {
    final attemptsLeft =
        PinRepository.maxAttempts - ref.watch(pinProvider).failedAttempts;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: context.colors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.lock_outline,
                      size: 32, color: context.accent),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  context.l10n.pinLockPrompt,
                  style: AppTypography.titleMd
                      .copyWith(color: context.colors.onSurface),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                PinPad(
                  value: _value,
                  onChanged: _onChanged,
                  error: _error,
                ),
                // Предупреждаем до того, как сессия слетит, а не после:
                // человек должен успеть вспомнить код или выйти сам.
                if (_error != null && attemptsLeft <= 2) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    context.l10n.pinAttemptsLeft(attemptsLeft),
                    style: AppTypography.labelSm
                        .copyWith(color: context.colors.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                TextButton(
                  onPressed: _forgot,
                  child: Text(context.l10n.pinForgot),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
