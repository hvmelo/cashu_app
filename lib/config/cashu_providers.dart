import 'dart:io';

import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cashu_providers.g.dart';

@riverpod
Future<String> seed(Ref ref) async {
  final path = await getApplicationDocumentsDirectory();
  final seedFile = File('${path.path}/seed.txt');
  String seed;
  if (await seedFile.exists()) {
    seed = await seedFile.readAsString();
  } else {
    seed = generateHexSeed();
    await seedFile.writeAsString(seed);
  }
  return seed;
}

@riverpod
Future<WalletDatabase> walletDatabase(Ref ref) async {
  // Initialize the wallet database
  final path = await getApplicationDocumentsDirectory();
  final db = WalletDatabase(path: '${path.path}/wallet.db');
  return db;
}

@riverpod
Future<MultiMintWallet> multiMintWallet(Ref ref) async {
  final seed = await ref.watch(seedProvider.future);
  final db = await ref.watch(walletDatabaseProvider.future);
  final multiMintWallet = await MultiMintWallet.newFromHexSeed(
    unit: 'sat',
    seed: seed,
    localstore: db,
  );
  return multiMintWallet;
}

@riverpod
class MultiMintWalletBalanceStream extends _$MultiMintWalletBalanceStream {
  @override
  Stream<BigInt> build() async* {
    final multiMintWallet = await ref.watch(multiMintWalletProvider.future);
    yield* multiMintWallet.streamBalance();
  }
}

@riverpod
Future<List<Mint>> listWalletMints(Ref ref) async {
  final multiMintWallet = await ref.watch(multiMintWalletProvider.future);
  final mints = await multiMintWallet.listMints();
  return mints;
}

@riverpod
Future<Wallet> mintWallet(Ref ref, String mintUrl) async {
  final multiMintWallet = await ref.watch(multiMintWalletProvider.future);
  final wallet = await multiMintWallet.createOrGetWallet(mintUrl: mintUrl);
  return wallet;
}

@riverpod
class MintBalanceStream extends _$MintBalanceStream {
  @override
  Stream<BigInt> build(String mintUrl) async* {
    final wallet = await ref.watch(mintWalletProvider(mintUrl).future);
    yield* wallet.streamBalance();
  }
}

@riverpod
class MintQuoteStream extends _$MintQuoteStream {
  @override
  Stream<MintQuote> build(String mintUrl, BigInt amount) async* {
    final mintWallet = await ref.watch(mintWalletProvider(mintUrl).future);
    yield* mintWallet.mint(amount: amount);
  }
}
