import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/repositories/image_repository.dart';
import '../../../core/utils/file_saver.dart';
import '../pages/workspace_page.dart';

// ─────────────────────────────────────────────
// Workspace Toolbar
// ─────────────────────────────────────────────
class WorkspaceToolbar extends ConsumerWidget {
  final String projectId;
  final VoidCallback onUploadTap;
  final int selectedCount;

  const WorkspaceToolbar({
    super.key,
    required this.projectId,
    required this.onUploadTap,
    required this.selectedCount,
  });

  Future<void> _executeAction(
    BuildContext context,
    WidgetRef ref,
    String actionName,
    Future<void> Function() action,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      await action();
      if (context.mounted) {
        Navigator.pop(context); // Dismiss loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$actionName completed successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        ref.invalidate(workspaceImagesProvider(projectId));
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Dismiss loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  void _showCompressDialog(BuildContext context, WidgetRef ref, List<String> targetIds) {
    if (targetIds.isEmpty) return;
    String mode = 'balanced';
    double quality = 75;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppColors.bgDarkCard,
          title: const Text('Compress Images', style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 14, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Compression Mode:', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 11)),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: mode,
                dropdownColor: AppColors.bgDarkCard,
                style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 12),
                items: ['keep_original', 'high_quality', 'balanced', 'maximum', 'custom'].map((m) {
                  return DropdownMenuItem(
                    value: m,
                    child: Text(m.replaceAll('_', ' ').toUpperCase()),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => mode = val);
                },
              ),
              if (mode == 'custom') ...[
                const SizedBox(height: 16),
                Text('Quality: ${quality.round()}%', style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 11)),
                Slider(
                  value: quality,
                  min: 1,
                  max: 100,
                  divisions: 99,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => quality = v),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _executeAction(
                  context,
                  ref,
                  'Compression',
                  () async {
                    if (targetIds.length > 1) {
                      await ref.read(imageRepositoryProvider).batchAction(
                        imageIds: targetIds,
                        action: 'compress',
                        options: {'mode': mode, 'quality': mode == 'custom' ? quality.round() : null},
                      );
                    } else {
                      await ref.read(imageRepositoryProvider).compress(
                        targetIds[0],
                        mode: mode,
                        quality: mode == 'custom' ? quality.round() : null,
                      );
                    }
                  },
                );
              },
              child: const Text('Apply', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  void _showResizeDialog(BuildContext context, WidgetRef ref, List<String> targetIds) {
    if (targetIds.isEmpty) return;
    final widthController = TextEditingController();
    final heightController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgDarkCard,
        title: const Text('Resize Images', style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 14, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: widthController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 12),
              decoration: const InputDecoration(
                labelText: 'Width (px)',
                labelStyle: TextStyle(color: AppColors.textTertiaryDark, fontSize: 11),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.bgDarkBorder)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 12),
              decoration: const InputDecoration(
                labelText: 'Height (px)',
                labelStyle: TextStyle(color: AppColors.textTertiaryDark, fontSize: 11),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.bgDarkBorder)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final w = int.tryParse(widthController.text);
              final h = int.tryParse(heightController.text);
              if (w == null && h == null) return;

              _executeAction(
                context,
                ref,
                'Resize',
                () async {
                  if (targetIds.length > 1) {
                    await ref.read(imageRepositoryProvider).batchAction(
                      imageIds: targetIds,
                      action: 'resize',
                      options: {'width': w, 'height': h},
                    );
                  } else {
                    await ref.read(imageRepositoryProvider).resize(targetIds[0], width: w, height: h);
                  }
                },
              );
            },
            child: const Text('Apply', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  void _showCreateC2paDialog(BuildContext context, WidgetRef ref, List<String> targetIds) {
    if (targetIds.isEmpty) return;
    final creatorC = TextEditingController();
    final orgC = TextEditingController();
    final genC = TextEditingController(text: 'Image Provenance Studio');
    final modelC = TextEditingController();
    final promptC = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgDarkCard,
        title: const Text('Create Custom C2PA', style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 14, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialogTextField(creatorC, 'Creator Name'),
              _dialogTextField(orgC, 'Organization'),
              _dialogTextField(genC, 'Generator / Tool'),
              _dialogTextField(modelC, 'AI Model Name'),
              _dialogTextField(promptC, 'Generative Prompt', maxLines: 2),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final opts = {
                'creator': creatorC.text.isNotEmpty ? creatorC.text : null,
                'organization': orgC.text.isNotEmpty ? orgC.text : null,
                'generator': genC.text.isNotEmpty ? genC.text : null,
                'aiModel': modelC.text.isNotEmpty ? modelC.text : null,
                'prompt': promptC.text.isNotEmpty ? promptC.text : null,
              };

              _executeAction(
                context,
                ref,
                'Create C2PA',
                () async {
                  if (targetIds.length > 1) {
                    await ref.read(imageRepositoryProvider).batchAction(
                      imageIds: targetIds,
                      action: 'create_c2pa',
                      options: opts,
                    );
                  } else {
                    await ref.read(imageRepositoryProvider).createC2pa(targetIds[0], opts);
                  }
                },
              );
            },
            child: const Text('Create', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context, WidgetRef ref, List<String> targetIds, String? filename) {
    if (targetIds.isEmpty) return;

    if (targetIds.length > 1) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.bgDarkCard,
          title: const Text('Export ZIP', style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 14, fontWeight: FontWeight.bold)),
          content: Text('Export ${targetIds.length} images bundled inside a ZIP archive?', style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _executeAction(
                  context,
                  ref,
                  'ZIP Export',
                  () async {
                    final bytes = await ref.read(imageRepositoryProvider).exportMultipleBytes(targetIds);
                    await saveFileBytes(bytes, 'export_${DateTime.now().millisecondsSinceEpoch}.zip');
                  },
                );
              },
              child: const Text('Download', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      );
    } else {
      String format = 'jpeg';
      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: AppColors.bgDarkCard,
            title: const Text('Export Image', style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 14, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Choose Output Format:', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 11)),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: format,
                  dropdownColor: AppColors.bgDarkCard,
                  style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 12),
                  items: ['jpeg', 'png', 'webp', 'tiff'].map((f) {
                    return DropdownMenuItem(
                      value: f,
                      child: Text(f.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => format = val);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _executeAction(
                    context,
                    ref,
                    'Image Export',
                    () async {
                      final bytes = await ref.read(imageRepositoryProvider).exportSingleBytes(targetIds[0], format);
                      final name = filename ?? 'image';
                      final base = name.split('.').first;
                      await saveFileBytes(bytes, '${base}_exported.$format');
                    },
                  );
                },
                child: const Text('Download', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
      );
    }
  }

  static Widget _dialogTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 12),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textTertiaryDark, fontSize: 11),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.bgDarkBorder)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspaceState = ref.watch(workspaceNotifierProvider(projectId));
    final selectedImage = workspaceState.selectedImage;
    final selectedImageIds = workspaceState.selectedImageIds.toList();

    final targetIds = selectedImageIds.isNotEmpty
        ? selectedImageIds
        : (selectedImage != null ? [selectedImage.id] : <String>[]);

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.bgDarkCard,
      child: Row(
        children: [
          // Upload
          _ToolButton(
            icon: Icons.upload_file_rounded,
            label: 'Upload',
            onTap: onUploadTap,
            primary: true,
          ),
          const SizedBox(width: 4),

          const VerticalDivider(width: 20, indent: 8, endIndent: 8, color: AppColors.bgDarkBorder),

          _ToolButton(
            icon: Icons.document_scanner_outlined,
            label: 'Scan',
            onTap: () {
              if (targetIds.isEmpty) return;
              _executeAction(context, ref, 'Re-scanning metadata', () async {
                for (final id in targetIds) {
                  await ref.read(imageRepositoryProvider).rescan(id);
                }
              });
            },
          ),
          _ToolButton(
            icon: Icons.compress_rounded,
            label: 'Compress',
            onTap: () => _showCompressDialog(context, ref, targetIds),
          ),
          _ToolButton(
            icon: Icons.open_with_rounded,
            label: 'Resize',
            onTap: () => _showResizeDialog(context, ref, targetIds),
          ),
          _ToolButton(
            icon: Icons.transform_rounded,
            label: 'Convert',
            onTap: () => _showExportDialog(context, ref, targetIds, selectedImage?.originalFilename),
          ),

          const VerticalDivider(width: 20, indent: 8, endIndent: 8, color: AppColors.bgDarkBorder),

          _ToolButton(
            icon: Icons.data_array_rounded,
            label: 'Remove EXIF',
            onTap: () {
              if (targetIds.isEmpty) return;
              _executeAction(context, ref, 'EXIF Removal', () async {
                if (targetIds.length > 1) {
                  await ref.read(imageRepositoryProvider).batchAction(imageIds: targetIds, action: 'remove_metadata');
                } else {
                  await ref.read(imageRepositoryProvider).removeMetadata(targetIds[0]);
                }
              });
            },
            danger: true,
          ),
          _ToolButton(
            icon: Icons.location_off_outlined,
            label: 'Remove GPS',
            onTap: () {
              if (targetIds.isEmpty) return;
              _executeAction(context, ref, 'GPS Removal', () async {
                if (targetIds.length > 1) {
                  await ref.read(imageRepositoryProvider).batchAction(imageIds: targetIds, action: 'remove_gps');
                } else {
                  await ref.read(imageRepositoryProvider).removeGps(targetIds[0]);
                }
              });
            },
            danger: true,
          ),
          _ToolButton(
            icon: Icons.verified_outlined,
            label: 'Remove C2PA',
            onTap: () {
              if (targetIds.isEmpty) return;
              _executeAction(context, ref, 'C2PA Removal', () async {
                if (targetIds.length > 1) {
                  await ref.read(imageRepositoryProvider).batchAction(imageIds: targetIds, action: 'remove_c2pa');
                } else {
                  await ref.read(imageRepositoryProvider).removeC2pa(targetIds[0]);
                }
              });
            },
            danger: true,
          ),
          _ToolButton(
            icon: Icons.add_task_rounded,
            label: 'Create C2PA',
            onTap: () => _showCreateC2paDialog(context, ref, targetIds),
            success: true,
          ),

          const VerticalDivider(width: 20, indent: 8, endIndent: 8, color: AppColors.bgDarkBorder),

          _ToolButton(
            icon: Icons.download_rounded,
            label: 'Export',
            onTap: () => _showExportDialog(context, ref, targetIds, selectedImage?.originalFilename),
          ),

          const Spacer(),

          if (selectedCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Text(
                '$selectedCount selected',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ToolButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool primary;
  final bool danger;
  final bool success;

  const _ToolButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.primary = false,
    this.danger = false,
    this.success = false,
  });

  @override
  State<_ToolButton> createState() => _ToolButtonState();
}

class _ToolButtonState extends State<_ToolButton> {
  bool _hovered = false;

  Color get _activeColor {
    if (widget.primary) return AppColors.primary;
    if (widget.danger) return AppColors.danger;
    if (widget.success) return AppColors.success;
    return AppColors.textSecondaryDark;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Tooltip(
        message: widget.label,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: _hovered ? _activeColor.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  size: 16,
                  color: _hovered ? _activeColor : AppColors.textTertiaryDark,
                ),
                if (widget.primary) ...[
                  const SizedBox(width: 6),
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 12,
                      color: _hovered ? _activeColor : AppColors.textTertiaryDark,
                      fontWeight: FontWeight.w500,
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
