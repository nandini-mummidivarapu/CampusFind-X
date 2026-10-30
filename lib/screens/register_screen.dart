import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../utils/validators.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

/// Registration Screen for local student demonstration accounts
class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _studentIdController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();

    final success = await auth.register(
      fullName: _nameController.text,
      email: _emailController.text,
      studentId: _studentIdController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Account created successfully for ${_nameController.text.trim()}!',
          ),
          backgroundColor: AppColors.foundGreen,
        ),
      );
      // Close registration and login screens, returning to home/caller
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Register Student Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Join CampusFind X',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Create your local demo account to post and track belongings.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 20),

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

                // Full Name
                CustomTextField(
                  controller: _nameController,
                  label: 'Full Name *',
                  hint: 'e.g., Alex Sharma',
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (v) => Validators.requiredField(v, 'Full Name'),
                ),
                const SizedBox(height: 14),

                // College Email
                CustomTextField(
                  controller: _emailController,
                  label: 'College Email *',
                  hint: 'e.g., alex.sharma@college.edu',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 14),

                // Student Roll/ID Number (Optional)
                CustomTextField(
                  controller: _studentIdController,
                  label: 'Student Roll / ID No. (Optional)',
                  hint: 'e.g., CS2024-042',
                  prefixIcon: Icons.badge_outlined,
                ),
                const SizedBox(height: 14),

                // Phone (Optional)
                CustomTextField(
                  controller: _phoneController,
                  label: 'Contact Phone Number (Optional)',
                  hint: 'e.g., +91 98765 43210',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                ),
                const SizedBox(height: 14),

                // Password
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password *',
                  hint: 'Minimum 6 characters',
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
                const SizedBox(height: 14),

                // Confirm Password
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password *',
                  hint: 'Re-enter your password',
                  prefixIcon: Icons.lock_clock_outlined,
                  obscureText: _obscureConfirm,
                  validator: (v) =>
                      Validators.confirmPassword(v, _passwordController.text),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _obscureConfirm = !_obscureConfirm);
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                PrimaryButton(
                  label: 'Register Account',
                  icon: Icons.person_add_rounded,
                  isLoading: authProvider.isLoading,
                  onPressed: _handleRegister,
                ),
                const SizedBox(height: 20),

                // Back to Login Link
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Already have an account? Sign In'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
