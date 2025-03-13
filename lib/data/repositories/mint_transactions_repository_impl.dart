import 'package:cdk_flutter/cdk_flutter.dart' as cdk;

import '../../core/types/types.dart';
import '../../domain/models/models.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/value_objects/value_objects.dart';
import '../data_sources/multi_mint_wallet_data_source.dart';

class MintTransactionsRepositoryImpl extends MintTransactionsRepository {
  final MultiMintWalletDataSource multiMintWalletDataSource;

  MintTransactionsRepositoryImpl({
    required this.multiMintWalletDataSource,
  });

  @override
  Stream<Result<MintQuote, Failure>> mintQuoteStream(
      String mintUrl, MintAmount amount) async* {
    try {
      final mintWallet =
          await multiMintWalletDataSource.createOrGetMintWallet(mintUrl);
      yield* mintWallet.mint(amount: amount.value).map((cdkQuote) => Result.ok(
            MintQuote(
              id: cdkQuote.id,
              amount: amount,
              request: cdkQuote.request,
              isIssued: cdkQuote.state == cdk.MintQuoteState.issued,
            ),
          ));
    } catch (e) {
      yield Result.error(Failure(e));
    }
  }

  @override
  Future<Result<MeltQuote, Failure>> meltQuote(
      String mintUrl, String request) async {
    try {
      final mintWallet =
          await multiMintWalletDataSource.createOrGetMintWallet(mintUrl);
      final result = await mintWallet.meltQuote(request: request);
      return Result.ok(
        MeltQuote(
          id: result.id,
          amount: result.amount,
          request: result.request,
          feeReserve: result.feeReserve,
          expiry: result.expiry,
        ),
      );
    } catch (e) {
      return Result.error(Failure(e));
    }
  }

  @override
  Future<Result<BigInt, Failure>> melt(String mintUrl, MeltQuote quote) async {
    try {
      final mintWallet = await multiMintWalletDataSource.getMintWallet(mintUrl);
      if (mintWallet == null) {
        return Result.error(Failure(Exception('Wallet not found')));
      }

      final cdkQuote = cdk.MeltQuote(
        id: quote.id,
        amount: quote.amount,
        request: quote.request,
        feeReserve: quote.feeReserve,
        expiry: quote.expiry,
      );
      final result = await mintWallet.melt(quote: cdkQuote);
      return Result.ok(result);
    } catch (e) {
      return Result.error(Failure(e));
    }
  }

  @override
  Future<Result<Unit, Failure>> send(String mintUrl, String amount) async {
    return Result.ok(unit);
  }

  @override
  Future<Result<Unit, Failure>> receive(String mintUrl, String amount) async {
    return Result.ok(unit);
  }
}
