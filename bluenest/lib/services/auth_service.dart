import '../core/api_constants.dart';
import 'api_service.dart';
import 'token_storage.dart';
import 'user_service.dart';

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

    final data = res.data is Map ? res.data as Map : {};
    final access = data['access']?.toString() ?? '';
    final refresh = data['refresh']?.toString() ?? '';

    await TokenStorage.save(
      access: access,
      refresh: refresh,
      role: role,
    );

    // Populate user profile
    final saved = await TokenStorage.loadProfile();
    final firstName =
        saved['firstName']?.isNotEmpty == true ? saved['firstName']! : username;
    final lastName = saved['lastName'] ?? '';
    final email = saved['email'] ?? '';
    final phone = saved['phone'] ?? '';

    await TokenStorage.saveProfile(
      username: username,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      role: role,
    );

    UserService.init(
      username: username,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
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
    required String role, // 'tenant' or 'landlord'
  }) async {
    final res = await ApiService.post(ApiConstants.register, {
      'username': username,
      'email': email,
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
      'role': role,
    });
    if (!res.ok) return res.errorMessage;

    // Cache the registered profile details
    await TokenStorage.saveProfile(
      username: username,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      role: role,
    );
    UserService.init(
      username: username,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      role: role,
    );
    return null;
  }
}
