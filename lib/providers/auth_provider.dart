import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../repositories/auth_repository.dart';

/// Provider for managing authentication state and current demo user session
class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AppUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider(this._authRepository) {
    _initUser();
  }

  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _initUser() async {
    _currentUser = await _authRepository.getCurrentUser();
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.login(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// One-click quick login for college demo
  Future<bool> quickDemoLogin() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.quickDemoLogin();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Register new demo student
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    String? studentId,
    String? phone,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.register(
        fullName: fullName,
        email: email,
        password: password,
        studentId: studentId,
        phone: phone,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Logout current student
  Future<void> logout() async {
    await _authRepository.logout();
    _currentUser = null;
    notifyListeners();
  }

  bool isOnboardingCompleted() {
    return _authRepository.isOnboardingCompleted();
  }

  Future<void> completeOnboarding() async {
    await _authRepository.setOnboardingCompleted();
    notifyListeners();
  }
}
