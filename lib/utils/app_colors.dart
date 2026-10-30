import 'package:flutter/material.dart';

/// App color palette designed for CampusFind X
/// Primary: Deep Navy Blue
/// Secondary / Accent: Bright Electric Blue
/// Status Colors: Emerald Green for Found/Resolved, Coral Amber for Lost/Urgent
class AppColors {
  // Brand colors
  static const Color primaryNavy = Color(0xFF0D2240);
  static const Color primaryNavyLight = Color(0xFF1E3A8A);
  static const Color primaryNavyDark = Color(0xFF081426);

  static const Color accentBlue = Color(0xFF0284C7);
  static const Color accentBlueLight = Color(0xFF38BDF8);

  // Status Colors
  static const Color lostRed = Color(0xFFDC2626);
  static const Color lostRedLight = Color(0xFFFEE2E2);

  static const Color foundGreen = Color(0xFF059669);
  static const Color foundGreenLight = Color(0xFFD1FAE5);

  static const Color resolvedPurple = Color(0xFF7C3AED);
  static const Color resolvedPurpleLight = Color(0xFFEDE9FE);

  static const Color openAmber = Color(0xFFD97706);
  static const Color openAmberLight = Color(0xFFFEF3C7);

  // Light Theme Neutrals
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Dark Theme Neutrals
  static const Color backgroundDark = Color(0xFF0B132B);
  static const Color surfaceDark = Color(0xFF1C2541);
  static const Color cardDark = Color(0xFF1E293B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color borderDark = Color(0xFF334155);
}
