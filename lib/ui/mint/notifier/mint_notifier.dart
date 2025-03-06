import 'package:cashu_app/config/providers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mint_notifier.freezed.dart';
part 'mint_notifier.g.dart';

/// Notifier for the mint screen
@riverpod
class MintNotifier extends _$MintNotifier {
  @override
  MintState build() {
    return MintState.initial();
  }

  /// Generates a Lightning invoice for the specified amount
  Future<void> generateInvoice(int amount) async {
    // Set loading state
    state =
        state.copyWith(amount: amount, isGeneratingInvoice: true, error: null);

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
          'lnbc${amount}n1pj4d03xpp5f70hy4qk9pza9zd8zawhv9hexs8q3xpj'
          'wvj08pj3vxf5ayxgj0yqdpzxyucrqvpsxqcqzpgxqyz5vqsp5usyc4lk9chsfp53kvcnvq4n'
          'vl9rlzw4qka6mwm7qmjm4y5yt6wq9qyyssqy9hdnr5ckn0zy95h90zqk4qxvmllskzlzcnw'
          'vju4e9d5u5c4qku5xdj7j8pjwl7hnkzrm3e9c5vgd63m2gc5v7wmqj0ys6v5ycqj6gpgq7m'
          'rvnz';

      // Update state with the invoice
      state = state.copyWith(invoice: mockInvoice, isGeneratingInvoice: false);
    } catch (e) {
      // Update state with the error
      state = state.copyWith(error: e.toString(), isGeneratingInvoice: false);
    }
  }

  /// Resets the state to the initial state
  void reset() {
    state = MintState.initial();
  }
}

/// State for the mint screen
@freezed
class MintState with _$MintState {
  const MintState._();

  factory MintState({
    required int amount,
    required bool isGeneratingInvoice,
    required String? invoice,
    required String? error,
  }) = _MintState;

  factory MintState.initial() => MintState(
        amount: 0,
        isGeneratingInvoice: false,
        invoice: null,
        error: null,
      );
}
