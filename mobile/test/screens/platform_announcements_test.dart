import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/api/paginated.dart';
import 'package:mobile/features/platform_admin/data/models/platform_admin_models.dart';
import 'package:mobile/features/platform_admin/data/repositories/platform_admin_repository.dart';
import 'package:mobile/features/platform_admin/presentation/providers/platform_admin_provider.dart';
import 'package:mobile/features/platform_admin/presentation/screens/announcement_form_screen.dart';
import 'package:mobile/features/platform_admin/presentation/screens/platform_announcements_tab.dart';

import '../support/test_app.dart';

Announcement _announcement({
  int id = 1,
  String title = 'Плановые работы',
  String body = 'В субботу с 2 до 4 часов сервис будет недоступен.',
  List<String> channels = const ['push', 'email'],
  String targetType = 'all',
  String? targetFilter,
  int farmsCount = 12,
  int recipientsCount = 34,
  AnnouncementStats? stats = const AnnouncementStats(
    push: ChannelDelivery(sent: 30, failed: 4),
    email: ChannelDelivery(sent: 34),
  ),
}) {
  return Announcement(
    id: id,
    title: title,
    body: body,
    channels: channels,
    targetType: targetType,
    targetFilter: targetFilter,
    farmsCount: farmsCount,
    recipientsCount: recipientsCount,
    stats: stats,
    createdAt: DateTime(2026, 9, 9, 12, 30),
  );
}

/// Репозиторий с заранее известным ответом. Провайдеры и notifier истории
/// остаются настоящими — проверяется именно их поведение.
class _FakeRepository extends PlatformAdminRepository {
  _FakeRepository({
    this.announcements = const [],
    this.farms = const [],
    this.sendFailure,
  }) : super(ApiClient(storage: const FlutterSecureStorage()));

  final List<Announcement> announcements;
  final List<PlatformFarm> farms;

  /// Чем ответить на отправку. `null` — принять.
  final Object? sendFailure;

  /// Что ушло на сервер: по этому видно и каналы, и адресата.
  final sent = <AnnouncementDraft>[];

  /// Сколько раз запрашивали историю — по этому видно, обошлась ли новая
  /// запись без перезагрузки списка.
  int listCalls = 0;

  @override
  Future<AnnouncementsPage> getAnnouncements({int page = 1, int limit = 20}) async {
    listCalls += 1;
    return (
      items: announcements,
      page: PageInfo(
        page: 1,
        limit: limit,
        total: announcements.length,
        totalPages: 1,
      ),
    );
  }

  @override
  Future<Announcement> createAnnouncement(AnnouncementDraft draft) async {
    sent.add(draft);
    if (sendFailure != null) throw sendFailure!;
    return _announcement(
      id: 99,
      title: draft.title,
      body: draft.body,
      channels: draft.channels,
      targetType: draft.targetType,
      targetFilter: draft.targetFilter,
      farmsCount: 12,
      recipientsCount: 34,
    );
  }

  @override
  Future<FarmsPage> getFarms({
    int page = 1,
    int limit = 20,
    String? search,
    String? filter,
    String? sort,
  }) async {
    return (
      items: farms,
      page: PageInfo(page: 1, limit: limit, total: farms.length, totalPages: 1),
    );
  }
}

Future<void> _settle(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(420, 2000));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Widget _historyTab(_FakeRepository repository) => testApp(
      const PlatformAnnouncementsTab(),
      overrides: [
        platformAdminRepositoryProvider.overrideWithValue(repository),
      ],
    );

Widget _form(_FakeRepository repository) => testAppScreen(
      const AnnouncementFormScreen(),
      overrides: [
        platformAdminRepositoryProvider.overrideWithValue(repository),
      ],
    );

/// История и форма в одном дереве: так проверяется, что отправленное попадает
/// в список без перезагрузки. Форма открывается настоящим переходом — она и в
/// приложении отдельный экран, а список остаётся под ней живым.
Widget _historyWithForm(_FakeRepository repository) => testAppScreen(
      Scaffold(
        body: const PlatformAnnouncementsTab(),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton.extended(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AnnouncementFormScreen()),
            ),
            label: const Text('Новое объявление'),
          ),
        ),
      ),
      overrides: [
        platformAdminRepositoryProvider.overrideWithValue(repository),
      ],
    );

/// Кнопка отправки внизу формы. Активной она становится только у полного
/// объявления, поэтому её состояние — часть проверок.
FilledButton _submitButton(WidgetTester tester) => tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Отправить'),
    );

Future<void> _fillMessage(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField).at(0), 'Плановые работы');
  await tester.enterText(
    find.byType(TextField).at(1),
    'В субботу с 2 до 4 часов сервис будет недоступен.',
  );
}

void main() {
  group('История объявлений', () {
    testWidgets('строка показывает, кому ушло и сколько дошло', (tester) async {
      await tester.pumpWidget(_historyTab(_FakeRepository(
        announcements: [
          _announcement(),
          _announcement(
            id: 2,
            title: 'Пора выбрать тариф',
            targetType: 'filter',
            targetFilter: 'no_plan',
            channels: const ['email'],
            farmsCount: 3,
            recipientsCount: 5,
            stats: const AnnouncementStats(email: ChannelDelivery(sent: 5)),
          ),
        ],
      )));
      await _settle(tester);

      expect(find.text('Плановые работы'), findsOneWidget);
      expect(find.text('Всем фермам'), findsOneWidget);
      expect(find.text('12 ферм · 34 получателя'), findsOneWidget);
      // Неудачи видны отдельно от удач: до четырёх ферм push не добрался.
      expect(find.text('доставлено 30 из 34'), findsOneWidget);
      expect(find.text('доставлено 34 из 34'), findsOneWidget);
      // Срез назван теми же словами, что и чип в списке ферм.
      expect(find.text('Срез «Без тарифа»'), findsOneWidget);
      expect(find.text('доставлено 5 из 5'), findsOneWidget);
      expect(find.text('2 ОБЪЯВЛЕНИЯ'), findsOneWidget);
    });

    testWidgets('пустая история объясняет, что здесь появится', (tester) async {
      await tester.pumpWidget(_historyTab(_FakeRepository()));
      await _settle(tester);

      expect(find.text('Объявлений ещё не было'), findsOneWidget);
      // Пустая вкладка сама предлагает следующее действие.
      expect(find.text('Новое объявление'), findsOneWidget);
    });
  });

  group('Форма объявления', () {
    testWidgets('без заголовка и текста отправить нельзя', (tester) async {
      await tester.pumpWidget(_form(_FakeRepository()));
      await _settle(tester);

      expect(_submitButton(tester).onPressed, isNull);

      // Одного заголовка недостаточно — пустая рассылка не нужна никому.
      await tester.enterText(find.byType(TextField).at(0), 'Плановые работы');
      await _settle(tester);
      expect(_submitButton(tester).onPressed, isNull);

      await _fillMessage(tester);
      await _settle(tester);
      expect(_submitButton(tester).onPressed, isNotNull);
    });

    testWidgets('без каналов и без выбранной фермы отправить нельзя',
        (tester) async {
      await tester.pumpWidget(_form(_FakeRepository()));
      await _settle(tester);
      await _fillMessage(tester);
      await _settle(tester);

      // Оба канала включены сразу: снимем их — отправлять станет нечем.
      await tester.tap(find.text('Push'));
      await _settle(tester);
      expect(_submitButton(tester).onPressed, isNotNull);
      await tester.tap(find.text('Почта'));
      await _settle(tester);
      expect(_submitButton(tester).onPressed, isNull);

      await tester.tap(find.text('Почта'));
      await _settle(tester);

      // Адресат «одной ферме» без самой фермы — незаконченный выбор.
      await tester.tap(find.text('Одной ферме'));
      await _settle(tester);
      expect(find.text('Выберите ферму'), findsWidgets);
      expect(_submitButton(tester).onPressed, isNull);
    });

    testWidgets('отправка спрашивает подтверждение и уходит на сервер с '
        'обоими каналами', (tester) async {
      final repository = _FakeRepository();
      await tester.pumpWidget(_form(repository));
      await _settle(tester);
      await _fillMessage(tester);
      await _settle(tester);

      await tester.tap(find.widgetWithText(FilledButton, 'Отправить'));
      await _settle(tester);

      // Пока подтверждение не получено, наружу ничего не ушло.
      expect(repository.sent, isEmpty);
      expect(find.text('Отправить объявление?'), findsOneWidget);
      expect(find.text('Кому: Всем фермам'), findsOneWidget);
      expect(
        find.text('Каналы: Push · Почта'),
        findsOneWidget,
      );

      await tester.tap(find.widgetWithText(TextButton, 'Отправить'));
      await _settle(tester);

      expect(repository.sent, hasLength(1));
      final draft = repository.sent.single;
      expect(draft.channels, ['push', 'email']);
      expect(draft.targetType, 'all');
      expect(draft.title, 'Плановые работы');
      // Сервер запрещает лишние поля: при «всем фермам» их не должно быть в
      // запросе вовсе, а не пустыми.
      expect(draft.toJson().containsKey('target_farm_id'), isFalse);
      expect(draft.toJson().containsKey('target_filter'), isFalse);
    });

    testWidgets('отказ от подтверждения ничего не отправляет', (tester) async {
      final repository = _FakeRepository();
      await tester.pumpWidget(_form(repository));
      await _settle(tester);
      await _fillMessage(tester);
      await _settle(tester);

      await tester.tap(find.widgetWithText(FilledButton, 'Отправить'));
      await _settle(tester);
      await tester.tap(find.widgetWithText(TextButton, 'Отмена'));
      await _settle(tester);

      expect(repository.sent, isEmpty);
      // Форма осталась на месте вместе с набранным текстом.
      expect(find.text('Плановые работы'), findsOneWidget);
    });

    testWidgets('отказ сервера оставляет форму открытой вместе с текстом',
        (tester) async {
      final repository =
          _FakeRepository(sendFailure: Exception('Почтовый шлюз не отвечает'));
      await tester.pumpWidget(_form(repository));
      await _settle(tester);
      await _fillMessage(tester);
      await _settle(tester);

      await tester.tap(find.widgetWithText(FilledButton, 'Отправить'));
      await _settle(tester);
      await tester.tap(find.widgetWithText(TextButton, 'Отправить'));
      await _settle(tester);

      // Набранное — единственная его копия, терять его вместе с ошибкой
      // нельзя.
      expect(find.byType(AnnouncementFormScreen), findsOneWidget);
      expect(find.text('Почтовый шлюз не отвечает'), findsOneWidget);
      expect(_submitButton(tester).onPressed, isNotNull);
    });

    testWidgets('выбранная ферма уходит адресатом, а лишних полей в запросе нет',
        (tester) async {
      final repository = _FakeRepository(farms: [
        PlatformFarm(
          id: 7,
          name: 'Зелёная поляна',
          createdAt: DateTime(2026, 9, 1),
        ),
      ]);
      await tester.pumpWidget(_form(repository));
      await _settle(tester);
      await _fillMessage(tester);
      await _settle(tester);

      // Выбор «одной ферме» сам открывает лист — иначе адресата пришлось бы
      // искать вторым касанием.
      await tester.tap(find.text('Одной ферме'));
      await _settle(tester);
      await tester.tap(find.text('Зелёная поляна').last);
      await _settle(tester);

      expect(_submitButton(tester).onPressed, isNotNull);
      await tester.tap(find.widgetWithText(FilledButton, 'Отправить'));
      await _settle(tester);
      expect(find.text('Кому: Ферме «Зелёная поляна»'), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, 'Отправить'));
      await tester.pumpAndSettle();

      final draft = repository.sent.single;
      expect(draft.targetType, 'farm');
      expect(draft.targetFarmId, 7);
      expect(draft.toJson()['target_farm_id'], 7);
      expect(draft.toJson().containsKey('target_filter'), isFalse);
    });

    testWidgets('отправленное встаёт в начало истории без перезагрузки',
        (tester) async {
      final repository = _FakeRepository(announcements: [
        _announcement(id: 1, title: 'Прошлое объявление'),
      ]);
      await tester.pumpWidget(_historyWithForm(repository));
      await _settle(tester);
      expect(repository.listCalls, 1);

      await tester.tap(find.text('Новое объявление'));
      await _settle(tester);

      await _fillMessage(tester);
      await _settle(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Отправить'));
      await _settle(tester);
      await tester.tap(find.widgetWithText(TextButton, 'Отправить'));
      // Не `_settle`: после успеха форма закрывается, и её снятие с экрана
      // приходится на кадр после конца перехода.
      await tester.pumpAndSettle();

      expect(find.byType(AnnouncementFormScreen), findsNothing);
      // Вернулись в историю и увидели отправленное — вторым запросом список
      // не перечитывался.
      expect(find.text('Плановые работы'), findsOneWidget);
      expect(find.text('Прошлое объявление'), findsOneWidget);
      expect(find.text('2 ОБЪЯВЛЕНИЯ'), findsOneWidget);
      expect(repository.listCalls, 1);
    });
  });
}
