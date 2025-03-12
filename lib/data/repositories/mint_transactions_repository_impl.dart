import 'package:cashu_app/core/types/result.dart';
import 'package:cashu_app/core/types/unit.dart';
import 'package:cashu_app/data/data_sources/multi_mint_wallet_data_source.dart';
import 'package:cashu_app/domain/repositories/mint_transactions_repository.dart';
import 'package:cdk_flutter/cdk_flutter.dart';

class MintTransactionsRepositoryImpl extends MintTransactionsRepository {
  final MultiMintWalletDataSource multiMintWalletDataSource;

  MintTransactionsRepositoryImpl({
    required this.multiMintWalletDataSource,
  });

  @override
  Stream<Result<MintQuote>> mintQuoteStream(
      String mintUrl, BigInt amount) async* {
    try {
      final mintWallet =
          await multiMintWalletDataSource.createOrGetMintWallet(mintUrl);
      yield* mintWallet.mint(amount: amount).map((quote) => Result.ok(quote));
    } catch (e) {
      yield Result.error(e);
    }
  }

  @override
  Future<Result<MeltQuote>> meltQuote(String mintUrl, String request) async {
    try {
      final mintWallet =
          await multiMintWalletDataSource.createOrGetMintWallet(mintUrl);
      final result = await mintWallet.meltQuote(request: request);
      return Result.ok(result);
    } catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<BigInt>> melt(String mintUrl, MeltQuote quote) async {
    final mintWallet = await multiMintWalletDataSource.getMintWallet(mintUrl);
    if (mintWallet == null) {
      return Result.error(Exception('Wallet not found'));
    }
    final result = await mintWallet.melt(quote: quote);
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
