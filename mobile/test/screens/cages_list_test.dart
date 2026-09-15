import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/access/farm_access.dart';
import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/cages/data/models/cage_model.dart';
import 'package:mobile/features/cages/data/repositories/cages_repository.dart';
import 'package:mobile/features/cages/presentation/screens/cages_list_screen.dart';

import '../support/test_app.dart';

class _FakeCagesRepository extends CagesRepository {
  _FakeCagesRepository(this.cages)
      : super(apiClient: ApiClient(storage: const FlutterSecureStorage()));

  final List<CageModel> cages;

  @override
  Future<List<CageModel>> getCages({
    int page = 1,
    int limit = 50,
    String? type,
    String? condition,
    String? location,
    String? search,
    bool? onlyAvailable,
  }) async =>
      page == 1 ? cages : const [];
}

const _cage = CageModel(
  id: 1,
  number: '7',
  type: 'single',
  capacity: 4,
  condition: 'good',
  currentOccupancy: 2,
);

Future<void> _settle(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 1400));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Widget _wrap(FarmRoleAccess role) => testAppScreen(
      const CagesListScreen(),
      overrides: [
        cagesRepositoryProvider
            .overrideWithValue(_FakeCagesRepository(const [_cage])),
        farmRoleProvider.overrideWithValue(role),
      ],
    );

Future<void> _openMenu(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.more_vert));
  await tester.pumpAndSettle();
}

void main() {
  // Уборка клеток — ровно работа работника, и сервер принимает отметку от
  // любой роли. Пункт лежал внутри меню, целиком закрытого правом на
  // распоряжение поголовьем, — работник до своей же работы не дотягивался.
  testWidgets('работник отмечает уборку, но клетку не правит и не удаляет',
      (tester) async {
    await tester.pumpWidget(_wrap(FarmRoleAccess.worker));
    await _settle(tester);

    await _openMenu(tester);

    expect(find.text('Отметить уборку'), findsOneWidget);
    expect(find.text('Изменить клетку'), findsNothing);
    expect(find.text('Удалить'), findsNothing);
  });

  testWidgets('владельцу доступны и правка, и уборка, и удаление',
      (tester) async {
    await tester.pumpWidget(_wrap(FarmRoleAccess.owner));
    await _settle(tester);

    await _openMenu(tester);

    expect(find.text('Изменить клетку'), findsOneWidget);
    expect(find.text('Отметить уборку'), findsOneWidget);
    expect(find.text('Удалить'), findsOneWidget);
  });

  testWidgets('управляющий правит клетку и убирает, но не удаляет',
      (tester) async {
    await tester.pumpWidget(_wrap(FarmRoleAccess.manager));
    await _settle(tester);

    await _openMenu(tester);

    expect(find.text('Изменить клетку'), findsOneWidget);
    expect(find.text('Отметить уборку'), findsOneWidget);
    expect(find.text('Удалить'), findsNothing);
  });
}
