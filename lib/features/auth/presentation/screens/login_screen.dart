import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psgy/core/di/auth_providers.dart';
import 'package:psgy/core/di/firebase_providers.dart';
import 'package:psgy/core/error/app_error_handler.dart';
import 'package:psgy/core/error/app_exception.dart';
import 'package:psgy/core/error/error_mapper.dart';
import 'package:psgy/core/theme/app_colors.dart';
import 'package:psgy/core/theme/app_spacing.dart';
import 'package:psgy/features/auth/domain/entities/auth_user.dart';
import 'package:psgy/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:psgy/features/auth/domain/usecases/watch_auth_state_usecase.dart';
import 'package:psgy/shared/widgets/micro_interactions.dart';
import 'package:psgy/shared/widgets/modern_card.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final SignInUseCase _signInUseCase;
  late final WatchAuthStateUseCase _watchAuthStateUseCase;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  StreamSubscription<AuthUser?>? _authSub;
  AuthUser? _user;
  bool _isLoading = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _signInUseCase = ref.read(signInUseCaseProvider);
    _watchAuthStateUseCase = ref.read(watchAuthStateUseCaseProvider);

    _authSub = _watchAuthStateUseCase().listen(
      (user) {
        if (!mounted) return;
        setState(() => _user = user);
      },
      onError: (error) {
        if (!mounted) return;
        final mapped = mapFirebaseException(error);
        appErrorHandler.hapticError();
        setState(() => _errorText = mapped.message);
        if (mapped is AuthException &&
            (mapped.code == 'user-token-expired' ||
                mapped.code == 'id-token-expired' ||
                mapped.code == 'user-disabled')) {
          ref.read(signOutUseCaseProvider)();
        }
      },
    );
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      ref.read(monitoringServiceProvider).logBreadcrumb(
            'login_attempt',
            params: {'email': _emailController.text.trim()},
          );

      final user = await _signInUseCase(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;

      ref.read(monitoringServiceProvider).logBreadcrumb(
            'login_success',
            params: {'uid': user.uid},
          );

      setState(() => _user = user);
    } catch (e) {
      if (!mounted) return;
      final mapped = mapFirebaseException(e);
      appErrorHandler.hapticError();
      setState(() => _errorText = mapped.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      child: _user != null
          ? _AuthenticatedView(key: ValueKey(_user!.uid), user: _user!)
          : _LoginFormView(
              key: const ValueKey('login-form'),
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
              obscurePassword: _obscurePassword,
              isLoading: _isLoading,
              errorText: _errorText,
              onTogglePassword: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
              onSignIn: _handleSignIn,
            ),
    );
  }
}

class _AuthenticatedView extends ConsumerWidget {
  final AuthUser user;

  const _AuthenticatedView({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Đã đăng nhập',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(user.email ?? user.uid),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: () => ref.read(signOutUseCaseProvider)(),
                  child: const Text('Đăng xuất'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginFormView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final String? errorText;
  final VoidCallback onTogglePassword;
  final VoidCallback onSignIn;

  const _LoginFormView({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.errorText,
    required this.onTogglePassword,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _BrandHeader(isDark: isDark),
                  const SizedBox(height: AppSpacing.lg),
                  ModernCard(
                    enableScaleTap: false,
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Đăng nhập',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Email / mật khẩu (hạ tầng Auth). Coach + User dùng Phone OTP.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            validator: (value) {
                              final email = value?.trim() ?? '';
                              if (email.isEmpty) return 'Email is required.';
                              if (!email.contains('@')) {
                                return 'Invalid email format.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: passwordController,
                            obscureText: obscurePassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => onSignIn(),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: onTogglePassword,
                              ),
                            ),
                            validator: (value) {
                              final password = value ?? '';
                              if (password.isEmpty) {
                                return 'Password is required.';
                              }
                              if (password.length < 6) {
                                return 'Password must be at least 6 characters.';
                              }
                              return null;
                            },
                          ),
                          if (errorText != null) ...[
                            const SizedBox(height: AppSpacing.md),
                            _ErrorBox(message: errorText!),
                          ],
                          const SizedBox(height: AppSpacing.lg),
                          ScaleTap(
                            onTap: isLoading ? null : onSignIn,
                            enableHaptic: true,
                            child: FilledButton(
                              onPressed: isLoading ? null : onSignIn,
                              child: isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Login'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  final bool isDark;

  const _BrandHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.brandGradientDark : AppColors.brandGradient,
        borderRadius: AppSpacing.borderRadiusLg,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.fitness_center_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'PSgy',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Gym + Coach booking',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.88),
                ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;

  const _ErrorBox({required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF7F1D1D) : AppColors.dangerContainer,
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: isDark ? AppColors.danger : AppColors.onDangerContainer,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color:
                        isDark ? AppColors.danger : AppColors.onDangerContainer,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
