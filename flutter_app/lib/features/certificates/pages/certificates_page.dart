import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io' as io;

import '../../../core/theme/app_theme.dart';

class CertificateModel {
  final String id;
  final String name;
  final String type; // SSL/X.509
  final String issuer;
  final DateTime expiryDate;
  final String status;

  CertificateModel({
    required this.id,
    required this.name,
    required this.type,
    required this.issuer,
    required this.expiryDate,
    required this.status,
  });
}

class CertificatesPage extends StatefulWidget {
  const CertificatesPage({super.key});

  @override
  State<CertificatesPage> createState() => _CertificatesPageState();
}

class _CertificatesPageState extends State<CertificatesPage> {
  final List<CertificateModel> _certificates = [
    CertificateModel(
      id: 'cert_1',
      name: 'Default IPS Self-Signed Certification',
      type: 'Self-Signed X.509',
      issuer: 'Image Provenance Studio CA',
      expiryDate: DateTime.now().add(const Duration(days: 365 * 5)),
      status: 'Active',
    ),
    CertificateModel(
      id: 'cert_2',
      name: 'Development Certificate',
      type: 'X.509 (DER/PEM)',
      issuer: 'Let\'s Encrypt Intermediate CA',
      expiryDate: DateTime.now().add(const Duration(days: 90)),
      status: 'Active',
    ),
  ];

  Future<void> _uploadCertificate() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pem', 'crt', 'pfx', 'p12', 'der'],
    );

    if (result != null && result.files.single.path != null && mounted) {
      final name = result.files.single.name;
      final passwordC = TextEditingController();

      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.bgDarkCard,
          title: const Text('Add Certificate', style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 14, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Selected file: $name', style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
              const SizedBox(height: 12),
              const Text('Enter Private Key Passphrase (optional):', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 11)),
              TextField(
                controller: passwordC,
                obscureText: true,
                style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 12),
                decoration: const InputDecoration(
                  labelText: 'Passphrase',
                  labelStyle: TextStyle(color: AppColors.textTertiaryDark, fontSize: 11),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.bgDarkBorder)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Add', style: TextStyle(fontSize: 12)),
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

        await Future.delayed(const Duration(seconds: 1)); // Realistic simulation

        if (mounted) {
          Navigator.pop(context); // Dismiss loading
          setState(() {
            _certificates.add(CertificateModel(
              id: 'cert_${DateTime.now().millisecondsSinceEpoch}',
              name: name.split('.').first.toUpperCase(),
              type: name.split('.').last.toUpperCase(),
              issuer: 'Local Uploaded Keypair',
              expiryDate: DateTime.now().add(const Duration(days: 365)),
              status: 'Active',
            ));
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Certificate installed successfully'), backgroundColor: AppColors.success),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDarkCard,
        title: const Text('PKI Certificates', style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 16, fontWeight: FontWeight.bold)),
        actions: [
          ElevatedButton.icon(
            onPressed: _uploadCertificate,
            icon: const Icon(Icons.security, size: 14),
            label: const Text('Add Private Key / Cert', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _certificates.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.admin_panel_settings_outlined, size: 64, color: AppColors.textTertiaryDark),
                  const SizedBox(height: 16),
                  const Text('No Certificates Installed', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Add official X.509 credentials to sign custom C2PA manifests', style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _uploadCertificate,
                    child: const Text('Add Certificate'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _certificates.length,
              itemBuilder: (context, index) {
                final cert = _certificates[index];
                return Card(
                  color: AppColors.bgDarkCard,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppColors.bgDarkBorder),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.vpn_key_rounded, color: AppColors.primary, size: 20),
                    ),
                    title: Text(
                      cert.name,
                      style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Type: ${cert.type}   |   Issuer: ${cert.issuer}', style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 11)),
                          const SizedBox(height: 2),
                          Text('Expires: ${cert.expiryDate.year}-${cert.expiryDate.month.toString().padLeft(2, '0')}-${cert.expiryDate.day.toString().padLeft(2, '0')}', style: const TextStyle(color: AppColors.textTertiaryDark, fontSize: 10)),
                        ],
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.08),
                        border: Border.all(color: AppColors.success.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        cert.status,
                        style: const TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
