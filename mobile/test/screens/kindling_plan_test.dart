import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/core/access/farm_access.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/breeding/data/repositories/breeding_repository.dart';
import 'package:mobile/features/breeding/domain/kindling_plan.dart';
import 'package:mobile/features/breeding/presentation/providers/breeding_provider.dart';
import 'package:mobile/features/breeding/presentation/screens/breeding_cycle_screen.dart';
import 'package:mobile/features/breeding/presentation/utils/kindling_plan_sheet.dart';
import 'package:mobile/features/breeding/presentation/widgets/kindling_plan_button.dart';
import 'package:mobile/features/rabbits/data/models/breeding_model.dart';
import 'package:mobile/features/rabbits/data/models/rabbit_model.dart';
import 'package:mobile/l10n/generated/app_localizations.dart';
import 'package:mobile/shared/models/api_response.dart';

import '../support/test_app.dart';

/// План окролов уезжает на бумагу и висит в сарае — перепечатать его сложнее,
/// чем перезагрузить экран. Поэтому проверяется то, что на листе: какие
/// строки на него попали, какой день назван днём маточника и что пустой месяц
/// не уходит в печать молча.
class _FakeBreedingRepository extends BreedingRepository {
  final List<BreedingModel> items;

  /// С каким статусом спросили случки: плану нужны только незакрытые.
  String? askedStatus;
  int? askedLimit;

  _FakeBreedingRepository({this.items = const []})
      : super(
          apiClient: ApiClient(
            storage: const FlutterSecureStorage(),
            baseUrl: 'http://localhost',
          ),
        );

  @override
  Future<PaginatedResponse<BreedingModel>> getBreedings({
    int page = 1,
    int limit = 20,
    String? status,
    int? maleId,
    int? femaleId,
    String? fromDate,
    String? toDate,
  }) async {
    askedStatus = status;
    askedLimit = limit;
    return PaginatedResponse<BreedingModel>(
      items: items,
      total: items.length,
      page: 1,
      limit: limit,
      totalPages: 1,
    );
  }
}

String _iso(DateTime date) => '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

RabbitModel _female(String name, {String? cage}) => RabbitModel(
      id: 20,
      tagId: 'A-20',
      name: name,
      breedId: 1,
      sex: 'female',
      birthDate: DateTime(2024, 1, 1),
      status: 'active',
      purpose: 'breeding',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
      cage: cage == null ? null : CageInfo(id: 5, number: cage),
    );

BreedingModel _breeding({
  int id = 1,
  required DateTime expectedBirth,
  String status = 'planned',
  bool? isPregnant,
  String femaleName = 'Зорька',
  String? cage = 'К-12',
}) {
  final bred = expectedBirth.subtract(const Duration(days: 31));
  return BreedingModel(
    id: id,
    maleId: 10,
    femaleId: 20,
    breedingDate: _iso(bred),
    status: status,
    isPregnant: isPregnant,
    expectedBirthDate: _iso(expectedBirth),
    female: _female(femaleName, cage: cage),
  );
}

Widget _wrap(KindlingSheetPrinter printer, _FakeBreedingRepository repository) =>
    testApp(
      Align(alignment: Alignment.topRight, child: KindlingPlanButton(printer: printer)),
      overrides: [breedingRepositoryProvider.overrideWithValue(repository)],
    );

/// Текущий месяц — тот, который предложат первым выбором.
DateTime get _thisMonth {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
}

void main() {
  setUpAll(() => initializeDateFormatting('ru_RU', null));

  group('строки плана', () {
    test('в план идут только окролы месяца, которых ещё ждут', () {
      final rows = kindlingPlanForMonth(
        [
          _breeding(id: 1, expectedBirth: DateTime(2026, 9, 20)),
          _breeding(id: 2, expectedBirth: DateTime(2026, 9, 5), femaleName: 'Белка'),
          // Соседний месяц — не на этом листе.
          _breeding(id: 3, expectedBirth: DateTime(2026, 10, 2), femaleName: 'Чужая'),
          // Отменённая случка и пустая самка окрола не дадут.
          _breeding(id: 4, expectedBirth: DateTime(2026, 9, 9), status: 'cancelled', femaleName: 'Отменённая'),
          _breeding(id: 5, expectedBirth: DateTime(2026, 9, 11), isPregnant: false, femaleName: 'Пустая'),
          // Окрол уже записан — на листе «что сделать» ему делать нечего.
          _breeding(id: 6, expectedBirth: DateTime(2026, 9, 12), status: 'completed', femaleName: 'Окотившаяся'),
        ],
        month: DateTime(2026, 9),
      );

      expect(rows.map((row) => row.female), ['Белка', 'Зорька']);
      expect(rows.first.birthDate, DateTime(2026, 9, 5));
      expect(rows.first.cage, 'К-12');
    });

    test('маточник ставят за три дня до окрола — как и задача с сервера', () {
      final rows = kindlingPlanForMonth(
        [_breeding(expectedBirth: DateTime(2026, 9, 14))],
        month: DateTime(2026, 9),
      );

      expect(rows.single.nestBoxDate, DateTime(2026, 9, 11));
      expect(rows.single.breedingDate, DateTime(2026, 8, 14));
    });

    test('без клетки строка остаётся, но номер не выдумывается', () {
      final rows = kindlingPlanForMonth(
        [_breeding(expectedBirth: DateTime(2026, 9, 14), cage: null)],
        month: DateTime(2026, 9),
      );

      expect(rows.single.cage, isNull);
    });
  });

  group('лист', () {
    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(const Locale('ru'));
    });

    String sheet(List<BreedingModel> breedings) => buildKindlingPlanHtml(
          rows: kindlingPlanForMonth(breedings, month: DateTime(2026, 9)),
          month: DateTime(2026, 9),
          l10n: l10n,
          dateLocale: 'ru',
          printedAt: DateTime(2026, 9, 1),
        );

    test('на листе есть месяц, ожидаемые окролы и дни маточника', () {
      final html = sheet([
        _breeding(expectedBirth: DateTime(2026, 9, 14)),
        _breeding(id: 2, expectedBirth: DateTime(2026, 9, 20), femaleName: 'Белка', cage: 'К-3'),
      ]);

      expect(html, contains('сентябрь 2026'));
      expect(html, contains('Зорька'));
      expect(html, contains('Белка'));
      expect(html, contains('К-12'));
      expect(html, contains('К-3'));
      // Окрол 14-го — маточник 11-го; окрол 20-го — маточник 17-го.
      expect(html, contains('14 сент'));
      expect(html, contains('11 сент'));
      expect(html, contains('17 сент'));
      // Колонка под карандаш и подсказка про маточник — ради них лист и висит.
      expect(html, contains(l10n.kindlingPlanColMark));
      expect(html, contains(l10n.kindlingPlanNestHint));
      // Строки идут по дням: 14-е выше 20-го.
      expect(html.indexOf('Зорька'), lessThan(html.indexOf('Белка')));
    });

    test('кличка не ломает разметку листа', () {
      final html = sheet([
        _breeding(expectedBirth: DateTime(2026, 9, 14), femaleName: 'Зорька <b>'),
      ]);

      expect(html, contains('Зорька &lt;b&gt;'));
      expect(html, isNot(contains('Зорька <b>')));
    });
  });

  group('кнопка печати', () {
    Future<void> pickThisMonth(WidgetTester tester) async {
      await tester.tap(find.byTooltip('План окролов'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('На этот месяц'));
      await tester.pumpAndSettle();
    }

    testWidgets('лист печатает и работник — по клеткам ходит он',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(420, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(testAppScreen(
        const BreedingCycleScreen(),
        overrides: [
          farmRoleProvider.overrideWithValue(FarmRoleAccess.worker),
          breedingRepositoryProvider
              .overrideWithValue(_FakeBreedingRepository()),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.byTooltip('План окролов'), findsOneWidget);
      // Записи заводит не он — эта кнопка ему и не показывается.
      expect(find.text('Подобрать пару'), findsNothing);
    });

    testWidgets('пустой месяц не уходит в печать, а объясняется словами',
        (tester) async {
      final repository = _FakeBreedingRepository();
      var printed = 0;

      await tester.pumpWidget(_wrap(
        ({required String html, required String documentName}) async => printed++,
        repository,
      ));
      await tester.pumpAndSettle();
      await pickThisMonth(tester);

      expect(printed, 0);
      expect(find.textContaining('окролов не ожидается'), findsOneWidget);
    });

    testWidgets('месяц с окролами уходит в печать листом с этими окролами',
        (tester) async {
      final month = _thisMonth;
      final repository = _FakeBreedingRepository(items: [
        _breeding(expectedBirth: DateTime(month.year, month.month, 14)),
      ]);
      String? printedHtml;
      String? printedName;

      await tester.pumpWidget(_wrap(
        ({required String html, required String documentName}) async {
          printedHtml = html;
          printedName = documentName;
        },
        repository,
      ));
      await tester.pumpAndSettle();
      await pickThisMonth(tester);

      expect(printedHtml, contains('Зорька'));
      expect(printedHtml, contains('К-12'));
      expect(printedName, contains('${month.year}'));
      // Плану нужны только незакрытые случки, и не первая страница ленты.
      expect(repository.askedStatus, 'planned');
      expect(repository.askedLimit, greaterThan(20));
      expect(find.textContaining('окролов не ожидается'), findsNothing);
    });
  });
}
