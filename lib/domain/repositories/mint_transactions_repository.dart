import '../../core/types/types.dart';
import '../models/models.dart';
import '../value_objects/value_objects.dart';

abstract class MintTransactionsRepository {
  Future<Result<MeltQuote, Failure>> meltQuote(String mintUrl, String request);
  Future<Result<BigInt, Failure>> melt(String mintUrl, MeltQuote quote);
  Future<Result<Unit, Failure>> send(String mintUrl, String amount);
  Future<Result<Unit, Failure>> receive(String mintUrl, String amount);
  Stream<Result<MintQuote, Failure>> mintQuoteStream(
      String mintUrl, MintAmount amount);
}
