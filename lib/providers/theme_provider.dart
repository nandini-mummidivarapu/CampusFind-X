import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

/// Provider to manage Application Theme (Light / Dark mode)
class ThemeProvider extends ChangeNotifier {
  final LocalStorageService _storageService;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider(this._storageService) {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void _loadTheme() {
    final savedMode = _storageService.loadThemeMode();
    if (savedMode == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (savedMode == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final modeString = mode == ThemeMode.dark
        ? 'dark'
        : mode == ThemeMode.light
        ? 'light'
        : 'system';
    await _storageService.saveThemeMode(modeString);
  }

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      await setThemeMode(ThemeMode.dark);
    }
  }
}
