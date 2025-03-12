import 'package:cashu_app/core/types/result.dart';
import 'package:cdk_flutter/cdk_flutter.dart';

import '../../core/types/unit.dart';

abstract class MintTransactionsRepository {
  Future<Result<MeltQuote>> meltQuote(String mintUrl, String request);
  Future<Result<BigInt>> melt(String mintUrl, MeltQuote quote);
  Future<Result<Unit>> send(String mintUrl, String amount);
  Future<Result<Unit>> receive(String mintUrl, String amount);
  Stream<Result<MintQuote>> mintQuoteStream(String mintUrl, BigInt amount);
}
