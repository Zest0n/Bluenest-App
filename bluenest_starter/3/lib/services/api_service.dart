import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/api_constants.dart';
import '../core/app_navigator.dart';
import 'token_storage.dart';

class ApiResponse {
  final int statusCode;
  final dynamic data; // decoded JSON, or null for empty bodies (e.g. 204)
  ApiResponse(this.statusCode, this.data);

  bool get ok => statusCode >= 200 && statusCode < 300;

  /// Turns Django/DRF error bodies into one readable string.
  String get errorMessage {
    final d = data;
    if (d is Map) {
      if (d['error'] != null) return d['error'].toString();
      if (d['detail'] != null) return d['detail'].toString();
      return d.entries.map((e) {
        final v = e.value is List ? (e.value as List).join(', ') : e.value;
        return '${e.key}: $v';
      }).join('\n');
    }
    if (d is List && d.isNotEmpty) return d.join('\n');
    return 'Something went wrong (code $statusCode)';
  }
}

class ApiService {
  // Render's free tier can take a while to wake up.
  static const _timeout = Duration(seconds: 60);

  static Future<ApiResponse> get(String path, {bool auth = true}) =>
      _send('GET', path, null, auth);

  static Future<ApiResponse> post(String path, Map<String, dynamic> body,
          {bool auth = false}) =>
      _send('POST', path, body, auth);

  static Future<ApiResponse> put(String path, Map<String, dynamic> body,
          {bool auth = true}) =>
      _send('PUT', path, body, auth);

  static Future<ApiResponse> patch(String path, Map<String, dynamic> body,
          {bool auth = true}) =>
      _send('PATCH', path, body, auth);

  static Future<ApiResponse> delete(String path, {bool auth = true}) =>
      _send('DELETE', path, null, auth);

  static Future<ApiResponse> _send(
    String method,
    String path,
    Map<String, dynamic>? body,
    bool auth,
  ) async {
    final headers = <String, String>{'Accept': 'application/json'};
    if (body != null) headers['Content-Type'] = 'application/json';
    if (auth) {
      final token = await TokenStorage.access;
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }

    try {
      final request = http.Request(method, Uri.parse('${ApiConstants.baseUrl}$path'))
        ..headers.addAll(headers);
      if (body != null) request.body = jsonEncode(body);

      final streamed = await request.send().timeout(_timeout);
      final res = await http.Response.fromStream(streamed);

      if (auth && res.statusCode == 401) {
        AppNavigator.sessionExpired();
      }
      return ApiResponse(res.statusCode, _decode(res.body, res.statusCode));
    } on TimeoutException {
      return ApiResponse(0, {
        'error': 'The server took too long to respond. It may be waking up - please try again.'
      });
    } catch (e) {
      return ApiResponse(0, {
        'error': 'Could not reach the server. Check your internet connection. '
            '(In Chrome this can also mean the backend has not enabled CORS.)'
      });
    }
  }

  static dynamic _decode(String body, int status) {
    if (body.trim().isEmpty) return null;
    try {
      return jsonDecode(body);
    } catch (_) {
      return {'error': 'Unexpected server response (HTTP $status)'};
    }
  }
}
