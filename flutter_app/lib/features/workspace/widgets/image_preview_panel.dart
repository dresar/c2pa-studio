import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/models/image_model.dart';

// ─────────────────────────────────────────────
// Image Preview Panel — Zoom, Pan, Compare
// ─────────────────────────────────────────────
class ImagePreviewPanel extends StatefulWidget {
  final ImageModel image;
  const ImagePreviewPanel({super.key, required this.image});

  @override
  State<ImagePreviewPanel> createState() => _ImagePreviewPanelState();
}

class _ImagePreviewPanelState extends State<ImagePreviewPanel> {
  final TransformationController _controller = TransformationController();
  double _currentScale = 1.0;

  void _zoomIn() {
    final matrix = _controller.value.clone();
    matrix.scale(1.25);
    _controller.value = matrix;
  }

  void _zoomOut() {
    final matrix = _controller.value.clone();
    matrix.scale(0.8);
    _controller.value = matrix;
  }

  void _resetZoom() {
    _controller.value = Matrix4.identity();
  }

  String get _imageUrl =>
      widget.image.processedUrl ??
      widget.image.imagekitUrl ??
      '';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF07070A),
      child: Column(
        children: [
          // Preview Controls
          _PreviewControls(
            onZoomIn: _zoomIn,
            onZoomOut: _zoomOut,
            onFit: _resetZoom,
            filename: widget.image.originalFilename,
            resolution: widget.image.width != null && widget.image.height != null
                ? '${widget.image.width}×${widget.image.height}'
                : null,
          ),

          // Image viewer
          Expanded(
            child: _imageUrl.isEmpty
                ? const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 64,
                      color: AppColors.textTertiaryDark,
                    ),
                  )
                : InteractiveViewer(
                    transformationController: _controller,
                    minScale: 0.1,
                    maxScale: 8.0,
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: _imageUrl,
                        fit: BoxFit.contain,
                        placeholder: (_, __) => const CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 2,
                        ),
                        errorWidget: (_, __, ___) => const Icon(
                          Icons.broken_image_outlined,
                          size: 48,
                          color: AppColors.textTertiaryDark,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// ─────────────────────────────────────────────
// Preview Controls Bar
// ─────────────────────────────────────────────
class _PreviewControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onFit;
  final String filename;
  final String? resolution;

  const _PreviewControls({
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onFit,
    required this.filename,
    this.resolution,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: AppColors.bgDarkCard,
        border: Border(bottom: BorderSide(color: AppColors.bgDarkBorder)),
      ),
      child: Row(
        children: [
          Text(
            filename,
            style: const TextStyle(
              color: AppColors.textSecondaryDark,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          if (resolution != null) ...[
            const SizedBox(width: 10),
            Text(
              resolution!,
              style: const TextStyle(
                color: AppColors.textTertiaryDark,
                fontSize: 11,
              ),
            ),
          ],
          const Spacer(),
          IconButton(
            onPressed: onZoomOut,
            icon: const Icon(Icons.zoom_out, size: 18),
            color: AppColors.textTertiaryDark,
            style: IconButton.styleFrom(minimumSize: const Size(28, 28)),
          ),
          IconButton(
            onPressed: onFit,
            icon: const Icon(Icons.fit_screen, size: 18),
            color: AppColors.textTertiaryDark,
            style: IconButton.styleFrom(minimumSize: const Size(28, 28)),
          ),
          IconButton(
            onPressed: onZoomIn,
            icon: const Icon(Icons.zoom_in, size: 18),
            color: AppColors.textTertiaryDark,
            style: IconButton.styleFrom(minimumSize: const Size(28, 28)),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.fullscreen, size: 18),
            color: AppColors.textTertiaryDark,
            style: IconButton.styleFrom(minimumSize: const Size(28, 28)),
          ),
        ],
      ),
    );
  }
}
