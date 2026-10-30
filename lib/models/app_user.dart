import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;

/// User model representing a student account in CampusFind X.
///
/// NOTE FOR COLLEGE LAB DEMO:
/// This model is designed for a local-first offline prototype. In a production
/// system, authentication would be handled via a secure remote backend (e.g., OAuth, JWT, Firebase).
/// For lab demonstration, passwords are never stored in plaintext; a simple SHA-256 hash
/// is used locally.
class AppUser {
  final String id;
  final String fullName;
  final String email;
  final String? studentId;
  final String? phone;
  final String passwordHash;
  final DateTime joinedAt;

  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    this.studentId,
    this.phone,
    required this.passwordHash,
    required this.joinedAt,
  });

  /// Helper to hash a password using SHA-256 for local demonstration
  static String hashPassword(String password) {
    final bytes = utf8.encode(password.trim());
    return crypto.sha256.convert(bytes).toString();
  }

  /// Verifies if a given plaintext password matches this user's stored hash
  bool verifyPassword(String password) {
    return passwordHash == hashPassword(password);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email.trim().toLowerCase(),
      'studentId': studentId,
      'phone': phone,
      'passwordHash': passwordHash,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      studentId: json['studentId'] as String?,
      phone: json['phone'] as String?,
      passwordHash: json['passwordHash'] as String? ?? '',
      joinedAt: json['joinedAt'] != null
          ? DateTime.parse(json['joinedAt'] as String)
          : DateTime.now(),
    );
  }

  AppUser copyWith({
    String? id,
    String? fullName,
    String? email,
    String? studentId,
    String? phone,
    String? passwordHash,
    DateTime? joinedAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      studentId: studentId ?? this.studentId,
      phone: phone ?? this.phone,
      passwordHash: passwordHash ?? this.passwordHash,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
