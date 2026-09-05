import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../core/models/project_model.dart';
import '../../../core/repositories/project_repository.dart';

part 'projects_page.g.dart';

// ─────────────────────────────────────────────
// Projects Provider
// ─────────────────────────────────────────────
@riverpod
Future<PaginatedResponse<ProjectModel>> projectsList(
  ProjectsListRef ref, {
  String? search,
  String? status,
}) async {
  final repo = ref.watch(projectRepositoryProvider);
  return repo.listProjects(search: search, status: status);
}

// ─────────────────────────────────────────────
// Projects Page
// ─────────────────────────────────────────────
class ProjectsPage extends ConsumerStatefulWidget {
  const ProjectsPage({super.key});

  @override
  ConsumerState<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends ConsumerState<ProjectsPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isGridView = true;
  bool _showCreateDialog = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(
      projectsListProvider(search: _searchQuery.isEmpty ? null : _searchQuery),
    );

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Column(
        children: [
          // Top Bar
          _buildTopBar(context),
          const Divider(height: 1, color: AppColors.bgDarkBorder),

          // Content
          Expanded(
            child: projectsAsync.when(
              data: (response) => _buildContent(response),
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (e, _) => Center(
                child: Text(
                  'Failed to load projects: $e',
                  style: const TextStyle(color: AppColors.danger),
                ),
              ),
            ),
          ),
        ],
      ),

      // FAB to create project
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateProjectDialog(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New Project'),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Row(
        children: [
          Text(
            'Projects',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(width: 24),

          // Search
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textTertiaryDark),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 16, color: AppColors.textTertiaryDark),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),

          const SizedBox(width: 12),

          // View Toggle
          Container(
            decoration: BoxDecoration(
              color: AppColors.bgDarkCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.bgDarkBorder),
            ),
            child: Row(
              children: [
                _ViewToggleButton(
                  icon: Icons.grid_view_rounded,
                  active: _isGridView,
                  onTap: () => setState(() => _isGridView = true),
                ),
                _ViewToggleButton(
                  icon: Icons.view_list_rounded,
                  active: !_isGridView,
                  onTap: () => setState(() => _isGridView = false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(PaginatedResponse<ProjectModel> response) {
    if (response.items.isEmpty) {
      return _EmptyProjectsState(onCreateTap: () => _showCreateProjectDialog(context));
    }

    if (_isGridView) {
      return GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          mainAxisExtent: 180,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: response.items.length,
        itemBuilder: (context, i) => _ProjectCard(
          project: response.items[i],
          onTap: () => context.go('/projects/${response.items[i].id}'),
          onDelete: () => _confirmDelete(context, response.items[i]),
        ).animate(delay: Duration(milliseconds: i * 60))
          .fadeIn(duration: 350.ms)
          .slideY(begin: 0.05, end: 0),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: response.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) => _ProjectListTile(
        project: response.items[i],
        onTap: () => context.go('/projects/${response.items[i].id}'),
      ).animate(delay: Duration(milliseconds: i * 40))
        .fadeIn(duration: 350.ms),
    );
  }

  Future<void> _showCreateProjectDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => _CreateProjectDialog(
        onCreated: () => ref.invalidate(projectsListProvider),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, ProjectModel project) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgDarkElevated,
        title: const Text('Delete Project', style: TextStyle(color: AppColors.textPrimaryDark)),
        content: Text(
          'Are you sure you want to delete "${project.name}"? This cannot be undone.',
          style: const TextStyle(color: AppColors.textSecondaryDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(projectRepositoryProvider).deleteProject(project.id);
      ref.invalidate(projectsListProvider);
    }
  }
}

// ─────────────────────────────────────────────
// Project Card (Grid)
// ─────────────────────────────────────────────
class _ProjectCard extends StatefulWidget {
  final ProjectModel project;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ProjectCard({
    required this.project,
    required this.onTap,
    required this.onDelete,
  });

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
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.bgDarkElevated : AppColors.bgDarkCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? AppColors.primary.withOpacity(0.35)
                  : AppColors.bgDarkBorder,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.folder_rounded,
                        color: AppColors.primary, size: 24),
                  ),
                  const Spacer(),
                  if (_hovered)
                    IconButton(
                      onPressed: widget.onDelete,
                      icon: const Icon(Icons.delete_outline,
                          color: AppColors.danger, size: 18),
                      style: IconButton.styleFrom(
                        minimumSize: const Size(28, 28),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                widget.project.name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.image_outlined,
                      size: 12, color: AppColors.textTertiaryDark),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.project.totalImages} images',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textTertiaryDark,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Project List Tile
// ─────────────────────────────────────────────
class _ProjectListTile extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;

  const _ProjectListTile({required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgDarkCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.bgDarkBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.folder_rounded, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textPrimaryDark,
                        ),
                  ),
                  if (project.description != null && project.description!.isNotEmpty)
                    Text(
                      project.description!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiaryDark,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Text(
              '${project.totalImages} images',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textTertiaryDark,
                  ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.chevron_right, color: AppColors.textTertiaryDark, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Create Project Dialog
// ─────────────────────────────────────────────
class _CreateProjectDialog extends ConsumerStatefulWidget {
  final VoidCallback onCreated;
  const _CreateProjectDialog({required this.onCreated});

  @override
  ConsumerState<_CreateProjectDialog> createState() =>
      _CreateProjectDialogState();
}

class _CreateProjectDialogState extends ConsumerState<_CreateProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });

    try {
      await ref.read(projectRepositoryProvider).createProject(
            name: _nameController.text.trim(),
            description: _descController.text.trim().isEmpty
                ? null
                : _descController.text.trim(),
          );
      widget.onCreated();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.bgDarkElevated,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('New Project', style: TextStyle(color: AppColors.textPrimaryDark)),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                autofocus: true,
                style: const TextStyle(color: AppColors.textPrimaryDark),
                decoration: const InputDecoration(
                  labelText: 'Project Name',
                  hintText: 'e.g. My Photography 2026',
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                style: const TextStyle(color: AppColors.textPrimaryDark),
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  hintText: 'Brief description of this project',
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: AppColors.danger, fontSize: 12)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _create,
          child: _loading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Create'),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────
class _ViewToggleButton extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _ViewToggleButton({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: active ? AppColors.primary : AppColors.textTertiaryDark,
        ),
      ),
    );
  }
}

class _EmptyProjectsState extends StatelessWidget {
  final VoidCallback onCreateTap;
  const _EmptyProjectsState({required this.onCreateTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.folder_open_outlined, size: 72, color: AppColors.textTertiaryDark),
          const SizedBox(height: 20),
          Text(
            'No projects found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a project to start organizing your images',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textTertiaryDark,
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onCreateTap,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Create Project'),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }
}
