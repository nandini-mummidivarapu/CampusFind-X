import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import 'register_screen.dart';

/// Login Screen supporting email/password entry and instant Demo Student Login
class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();

    final success = await auth.login(
      _emailController.text,
      _passwordController.text,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome back, ${auth.currentUser?.fullName}!'),
          backgroundColor: AppColors.foundGreen,
        ),
      );
      Navigator.pop(context);
    }
  }

  void _handleDemoLogin() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.quickDemoLogin();

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Signed in as Demo Student (${AppConstants.demoUserName})',
          ),
          backgroundColor: AppColors.accentBlue,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Student Login')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.accentBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.accentBlue.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.school_rounded,
                        color: AppColors.accentBlue,
                        size: 32,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Local Campus Demo Mode',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: AppColors.accentBlue,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Designed for college lab evaluation. No internet or remote credentials required.',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  'Sign In to CampusFind X',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Access your reported items and connect with campus finders.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 24),

                // Error Message if any
                if (authProvider.errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.lostRedLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.lostRed.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: AppColors.lostRed,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            authProvider.errorMessage!,
                            style: const TextStyle(
                              color: AppColors.lostRed,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Email Field
                CustomTextField(
                  controller: _emailController,
                  label: 'College Email',
                  hint: 'e.g., student@college.edu',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),

                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: _obscurePassword,
                  validator: Validators.password,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Sign In Button
                PrimaryButton(
                  label: 'Sign In',
                  icon: Icons.login_rounded,
                  isLoading: authProvider.isLoading,
                  onPressed: _handleLogin,
                ),
                const SizedBox(height: 16),

                // Quick Demo Login Button (One-click)
                PrimaryButton(
                  label: 'Quick Demo Login (Alex Sharma)',
                  icon: Icons.play_arrow_rounded,
                  isOutlined: true,
                  backgroundColor: AppColors.accentBlue,
                  textColor: AppColors.accentBlue,
                  onPressed: _handleDemoLogin,
                ),
                const SizedBox(height: 28),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: TextStyle(
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        authProvider.clearError();
                        Navigator.pushNamed(context, RegisterScreen.routeName);
                      },
                      child: Text(
                        'Register Now',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
