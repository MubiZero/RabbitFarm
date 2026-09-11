import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/api/api_failure.dart';
import 'package:mobile/core/providers/api_providers.dart';
import 'package:mobile/core/router/deep_links.dart';
import 'package:mobile/features/auth/data/models/auth_response.dart';
import 'package:mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/auth/presentation/screens/login_screen.dart';

import '../support/fake_storage.dart';
import '../support/test_app.dart';

/// Репозиторий, который запоминает вызовы вместо похода в сеть. Код всегда
/// отвергается: успешный вход уводит экран на `/` через роутер, которого в
/// виджет-тесте нет, — он проверяется ниже, на уровне провайдера.
class _RecordingAuthRepository extends AuthRepository {
  _RecordingAuthRepository()
      : super(
          apiClient: ApiClient(storage: FakeStorage()),
          storage: FakeStorage(),
        );

  final requestedPhones = <String>[];
  final verified = <(String, String)>[];

  @override
  Future<bool> isLoggedIn() async => false;

  @override
  Future<void> requestOtp({String? phone, String? email}) async {
    requestedPhones.add(phone ?? email!);
  }

  @override
  Future<AuthResponse> verifyOtp({
    String? phone,
    String? email,
    required String code,
  }) async {
    verified.add((phone ?? email!, code));
    throw const ApiFailure(ApiFailureKind.invalid, serverText: 'Неверный код');
  }
}

/// Ответы сервера на вход по телефону. Пользователь намеренно без почты —
/// именно так выглядит работник, приглашённый по номеру.
class _OtpAdapter implements HttpClientAdapter {
  final requests = <String, dynamic>{};

  ResponseBody _json(Map<String, dynamic> body, int status) =>
      ResponseBody.fromString(
        jsonEncode(body),
        status,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType]
        },
      );

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests[options.path] = options.data;

    if (options.path.contains('/auth/otp/request')) {
      return _json({'success': true, 'message': 'ok', 'data': null}, 200);
    }

    if (options.path.contains('/auth/otp/verify')) {
      return _json({
        'success': true,
        'message': 'ok',
        'data': {
          'access_token': 'access',
          'refresh_token': 'refresh',
          'user': {
            'id': 5,
            'email': null,
            'phone': '+992901234567',
            'full_name': 'Работник Фермы',
            'role': 'worker',
            'is_active': true,
            'created_at': '2026-01-01T00:00:00.000Z',
            'updated_at': '2026-01-01T00:00:00.000Z',
            'farm': {'id': 7, 'status': 'active'}
          }
        }
      }, 200);
    }

    return _json({'success': true, 'message': 'ok', 'data': null}, 200);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('экран входа по телефону', () {
    Future<_RecordingAuthRepository> pumpLogin(WidgetTester tester) async {
      final repository = _RecordingAuthRepository();
      await tester.pumpWidget(testAppScreen(
        const LoginScreen(),
        overrides: [
          storageProvider.overrideWithValue(FakeStorage()),
          authRepositoryProvider.overrideWithValue(repository),
        ],
      ));
      await tester.pumpAndSettle();
      return repository;
    }

    Future<void> enterPhone(WidgetTester tester, String phone) async {
      await tester.enterText(find.byType(TextFormField), phone);
      await tester.tap(find.text('Получить код'));
      await tester.pumpAndSettle();
    }

    testWidgets('нетаджикский номер не уходит на сервер', (tester) async {
      final repository = await pumpLogin(tester);

      await enterPhone(tester, '12345');

      expect(find.text('Номер как +992 90 123 45 67'), findsOneWidget);
      expect(repository.requestedPhones, isEmpty);
    });

    testWidgets('номер без кода страны нормализуется и уходит как +992…',
        (tester) async {
      final repository = await pumpLogin(tester);

      await enterPhone(tester, '90 123 45 67');

      expect(repository.requestedPhones, ['+992901234567']);
      // Шаг кода: человек видит, на какой номер ушла SMS.
      expect(find.text('Отправили код на +992 90 123 45 67'), findsOneWidget);
      // Повторная отправка сразу недоступна — идёт обратный отсчёт.
      expect(find.text('Отправить ещё раз через 60 с'), findsOneWidget);
    });

    testWidgets('шесть цифр уходят на проверку сами, без нажатия «Войти»',
        (tester) async {
      final repository = await pumpLogin(tester);
      await enterPhone(tester, '901234567');

      await tester.enterText(find.byType(TextFormField), '123456');
      await tester.pumpAndSettle();

      expect(repository.verified, [('+992901234567', '123456')]);
      // Отказ сервера показан как есть, а поле очищено: следующую попытку не
      // приходится начинать со стирания шести цифр.
      expect(find.text('Неверный код'), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller?.text,
        isEmpty,
      );
    });

    testWidgets('номер из ссылки-приглашения уже стоит в поле',
        (tester) async {
      final repository = _RecordingAuthRepository();
      await tester.pumpWidget(testAppScreen(
        const LoginScreen(initialPhone: '+992901234567'),
        overrides: [
          storageProvider.overrideWithValue(FakeStorage()),
          authRepositoryProvider.overrideWithValue(repository),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.text('+992 90 123 45 67'), findsOneWidget);
      // Сам код по ссылке не запрашивается: SMS уходит по нажатию, а не
      // потому что человек открыл ссылку.
      expect(repository.requestedPhones, isEmpty);
      expect(find.text('Получить код'), findsOneWidget);
    });

    testWidgets('номер из ссылки, открывшей приложение, доезжает до поля',
        (tester) async {
      // Ссылка приходит раньше роутера: экран забирает номер сам, а не
      // получает его маршрутом (см. `deep_links.dart`).
      pendingInvitePhone.value = '+992905550777';
      addTearDown(() => pendingInvitePhone.value = null);

      await pumpLogin(tester);

      expect(find.text('+992 90 555 07 77'), findsOneWidget);
      // Забирается ровно один раз — следующий показ входа поля не подставит.
      expect(pendingInvitePhone.value, isNull);
    });

    testWidgets('«Изменить номер» возвращает к вводу телефона',
        (tester) async {
      await pumpLogin(tester);
      await enterPhone(tester, '901234567');

      await tester.tap(find.text('Изменить номер'));
      await tester.pumpAndSettle();

      expect(find.text('Получить код'), findsOneWidget);
      expect(find.text('Отправили код на +992 90 123 45 67'), findsNothing);
    });
  });

  group('вход по коду через провайдер', () {
    Future<(ProviderContainer, _OtpAdapter, FakeStorage)> build() async {
      final storage = FakeStorage();
      final adapter = _OtpAdapter();
      final client = ApiClient(storage: storage);
      client.dio.httpClientAdapter = adapter;

      final container = ProviderContainer(overrides: [
        storageProvider.overrideWithValue(storage),
        apiClientProvider.overrideWithValue(client),
      ]);
      addTearDown(container.dispose);
      return (container, adapter, storage);
    }

    test('запрос кода уходит на /auth/otp/request с номером', () async {
      final (container, adapter, _) = await build();

      await container
          .read(authProvider.notifier)
          .requestOtp(phone: '+992901234567');

      expect(adapter.requests['/auth/otp/request'],
          {'phone': '+992901234567'});
    });

    test('успешный код открывает сессию работнику без почты', () async {
      final (container, _, storage) = await build();

      await container.read(authProvider.notifier).loginWithOtp(
            phone: '+992901234567',
            code: '123456',
          );

      final state = container.read(authProvider);
      expect(state.isAuthenticated, isTrue);
      // Почты у приглашённого по телефону нет вовсе — разбор профиля на этом
      // спотыкаться не должен.
      expect(state.user?.email, isNull);
      expect(state.user?.contact, '+992 90 123 45 67');
      expect(storage.values['access_token'], 'access');
      expect(storage.values['refresh_token'], 'refresh');
      // Профиль кладётся рядом с токенами: без него роль неизвестна офлайн.
      expect(storage.values['profile'], isNotNull);
    });
  });
}
