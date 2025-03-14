import 'package:freezed_annotation/freezed_annotation.dart';

part 'mint_transactions_failures.freezed.dart';

@freezed
class MeltQuoteFailure with _$MeltQuoteFailure {
  const factory MeltQuoteFailure.unknown(Object error,
      {StackTrace? stackTrace}) = MeltQuoteUnknown;
}

@freezed
class MeltFailure with _$MeltFailure {
  const factory MeltFailure.unknown(Object error, {StackTrace? stackTrace}) =
      MeltUnknown;
}

@freezed
class SendFailure with _$SendFailure {
  const factory SendFailure.unknown(Object error, {StackTrace? stackTrace}) =
      SendUnknown;
}

@freezed
class ReceiveFailure with _$ReceiveFailure {
  const factory ReceiveFailure.unknown(Object error, {StackTrace? stackTrace}) =
      ReceiveUnknown;
}

@freezed
class MintQuoteStreamFailure with _$MintQuoteStreamFailure {
  const factory MintQuoteStreamFailure.unknown(Object error,
      {StackTrace? stackTrace}) = MintQuoteStreamUnknown;
}
