import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';

// ─────────────────────────────────────────────
// Project Detail Page — redirects to Workspace
// ─────────────────────────────────────────────
class ProjectDetailPage extends StatelessWidget {
  final String projectId;
  const ProjectDetailPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    // Redirect to workspace
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/workspace/$projectId');
    });

    return const Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}
