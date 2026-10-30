import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_user.dart';
import '../models/item_report.dart';
import '../utils/app_constants.dart';
import 'sample_data.dart';

/// Service responsible for local data persistence using SharedPreferences.
/// Stores structured JSON for reports, demo accounts, favorites, and settings.
class LocalStorageService {
  static const String _keyReports = 'campusfindx_reports_v1';
  static const String _keyUsers = 'campusfindx_users_v1';
  static const String _keyCurrentUser = 'campusfindx_current_user_v1';
  static const String _keyFavorites = 'campusfindx_favorites_v1';
  static const String _keyThemeMode = 'campusfindx_theme_mode_v1';
  static const String _keyOnboardingDone = 'campusfindx_onboarding_done_v1';
  static const String _keyIsSeeded = 'campusfindx_is_seeded_v1';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  /// Factory method to initialize SharedPreferences asynchronously
  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final service = LocalStorageService(prefs);
    await service._ensureInitialDataSeeded();
    return service;
  }

  /// Seeds initial 16 sample reports and demo user account only on very first launch
  Future<void> _ensureInitialDataSeeded() async {
    final isSeeded = _prefs.getBool(_keyIsSeeded) ?? false;
    if (!isSeeded) {
      // Seed sample reports
      final initialReports = SampleData.getInitialReports();
      await saveReports(initialReports);

      // Seed default demo user account
      final defaultUser = AppUser(
        id: AppConstants.demoUserId,
        fullName: AppConstants.demoUserName,
        email: AppConstants.demoUserEmail,
        studentId: AppConstants.demoUserStudentId,
        phone: AppConstants.demoUserPhone,
        passwordHash: AppUser.hashPassword('student123'),
        joinedAt: DateTime.now().subtract(const Duration(days: 30)),
      );
      await saveUsers([defaultUser]);

      // Seed initial favorites (e.g. sample_01)
      await saveFavorites(['sample_01', 'sample_04']);

      await _prefs.setBool(_keyIsSeeded, true);
    }
  }

  /// Reset to initial demo data (helpful for college lab examiners)
  Future<void> resetToSampleData() async {
    final initialReports = SampleData.getInitialReports();
    await saveReports(initialReports);
    await saveFavorites(['sample_01', 'sample_04']);
  }

  // ==================== ITEM REPORTS ====================

  /// Load all item reports from local storage
  List<ItemReport> loadReports() {
    final jsonString = _prefs.getString(_keyReports);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> list = jsonDecode(jsonString) as List<dynamic>;
      return list
          .map((item) => ItemReport.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // In case of corrupt JSON, return empty list safely
      return [];
    }
  }

  /// Save all item reports to local storage
  Future<bool> saveReports(List<ItemReport> reports) async {
    final list = reports.map((r) => r.toJson()).toList();
    return _prefs.setString(_keyReports, jsonEncode(list));
  }

  // ==================== USERS & AUTH ====================

  /// Load all registered demo user accounts
  List<AppUser> loadUsers() {
    final jsonString = _prefs.getString(_keyUsers);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> list = jsonDecode(jsonString) as List<dynamic>;
      return list
          .map((item) => AppUser.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Save registered demo users list
  Future<bool> saveUsers(List<AppUser> users) async {
    final list = users.map((u) => u.toJson()).toList();
    return _prefs.setString(_keyUsers, jsonEncode(list));
  }

  /// Get currently active demo session
  AppUser? loadCurrentUser() {
    final jsonString = _prefs.getString(_keyCurrentUser);
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }
    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return AppUser.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  /// Save current active demo session
  Future<bool> saveCurrentUser(AppUser user) async {
    return _prefs.setString(_keyCurrentUser, jsonEncode(user.toJson()));
  }

  /// Clear current active demo session (logout)
  Future<bool> clearCurrentUser() async {
    return _prefs.remove(_keyCurrentUser);
  }

  // ==================== FAVORITES ====================

  /// Get list of favorited report IDs
  List<String> loadFavorites() {
    return _prefs.getStringList(_keyFavorites) ?? [];
  }

  /// Save list of favorited report IDs
  Future<bool> saveFavorites(List<String> ids) async {
    return _prefs.setStringList(_keyFavorites, ids);
  }

  // ==================== SETTINGS & PREFERENCES ====================

  /// Get theme mode string: 'light', 'dark', or 'system'
  String loadThemeMode() {
    return _prefs.getString(_keyThemeMode) ?? 'system';
  }

  /// Save theme mode string
  Future<bool> saveThemeMode(String themeMode) async {
    return _prefs.setString(_keyThemeMode, themeMode);
  }

  /// Check if student finished onboarding
  bool isOnboardingCompleted() {
    return _prefs.getBool(_keyOnboardingDone) ?? false;
  }

  /// Set onboarding completed
  Future<bool> setOnboardingCompleted(bool value) async {
    return _prefs.setBool(_keyOnboardingDone, value);
  }
}
