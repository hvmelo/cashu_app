import '../../core/types/types.dart';
import '../failures/mint_transactions_failures.dart';
import '../models/models.dart';
import '../value_objects/value_objects.dart';

abstract class MintTransactionsRepository {
  Future<Result<MeltQuote, MeltQuoteFailure>> meltQuote(
      String mintUrl, String request);
  Future<Result<BigInt, MeltFailure>> melt(String mintUrl, MeltQuote quote);
  Future<Result<Unit, SendFailure>> send(String mintUrl, String amount);
  Future<Result<Unit, ReceiveFailure>> receive(String mintUrl, String amount);
  Stream<Result<MintQuote, MintQuoteStreamFailure>> mintQuoteStream(
      String mintUrl, MintAmount amount);
}
