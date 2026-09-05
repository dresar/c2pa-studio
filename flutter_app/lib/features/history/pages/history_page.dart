import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────
// History Page
// ─────────────────────────────────────────────
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.bgDark,
            title: Text(
              'History',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            actions: [
              // Filter button
              IconButton(
                icon: const Icon(Icons.filter_list, color: AppColors.textSecondaryDark),
                onPressed: () {},
              ),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _HistoryItem(
                  action: _mockActions[i % _mockActions.length],
                  time: DateTime.now().subtract(Duration(hours: i * 2)),
                  filename: 'image_${i + 1}.jpg',
                ),
                childCount: 0, // Will be filled by API
              ),
            ),
          ),

          const SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: AppColors.textTertiaryDark),
                  SizedBox(height: 16),
                  Text(
                    'No activity yet',
                    style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Upload and process images to see your history',
                    style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _mockActions = [
    'UPLOADED', 'METADATA_SCANNED', 'COMPRESSED', 'C2PA_CREATED', 'EXPORTED',
  ];
}

class _HistoryItem extends StatelessWidget {
  final String action;
  final DateTime time;
  final String filename;

  const _HistoryItem({
    required this.action,
    required this.time,
    required this.filename,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _getIconColor(action);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgDarkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.bgDarkBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.replaceAll('_', ' '),
                  style: const TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  filename,
                  style: const TextStyle(color: AppColors.textTertiaryDark, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            _formatTime(time),
            style: const TextStyle(color: AppColors.textTertiaryDark, fontSize: 11),
          ),
        ],
      ),
    );
  }

  (IconData, Color) _getIconColor(String action) {
    return switch (action) {
      'UPLOADED' => (Icons.upload_file, AppColors.primary),
      'METADATA_SCANNED' => (Icons.document_scanner, AppColors.info),
      'COMPRESSED' => (Icons.compress, AppColors.warning),
      'C2PA_CREATED' => (Icons.verified, AppColors.success),
      'EXPORTED' || 'DOWNLOADED' => (Icons.download, AppColors.success),
      'DELETED' => (Icons.delete_outline, AppColors.danger),
      _ => (Icons.history, AppColors.textTertiaryDark),
    };
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
