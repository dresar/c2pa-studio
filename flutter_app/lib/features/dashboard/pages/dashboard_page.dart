import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../core/models/project_model.dart';
import '../../../core/repositories/project_repository.dart';
import '../../auth/providers/auth_provider.dart';

// ─────────────────────────────────────────────
// Dashboard Page
// ─────────────────────────────────────────────
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );

    final projectsAsync = ref.watch(
      _recentProjectsProvider,
    );

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: CustomScrollView(
        slivers: [
          // Top Bar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppColors.bgDark,
            title: Text(
              'Dashboard',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
            ),
            actions: [
              _NotificationBell(),
              const SizedBox(width: 8),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Welcome
                _WelcomeBanner(
                  name: user?.displayName ?? user?.username ?? 'User',
                ),
                const SizedBox(height: 28),

                // Quick Actions
                _SectionTitle('Quick Actions'),
                const SizedBox(height: 12),
                _QuickActions(),
                const SizedBox(height: 28),

                // Stats Row
                _SectionTitle('Overview'),
                const SizedBox(height: 12),
                _StatsRow(),
                const SizedBox(height: 28),

                // Recent Projects
                Row(
                  children: [
                    Expanded(child: _SectionTitle('Recent Projects')),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.projects),
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                projectsAsync.when(
                  data: (projects) => _RecentProjectsGrid(projects: projects),
                  loading: () => const _LoadingSkeleton(),
                  error: (e, _) => _ErrorState(message: e.toString()),
                ),

                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Provider: Recent Projects
// ─────────────────────────────────────────────
final _recentProjectsProvider = FutureProvider<List<ProjectModel>>((ref) async {
  final repo = ref.watch(projectRepositoryProvider);
  final result = await repo.listProjects(limit: 6);
  return result.items;
});

// ─────────────────────────────────────────────
// Welcome Banner
// ─────────────────────────────────────────────
class _WelcomeBanner extends StatelessWidget {
  final String name;
  const _WelcomeBanner({required this.name});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting, $name 👋',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Ready to manage your image provenance?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.verified_rounded,
            size: 56,
            color: Colors.white24,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.05, end: 0);
  }
}

// ─────────────────────────────────────────────
// Quick Actions
// ─────────────────────────────────────────────
class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Icons.add_photo_alternate_rounded,
        label: 'New Project',
        color: AppColors.primary,
        onTap: () => context.go(AppRoutes.projects),
      ),
      _QuickAction(
        icon: Icons.folder_open_rounded,
        label: 'Open Project',
        color: AppColors.success,
        onTap: () => context.go(AppRoutes.projects),
      ),
      _QuickAction(
        icon: Icons.history_rounded,
        label: 'History',
        color: AppColors.warning,
        onTap: () => context.go(AppRoutes.history),
      ),
      _QuickAction(
        icon: Icons.settings_rounded,
        label: 'Settings',
        color: const Color(0xFF8B5CF6),
        onTap: () => context.go(AppRoutes.settings),
      ),
    ];

    return Row(
      children: actions.asMap().entries.map((entry) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: entry.key < actions.length - 1 ? 12 : 0,
            ),
            child: entry.value,
          ),
        );
      }).toList(),
    );
  }
}

class _QuickAction extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_QuickAction> createState() => _QuickActionState();
}

class _QuickActionState extends State<_QuickAction> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.color.withOpacity(0.12)
                : AppColors.bgDarkCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? widget.color.withOpacity(0.4)
                  : AppColors.bgDarkBorder,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: widget.color.withOpacity(0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 28, color: widget.color),
              const SizedBox(height: 10),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondaryDark,
                      fontWeight: FontWeight.w500,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Stats Row
// ─────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatCard(label: 'Projects', value: '—', icon: Icons.folder, color: AppColors.primary)),
        const SizedBox(width: 12),
        Expanded(child: _StatCard(label: 'Images', value: '—', icon: Icons.image, color: AppColors.success)),
        const SizedBox(width: 12),
        Expanded(child: _StatCard(label: 'C2PA Tagged', value: '—', icon: Icons.verified, color: AppColors.warning)),
        const SizedBox(width: 12),
        Expanded(child: _StatCard(label: 'Exports', value: '—', icon: Icons.download, color: const Color(0xFF8B5CF6))),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgDarkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.bgDarkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiaryDark,
                ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Recent Projects Grid
// ─────────────────────────────────────────────
class _RecentProjectsGrid extends StatelessWidget {
  final List<ProjectModel> projects;
  const _RecentProjectsGrid({required this.projects});

  @override
  Widget build(BuildContext context) {
    if (projects.isEmpty) {
      return _EmptyProjects();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 320,
        mainAxisExtent: 160,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return _ProjectCard(project: project)
            .animate(delay: Duration(milliseconds: index * 80))
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.05, end: 0);
      },
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final ProjectModel project;
  const _ProjectCard({required this.project});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go('/projects/${widget.project.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.bgDarkElevated : AppColors.bgDarkCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? AppColors.primary.withOpacity(0.3) : AppColors.bgDarkBorder,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.folder, color: AppColors.primary, size: 22),
                  ),
                  const Spacer(),
                  _StatusChip(status: widget.project.status),
                ],
              ),
              const Spacer(),
              Text(
                widget.project.name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${widget.project.totalImages} images',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiaryDark,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'ACTIVE' => AppColors.success,
      'ARCHIVED' => AppColors.textTertiaryDark,
      _ => AppColors.danger,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _EmptyProjects extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.bgDarkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.bgDarkBorder),
      ),
      child: Column(
        children: [
          const Icon(Icons.folder_open_outlined, size: 48, color: AppColors.textTertiaryDark),
          const SizedBox(height: 16),
          Text(
            'No projects yet',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.textSecondaryDark),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first project to get started',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textTertiaryDark),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => context.go(AppRoutes.projects),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Create Project'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.textSecondaryDark,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
    );
  }
}

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        3,
        (i) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 2 ? 12 : 0),
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.bgDarkCard,
                borderRadius: BorderRadius.circular(16),
              ),
            )
                .animate(onPlay: (c) => c.repeat())
                .shimmer(
                  duration: 1500.ms,
                  color: AppColors.bgDarkElevated,
                ),
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.danger.withOpacity(0.2)),
      ),
      child: Text(
        'Failed to load: $message',
        style: TextStyle(color: AppColors.danger),
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.notifications_outlined, color: AppColors.textSecondaryDark),
      onPressed: () {},
    );
  }
}
