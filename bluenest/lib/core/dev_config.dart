/// Developer switches. Remove / set to false before release.
class DevConfig {
  /// When true, pressing "Log in" on the auth screen skips validation and the
  /// API call and goes straight to the tenant / landlord dashboard.
  ///
  /// To restore real login: set this to false
  /// (or delete the `bypassLogin` block in auth_screen.dart's _submit()).
  static const bool bypassLogin = true;
}
