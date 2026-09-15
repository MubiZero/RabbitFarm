import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/features/cages/data/models/cage_model.dart';
import 'package:mobile/features/cages/presentation/utils/cage_tag.dart';

/// Метка на клетке — бумажка, которая висит в сарае год и мокнет. Проверяется
/// то, от чего зависит, откроется ли клетка: что кодируется, что принимается
/// обратно и что на листе действительно есть номер клетки.
CageModel _cage(int id, String number, {String? location}) => CageModel(
  id: id,
  number: number,
  type: 'single',
  capacity: 1,
  condition: 'good',
  location: location,
);

void main() {
  group('код метки', () {
    test('туда и обратно', () {
      expect(cageIdFromTag(cageTagPayload(14)), 14);
    });

    test('чужая наклейка на клетке — не ошибка, а «не наша метка»', () {
      // В крольчатнике на клетках висят и наклейки поставщика, и штрихкоды
      // с мешка комбикорма. Камеру на них наведут обязательно.
      expect(cageIdFromTag('https://example.com/cage/14'), isNull);
      expect(cageIdFromTag('4607034730017'), isNull);
      expect(cageIdFromTag(null), isNull);
      expect(cageIdFromTag(''), isNull);
    });

    test('чужая ссылка нашей же схемы клетку не открывает', () {
      // Приглашение сотрудника — тоже rabbitfarm://, и спутать их нельзя.
      expect(cageIdFromTag('rabbitfarm://join?phone=+992000000000'), isNull);
      expect(cageIdFromTag('rabbitfarm://cage/'), isNull);
      expect(cageIdFromTag('rabbitfarm://cage/abc'), isNull);
    });
  });

  group('лист меток', () {
    test('несёт номер клетки и её место', () {
      final html = cageTagsHtml(
        [_cage(1, 'A-1', location: 'Первый ряд'), _cage(2, 'A-2')],
        hint: 'Вырежьте по рамке',
      );

      expect(html, contains('A-1'));
      expect(html, contains('Первый ряд'));
      expect(html, contains('A-2'));
      expect(html, contains('Вырежьте по рамке'));
      // Код рисуется прямо в разметку: картинке негде храниться, а внешняя
      // ссылка на печати не загрузится.
      expect(html, contains('<svg'));
    });

    test('угловые скобки в номере не ломают разметку', () {
      final html = cageTagsHtml([_cage(3, 'A<1>')], hint: '');

      expect(html, contains('A&lt;1&gt;'));
      expect(html, isNot(contains('A<1>')));
    });
  });
}
