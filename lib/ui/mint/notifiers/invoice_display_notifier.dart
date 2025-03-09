import 'package:cashu_app/config/app_providers.dart';
import 'package:cashu_app/utils/result.dart';
import 'package:cdk_flutter/cdk_flutter.dart' hide Error;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../config/cashu_providers.dart';

part 'invoice_display_notifier.freezed.dart';
part 'invoice_display_notifier.g.dart';

/// Notifier for the invoice display
@riverpod
class InvoiceDisplayNotifier extends _$InvoiceDisplayNotifier {
  @override
  InvoiceDisplayState build(BigInt amount) {
    final currentMint = ref.watch(currentMintProvider);

    if (currentMint == null) {
      throw Exception('No mint selected');
    }

    final mintQuoteAsync =
        ref.watch(mintQuoteStreamProvider(currentMint.url, amount));

    switch (mintQuoteAsync) {
      case AsyncData(value: final result):
        switch (result) {
          case Ok(:final value):
            return InvoiceDisplayState(
              invoice: value.request,
              isIssued: value.state == MintQuoteState.issued,
              isLoading: false,
              error: null,
            );
          case Error(:final error):
            return InvoiceDisplayState(
              invoice: null,
              isIssued: false,
              isLoading: false,
              error: InvoiceDisplayError.mintQuoteError(error),
            );
        }
      case AsyncError(:final error):
        return InvoiceDisplayState(
          invoice: null,
          isIssued: false,
          isLoading: false,
          error: InvoiceDisplayError.mintQuoteError(error),
        );
      default:
        return InvoiceDisplayState(
          invoice: null,
          isIssued: false,
          isLoading: true,
          error: null,
        );
    }
  }
}

/// State for the invoice display
@freezed
class InvoiceDisplayState with _$InvoiceDisplayState {
  const InvoiceDisplayState._();

  factory InvoiceDisplayState({
    required String? invoice,
    required bool isLoading,
    required bool isIssued,
    required InvoiceDisplayError? error,
  }) = _InvoiceDisplayState;
}

@freezed
sealed class InvoiceDisplayError with _$InvoiceDisplayError {
  const InvoiceDisplayError._();
  factory InvoiceDisplayError.mintQuoteError(Object error) = MintQuoteError;
}
