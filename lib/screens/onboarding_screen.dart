import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/primary_button.dart';
import 'main_navigation_screen.dart';

/// Onboarding Screen introducing key features: Lost, Found, and Search
class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlideData> _slides = const [
    OnboardingSlideData(
      icon: Icons.search_off_rounded,
      color: AppColors.lostRed,
      title: 'Report Lost Belongings',
      description:
          'Misplaced your ID card, earphones, or books on campus? File a report in seconds with location details and photos so fellow students can help you recover them.',
    ),
    OnboardingSlideData(
      icon: Icons.check_circle_outline_rounded,
      color: AppColors.foundGreen,
      title: 'Return Found Items',
      description:
          'Discovered someone\'s lost bag, keys, or calculator in a lab or classroom? Post a found notice and safely return belongings to their rightful owner.',
    ),
    OnboardingSlideData(
      icon: Icons.filter_alt_rounded,
      color: AppColors.accentBlue,
      title: 'Smart Campus Search & Filters',
      description:
          'Quickly search through campus reports by location, item category, and status. Save items to your favorites and connect directly with campus mates.',
    ),
  ];

  void _finishOnboarding() async {
    final auth = context.read<AuthProvider>();
    await auth.completeOnboarding();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, MainNavigationScreen.routeName);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _finishOnboarding,
            child: const Text(
              'Skip',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: slide.color.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(slide.icon, size: 80, color: slide.color),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide.description,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Indicators and Navigation Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Page Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? theme.colorScheme.primary
                              : theme.dividerColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Button
                  PrimaryButton(
                    label: _currentPage == _slides.length - 1
                        ? 'Get Started'
                        : 'Continue',
                    icon: _currentPage == _slides.length - 1
                        ? Icons.rocket_launch_rounded
                        : Icons.arrow_forward_rounded,
                    onPressed: () {
                      if (_currentPage < _slides.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _finishOnboarding();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingSlideData {
  final IconData icon;
  final Color color;
  final String title;
  final String description;

  const OnboardingSlideData({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });
}
