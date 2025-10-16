import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/rabbits/presentation/screens/rabbits_list_screen.dart';
import '../../features/rabbits/presentation/screens/rabbit_form_screen.dart';
import '../../features/rabbits/presentation/screens/rabbit_detail_screen.dart';
import '../../features/rabbits/data/models/rabbit_model.dart';

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
        return '/';
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

      // Main app routes
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const RabbitsListScreen(),
      ),

      // Rabbits routes
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
    ],
  );
});
