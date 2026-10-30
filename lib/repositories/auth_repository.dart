import '../models/app_user.dart';
import '../services/local_storage_service.dart';
import '../utils/app_constants.dart';

/// Repository managing local demonstration authentication.
///
/// DISCLAIMER FOR LAB EXAMINERS & STUDENTS:
/// This repository implements local client-side demo authentication without an external server.
/// In production, never verify passwords client-side or consider local storage secure against device root access.
class AuthRepository {
  final LocalStorageService _storageService;

  AuthRepository(this._storageService);

  /// Fetch currently authenticated student session (or null if guest)
  Future<AppUser?> getCurrentUser() async {
    return _storageService.loadCurrentUser();
  }

  /// Login with email and password
  Future<AppUser> login(String email, String password) async {
    final cleanEmail = email.trim().toLowerCase();
    final users = _storageService.loadUsers();

    final user = users.cast<AppUser?>().firstWhere(
      (u) => u?.email == cleanEmail,
      orElse: () => null,
    );

    if (user == null) {
      throw Exception(
        'No student account found with this email. Please check spelling or register.',
      );
    }

    if (!user.verifyPassword(password)) {
      throw Exception('Incorrect password. Please try again.');
    }

    await _storageService.saveCurrentUser(user);
    return user;
  }

  /// One-click quick login for college lab demonstration
  Future<AppUser> quickDemoLogin() async {
    final users = _storageService.loadUsers();
    AppUser? demoUser = users.cast<AppUser?>().firstWhere(
      (u) => u?.id == AppConstants.demoUserId,
      orElse: () => null,
    );

    if (demoUser == null) {
      demoUser = AppUser(
        id: AppConstants.demoUserId,
        fullName: AppConstants.demoUserName,
        email: AppConstants.demoUserEmail,
        studentId: AppConstants.demoUserStudentId,
        phone: AppConstants.demoUserPhone,
        passwordHash: AppUser.hashPassword('student123'),
        joinedAt: DateTime.now(),
      );
      users.add(demoUser);
      await _storageService.saveUsers(users);
    }

    await _storageService.saveCurrentUser(demoUser);
    return demoUser;
  }

  /// Register a new student account locally
  Future<AppUser> register({
    required String fullName,
    required String email,
    required String password,
    String? studentId,
    String? phone,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final users = _storageService.loadUsers();

    // Prevent duplicate email registrations
    final exists = users.any((u) => u.email == cleanEmail);
    if (exists) {
      throw Exception(
        'A student account with $cleanEmail already exists. Please log in instead.',
      );
    }

    final newUser = AppUser(
      id: 'student_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName.trim(),
      email: cleanEmail,
      studentId: studentId?.trim(),
      phone: phone?.trim(),
      passwordHash: AppUser.hashPassword(password),
      joinedAt: DateTime.now(),
    );

    users.add(newUser);
    await _storageService.saveUsers(users);
    await _storageService.saveCurrentUser(newUser);
    return newUser;
  }

  /// End current student session
  Future<void> logout() async {
    await _storageService.clearCurrentUser();
  }

  /// Check if onboarding has been seen
  bool isOnboardingCompleted() {
    return _storageService.isOnboardingCompleted();
  }

  /// Mark onboarding completed
  Future<void> setOnboardingCompleted() async {
    await _storageService.setOnboardingCompleted(true);
  }
}
