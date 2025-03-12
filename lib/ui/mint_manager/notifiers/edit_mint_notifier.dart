import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/data_providers.dart';
import '../../../domain/models/mint_wrapper.dart';
import '../../core/notifiers/current_mint_notifier.dart';

part 'edit_mint_notifier.freezed.dart';
part 'edit_mint_notifier.g.dart';

/// Notifier for the edit mint screen
@riverpod
class EditMintNotifier extends _$EditMintNotifier {
  @override
  EditMintState build(MintWrapper mint) {
    // Initialize the state with the provided mint
    return EditMintState(
      originalMint: mint,
      nickname: mint.nickName ?? '',
      isSubmitting: false,
      isSuccess: false,
      error: null,
    );
  }

  /// Updates the nickname field
  void nicknameChanged(String nickname) {
    state = state.copyWith(
      nickname: nickname.trim(),
      error: null,
    );
  }

  /// Saves the changes to the mint
  Future<void> saveMint() async {
    // Set submitting state
    state = state.copyWith(
      isSubmitting: true,
      error: null,
    );

    try {
      // Update the mint's nickname
      final newNickname = state.nickname.isEmpty ? null : state.nickname;
      final mintRepo = await ref.watch(mintRepositoryProvider.future);
      await mintRepo.updateMint(
        state.originalMint.mint.url,
        newNickname,
      );

      // Update the current mint if this is the current mint
      final currentMint = await ref.read(currentMintNotifierProvider.future);
      if (currentMint?.mint.url == state.originalMint.mint.url) {
        ref.invalidate(currentMintNotifierProvider);
      }

      // Set success state
      state = state.copyWith(
        isSubmitting: false,
        isSuccess: true,
      );
    } catch (e) {
      // Set error state
      state = state.copyWith(
        isSubmitting: false,
        error: EditMintError.unknown(e.toString()),
      );
    }
  }

  /// Deletes the mint
  ///
  /// Note: This is a placeholder implementation since the MintRepository
  /// doesn't have a deleteUserMint method. In a real implementation,
  /// you would need to add this method to the MintRepository interface
  /// and implement it in the MintRepositoryImpl class.
  Future<void> deleteMint() async {
    // Set submitting state
    state = state.copyWith(
      isSubmitting: true,
      error: null,
    );

    try {
      // TODO: Implement mint deletion in the MintRepository
      // For now, we'll just simulate a successful deletion

      // If this is the current mint, we need to select a different one
      final currentMint = await ref.read(currentMintNotifierProvider.future);
      if (currentMint?.mint.url == state.originalMint.mint.url) {
        // Get the first available mint that's not this one
        final mints = await ref.read(listMintsProvider.future);
        final otherMints = mints
            .where((m) => m.mint.url != state.originalMint.mint.url)
            .toList();

        if (otherMints.isNotEmpty) {
          // Set another mint as the current mint
          await ref
              .read(currentMintNotifierProvider.notifier)
              .setCurrentMint(otherMints.first.mint.url);
        } else {
          // No other mints available, so we need to clear the current mint
          // Since there's no clearCurrentMint method, we'll set the current mint to null
          // by invalidating the provider
          ref.invalidate(currentMintNotifierProvider);
        }
      }

      // Set success state
      state = state.copyWith(
        isSubmitting: false,
        isSuccess: true,
      );
    } catch (e) {
      // Set error state
      state = state.copyWith(
        isSubmitting: false,
        error: EditMintError.unknown(e.toString()),
      );
    }
  }

  /// Sets this mint as the current mint
  Future<void> setAsCurrentMint() async {
    // Set submitting state
    state = state.copyWith(
      isSubmitting: true,
      error: null,
    );

    try {
      // Set as current mint
      await ref
          .read(currentMintNotifierProvider.notifier)
          .setCurrentMint(state.originalMint.mint.url);

      // Set success state
      state = state.copyWith(
        isSubmitting: false,
        isSuccess: true,
      );
    } catch (e) {
      // Set error state
      state = state.copyWith(
        isSubmitting: false,
        error: EditMintError.unknown(e.toString()),
      );
    }
  }

  /// Clears any errors
  void clearErrors() {
    state = state.copyWith(
      error: null,
    );
  }

  /// Resets the success state
  void resetSuccess() {
    state = state.copyWith(
      isSuccess: false,
    );
  }
}

/// State for the edit mint screen
@freezed
class EditMintState with _$EditMintState {
  const factory EditMintState({
    required MintWrapper originalMint,
    required String nickname,
    required bool isSubmitting,
    required bool isSuccess,
    required EditMintError? error,
  }) = _EditMintState;
}

@freezed
sealed class EditMintError with _$EditMintError {
  const EditMintError._();

  factory EditMintError.unknown(String message) = UnknownError;

  @override
  String get message {
    return switch (this) {
      UnknownError(:final message) => message,
    };
  }
}
