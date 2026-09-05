import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../features/auth/providers/auth_provider.dart';

// ─────────────────────────────────────────────
// Main Shell — Sidebar + Content
// ─────────────────────────────────────────────
class MainShell extends ConsumerStatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  bool _sidebarExpanded = true;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    if (isMobile) {
      return _MobileShell(child: widget.child);
    }

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Row(
        children: [
          // Sidebar
          _AppSidebar(
            expanded: _sidebarExpanded,
            onToggle: () =>
                setState(() => _sidebarExpanded = !_sidebarExpanded),
          ),

          // Divider
          VerticalDivider(
            width: 1,
            color: AppColors.bgDarkBorder,
          ),

          // Main Content
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// App Sidebar
// ─────────────────────────────────────────────
class _AppSidebar extends ConsumerWidget {
  final bool expanded;
  final VoidCallback onToggle;

  const _AppSidebar({required this.expanded, required this.onToggle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = expanded
        ? AppConstants.sidebarWidthExpanded
        : AppConstants.sidebarWidthCollapsed;

    return AnimatedContainer(
      duration: AppConstants.animMedium,
      curve: Curves.easeInOut,
      width: width,
      color: AppColors.bgDark,
      child: Column(
        children: [
          // Logo + Toggle
          _buildHeader(context),
          const Divider(height: 1, color: AppColors.bgDarkBorder),

          // Navigation
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: _navItems.map((item) {
                  return _NavItem(
                    item: item,
                    expanded: expanded,
                    currentLocation: GoRouterState.of(context).matchedLocation,
                  );
                }).toList(),
              ),
            ),
          ),

          const Divider(height: 1, color: AppColors.bgDarkBorder),

          // Profile + Logout
          _buildFooter(context, ref),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // App Icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(Icons.verified_rounded, size: 20, color: Colors.white),
          ),

          if (expanded) ...[
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'IPS',
                style: const TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  letterSpacing: 0.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],

          const Spacer(),

          // Collapse toggle
          IconButton(
            onPressed: onToggle,
            icon: Icon(
              expanded ? Icons.chevron_left : Icons.chevron_right,
              color: AppColors.textTertiaryDark,
              size: 20,
            ),
            style: IconButton.styleFrom(
              minimumSize: const Size(32, 32),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );

    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Profile
          InkWell(
            onTap: () => context.go(AppRoutes.profile),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      (user?.displayName ?? user?.username ?? 'U')
                          .substring(0, 1)
                          .toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (expanded) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.displayName ?? user?.username ?? 'User',
                            style: const TextStyle(
                              color: AppColors.textPrimaryDark,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            user?.email ?? '',
                            style: const TextStyle(
                              color: AppColors.textTertiaryDark,
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Logout
          InkWell(
            onTap: () async {
              await ref.read(authNotifierProvider.notifier).logout();
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const Icon(Icons.logout, color: AppColors.danger, size: 18),
                  if (expanded) ...[
                    const SizedBox(width: 10),
                    const Text(
                      'Sign Out',
                      style: TextStyle(
                        color: AppColors.danger,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _navItems = [
    _NavItemData(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      route: AppRoutes.dashboard,
    ),
    _NavItemData(
      label: 'Projects',
      icon: Icons.folder_outlined,
      activeIcon: Icons.folder,
      route: AppRoutes.projects,
    ),
    _NavItemData(
      label: 'History',
      icon: Icons.history_outlined,
      activeIcon: Icons.history,
      route: AppRoutes.history,
    ),
    _NavItemData(
      label: 'Templates',
      icon: Icons.description_outlined,
      activeIcon: Icons.description,
      route: AppRoutes.templates,
    ),
    _NavItemData(
      label: 'Certificates',
      icon: Icons.admin_panel_settings_outlined,
      activeIcon: Icons.admin_panel_settings,
      route: AppRoutes.certificates,
    ),
    _NavItemData(
      label: 'Settings',
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      route: AppRoutes.settings,
    ),
  ];
}

// ─────────────────────────────────────────────
// Nav Item
// ─────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final _NavItemData item;
  final bool expanded;
  final String currentLocation;

  const _NavItem({
    required this.item,
    required this.expanded,
    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentLocation.startsWith(item.route);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Tooltip(
        message: expanded ? '' : item.label,
        preferBelow: false,
        child: InkWell(
          onTap: () => context.go(item.route),
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary.withOpacity(0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  isActive ? item.activeIcon : item.icon,
                  size: 20,
                  color: isActive
                      ? AppColors.primary
                      : AppColors.textTertiaryDark,
                ),
                if (expanded) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive
                            ? AppColors.primary
                            : AppColors.textSecondaryDark,
                      ),
                    ),
                  ),
                  if (isActive)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;

  const _NavItemData({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
}

// ─────────────────────────────────────────────
// Mobile Shell with Bottom Navigation
// ─────────────────────────────────────────────
class _MobileShell extends StatelessWidget {
  final Widget child;
  const _MobileShell({required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    int selectedIndex = 0;
    if (location.startsWith(AppRoutes.projects)) selectedIndex = 1;
    if (location.startsWith(AppRoutes.history)) selectedIndex = 2;
    if (location.startsWith(AppRoutes.settings)) selectedIndex = 3;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        backgroundColor: AppColors.bgDarkCard,
        indicatorColor: AppColors.primary.withOpacity(0.15),
        onDestinationSelected: (index) {
          switch (index) {
            case 0: context.go(AppRoutes.dashboard); break;
            case 1: context.go(AppRoutes.projects); break;
            case 2: context.go(AppRoutes.history); break;
            case 3: context.go(AppRoutes.settings); break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder),
            label: 'Projects',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
