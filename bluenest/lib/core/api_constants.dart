class ApiConstants {
  /// Teammate's backend on Render:
  /// https://team-blue-backend.onrender.com/
  static const String _defaultUrl = 'https://team-blue-backend.onrender.com';

  static String get baseUrl {
    const fromEnv =
        String.fromEnvironment('BASE_URL', defaultValue: _defaultUrl);
    return fromEnv.endsWith('/')
        ? fromEnv.substring(0, fromEnv.length - 1)
        : fromEnv;
  }

  // Accounts
  static const String login = '/api/accounts/login/';
  static const String register = '/api/accounts/register/';

  // Listings  (all from the shared Postman collection)
  static const String properties = '/api/listing/properties/'; // GET list
  static const String createProperty = '/api/listing/properties/create/'; // POST
  static String property(int id) => '/api/listing/properties/$id/'; // GET
  static String updateProperty(int id) => '/api/listing/properties/$id/update/'; // PUT
  static String partialUpdateProperty(int id) =>
      '/api/listing/properties/$id/partial-update/'; // PATCH
  static String deleteProperty(int id) => '/api/listing/properties/$id/delete/'; // DELETE
}
