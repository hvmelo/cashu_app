import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/types/result.dart';
import '../../../domain/models/mint_quote.dart';
import '../../../domain/value_objects/value_objects.dart';
import '../../core/notifiers/current_mint_notifier.dart';
import '../../core/providers/mint_providers.dart';

part 'invoice_display_notifier.g.dart';

/// Notifier for the invoice display
@riverpod
class InvoiceDisplayNotifier extends _$InvoiceDisplayNotifier {
  @override
  Stream<MintQuote> build(MintAmount amount) async* {
    final currentMint = await ref.watch(currentMintNotifierProvider.future);
    if (currentMint == null) {
      throw Exception('A mint should be selected at this point');
    }

    // Observa o stream de mintQuote
    final stream = ref.watch(mintQuoteStreamProvider(
      currentMint.url,
      amount,
    ));

    // Transforma AsyncValue<Result<MintQuote, Error>> em Stream<MintQuote>
    // utilizando o padrão de yield* para delegar ao stream subjacente
    yield* stream.when(
      data: (result) async* {
        switch (result) {
          case Ok(value: final mintQuote):
            yield mintQuote;
            break;
          case Error(:final error):
            throw error;
        }
      },
      loading: () async* {
        // Nada a emitir enquanto estiver carregando
      },
      error: (error, stack) async* {
        throw error;
      },
    );
  }
}
