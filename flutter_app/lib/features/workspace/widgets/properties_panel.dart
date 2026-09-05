import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/models/image_model.dart';
import '../../../core/models/project_model.dart';
import '../../../core/repositories/image_repository.dart';
import '../../../core/utils/file_saver.dart';
import '../pages/workspace_page.dart';

final imageHistoryProvider = FutureProvider.family<PaginatedResponse<ImageHistoryModel>, String>((ref, imageId) async {
  return ref.watch(imageRepositoryProvider).getHistory(imageId);
});

// ─────────────────────────────────────────────
// Properties Panel — Tabbed view
// Overview | Metadata | C2PA | Compression | History | Export
// ─────────────────────────────────────────────
class PropertiesPanel extends ConsumerStatefulWidget {
  final ImageModel image;
  final String projectId;

  const PropertiesPanel({
    super.key,
    required this.image,
    required this.projectId,
  });

  @override
  ConsumerState<PropertiesPanel> createState() => _PropertiesPanelState();
}

class _PropertiesPanelState extends ConsumerState<PropertiesPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgDark,
      child: Column(
        children: [
          // Tab Bar
          Container(
            color: AppColors.bgDarkCard,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(fontSize: 11),
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textTertiaryDark,
              indicatorColor: AppColors.primary,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 2,
              dividerColor: AppColors.bgDarkBorder,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Metadata'),
                Tab(text: 'C2PA'),
                Tab(text: 'Compress'),
                Tab(text: 'History'),
                Tab(text: 'Export'),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _OverviewTab(image: widget.image),
                _MetadataTab(metadata: widget.image.metadata),
                _C2paTab(manifest: widget.image.c2paManifest, image: widget.image, projectId: widget.projectId),
                _CompressionTab(image: widget.image, projectId: widget.projectId),
                _HistoryTab(imageId: widget.image.id),
                _ExportTab(image: widget.image, projectId: widget.projectId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Overview Tab
// ─────────────────────────────────────────────
class _OverviewTab extends StatelessWidget {
  final ImageModel image;
  const _OverviewTab({required this.image});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _InfoRow('Filename', image.originalFilename),
        _InfoRow('Format', image.format?.toUpperCase() ?? 'Unknown'),
        _InfoRow('Size', _formatBytes(image.sizeBytes)),
        if (image.width != null && image.height != null)
          _InfoRow('Resolution', '${image.width} × ${image.height} px'),
        _InfoRow('Status', image.status),
        const Divider(color: AppColors.bgDarkBorder, height: 24),
        _SectionHeader('Metadata Flags'),
        _FlagRow('EXIF', image.hasExif),
        _FlagRow('IPTC', image.hasIptc),
        _FlagRow('XMP', image.hasXmp),
        _FlagRow('GPS', image.hasGps),
        _FlagRow('C2PA', image.hasC2pa, extra: image.c2paVerified == true ? 'Verified' : null),
      ],
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes} B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

// ─────────────────────────────────────────────
// Metadata Tab
// ─────────────────────────────────────────────
class _MetadataTab extends StatelessWidget {
  final ImageMetadataModel? metadata;
  const _MetadataTab({required this.metadata});

  @override
  Widget build(BuildContext context) {
    if (metadata == null) {
      return const _EmptyState(icon: Icons.info_outline, message: 'No metadata scanned yet');
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (metadata!.cameraModel != null || metadata!.cameraMake != null) ...[
          _SectionHeader('Camera'),
          if (metadata!.cameraMake != null) _InfoRow('Make', metadata!.cameraMake!),
          if (metadata!.cameraModel != null) _InfoRow('Model', metadata!.cameraModel!),
          if (metadata!.lensModel != null) _InfoRow('Lens', metadata!.lensModel!),
          const SizedBox(height: 8),
        ],
        if (metadata!.focalLength != null || metadata!.aperture != null) ...[
          _SectionHeader('Exposure'),
          if (metadata!.focalLength != null) _InfoRow('Focal Length', metadata!.focalLength!),
          if (metadata!.aperture != null) _InfoRow('Aperture', 'f/${metadata!.aperture}'),
          if (metadata!.shutterSpeed != null) _InfoRow('Shutter Speed', metadata!.shutterSpeed!),
          if (metadata!.iso != null) _InfoRow('ISO', metadata!.iso!),
          const SizedBox(height: 8),
        ],
        if (metadata!.latitude != null && metadata!.longitude != null) ...[
          _SectionHeader('GPS'),
          _InfoRow('Latitude', metadata!.latitude!.toStringAsFixed(6)),
          _InfoRow('Longitude', metadata!.longitude!.toStringAsFixed(6)),
          if (metadata!.altitude != null) _InfoRow('Altitude', '${metadata!.altitude!.toStringAsFixed(1)} m'),
          const SizedBox(height: 8),
        ],
        if (metadata!.software != null) ...[
          _SectionHeader('Software'),
          _InfoRow('Software', metadata!.software!),
        ],
        if (metadata!.capturedAt != null) ...[
          _SectionHeader('Dates'),
          _InfoRow('Captured', _formatDate(metadata!.capturedAt!)),
          if (metadata!.modifiedAt != null) _InfoRow('Modified', _formatDate(metadata!.modifiedAt!)),
        ],
      ],
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// ─────────────────────────────────────────────
// C2PA Tab
// ─────────────────────────────────────────────
class _C2paTab extends ConsumerWidget {
  final C2paManifestModel? manifest;
  final ImageModel image;
  final String projectId;

  const _C2paTab({
    required this.manifest,
    required this.image,
    required this.projectId,
  });

  void _showCreateC2paDialog(BuildContext context, WidgetRef ref) {
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
            onPressed: () async {
              Navigator.pop(context);
              final opts = {
                'creator': creatorC.text.isNotEmpty ? creatorC.text : null,
                'organization': orgC.text.isNotEmpty ? orgC.text : null,
                'generator': genC.text.isNotEmpty ? genC.text : null,
                'aiModel': modelC.text.isNotEmpty ? modelC.text : null,
                'prompt': promptC.text.isNotEmpty ? promptC.text : null,
              };

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );

              try {
                await ref.read(imageRepositoryProvider).createC2pa(image.id, opts);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Custom C2PA created successfully!'), backgroundColor: AppColors.success),
                  );
                  ref.invalidate(workspaceImagesProvider(projectId));
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.danger),
                  );
                }
              }
            },
            child: const Text('Create', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _dialogTextField(TextEditingController controller, String label, {int maxLines = 1}) {
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
    if (!image.hasC2pa || manifest == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified_outlined, size: 48, color: AppColors.textTertiaryDark),
            const SizedBox(height: 16),
            const Text(
              'No C2PA Found',
              style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'This image has no content credentials',
              style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _showCreateC2paDialog(context, ref),
              icon: const Icon(Icons.add_task, size: 14),
              label: const Text('Create Custom C2PA'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Status Badge
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: manifest!.isVerified == true
                ? AppColors.success.withOpacity(0.08)
                : AppColors.warning.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: manifest!.isVerified == true
                  ? AppColors.success.withOpacity(0.3)
                  : AppColors.warning.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                manifest!.isVerified == true ? Icons.verified_rounded : Icons.warning_amber_rounded,
                color: manifest!.isVerified == true ? AppColors.success : AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                manifest!.isVerified == true ? 'Verified C2PA' : 'Custom C2PA (Unverified)',
                style: TextStyle(
                  color: manifest!.isVerified == true ? AppColors.success : AppColors.warning,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (manifest!.creator != null) _InfoRow('Creator', manifest!.creator!),
        if (manifest!.organization != null) _InfoRow('Organization', manifest!.organization!),
        if (manifest!.generator != null) _InfoRow('Generator', manifest!.generator!),
        if (manifest!.aiModel != null) _InfoRow('AI Model', manifest!.aiModel!),
        if (manifest!.license != null) _InfoRow('License', manifest!.license!),
        if (manifest!.copyright != null) _InfoRow('Copyright', manifest!.copyright!),
        if (manifest!.timestamp != null) _InfoRow('Timestamp', manifest!.timestamp.toString()),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Compression Tab
// ─────────────────────────────────────────────
class _CompressionTab extends ConsumerStatefulWidget {
  final ImageModel image;
  final String projectId;
  const _CompressionTab({required this.image, required this.projectId});

  @override
  ConsumerState<_CompressionTab> createState() => _CompressionTabState();
}

class _CompressionTabState extends ConsumerState<_CompressionTab> {
  String _mode = 'balanced';
  double _quality = 75;

  Future<void> _applyCompression() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      await ref.read(imageRepositoryProvider).compress(
        widget.image.id,
        mode: _mode,
        quality: _mode == 'custom' ? _quality.round() : null,
      );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compression job queued successfully!'), backgroundColor: AppColors.success),
        );
        ref.invalidate(workspaceImagesProvider(widget.projectId));
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.danger),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _SectionHeader('Compression Mode'),
        const SizedBox(height: 8),
        ...['keep_original', 'high_quality', 'balanced', 'maximum', 'custom']
            .map((mode) => RadioListTile<String>(
                  title: Text(
                    mode.replaceAll('_', ' ').toUpperCase(),
                    style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 12),
                  ),
                  value: mode,
                  groupValue: _mode,
                  onChanged: (v) => setState(() => _mode = v!),
                  activeColor: AppColors.primary,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                )),
        if (_mode == 'custom') ...[
          const SizedBox(height: 12),
          _SectionHeader('Quality: ${_quality.round()}'),
          Slider(
            value: _quality,
            min: 1,
            max: 100,
            divisions: 99,
            activeColor: AppColors.primary,
            onChanged: (v) => setState(() => _quality = v),
          ),
        ],
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: _applyCompression,
          icon: const Icon(Icons.compress, size: 14),
          label: const Text('Apply Compression'),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// History Tab
// ─────────────────────────────────────────────
class _HistoryTab extends ConsumerWidget {
  final String imageId;
  const _HistoryTab({required this.imageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(imageHistoryProvider(imageId));

    return historyAsync.when(
      data: (response) {
        if (response.items.isEmpty) {
          return const _EmptyState(icon: Icons.history, message: 'No history yet');
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: response.items.length,
          itemBuilder: (context, index) {
            final item = response.items[index];
            return Card(
              color: AppColors.bgDarkCard,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(
                  item.action.replaceAll('_', ' '),
                  style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  item.description ?? '',
                  style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 11),
                ),
                trailing: Text(
                  _formatTime(item.createdAt),
                  style: const TextStyle(color: AppColors.textTertiaryDark, fontSize: 10),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
      error: (err, _) => _EmptyState(icon: Icons.error_outline, message: err.toString()),
    );
  }

  String _formatTime(DateTime dt) {
    final local = dt.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}

// ─────────────────────────────────────────────
// Export Tab
// ─────────────────────────────────────────────
class _ExportTab extends ConsumerStatefulWidget {
  final ImageModel image;
  final String projectId;
  const _ExportTab({required this.image, required this.projectId});

  @override
  ConsumerState<_ExportTab> createState() => _ExportTabState();
}

class _ExportTabState extends ConsumerState<_ExportTab> {
  String _format = 'jpeg';

  Future<void> _exportImage() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      final bytes = await ref.read(imageRepositoryProvider).exportSingleBytes(widget.image.id, _format);
      if (mounted) {
        Navigator.pop(context);
        final base = widget.image.originalFilename.split('.').first;
        await saveFileBytes(bytes, '${base}_exported.$_format');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File downloaded successfully!'), backgroundColor: AppColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e'), backgroundColor: AppColors.danger),
        );
      }
    }
  }

  Future<void> _exportZip() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    try {
      final bytes = await ref.read(imageRepositoryProvider).exportMultipleBytes([widget.image.id]);
      if (mounted) {
        Navigator.pop(context);
        final base = widget.image.originalFilename.split('.').first;
        await saveFileBytes(bytes, '${base}_export.zip');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ZIP downloaded successfully!'), backgroundColor: AppColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export ZIP failed: $e'), backgroundColor: AppColors.danger),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _SectionHeader('Export Format'),
        const SizedBox(height: 8),
        ...['jpeg', 'png', 'webp', 'tiff'].map((fmt) => RadioListTile<String>(
              title: Text(
                fmt.toUpperCase(),
                style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 12),
              ),
              value: fmt,
              groupValue: _format,
              onChanged: (v) => setState(() => _format = v!),
              activeColor: AppColors.primary,
              dense: true,
              contentPadding: EdgeInsets.zero,
            )),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: _exportImage,
          icon: const Icon(Icons.download, size: 14),
          label: const Text('Export Image'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _exportZip,
          icon: const Icon(Icons.folder_zip_outlined, size: 14),
          label: const Text('Export as ZIP'),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Shared widgets
// ─────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textTertiaryDark,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimaryDark,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FlagRow extends StatelessWidget {
  final String label;
  final bool value;
  final String? extra;
  const _FlagRow(this.label, this.value, {this.extra});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            value ? Icons.check_circle_outline : Icons.radio_button_unchecked,
            size: 14,
            color: value ? AppColors.success : AppColors.textTertiaryDark,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: value ? AppColors.textSecondaryDark : AppColors.textTertiaryDark,
              fontSize: 12,
            ),
          ),
          if (extra != null && value) ...[
            const SizedBox(width: 6),
            Text(extra!, style: const TextStyle(color: AppColors.success, fontSize: 10)),
          ],
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textTertiaryDark,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: AppColors.textTertiaryDark),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(color: AppColors.textTertiaryDark, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
