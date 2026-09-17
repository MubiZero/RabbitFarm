import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/access/farm_access.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/rabbits/data/models/birth_model.dart';
import 'package:mobile/features/rabbits/data/repositories/births_repository.dart';
import 'package:mobile/features/rabbits/presentation/screens/births_list_screen.dart';

import '../support/test_app.dart';
import 'package:mobile/shared/models/api_response.dart';

/// Крольчонок жил в приложении двумя способами сразу: числом в выводке и,
/// если нажали «Завести карточки», — строкой в поголовье. Половины друг о
/// друге не знали: отметка падежа в выводке до карточек не доходила, отметка
/// на карточке — до выводка. Теперь правда одна, и экран это показывает:
/// заведены карточки — считаем по ним, действия из выводка убраны.
class _FakeBirthsRepository extends BirthsRepository {
  _FakeBirthsRepository(this._birth)
      : super(apiClient: ApiClient(storage: const FlutterSecureStorage()));

  final BirthModel _birth;

  @override
  Future<PaginatedResponse<BirthModel>> getBirths({
    int page = 1,
    int limit = 30,
  }) async =>
      PaginatedResponse<BirthModel>(
        items: [_birth],
        total: [_birth].length,
        page: page,
        limit: limit,
        totalPages: 1,
      );
}

BirthModel _birth({String? cardedAt}) => BirthModel(
      id: 1,
      motherId: 5,
      birthDate: '2026-09-01',
      kitsBornAlive: 6,
      kitsBornDead: 0,
      kitsCardedAt: cardedAt,
    );

Future<void> _pump(WidgetTester tester, {String? cardedAt}) async {
  await tester.binding.setSurfaceSize(const Size(420, 1200));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    testAppScreen(
      const BirthsListScreen(),
      overrides: [
        birthsRepositoryProvider.overrideWithValue(
            _FakeBirthsRepository(_birth(cardedAt: cardedAt))),
        farmRoleProvider.overrideWithValue(FarmRoleAccess.owner),
      ],
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('пока карточек нет, выводком можно управлять отсюда', (
    tester,
  ) async {
    await _pump(tester);

    expect(find.text('Завести крольчат'), findsOneWidget);
    expect(find.text('Отметить падёж'), findsOneWidget);
  });

  testWidgets('после карточек выводок только читается', (tester) async {
    await _pump(tester, cardedAt: '2026-09-10T08:00:00.000Z');

    // Кнопка «Завести крольчат» была той самой, которую можно нажать дважды
    // и получить из шести крольчат двенадцать карточек.
    expect(find.text('Завести крольчат'), findsNothing);
    // Падёж и отсадку теперь отмечают на карточке крольчонка — сервер правку
    // чисел выводка в этом состоянии отклоняет, и кнопка вела бы в отказ.
    expect(find.text('Отметить падёж'), findsNothing);
    expect(find.text('Отсадили'), findsNothing);
    // Вместо кнопок — объяснение, куда идти.
    expect(find.textContaining('карточками'), findsOneWidget);
  });
}
