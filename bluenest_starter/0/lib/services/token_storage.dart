import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';
  static const _roleKey = 'user_role';

  static Future<void> save({
    required String access,
    required String refresh,
    String? role,
  }) async {
    await _storage.write(key: _accessKey, value: access);
    await _storage.write(key: _refreshKey, value: refresh);
    if (role != null) await _storage.write(key: _roleKey, value: role);
  }

  static Future<String?> get access => _storage.read(key: _accessKey);
  static Future<String?> get refresh => _storage.read(key: _refreshKey);
  static Future<String?> get role => _storage.read(key: _roleKey);

  static Future<void> clear() => _storage.deleteAll();
}
