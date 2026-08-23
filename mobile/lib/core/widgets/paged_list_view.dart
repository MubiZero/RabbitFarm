import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'app_error_state.dart';
import 'skeleton.dart';
import 'stale_data_banner.dart';

/// Список с подгрузкой по мере прокрутки, обновлением жестом и полным набором
/// состояний.
///
/// Все списочные экраны хранят состояние одинаково — элементы, признак
/// загрузки, текст ошибки и «есть ли ещё страницы», — но каждый экран заново
/// расписывал, что показать при каждом сочетании. Сочетаний шесть, и часть из
/// них теряли: на экране случек первая загрузка не подходила ни под одно
/// условие, и пользователь видел пустой белый экран без единого объяснения.
///
/// Здесь эти сочетания разобраны один раз:
///
/// | Состояние | Что видно |
/// |---|---|
/// | Первая загрузка | Скелетон в форме будущих карточек |
/// | Ошибка, данных нет | Сообщение и кнопка «Повторить» |
/// | Данных нет | Подсказка, как добавить первую запись |
/// | Есть данные | Список; ошибка обновления — полосой сверху |
/// | Догружается страница | Индикатор в конце списка |
///
/// Подгрузка следующей страницы висит на прокрутке самого списка, поэтому
/// экранам больше не нужен собственный `ScrollController` с подпиской в
/// `initState` и отпиской в `dispose`.
class PagedListView<T> extends StatelessWidget {
  final List<T> items;
  final bool isLoading;
  final String? error;
  final bool hasMore;

  final Future<void> Function() onRefresh;
  final VoidCallback? onLoadMore;

  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Что показать, когда записей нет. Пустой экран обязан подсказывать
  /// следующее действие, а не просто сообщать о пустоте.
  final Widget empty;

  /// Заглушка первой загрузки. По умолчанию — столбик карточек-заглушек.
  final WidgetBuilder? skeleton;

  /// Блок над списком: строка фильтров, сводка, поиск. Остаётся на месте и
  /// когда список пуст, иначе фильтр «исчезает» ровно тогда, когда его нужно
  /// сбросить.
  final Widget? header;

  final EdgeInsetsGeometry padding;
  final double separator;

  const PagedListView({
    super.key,
    required this.items,
    required this.isLoading,
    required this.onRefresh,
    required this.itemBuilder,
    required this.empty,
    this.error,
    this.hasMore = false,
    this.onLoadMore,
    this.skeleton,
    this.header,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.screenH,
      AppSpacing.lg,
      AppSpacing.screenH,
      AppSpacing.fabSafeBottom,
    ),
    this.separator = AppSpacing.md,
  });

  bool get _isFirstLoad => items.isEmpty && isLoading;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: CustomScrollView(
          // Тянуть для обновления нужно и тогда, когда содержимое короче
          // экрана, — иначе на пустом списке жест не работает.
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            if (header != null) SliverToBoxAdapter(child: header),
            if (error != null && items.isNotEmpty)
              SliverToBoxAdapter(child: StaleDataBanner(onRetry: onRefresh)),
            ..._body(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _body(BuildContext context) {
    if (_isFirstLoad) {
      return [
        SliverToBoxAdapter(
          child: skeleton?.call(context) ??
              const SkeletonList(padding: EdgeInsets.all(AppSpacing.screenH)),
        ),
      ];
    }

    if (items.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: error != null
              ? AppErrorState(message: error!, onRetry: onRefresh)
              : empty,
        ),
      ];
    }

    return [
      SliverPadding(
        padding: padding,
        sliver: SliverList.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => SizedBox(height: separator),
          itemBuilder: (context, i) => itemBuilder(context, items[i], i),
        ),
      ),
      if (isLoading)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.xl),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
    ];
  }

  bool _onScroll(ScrollNotification n) {
    if (onLoadMore == null || !hasMore || isLoading) return false;
    // Запас в пол-экрана: следующая страница успевает приехать до того, как
    // пользователь долистает до конца.
    final remaining = n.metrics.maxScrollExtent - n.metrics.pixels;
    if (remaining < n.metrics.viewportDimension * 0.5) onLoadMore!();
    return false;
  }
}
