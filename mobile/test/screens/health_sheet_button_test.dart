import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/health/data/models/medical_record_model.dart';
import 'package:mobile/features/health/data/models/vaccination_model.dart';
import 'package:mobile/features/health/data/repositories/medical_records_repository.dart';
import 'package:mobile/features/health/data/repositories/vaccinations_repository.dart';
import 'package:mobile/features/health/presentation/providers/medical_records_provider.dart';
import 'package:mobile/features/health/presentation/widgets/health_sheet_button.dart';
import 'package:mobile/features/rabbits/data/models/rabbit_model.dart';

import '../support/test_app.dart';

/// Карта здоровья уезжает к ветеринару на бумаге или в таблице — исправить
/// её там уже нельзя. Проверяется, что на лист попадает вся история кролика,
/// а не первая страница общего списка, и что пустая карта не уходит молча.
ApiClient _client() => ApiClient(
      storage: const FlutterSecureStorage(),
      baseUrl: 'http://localhost',
    );

class _FakeVaccinations extends VaccinationsRepository {
  _FakeVaccinations(this.items) : super(apiClient: _client());

  final List<Vaccination> items;
  int? askedRabbitId;

  @override
  Future<List<Vaccination>> getRabbitVaccinations(int rabbitId) async {
    askedRabbitId = rabbitId;
    return items;
  }
}

class _FakeMedicalRecords extends MedicalRecordsRepository {
  _FakeMedicalRecords(this.items) : super(_client());

  final List<MedicalRecord> items;

  @override
  Future<List<MedicalRecord>> getRabbitMedicalRecords(int rabbitId) async =>
      items;
}

final _rabbit = RabbitModel(
  id: 7,
  tagId: 'A-0231',
  name: 'Мушка',
  breedId: 1,
  sex: 'female',
  birthDate: DateTime(2026, 1, 20),
  status: 'active',
  purpose: 'breeding',
  createdAt: DateTime(2026, 1, 20),
  updatedAt: DateTime(2026, 9, 1),
);

final _vaccination = Vaccination(
  id: 1,
  rabbitId: 7,
  vaccineName: 'ВГБК',
  vaccineType: VaccineType.vhd,
  vaccinationDate: DateTime(2026, 9, 10),
);

void main() {
  setUpAll(() => initializeDateFormatting('ru'));

  late String? printedHtml;
  late String? sharedCsv;

  Future<void> open(
    WidgetTester tester, {
    List<Vaccination> vaccinations = const [],
    List<MedicalRecord> treatments = const [],
  }) async {
    printedHtml = null;
    sharedCsv = null;

    await tester.pumpWidget(testApp(
      HealthSheetButton(
        rabbit: _rabbit,
        printer: ({required html, required documentName}) async {
          printedHtml = html;
        },
        sharer: ({required csv, required fileName, required subject}) async {
          sharedCsv = csv;
        },
      ),
      overrides: [
        vaccinationsRepositoryProvider
            .overrideWithValue(_FakeVaccinations(vaccinations)),
        medicalRecordsRepositoryProvider
            .overrideWithValue(_FakeMedicalRecords(treatments)),
      ],
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
  }

  testWidgets('бумага собирается из истории самого кролика', (tester) async {
    await open(tester, vaccinations: [_vaccination]);

    await tester.tap(find.text('Напечатать'));
    await tester.pumpAndSettle();

    expect(printedHtml, isNotNull);
    expect(printedHtml, contains('Мушка'));
    expect(printedHtml, contains('ВГБК'));
    expect(sharedCsv, isNull);
  });

  testWidgets('таблица уходит отдельным выбором, а не вместе с печатью',
      (tester) async {
    await open(tester, vaccinations: [_vaccination]);

    await tester.tap(find.text('Отправить таблицей'));
    await tester.pumpAndSettle();

    expect(sharedCsv, isNotNull);
    expect(sharedCsv, contains('ВГБК'));
    expect(printedHtml, isNull);
  });

  testWidgets('пустая карта не уходит в печать молча', (tester) async {
    // Пустой лист обманывает: человек решит, что прививок не делали, хотя их
    // просто не записывали в приложение.
    await open(tester);

    await tester.tap(find.text('Напечатать'));
    await tester.pumpAndSettle();

    expect(printedHtml, isNull);
    expect(
      find.text('У этого кролика ещё нет ни прививок, ни лечения'),
      findsOneWidget,
    );
  });
}
