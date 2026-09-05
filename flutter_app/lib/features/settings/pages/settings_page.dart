import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/providers/auth_provider.dart';

// ─────────────────────────────────────────────
// Settings Page
// ─────────────────────────────────────────────
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _apiUrlController = TextEditingController();
  bool _darkMode = true;
  bool _autoScan = true;
  bool _autoSave = true;
  String _compressionDefault = 'balanced';
  String _exportFormat = 'jpeg';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _apiUrlController.text =
          prefs.getString(AppConstants.keyApiUrl) ?? AppConstants.defaultApiUrl;
    });
  }

  Future<void> _saveApiUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyApiUrl, _apiUrlController.text.trim());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API URL saved. Restart the app to apply.')),
      );
    }
  }

  @override
  void dispose() {
    _apiUrlController.dispose();
    super.dispose();
  }

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
              'Settings',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ─── Appearance ──────────────────
                _SettingsSection(
                  title: 'Appearance',
                  children: [
                    _SwitchTile(
                      label: 'Dark Mode',
                      subtitle: 'Use dark theme (default)',
                      value: _darkMode,
                      onChanged: (v) => setState(() => _darkMode = v),
                    ),
                  ],
                ),

                // ─── Connection ───────────────────
                _SettingsSection(
                  title: 'Connection',
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'API URL',
                            style: TextStyle(
                              color: AppColors.textSecondaryDark,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _apiUrlController,
                                  style: const TextStyle(
                                    color: AppColors.textPrimaryDark,
                                    fontSize: 13,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'http://localhost:3000/api/v1',
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _saveApiUrl,
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12)),
                                child: const Text('Save'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // ─── Processing ───────────────────
                _SettingsSection(
                  title: 'Processing',
                  children: [
                    _SwitchTile(
                      label: 'Auto Scan',
                      subtitle: 'Automatically scan metadata after upload',
                      value: _autoScan,
                      onChanged: (v) => setState(() => _autoScan = v),
                    ),
                    _SwitchTile(
                      label: 'Auto Save',
                      subtitle: 'Save project changes automatically',
                      value: _autoSave,
                      onChanged: (v) => setState(() => _autoSave = v),
                    ),
                  ],
                ),

                // ─── Defaults ─────────────────────
                _SettingsSection(
                  title: 'Defaults',
                  children: [
                    _DropdownTile(
                      label: 'Compression Default',
                      value: _compressionDefault,
                      options: {
                        'keep_original': 'Keep Original',
                        'high_quality': 'High Quality',
                        'balanced': 'Balanced',
                        'maximum': 'Maximum',
                      },
                      onChanged: (v) => setState(() => _compressionDefault = v!),
                    ),
                    _DropdownTile(
                      label: 'Export Format',
                      value: _exportFormat,
                      options: {
                        'jpeg': 'JPEG',
                        'png': 'PNG',
                        'webp': 'WebP',
                        'tiff': 'TIFF',
                      },
                      onChanged: (v) => setState(() => _exportFormat = v!),
                    ),
                  ],
                ),

                // ─── Account ──────────────────────
                _SettingsSection(
                  title: 'Account',
                  children: [
                    ListTile(
                      leading: const Icon(Icons.logout, color: AppColors.danger),
                      title: const Text(
                        'Sign Out',
                        style: TextStyle(color: AppColors.danger, fontSize: 13),
                      ),
                      onTap: () async {
                        await ref.read(authNotifierProvider.notifier).logout();
                      },
                    ),
                  ],
                ),

                // ─── About ────────────────────────
                _SettingsSection(
                  title: 'About',
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstants.appName,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppColors.textPrimaryDark,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Version ${AppConstants.appVersion}',
                            style: const TextStyle(
                              color: AppColors.textTertiaryDark,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppConstants.appDescription,
                            style: const TextStyle(
                              color: AppColors.textTertiaryDark,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
// Widgets
// ─────────────────────────────────────────────
class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: AppColors.textTertiaryDark,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgDarkCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.bgDarkBorder),
          ),
          child: Column(children: children),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        label,
        style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 13, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.textTertiaryDark, fontSize: 11),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
    );
  }
}

class _DropdownTile extends StatelessWidget {
  final String label;
  final String value;
  final Map<String, String> options;
  final ValueChanged<String?> onChanged;

  const _DropdownTile({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimaryDark,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          DropdownButton<String>(
            value: value,
            dropdownColor: AppColors.bgDarkElevated,
            style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 13),
            underline: const SizedBox(),
            onChanged: onChanged,
            items: options.entries
                .map((e) => DropdownMenuItem<String>(
                      value: e.key,
                      child: Text(e.value),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
