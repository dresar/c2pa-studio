import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/models/image_model.dart';
import '../../../core/repositories/template_repository.dart';

// ─────────────────────────────────────────────
// Templates List Provider
// ─────────────────────────────────────────────
final templatesListProvider = FutureProvider.autoDispose<List<C2paTemplateModel>>((ref) async {
  return ref.watch(templateRepositoryProvider).listTemplates();
});

// ─────────────────────────────────────────────
// Templates Page
// ─────────────────────────────────────────────
class TemplatesPage extends ConsumerStatefulWidget {
  const TemplatesPage({super.key});

  @override
  ConsumerState<TemplatesPage> createState() => _TemplatesPageState();
}

class _TemplatesPageState extends ConsumerState<TemplatesPage> {
  Future<void> _deleteTemplate(C2paTemplateModel template) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgDarkCard,
        title: const Text('Delete Template', style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 14, fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete template "${template.name}"?', style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Delete', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );

      try {
        await ref.read(templateRepositoryProvider).deleteTemplate(template.id);
        if (mounted) {
          Navigator.pop(context); // Dismiss loading
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Template deleted successfully'), backgroundColor: AppColors.success),
          );
          ref.invalidate(templatesListProvider);
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete: $e'), backgroundColor: AppColors.danger),
          );
        }
      }
    }
  }

  void _showCreateDialog() {
    final nameC = TextEditingController();
    final creatorC = TextEditingController();
    final orgC = TextEditingController();
    final webC = TextEditingController();
    final licC = TextEditingController();
    final copyC = TextEditingController();
    final genC = TextEditingController(text: 'Image Provenance Studio');
    final modelC = TextEditingController();
    final workC = TextEditingController();
    final srcC = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgDarkCard,
        title: const Text('Create New Template', style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 14, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _formField(nameC, 'Template Name (Required)'),
              _formField(creatorC, 'Creator Name'),
              _formField(orgC, 'Organization'),
              _formField(webC, 'Website URL'),
              _formField(licC, 'License Type'),
              _formField(copyC, 'Copyright Holder'),
              _formField(genC, 'Generator / Tool'),
              _formField(modelC, 'AI Model'),
              _formField(workC, 'AI Workflow'),
              _formField(srcC, 'Original Source'),
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
              if (nameC.text.trim().isEmpty) return;
              Navigator.pop(context);

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              );

              try {
                final data = {
                  'name': nameC.text.trim(),
                  'creator': creatorC.text.isNotEmpty ? creatorC.text.trim() : null,
                  'organization': orgC.text.isNotEmpty ? orgC.text.trim() : null,
                  'website': webC.text.isNotEmpty ? webC.text.trim() : null,
                  'license': licC.text.isNotEmpty ? licC.text.trim() : null,
                  'copyright': copyC.text.isNotEmpty ? copyC.text.trim() : null,
                  'generator': genC.text.isNotEmpty ? genC.text.trim() : null,
                  'aiModel': modelC.text.isNotEmpty ? modelC.text.trim() : null,
                  'workflow': workC.text.isNotEmpty ? workC.text.trim() : null,
                  'source': srcC.text.isNotEmpty ? srcC.text.trim() : null,
                };

                await ref.read(templateRepositoryProvider).createTemplate(data);
                if (mounted) {
                  Navigator.pop(context); // Dismiss loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Template created successfully'), backgroundColor: AppColors.success),
                  );
                  ref.invalidate(templatesListProvider);
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Creation failed: $e'), backgroundColor: AppColors.danger),
                  );
                }
              }
            },
            child: const Text('Save', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _formField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
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
  Widget build(BuildContext context) {
    final templatesAsync = ref.watch(templatesListProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDarkCard,
        title: const Text('C2PA Templates', style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 16, fontWeight: FontWeight.bold)),
        actions: [
          ElevatedButton.icon(
            onPressed: _showCreateDialog,
            icon: const Icon(Icons.add, size: 14),
            label: const Text('Create Template', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: templatesAsync.when(
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.description_outlined, size: 64, color: AppColors.textTertiaryDark),
                  const SizedBox(height: 16),
                  const Text('No Templates Saved', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Save custom metadata presets for C2PA injection', style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _showCreateDialog,
                    child: const Text('Create Template'),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 320,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.4,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return Card(
                color: AppColors.bgDarkCard,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.bgDarkBorder),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.description_rounded, color: AppColors.primary, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.name,
                              style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 13, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _deleteTemplate(item),
                            icon: const Icon(Icons.delete_outline, color: AppColors.danger, size: 16),
                            style: IconButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(24, 24)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (item.creator != null) _templateField('Creator', item.creator!),
                      if (item.organization != null) _templateField('Organization', item.organization!),
                      if (item.license != null) _templateField('License', item.license!),
                      if (item.copyright != null) _templateField('Copyright', item.copyright!),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
        error: (err, _) => Center(child: Text(err.toString(), style: const TextStyle(color: AppColors.danger))),
      ),
    );
  }

  Widget _templateField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(color: AppColors.textTertiaryDark, fontSize: 10, fontWeight: FontWeight.w500)),
          Expanded(child: Text(value, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 10), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
