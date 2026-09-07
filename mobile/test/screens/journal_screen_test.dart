import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/core/access/farm_access.dart';
import 'package:mobile/core/api/api_failure.dart';
import 'package:mobile/features/home/data/models/journal_entry.dart';
import 'package:mobile/features/home/presentation/providers/journal_provider.dart';
import 'package:mobile/features/home/presentation/screens/journal_screen.dart';

import '../support/test_app.dart';

final _today = DateTime.now();

JournalEntry _entry({
  required JournalKind kind,
  required DateTime at,
  bool hasTime = true,
  String? title,
  String? rabbitName,
  String? cageNumber,
  String? author,
  String? imageUrl,
}) =>
    JournalEntry(
      kind: kind,
      at: at,
      hasTime: hasTime,
      title: title,
      rabbitName: rabbitName,
      cageNumber: cageNumber,
      author: author,
      imageUrl: imageUrl,
      formArgs: Object(),
    );

Future<void> _pumpJournal(
  WidgetTester tester,
  Override feed, {
  FarmRoleAccess role = FarmRoleAccess.worker,
}) async {
  await tester.binding.setSurfaceSize(const Size(420, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(testAppScreen(
    const JournalScreen(),
    overrides: [farmRoleProvider.overrideWithValue(role), feed],
  ));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Override _feed(List<JournalEntry> entries) =>
    journalFeedProvider(JournalPeriod.today).overrideWith((ref) async => entries);

void main() {
  setUpAll(() => initializeDateFormatting('ru', null));

  testWidgets('строка называет вид записи, кому она и кто записал',
      (tester) async {
    await _pumpJournal(
      tester,
      _feed([
        _entry(
          kind: JournalKind.feeding,
          at: DateTime(_today.year, _today.month, _today.day, 8, 30),
          title: 'Сено луговое',
          rabbitName: 'Зорька',
          author: 'Иван Работник',
        ),
      ]),
    );

    expect(find.text('Сено луговое'), findsOneWidget);
    // Вид записи назван словом, а не только цветом значка.
    expect(find.text('Кормление · Кролик Зорька'), findsOneWidget);
    expect(find.text('08:30'), findsOneWidget);
    expect(find.text('Иван Работник'), findsOneWidget);
  });

  testWidgets('у прививки показывается день, а не выдуманное время',
      (tester) async {
    await _pumpJournal(
      tester,
      _feed([
        _entry(
          kind: JournalKind.vaccination,
          at: DateTime(_today.year, _today.month, _today.day),
          hasTime: false,
          title: 'ВГБК',
          rabbitName: 'Зорька',
        ),
      ]),
    );

    expect(find.text('00:00'), findsNothing);
    expect(find.text('Прививка · Кролик Зорька'), findsOneWidget);
  });

  testWidgets('заметка без привязки к кролику или клетке показывает текст',
      (tester) async {
    await _pumpJournal(
      tester,
      _feed([
        _entry(
          kind: JournalKind.note,
          at: DateTime(_today.year, _today.month, _today.day, 14),
          title: 'Заказать сено на следующую неделю',
        ),
      ]),
    );

    expect(find.text('Заказать сено на следующую неделю'), findsOneWidget);
    // Без кролика и клетки строка вида не приписывает лишней цели.
    expect(find.text('Заметка'), findsOneWidget);
  });

  testWidgets('фото без подписи подписывается видом записи, а не кормом',
      (tester) async {
    await _pumpJournal(
      tester,
      _feed([
        _entry(
          kind: JournalKind.photo,
          at: DateTime(_today.year, _today.month, _today.day, 10),
          rabbitName: 'Зорька',
        ),
      ]),
    );

    // Общий фолбэк для записи без заголовка — вид записи, а не текст,
    // придуманный для кормления без корма.
    expect(find.text('Фото'), findsWidgets);
    expect(find.text('Корм не указан'), findsNothing);
  });

  testWidgets('пустой журнал зовёт сделать первую запись', (tester) async {
    await _pumpJournal(tester, _feed(const []));

    expect(find.text('Записей нет'), findsNothing);
    expect(find.textContaining('ничего не записано'), findsOneWidget);
    expect(find.text('Записать'), findsOneWidget);
  });

  testWidgets('сбой загрузки объясняется и даёт повторить', (tester) async {
    await _pumpJournal(
      tester,
      journalFeedProvider(JournalPeriod.today).overrideWith(
        (ref) async => throw const ApiFailure(ApiFailureKind.offline),
      ),
    );

    expect(find.text('Нет связи — проверьте интернет'), findsOneWidget);
    expect(find.text('Повторить'), findsOneWidget);
  });

  testWidgets('фильтр оставляет записи только выбранного вида',
      (tester) async {
    final at = DateTime(_today.year, _today.month, _today.day, 9);

    await _pumpJournal(
      tester,
      _feed([
        _entry(
          kind: JournalKind.feeding,
          at: at,
          title: 'Сено луговое',
        ),
        _entry(
          kind: JournalKind.task,
          at: at.subtract(const Duration(hours: 1)),
          title: 'Вычистить клетки',
        ),
      ]),
    );

    expect(find.text('Сено луговое'), findsOneWidget);
    expect(find.text('Вычистить клетки'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilterChip, 'Задача'));
    await tester.pumpAndSettle();

    expect(find.text('Сено луговое'), findsNothing);
    expect(find.text('Вычистить клетки'), findsOneWidget);
  });

  testWidgets('когда вид записи один, фильтровать нечего', (tester) async {
    await _pumpJournal(
      tester,
      _feed([
        _entry(
          kind: JournalKind.feeding,
          at: DateTime(_today.year, _today.month, _today.day, 9),
          title: 'Сено луговое',
        ),
      ]),
    );

    expect(find.byType(FilterChip), findsNothing);
  });
}
