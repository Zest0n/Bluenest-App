import 'package:flutter/material.dart';
import 'token_storage.dart';

class UserProfile {
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String role;

  const UserProfile({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role,
  });

  String get fullName {
    final name = '$firstName $lastName'.trim();
    return name.isNotEmpty ? name : username;
  }

  String get initials {
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '${firstName[0]}${lastName[0]}'.toUpperCase();
    }
    if (firstName.isNotEmpty) return firstName[0].toUpperCase();
    if (username.isNotEmpty) return username[0].toUpperCase();
    return 'R';
  }

  UserProfile copyWith({
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? role,
  }) {
    return UserProfile(
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
    );
  }
}

class UserService {
  // Initial default profile from the Postman collection
  static final ValueNotifier<UserProfile> current = ValueNotifier<UserProfile>(
    const UserProfile(
      username: 'vasu_tenant01',
      firstName: 'Vasu',
      lastName: 'Tenant',
      email: 'tenant01@example.com',
      phone: '9876543210',
      role: 'tenant',
    ),
  );

  static void init({
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? role,
  }) {
    current.value = current.value.copyWith(
      username: username != null && username.isNotEmpty ? username : null,
      firstName: firstName != null && firstName.isNotEmpty ? firstName : null,
      lastName: lastName != null && lastName.isNotEmpty ? lastName : null,
      email: email != null && email.isNotEmpty ? email : null,
      phone: phone != null && phone.isNotEmpty ? phone : null,
      role: role != null && role.isNotEmpty ? role : null,
    );
  }

  static Future<void> loadSavedProfile() async {
    final p = await TokenStorage.loadProfile();
    if (p['username']?.isNotEmpty == true || p['firstName']?.isNotEmpty == true) {
      current.value = UserProfile(
        username: p['username']?.isNotEmpty == true ? p['username']! : 'User',
        firstName: p['firstName'] ?? '',
        lastName: p['lastName'] ?? '',
        email: p['email'] ?? '',
        phone: p['phone'] ?? '',
        role: p['role']?.isNotEmpty == true ? p['role']! : 'tenant',
      );
    }
  }

  static Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phone,
  }) async {
    current.value = current.value.copyWith(
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      username: username.trim(),
      email: email.trim(),
      phone: phone.trim(),
    );
    // Keep persistent storage in sync
    await TokenStorage.saveProfile(
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      username: username.trim(),
      email: email.trim(),
      phone: phone.trim(),
      role: current.value.role,
    );
    return true;
  }
}
