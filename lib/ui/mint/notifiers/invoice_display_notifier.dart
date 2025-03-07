import 'package:cashu_app/config/providers.dart';
import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'invoice_display_notifier.freezed.dart';
part 'invoice_display_notifier.g.dart';

/// Notifier for the invoice display
@riverpod
class InvoiceDisplayNotifier extends _$InvoiceDisplayNotifier {
  @override
  InvoiceDisplayState build(BigInt amount) {
    final mintQuoteAsync = ref.watch(mintQuoteStreamProvider(amount));

    return switch (mintQuoteAsync) {
      AsyncData(:final value) => InvoiceDisplayState(
          invoice: value.request,
          isIssued: value.state == MintQuoteState.issued,
          isLoading: false,
          error: null,
        ),
      AsyncError(:final error) => InvoiceDisplayState(
          invoice: null,
          isIssued: false,
          isLoading: false,
          error: InvoiceDisplayError.mintQuoteError(error),
        ),
      _ => InvoiceDisplayState(
          invoice: null,
          isIssued: false,
          isLoading: true,
          error: null,
        ),
    };
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
