import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/core/access/farm_access.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/cages/data/models/cage_model.dart';
import 'package:mobile/features/cages/presentation/providers/cages_provider.dart';
import 'package:mobile/features/rabbits/data/models/breed_model.dart';
import 'package:mobile/features/rabbits/data/models/rabbit_model.dart';
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

Widget _screen({RabbitModel? rabbit, String? farmPurpose}) => testAppScreen(
      RabbitFormScreen(rabbit: rabbit),
      overrides: [
        breedsRepositoryProvider.overrideWithValue(_FakeBreedsRepository()),
        cageOptionsProvider.overrideWith((ref) async => const <CageModel>[]),
        farmDefaultPurposeProvider.overrideWithValue(farmPurpose),
      ],
    );

RabbitModel _rabbit({required String status}) => RabbitModel(
      id: 42,
      name: 'Мушка',
      tagId: 'A-0231',
      breedId: 1,
      sex: 'female',
      birthDate: DateTime(2026, 1, 1),
      status: status,
      purpose: 'meat',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );

/// Открыть список статусов. При правке блок «Дополнительно» раскрыт сам:
/// свёрнутый поверх заполненных полей читался бы как «данные потерялись».
Future<void> _openStatuses(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 2400));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final dropdown = find.ancestor(
    of: find.text('Статус'),
    matching: find.byType(DropdownButtonFormField<String>),
  );
  await tester.ensureVisible(dropdown);
  await tester.pumpAndSettle();
  await tester.tap(dropdown);
  await tester.pumpAndSettle();
}

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

  // «Продан» и «Пал» ставились здесь без цены, без дня и без причины — так
  // продажа теряла приход в книге, а падёж оставался статусом без объяснения.
  // У каждого из двух теперь свой экран с карточки кролика.
  testWidgets('выбытие в общем списке статусов не предлагают', (tester) async {
    await tester.pumpWidget(_screen(rabbit: _rabbit(status: 'healthy')));
    await tester.pumpAndSettle();
    await _openStatuses(tester);

    expect(find.text('Болен'), findsWidgets);
    expect(find.text('Продан'), findsNothing);
    expect(find.text('Погиб'), findsNothing);
  });

  // Ошибочную продажу надо уметь отменить, вернув кролика в живые, — да и
  // список не нашёл бы своего значения, не будь в нём текущего статуса.
  testWidgets('проданный кролик свой статус в списке видит', (tester) async {
    await tester.pumpWidget(_screen(rabbit: _rabbit(status: 'sold')));
    await tester.pumpAndSettle();
    await _openStatuses(tester);

    expect(find.text('Продан'), findsWidgets);
    expect(find.text('Погиб'), findsNothing);
  });

  testWidgets('новый кролик получает назначение хозяйства', (tester) async {
    // «Не буду каждому кролику выставлять назначение» — сказано фермером про
    // эту самую форму. Хозяйство говорит это один раз, в настройках.
    await tester.binding.setSurfaceSize(const Size(420, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_screen(farmPurpose: 'meat'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Дополнительно'));
    await tester.pumpAndSettle();

    final purpose = find.ancestor(
      of: find.text('Назначение'),
      matching: find.byType(DropdownButtonFormField<String>),
    );
    expect(
      tester.widget<DropdownButtonFormField<String>>(purpose).initialValue,
      'meat',
    );
  });

  testWidgets('пока хозяйство не сказало, назначение прежнее', (tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_screen());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Дополнительно'));
    await tester.pumpAndSettle();

    final purpose = find.ancestor(
      of: find.text('Назначение'),
      matching: find.byType(DropdownButtonFormField<String>),
    );
    expect(
      tester.widget<DropdownButtonFormField<String>>(purpose).initialValue,
      'breeding',
    );
  });
}
