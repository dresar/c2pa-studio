import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/pages/splash_page.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/register_page.dart';
import '../../features/auth/pages/forgot_password_page.dart';
import '../../features/dashboard/pages/dashboard_page.dart';
import '../../features/projects/pages/projects_page.dart';
import '../../features/projects/pages/project_detail_page.dart';
import '../../features/workspace/pages/workspace_page.dart';
import '../../features/history/pages/history_page.dart';
import '../../features/settings/pages/settings_page.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../widgets/shell/main_shell.dart';
import '../../features/templates/pages/templates_page.dart';
import '../../features/certificates/pages/certificates_page.dart';
import '../../features/profile/pages/profile_page.dart';

part 'app_router.g.dart';

// ─────────────────────────────────────────────
// Route Names
// ─────────────────────────────────────────────
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String projects = '/projects';
  static const String projectDetail = '/projects/:id';
  static const String workspace = '/workspace/:projectId';
  static const String history = '/history';
  static const String templates = '/templates';
  static const String certificates = '/certificates';
  static const String settings = '/settings';
  static const String profile = '/profile';
}

// ─────────────────────────────────────────────
// Router Provider
// ─────────────────────────────────────────────
@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isAuthenticated = authState.maybeWhen(
        authenticated: (_) => true,
        orElse: () => false,
      );

      final isLoading = authState.maybeWhen(
        loading: () => true,
        orElse: () => false,
      );

      if (isLoading) return AppRoutes.splash;

      final publicRoutes = [
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.forgotPassword,
        AppRoutes.splash,
      ];

      final isPublicRoute = publicRoutes.any((r) => state.matchedLocation == r);

      if (!isAuthenticated && !isPublicRoute) {
        return AppRoutes.login;
      }

      if (isAuthenticated && isPublicRoute && state.matchedLocation != AppRoutes.splash) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      // Public routes
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => _buildFadePage(state, const SplashPage()),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => _buildFadePage(state, const LoginPage()),
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (context, state) => _buildFadePage(state, const RegisterPage()),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        pageBuilder: (context, state) =>
            _buildFadePage(state, const ForgotPasswordPage()),
      ),

      // Authenticated shell with sidebar
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            pageBuilder: (context, state) =>
                _buildFadePage(state, const DashboardPage()),
          ),
          GoRoute(
            path: AppRoutes.projects,
            pageBuilder: (context, state) =>
                _buildFadePage(state, const ProjectsPage()),
          ),
          GoRoute(
            path: AppRoutes.projectDetail,
            pageBuilder: (context, state) => _buildFadePage(
              state,
              ProjectDetailPage(projectId: state.pathParameters['id']!),
            ),
          ),
          GoRoute(
            path: AppRoutes.workspace,
            pageBuilder: (context, state) => _buildFadePage(
              state,
              WorkspacePage(projectId: state.pathParameters['projectId']!),
            ),
          ),
          GoRoute(
            path: AppRoutes.history,
            pageBuilder: (context, state) =>
                _buildFadePage(state, const HistoryPage()),
          ),
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (context, state) =>
                _buildFadePage(state, const SettingsPage()),
          ),
          GoRoute(
            path: AppRoutes.templates,
            pageBuilder: (context, state) =>
                _buildFadePage(state, const TemplatesPage()),
          ),
          GoRoute(
            path: AppRoutes.certificates,
            pageBuilder: (context, state) =>
                _buildFadePage(state, const CertificatesPage()),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) =>
                _buildFadePage(state, const ProfilePage()),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => _ErrorPage(error: state.error),
  );
}

// ─────────────────────────────────────────────
// Page transition builder helper
// ─────────────────────────────────────────────
CustomTransitionPage<void> _buildFadePage(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}

// ─────────────────────────────────────────────
// Error Page
// ─────────────────────────────────────────────
class _ErrorPage extends StatelessWidget {
  final Exception? error;
  const _ErrorPage({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(error.toString()),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.dashboard),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
