import 'package:freezed_annotation/freezed_annotation.dart';

part 'melt_quote.freezed.dart';

@freezed
class MeltQuote with _$MeltQuote {
  const factory MeltQuote({
    required String id,
    required String request,
    required BigInt amount,
    required BigInt feeReserve,
    required BigInt expiry,
  }) = _MeltQuote;
}
