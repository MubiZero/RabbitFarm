import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/staff/data/models/staff_models.dart';
import 'package:mobile/features/staff/data/repositories/staff_repository.dart';
import 'package:mobile/features/staff/presentation/providers/staff_provider.dart';
import 'package:mobile/features/staff/presentation/screens/farm_audit_screen.dart';
import 'package:mobile/shared/models/api_response.dart';

import '../support/fake_storage.dart';
import '../support/test_app.dart';

/// Экран отвечает на вопрос «кто исправил мою запись».
///
/// До журнала изменений правка не оставляла следа нигде: запись после неё
/// оставалась подписана тем, кто завёл её изначально.
class _FakeStaffRepository extends StaffRepository {
  _FakeStaffRepository(this.entries) : super(ApiClient(storage: FakeStorage()));

  final List<FarmAuditEntry> entries;

  @override
  Future<PaginatedResponse<FarmAuditEntry>> getAuditLog({
    int page = 1,
    int limit = 30,
    String scope = 'all',
  }) async {
    return PaginatedResponse<FarmAuditEntry>(
      items: entries,
      total: entries.length,
      page: 1,
      limit: limit,
      totalPages: 1,
    );
  }
}

const _safar = FarmMember(
  id: 7,
  fullName: 'Сафар Раҷабов',
  role: FarmRole.worker,
);

const _dilnoza = FarmMember(
  id: 4,
  fullName: 'Дилноза Каримова',
  role: FarmRole.manager,
);

FarmAuditEntry _entry({
  required String action,
  String? entityType,
  String? entityLabel,
  FarmMember? target,
  Map<String, dynamic>? before,
  Map<String, dynamic>? after,
}) {
  return FarmAuditEntry(
    id: 1,
    action: action,
    at: DateTime(2026, 9, 14, 8, 30),
    actor: _safar,
    target: target,
    entityType: entityType,
    entityLabel: entityLabel,
    before: before,
    after: after,
  );
}

Future<void> _pump(WidgetTester tester, List<FarmAuditEntry> entries) async {
  await tester.pumpWidget(testAppScreen(
    const FarmAuditScreen(),
    overrides: [
      staffRepositoryProvider.overrideWithValue(_FakeStaffRepository(entries)),
    ],
  ));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('правка названа правкой, с автором и с тем, что изменилось',
      (tester) async {
    await _pump(tester, [
      _entry(
        action: 'feeding_record.updated',
        entityType: 'feeding_record',
        entityLabel: '2026-09-14',
        before: {'quantity': '250.00'},
        after: {'quantity': '500.00'},
      ),
    ]);

    expect(find.textContaining('Исправлено'), findsOneWidget);
    expect(find.textContaining('Кормление'), findsOneWidget);
    // Ради этой строки журнал и заводится: «500 вместо 250» владелец
    // проверит сам, «кто-то что-то поправил» — нет.
    expect(find.text('Сколько: 250 → 500'), findsOneWidget);
    expect(find.text('Сафар Раҷабов'), findsOneWidget);
  });

  testWidgets('удаление по-прежнему видно и названо своим словом',
      (tester) async {
    await _pump(tester, [
      _entry(
        action: 'rabbit.deleted',
        entityType: 'rabbit',
        entityLabel: 'Мушка',
      ),
    ]);

    expect(find.text('Мушка'), findsOneWidget);
    expect(find.textContaining('Удалено'), findsOneWidget);
  });

  testWidgets('кадровое действие показывает, над кем оно', (tester) async {
    await _pump(tester, [
      _entry(action: 'staff.role_changed', target: _dilnoza),
    ]);

    expect(find.text('Дилноза Каримова'), findsOneWidget);
    expect(find.textContaining('Смена роли'), findsOneWidget);
  });

  testWidgets('ссылочное поле не показывают номером', (tester) async {
    // В снимке лежит `cage_id`, за именем клетки идти уже некуда, и
    // «Клетка: 3 → 7» человеку не говорит ничего.
    await _pump(tester, [
      _entry(
        action: 'rabbit.updated',
        entityType: 'rabbit',
        entityLabel: 'Мушка',
        before: {'cage_id': 3},
        after: {'cage_id': 7},
      ),
    ]);

    expect(find.text('Изменено: Клетка'), findsOneWidget);
    expect(find.textContaining('3 → 7'), findsNothing);
  });

  testWidgets('поле без имени в приложении пропускается, а запись остаётся',
      (tester) async {
    await _pump(tester, [
      _entry(
        action: 'task.updated',
        entityType: 'task',
        entityLabel: 'Почистить клетки',
        before: {'reminder_sent_at': null},
        after: {'reminder_sent_at': '2026-09-14T08:00:00.000Z'},
      ),
    ]);

    expect(find.text('Почистить клетки'), findsOneWidget);
    expect(find.textContaining('reminder_sent_at'), findsNothing);
  });

  testWidgets('пустой журнал подсказывает, что в него попадает',
      (tester) async {
    await _pump(tester, const []);

    expect(find.text('Записей пока нет'), findsOneWidget);
  });
}
