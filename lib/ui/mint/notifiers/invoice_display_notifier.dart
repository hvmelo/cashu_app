import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/types/result.dart';
import '../../../domain/models/mint_quote.dart';
import '../../../domain/value_objects/value_objects.dart';
import '../../core/notifiers/current_mint_notifier.dart';
import '../../providers/mint_providers.dart';

part 'invoice_display_notifier.g.dart';

/// Notifier for the invoice display
@riverpod
class InvoiceDisplayNotifier extends _$InvoiceDisplayNotifier {
  @override
  Future<MintQuote> build(MintAmount amount) async {
    final currentMint = await ref.watch(currentMintNotifierProvider.future);
    if (currentMint == null) {
      throw Exception('A mint should be selected at this point');
    }

    final mintQuoteResult = await ref.watch(mintQuoteStreamProvider(
      currentMint.url,
      amount,
    ).future);

    switch (mintQuoteResult) {
      case Ok(value: final mintQuote):
        return mintQuote;
      case Error(:final error):
        throw Exception('Failed to get mint quote: $error');
    }
  }
}
