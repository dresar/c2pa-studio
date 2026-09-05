import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/models/image_model.dart';

// ─────────────────────────────────────────────
// Image List Panel
// ─────────────────────────────────────────────
class ImageListPanel extends StatelessWidget {
  final List<ImageModel> images;
  final ImageModel? selectedImage;
  final Set<String> selectedIds;
  final void Function(ImageModel) onImageTap;
  final void Function(String) onToggleSelect;

  const ImageListPanel({
    super.key,
    required this.images,
    required this.selectedImage,
    required this.selectedIds,
    required this.onImageTap,
    required this.onToggleSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const Center(
        child: Text(
          'No images yet.\nUpload to start.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 13),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];
        final isSelected = selectedImage?.id == image.id;
        final isChecked = selectedIds.contains(image.id);

        return _ImageListItem(
          image: image,
          isSelected: isSelected,
          isChecked: isChecked,
          onTap: () => onImageTap(image),
          onToggleCheck: () => onToggleSelect(image.id),
        );
      },
    );
  }
}

class _ImageListItem extends StatefulWidget {
  final ImageModel image;
  final bool isSelected;
  final bool isChecked;
  final VoidCallback onTap;
  final VoidCallback onToggleCheck;

  const _ImageListItem({
    required this.image,
    required this.isSelected,
    required this.isChecked,
    required this.onTap,
    required this.onToggleCheck,
  });

  @override
  State<_ImageListItem> createState() => _ImageListItemState();
}

class _ImageListItemState extends State<_ImageListItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.primary.withOpacity(0.12)
                : _hovered
                    ? AppColors.bgDarkElevated
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.primary.withOpacity(0.4)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              // Checkbox (on hover or when in selection mode)
              if (_hovered || widget.isChecked)
                GestureDetector(
                  onTap: widget.onToggleCheck,
                  child: Container(
                    width: 18,
                    height: 18,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: widget.isChecked
                          ? AppColors.primary
                          : Colors.transparent,
                      border: Border.all(
                        color: widget.isChecked
                            ? AppColors.primary
                            : AppColors.bgDarkBorder,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: widget.isChecked
                        ? const Icon(Icons.check, size: 12, color: Colors.white)
                        : null,
                  ),
                )
              else
                const SizedBox(width: 26),

              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: widget.image.thumbnailUrl != null
                      ? CachedNetworkImage(
                          imageUrl: widget.image.thumbnailUrl!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Shimmer.fromColors(
                            baseColor: AppColors.bgDarkElevated,
                            highlightColor: AppColors.bgDarkCard,
                            child: Container(color: AppColors.bgDarkElevated),
                          ),
                          errorWidget: (_, __, ___) => const Icon(
                            Icons.image_not_supported_outlined,
                            size: 20,
                            color: AppColors.textTertiaryDark,
                          ),
                        )
                      : Container(
                          color: AppColors.bgDarkElevated,
                          child: const Icon(
                            Icons.image_outlined,
                            size: 22,
                            color: AppColors.textTertiaryDark,
                          ),
                        ),
                ),
              ),

              const SizedBox(width: 10),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.image.originalFilename,
                      style: const TextStyle(
                        color: AppColors.textPrimaryDark,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _StatusDot(hasC2pa: widget.image.hasC2pa, c2paVerified: widget.image.c2paVerified),
                        const SizedBox(width: 4),
                        _StatusDot(hasC2pa: widget.image.hasExif, c2paVerified: null, label: 'EXIF'),
                        const SizedBox(width: 6),
                        Text(
                          _formatBytes(widget.image.sizeBytes),
                          style: const TextStyle(
                            color: AppColors.textTertiaryDark,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Status indicator
              _buildStatus(widget.image.status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatus(String status) {
    final color = switch (status) {
      'READY' => AppColors.success,
      'SCANNING' || 'PROCESSING' => AppColors.warning,
      'ERROR' => AppColors.danger,
      _ => AppColors.textTertiaryDark,
    };

    if (status == 'SCANNING' || status == 'PROCESSING') {
      return SizedBox(
        width: 12,
        height: 12,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
          color: color,
        ),
      );
    }

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}

class _StatusDot extends StatelessWidget {
  final bool hasC2pa;
  final bool? c2paVerified;
  final String? label;

  const _StatusDot({required this.hasC2pa, required this.c2paVerified, this.label});

  @override
  Widget build(BuildContext context) {
    if (!hasC2pa) return const SizedBox.shrink();

    final color = c2paVerified == true
        ? AppColors.c2paVerified
        : c2paVerified == false
            ? AppColors.c2paInvalid
            : AppColors.c2paCustom;

    return Container(
      width: 16,
      height: 12,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: color.withOpacity(0.6), width: 0.5),
      ),
      child: Center(
        child: Text(
          label ?? 'C2',
          style: TextStyle(fontSize: 7, color: color, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
