import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/types/result.dart';
import '../../../core/types/unit.dart';
import '../../../domain/value_objects/mint_amount.dart';

part 'mint_screen_notifier.freezed.dart';
part 'mint_screen_notifier.g.dart';

/// Notifier for the mint screen
@riverpod
class MintScreenNotifier extends _$MintScreenNotifier {
  @override
  FutureOr<MintScreenState> build() async {
    return MintScreenState.editing(
      amount: '0',
      showErrorMessages: false,
    );
  }

  void amountChanged(String amountStr) {
    update((state) =>
        (state as MintScreenEditingState).copyWith(amount: amountStr));
  }

  /// Generates a Lightning invoice for the specified amount
  Future<void> generateInvoice() async {
    final currentState = state.unwrapPrevious().valueOrNull;

    if (currentState == null) {
      throw Exception('Current state is null');
    }

    if (currentState is! MintScreenEditingState) {
      throw Exception('Current state is not an MintScreenEditingState');
    }

    final validationResult = currentState.validate();

    if (validationResult.isError) {
      state = AsyncError(validationResult.error!, StackTrace.current);
      return;
    }

    final amount = BigInt.tryParse(currentState.amount.trim());

    if (amount == null) {
      state =
          AsyncError(MintScreenError.invalidAmountFormat(), StackTrace.current);
      return;
    }

    // Create the mint amount
    final mintAmountResult = MintAmount.create(amount);

    switch (mintAmountResult) {
      case Ok(value: final mintAmount):
        update((state) => MintScreenState.invoice(
              mintAmount: mintAmount,
            ));
        return;
      case Error(:final error):
        state = AsyncError(error, StackTrace.current);
        return;
    }
  }

  void clearErrors() {
    update((state) => (state as MintScreenEditingState).copyWith(
          showErrorMessages: false,
        ));
  }

  /// Resets the state to the initial state
  void reset() {
    update((state) => MintScreenState.editing(
          amount: '0',
          showErrorMessages: false,
        ));
  }
}

/// State for the mint screen
@freezed
class MintScreenState with _$MintScreenState {
  const MintScreenState._();

  factory MintScreenState.editing({
    required String amount,
    required bool showErrorMessages,
  }) = MintScreenEditingState;

  factory MintScreenState.invoice({
    required MintAmount mintAmount,
  }) = MintScreenInvoiceState;

  Result<Unit, MintScreenError> validate() {
    if (this is MintScreenInvoiceState) {
      return Result.ok(unit);
    }

    final currentState = this as MintScreenEditingState;
    final amount = BigInt.tryParse(currentState.amount.trim());

    if (amount == null) {
      return Result.error(MintScreenError.invalidAmountFormat());
    }

    final mintAmountValidationResult = MintAmount.validate(amount);

    return switch (mintAmountValidationResult) {
      Ok() => Result.ok(unit),
      Error(:final error) => switch (error) {
          MintAmountNegativeOrZero() =>
            Result.error(MintScreenError.mintAmountNegativeOrZero()),
          MintAmountTooLarge(:final maxAmount) =>
            Result.error(MintScreenError.mintAmountTooLarge(maxAmount)),
          _ => throw Exception('Unexpected error: $error'),
        },
    };
  }
}

@freezed
sealed class MintScreenError with _$MintScreenError {
  const MintScreenError._();
  factory MintScreenError.mintAmountTooLarge(BigInt maxAmount) = AmountTooLarge;
  factory MintScreenError.mintAmountNegativeOrZero() = AmountNegativeOrZero;
  factory MintScreenError.invalidAmountFormat() = AmountInvalidFormat;
  factory MintScreenError.unknown() = UnknownError;
}
