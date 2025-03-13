import 'package:cashu_app/config/app_config.dart';
import 'package:cashu_app/core/core_providers.dart';
import 'package:cashu_app/data/data_providers.dart';
import 'package:cashu_app/utils/provider_logger.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain/value_objects/value_objects.dart';
import 'main.dart';

/// Staging config entry point.
/// Launch with `flutter run --target lib/main_staging.dart`.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app configuration for staging mode
  AppConfig.init(environment: AppEnvironment.staging, useMocks: false);

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
  final mintRepository = await container.read(mintRepositoryProvider.future);
  await mintRepository.addMint(
    MintUrl.fromData('https://mint.refugio.com.br'),
    nickname: MintNickname.fromData('Refugio'),
  );
  await mintRepository.addMint(
    MintUrl.fromData('https://testnut.cashu.space'),
    nickname: MintNickname.fromData('Testnut'),
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MainApp(),
    ),
  );
}
