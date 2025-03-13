import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/value_objects.dart';

part 'mint_quote.freezed.dart';

@freezed
class MintQuote with _$MintQuote {
  const factory MintQuote({
    required String id,
    required String request,
    required MintAmount amount,
    required bool isIssued,
  }) = _MintQuote;
}
