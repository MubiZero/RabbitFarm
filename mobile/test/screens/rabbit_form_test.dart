import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/cages/data/models/cage_model.dart';
import 'package:mobile/features/cages/presentation/providers/cages_provider.dart';
import 'package:mobile/features/rabbits/data/models/breed_model.dart';
import 'package:mobile/features/rabbits/data/repositories/breeds_repository.dart';
import 'package:mobile/features/rabbits/presentation/screens/rabbit_form_screen.dart';

import '../support/test_app.dart';

/// Форма кролика — то место, где ферма либо заводится, либо нет: «всех своих
/// кроликов по одному вбивать не буду» сказано именно про неё. Поэтому тест
/// проверяет не вёрстку, а сколько работы форма требует на входе.
class _FakeBreedsRepository extends BreedsRepository {
  _FakeBreedsRepository()
    : super(apiClient: ApiClient(storage: const FlutterSecureStorage()));

  @override
  Future<List<BreedModel>> getBreeds() async => const [
    BreedModel(id: 1, name: 'Калифорнийская'),
    BreedModel(id: 2, name: 'Серый великан'),
  ];
}

Widget _screen() => testAppScreen(
  const RabbitFormScreen(),
  overrides: [
    breedsRepositoryProvider.overrideWithValue(_FakeBreedsRepository()),
    cageOptionsProvider.overrideWith((ref) async => const <CageModel>[]),
  ],
);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('в главном блоке ровно три поля, остальное свёрнуто', (
    tester,
  ) async {
    await tester.pumpWidget(_screen());
    await tester.pumpAndSettle();

    // Видно: пол, дата рождения, порода.
    expect(find.text('Пол'), findsOneWidget);
    expect(find.text('Дата рождения'), findsOneWidget);
    expect(find.text('Порода'), findsOneWidget);

    // Скрыто, пока не попросили: раньше эти поля лежали в той же простыне.
    expect(find.text('Номер бирки'), findsNothing);
    expect(find.text('Окрас'), findsNothing);
    expect(find.text('Отец'), findsNothing);

    await tester.tap(find.text('Дополнительно'));
    await tester.pumpAndSettle();

    expect(find.text('Номер бирки'), findsOneWidget);
    expect(find.text('Окрас'), findsOneWidget);
  });

  testWidgets('пол заранее не выбран и без него сохранить нельзя', (
    tester,
  ) async {
    await tester.pumpWidget(_screen());
    await tester.pumpAndSettle();

    // Раньше здесь стоял «самец» по умолчанию, и самки заводились самцами
    // просто потому, что поле не трогали.
    final selector = tester.widget<SegmentedButton<String>>(
      find.byType(SegmentedButton<String>),
    );
    expect(selector.selected, isEmpty);

    await tester.tap(find.text('Добавить'));
    await tester.pumpAndSettle();

    expect(find.text('Выберите, самец это или самка'), findsOneWidget);
  });
}
