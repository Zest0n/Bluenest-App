/// Developer switches. Remove / set to false before release.
class DevConfig {
  /// When true, skips authentication & API calls with mock data.
  /// Set to false to attach real APIs everywhere for beta testing and APK builds.
  static bool bypassLogin = false;
}
