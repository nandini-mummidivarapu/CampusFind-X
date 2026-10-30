import 'package:flutter/material.dart';

/// Reusable Material 3 Bottom Navigation Bar
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      elevation: 3,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.format_list_bulleted_rounded),
          selectedIcon: Icon(Icons.format_list_bulleted_rounded),
          label: 'Reports',
        ),
        NavigationDestination(
          icon: Icon(Icons.assignment_outlined),
          selectedIcon: Icon(Icons.assignment_rounded),
          label: 'My Reports',
        ),
        NavigationDestination(
          icon: Icon(Icons.bookmark_outline_rounded),
          selectedIcon: Icon(Icons.bookmark_rounded),
          label: 'Favorites',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}
