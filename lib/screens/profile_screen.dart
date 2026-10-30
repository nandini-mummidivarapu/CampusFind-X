import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/item_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../widgets/primary_button.dart';
import 'login_screen.dart';
import 'register_screen.dart';

/// Profile and Settings Screen handling theme toggles, demo credentials, and app information
class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

  const ProfileScreen({super.key});

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: 'Version ${AppConstants.appVersion}',
      applicationIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryNavy,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.find_in_page_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
      children: [
        const SizedBox(height: 12),
        const Text(
          'CampusFind X is a comprehensive Campus Lost and Found mobile management application engineered using Flutter, Dart, Material 3, and Provider state management.',
          style: TextStyle(fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 8),
        const Text(
          'Designed specifically for college campus utility and academic laboratory demonstrations.',
          style: TextStyle(fontSize: 13, height: 1.4),
        ),
      ],
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset Sample Data?'),
        content: const Text(
          'This will reload all 16 original college lost & found demonstration records. Any custom items you created may be replaced.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final itemProvider = context.read<ItemProvider>();
              await itemProvider.resetToSampleData();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sample demonstration dataset reloaded!'),
                    backgroundColor: AppColors.foundGreen,
                  ),
                );
              }
            },
            child: const Text('Reset Data'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final auth = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final user = auth.currentUser;

    final joinedDate = user != null
        ? DateFormat('MMMM yyyy').format(user.joinedAt)
        : 'N/A';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: user != null
                  ? Column(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: AppColors.primaryNavy,
                          child: Text(
                            user.fullName.isNotEmpty
                                ? user.fullName[0].toUpperCase()
                                : 'S',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user.fullName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: TextStyle(
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: [
                            if (user.studentId != null)
                              Chip(
                                avatar: const Icon(
                                  Icons.badge_outlined,
                                  size: 16,
                                ),
                                label: Text(user.studentId!),
                                visualDensity: VisualDensity.compact,
                              ),
                            Chip(
                              avatar: const Icon(
                                Icons.calendar_today_rounded,
                                size: 14,
                              ),
                              label: Text('Member since $joinedDate'),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        const CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.person_outline_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Campus Guest',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Sign in to report belongings and manage your notices',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12.5, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                label: 'Sign In',
                                height: 42,
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    LoginScreen.routeName,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: PrimaryButton(
                                label: 'Register',
                                height: 42,
                                isOutlined: true,
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    RegisterScreen.routeName,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 24),

            // Settings Section
            Text(
              'Appearance & Settings',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),

            // Theme Toggle Tile
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
              child: SwitchListTile(
                secondary: Icon(
                  themeProvider.isDarkMode
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  color: AppColors.accentBlue,
                ),
                title: const Text('Dark Mode Theme'),
                subtitle: Text(
                  themeProvider.isDarkMode
                      ? 'Dark high-contrast mode active'
                      : 'Light neutral mode active',
                  style: const TextStyle(fontSize: 12),
                ),
                value: themeProvider.isDarkMode,
                onChanged: (_) {
                  themeProvider.toggleTheme();
                },
              ),
            ),
            const SizedBox(height: 10),

            // College Lab Demo Tools Section
            Text(
              'Lab Demonstration Utilities',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.restart_alt_rounded,
                      color: AppColors.openAmber,
                    ),
                    title: const Text('Reset Sample Data'),
                    subtitle: const Text(
                      'Reload original 16 realistic campus reports',
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showResetConfirmation(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.accentBlue,
                    ),
                    title: const Text('About CampusFind X'),
                    subtitle: const Text(
                      'Architecture, version, and college lab info',
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _showAboutDialog(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout Button if logged in
            if (user != null)
              PrimaryButton(
                label: 'Sign Out Account',
                icon: Icons.logout_rounded,
                isOutlined: true,
                backgroundColor: AppColors.lostRed,
                textColor: AppColors.lostRed,
                onPressed: () async {
                  await auth.logout();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logged out successfully.')),
                    );
                  }
                },
              ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}
