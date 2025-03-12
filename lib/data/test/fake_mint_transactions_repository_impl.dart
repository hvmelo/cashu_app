import 'package:cashu_app/core/types/result.dart';
import 'package:cashu_app/core/types/unit.dart';
import 'package:cashu_app/domain/repositories/mint_transactions_repository.dart';
import 'package:cdk_flutter/cdk_flutter.dart';

/// A fake implementation of the MintTransactionsRepository for development and testing
class FakeMintTransactionsRepositoryImpl implements MintTransactionsRepository {
  @override
  Stream<Result<MintQuote>> mintQuoteStream(
      String mintUrl, BigInt amount) async* {
    // Simulate a mint quote stream with a successful quote
    yield Result.ok(MintQuote(
      id: 'mint-quote-id',
      request:
          'lnbc1000n1pj9npjfpp5e0nv0m9k25lauasd8dlgz7h8uaey8j4zn0c699y6jxv8hwj8gpsdqqcqzzsxqyz5vqsp5usxj6u6s46k77g37urfxpla9w7pvyfq6qx37z3fs8vt08dxn8vaq9qyyssqd4jceqk0sk5003k2t465xlz2w94q8kt58z3v4xgec7kujxvqc9t72v5sjq6gjh9tafkah8rt9d4nqw8vk4d9h2pjgqwa5z6cpvf2l8kgqz4545k',
      amount: amount,
      state: MintQuoteState.unpaid,
    ));

    // Wait for 3 seconds and then update the state to paid
    await Future.delayed(const Duration(seconds: 2));
    yield Result.ok(MintQuote(
      id: 'mint-quote-id',
      request:
          'lnbc1000n1pj9npjfpp5e0nv0m9k25lauasd8dlgz7h8uaey8j4zn0c699y6jxv8hwj8gpsdqqcqzzsxqyz5vqsp5usxj6u6s46k77g37urfxpla9w7pvyfq6qx37z3fs8vt08dxn8vaq9qyyssqd4jceqk0sk5003k2t465xlz2w94q8kt58z3v4xgec7kujxvqc9t72v5sjq6gjh9tafkah8rt9d4nqw8vk4d9h2pjgqwa5z6cpvf2l8kgqz4545k',
      amount: amount,
      state: MintQuoteState.issued,
    ));
  }

  @override
  Future<Result<MeltQuote>> meltQuote(String mintUrl, String request) async {
    // Return a mock melt quote
    return Result.ok(MeltQuote(
      id: 'mock-id',
      request: request,
      amount: BigInt.from(100),
      feeReserve: BigInt.from(1),
      expiry: BigInt.from(1000),
    ));
  }

  @override
  Future<Result<BigInt>> melt(String mintUrl, MeltQuote quote) async {
    // Simulate a successful melt
    return Result.ok(quote.amount);
  }

  @override
  Future<Result<Unit>> send(String mintUrl, String amount) async {
    // Simulate a successful send
    return Result.ok(unit);
  }

  @override
  Future<Result<Unit>> receive(String mintUrl, String amount) async {
    // Simulate a successful receive
    return Result.ok(unit);
  }
}
