import 'package:flutter/foundation.dart';

enum AppEnvironment {
  development,
  staging,
  production,
}

/// Configuration class for the application
class AppConfig {
  static AppEnvironment get environment => _environment;

  /// Whether to use mock implementations instead of real ones
  static bool get useMocks => _useMocks;

  // Private fields
  static bool _useMocks = kDebugMode;
  static final AppEnvironment _environment = AppEnvironment.development;

  /// Initialize the configuration
  static void init({AppEnvironment? environment, bool? useMocks}) {
    if (environment != null) {
      environment = environment;
    }

    if (useMocks != null) {
      _useMocks = useMocks;
    } else {
      // By default, use mocks in development mode
      _useMocks = _environment == AppEnvironment.development;
    }
  }
}
