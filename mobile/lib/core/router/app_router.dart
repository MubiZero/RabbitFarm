import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/rabbits/presentation/screens/rabbits_list_screen.dart';
import '../../features/rabbits/presentation/screens/rabbit_form_screen.dart';
import '../../features/rabbits/presentation/screens/rabbit_detail_screen.dart';
import '../../features/rabbits/presentation/screens/pedigree_screen.dart';
import '../../features/rabbits/presentation/screens/breeds_list_screen.dart';
import '../../features/rabbits/presentation/screens/breed_form_screen.dart';
import '../../features/rabbits/presentation/screens/breeding_planner_screen.dart';
import '../../features/breeding/presentation/screens/breeding_form_screen.dart';
import '../../features/breeding/presentation/screens/breeding_detail_screen.dart';
import '../../features/rabbits/presentation/screens/birth_form_screen.dart';
import '../../features/rabbits/presentation/screens/births_list_screen.dart';
import '../../features/rabbits/data/models/rabbit_model.dart';
import '../../features/rabbits/data/models/breed_model.dart';
import '../../features/rabbits/data/models/breeding_model.dart';
import '../../features/rabbits/data/models/birth_model.dart';
import '../../features/cages/presentation/screens/cages_list_screen.dart';
import '../../features/cages/presentation/screens/cage_form_screen.dart';
import '../../features/cages/presentation/screens/cage_detail_screen.dart';
import '../../features/cages/data/models/cage_model.dart';
import '../../features/health/presentation/screens/health_journal_screen.dart';
import '../../features/health/presentation/screens/vaccinations_list_screen.dart';
import '../../features/health/presentation/screens/vaccination_form_screen.dart';
import '../../features/health/data/models/vaccination_model.dart';
import '../../features/health/presentation/providers/vaccinations_provider.dart';
import '../../features/health/presentation/screens/medical_records_list_screen.dart';
import '../../features/health/presentation/screens/medical_record_form_screen.dart';
import '../../features/health/data/models/medical_record_model.dart';
import '../../features/feeding/presentation/screens/feeds_list_screen.dart';
import '../../features/feeding/presentation/screens/feed_form_screen.dart';
import '../../features/feeding/presentation/screens/feed_statistics_screen.dart';
import '../../features/feeding/presentation/screens/feeding_records_list_screen.dart';
import '../../features/feeding/presentation/screens/feeding_record_form_screen.dart';
import '../../features/feeding/presentation/screens/feeding_statistics_screen.dart';
import '../../features/feeding/data/models/feed_model.dart';
import '../../features/feeding/data/models/feeding_record_model.dart';
import '../../features/feeding/presentation/providers/feeds_provider.dart';
import '../../features/finance/presentation/screens/transactions_list_screen.dart';
import '../../features/finance/presentation/screens/transaction_form_screen.dart';
import '../../features/finance/presentation/screens/transaction_statistics_screen.dart';
import '../../features/finance/data/models/transaction_model.dart';
import '../../features/tasks/presentation/screens/tasks_list_screen.dart';
import '../../features/tasks/presentation/screens/task_form_screen.dart';
import '../../features/tasks/data/models/task_model.dart';
import '../../features/tasks/presentation/providers/tasks_provider.dart';
import '../../features/notes/presentation/screens/note_form_screen.dart';
import '../../features/notes/data/models/note_model.dart';
import '../../features/notes/presentation/providers/notes_provider.dart';
import '../widgets/app_async_view.dart';
import '../../features/rabbits/presentation/screens/photo_gallery_screen.dart';
import '../../features/rabbits/data/models/rabbit_photo_model.dart';
import '../../features/home/presentation/screens/main_navigation_screen.dart';
import '../../features/home/presentation/screens/today_screen.dart';
import '../../features/home/presentation/screens/farm_screen.dart';
import '../../features/home/presentation/screens/journal_screen.dart';
import '../../features/rabbits/presentation/screens/herd_screen.dart';
import '../../features/breeding/presentation/screens/breeding_cycle_screen.dart';
import '../../features/reports/presentation/screens/reports_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/subscription/presentation/screens/subscription_screen.dart';
import '../../features/support/presentation/screens/support_request_screen.dart';
import '../../features/staff/presentation/screens/staff_screen.dart';
import '../../features/platform_admin/data/models/platform_admin_models.dart';
import '../../features/platform_admin/presentation/screens/platform_admin_screen.dart';
import '../../features/platform_admin/presentation/screens/announcement_form_screen.dart';
import '../../features/platform_admin/presentation/screens/plan_form_screen.dart';
import '../../features/platform_admin/presentation/screens/farm_detail_screen.dart';
import '../../features/platform_admin/presentation/screens/farm_export_screen.dart';
import '../../features/staff/presentation/screens/join_farm_screen.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_welcome_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_farm_name_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_farm_type_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_ready_screen.dart';

/// Notifies GoRouter when auth state changes.
/// Correct pattern: GoRouter is created once, redirect is re-evaluated on notification.
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final authState = _ref.read(authProvider);

    // Don't redirect while initializing
    if (authState.isLoading) return null;

    final isAuthenticated = authState.isAuthenticated;
    final loc = state.matchedLocation;
    final isPublic = loc == '/login' ||
        loc == '/register' ||
        loc == '/join' ||
        loc == '/forgot-password' ||
        loc == '/reset-password' ||
        loc == '/splash' ||
        loc.startsWith('/onboarding');

    // Not authenticated on a protected page -> splash
    if (!isAuthenticated && !isPublic) {
      return '/splash';
    }

    // Authenticated on a public page -> home
    if (isAuthenticated &&
        (loc == '/login' ||
            loc == '/register' ||
            loc == '/join' ||
            loc == '/forgot-password' ||
            loc == '/reset-password' ||
            loc == '/splash')) {
      return '/today';
    }

    return null;
  }
}

/// Экраны, которые открываются «вглубь» (карточки, формы, справочники),
/// должны закрывать вкладочную оболочку целиком. Без явного корневого ключа
/// go_router кладёт их в навигатор оболочки: под формой оставались панель
/// вкладок и кнопка «+», которой можно было начать вторую запись поверх
/// незаконченной первой.
final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);
  ref.onDispose(notifier.dispose);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      // Splash
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding routes
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingWelcomeScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/onboarding/farm-name',
        name: 'onboarding-farm-name',
        builder: (context, state) => const OnboardingFarmNameScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/onboarding/farm-type',
        name: 'onboarding-farm-type',
        builder: (context, state) => const OnboardingFarmTypeScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/onboarding/ready',
        name: 'onboarding-ready',
        builder: (context, state) => const OnboardingReadyScreen(),
      ),

      // Auth routes
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/join',
        name: 'join-farm',
        builder: (context, state) => const JoinFarmScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/reset-password',
        name: 'reset-password',
        builder: (context, state) =>
            ResetPasswordScreen(email: state.extra as String),
      ),

      // Root redirect
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/',
        redirect: (context, state) => '/today',
      ),

      // Прежние адреса вкладок: ссылки из старых экранов и уведомлений
      // не должны упираться в «страница не найдена».
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/menu',
        redirect: (context, state) => '/farm',
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/more',
        redirect: (context, state) => '/farm',
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/rabbits',
        name: 'rabbits',
        builder: (context, state) => const RabbitsListScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/tasks',
        name: 'tasks',
        builder: (context, state) => const TasksListScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/reports',
        name: 'reports',
        builder: (context, state) => const ReportsScreen(),
      ),

      // Main shell route with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainNavigationScreen(
            currentPath: state.uri.path,
            child: child,
          );
        },
        routes: [
          // Today screen
          GoRoute(
            path: '/today',
            name: 'today',
            builder: (context, state) => const TodayScreen(),
          ),

          // Стадо: клетки и кролики — два взгляда на одно поголовье.
          GoRoute(
            path: '/herd',
            name: 'herd',
            builder: (context, state) => const HerdScreen(),
          ),

          // Разведение: линия цикла от случки до отсадки.
          GoRoute(
            path: '/breeding',
            name: 'breeding',
            builder: (context, state) => const BreedingCycleScreen(),
          ),

          // Хозяйство: деньги, корма, здоровье, отчёты, люди, настройки.
          GoRoute(
            path: '/farm',
            name: 'farm',
            builder: (context, state) => const FarmScreen(),
          ),

          // Журнал смены — вкладка работника.
          GoRoute(
            path: '/journal',
            name: 'journal',
            builder: (context, state) => const JournalScreen(),
          ),
        ],
      ),

      // Rabbit detail and form routes (outside shell)
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/rabbits/new',
        name: 'rabbit-new',
        builder: (context, state) => const RabbitFormScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/rabbits/:id',
        name: 'rabbit-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return RabbitDetailScreen(rabbitId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/rabbits/:id/edit',
        name: 'rabbit-edit',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final rabbit = state.extra as RabbitModel?;
          return RabbitFormScreen(
            rabbitId: id,
            rabbit: rabbit,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/rabbits/:id/pedigree',
        name: 'rabbit-pedigree',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          // Подпись собирает экран: русское слово в роутере не переводится
          // и живёт мимо словаря приложения.
          final name = state.uri.queryParameters['name'];
          return PedigreeScreen(
            rabbitId: id,
            rabbitName: name,
          );
        },
      ),

      // Breeds routes
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/breeds',
        name: 'breeds',
        builder: (context, state) => const BreedsListScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/breeds/form',
        name: 'breed-form',
        builder: (context, state) {
          final breed = state.extra as BreedModel?;
          return BreedFormScreen(breed: breed);
        },
      ),

      // Breeding routes
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/breeding/planner',
        name: 'breeding-planner',
        builder: (context, state) => const BreedingPlannerScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/breeding/new',
        name: 'breeding-new',
        builder: (context, state) {
          final initialData = state.extra as Map<String, dynamic>?;
          return BreedingFormScreen(initialData: initialData);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/breeding/:id',
        name: 'breeding-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return BreedingDetailScreen(breedingId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/breeding/:id/edit',
        name: 'breeding-edit',
        builder: (context, state) {
          final breeding = state.extra as BreedingModel?;
          assert(breeding != null, 'breeding-edit route requires BreedingModel as extra');
          if (breeding == null) {
            return BreedingDetailScreen(breedingId: int.parse(state.pathParameters['id']!));
          }
          return BreedingFormScreen(breeding: breeding);
        },
      ),

      // Births routes
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/births',
        name: 'births',
        builder: (context, state) => const BirthsListScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/births/new',
        name: 'birth-new',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is BirthModel) {
            return BirthFormScreen(birth: extra);
          }
          final breeding = extra is BreedingModel ? extra : null;
          return BirthFormScreen(breeding: breeding);
        },
      ),

      // Здоровье — общий журнал прививок и лечения. Прежние адреса ниже
      // остаются: на них ведут ссылки с «Сегодня» и из пустых состояний.
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/health',
        name: 'health',
        builder: (context, state) => const HealthJournalScreen(),
      ),

      // Vaccinations routes
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/vaccinations',
        name: 'vaccinations',
        builder: (context, state) => const VaccinationsListScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/vaccinations/form',
        name: 'vaccination-form',
        builder: (context, state) {
          final vaccination = state.extra as Vaccination?;
          return VaccinationFormScreen(vaccination: vaccination);
        },
      ),
      // Открывает карточку (=форму редактирования) по id — для тапа по push.
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/vaccinations/:id',
        name: 'vaccination-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return Consumer(
            builder: (context, ref, _) => AppAsyncView<Vaccination>(
              value: ref.watch(vaccinationByIdProvider(id)),
              onRetry: () => ref.invalidate(vaccinationByIdProvider(id)),
              builder: (vaccination) => VaccinationFormScreen(vaccination: vaccination),
            ),
          );
        },
      ),

      // Cages routes
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/cages',
        name: 'cages',
        builder: (context, state) => const CagesListScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/cages/form',
        name: 'cage-form',
        builder: (context, state) {
          final cage = state.extra as CageModel?;
          return CageFormScreen(cage: cage);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/cages/:id',
        name: 'cage-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CageDetailScreen(cageId: id);
        },
      ),

      // Medical Records routes
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/medical-records',
        name: 'medical-records',
        builder: (context, state) => const MedicalRecordsListScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/medical-records/form',
        name: 'medical-record-form',
        builder: (context, state) {
          final medicalRecord = state.extra as MedicalRecord?;
          return MedicalRecordFormScreen(medicalRecord: medicalRecord);
        },
      ),

      // Feeds routes
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/feeds',
        name: 'feeds',
        builder: (context, state) => const FeedsListScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/feeds/form',
        name: 'feed-form',
        builder: (context, state) {
          final feed = state.extra as Feed?;
          return FeedFormScreen(feed: feed);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/feeds/statistics',
        name: 'feed-statistics',
        builder: (context, state) => const FeedStatisticsScreen(),
      ),
      // Открывает карточку (=форму редактирования) по id — для тапа по push.
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/feeds/:id',
        name: 'feed-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return Consumer(
            builder: (context, ref, _) => AppAsyncView<Feed>(
              value: ref.watch(feedByIdProvider(id)),
              onRetry: () => ref.invalidate(feedByIdProvider(id)),
              builder: (feed) => FeedFormScreen(feed: feed),
            ),
          );
        },
      ),

      // Feeding Records routes
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/feeding-records',
        name: 'feeding-records',
        builder: (context, state) => const FeedingRecordsListScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/feeding-records/form',
        name: 'feeding-record-form',
        builder: (context, state) {
          final record = state.extra as FeedingRecord?;
          return FeedingRecordFormScreen(record: record);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/feeding-records/statistics',
        name: 'feeding-record-statistics',
        builder: (context, state) => const FeedingStatisticsScreen(),
      ),

      // Transactions routes
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/transactions',
        name: 'transactions',
        builder: (context, state) => const TransactionsListScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/transactions/form',
        name: 'transaction-form',
        builder: (context, state) {
          final transaction = state.extra as Transaction?;
          return TransactionFormScreen(transaction: transaction);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/transactions/statistics',
        name: 'transaction-statistics',
        builder: (context, state) => const TransactionStatisticsScreen(),
      ),

      // Task form route (outside shell)
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/tasks/form',
        name: 'task-form',
        builder: (context, state) {
          final task = state.extra as Task?;
          return TaskFormScreen(task: task);
        },
      ),
      // Открывает карточку (=форму редактирования) по id — для тапа по push.
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/tasks/:id',
        name: 'task-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return Consumer(
            builder: (context, ref, _) => AppAsyncView<Task>(
              value: ref.watch(taskProvider(id)),
              onRetry: () => ref.invalidate(taskProvider(id)),
              builder: (task) => TaskFormScreen(task: task),
            ),
          );
        },
      ),

      // Note form route (outside shell)
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/notes/form',
        name: 'note-form',
        builder: (context, state) {
          final note = state.extra as NoteModel?;
          return NoteFormScreen(note: note);
        },
      ),
      // Открывает карточку (=форму редактирования) по id — для тапа по push.
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/notes/:id',
        name: 'note-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return Consumer(
            builder: (context, ref, _) => AppAsyncView<NoteModel>(
              value: ref.watch(noteByIdProvider(id)),
              onRetry: () => ref.invalidate(noteByIdProvider(id)),
              builder: (note) => NoteFormScreen(note: note),
            ),
          );
        },
      ),

      // Photo journal entry route (outside shell) — открывает галерею
      // кролика, которому принадлежит снимок: у самой записи Дневника нет
      // формы правки, редактировать там нечего.
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/rabbits/gallery',
        name: 'rabbit-gallery-from-journal',
        builder: (context, state) {
          final photo = state.extra as RabbitPhoto;
          return PhotoGalleryScreen(
            rabbitId: photo.rabbitId!,
            rabbitLabel: photo.rabbit?.label ?? '',
          );
        },
      ),

      // Settings screen
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      // Тариф самой фермы — оплата продления (см.
      // docs/plans/PLATFORM-ADMIN.md, 4.1). Доступ на сервере ограничен
      // владельцем, маршрут сам по себе ничего не открывает.
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/subscription',
        name: 'subscription',
        builder: (context, state) => const SubscriptionScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/staff',
        name: 'staff',
        builder: (context, state) => const StaffScreen(),
      ),
      // Работает даже при закрытом доступе фермы (см.
      // `authenticateEvenIfFarmBlocked` на бэкенде) — маршрут сам по себе
      // ничего не открывает, доступ решает сервер.
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/support',
        name: 'support',
        builder: (context, state) => const SupportRequestScreen(),
      ),

      // Платформенная админка. Вход в неё есть только у суперадмина (см.
      // экран «Хозяйство»), а доступ к данным закрыт на сервере — маршрут
      // сам по себе ничего не открывает.
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/platform-admin',
        name: 'platform-admin',
        builder: (context, state) => const PlatformAdminScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/platform-admin/plans/form',
        name: 'platform-plan-form',
        builder: (context, state) => PlanFormScreen(plan: state.extra as Plan?),
      ),
      // Карточка одной фермы — по id, а не через `extra`: сама ферма грузится
      // целиком (состав, платежи, место), и строка из списка ей не подходит.
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/platform-admin/farms/:id',
        name: 'platform-farm',
        builder: (context, state) => FarmDetailScreen(
          farmId: int.parse(state.pathParameters['id']!),
        ),
      ),
      // Выгрузка данных фермы. Название приходит в `extra` с карточки — только
      // для заголовка; без него экран обходится подписью-заглушкой, а не
      // вторым запросом.
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/platform-admin/farms/:id/export',
        name: 'platform-farm-export',
        builder: (context, state) => FarmExportScreen(
          farmId: int.parse(state.pathParameters['id']!),
          farmName: state.extra as String?,
        ),
      ),
      // Составление объявления. Правки у отправленного нет и быть не может,
      // поэтому маршрут один и без параметров — только новое.
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/platform-admin/announcements/form',
        name: 'platform-announcement-form',
        builder: (context, state) => const AnnouncementFormScreen(),
      ),

    ],
  );
});
