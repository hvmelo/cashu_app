import 'dart:io';

import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

Future<MultiMintWallet> multiMintWallet(Ref ref) async {
  await CdkFlutter.init(); // Initialize the SDK

  final path = await getApplicationDocumentsDirectory();

  // Create seed file if it doesn't exist
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

  // Initialize the MultiMintWallet
  final wallet = await MultiMintWallet.newFromHexSeed(
    unit: 'sat',
    seed: seed,
    localstore: db,
  );

  return wallet;
}
