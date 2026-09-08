import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/features/platform_admin/data/repositories/platform_admin_repository.dart';
import 'package:mobile/features/platform_admin/presentation/providers/platform_admin_provider.dart';
import 'package:mobile/features/platform_admin/presentation/screens/farm_export_screen.dart';

import '../support/test_app.dart';

/// Снимок в той форме, в которой его отдаёт
/// `GET /platform-admin/farms/:id/export`: восемнадцать списков, часть пустых.
/// Мобилка не разбирает содержимое по полям — она его показывает.
Map<String, dynamic> _export() => {
      'generated_at': '2026-09-09T09:15:00.000Z',
      'farm': {'id': 1, 'name': 'Ферма Иванова', 'status': 'active'},
      'staff': [
        {'id': 5, 'full_name': 'Иван Иванов', 'role': 'owner'},
      ],
      'rabbits': [
        {'id': 11, 'tag_number': 'A-1', 'gender': 'female'},
      ],
      'rabbit_weights': [],
      'breedings': [],
      'births': [],
      'vaccinations': [],
      'medical_records': [],
      'cages': [],
      'breeds': [],
      'feeds': [],
      'feeding_records': [],
      'transactions': [],
      'tasks': [],
      'photos': [],
      'notes': [],
      'payments': [],
    };

class _FakeRepository extends PlatformAdminRepository {
  _FakeRepository({this.error})
      : super(ApiClient(storage: const FlutterSecureStorage()));

  final Object? error;

  int calls = 0;

  @override
  Future<Map<String, dynamic>> exportFarm(int farmId) async {
    calls++;
    if (error != null) throw error!;
    return _export();
  }
}

Widget _screen(_FakeRepository repository) => testAppScreen(
      const FarmExportScreen(farmId: 1, farmName: 'Ферма Иванова'),
      overrides: [
        platformAdminRepositoryProvider.overrideWithValue(repository),
      ],
    );

Future<void> _settle(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 3000));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

String _shown(WidgetTester tester) =>
    tester.widget<SelectableText>(find.byType(SelectableText)).data!;

void main() {
  group('Выгрузка данных фермы', () {
    testWidgets('снимок запрашивается сразу и показан целиком', (tester) async {
      final repository = _FakeRepository();
      await tester.pumpWidget(_screen(repository));
      await _settle(tester);

      // Экран не ждёт отдельного нажатия: за выгрузкой сюда и заходят.
      expect(repository.calls, 1);

      final text = _shown(tester);
      // Читаемый JSON с отступами, а не одна строка на весь буфер.
      expect(text, contains('\n  "rabbits": ['));
      expect(text, contains('"tag_number": "A-1"'));
      // Пустые списки видны как пустые, а не выброшены: «фото нет» — это
      // тоже ответ на «отдайте мои данные».
      expect(text, contains('"photos": []'));

      // Заголовок — название фермы, пришедшее с карточки.
      expect(find.widgetWithText(AppBar, 'Ферма Иванова'), findsOneWidget);
      // Когда снимок собран — строкой, а не поиском по JSON глазами. Сама
      // дата не сверяется: она печатается в местном поясе, и на машине с
      // другим поясом день сдвинулся бы.
      expect(find.textContaining('Снимок собран'), findsOneWidget);
    });

    testWidgets('кнопка отдаёт снимок в буфер обмена', (tester) async {
      final copied = <String>[];
      // Буфер обмена живёт на стороне платформы — в тесте её подменяем.
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copied.add((call.arguments as Map)['text'] as String);
          }
          return null;
        },
      );
      addTearDown(() => tester.binding.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null));

      await tester.pumpWidget(_screen(_FakeRepository()));
      await _settle(tester);

      await tester.tap(find.byIcon(Icons.copy_all_outlined));
      await _settle(tester);

      // В буфер ушёл тот же текст, что на экране, — целиком.
      expect(copied.single, _shown(tester));
      expect(find.text('Скопировано'), findsOneWidget);
    });

    testWidgets('пока снимка нет, копировать нечего', (tester) async {
      await tester.pumpWidget(
        _screen(_FakeRepository(error: Exception('нет сети'))),
      );
      await _settle(tester);

      expect(find.text('Повторить'), findsOneWidget);
      expect(
        tester
            .widget<IconButton>(
                find.widgetWithIcon(IconButton, Icons.copy_all_outlined))
            .onPressed,
        isNull,
      );
    });
  });
}
