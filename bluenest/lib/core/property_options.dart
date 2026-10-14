/// Allowed values for the dropdown fields.
/// TODO: confirm the full lists with the backend. From the Postman docs we only
/// know: property_type "apartment", furnishing_status "unfurnished",
/// tenant_preference "family". The rest are best guesses - edit them here.
class PropertyOptions {
  static const propertyTypes = ['apartment', 'house', 'villa', 'studio'];
  static const furnishing = ['unfurnished', 'semi_furnished', 'furnished'];
  static const tenantPreference = ['family', 'bachelor', 'any'];

  /// "semi_furnished" -> "Semi furnished"
  static String label(String v) {
    if (v.isEmpty) return v;
    final s = v.replaceAll('_', ' ');
    return s[0].toUpperCase() + s.substring(1);
  }

  /// Makes sure the value already saved on a property is selectable.
  static List<String> withCurrent(List<String> base, String? current) {
    if (current == null || current.isEmpty || base.contains(current)) return base;
    return [...base, current];
  }
}
