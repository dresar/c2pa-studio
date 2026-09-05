import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';

// ─────────────────────────────────────────────
// Entry Point
// ─────────────────────────────────────────────
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: ImageProvenanceStudioApp(),
    ),
  );
}

// ─────────────────────────────────────────────
// App Root
// ─────────────────────────────────────────────
class ImageProvenanceStudioApp extends ConsumerWidget {
  const ImageProvenanceStudioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,

      // Router
      routerConfig: router,

      // Responsive framework
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 480, name: MOBILE),
          const Breakpoint(start: 481, end: 900, name: TABLET),
          const Breakpoint(start: 901, end: 1440, name: DESKTOP),
          const Breakpoint(start: 1441, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}
