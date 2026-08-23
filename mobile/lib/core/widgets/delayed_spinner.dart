import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Индикатор загрузки, который появляется не сразу.
///
/// Ответ из кэша или из локальной сети приходит за десятки миллисекунд. Если
/// показывать спиннер немедленно, он успевает мигнуть — и экран выглядит
/// дёрганым именно там, где он на самом деле быстрый. Пауза в
/// [AppDuration.spinnerDelay] убирает мигание, не скрывая настоящую загрузку.
class DelayedSpinner extends StatefulWidget {
  final Duration delay;

  const DelayedSpinner({super.key, this.delay = AppDuration.spinnerDelay});

  @override
  State<DelayedSpinner> createState() => _DelayedSpinnerState();
}

class _DelayedSpinnerState extends State<DelayedSpinner> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay).then((_) {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: AppDuration.fast,
        child: const Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
