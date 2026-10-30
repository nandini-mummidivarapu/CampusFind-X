import 'package:flutter/material.dart';

/// Application-wide constants, categories, and campus locations
class AppConstants {
  static const String appName = 'CampusFind X';
  static const String appTagline = 'College Lost & Found Hub';
  static const String appVersion = '1.0.0';

  // Common campus locations for quick selection/suggestions
  static const List<String> campusLocations = [
    'Central Library - Ground Floor',
    'Central Library - 2nd Floor Reading Room',
    'Computer Science Lab 1',
    'Computer Science Lab 3',
    'Main Academic Block - Ground Floor',
    'Main Academic Block - 1st Floor Corridor',
    'Student Canteen / Cafeteria',
    'Sports Complex / Basketball Court',
    'Main Auditorium',
    'Seminar Hall A',
    'Seminar Hall B',
    'College Bus Stop & Main Gate',
    'Two-Wheeler Parking Lot',
    'Mechanical Workshop Building',
    'Admin Block & Principal Office Reception',
  ];

  // Demo user defaults
  static const String demoUserId = 'demo_user_001';
  static const String demoUserName = 'Alex Sharma';
  static const String demoUserEmail = 'alex.sharma@college.edu';
  static const String demoUserPhone = '+91 98765 43210';
  static const String demoUserStudentId = 'CS2024-042';
}

/// Category metadata helper
class CategoryInfo {
  final String key;
  final String displayName;
  final IconData icon;

  const CategoryInfo({
    required this.key,
    required this.displayName,
    required this.icon,
  });

  static const List<CategoryInfo> allCategories = [
    CategoryInfo(
      key: 'idCard',
      displayName: 'College ID Card',
      icon: Icons.badge_outlined,
    ),
    CategoryInfo(
      key: 'books',
      displayName: 'Books & Notes',
      icon: Icons.menu_book_outlined,
    ),
    CategoryInfo(
      key: 'electronics',
      displayName: 'Electronics & Gadgets',
      icon: Icons.devices_other_outlined,
    ),
    CategoryInfo(
      key: 'phones',
      displayName: 'Mobile Phones',
      icon: Icons.smartphone_outlined,
    ),
    CategoryInfo(
      key: 'bags',
      displayName: 'Bags & Backpacks',
      icon: Icons.backpack_outlined,
    ),
    CategoryInfo(
      key: 'keys',
      displayName: 'Keys & Keychains',
      icon: Icons.key_outlined,
    ),
    CategoryInfo(
      key: 'bottles',
      displayName: 'Water Bottles',
      icon: Icons.water_drop_outlined,
    ),
    CategoryInfo(
      key: 'watches',
      displayName: 'Watches',
      icon: Icons.watch_outlined,
    ),
    CategoryInfo(
      key: 'documents',
      displayName: 'Documents & Cards',
      icon: Icons.description_outlined,
    ),
    CategoryInfo(
      key: 'others',
      displayName: 'Other Belongings',
      icon: Icons.category_outlined,
    ),
  ];

  static CategoryInfo getByKey(String key) {
    return allCategories.firstWhere(
      (c) => c.key.toLowerCase() == key.toLowerCase(),
      orElse: () => const CategoryInfo(
        key: 'others',
        displayName: 'Other Belongings',
        icon: Icons.category_outlined,
      ),
    );
  }
}
