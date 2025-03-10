import 'package:cashu_app/core/types/result.dart';
import 'package:cashu_app/core/types/unit.dart';
import 'package:cashu_app/domain/repositories/mint_transaction_repository.dart';
import 'package:cdk_flutter/cdk_flutter.dart';

import '../../../domain/repositories/mint_wallet_repository.dart';

class MintTransactionRepositoryImpl extends MintTransactionRepository {
  final MultiMintWallet multiMintWallet;
  final MintWalletRepository mintWalletRepository;

  MintTransactionRepositoryImpl({
    required this.multiMintWallet,
    required this.mintWalletRepository,
  });

  @override
  Stream<Result<Unit>> mintQuoteStream(String mintUrl, BigInt amount) async* {
    final wallet = await mintWalletRepository.getWallet(mintUrl);
    if (wallet == null) {
      yield Result.error(Exception('Wallet not found'));
    } else {
      yield* wallet.mint(amount: amount).map((quote) => Result.ok(unit));
    }
  }

  @override
  Future<Result<MeltQuote>> meltQuote(String mintUrl, String request) async {
    final wallet = await mintWalletRepository.getWallet(mintUrl);
    if (wallet == null) {
      return Result.error(Exception('Wallet not found'));
    }
    final result = await wallet.meltQuote(request: request);
    return Result.ok(result);
  }

  @override
  Future<Result<BigInt>> melt(String mintUrl, MeltQuote quote) async {
    final wallet = await mintWalletRepository.getWallet(mintUrl);
    if (wallet == null) {
      return Result.error(Exception('Wallet not found'));
    }
    final result = await wallet.melt(quote: quote);
    return Result.ok(result);
  }

  @override
  Future<Result<Unit>> send(String mintUrl, String amount) async {
    return Result.ok(unit);
  }

  @override
  Future<Result<Unit>> receive(String mintUrl, String amount) async {
    return Result.ok(unit);
  }
}
