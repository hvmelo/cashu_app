import 'package:cashu_app/ui/core/errors/unexpected_error.dart';
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
      amount: BigInt.zero,
      showErrorMessages: false,
    );
  }

  void amountChanged(String amountStr) {
    final amount = BigInt.tryParse(amountStr.trim());
    if (amount == null) {
      throw UnexpectedError(message: 'Invalid amount format.');
    }
    update(
        (state) => (state as MintScreenEditingState).copyWith(amount: amount));
  }

  Result<Unit, MintAmountValidationFailure> validateAmount() {
    final currentState = this as MintScreenEditingState;
    return MintAmount.validate(currentState.amount);
  }

  /// Generates a Lightning invoice for the specified amount
  Future<void> generateInvoice() async {
    final currentState = state.unwrapPrevious().valueOrNull;
    if (currentState == null) return;

    if (currentState is! MintScreenEditingState) {
      throw UnexpectedError(
          message: 'Current state is not an MintScreenEditingState');
    }

    // Create a MintAmount value object from the current amount
    final mintAmountResult = MintAmount.create(currentState.amount);
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
          amount: BigInt.zero,
          showErrorMessages: false,
        ));
  }
}

/// State for the mint screen
@freezed
sealed class MintScreenState with _$MintScreenState {
  factory MintScreenState.editing({
    required BigInt amount,
    required bool showErrorMessages,
  }) = MintScreenEditingState;

  factory MintScreenState.invoice({
    required MintAmount mintAmount,
  }) = MintScreenInvoiceState;
}
