import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/core/api/api_client.dart';
import 'package:mobile/core/providers/locale_provider.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';
import 'package:mobile/features/auth/data/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/auth/presentation/providers/language_sync.dart';

UserModel _user({String? language}) => UserModel(
      id: 1,
      fullName: 'Фермер',
      role: 'owner',
      isActive: true,
      language: language,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );

/// Репозиторий без сети: сессии нет, а обновление профиля только запоминает,
/// какой язык до него доехал.
class _FakeAuthRepository extends AuthRepository {
  _FakeAuthRepository()
      : super(
          apiClient: ApiClient(storage: const FlutterSecureStorage()),
          storage: const FlutterSecureStorage(),
        );

  final List<String> languagesSent = [];

  @override
  Future<bool> isLoggedIn() async => false;

  @override
  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    final language = data['language'] as String;
    languagesSent.add(language);
    return _user(language: language);
  }
}

/// Позволяет тесту объявить человека вошедшим, не проигрывая весь вход.
class _TestAuthNotifier extends AuthNotifier {
  _TestAuthNotifier(super.repository, super.ref);

  void signIn(UserModel user) {
    state = state.copyWith(isAuthenticated: true, user: user, isLoading: false);
  }
}

({
  ProviderContainer container,
  _FakeAuthRepository repository,
  _TestAuthNotifier auth,
}) _setUp({UserModel? signedInAs}) {
  final repository = _FakeAuthRepository();
  late _TestAuthNotifier auth;

  final container = ProviderContainer(
    retry: (retryCount, error) => null,
    overrides: [
      authRepositoryProvider.overrideWithValue(repository),
      authProvider.overrideWith((ref) {
        auth = _TestAuthNotifier(repository, ref);
        return auth;
      }),
    ],
  );
  addTearDown(container.dispose);

  container.read(authProvider);
  if (signedInAs != null) auth.signIn(signedInAs);
  container.read(languageSyncProvider);

  return (container: container, repository: repository, auth: auth);
}

Future<void> _settle() async {
  for (var i = 0; i < 6; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Человек выбрал таджикский — приложение обязано сообщить это серверу,
    // иначе пуши так и будут приходить по-русски.
    SharedPreferences.setMockInitialValues({'app_locale': 'tg'});
  });

  test('вошедшему с другим языком отправляет выбранный', () async {
    final env = _setUp(signedInAs: _user(language: 'ru'));

    await _settle();

    expect(env.repository.languagesSent, ['tg']);
  });

  test('не шлёт тот же язык, который на сервере уже стоит', () async {
    final env = _setUp(signedInAs: _user(language: 'tg'));

    await _settle();

    expect(env.repository.languagesSent, isEmpty);
  });

  test('не входившему не шлёт ничего — записывать язык некуда', () async {
    final env = _setUp();

    await _settle();

    expect(env.repository.languagesSent, isEmpty);
  });

  test('язык уезжает при входе, даже если выбран был до него', () async {
    final env = _setUp();
    await _settle();
    expect(env.repository.languagesSent, isEmpty);

    env.auth.signIn(_user(language: 'ru'));
    await _settle();

    expect(env.repository.languagesSent, ['tg']);
  });

  test('смена языка в настройках уходит на сервер', () async {
    final env = _setUp(signedInAs: _user(language: 'tg'));
    await _settle();

    await env.container
        .read(localeProvider.notifier)
        .setLocale(const Locale('uz'));
    await _settle();

    expect(env.repository.languagesSent, ['uz']);
  });
}
