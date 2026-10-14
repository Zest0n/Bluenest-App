import '../core/api_constants.dart';
import '../core/dev_config.dart';
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
  static final List<Property> _mockProperties = [
    Property(
      id: 1,
      title: 'Luxury 3 BHK Apartment in Indiranagar',
      description:
          'Spacious and well-ventilated 3 BHK apartment with modern amenities, 24/7 security, power backup, covered car parking, and modular kitchen. Close to metro and vibrant cafes.',
      propertyType: 'apartment',
      address: '100 Feet Road, Indiranagar',
      city: 'Bangalore',
      locality: 'Indiranagar',
      bhk: 3,
      bathrooms: 3,
      sizeSqft: 1850,
      floor: 4,
      furnishingStatus: 'furnished',
      tenantPreference: 'family',
      askingRent: 45000,
      imageUrl: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=600',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Property(
      id: 2,
      title: 'Modern 2 BHK Flat near IT Park',
      description:
          'Well-maintained 2 BHK apartment near tech parks. Semi-furnished with wardrobes, geysers, modular kitchen, and balcony with open views.',
      propertyType: 'apartment',
      address: 'Outer Ring Road, Marathahalli',
      city: 'Bangalore',
      locality: 'Marathahalli',
      bhk: 2,
      bathrooms: 2,
      sizeSqft: 1200,
      floor: 2,
      furnishingStatus: 'semi_furnished',
      tenantPreference: 'any',
      askingRent: 28000,
      imageUrl: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=600',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Property(
      id: 3,
      title: 'Cozy 1 BHK Studio for Working Professionals',
      description:
          'Fully furnished studio apartment ideal for single professionals. High-speed internet enabled, gym and club access included.',
      propertyType: 'studio',
      address: 'Koramangala 5th Block',
      city: 'Bangalore',
      locality: 'Koramangala',
      bhk: 1,
      bathrooms: 1,
      sizeSqft: 650,
      floor: 1,
      furnishingStatus: 'furnished',
      tenantPreference: 'bachelor',
      askingRent: 18000,
      imageUrl: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=600',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Property(
      id: 4,
      title: 'Independent 4 BHK Villa with Garden',
      description:
          'Independent duplex villa with private garden, terrace, servant quarters, and solar water heater in a secure gated community.',
      propertyType: 'villa',
      address: 'Whitefield Main Road',
      city: 'Bangalore',
      locality: 'Whitefield',
      bhk: 4,
      bathrooms: 4,
      sizeSqft: 3200,
      floor: 1,
      furnishingStatus: 'unfurnished',
      tenantPreference: 'family',
      askingRent: 75000,
      imageUrl: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=600',
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
    ),
  ];

  /// GET /api/listing/properties/
  static Future<Result<List<Property>>> list() async {
    if (DevConfig.bypassLogin) {
      await Future.delayed(const Duration(milliseconds: 300));
      return Result.ok(List<Property>.from(_mockProperties));
    }

    final res = await ApiService.get(ApiConstants.properties);
    if (!res.ok) return Result.fail(res.errorMessage);

    final d = res.data;
    List raw = [];
    if (d is List) {
      raw = d;
    } else if (d is Map) {
      final inner = d['results'] ?? d['data']; // paginated or wrapped
      if (inner is List) {
        raw = inner;
      } else if (d['id'] != null) {
        raw = [d];
      }
    }
    return Result.ok(raw
        .whereType<Map>()
        .map((m) => Property.fromJson(Map<String, dynamic>.from(m)))
        .toList());
  }

  /// GET /api/listing/properties/{id}/
  static Future<Result<Property>> get(int id) async {
    if (DevConfig.bypassLogin) {
      await Future.delayed(const Duration(milliseconds: 200));
      final found = _mockProperties.where((p) => p.id == id);
      if (found.isNotEmpty) return Result.ok(found.first);
      if (_mockProperties.isNotEmpty) return Result.ok(_mockProperties.first);
      return const Result.fail('Property not found');
    }
    return _single(await ApiService.get(ApiConstants.property(id)));
  }

  /// POST /api/listing/properties/create/
  static Future<Result<Property>> create(Map<String, dynamic> body) async {
    if (DevConfig.bypassLogin) {
      await Future.delayed(const Duration(milliseconds: 300));
      final newId = (_mockProperties.map((p) => p.id).fold(0, (a, b) => a > b ? a : b)) + 1;
      final newProperty = Property(
        id: newId,
        title: body['title']?.toString() ?? 'New Property',
        description: body['description']?.toString() ?? '',
        propertyType: body['property_type']?.toString() ?? 'apartment',
        address: body['address']?.toString() ?? '',
        city: body['city']?.toString() ?? '',
        locality: body['locality']?.toString() ?? '',
        bhk: int.tryParse(body['bhk']?.toString() ?? ''),
        bathrooms: int.tryParse(body['bathrooms']?.toString() ?? ''),
        sizeSqft: double.tryParse(body['size_sqft']?.toString() ?? ''),
        floor: int.tryParse(body['floor']?.toString() ?? ''),
        furnishingStatus: body['furnishing_status']?.toString() ?? 'unfurnished',
        tenantPreference: body['tenant_preference']?.toString() ?? 'any',
        askingRent: num.tryParse(body['asking_rent']?.toString() ?? ''),
        imageUrl: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=600',
        createdAt: DateTime.now(),
        raw: body,
      );
      _mockProperties.insert(0, newProperty);
      return Result.ok(newProperty);
    }
    return _single(await ApiService.post(ApiConstants.createProperty, body, auth: true));
  }

  /// PUT /api/listing/properties/{id}/update/  (full update)
  static Future<Result<Property>> update(int id, Map<String, dynamic> body) async {
    if (DevConfig.bypassLogin) {
      await Future.delayed(const Duration(milliseconds: 300));
      final index = _mockProperties.indexWhere((p) => p.id == id);
      final updated = Property(
        id: id,
        title: body['title']?.toString() ?? (index >= 0 ? _mockProperties[index].title : ''),
        description: body['description']?.toString() ?? (index >= 0 ? _mockProperties[index].description : ''),
        propertyType: body['property_type']?.toString() ?? (index >= 0 ? _mockProperties[index].propertyType : 'apartment'),
        address: body['address']?.toString() ?? (index >= 0 ? _mockProperties[index].address : ''),
        city: body['city']?.toString() ?? (index >= 0 ? _mockProperties[index].city : ''),
        locality: body['locality']?.toString() ?? (index >= 0 ? _mockProperties[index].locality : ''),
        bhk: int.tryParse(body['bhk']?.toString() ?? '') ?? (index >= 0 ? _mockProperties[index].bhk : null),
        bathrooms: int.tryParse(body['bathrooms']?.toString() ?? '') ?? (index >= 0 ? _mockProperties[index].bathrooms : null),
        sizeSqft: double.tryParse(body['size_sqft']?.toString() ?? '') ?? (index >= 0 ? _mockProperties[index].sizeSqft : null),
        floor: int.tryParse(body['floor']?.toString() ?? '') ?? (index >= 0 ? _mockProperties[index].floor : null),
        furnishingStatus: body['furnishing_status']?.toString() ?? (index >= 0 ? _mockProperties[index].furnishingStatus : 'unfurnished'),
        tenantPreference: body['tenant_preference']?.toString() ?? (index >= 0 ? _mockProperties[index].tenantPreference : 'any'),
        askingRent: num.tryParse(body['asking_rent']?.toString() ?? '') ?? (index >= 0 ? _mockProperties[index].askingRent : null),
        imageUrl: index >= 0 ? _mockProperties[index].imageUrl : null,
        createdAt: index >= 0 ? _mockProperties[index].createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
        raw: body,
      );
      if (index >= 0) {
        _mockProperties[index] = updated;
      } else {
        _mockProperties.insert(0, updated);
      }
      return Result.ok(updated);
    }
    return _single(await ApiService.put(ApiConstants.updateProperty(id), body, auth: true));
  }

  /// PATCH /api/listing/properties/{id}/partial-update/
  static Future<Result<Property>> partialUpdate(int id, Map<String, dynamic> body) async {
    if (DevConfig.bypassLogin) return update(id, body);
    return _single(await ApiService.patch(ApiConstants.partialUpdateProperty(id), body, auth: true));
  }

  /// DELETE /api/listing/properties/{id}/delete/  (204 No Content)
  static Future<Result<bool>> delete(int id) async {
    if (DevConfig.bypassLogin) {
      await Future.delayed(const Duration(milliseconds: 200));
      _mockProperties.removeWhere((p) => p.id == id);
      return const Result.ok(true);
    }
    final res = await ApiService.delete(ApiConstants.deleteProperty(id), auth: true);
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
