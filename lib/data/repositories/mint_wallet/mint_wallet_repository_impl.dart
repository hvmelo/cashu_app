import 'package:cdk_flutter/cdk_flutter.dart';

import '../../../domain/repositories/mint_wallet_repository.dart';

class MintWalletRepositoryImpl extends MintWalletRepository {
  final MultiMintWallet multiMintWallet;

  MintWalletRepositoryImpl({required this.multiMintWallet});

  @override
  Future<void> createWallet(String mintUrl) async {
    await multiMintWallet.createOrGetWallet(mintUrl: mintUrl);
  }

  @override
  Future<Wallet?> getWallet(String mintUrl) async {
    return await multiMintWallet.getWallet(mintUrl: mintUrl);
  }

  @override
  Stream<BigInt> walletBalanceStream(String mintUrl) async* {
    final wallet = await multiMintWallet.getWallet(mintUrl: mintUrl);
    if (wallet == null) {
      yield BigInt.zero;
      return;
    }
    yield* wallet.streamBalance();
  }
}
