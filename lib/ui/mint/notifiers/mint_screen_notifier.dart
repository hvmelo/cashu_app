import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mint_screen_notifier.freezed.dart';
part 'mint_screen_notifier.g.dart';

/// Notifier for the mint screen
@riverpod
class MintScreenNotifier extends _$MintScreenNotifier {
  @override
  MintScreenState build() {
    return MintScreenState.initial();
  }

  void amountChanged(String amountStr) {
    state = state.copyWith(
      amount: int.tryParse(amountStr.trim()) ?? 0,
    );
  }

  /// Generates a Lightning invoice for the specified amount
  Future<void> generateInvoice() async {
    // Validate the amount
    final error = validate();
    if (error != null) {
      state = state.copyWith(showErrorMessages: true, error: error);
      return;
    }

    state = state.copyWith(isSubmitted: true);
    return;
  }

  MintScreenError? validate() {
    // Check if the value is empty
    if (state.amount == 0) {
      return MintScreenError.emptyAmount();
    }

    // Check if the value is a valid number
    if (state.amount <= 0) {
      return MintScreenError.invalidAmount();
    }
    return null;
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Resets the state to the initial state
  void reset() {
    state = MintScreenState.initial();
  }
}

/// State for the mint screen
@freezed
class MintScreenState with _$MintScreenState {
  const MintScreenState._();

  factory MintScreenState({
    required int amount,
    required bool isSubmitted,
    required bool showErrorMessages,
    required MintScreenError? error,
  }) = _MintScreenState;

  factory MintScreenState.initial() => MintScreenState(
        amount: 0,
        isSubmitted: false,
        showErrorMessages: false,
        error: null,
      );
}

@freezed
sealed class MintScreenError with _$MintScreenError {
  const MintScreenError._();

  factory MintScreenError.emptyAmount() = EmptyAmountError;
  factory MintScreenError.invalidAmount() = InvalidAmountError;
  factory MintScreenError.unknown() = UnknownError;
}
