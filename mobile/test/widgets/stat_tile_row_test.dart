import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/widgets/stat_tile.dart';

import '../support/test_app.dart';

/// Плитки чисел стоят рядами по две-три, и подписи у них разной длины:
/// «Сейчас» рядом с «С прошлого раза». Собранный вручную `Row` равняет их по
/// центру, и плитка с подписью в две строки становится выше соседних — ряд
/// выглядит разъехавшимся. `StatTileRow` меряет самую высокую и равняет по
/// ней остальные.
void main() {
  testWidgets('плитки в ряду одной высоты, даже с подписью в две строки',
      (tester) async {
    await tester.pumpWidget(testApp(
      const StatTileRow(
        tiles: [
          StatTile(icon: Icons.scale_outlined, label: 'Сейчас', value: '2,32 кг'),
          StatTile(
            icon: Icons.remove,
            label: 'С прошлого раза, а подпись тут длинная',
            value: '—',
          ),
          StatTile(icon: Icons.remove, label: 'За всё время', value: '0 кг'),
        ],
      ),
    ));

    final heights = tester
        .widgetList<StatTile>(find.byType(StatTile))
        .map((tile) => tester.getSize(find.byWidget(tile)).height)
        .toSet();

    expect(heights, hasLength(1),
        reason: 'плитки одного ряда не должны быть разной высоты');
  });

  test('ряды плиток собраны общим виджетом, а не руками', () {
    // Сторож класса ошибок: общий ряд в проекте есть, и обходить его
    // собственным `Row` — значит снова получить разъехавшиеся высоты на
    // очередном экране.
    final offenders = <String>[];
    final handmade = RegExp(
      r'Row\(\s*\n\s*children: \[\s*\n\s*Expanded\(\s*\n\s*child: StatTile\(',
      multiLine: true,
    );

    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final text = entity.readAsStringSync();
      if (handmade.hasMatch(text)) offenders.add(entity.path);
    }

    expect(offenders, isEmpty,
        reason: 'эти экраны собирают ряд плиток сами — им нужен StatTileRow');
  });
}
