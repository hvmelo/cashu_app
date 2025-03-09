import 'package:cashu_app/config/app_providers.dart';
import 'package:cashu_app/domain/models/user_mint.dart';
import 'package:cashu_app/utils/provider_logger.dart';
import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

/// Development config entry point.
/// Launch with `flutter run --target lib/main_development.dart`.
/// Uses test mint.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CdkFlutter.init();

  // final path = await getApplicationDocumentsDirectory();
  // final dbFile = File('${path.path}/wallet.db');
  // if (dbFile.existsSync()) {
  //   dbFile.deleteSync();
  // }
  // Get initial mint URL from the available mints
  final sharedPreferences = await SharedPreferences.getInstance();
  // Create a provider container with overrides
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
    ],
    observers: [ProviderLogger()],
  );

  // Add initial mints to the user mints repository
  final userMintRepository = container.read(userMintRepositoryProvider);

  final userMints = userMintRepository.retrieveAllUserMints();

  if (userMints.isEmpty) {
    final initialMints = [
      UserMint(
        url: 'https://mint.refugio.com.br',
        nickName: 'Refugio',
      ),
      UserMint(
        url: 'https://testnut.cashu.space',
        nickName: 'Testnut',
      ),
    ];
    for (final mint in initialMints) {
      userMintRepository.saveUserMint(mint);
    }
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MainApp(),
    ),
  );
}
