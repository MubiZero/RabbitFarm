import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/core/access/farm_access.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/api/api_failure.dart';
import 'package:mobile/features/health/data/models/medical_record_model.dart';
import 'package:mobile/features/health/data/models/vaccination_model.dart';
import 'package:mobile/features/health/data/repositories/medical_records_repository.dart';
import 'package:mobile/features/health/data/repositories/vaccinations_repository.dart';
import 'package:mobile/features/health/presentation/providers/medical_records_provider.dart';
import 'package:mobile/features/health/presentation/screens/health_journal_screen.dart';
import 'package:mobile/features/rabbits/data/models/rabbit_model.dart';

import '../support/test_app.dart';

/// В записях здоровья кролик приходит краткой ссылкой, а не полной моделью:
/// сервер отдаёт только id, кличку и клеймо.
RabbitRef _rabbit(String name) => RabbitRef(id: 7, tagId: 'A-7', name: name);

Vaccination _vaccination({
  required int id,
  required String name,
  required DateTime date,
  DateTime? next,
  RabbitRef? rabbit,
}) =>
    Vaccination(
      id: id,
      rabbitId: rabbit?.id ?? 7,
      vaccineName: name,
      vaccineType: VaccineType.vhd,
      vaccinationDate: date,
      nextVaccinationDate: next,
      rabbit: rabbit,
    );

MedicalRecord _treatment({
  required int id,
  required String symptoms,
  required DateTime startedAt,
  String? diagnosis,
  DateTime? endedAt,
  MedicalOutcome outcome = MedicalOutcome.ongoing,
}) =>
    MedicalRecord(
      id: id,
      rabbitId: 7,
      symptoms: symptoms,
      diagnosis: diagnosis,
      startedAt: startedAt,
      endedAt: endedAt,
      outcome: outcome,
    );

/// Репозитории без сети: подменяются целиком, чтобы под тестом осталась
/// настоящая работа провайдера — слияние двух источников в одну ленту и
/// порядок по дате.
class _FakeVaccinationsRepository extends VaccinationsRepository {
  _FakeVaccinationsRepository(this.vaccinations, {this.error})
      : super(apiClient: ApiClient(storage: const FlutterSecureStorage()));

  final List<Vaccination> vaccinations;
  final Object? error;

  @override
  Future<List<Vaccination>> getVaccinations({
    int page = 1,
    int limit = 50,
    int? rabbitId,
    VaccineType? vaccineType,
    DateTime? fromDate,
    DateTime? toDate,
    bool? upcoming,
    String sortBy = 'vaccination_date',
    String sortOrder = 'DESC',
  }) async {
    if (error != null) throw error!;
    return vaccinations;
  }
}

class _FakeMedicalRecordsRepository extends MedicalRecordsRepository {
  _FakeMedicalRecordsRepository(this.records, {this.error})
      : super(ApiClient(storage: const FlutterSecureStorage()));

  final List<MedicalRecord> records;
  final Object? error;

  @override
  Future<List<MedicalRecord>> getMedicalRecords({
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
    int? rabbitId,
    String? outcome,
    DateTime? fromDate,
    DateTime? toDate,
    bool? ongoing,
  }) async {
    if (error != null) throw error!;
    return records;
  }
}

/// Скелетон пульсирует бесконечно, поэтому `pumpAndSettle` здесь не сходится:
/// ждём ответ провайдера и доигрываем анимацию полос вручную.
Future<void> _pumpJournal(
  WidgetTester tester, {
  List<Vaccination> vaccinations = const [],
  List<MedicalRecord> treatments = const [],
  FarmRoleAccess role = FarmRoleAccess.owner,
  bool canRecord = true,
  Object? error,
}) async {
  await tester.binding.setSurfaceSize(const Size(420, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(testAppScreen(
    const HealthJournalScreen(),
    overrides: <Override>[
      farmRoleProvider.overrideWithValue(role),
      // Право на ежедневные записи есть у всех трёх ролей, поэтому «роль без
      // права» изображается прямой подменой возможности.
      if (!canRecord)
        canProvider.overrideWith((ref, capability) =>
            capability != FarmCapability.recordDailyWork),
      vaccinationsRepositoryProvider.overrideWithValue(
        _FakeVaccinationsRepository(vaccinations, error: error),
      ),
      medicalRecordsRepositoryProvider.overrideWithValue(
        _FakeMedicalRecordsRepository(treatments, error: error),
      ),
    ],
  ));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

double _topOf(WidgetTester tester, String text) =>
    tester.getTopLeft(find.text(text)).dy;

void main() {
  setUpAll(() => initializeDateFormatting('ru', null));

  testWidgets('прививки и лечение идут одной лентой, свежее сверху',
      (tester) async {
    await _pumpJournal(
      tester,
      vaccinations: [
        _vaccination(id: 1, name: 'ВГБК', date: DateTime(2026, 5, 10)),
        _vaccination(id: 2, name: 'Миксоматоз', date: DateTime(2026, 4, 1)),
      ],
      treatments: [
        _treatment(
          id: 3,
          symptoms: 'Отказ от корма',
          diagnosis: 'Кокцидиоз',
          startedAt: DateTime(2026, 5, 20),
        ),
      ],
    );

    expect(find.text('ВГБК'), findsOneWidget);
    expect(find.text('Кокцидиоз'), findsOneWidget);
    expect(find.text('Миксоматоз'), findsOneWidget);

    // Лечение от 20 мая выше прививки от 10 мая, а та — выше прививки
    // от 1 апреля.
    expect(_topOf(tester, 'Кокцидиоз'), lessThan(_topOf(tester, 'ВГБК')));
    expect(_topOf(tester, 'ВГБК'), lessThan(_topOf(tester, 'Миксоматоз')));
  });

  testWidgets('строка называет вид записи, кому она и чем кончилось',
      (tester) async {
    await _pumpJournal(
      tester,
      vaccinations: [
        // Кличку сервер присылает в каждом ответе, но модель `Vaccination`
        // её пока не разбирает, поэтому в приложении эта строка выходит без
        // адресата. Здесь проверяется, что лента покажет кличку, как только
        // модель начнёт её читать.
        _vaccination(
          id: 1,
          name: 'ВГБК',
          date: DateTime(2026, 5, 10),
          next: DateTime(2026, 11, 10),
          rabbit: _rabbit('Зорька'),
        ),
      ],
      treatments: [
        _treatment(
          id: 2,
          symptoms: 'Хрипы',
          diagnosis: 'Пастереллёз',
          startedAt: DateTime(2026, 5, 1),
          endedAt: DateTime(2026, 5, 12),
          outcome: MedicalOutcome.recovered,
        ),
      ],
    );

    expect(find.text('Прививка · Кролик Зорька'), findsOneWidget);
    expect(find.text('10 мая 2026'), findsOneWidget);
    // Когда прививать снова — ради этого журнал и открывают.
    expect(find.textContaining('Следующая'), findsOneWidget);

    expect(find.textContaining('Выздоровел'), findsOneWidget);
  });

  testWidgets('фильтр оставляет записи только выбранного вида', (tester) async {
    await _pumpJournal(
      tester,
      vaccinations: [
        _vaccination(id: 1, name: 'ВГБК', date: DateTime(2026, 5, 10)),
      ],
      treatments: [
        _treatment(
          id: 2,
          symptoms: 'Хрипы',
          diagnosis: 'Пастереллёз',
          startedAt: DateTime(2026, 5, 1),
        ),
      ],
    );

    expect(find.text('ВГБК'), findsOneWidget);
    expect(find.text('Пастереллёз'), findsOneWidget);

    await tester.tap(find.text('Прививки'));
    await tester.pump();

    expect(find.text('ВГБК'), findsOneWidget);
    expect(find.text('Пастереллёз'), findsNothing);

    await tester.tap(find.text('Лечение').first);
    await tester.pump();

    expect(find.text('ВГБК'), findsNothing);
    expect(find.text('Пастереллёз'), findsOneWidget);
  });

  testWidgets('пустой журнал объясняет, зачем он нужен, и зовёт записать',
      (tester) async {
    await _pumpJournal(tester);

    expect(find.text('Здоровье стада ещё не записано'), findsOneWidget);
    expect(find.textContaining('когда прививать снова'), findsOneWidget);
    expect(find.text('Записать'), findsOneWidget);
  });

  testWidgets('сбой загрузки объясняется и даёт повторить', (tester) async {
    await _pumpJournal(
      tester,
      error: const ApiFailure(ApiFailureKind.offline),
    );

    expect(find.text('Нет связи — проверьте интернет'), findsOneWidget);
    expect(find.text('Повторить'), findsOneWidget);
  });

  testWidgets('работник видит кнопку записи', (tester) async {
    await _pumpJournal(
      tester,
      role: FarmRoleAccess.worker,
      vaccinations: [
        _vaccination(id: 1, name: 'ВГБК', date: DateTime(2026, 5, 10)),
      ],
    );

    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('без права на ежедневные записи кнопки записи нет',
      (tester) async {
    await _pumpJournal(
      tester,
      canRecord: false,
      vaccinations: [
        _vaccination(id: 1, name: 'ВГБК', date: DateTime(2026, 5, 10)),
      ],
    );

    expect(find.byType(FloatingActionButton), findsNothing);
    // И в пустом состоянии тоже: кнопка, ведущая к отказу сервера, читается
    // как поломка приложения.
    await _pumpJournal(tester, canRecord: false);
    expect(find.text('Записать'), findsNothing);
  });
}
