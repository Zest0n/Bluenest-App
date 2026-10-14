import '../core/api_constants.dart';
import 'api_service.dart';
import 'token_storage.dart';

class AuthService {
  /// Returns null on success, or an error message.
  static Future<String?> login({
    required String username,
    required String password,
    required String role,
  }) async {
    final res = await ApiService.post(ApiConstants.login, {
      'username': username,
      'password': password,
    });
    if (!res.ok) return res.errorMessage;

    await TokenStorage.save(
      access: res.data['access'],
      refresh: res.data['refresh'],
      role: role,
    );
    return null;
  }

  /// Returns null on success, or an error message.
  static Future<String?> register({
    required String username,
    required String email,
    required String phone,
    required String firstName,
    required String lastName,
    required String password,
    required String password2,
    required String role, // 'tenant' or 'landlord'
  }) async {
    final res = await ApiService.post(ApiConstants.register, {
      'username': username,
      'email': email,
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
      'password2': password2,
      'role': role,
    });
    return res.ok ? null : res.errorMessage;
  }
}
