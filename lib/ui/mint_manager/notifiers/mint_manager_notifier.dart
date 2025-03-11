import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/data_providers.dart';
import '../../../domain/models/mint_wrapper.dart';
import '../../core/notifiers/current_mint_notifier.dart';

part 'mint_manager_notifier.freezed.dart';
part 'mint_manager_notifier.g.dart';

/// Notifier for the mint management screen
@riverpod
class MintManagerNotifier extends _$MintManagerNotifier {
  @override
  Future<MintManagerState> build() async {
    // Load the initial list of mints
    final availableMints = await ref.watch(listMintsProvider.future);
    final currentMint = await ref.watch(currentMintNotifierProvider.future);

    return MintManagerState(
      availableMints: availableMints,
      currentMint: currentMint,
      selectedMint: null,
    );
  }

  /// Refreshes the list of mints
  Future<void> refreshMints() async {
    state = AsyncLoading();

    ref.invalidateSelf();
  }

  /// Selects a mint for editing or viewing details
  void selectMint(MintWrapper mint) {
    update((state) => state.copyWith(selectedMint: mint));
  }

  /// Clears the selected mint
  void clearSelectedMint() {
    update((state) => state.copyWith(selectedMint: null));
  }

  /// Sets a mint as the current mint
  Future<void> setCurrentMint(String mintUrl) async {
    state = AsyncLoading();

    ref.read(currentMintNotifierProvider.notifier).setCurrentMint(mintUrl);

    // Refresh the state to reflect the change
    ref.invalidateSelf();
  }

  /// Updates a mint's nickname
  Future<void> updateMintNickname(String mintUrl, String? nickname) async {
    state = AsyncLoading();

    ref.read(mintRepositoryProvider).updateMintNickname(mintUrl, nickname);

    ref.invalidateSelf();
  }
}

/// State for the mint management screen
@freezed
class MintManagerState with _$MintManagerState {
  const factory MintManagerState({
    required List<MintWrapper> availableMints,
    required MintWrapper? currentMint,
    required MintWrapper? selectedMint,
  }) = _MintManagerState;
}

@freezed
sealed class MintManagerError with _$MintManagerError {
  const MintManagerError._();

  factory MintManagerError.unknown(String message) = UnknownError;

  @override
  String get message {
    return switch (this) {
      UnknownError(:final message) => message,
    };
  }
}
