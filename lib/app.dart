import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'screens/favorites_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/my_reports_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'screens/report_found_screen.dart';
import 'screens/report_lost_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/splash_screen.dart';
import 'utils/app_colors.dart';
import 'utils/app_constants.dart';

/// Root Application Widget configuring Material 3 themes and route navigation
class CampusFindXApp extends StatelessWidget {
  const CampusFindXApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    // Material 3 Light Theme
    final lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryNavy,
        brightness: Brightness.light,
        primary: AppColors.primaryNavy,
        onPrimary: Colors.white,
        secondary: AppColors.accentBlue,
        surface: AppColors.surfaceLight,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderLight),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNavy,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );

    // Material 3 Dark Theme
    final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accentBlue,
        brightness: Brightness.dark,
        primary: AppColors.accentBlue,
        onPrimary: Colors.white,
        surface: AppColors.surfaceDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderDark),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        OnboardingScreen.routeName: (_) => const OnboardingScreen(),
        MainNavigationScreen.routeName: (_) => const MainNavigationScreen(),
        ReportsScreen.routeName: (_) => const ReportsScreen(),
        ReportLostScreen.routeName: (_) => const ReportLostScreen(),
        ReportFoundScreen.routeName: (_) => const ReportFoundScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        MyReportsScreen.routeName: (_) => const MyReportsScreen(),
        FavoritesScreen.routeName: (_) => const FavoritesScreen(),
        ProfileScreen.routeName: (_) => const ProfileScreen(),
      },
    );
  }
}
