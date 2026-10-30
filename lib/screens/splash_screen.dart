import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import 'main_navigation_screen.dart';
import 'onboarding_screen.dart';

/// Splash Screen featuring CampusFind X branding and smooth transition
class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    // Navigate after 2 seconds
    Timer(const Duration(milliseconds: 2200), _handleNavigation);
  }

  void _handleNavigation() {
    if (!mounted) return;
    final authProvider = context.read<AuthProvider>();
    final isDone = authProvider.isOnboardingCompleted();

    if (isDone) {
      Navigator.pushReplacementNamed(context, MainNavigationScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, OnboardingScreen.routeName);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand Icon
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accentBlueLight.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.find_in_page_rounded,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // App Title
                    const Text(
                      AppConstants.appName,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tagline
                    Text(
                      AppConstants.appTagline,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Loading indicator
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.accentBlueLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
