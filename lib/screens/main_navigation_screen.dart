import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/app_bottom_navigation.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'my_reports_screen.dart';
import 'profile_screen.dart';
import 'report_found_screen.dart';
import 'report_lost_screen.dart';
import 'reports_screen.dart';

/// Main scaffold managing bottom navigation and quick reporting action modal
class MainNavigationScreen extends StatefulWidget {
  static const String routeName = '/main';

  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showCreateOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create Campus Report',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              const Text(
                'Choose what you would like to report to the campus community',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.5, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Option 1: Lost Item
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: AppColors.lostRed.withOpacity(0.3)),
                ),
                tileColor: AppColors.lostRedLight.withOpacity(0.4),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.lostRed.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.search_off_rounded,
                    color: AppColors.lostRed,
                  ),
                ),
                title: const Text(
                  'Report Lost Item',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: const Text(
                  'Lost an ID card, bag, bottle, or notes on campus',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.pushNamed(context, ReportLostScreen.routeName);
                },
              ),
              const SizedBox(height: 12),

              // Option 2: Found Item
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: AppColors.foundGreen.withOpacity(0.3),
                  ),
                ),
                tileColor: AppColors.foundGreenLight.withOpacity(0.4),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.foundGreen.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.foundGreen,
                  ),
                ),
                title: const Text(
                  'Report Found Item',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: const Text(
                  'Discovered someone\'s belongings in a lab or corridor',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.pushNamed(context, ReportFoundScreen.routeName);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onNavigateTab: _navigateToTab),
      const ReportsScreen(),
      const MyReportsScreen(),
      FavoritesScreen(onNavigateTab: _navigateToTab),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateOptions(context),
        backgroundColor: AppColors.accentBlue,
        foregroundColor: Colors.white,
        tooltip: 'Report Item',
        child: const Icon(Icons.add_rounded, size: 28),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onDestinationSelected: _navigateToTab,
      ),
    );
  }
}
