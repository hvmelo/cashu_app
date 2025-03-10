import 'package:cdk_flutter/cdk_flutter.dart';

abstract class MintWalletRepository {
  Future<void> createWallet(String mintUrl);
  Future<Wallet?> getWallet(String mintUrl);
  Stream<BigInt> walletBalanceStream(String mintUrl);
}
