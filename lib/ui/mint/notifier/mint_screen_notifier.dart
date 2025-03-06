import 'package:cashu_app/config/providers.dart';
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

    state = state.copyWith(
        amount: state.amount, isGeneratingInvoice: true, error: null);

    try {
      final wallet = ref.read(walletProvider);
      if (wallet == null) {
        throw Exception('Wallet is not initialized');
      }

      // For demonstration purposes, we're using a mock invoice
      // In a real implementation, you would call the appropriate CDK Flutter API
      // method to generate a Lightning invoice
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      // This is a placeholder - in a real app, you would use the actual invoice from the API
      final mockInvoice =
          'lnbc${state.amount}n1pj4d03xpp5f70hy4qk9pza9zd8zawhv9hexs8q3xpj'
          'wvj08pj3vxf5ayxgj0yqdpzxyucrqvpsxqcqzpgxqyz5vqsp5usyc4lk9chsfp53kvcnvq4n'
          'vl9rlzw4qka6mwm7qmjm4y5yt6wq9qyyssqy9hdnr5ckn0zy95h90zqk4qxvmllskzlzcnw'
          'vju4e9d5u5c4qku5xdj7j8pjwl7hnkzrm3e9c5vgd63m2gc5v7wmqj0ys6v5ycqj6gpgq7m'
          'rvnz';

      // Update state with the invoice
      state = state.copyWith(invoice: mockInvoice, isGeneratingInvoice: false);
    } catch (e) {
      // Update state with the error
      state = state.copyWith(
          error: MintScreenError.invalidAmount(), isGeneratingInvoice: false);
    }
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
    required bool isGeneratingInvoice,
    required String? invoice,
    required bool showErrorMessages,
    required MintScreenError? error,
  }) = _MintScreenState;

  factory MintScreenState.initial() => MintScreenState(
        amount: 0,
        isGeneratingInvoice: false,
        invoice: null,
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
