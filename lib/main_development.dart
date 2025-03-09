import 'dart:io';

import 'package:cashu_app/config/app_providers.dart';
import 'package:cashu_app/config/cashu_providers.dart';
import 'package:cashu_app/domain/models/user_mint.dart';
import 'package:cashu_app/utils/provider_logger.dart';
import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

/// Development config entry point.
/// Launch with `flutter run --target lib/main_development.dart`.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CdkFlutter.init();

  final path = await getApplicationDocumentsDirectory();

  // Create a seed file if it doesn't exist
  final seedFile = File('${path.path}/seed.txt');
  String seed;
  if (await seedFile.exists()) {
    seed = await seedFile.readAsString();
  } else {
    seed = generateHexSeed();
    await seedFile.writeAsString(seed);
  }

  // Initialize the wallet database
  final db = WalletDatabase(path: '${path.path}/wallet.db');

  // Initialize the multi-mint wallet
  final multiMintWallet = await MultiMintWallet.newFromHexSeed(
    unit: 'sat',
    seed: seed,
    localstore: db,
  );

  // Initialize the shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Create a provider container with overrides
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
      multiMintWalletProvider.overrideWith((ref) => multiMintWallet),
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
      await container
          .read(addMintUseCaseProvider)
          .execute(mint.url, nickName: mint.nickName);
    }
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MainApp(),
    ),
  );
}
