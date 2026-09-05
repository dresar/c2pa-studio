import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:desktop_drop/desktop_drop.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/models/image_model.dart';
import '../../../core/models/project_model.dart';
import '../../../core/repositories/image_repository.dart';
import '../../../core/repositories/project_repository.dart';
import '../widgets/image_list_panel.dart';
import '../widgets/image_preview_panel.dart';
import '../widgets/properties_panel.dart';
import '../widgets/toolbar.dart';

part 'workspace_page.g.dart';

// ─────────────────────────────────────────────
// Workspace State
// ─────────────────────────────────────────────
@riverpod
class WorkspaceNotifier extends _$WorkspaceNotifier {
  @override
  WorkspaceState build(String projectId) {
    return const WorkspaceState();
  }

  void selectImage(ImageModel? image) {
    state = state.copyWith(selectedImage: image);
  }

  void toggleImageSelection(String imageId) {
    final selected = Set<String>.from(state.selectedImageIds);
    if (selected.contains(imageId)) {
      selected.remove(imageId);
    } else {
      selected.add(imageId);
    }
    state = state.copyWith(selectedImageIds: selected);
  }

  void clearSelection() {
    state = state.copyWith(selectedImageIds: {});
  }

  void selectAll(List<String> ids) {
    state = state.copyWith(selectedImageIds: Set<String>.from(ids));
  }
}

class WorkspaceState {
  final ImageModel? selectedImage;
  final Set<String> selectedImageIds;
  final bool isUploading;
  final double uploadProgress;

  const WorkspaceState({
    this.selectedImage,
    this.selectedImageIds = const {},
    this.isUploading = false,
    this.uploadProgress = 0,
  });

  WorkspaceState copyWith({
    ImageModel? selectedImage,
    Set<String>? selectedImageIds,
    bool? isUploading,
    double? uploadProgress,
  }) {
    return WorkspaceState(
      selectedImage: selectedImage ?? this.selectedImage,
      selectedImageIds: selectedImageIds ?? this.selectedImageIds,
      isUploading: isUploading ?? this.isUploading,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }
}

// ─────────────────────────────────────────────
// Images Provider
// ─────────────────────────────────────────────
@riverpod
Future<PaginatedResponse<ImageModel>> workspaceImages(
  WorkspaceImagesRef ref,
  String projectId,
) async {
  final repo = ref.watch(imageRepositoryProvider);
  return repo.listImages(projectId: projectId);
}

// ─────────────────────────────────────────────
// Workspace Page — The Main Editor
// ─────────────────────────────────────────────
class WorkspacePage extends ConsumerStatefulWidget {
  final String projectId;
  const WorkspacePage({super.key, required this.projectId});

  @override
  ConsumerState<WorkspacePage> createState() => _WorkspacePageState();
}

class _WorkspacePageState extends ConsumerState<WorkspacePage> {
  bool _isDragOver = false;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      final imagesAsync = ref.read(workspaceImagesProvider(widget.projectId));
      imagesAsync.whenData((response) {
        final hasPending = response.items.any((img) =>
            img.status == 'PENDING' ||
            img.status == 'SCANNING' ||
            img.status == 'PROCESSING');
        if (hasPending) {
          ref.invalidate(workspaceImagesProvider(widget.projectId));
        }
      });
    });
  }

  Future<void> _uploadFiles(List<String> paths) async {
    if (paths.isEmpty) return;

    final notifier = ref.read(workspaceNotifierProvider(widget.projectId).notifier);
    try {
      await ref.read(imageRepositoryProvider).uploadImages(
        projectId: widget.projectId,
        filePaths: paths,
      );
      ref.invalidate(workspaceImagesProvider(widget.projectId));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result != null) {
      final paths = result.files
          .where((f) => f.path != null)
          .map((f) => f.path!)
          .toList();
      await _uploadFiles(paths);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagesAsync = ref.watch(workspaceImagesProvider(widget.projectId));
    final workspaceState = ref.watch(workspaceNotifierProvider(widget.projectId));

    return DropTarget(
      onDragDone: (details) {
        setState(() => _isDragOver = false);
        final paths = details.files.map((f) => f.path).toList();
        _uploadFiles(paths);
      },
      onDragEntered: (_) => setState(() => _isDragOver = true),
      onDragExited: (_) => setState(() => _isDragOver = false),
      child: Scaffold(
        backgroundColor: AppColors.bgDark,
        body: Stack(
          children: [
            Column(
              children: [
                // Toolbar
                WorkspaceToolbar(
                  projectId: widget.projectId,
                  onUploadTap: _pickFiles,
                  selectedCount: workspaceState.selectedImageIds.length,
                ),
                const Divider(height: 1, color: AppColors.bgDarkBorder),

                // Main workspace layout
                Expanded(
                  child: Row(
                    children: [
                      // Image List Panel
                      SizedBox(
                        width: 280,
                        child: imagesAsync.when(
                          data: (response) => ImageListPanel(
                            images: response.items,
                            selectedImage: workspaceState.selectedImage,
                            selectedIds: workspaceState.selectedImageIds,
                            onImageTap: (img) => ref
                                .read(workspaceNotifierProvider(widget.projectId).notifier)
                                .selectImage(img),
                            onToggleSelect: (id) => ref
                                .read(workspaceNotifierProvider(widget.projectId).notifier)
                                .toggleImageSelection(id),
                          ),
                          loading: () => const _LoadingPanel(),
                          error: (e, _) => _ErrorPanel(message: e.toString()),
                        ),
                      ),
                      const VerticalDivider(width: 1, color: AppColors.bgDarkBorder),

                      // Preview Panel
                      Expanded(
                        child: workspaceState.selectedImage != null
                            ? ImagePreviewPanel(image: workspaceState.selectedImage!)
                            : _DropZoneHint(onUploadTap: _pickFiles),
                      ),

                      const VerticalDivider(width: 1, color: AppColors.bgDarkBorder),

                      // Properties Panel
                      SizedBox(
                        width: 320,
                        child: workspaceState.selectedImage != null
                            ? PropertiesPanel(
                                image: workspaceState.selectedImage!,
                                projectId: widget.projectId,
                              )
                            : const _EmptyPropertiesHint(),
                      ),
                    ],
                  ),
                ),

                // Status Bar
                _StatusBar(
                  imageCount: imagesAsync.maybeWhen(
                    data: (r) => r.total,
                    orElse: () => 0,
                  ),
                  selectedCount: workspaceState.selectedImageIds.length,
                ),
              ],
            ),

            // Drag overlay
            if (_isDragOver)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.upload_file_rounded,
                          size: 64,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Drop images here',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 150.ms),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Drop Zone Hint
// ─────────────────────────────────────────────
class _DropZoneHint extends StatelessWidget {
  final VoidCallback onUploadTap;
  const _DropZoneHint({required this.onUploadTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                style: BorderStyle.solid,
              ),
            ),
            child: const Icon(
              Icons.cloud_upload_outlined,
              size: 36,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Drop images here',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'or',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textTertiaryDark,
                ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onUploadTap,
            icon: const Icon(Icons.upload_file, size: 16),
            label: const Text('Browse Files'),
          ),
          const SizedBox(height: 16),
          Text(
            'JPEG, PNG, WEBP, TIFF — up to 50 MB',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiaryDark,
                ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }
}

class _EmptyPropertiesHint extends StatelessWidget {
  const _EmptyPropertiesHint();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Select an image\nto view properties',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textTertiaryDark,
            ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  final int imageCount;
  final int selectedCount;
  const _StatusBar({required this.imageCount, required this.selectedCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.bgDarkCard,
        border: Border(top: BorderSide(color: AppColors.bgDarkBorder)),
      ),
      child: Row(
        children: [
          Text(
            '$imageCount images',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textTertiaryDark,
                ),
          ),
          if (selectedCount > 0) ...[
            const SizedBox(width: 16),
            Text(
              '$selectedCount selected',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
          const Spacer(),
          Text(
            'Image Provenance Studio',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textTertiaryDark,
                ),
          ),
        ],
      ),
    );
  }
}

class _LoadingPanel extends StatelessWidget {
  const _LoadingPanel();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  final String message;
  const _ErrorPanel({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message,
          style: const TextStyle(color: AppColors.danger, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
