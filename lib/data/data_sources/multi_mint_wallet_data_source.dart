import 'dart:io';

import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:path_provider/path_provider.dart';

class MultiMintWalletDataSource {
  late final MultiMintWallet _wallet;

  /// Private constructor to ensure proper initialization
  MultiMintWalletDataSource._(this._wallet);

  static Future<MultiMintWalletDataSource> create() async {
    await CdkFlutter.init(); // Initialize SDK

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

    // Initialize wallet database
    final db = WalletDatabase(path: '${path.path}/wallet.db');

    // Initialize MultiMintWallet
    final wallet = await MultiMintWallet.newFromHexSeed(
      unit: 'sat',
      seed: seed,
      localstore: db,
    );

    return MultiMintWalletDataSource._(wallet);
  }

  MultiMintWallet get wallet => _wallet;

  Stream<BigInt> streamBalance() => _wallet.streamBalance();

  Future<List<Mint>> listMints() => _wallet.listMints();

  Future<void> addMint(String mintUrl) async {
    await _wallet.addMint(mintUrl: mintUrl);
  }

  Future<void> removeMint(String mintUrl) async {
    await _wallet.removeMint(mintUrl: mintUrl);
  }

  Future<Wallet?> getMintWallet(String mintUrl) async {
    return await _wallet.getWallet(mintUrl: mintUrl);
  }

  Future<Wallet> createOrGetMintWallet(String mintUrl) async {
    return await _wallet.createOrGetWallet(mintUrl: mintUrl);
  }
}
