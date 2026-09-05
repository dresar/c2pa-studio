import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────
// Glass-morphism Card for Auth Pages
// ─────────────────────────────────────────────
class AuthGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const AuthGlassCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.bgDarkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.bgDarkBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 40,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
