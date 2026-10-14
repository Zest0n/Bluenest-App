import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/api_constants.dart';
import 'token_storage.dart';

class ApiResponse {
  final int statusCode;
  final dynamic data;
  ApiResponse(this.statusCode, this.data);

  bool get ok => statusCode >= 200 && statusCode < 300;

  /// Turns Django/DRF error bodies into one readable string.
  String get errorMessage {
    final d = data;
    if (d is Map) {
      if (d['error'] != null) return d['error'].toString();
      if (d['detail'] != null) return d['detail'].toString();
      // field errors: {"username": ["already exists"], ...}
      return d.entries.map((e) {
        final v = e.value is List ? (e.value as List).join(', ') : e.value;
        return '${e.key}: $v';
      }).join('\n');
    }
    return 'Something went wrong (code $statusCode)';
  }
}

class ApiService {
  static Future<ApiResponse> post(
    String path,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (auth) {
      final token = await TokenStorage.access;
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    try {
      final res = await http
          .post(
            Uri.parse('${ApiConstants.baseUrl}$path'),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30)); // Render free tier can be slow to wake up
      return ApiResponse(res.statusCode, _decode(res.body));
    } on SocketException {
      return ApiResponse(0, {'error': 'No connection to server'});
    } catch (e) {
      return ApiResponse(0, {'error': 'Request failed: $e'});
    }
  }

  static Future<ApiResponse> get(String path, {bool auth = true}) async {
    final headers = <String, String>{};
    if (auth) {
      final token = await TokenStorage.access;
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    try {
      final res = await http
          .get(Uri.parse('${ApiConstants.baseUrl}$path'), headers: headers)
          .timeout(const Duration(seconds: 30));
      return ApiResponse(res.statusCode, _decode(res.body));
    } catch (e) {
      return ApiResponse(0, {'error': 'Request failed: $e'});
    }
  }

  static dynamic _decode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return {'error': 'Invalid server response'};
    }
  }
}
