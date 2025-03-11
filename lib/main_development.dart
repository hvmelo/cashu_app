import 'package:cashu_app/core/core_providers.dart';
import 'package:cashu_app/data/data_providers.dart';
import 'package:cashu_app/utils/provider_logger.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

/// Development config entry point.
/// Launch with `flutter run --target lib/main_development.dart`.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Create a provider container with overrides
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
    ],
    observers: [ProviderLogger()],
  );

  // Add initial mints to the user mints repository
  final mintRepository = container.read(mintRepositoryProvider);
  await mintRepository.addMint(
    'https://mint.refugio.com.br',
    nickName: 'Refugio',
  );
  await mintRepository.addMint(
    'https://testnut.cashu.space',
    nickName: 'Testnut',
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MainApp(),
    ),
  );
}
