# Frontend-Backend Workflow Fix Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Устранить 5 архитектурных проблем: дублирование провайдеров, race condition в Splash, потеря сессии при сетевых ошибках, пересоздание GoRouter при каждом изменении стейта, отсутствие проверки isLoading в роутере.

**Architecture:** Унификация apiClientProvider в core/providers/api_providers.dart; RouterNotifier extends ChangeNotifier с refreshListenable вместо пересоздания GoRouter; защита от сетевых ошибок в _checkAuthStatus; ожидание isLoading в SplashScreen.

**Tech Stack:** Flutter, Riverpod (StateNotifier + Provider), GoRouter, Dio, FlutterSecureStorage

---

## Task 1: Унификация провайдеров (api_providers.dart)

**Files:**
- Modify: `mobile/lib/core/providers/api_providers.dart`

**Step 1: Прочитать текущий файл**

```
cat mobile/lib/core/providers/api_providers.dart
```

**Step 2: Переименовать secureStorageProvider → storageProvider**

Заменить содержимое `mobile/lib/core/providers/api_providers.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/api_client.dart';

// Storage provider (единственный источник истины для FlutterSecureStorage)
final storageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

// ApiClient provider (единственный источник истины для ApiClient)
final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(storageProvider);
  return ApiClient(storage: storage);
});
```

**Step 3: Commit**

```bash
git add mobile/lib/core/providers/api_providers.dart
git commit -m "refactor: rename secureStorageProvider to storageProvider in core"
```

---

## Task 2: Очистить auth_provider.dart от дублей

**Files:**
- Modify: `mobile/lib/features/auth/presentation/providers/auth_provider.dart`

**Step 1: Обновить импорты и удалить дублирующие провайдеры**

Заменить первые строки файла — убрать определения storageProvider и apiClientProvider, добавить импорт из core:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/providers/api_providers.dart';  // ← добавить
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
```

Удалить из файла эти два провайдера (они теперь в api_providers.dart):
```dart
// УДАЛИТЬ:
// final storageProvider = Provider<FlutterSecureStorage>((ref) { ... });
// final apiClientProvider = Provider<ApiClient>((ref) { ... });
```

`authRepositoryProvider` оставить как есть — он использует `apiClientProvider` и `storageProvider` которые теперь из core.

**Step 2: Commit**

```bash
git add mobile/lib/features/auth/presentation/providers/auth_provider.dart
git commit -m "refactor: remove duplicate provider definitions from auth_provider"
```

---

## Task 3: Обновить импорты в фичах, которые брали apiClientProvider из auth_provider

**Files:**
- Modify: `mobile/lib/features/breeding/presentation/providers/breeding_provider.dart`
- Modify: `mobile/lib/features/cages/data/repositories/cages_repository.dart`
- Modify: `mobile/lib/features/rabbits/data/repositories/births_repository.dart`
- Modify: `mobile/lib/features/rabbits/data/repositories/breeds_repository.dart`
- Modify: `mobile/lib/features/rabbits/data/repositories/pedigree_repository.dart`
- Modify: `mobile/lib/features/rabbits/presentation/providers/rabbits_provider.dart`

**Step 1: В каждом из файлов заменить импорт**

Найти строку:
```dart
import '../../../auth/presentation/providers/auth_provider.dart';
// или
import '../../../../features/auth/presentation/providers/auth_provider.dart';
```

Добавить рядом (или заменить если auth_provider больше не нужен в файле):
```dart
import '../../../../core/providers/api_providers.dart';
```

Важно: если файл использует **только** `apiClientProvider` из auth_provider — заменить импорт полностью. Если использует и `authProvider`, и `apiClientProvider` — оставить оба импорта, но `apiClientProvider` будет из core.

Конкретно проверить каждый файл:
- `breeding_provider.dart` — проверить что именно использует
- `cages_repository.dart` — проверить
- `births_repository.dart` — проверить
- `breeds_repository.dart` — проверить
- `pedigree_repository.dart` — проверить
- `rabbits_provider.dart` — проверить

**Step 2: Убедиться что нет конфликтов имён**

```bash
cd mobile && flutter analyze --no-fatal-infos 2>&1 | grep -E "error:|warning:" | head -30
```

**Step 3: Commit**

```bash
git add mobile/lib/features/breeding/ mobile/lib/features/cages/ mobile/lib/features/rabbits/
git commit -m "refactor: unify apiClientProvider import to core/providers/api_providers"
```

---

## Task 4: Исправить getProfile — не прятать DioException

**Files:**
- Modify: `mobile/lib/features/auth/data/repositories/auth_repository.dart`

**Step 1: Изменить getProfile чтобы DioException не оборачивался в Exception**

Найти метод `getProfile()`:
```dart
Future<UserModel> getProfile() async {
  try {
    final response = await _apiClient.getProfile();
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return UserModel.fromJson(apiResponse.data!);
  } on DioException catch (e) {
    throw Exception(e.message ?? 'Ошибка загрузки профиля');  // ← ПРОБЛЕМА
  }
}
```

Заменить на (убрать catch DioException — пусть пробрасывается напрямую):
```dart
Future<UserModel> getProfile() async {
  // DioException пробрасывается напрямую для обработки в AuthNotifier
  final response = await _apiClient.getProfile();
  final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
    response.data,
    (json) => json as Map<String, dynamic>,
  );
  if (!apiResponse.success || apiResponse.data == null) {
    throw Exception(apiResponse.message);
  }
  return UserModel.fromJson(apiResponse.data!);
}
```

**Step 2: Commit**

```bash
git add mobile/lib/features/auth/data/repositories/auth_repository.dart
git commit -m "fix: let DioException propagate from getProfile for proper error handling"
```

---

## Task 5: Исправить _checkAuthStatus — сетевая ошибка ≠ выход

**Files:**
- Modify: `mobile/lib/features/auth/presentation/providers/auth_provider.dart`

**Step 1: Добавить импорт Dio**

Убедиться что в начале файла есть:
```dart
import 'package:dio/dio.dart';
```

**Step 2: Обновить _checkAuthStatus в AuthNotifier**

Найти метод `_checkAuthStatus()` и заменить его:
```dart
// Проверяет является ли DioException сетевой ошибкой (не auth ошибкой)
bool _isNetworkError(DioException e) {
  return e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.connectionError ||
      (e.type == DioExceptionType.unknown &&
          e.error.toString().contains('SocketException'));
}

Future<void> _checkAuthStatus() async {
  state = state.copyWith(isLoading: true);

  try {
    final isLoggedIn = await _authRepository.isLoggedIn();

    if (isLoggedIn) {
      try {
        final user = await _authRepository.getProfile();
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
      } on DioException catch (e) {
        if (_isNetworkError(e)) {
          // Нет сети, но токен есть — считаем пользователя авторизованным
          // user == null, приложение продолжит работу
          state = state.copyWith(
            isAuthenticated: true,
            isLoading: false,
          );
        } else {
          // 401/403 — токен невалидный, разлогиниваем
          await _authRepository.logout();
          state = state.copyWith(isLoading: false);
        }
      } catch (e) {
        // Неизвестная ошибка при загрузке профиля — разлогиниваем
        state = state.copyWith(isLoading: false);
      }
    } else {
      state = state.copyWith(isLoading: false);
    }
  } catch (e) {
    state = state.copyWith(isLoading: false);
  }
}
```

**Step 3: Commit**

```bash
git add mobile/lib/features/auth/presentation/providers/auth_provider.dart
git commit -m "fix: network error during profile fetch no longer logs user out"
```

---

## Task 6: Исправить SplashScreen — ждать окончания isLoading

**Files:**
- Modify: `mobile/lib/features/onboarding/presentation/screens/splash_screen.dart`

**Step 1: Обновить метод _navigate**

Найти `Future<void> _navigate()` и заменить:
```dart
Future<void> _navigate() async {
  await Future.delayed(const Duration(milliseconds: 1500));
  if (!mounted) return;

  // Ждём окончания инициализации аутентификации (максимум 5 секунд)
  int waitedMs = 0;
  while (ref.read(authProvider).isLoading && waitedMs < 5000) {
    await Future.delayed(const Duration(milliseconds: 50));
    waitedMs += 50;
    if (!mounted) return;
  }

  final authState = ref.read(authProvider);
  final onboarding = await ref.read(onboardingProvider.future);

  if (!mounted) return;

  if (authState.isAuthenticated) {
    context.go('/today');
  } else if (!onboarding.isDone) {
    context.go('/onboarding');
  } else {
    context.go('/login');
  }
}
```

**Step 2: Commit**

```bash
git add mobile/lib/features/onboarding/presentation/screens/splash_screen.dart
git commit -m "fix: splash screen waits for auth initialization before navigating"
```

---

## Task 7: Исправить Router — использовать refreshListenable вместо пересоздания

**Files:**
- Modify: `mobile/lib/core/router/app_router.dart`

**Step 1: Добавить класс RouterNotifier перед routerProvider**

Найти начало файла после всех импортов и добавить класс `RouterNotifier`:

```dart
// Нотифицирует GoRouter когда меняется состояние аутентификации
// Вместо пересоздания GoRouter при каждом изменении стейта
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    // Слушаем authProvider, нотифицируем GoRouter
    _ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final authState = _ref.read(authProvider);

    // Не редиректим пока идёт инициализация
    if (authState.isLoading) return null;

    final isAuthenticated = authState.isAuthenticated;
    final loc = state.matchedLocation;
    final isPublic = loc == '/login' ||
        loc == '/register' ||
        loc == '/splash' ||
        loc.startsWith('/onboarding');

    // Неавторизован на защищённой странице → splash
    if (!isAuthenticated && !isPublic) {
      return '/splash';
    }

    // Авторизован на публичной странице → home
    if (isAuthenticated &&
        (loc == '/login' || loc == '/register' || loc == '/splash')) {
      return '/today';
    }

    return null;
  }
}
```

**Step 2: Обновить routerProvider**

Найти `final routerProvider = Provider<GoRouter>((ref) {` и заменить тело:

```dart
final routerProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,   // ← GoRouter пересчитывает redirect при нотификации
    redirect: notifier.redirect,   // ← логика redirect в RouterNotifier
    routes: [
      // ... все routes остаются без изменений
    ],
  );
});
```

Удалить строку:
```dart
final authState = ref.watch(authProvider);  // ← УДАЛИТЬ (было причиной пересоздания)
```

И удалить старый `redirect:` из GoRouter (теперь он в `notifier.redirect`).

**Step 3: Убедиться что компилируется**

```bash
cd mobile && flutter analyze --no-fatal-infos 2>&1 | grep -E "^.*error:" | head -20
```

**Step 4: Commit**

```bash
git add mobile/lib/core/router/app_router.dart
git commit -m "fix: use RouterNotifier with refreshListenable instead of recreating GoRouter"
```

---

## Task 8: Финальная проверка

**Step 1: Полный анализ**

```bash
cd mobile && flutter analyze 2>&1 | tail -20
```

Ожидаем: `No issues found!` или только warnings/infos.

**Step 2: Проверить что нет конфликтов имён провайдеров**

```bash
grep -r "final storageProvider\|final apiClientProvider" mobile/lib/ --include="*.dart" | grep -v "\.g\.dart"
```

Ожидаем: только по одному вхождению каждого (в `core/providers/api_providers.dart`).

**Step 3: Проверить workflow вручную (если бэкенд запущен)**

1. Запустить `docker-compose up` в корне проекта
2. Запустить `flutter run` в mobile/
3. Проверить:
   - Новый пользователь: Splash → Onboarding → Register → Today ✓
   - Повторный вход: Splash → (isLoading ждём) → Today ✓
   - Нет сети при старте: Splash → Today (если был залогинен) ✓
   - Невалидный токен: Splash → Login ✓

**Step 4: Финальный commit если нет ошибок**

```bash
git log --oneline -7
```
