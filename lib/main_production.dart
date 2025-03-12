import 'package:cashu_app/config/app_config.dart';
import 'package:cashu_app/core/core_providers.dart';
import 'package:cashu_app/utils/provider_logger.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

/// Production config entry point.
/// Launch with `flutter run --target lib/main_production.dart`.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app configuration for production mode
  AppConfig.init(environment: AppEnvironment.production, useMocks: false);

  // Initialize the shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Create a provider container with overrides
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
    ],
    observers: [ProviderLogger()],
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MainApp(),
    ),
  );
}
