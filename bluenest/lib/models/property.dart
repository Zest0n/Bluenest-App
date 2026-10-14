import '../core/api_constants.dart';
import '../core/property_options.dart';

/// A property from /api/listing/properties/ (fields per the Postman docs).
/// Unknown extra fields stay in [raw] and show up in [detailRows].
class Property {
  final int id;
  final String title;
  final String description;
  final String propertyType;
  final String address;
  final String city;
  final String locality;
  final int? bhk;
  final int? bathrooms;
  final double? sizeSqft;
  final int? floor;
  final String furnishingStatus;
  final String tenantPreference;
  final num? askingRent;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic> raw;

  const Property({
    required this.id,
    required this.title,
    required this.description,
    required this.propertyType,
    required this.address,
    required this.city,
    required this.locality,
    required this.furnishingStatus,
    required this.tenantPreference,
    this.bhk,
    this.bathrooms,
    this.sizeSqft,
    this.floor,
    this.askingRent,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    this.raw = const {},
  });

  factory Property.fromJson(Map<String, dynamic> j) {
    String s(String k) => j[k]?.toString() ?? '';
    return Property(
      id: (j['id'] as num?)?.toInt() ?? 0,
      title: s('title'),
      description: s('description'),
      propertyType: s('property_type'),
      address: s('address'),
      city: s('city'),
      locality: s('locality'),
      bhk: int.tryParse(s('bhk')),
      bathrooms: int.tryParse(s('bathrooms')),
      sizeSqft: double.tryParse(s('size_sqft')),
      floor: int.tryParse(s('floor')),
      furnishingStatus: s('furnishing_status'),
      tenantPreference: s('tenant_preference'),
      askingRent: num.tryParse(s('asking_rent')),
      imageUrl: _resolveImage(j['image']),
      createdAt: DateTime.tryParse(s('created_at')),
      updatedAt: DateTime.tryParse(s('updated_at')),
      raw: j,
    );
  }

  static String? _resolveImage(dynamic v) {
    final s = v?.toString().trim() ?? '';
    if (s.isEmpty) return null;
    if (s.startsWith('http')) return s;
    final base = ApiConstants.baseUrl.replaceAll(RegExp(r'/+$'), '');
    return s.startsWith('/') ? '$base$s' : '$base/$s';
  }

  String get location =>
      [locality, city].where((x) => x.trim().isNotEmpty).join(', ');

  /// Monthly rent shown on cards (backend field: asking_rent).
  num? get rent => askingRent;

  static const _known = {
    'id', 'title', 'description', 'property_type', 'address', 'city',
    'locality', 'bhk', 'bathrooms', 'size_sqft', 'floor', 'furnishing_status',
    'tenant_preference', 'asking_rent', 'image', 'created_at', 'updated_at',
  };

  /// Label -> value rows for the details screen: the known fields first,
  /// then anything else the API returns.
  Map<String, String> get detailRows {
    final out = <String, String>{};
    void add(String label, String? v) {
      if (v != null && v.trim().isNotEmpty) out[label] = v;
    }

    add('Property type', PropertyOptions.label(propertyType));
    add('Address', address);
    add('Bathrooms', bathrooms?.toString());
    add('Floor', floor?.toString());
    add('Furnishing', PropertyOptions.label(furnishingStatus));
    add('Preferred tenants', PropertyOptions.label(tenantPreference));

    raw.forEach((k, v) {
      if (_known.contains(k) || v == null) return;
      final text = v.toString().trim();
      if (text.isEmpty) return;
      final label = k.replaceAll('_', ' ');
      out[label[0].toUpperCase() + label.substring(1)] = text;
    });
    return out;
  }
}
