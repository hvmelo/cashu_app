import 'dart:io';

import 'package:cashu_app/config/providers.dart';
import 'package:cashu_app/ui/home/widgets/mint_selector.dart';
import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'main.dart';

/// Development config entry point.
/// Launch with `flutter run --target lib/main_development.dart`.
/// Uses test mint.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CdkFlutter.init();
  final path = await getApplicationDocumentsDirectory();

  final seedFile = File('${path.path}/seed.txt');

  String seed;
  if (await seedFile.exists()) {
    seed = await seedFile.readAsString();
  } else {
    seed = generateHexSeed();
    await seedFile.writeAsString(seed);
  }
  final db = WalletDatabase(path: '${path.path}/wallet.db');

  // https://mint.refugio.com.br
  // https://testnut.cashu.space

  // Get initial mint URL from the available mints
  final initialMintUrl = availableMints[1]; // Default to testnut.cashu.space

  // Create the wallet with the initial mint
  final wallet = Wallet.newFromHexSeed(
      mintUrl: initialMintUrl, unit: 'sat', seed: seed, localstore: db);

  // Create a provider container with overrides
  final container = ProviderContainer(
    overrides: [
      walletProvider.overrideWith((ref) => wallet),
      // Initialize the current mint provider with the wallet's mint URL
      currentMintProvider.overrideWith((ref) => wallet.mintUrl),
    ],
  );

  // Listen to changes in the current mint provider
  container.listen<String>(
    currentMintProvider,
    (previous, next) {
      if (previous != next && previous != null) {
        // Mint URL has changed, recreate the wallet
        final newWallet = Wallet.newFromHexSeed(
          mintUrl: next,
          unit: 'sat',
          seed: seed,
          localstore: db,
        );

        // Update the wallet provider
        container.read(walletProvider.notifier).state = newWallet;
      }
    },
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MainApp(),
    ),
  );
}
