import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/l10n/generated/app_localizations_ru.dart';

/// Строки выносились в переводы с дедупликацией по совпадению текста, и из-за
/// этого разные по смыслу подписи слились в один ключ: клетке досталась
/// подпись «Тип корма» от экрана кормов. Тесты держат разные понятия
/// раздельно, а общие — общими.
void main() {
  final l10n = AppLocalizationsRu();

  group('Тип — у клетки свой, у корма свой', () {
    test('клетка', () => expect(l10n.cageFormType, 'Тип клетки'));
    test('корм', () => expect(l10n.feedsFilterType, 'Тип корма'));
  });

  group('Общие подписи не принадлежат экрану', () {
    test('разделы формы', () {
      expect(l10n.commonSectionMain, 'Основное');
      expect(l10n.commonSectionDetails, 'Подробности');
    });
    test('фильтры', () {
      expect(l10n.commonFilters, 'Фильтры');
      expect(l10n.commonApply, 'Применить');
      expect(l10n.commonReset, 'Сбросить');
    });
    test('прочее', () {
      expect(l10n.commonSummary, 'Сводка');
      expect(l10n.commonPeriod, 'Период');
      expect(l10n.commonEmail, 'Почта');
      expect(l10n.commonNameMissing, 'Имя не указано');
    });
  });
}
