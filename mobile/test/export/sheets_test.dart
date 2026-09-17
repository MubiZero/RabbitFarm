import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/core/export/csv.dart';
import 'package:mobile/features/finance/data/models/transaction_model.dart';
import 'package:mobile/features/finance/presentation/utils/finance_sheet.dart';
import 'package:mobile/features/health/data/models/medical_record_model.dart';
import 'package:mobile/features/health/data/models/vaccination_model.dart';
import 'package:mobile/features/health/presentation/utils/health_sheet.dart';
import 'package:mobile/l10n/generated/app_localizations_ru.dart';

/// Бумагу носят ветеринару и в банк, а таблицу открывают в Excel — и то и
/// другое вне приложения, где ошибку уже не исправить. Поэтому проверяется
/// не «функция вернула строку», а что именно в ней окажется.
void main() {
  // Без этого любой `DateFormat` с русской локалью падает: в тестовом
  // окружении данные локалей не подгружаются сами.
  setUpAll(() => initializeDateFormatting('ru'));

  final l10n = AppLocalizationsRu();

  final vaccination = Vaccination(
    id: 1,
    rabbitId: 7,
    vaccineName: 'ВГБК',
    vaccineType: VaccineType.vhd,
    vaccinationDate: DateTime(2026, 9, 10),
    nextVaccinationDate: DateTime(2027, 3, 10),
    veterinarian: 'Ветврач Саидов',
    cost: 12.5,
  );

  final treatment = MedicalRecord(
    id: 2,
    rabbitId: 7,
    symptoms: 'Вялость, отказ от корма',
    diagnosis: 'Кокцидиоз',
    treatment: 'Байкокс',
    medication: 'Байкокс 2,5%',
    startedAt: DateTime(2026, 9, 12),
    endedAt: DateTime(2026, 9, 18),
    outcome: MedicalOutcome.recovered,
    cost: 30,
  );

  const rabbit = HealthSheetRabbit(
    name: 'Мушка',
    tagId: 'A-0231',
    breed: 'Калифорнийская',
    sex: 'Самка',
    weight: 4.2,
  );

  group('карта здоровья на бумаге', () {
    String sheet({
      List<Vaccination> vaccinations = const [],
      List<MedicalRecord> treatments = const [],
    }) =>
        buildHealthSheetHtml(
          rabbit: rabbit,
          vaccinations: vaccinations,
          treatments: treatments,
          l10n: l10n,
          dateLocale: 'ru',
          outcomeLabel: (outcome) => 'Выздоровел',
          printedAt: DateTime(2026, 9, 17),
        );

    test('кролик назван так, чтобы ветеринар его узнал', () {
      final html = sheet(vaccinations: [vaccination]);

      expect(html, contains('Мушка'));
      expect(html, contains('A-0231'));
      expect(html, contains('Калифорнийская'));
      // Вес — с единицей: «4,2» без «кг» на бумаге ничего не значит.
      expect(html, contains('4,2 кг'));
    });

    test('прививка попадает на лист с датой следующей', () {
      final html = sheet(vaccinations: [vaccination]);

      expect(html, contains('ВГБК'));
      expect(html, contains('10 сент. 2026'));
      expect(html, contains('10 мар. 2027'));
      expect(html, contains('Ветврач Саидов'));
    });

    test('лечение показано сроком, а не одной датой', () {
      final html = sheet(treatments: [treatment]);

      expect(html, contains('Кокцидиоз'));
      expect(html, contains('Байкокс'));
      expect(html, contains('12 сент. 2026 — 18 сент. 2026'));
      expect(html, contains('Выздоровел'));
    });

    test('пустой раздел говорит словами, а не пустой таблицей', () {
      // Пустая таблица на бумаге читается как «забыли напечатать».
      final html = sheet(treatments: [treatment]);

      expect(html, contains('Прививок не записано'));
    });

    test('кличка с угловой скобкой не разваливает вёрстку', () {
      final html = buildHealthSheetHtml(
        rabbit: const HealthSheetRabbit(name: '<Мушка>'),
        vaccinations: [vaccination],
        treatments: const [],
        l10n: l10n,
        dateLocale: 'ru',
      );

      expect(html, contains('&lt;Мушка&gt;'));
      expect(html, isNot(contains('<Мушка>')));
    });
  });

  group('карта здоровья таблицей', () {
    test('прививки и лечение идут одним списком с колонкой «что это»', () {
      final csv = buildHealthSheetCsv(
        rabbit: rabbit,
        vaccinations: [vaccination],
        treatments: [treatment],
        l10n: l10n,
        outcomeLabel: (outcome) => 'Выздоровел',
      );

      final lines = csv.trimRight().split('\r\n');
      expect(lines, hasLength(3));
      expect(lines[1], startsWith('Прививка;10.09.2026;ВГБК'));
      expect(lines[2], startsWith('Лечение;12.09.2026;Кокцидиоз'));
    });

    test('запятая внутри значения не разъезжается на два столбца', () {
      final csv = buildHealthSheetCsv(
        rabbit: rabbit,
        vaccinations: const [],
        treatments: [treatment.copyWith(diagnosis: null)],
        l10n: l10n,
      );

      // Разделитель — точка с запятой, и в симптомах она не встречается,
      // зато встречается в «Байкокс 2,5%» — проверяем и то, и другое.
      expect(csv, contains('Вялость, отказ от корма'));
      expect(csv, contains('Байкокс 2,5%'));
    });

    test('файл начинается с BOM — иначе Excel покажет кашу вместо кириллицы',
        () {
      final csv = buildHealthSheetCsv(
        rabbit: rabbit,
        vaccinations: [vaccination],
        treatments: const [],
        l10n: l10n,
      );

      expect(csv.codeUnitAt(0), 0xFEFF);
    });
  });

  group('книга доходов и расходов', () {
    final income = Transaction(
      id: 1,
      type: TransactionType.income,
      category: TransactionCategory.saleRabbit,
      amount: 450,
      transactionDate: DateTime(2026, 9, 3),
      description: 'Продал двух самцов',
    );
    final expense = Transaction(
      id: 2,
      type: TransactionType.expense,
      category: TransactionCategory.feed,
      amount: 120.5,
      transactionDate: DateTime(2026, 9, 5),
    );

    String labelOf(TransactionCategory category) => category.name;

    test('итог считается по типу операции, а не по знаку суммы', () {
      final totals = totalsOf([income, expense]);

      expect(totals.income, 450);
      expect(totals.expense, 120.5);
      expect(totals.balance, 329.5);
    });

    test('лист несёт итог наверху — за ним и приходят в банк', () {
      final html = buildFinanceSheetHtml(
        transactions: [income, expense],
        from: DateTime(2026, 9, 1),
        to: DateTime(2026, 9, 30),
        l10n: l10n,
        dateLocale: 'ru',
        currency: 'с',
        categoryLabel: labelOf,
        printedAt: DateTime(2026, 9, 17),
      );

      expect(html, contains('329,5 с'));
      expect(html, contains('1 сент. 2026'));
      expect(html, contains('Продал двух самцов'));
    });

    test('пустой срок сказан словами, а не пустой таблицей', () {
      final html = buildFinanceSheetHtml(
        transactions: const [],
        from: DateTime(2026, 9, 1),
        to: DateTime(2026, 9, 30),
        l10n: l10n,
        dateLocale: 'ru',
        currency: 'с',
        categoryLabel: labelOf,
      );

      expect(html, contains('За этот срок операций не записано'));
    });

    test('в таблице сумма с запятой — иначе Excel считает её текстом', () {
      final csv = buildFinanceSheetCsv(
        transactions: [expense],
        l10n: l10n,
        categoryLabel: labelOf,
        typeLabel: (type) => type.name,
      );

      expect(csv, contains('120,5'));
      expect(csv, isNot(contains('120.5')));
    });
  });

  group('общая сборка таблицы', () {
    test('кавычка внутри значения удваивается', () {
      final csv = buildCsv([
        ['Кличка'],
        ['Мушка "Быстрая"'],
      ]);

      expect(csv, contains('"Мушка ""Быстрая"""'));
    });

    test('целое число идёт без хвоста из нулей', () {
      expect(csvNumber(12), '12');
      expect(csvNumber(12.5), '12,5');
      expect(csvNumber(null), '');
    });
  });
}
