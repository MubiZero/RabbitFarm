import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/rabbits/data/repositories/rabbits_repository.dart';
import 'package:mobile/features/rabbits/presentation/providers/rabbits_provider.dart';
import 'package:mobile/features/rabbits/presentation/utils/rabbit_labels.dart';
import 'package:mobile/features/settings/presentation/screens/settings_screen.dart';

import '../support/test_app.dart';

/// Назначение кролика жило одним фильтром списка: поле обязательное,
/// заполняется на каждой карточке, а сводки по нему не было нигде и выставить
/// его разом было нельзя. Большинство ферм держат кроликов для чего-то одного
/// — значит, это свойство хозяйства, а не двухсот карточек.
class _FakeRabbitsRepository extends RabbitsRepository {
  _FakeRabbitsRepository()
      : super(apiClient: ApiClient(storage: const FlutterSecureStorage()));

  final List<String> purposes = [];

  @override
  Future<int> setPurposeForAll(String purpose) async {
    purposes.add(purpose);
    return 12;
  }
}

/// Владелец: оптовая простановка — решение по хозяйству, и помощнику её не
/// дают (сервер тоже: `authorize(['owner'])`).
class _OwnerAuthNotifier extends AuthNotifier {
  _OwnerAuthNotifier(super.repository, super.ref) {
    state = state.copyWith(
      isAuthenticated: true,
      isLoading: false,
      user: UserModel(
        id: 1,
        email: 'owner@example.com',
        fullName: 'Пётр Владелец',
        role: 'owner',
        isActive: true,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      ),
    );
  }
}

Widget _screen(_FakeRabbitsRepository repository) => testAppScreen(
      const SettingsScreen(),
      overrides: [
        rabbitsRepositoryProvider.overrideWithValue(repository),
        authProvider.overrideWith(
          (ref) => _OwnerAuthNotifier(ref.watch(authRepositoryProvider), ref),
        ),
      ],
    );

Future<void> _settle(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 2400));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  // «Мех» и «Питомец» форма предлагала, а колонка их не знает
  // (`ENUM('breeding','meat','sale','show')`) — сервер отвечал 422, и кролик
  // с таким назначением не сохранялся вовсе.
  test('назначений ровно столько, сколько принимает сервер', () {
    expect(rabbitPurposes, ['breeding', 'meat', 'sale', 'show']);
    expect(rabbitPurposes, isNot(contains('fur')));
    expect(rabbitPurposes, isNot(contains('pet')));
  });

  testWidgets('владелец выставляет назначение всем — с подтверждением',
      (tester) async {
    final repository = _FakeRabbitsRepository();
    await tester.pumpWidget(_screen(repository));
    await _settle(tester);

    final entry = find.text('Назначение всем кроликам');
    await tester.ensureVisible(entry);
    await tester.tap(entry);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ListTile, 'На мясо'));
    await tester.pumpAndSettle();

    // Между выбором и запросом — подтверждение: замена оптовая и
    // необратимая, вернуть прежние назначения можно только по одному.
    expect(find.text('Выставить назначение всем?'), findsOneWidget);
    expect(repository.purposes, isEmpty);

    await tester.tap(find.text('Выставить'));
    await tester.pumpAndSettle();

    expect(repository.purposes, ['meat']);
    // Итог называется числом — тем, что вернул сервер, а не «готово».
    expect(find.textContaining('12'), findsOneWidget);
  });

  testWidgets('отказ от подтверждения ничего не отправляет', (tester) async {
    final repository = _FakeRabbitsRepository();
    await tester.pumpWidget(_screen(repository));
    await _settle(tester);

    final entry = find.text('Назначение всем кроликам');
    await tester.ensureVisible(entry);
    await tester.tap(entry);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ListTile, 'На мясо'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Отмена'));
    await tester.pumpAndSettle();

    expect(repository.purposes, isEmpty);
  });
}
