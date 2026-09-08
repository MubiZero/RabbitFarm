import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/widgets/widgets.dart';

import '../support/test_app.dart';

/// Ради этих проверок каркасы и появились: пустой экран без объяснения был
/// самым частым дефектом интерфейса, и повторялся он ровно потому, что
/// сочетания «загрузка», «ошибка» и «пусто» каждый экран разбирал заново.

Widget _host(Widget child) => testApp(child);

void main() {
  group('PagedListView', () {
    Widget build({
      List<String> items = const [],
      bool isLoading = false,
      String? error,
    }) =>
        _host(
          PagedListView<String>(
            items: items,
            isLoading: isLoading,
            error: error,
            onRefresh: () async {},
            itemBuilder: (_, item, __) => ListTile(title: Text(item)),
            empty: const AppEmptyState(
              icon: Icons.inbox_outlined,
              title: 'Записей нет',
              subtitle: 'Добавьте первую.',
            ),
          ),
        );

    testWidgets('первая загрузка показывает заглушку, а не пустой экран',
        (tester) async {
      await tester.pumpWidget(build(isLoading: true));
      await tester.pump();

      expect(find.byType(SkeletonCard), findsWidgets);
      expect(find.byType(AppEmptyState), findsNothing);
    });

    testWidgets('пустой список объясняет, что делать дальше', (tester) async {
      await tester.pumpWidget(build());
      await tester.pumpAndSettle();

      expect(find.text('Записей нет'), findsOneWidget);
      expect(find.byType(SkeletonCard), findsNothing);
    });

    testWidgets('ошибка без данных даёт кнопку «Повторить»', (tester) async {
      await tester.pumpWidget(build(error: 'Нет связи с сервером'));
      await tester.pumpAndSettle();

      expect(find.text('Не удалось загрузить'), findsOneWidget);
      expect(find.text('Нет связи с сервером'), findsOneWidget);
      expect(find.text('Повторить'), findsOneWidget);
    });

    testWidgets('ошибка при обновлении оставляет данные и честно предупреждает',
        (tester) async {
      await tester.pumpWidget(
        build(items: const ['Кролик Борис'], error: 'Нет связи с сервером'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Кролик Борис'), findsOneWidget);
      expect(find.byType(StaleDataBanner), findsOneWidget);
      expect(find.byType(AppErrorState), findsNothing);
    });
  });

  group('AppAsyncView', () {
    Widget build(AsyncValue<String> value) => _host(
          AppAsyncView<String>(
            value: value,
            onRetry: () {},
            skeleton: (_) => const SkeletonList(count: 2),
            builder: (data) => Text(data),
          ),
        );

    testWidgets('во время загрузки показывает заглушку', (tester) async {
      await tester.pumpWidget(build(const AsyncValue.loading()));
      await tester.pump();

      expect(find.byType(SkeletonCard), findsWidgets);
    });

    testWidgets('ошибка без данных ведёт к повтору, а не в тупик',
        (tester) async {
      await tester.pumpWidget(
        build(AsyncValue.error('Сервер недоступен', StackTrace.empty)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Повторить'), findsOneWidget);
    });

    testWidgets('прежние данные переживают неудачное обновление',
        (tester) async {
      await tester.pumpWidget(
        // ignore: invalid_use_of_internal_member
        build(
          const AsyncValue<String>.loading()
              // ignore: invalid_use_of_internal_member
              .copyWithPrevious(const AsyncValue.data('12 кроликов'))
              // ignore: invalid_use_of_internal_member
              .copyWithPrevious(
                AsyncValue<String>.error('Нет связи', StackTrace.empty)
                    // ignore: invalid_use_of_internal_member
                    .copyWithPrevious(const AsyncValue.data('12 кроликов')),
              ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('12 кроликов'), findsOneWidget);
    });
  });

  group('AppErrorState', () {
    testWidgets('не показывает пользователю служебное слово Exception',
        (tester) async {
      await tester.pumpWidget(
        _host(const AppErrorState(message: 'Exception: Нет связи с сервером')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Нет связи с сервером'), findsOneWidget);
      expect(
        find.textContaining('Exception'),
        findsNothing,
        reason: 'название класса исключения ничего не говорит фермеру',
      );
    });
  });
}
