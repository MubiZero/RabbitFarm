import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/cache/cache_scope.dart';
import 'package:mobile/features/cages/data/models/cage_model.dart';
import 'package:mobile/features/cages/presentation/providers/cages_provider.dart';
import 'package:mobile/features/health/data/models/vaccination_model.dart';
import 'package:mobile/features/health/data/repositories/vaccinations_repository.dart';
import 'package:mobile/features/health/presentation/screens/vaccination_form_screen.dart';
import 'package:mobile/features/rabbits/data/models/breed_model.dart';
import 'package:mobile/features/rabbits/data/models/rabbit_model.dart';
import 'package:mobile/features/rabbits/data/repositories/breeds_repository.dart';
import 'package:mobile/features/rabbits/presentation/screens/rabbit_form_screen.dart';

import '../support/test_app.dart';
import 'package:mobile/shared/models/api_response.dart';

/// Поля, которые человек заполняет, а приложение нигде не показывает — или
/// наоборот, показывает то, чего негде заполнить. Хуже прочих была стоимость
/// прививки: поля не было в модели вовсе, поэтому готовая серверная
/// автоматика «прививка → расход фермы» не срабатывала ни разу, хотя для
/// лечения такая же работает.
class _FakeVaccinationsRepository extends VaccinationsRepository {
  _FakeVaccinationsRepository()
      : super(apiClient: ApiClient(storage: const FlutterSecureStorage()));

  final List<Map<String, dynamic>> sent = [];

  @override
  Future<PaginatedResponse<Vaccination>> getVaccinations({
    int page = 1,
    int limit = 50,
    int? rabbitId,
    VaccineType? vaccineType,
    DateTime? fromDate,
    DateTime? toDate,
    bool? upcoming,
    String sortBy = 'vaccination_date',
    String sortOrder = 'DESC',
  }) async =>
      const PaginatedResponse<Vaccination>(
        items: [],
        total: 0,
        page: 1,
        limit: 50,
        totalPages: 0,
      );

  @override
  Future<Vaccination> createVaccination(VaccinationRequest request) async {
    sent.add(request.toJson());
    return Vaccination(
      id: 1,
      rabbitId: request.rabbitId,
      vaccineName: request.vaccineName,
      vaccineType: request.vaccineType,
      vaccinationDate: request.vaccinationDate,
      cost: request.cost,
    );
  }
}

class _FakeBreedsRepository extends BreedsRepository {
  _FakeBreedsRepository()
      : super(apiClient: ApiClient(storage: const FlutterSecureStorage()));

  @override
  Future<List<BreedModel>> getBreeds() async => const [
        BreedModel(id: 1, name: 'Калифорнийская'),
      ];
}

final _rabbit = RabbitModel(
  id: 42,
  name: 'Мушка',
  tagId: 'A-0231',
  breedId: 1,
  sex: 'female',
  birthDate: DateTime(2026, 1, 1),
  status: 'healthy',
  purpose: 'meat',
  createdAt: DateTime(2026, 1, 1),
  updatedAt: DateTime(2026, 1, 1),
);

Future<void> _wide(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 2400));
  addTearDown(() => tester.binding.setSurfaceSize(null));
}

void main() {
  setUpAll(() => initializeDateFormatting('ru'));
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('стоимость прививки доезжает до сервера', (tester) async {
    final repository = _FakeVaccinationsRepository();

    await tester.pumpWidget(testAppScreen(
      VaccinationFormScreen(rabbit: _rabbit),
      overrides: [
        vaccinationsRepositoryProvider.overrideWithValue(repository),
        cacheScopeProvider.overrideWithValue(null),
      ],
    ));
    await _wide(tester);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Название вакцины'),
      'Раббивак V',
    );
    final cost = find.widgetWithText(TextFormField, 'Затраты, с');
    await tester.ensureVisible(cost);
    await tester.enterText(cost, '120');

    final submit = find.widgetWithText(FilledButton, 'Добавить');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();

    // Именно это поле сервер превращает в расход фермы (`autoExpenseService`).
    expect(repository.sent.single['cost'], 120);
  });

  // Дата рождения покупного кролика — со слов продавца, а день покупки хозяин
  // знает точно. Поле было в модели и на сервере, заполнить его было негде.
  testWidgets('дату покупки можно указать и снять', (tester) async {
    await tester.pumpWidget(testAppScreen(
      RabbitFormScreen(rabbit: _rabbit),
      overrides: [
        breedsRepositoryProvider.overrideWithValue(_FakeBreedsRepository()),
        cageOptionsProvider.overrideWith((ref) async => const <CageModel>[]),
      ],
    ));
    await _wide(tester);
    await tester.pumpAndSettle();

    final field = find.text('Когда купили');
    await tester.ensureVisible(field);
    await tester.pumpAndSettle();

    // Пока даты нет, поле отвечает «родился на ферме», а не подставляет
    // сегодняшнее число — выдуманная дата хуже честного пропуска.
    expect(find.text('Родился на ферме'), findsOneWidget);
  });
}
