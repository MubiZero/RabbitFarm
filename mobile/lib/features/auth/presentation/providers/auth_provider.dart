import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/analytics/analytics.dart';
import '../../../../core/models/farm_ref.dart';
import '../../../../core/providers/app_version.dart';
import '../../../../core/notifications/fcm_service.dart';
import '../../../../core/providers/api_providers.dart';
import '../../../../core/providers/session.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

// Auth Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storage = ref.watch(storageProvider);
  return AuthRepository(apiClient: apiClient, storage: storage);
});

// Auth State
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final Object? error;
  final bool isAuthenticated;

  /// Идёт вход под клиентом, только чтение (см.
  /// docs/plans/PLATFORM-ADMIN.md, 3.2) — [user] в этом режиме не сам админ,
  /// а владелец просматриваемой фермы; собственная сессия админа отложена и
  /// ждёт [AuthNotifier.exitImpersonation].
  final bool isImpersonating;

  /// Название фермы для плашки. Не пусто ровно тогда, когда
  /// [isImpersonating] — используется вместо самого имени пользователя,
  /// потому что плашка должна сказать «вы смотрите чужую ферму», а не
  /// притвориться, что это обычный сеанс.
  final String? impersonatedFarmName;

  /// Сеанс просмотра закончился сам — истёк срок, а не нажали «Выйти».
  /// Разовый флаг: экран показывает уведомление и сбрасывает его.
  final bool impersonationJustExpired;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.isImpersonating = false,
    this.impersonatedFarmName,
    this.impersonationJustExpired = false,
  });

  /// Переход между «под клиентом» и обычной сессией всегда идёт через
  /// прямое построение [AuthState] (как уже делает выход — `state =
  /// AuthState()`), а не через [copyWith]: здесь поля сливаются с прежними
  /// значениями, и обнулить [impersonatedFarmName] этим способом нельзя.
  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    Object? error,
    bool? isAuthenticated,
    bool? isImpersonating,
    String? impersonatedFarmName,
    bool? impersonationJustExpired,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isImpersonating: isImpersonating ?? this.isImpersonating,
      impersonatedFarmName: impersonatedFarmName ?? this.impersonatedFarmName,
      impersonationJustExpired:
          impersonationJustExpired ?? this.impersonationJustExpired,
    );
  }
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthNotifier(this._authRepository, this._ref) : super(AuthState()) {
    // Клиент сообщает сюда, что обновить токен не удалось. Раньше он молча
    // стирал токены, а приложение продолжало считать себя авторизованным:
    // все экраны писали «не авторизован», и выйти можно было только
    // перезапуском.
    _ref.read(apiClientProvider).onSessionExpired = _handleSessionExpired;
    // Ферму могли приостановить или её тариф истёк, пока сеанс уже был
    // открыт — узнаём об этом по ответу на первый же неудавшийся запрос, не
    // дожидаясь следующего обновления профиля (см. `FarmStatusBanner`).
    _ref.read(apiClientProvider).onFarmAccessChanged = _handleFarmAccessChanged;
    // Проверяется бэкендом на каждый запрос, включая незалогиненные (вход,
    // регистрация) — поэтому висит здесь же, а не только для сессии.
    _ref.read(apiClientProvider).onUpgradeRequired =
        () => _ref.read(upgradeRequiredProvider.notifier).state = true;
    _checkAuthStatus();
  }

  void _handleFarmAccessChanged(String status) {
    if (!mounted) return;
    final user = state.user;
    if (user == null) return;

    state = state.copyWith(
      user: user.copyWith(
        farm: (user.farm ?? FarmRef(id: user.id, status: status))
            .copyWith(status: status),
      ),
    );
  }

  void _handleSessionExpired() {
    if (!mounted) return;
    // Это тот же сигнал, которым для обычной сессии кончается «token
    // expired» — но если только что был вход под клиентом (см.
    // docs/plans/PLATFORM-ADMIN.md, 3.2), это в первую очередь означает, что
    // истёк его 15-минутный токен: у него нет refresh, и обновиться ему было
    // нечем. В этом случае не выходим совсем, а возвращаем отложенную сессию
    // админа.
    _restoreAfterSessionExpired();
  }

  Future<void> _restoreAfterSessionExpired() async {
    final wasImpersonating = await _authRepository.isImpersonating();
    if (wasImpersonating) {
      final restored = await _authRepository.restoreFromImpersonation();
      if (!mounted) return;
      if (restored) {
        try {
          final user = await _authRepository.getProfile();
          if (!mounted) return;
          state = AuthState(
            user: user,
            isAuthenticated: true,
            impersonationJustExpired: true,
          );
          resetSessionData(_ref);
          return;
        } catch (_) {
          // Восстановленный токен админа тоже не подошёл (истёк заодно или
          // сеть подвела) — тогда честный выход, а не «как бы авторизован».
        }
      }
    }

    if (!mounted) return;
    state = AuthState();
    // Профиль уезжает вместе с сессией: токены клиент уже стёр, а имя и роль
    // прошлого пользователя оставлять на устройстве незачем.
    await _authRepository.clearCachedProfile();
    resetSessionData(_ref);
  }

  /// Плашка показала «сеанс просмотра истёк, вы в своём аккаунте» — флаг
  /// разовый, дальше он не нужен.
  void clearImpersonationExpiredNotice() {
    if (state.impersonationJustExpired) {
      state = state.copyWith(impersonationJustExpired: false);
    }
  }

  bool _isNetworkError(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError ||
        (e.type == DioExceptionType.unknown &&
            e.error.toString().contains('SocketException'));
  }

  // Check if user is already logged in
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    try {
      final isLoggedIn = await _authRepository.isLoggedIn();

      if (isLoggedIn) {
        // Приложение перезапустили посреди сеанса просмотра под клиентом
        // (см. docs/plans/PLATFORM-ADMIN.md, 3.2) — в памяти от этого
        // сеанса ничего не остаётся, а на диске остаётся отложенная сессия
        // админа. Без этой проверки плашка и кнопка «Выйти» после
        // перезапуска пропадали бы, хотя токен на владельца ещё жив.
        final impersonatedFarmName = await _authRepository.isImpersonating()
            ? await _authRepository.impersonatedFarmName()
            : null;

        try {
          final user = await _authRepository.getProfile();
          state = state.copyWith(
            user: user,
            isAuthenticated: true,
            isLoading: false,
            isImpersonating: impersonatedFarmName != null,
            impersonatedFarmName: impersonatedFarmName,
          );
          _ref.read(fcmServiceProvider).registerCurrentToken();
        } on DioException catch (e) {
          if (_isNetworkError(e)) {
            // Сети нет, но токен есть — работаем дальше. Профиль при этом
            // берём из хранилища: без него роль неизвестна, а неизвестная
            // роль трактуется как самая узкая, и владелец в сарае без связи
            // получал интерфейс работника.
            state = state.copyWith(
              user: await _authRepository.cachedProfile(),
              isAuthenticated: true,
              isLoading: false,
              isImpersonating: impersonatedFarmName != null,
              impersonatedFarmName: impersonatedFarmName,
            );
          } else {
            // 401/403 — token is invalid, log user out
            await _authRepository.logout();
            state = state.copyWith(isLoading: false);
          }
        } catch (e) {
          // Unknown error during profile fetch — log user out
          state = state.copyWith(isLoading: false);
        }
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  // Login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authResponse = await _authRepository.login(
        email: email,
        password: password,
      );

      state = state.copyWith(
        user: authResponse.user,
        isAuthenticated: true,
        isLoading: false,
      );
      _ref.read(fcmServiceProvider).registerCurrentToken();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e,
      );
      rethrow;
    }
  }

  // Register
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    String? farmName,
    String? phone,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authResponse = await _authRepository.register(
        email: email,
        password: password,
        fullName: fullName,
        farmName: farmName,
        phone: phone,
      );

      state = state.copyWith(
        user: authResponse.user,
        isAuthenticated: true,
        isLoading: false,
      );
      Analytics.signUpCompleted();
      _ref.read(fcmServiceProvider).registerCurrentToken();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e,
      );
      rethrow;
    }
  }

  /// Запросить код входа по телефону — первый шаг основного способа входа.
  Future<void> requestOtp(String phone) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authRepository.requestOtp(phone: phone);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
      rethrow;
    }
  }

  /// Проверить код и войти — второй шаг. Для номера с активным приглашением
  /// сервер заводит работника на лету и сразу выдаёт токены.
  Future<void> verifyOtp({required String phone, required String code}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authResponse = await _authRepository.verifyOtp(
        phone: phone,
        code: code,
      );

      state = state.copyWith(
        user: authResponse.user,
        isAuthenticated: true,
        isLoading: false,
      );
      _ref.read(fcmServiceProvider).registerCurrentToken();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e,
      );
      rethrow;
    }
  }

  /// Присоединиться к ферме по коду приглашения.
  Future<void> acceptInvitation({
    required String code,
    required String password,
    required String fullName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authResponse = await _authRepository.acceptInvitation(
        code: code,
        password: password,
        fullName: fullName,
      );

      state = state.copyWith(
        user: authResponse.user,
        isAuthenticated: true,
        isLoading: false,
      );
      _ref.read(fcmServiceProvider).registerCurrentToken();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e,
      );
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      // Отвязываем токен, пока access-токен ещё не стёрт: после
      // _authRepository.logout() запрос ушёл бы уже без авторизации.
      await _ref.read(fcmServiceProvider).unregisterCurrentToken();
      await _authRepository.logout();
    } catch (_) {
      // Ignore network errors — tokens are already cleared in repository (finally)
    } finally {
      // Always reset auth state
      state = AuthState();
      // Данные предыдущего пользователя нужно забыть: на общем планшете фермы
      // следующий вошедший иначе увидит чужое поголовье прямо из памяти.
      resetSessionData(_ref);
    }
  }

  /// Начать вход под клиентом, только чтение (см.
  /// docs/plans/PLATFORM-ADMIN.md, 3.2). [accessToken] — уже выпущенный
  /// сервером 15-минутный read_only-токен на владельца фермы; собственная
  /// сессия админа откладывается, а не заканчивается.
  Future<void> startImpersonation({
    required String accessToken,
    required String farmName,
  }) async {
    await _authRepository.startImpersonation(
      accessToken: accessToken,
      farmName: farmName,
    );
    final user = await _authRepository.getProfile();
    state = AuthState(
      user: user,
      isAuthenticated: true,
      isImpersonating: true,
      impersonatedFarmName: farmName,
    );
    // Провайдеры кроликов, клеток и прочего хозяйства обязаны перечитаться
    // для фермы, под которой вошли, — как при обычной смене пользователя на
    // общем устройстве.
    resetSessionData(_ref);
  }

  /// Кнопка «Выйти из режима просмотра» — в отличие от [_handleSessionExpired]
  /// это осознанное завершение раньше 15 минут, без флага «истёк сам».
  Future<void> exitImpersonation() async {
    final restored = await _authRepository.restoreFromImpersonation();
    if (!restored) {
      // Отложенной сессии не нашлось — восстанавливать нечего, только выйти.
      await logout();
      return;
    }

    final user = await _authRepository.getProfile();
    state = AuthState(user: user, isAuthenticated: true);
    resetSessionData(_ref);
  }

  /// Первичная установка пароля тому, кто входил только по OTP — сессия не
  /// прерывается, просто у профиля появляется способ входа про запас.
  Future<void> setPassword(String newPassword) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authRepository.setPassword(newPassword);
      final user = state.user;
      state = state.copyWith(
        isLoading: false,
        user: user == null ? null : user.copyWith(hasPassword: true),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
      rethrow;
    }
  }

  /// Сменить уже заданный пароль. Сервер отзывает токены на всех
  /// устройствах — сразу вслед за успехом выходим и здесь, а не только
  /// доверяем следующему запросу упасть на 401.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authRepository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
      rethrow;
    }

    await logout();
  }

  // Refresh profile
  Future<void> refreshProfile() async {
    try {
      final user = await _authRepository.getProfile();
      state = state.copyWith(user: user);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Включить/выключить ежедневный дайджест (см. Настройки). Возвращает
  /// причину неудачи или `null` — как и остальные действия из форм, чтобы
  /// экран сам решил, что показать, вместо разбора состояния провайдера.
  ///
  /// Переключатель обновляется сразу, не дожидаясь ответа сервера: это
  /// обратимая настройка без побочных эффектов для остальной фермы — ждать
  /// здесь ответа сервера ради сотни миллисекунд не за чем. При отказе
  /// значение возвращается назад.
  Future<Object?> setDigestEnabled(bool enabled) async {
    final user = state.user;
    if (user == null) return null;

    final previous = user.digestEnabled;
    state = state.copyWith(user: user.copyWith(digestEnabled: enabled));

    try {
      final updated =
          await _authRepository.updateProfile({'digest_enabled': enabled});
      if (!mounted) return null;
      state = state.copyWith(user: updated);
      return null;
    } catch (e) {
      if (!mounted) return null;
      state = state.copyWith(user: user.copyWith(digestEnabled: previous));
      return e;
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository, ref);
});
