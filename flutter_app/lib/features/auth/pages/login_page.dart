import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../providers/auth_provider.dart';
import '../../../core/router/app_router.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_glass_card.dart';

// ─────────────────────────────────────────────
// Login Page
// ─────────────────────────────────────────────
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authNotifierProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.maybeWhen(loading: () => true, orElse: () => false);
    final error = authState.maybeWhen(error: (msg) => msg, orElse: () => null);

    // Navigate on success
    ref.listen<AuthState>(authNotifierProvider, (_, next) {
      next.maybeMap(
        authenticated: (_) => context.go(AppRoutes.dashboard),
        orElse: () {},
      );
    });

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Row(
        children: [
          // Left: Branding Panel (desktop only)
          if (MediaQuery.of(context).size.width > 900)
            Expanded(
              child: _BrandPanel(),
            ),

          // Right: Login Form
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: SizedBox(
                  width: 420,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      _buildHeader(context),
                      const SizedBox(height: 40),

                      // Form Card
                      AuthGlassCard(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Email
                              AuthTextField(
                                controller: _emailController,
                                label: 'Email',
                                hint: 'you@example.com',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Email is required';
                                  }
                                  if (!v.contains('@')) return 'Invalid email';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Password
                              AuthTextField(
                                controller: _passwordController,
                                label: 'Password',
                                hint: '••••••••',
                                icon: Icons.lock_outline,
                                obscureText: _obscurePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: AppColors.textTertiaryDark,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return 'Password is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Remember me + Forgot
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (v) =>
                                        setState(() => _rememberMe = v ?? false),
                                    activeColor: AppColors.primary,
                                    side: BorderSide(
                                        color: AppColors.bgDarkBorder),
                                  ),
                                  Text(
                                    'Remember me',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.textSecondaryDark,
                                        ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () =>
                                        context.push(AppRoutes.forgotPassword),
                                    child: Text(
                                      'Forgot password?',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: AppColors.primary),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Error
                              if (error != null) ...[
                                _ErrorBanner(message: error),
                                const SizedBox(height: 16),
                              ],

                              // Login button
                              SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _handleLogin,
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text('Sign In'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Register link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondaryDark,
                                ),
                          ),
                          TextButton(
                            onPressed: () => context.go(AppRoutes.register),
                            child: const Text(
                              'Create Account',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.verified_rounded,
                  size: 22, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          'Welcome back',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.textPrimaryDark,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to your workspace',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryDark,
              ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1, end: 0);
  }
}

// ─────────────────────────────────────────────
// Brand Panel (desktop left side)
// ─────────────────────────────────────────────
class _BrandPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF09090B)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      padding: const EdgeInsets.all(48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Feature list
          const Spacer(),
          ..._features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Icon(f.icon, size: 20, color: AppColors.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            f.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: AppColors.textPrimaryDark),
                          ),
                          Text(
                            f.subtitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: AppColors.textTertiaryDark),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          const Spacer(),
          Text(
            '"Professional image provenance\nmanagement at your fingertips."',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondaryDark,
                  fontStyle: FontStyle.italic,
                ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    ).animate().fadeIn(duration: 700.ms);
  }

  static const _features = [
    _Feature(
      icon: Icons.verified_rounded,
      title: 'C2PA Verification',
      subtitle: 'Read, verify, and create content credentials',
    ),
    _Feature(
      icon: Icons.info_outline_rounded,
      title: 'Metadata Engine',
      subtitle: 'EXIF, IPTC, XMP, GPS, ICC inspection',
    ),
    _Feature(
      icon: Icons.compress_rounded,
      title: 'Image Processing',
      subtitle: 'Compress, resize, convert in batch',
    ),
    _Feature(
      icon: Icons.folder_open_rounded,
      title: 'Project Management',
      subtitle: 'Organize images into projects with history',
    ),
  ];
}

class _Feature {
  final IconData icon;
  final String title;
  final String subtitle;
  const _Feature({required this.icon, required this.title, required this.subtitle});
}

// ─────────────────────────────────────────────
// Error Banner Widget
// ─────────────────────────────────────────────
class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.danger.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.danger, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.danger),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms).shake(hz: 3, offset: Offset(4, 0));
  }
}
