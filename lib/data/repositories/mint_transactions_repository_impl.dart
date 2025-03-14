import 'package:cdk_flutter/cdk_flutter.dart' as cdk;

import '../../core/types/types.dart';
import '../../domain/failures/mint_transactions_failures.dart';
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
  Stream<Result<MintQuote, MintQuoteStreamFailure>> mintQuoteStream(
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
      yield Result.error(MintQuoteStreamFailure.unknown(e));
    }
  }

  @override
  Future<Result<MeltQuote, MeltQuoteFailure>> meltQuote(
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
      return Result.error(MeltQuoteFailure.unknown(e));
    }
  }

  @override
  Future<Result<BigInt, MeltFailure>> melt(
      String mintUrl, MeltQuote quote) async {
    try {
      final mintWallet = await multiMintWalletDataSource.getMintWallet(mintUrl);
      if (mintWallet == null) {
        return Result.error(MeltFailure.unknown(Exception('Wallet not found')));
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
      return Result.error(MeltFailure.unknown(e));
    }
  }

  @override
  Future<Result<Unit, SendFailure>> send(String mintUrl, String amount) async {
    return Result.ok(unit);
  }

  @override
  Future<Result<Unit, ReceiveFailure>> receive(
      String mintUrl, String amount) async {
    return Result.ok(unit);
  }
}
