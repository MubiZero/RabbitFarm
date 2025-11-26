import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/rabbits/presentation/screens/rabbits_list_screen.dart';
import '../../features/rabbits/presentation/screens/rabbit_form_screen.dart';
import '../../features/rabbits/presentation/screens/rabbit_detail_screen.dart';
import '../../features/rabbits/presentation/screens/pedigree_screen.dart';
import '../../features/rabbits/presentation/screens/breeds_list_screen.dart';
import '../../features/rabbits/presentation/screens/breed_form_screen.dart';
import '../../features/rabbits/presentation/screens/breeding_planner_screen.dart';
import '../../features/breeding/presentation/screens/breeding_list_screen.dart';
import '../../features/breeding/presentation/screens/breeding_form_screen.dart';
import '../../features/breeding/presentation/screens/breeding_detail_screen.dart';
import '../../features/rabbits/presentation/screens/birth_form_screen.dart';
import '../../features/rabbits/presentation/screens/births_list_screen.dart';
import '../../features/rabbits/data/models/rabbit_model.dart';
import '../../features/rabbits/data/models/breed_model.dart';
import '../../features/rabbits/data/models/breeding_model.dart';
import '../../features/cages/presentation/screens/cages_list_screen.dart';
import '../../features/cages/presentation/screens/cage_form_screen.dart';
import '../../features/cages/presentation/screens/cage_detail_screen.dart';
import '../../features/cages/data/models/cage_model.dart';
import '../../features/health/presentation/screens/vaccinations_list_screen.dart';
import '../../features/health/presentation/screens/vaccination_form_screen.dart';
import '../../features/health/data/models/vaccination_model.dart';
import '../../features/health/presentation/screens/medical_records_list_screen.dart';
import '../../features/health/presentation/screens/medical_record_form_screen.dart';
import '../../features/health/data/models/medical_record_model.dart';
import '../../features/feeding/presentation/screens/feeds_list_screen.dart';
import '../../features/feeding/presentation/screens/feed_form_screen.dart';
import '../../features/feeding/presentation/screens/feeding_records_list_screen.dart';
import '../../features/feeding/presentation/screens/feeding_record_form_screen.dart';
import '../../features/feeding/data/models/feed_model.dart';
import '../../features/feeding/data/models/feeding_record_model.dart';
import '../../features/finance/presentation/screens/transactions_list_screen.dart';
import '../../features/finance/presentation/screens/transaction_form_screen.dart';
import '../../features/finance/data/models/transaction_model.dart';
import '../../features/tasks/presentation/screens/tasks_list_screen.dart';
import '../../features/tasks/presentation/screens/task_form_screen.dart';
import '../../features/tasks/data/models/task_model.dart';
import '../../features/reports/presentation/screens/dashboard_screen.dart';
import '../../features/reports/presentation/screens/modern_dashboard_screen.dart';
import '../../features/reports/presentation/screens/customizable_dashboard_screen.dart';
import '../../features/reports/presentation/screens/dashboard_settings_screen.dart';
import '../../features/home/presentation/screens/main_navigation_screen.dart';
import '../../features/home/presentation/screens/today_screen.dart';
import '../../features/home/presentation/screens/more_screen.dart';

// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';

      // If not authenticated and not on login/register page, redirect to login
      if (!isAuthenticated && !isLoggingIn && !isRegistering) {
        return '/login';
      }

      // If authenticated and on login/register page, redirect to home
      if (isAuthenticated && (isLoggingIn || isRegistering)) {
        return '/today';
      }

      return null; // No redirect
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Root redirect
      GoRoute(
        path: '/',
        redirect: (context, state) => '/today',
      ),

      // Main shell route with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigationScreen(
            child: child,
            currentPath: state.uri.path,
          );
        },
        routes: [
          // Today screen
          GoRoute(
            path: '/today',
            name: 'today',
            builder: (context, state) => const TodayScreen(),
          ),

          // Dashboard (Overview)
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const CustomizableDashboardScreen(),
          ),

          // Rabbits
          GoRoute(
            path: '/rabbits',
            name: 'rabbits',
            builder: (context, state) => const RabbitsListScreen(),
          ),

          // Tasks
          GoRoute(
            path: '/tasks',
            name: 'tasks',
            builder: (context, state) => const TasksListScreen(),
          ),

          // More screen
          GoRoute(
            path: '/more',
            name: 'more',
            builder: (context, state) => const MoreScreen(),
          ),
        ],
      ),

      // Rabbit detail and form routes (outside shell)
      GoRoute(
        path: '/rabbits/new',
        name: 'rabbit-new',
        builder: (context, state) => const RabbitFormScreen(),
      ),
      GoRoute(
        path: '/rabbits/:id',
        name: 'rabbit-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return RabbitDetailScreen(rabbitId: id);
        },
      ),
      GoRoute(
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
        path: '/rabbits/:id/pedigree',
        name: 'rabbit-pedigree',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final name = state.uri.queryParameters['name'] ?? 'Кролик';
          return PedigreeScreen(
            rabbitId: id,
            rabbitName: name,
          );
        },
      ),

      // Breeds routes
      GoRoute(
        path: '/breeds',
        name: 'breeds',
        builder: (context, state) => const BreedsListScreen(),
      ),
      GoRoute(
        path: '/breeds/form',
        name: 'breed-form',
        builder: (context, state) {
          final breed = state.extra as BreedModel?;
          return BreedFormScreen(breed: breed);
        },
      ),

      // Breeding routes
      GoRoute(
        path: '/breeding/planner',
        name: 'breeding-planner',
        builder: (context, state) => const BreedingPlannerScreen(),
      ),
      GoRoute(
        path: '/breeding',
        name: 'breeding-list',
        builder: (context, state) => const BreedingListScreen(),
      ),
      GoRoute(
        path: '/breeding/new',
        name: 'breeding-new',
        builder: (context, state) {
          final initialData = state.extra as Map<String, dynamic>?;
          return BreedingFormScreen(initialData: initialData);
        },
      ),
      GoRoute(
        path: '/breeding/:id',
        name: 'breeding-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return BreedingDetailScreen(breedingId: id);
        },
      ),

      // Births routes
      GoRoute(
        path: '/births',
        name: 'births',
        builder: (context, state) => const BirthsListScreen(),
      ),
      GoRoute(
        path: '/births/new',
        name: 'birth-new',
        builder: (context, state) {
          final breeding = state.extra as BreedingModel?;
          return BirthFormScreen(breeding: breeding);
        },
      ),

      // Vaccinations routes
      GoRoute(
        path: '/vaccinations',
        name: 'vaccinations',
        builder: (context, state) => const VaccinationsListScreen(),
      ),
      GoRoute(
        path: '/vaccinations/form',
        name: 'vaccination-form',
        builder: (context, state) {
          final vaccination = state.extra as Vaccination?;
          return VaccinationFormScreen(vaccination: vaccination);
        },
      ),

      // Cages routes
      GoRoute(
        path: '/cages',
        name: 'cages',
        builder: (context, state) => const CagesListScreen(),
      ),
      GoRoute(
        path: '/cages/form',
        name: 'cage-form',
        builder: (context, state) {
          final cage = state.extra as CageModel?;
          return CageFormScreen(cage: cage);
        },
      ),
      GoRoute(
        path: '/cages/:id',
        name: 'cage-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CageDetailScreen(cageId: id);
        },
      ),

      // Medical Records routes
      GoRoute(
        path: '/medical-records',
        name: 'medical-records',
        builder: (context, state) => const MedicalRecordsListScreen(),
      ),
      GoRoute(
        path: '/medical-records/form',
        name: 'medical-record-form',
        builder: (context, state) {
          final medicalRecord = state.extra as MedicalRecord?;
          return MedicalRecordFormScreen(medicalRecord: medicalRecord);
        },
      ),

      // Feeds routes
      GoRoute(
        path: '/feeds',
        name: 'feeds',
        builder: (context, state) => const FeedsListScreen(),
      ),
      GoRoute(
        path: '/feeds/form',
        name: 'feed-form',
        builder: (context, state) {
          final feed = state.extra as Feed?;
          return FeedFormScreen(feed: feed);
        },
      ),

      // Feeding Records routes
      GoRoute(
        path: '/feeding-records',
        name: 'feeding-records',
        builder: (context, state) => const FeedingRecordsListScreen(),
      ),
      GoRoute(
        path: '/feeding-records/form',
        name: 'feeding-record-form',
        builder: (context, state) {
          final record = state.extra as FeedingRecord?;
          return FeedingRecordFormScreen(record: record);
        },
      ),

      // Transactions routes
      GoRoute(
        path: '/transactions',
        name: 'transactions',
        builder: (context, state) => const TransactionsListScreen(),
      ),
      GoRoute(
        path: '/transactions/form',
        name: 'transaction-form',
        builder: (context, state) {
          final transaction = state.extra as Transaction?;
          return TransactionFormScreen(transaction: transaction);
        },
      ),

      // Task form route (outside shell)
      GoRoute(
        path: '/tasks/form',
        name: 'task-form',
        builder: (context, state) {
          final task = state.extra as Task?;
          return TaskFormScreen(task: task);
        },
      ),

      // Dashboard settings
      GoRoute(
        path: '/dashboard/settings',
        name: 'dashboard-settings',
        builder: (context, state) => const DashboardSettingsScreen(),
      ),

      // Reports route (alias for dashboard)
      GoRoute(
        path: '/reports',
        name: 'reports',
        builder: (context, state) => const CustomizableDashboardScreen(),
      ),

      // Modern dashboard (без кастомизации)
      GoRoute(
        path: '/dashboard/modern',
        name: 'dashboard-modern',
        builder: (context, state) => const ModernDashboardScreen(),
      ),

      // Old dashboard (for reference)
      GoRoute(
        path: '/dashboard/old',
        name: 'dashboard-old',
        builder: (context, state) => const DashboardScreen(),
      ),

      // Photos and Notes routes (placeholder screens)
      GoRoute(
        path: '/photos',
        name: 'photos',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Фото - скоро будет доступно')),
        ),
      ),
      GoRoute(
        path: '/notes',
        name: 'notes',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Заметки - скоро будет доступно')),
        ),
      ),

      // Matings route (referenced in More screen)
      GoRoute(
        path: '/matings',
        name: 'matings',
        builder: (context, state) => const BreedingPlannerScreen(),
      ),
    ],
  );
});
