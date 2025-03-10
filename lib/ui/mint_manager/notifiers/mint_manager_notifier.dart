import 'package:cashu_app/config/app_providers.dart';
import 'package:cashu_app/domain/models/user_mint.dart';
import 'package:cashu_app/utils/result.dart';
import 'package:cashu_app/utils/unit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mint_manager_notifier.freezed.dart';
part 'mint_manager_notifier.g.dart';

/// Notifier for the mint management screen
@riverpod
class MintManagerNotifier extends _$MintManagerNotifier {
  @override
  MintManagementState build() {
    // Load the initial list of mints
    final mints = ref.read(allUserMintsProvider);
    final currentMint = ref.read(currentMintProvider);

    return MintManagementState(
      mints: mints,
      currentMintUrl: currentMint?.url,
      selectedMint: null,
      isLoading: false,
      error: null,
    );
  }

  /// Refreshes the list of mints
  void refreshMints() {
    final mints = ref.read(allUserMintsProvider);
    final currentMint = ref.read(currentMintProvider);

    state = state.copyWith(
      mints: mints,
      currentMintUrl: currentMint?.url,
      isLoading: false,
    );
  }

  /// Selects a mint for editing or viewing details
  void selectMint(UserMint mint) {
    state = state.copyWith(
      selectedMint: mint,
    );
  }

  /// Clears the selected mint
  void clearSelectedMint() {
    state = state.copyWith(
      selectedMint: null,
    );
  }

  /// Sets a mint as the current mint
  Future<Result<UserMint>> setCurrentMint(String mintUrl) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      ref.read(currentMintProvider.notifier).setCurrentMint(mintUrl);

      // Refresh the state to reflect the change
      refreshMints();

      // Find the mint that was set as current
      final mint = state.mints.firstWhere((m) => m.url == mintUrl);

      return Result.ok(mint);
    } catch (e, stackTrace) {
      state = state.copyWith(
        isLoading: false,
        error: MintManagementError.unknown(e.toString()),
      );
      return Result.error(e, stackTrace: stackTrace);
    }
  }

  /// Updates a mint's nickname
  Future<Result<UserMint>> updateMintNickname(
      String mintUrl, String? nickname) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Get the mint to update
      final mintToUpdate = state.mints.firstWhere((m) => m.url == mintUrl);

      // Create updated mint
      final updatedMint = UserMint(
        url: mintUrl,
        nickName: nickname,
      );

      // Save the updated mint
      ref.read(userMintRepositoryProvider).saveUserMint(updatedMint);

      // Refresh the state to reflect the change
      refreshMints();

      return Result.ok(updatedMint);
    } catch (e, stackTrace) {
      state = state.copyWith(
        isLoading: false,
        error: MintManagementError.unknown(e.toString()),
      );
      return Result.error(e, stackTrace: stackTrace);
    }
  }

  /// Deletes a mint
  Future<Result<Unit>> deleteMint(String mintUrl) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Delete the mint
      ref.read(userMintRepositoryProvider).deleteUserMint(mintUrl);

      // If the deleted mint was the current mint, clear the current mint
      final currentMintUrl = ref.read(currentMintProvider)?.url;
      if (currentMintUrl == mintUrl) {
        ref.read(userMintRepositoryProvider).deleteCurrentMintUrl();
      }

      // Refresh the state to reflect the change
      refreshMints();

      return const Result.ok(unit);
    } catch (e, stackTrace) {
      state = state.copyWith(
        isLoading: false,
        error: MintManagementError.unknown(e.toString()),
      );
      return Result.error(e, stackTrace: stackTrace);
    }
  }
}

/// State for the mint management screen
@freezed
class MintManagementState with _$MintManagementState {
  const factory MintManagementState({
    required List<UserMint> mints,
    required String? currentMintUrl,
    required UserMint? selectedMint,
    required bool isLoading,
    required MintManagementError? error,
  }) = _MintManagementState;
}

@freezed
sealed class MintManagementError with _$MintManagementError {
  const MintManagementError._();

  factory MintManagementError.unknown(String message) = UnknownError;

  @override
  String get message {
    return switch (this) {
      UnknownError(:final message) => message,
    };
  }
}
