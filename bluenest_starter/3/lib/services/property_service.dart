import '../core/api_constants.dart';
import '../models/property.dart';
import 'api_service.dart';

class Result<T> {
  final T? data;
  final String? error;
  const Result.ok(this.data) : error = null;
  const Result.fail(this.error) : data = null;
  bool get ok => error == null;
}

class PropertyService {
  /// GET /api/listing/properties/
  static Future<Result<List<Property>>> list() async {
    final res = await ApiService.get(ApiConstants.properties);
    if (!res.ok) return Result.fail(res.errorMessage);

    final d = res.data;
    List raw = [];
    if (d is List) {
      raw = d;
    } else if (d is Map) {
      final inner = d['results'] ?? d['data']; // paginated or wrapped
      if (inner is List) raw = inner;
    }
    return Result.ok(raw
        .whereType<Map>()
        .map((m) => Property.fromJson(Map<String, dynamic>.from(m)))
        .toList());
  }

  /// GET /api/listing/properties/{id}/
  static Future<Result<Property>> get(int id) async =>
      _single(await ApiService.get(ApiConstants.property(id)));

  /// POST /api/listing/properties/create/
  static Future<Result<Property>> create(Map<String, dynamic> body) async =>
      _single(await ApiService.post(ApiConstants.createProperty, body, auth: true));

  /// PUT /api/listing/properties/{id}/update/  (full update)
  static Future<Result<Property>> update(int id, Map<String, dynamic> body) async =>
      _single(await ApiService.put(ApiConstants.updateProperty(id), body));

  /// PATCH /api/listing/properties/{id}/partial-update/
  static Future<Result<Property>> partialUpdate(int id, Map<String, dynamic> body) async =>
      _single(await ApiService.patch(ApiConstants.partialUpdateProperty(id), body));

  /// DELETE /api/listing/properties/{id}/delete/  (204 No Content)
  static Future<Result<bool>> delete(int id) async {
    final res = await ApiService.delete(ApiConstants.deleteProperty(id));
    return res.ok ? const Result.ok(true) : Result.fail(res.errorMessage);
  }

  /// Create returns {"message":..., "data": {...}}; get/update return the object.
  static Result<Property> _single(ApiResponse res) {
    if (!res.ok) return Result.fail(res.errorMessage);
    final d = res.data;
    final m = (d is Map && d['data'] is Map) ? d['data'] : d;
    if (m is! Map) return const Result.fail('Unexpected response from server');
    return Result.ok(Property.fromJson(Map<String, dynamic>.from(m)));
  }
}
