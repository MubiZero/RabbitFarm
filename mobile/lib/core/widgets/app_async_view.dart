import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/error_text.dart';
import '../l10n/l10n_context.dart';
import 'app_error_state.dart';
import 'delayed_spinner.dart';
import 'stale_data_banner.dart';

/// Показывает данные, загрузку и ошибку по одним правилам на всех экранах.
///
/// Раньше каждый экран расписывал `.when(...)` сам, и правила расходились: на
/// «Сегодня» ошибка превращалась в три пустых блока без единого слова и без
/// возможности повторить, где-то вместо макета крутился спиннер по центру.
///
/// Правила здесь такие:
///
/// * **Первая загрузка** — [skeleton], повторяющий геометрию будущего
///   содержимого, чтобы при подстановке данных ничего не прыгало. Если
///   скелетон не задан, спиннер появляется не сразу: быстрый ответ не должен
///   мигать индикатором.
/// * **Ошибка без данных** — сообщение и кнопка «Повторить». Пустой экран
///   недопустим: пользователь должен понимать, что произошло.
/// * **Ошибка при обновлении, когда данные уже есть** — показываются прежние
///   данные и полоса с предупреждением сверху. Цифры минутной давности
///   полезнее пустоты, но молчать о том, что они устарели, нельзя.
class AppAsyncView<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) builder;

  /// Заглушка на время первой загрузки. Должна повторять компоновку
  /// содержимого: одинаковая высота блоков — это отсутствие рывка.
  final WidgetBuilder? skeleton;

  /// Повторная попытка. Без неё экран с ошибкой становится тупиком.
  final VoidCallback? onRetry;

  const AppAsyncView({
    super.key,
    required this.value,
    required this.builder,
    this.skeleton,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final data = value.valueOrNull;

    if (value.hasError && data == null) {
      return AppErrorState(
        message: errorText(context.l10n, value.error),
        onRetry: onRetry,
      );
    }

    if (data == null) {
      return skeleton?.call(context) ?? const DelayedSpinner();
    }

    if (value.hasError) {
      return Column(
        children: [
          StaleDataBanner(onRetry: onRetry),
          Expanded(child: builder(data)),
        ],
      );
    }

    return builder(data);
  }
}
