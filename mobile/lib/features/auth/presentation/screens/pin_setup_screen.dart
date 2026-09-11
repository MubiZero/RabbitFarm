import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/theme.dart';
import '../../data/pin_repository.dart';
import '../providers/pin_provider.dart';
import '../widgets/pin_pad.dart';

/// Завести код быстрого входа: набрать четыре цифры и повторить их.
///
/// Предлагается сразу после входа по SMS — дальше человек открывает
/// приложение этим кодом, а не ждёт новое сообщение каждый раз. Отказ
/// запоминается: второй раз на каждом входе не спрашиваем.
class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key, this.fromSettings = false});

  /// Из Настроек экран открыт как «сменить код»: после сохранения
  /// возвращаемся назад, а не на «Сегодня», и кнопки «не сейчас» нет.
  final bool fromSettings;

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  String _first = '';
  String _repeat = '';
  bool _confirming = false;
  String? _error;

  void _onChanged(String value) {
    setState(() {
      _error = null;
      if (_confirming) {
        _repeat = value;
      } else {
        _first = value;
      }
    });

    if (value.length < PinRepository.pinLength) return;

    if (!_confirming) {
      // Переход к повтору — не мгновенный: иначе четвёртая цифра и смена
      // подписи происходят в один кадр, и непонятно, что вообще случилось.
      Future.delayed(const Duration(milliseconds: 150), () {
        if (!mounted) return;
        setState(() => _confirming = true);
      });
      return;
    }

    if (_repeat != _first) {
      setState(() {
        _error = context.l10n.pinMismatch;
        _repeat = '';
      });
      return;
    }
    _save();
  }

  Future<void> _save() async {
    await ref.read(pinProvider.notifier).setPin(_first);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.pinSaved)),
    );
    if (widget.fromSettings) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  Future<void> _skip() async {
    await ref.read(pinProvider.notifier).decline();
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final value = _confirming ? _repeat : _first;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fromSettings
            ? context.l10n.pinChangeTitle
            : context.l10n.pinSetupTitle),
        automaticallyImplyLeading: widget.fromSettings,
      ),
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
                Text(
                  _confirming
                      ? context.l10n.pinRepeatPrompt
                      : context.l10n.pinSetupPrompt,
                  style: AppTypography.titleMd
                      .copyWith(color: context.colors.onSurface),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  context.l10n.pinSetupExplanation,
                  style: AppTypography.bodyMd
                      .copyWith(color: context.colors.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                PinPad(value: value, onChanged: _onChanged, error: _error),
                const SizedBox(height: AppSpacing.lg),
                if (!widget.fromSettings)
                  TextButton(
                    onPressed: _skip,
                    child: Text(context.l10n.pinSkip),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
