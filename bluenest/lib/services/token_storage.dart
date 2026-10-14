import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/dev_config.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';
  static const _roleKey = 'user_role';
  static const _usernameKey = 'user_username';
  static const _firstNameKey = 'user_first_name';
  static const _lastNameKey = 'user_last_name';
  static const _emailKey = 'user_email';
  static const _phoneKey = 'user_phone';

  // In-memory cache & fallback
  static final Map<String, String> _mem = {};

  static Future<void> save({
    required String access,
    required String refresh,
    String? role,
  }) async {
    _mem[_accessKey] = access;
    _mem[_refreshKey] = refresh;
    if (role != null) _mem[_roleKey] = role;

    if (!DevConfig.bypassLogin) {
      try {
        await _storage.write(key: _accessKey, value: access);
        await _storage.write(key: _refreshKey, value: refresh);
        if (role != null) await _storage.write(key: _roleKey, value: role);
      } catch (_) {}
    }
  }

  static Future<void> saveProfile({
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? role,
  }) async {
    if (username != null) _mem[_usernameKey] = username;
    if (firstName != null) _mem[_firstNameKey] = firstName;
    if (lastName != null) _mem[_lastNameKey] = lastName;
    if (email != null) _mem[_emailKey] = email;
    if (phone != null) _mem[_phoneKey] = phone;
    if (role != null) _mem[_roleKey] = role;

    if (!DevConfig.bypassLogin) {
      try {
        if (username != null) await _storage.write(key: _usernameKey, value: username);
        if (firstName != null) await _storage.write(key: _firstNameKey, value: firstName);
        if (lastName != null) await _storage.write(key: _lastNameKey, value: lastName);
        if (email != null) await _storage.write(key: _emailKey, value: email);
        if (phone != null) await _storage.write(key: _phoneKey, value: phone);
        if (role != null) await _storage.write(key: _roleKey, value: role);
      } catch (_) {}
    }
  }

  static Future<Map<String, String>> loadProfile() async {
    if (DevConfig.bypassLogin) {
      return {
        'username': _mem[_usernameKey] ?? '',
        'firstName': _mem[_firstNameKey] ?? '',
        'lastName': _mem[_lastNameKey] ?? '',
        'email': _mem[_emailKey] ?? '',
        'phone': _mem[_phoneKey] ?? '',
        'role': _mem[_roleKey] ?? '',
      };
    }
    try {
      final username = (await _storage.read(key: _usernameKey)) ?? _mem[_usernameKey] ?? '';
      final firstName = (await _storage.read(key: _firstNameKey)) ?? _mem[_firstNameKey] ?? '';
      final lastName = (await _storage.read(key: _lastNameKey)) ?? _mem[_lastNameKey] ?? '';
      final email = (await _storage.read(key: _emailKey)) ?? _mem[_emailKey] ?? '';
      final phone = (await _storage.read(key: _phoneKey)) ?? _mem[_phoneKey] ?? '';
      final role = (await _storage.read(key: _roleKey)) ?? _mem[_roleKey] ?? '';
      return {
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'role': role,
      };
    } catch (_) {
      return {
        'username': _mem[_usernameKey] ?? '',
        'firstName': _mem[_firstNameKey] ?? '',
        'lastName': _mem[_lastNameKey] ?? '',
        'email': _mem[_emailKey] ?? '',
        'phone': _mem[_phoneKey] ?? '',
        'role': _mem[_roleKey] ?? '',
      };
    }
  }

  static Future<String?> get access async {
    if (DevConfig.bypassLogin) return _mem[_accessKey] ?? 'mock-access-token';
    try {
      return (await _storage.read(key: _accessKey)) ?? _mem[_accessKey];
    } catch (_) {
      return _mem[_accessKey];
    }
  }

  static Future<String?> get refresh async {
    if (DevConfig.bypassLogin) return _mem[_refreshKey] ?? 'mock-refresh-token';
    try {
      return (await _storage.read(key: _refreshKey)) ?? _mem[_refreshKey];
    } catch (_) {
      return _mem[_refreshKey];
    }
  }

  static Future<String?> get role async {
    if (DevConfig.bypassLogin) return _mem[_roleKey] ?? 'tenant';
    try {
      return (await _storage.read(key: _roleKey)) ?? _mem[_roleKey];
    } catch (_) {
      return _mem[_roleKey];
    }
  }

  static Future<void> clear() async {
    _mem.clear();
    if (!DevConfig.bypassLogin) {
      try {
        await _storage.deleteAll();
      } catch (_) {}
    }
  }
}
