/// A property from /api/listing/properties/.
///
/// Known fields (from the Postman responses): id, title, description, city,
/// locality, bhk, size_sqft, created_at, updated_at. Anything else the backend
/// sends is kept in [raw] and shown automatically in [extraFields], so new
/// backend fields appear on the details screen without code changes.
class Property {
  final int id;
  final String title;
  final String description;
  final String city;
  final String locality;
  final int? bhk;
  final double? sizeSqft;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic> raw;

  const Property({
    required this.id,
    required this.title,
    required this.description,
    required this.city,
    required this.locality,
    this.bhk,
    this.sizeSqft,
    this.createdAt,
    this.updatedAt,
    this.raw = const {},
  });

  factory Property.fromJson(Map<String, dynamic> j) {
    return Property(
      id: (j['id'] as num?)?.toInt() ?? 0,
      title: j['title']?.toString() ?? '',
      description: j['description']?.toString() ?? '',
      city: j['city']?.toString() ?? '',
      locality: j['locality']?.toString() ?? '',
      bhk: int.tryParse(j['bhk']?.toString() ?? ''),
      sizeSqft: double.tryParse(j['size_sqft']?.toString() ?? ''),
      createdAt: DateTime.tryParse(j['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(j['updated_at']?.toString() ?? ''),
      raw: j,
    );
  }

  String get location =>
      [locality, city].where((s) => s.trim().isNotEmpty).join(', ');

  /// Monthly rent, if the backend sends it under a common key.
  /// TODO: replace with the real field name once confirmed.
  num? get rent {
    for (final k in ['rent', 'monthly_rent', 'rent_amount', 'price', 'expected_rent']) {
      final v = num.tryParse(raw[k]?.toString() ?? '');
      if (v != null) return v;
    }
    return null;
  }

  static const _known = {
    'id', 'title', 'description', 'city', 'locality', 'bhk',
    'size_sqft', 'created_at', 'updated_at',
  };

  /// Every other field the API returned, as label -> text.
  Map<String, String> get extraFields {
    final out = <String, String>{};
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
