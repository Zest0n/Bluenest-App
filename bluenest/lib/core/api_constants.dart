class ApiConstants {
  /// Change this ONE line when you get your Render URL, e.g.
  /// 'https://bluenest-api.onrender.com'
  ///
  /// 10.0.2.2 = your computer's localhost as seen from the Android emulator.
  /// - Android emulator : http://10.0.2.2:8000
  /// - iOS simulator    : http://127.0.0.1:8000
  /// - Real phone       : http://<your-laptop-LAN-IP>:8000
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  // Accounts
  static const String login = '/api/accounts/login/';
  static const String register = '/api/accounts/register/';

  // Listings
  static const String createProperty = '/api/listing/properties/create/';
}
