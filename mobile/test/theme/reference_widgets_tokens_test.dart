import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Эталонные виджеты обязаны соблюдать собственные токены.
///
/// С них копируют все остальные экраны, а сами они писали отступы и радиусы
/// числами — отсюда 239 самодельных отступов и 31 радиус по фичам. Дизайнер
/// назвал это корнем: не 370 задач, а пять.
///
/// Тест смотрит ровно туда, где числа и заводились, — в отступы, промежутки
/// и скругления. Размеры значков, доли прозрачности и толщина полос сюда не
/// попадают: это не шкала отступов, и приводить их к ней незачем.
///
/// Проверка файлом, а не виджетом: число возвращается по одной строке за
/// раз, и глазами такое не ловится — ровно так же, как контраст.
void main() {
  const widgets = [
    'stat_tile.dart',
    'status_badge.dart',
    'app_card.dart',
    'alert_card.dart',
    'metric_bar.dart',
  ];

  /// `EdgeInsets.all(12)`, `SizedBox(height: 8)`, `BorderRadius.circular(16)`
  /// — но не `size: 18` и не `alpha: 0.12`.
  final offenders = [
    RegExp(r'EdgeInsets\.(all|symmetric|only|fromLTRB)\([^)]*\b\d'),
    RegExp(r'BorderRadius\.circular\(\s*\d'),
    RegExp(r'SizedBox\(\s*(width|height):\s*\d'),
  ];

  for (final name in widgets) {
    test('$name не пишет отступы и скругления числами', () {
      final file = File('lib/core/widgets/$name');
      expect(file.existsSync(), isTrue, reason: 'не найден $name');

      final found = <String>[];
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.trimLeft().startsWith('//')) continue;
        if (offenders.any((pattern) => pattern.hasMatch(line))) {
          found.add('${i + 1}: ${line.trim()}');
        }
      }

      expect(
        found,
        isEmpty,
        reason: 'возьмите значение из AppSpacing / AppRadius:\n'
            '${found.join('\n')}',
      );
    });
  }

  test('сторож действительно ловит число, а не смотрит мимо', () {
    // Проверка от обратного: предыдущий сторож в этом репозитории —
    // на узбекские апострофы — был зелёным и пропускал строку, потому что
    // шаблон требовал символ, которого в том случае не было.
    const sample = '      padding: const EdgeInsets.all(12),';
    expect(offenders.any((pattern) => pattern.hasMatch(sample)), isTrue);

    const withToken = '      padding: const EdgeInsets.all(AppSpacing.md),';
    expect(offenders.any((pattern) => pattern.hasMatch(withToken)), isFalse);

    // А размер значка трогать не должен.
    const iconSize = '      child: Icon(icon, size: 18, color: color),';
    expect(offenders.any((pattern) => pattern.hasMatch(iconSize)), isFalse);
  });
}
