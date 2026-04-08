class AppConstants {
  AppConstants._();

  static const String appName     = 'Sarkari Next';
  static const String appVersion  = '1.0.0';

  // Cache TTLs
  static const int examCacheTtlHours     = 24;
  static const int blogCacheTtlMinutes   = 60;
  static const int sarkariCacheTtlMins   = 30;

  // Pagination
  static const int defaultPageSize = 10;

  // Hive boxes
  static const String userBox    = 'user_box';
  static const String cacheBox   = 'cache_box';
  static const String settingsBox= 'settings_box';
}