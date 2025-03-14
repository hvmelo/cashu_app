import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/models/mint.dart';
import '../../core/notifiers/current_mint_notifier.dart';
import '../../core/providers/mint_providers.dart';

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
    );
  }

  /// Refreshes the list of mints
  Future<void> refreshMints() async {
    state = AsyncLoading();

    ref.invalidateSelf();
  }

  /// Sets a mint as the current mint
  Future<void> setCurrentMint(String mintUrl) async {
    state = AsyncLoading();
    ref.read(currentMintNotifierProvider.notifier).setCurrentMint(mintUrl);
  }
}

/// State for the mint management screen
@freezed
class MintManagerState with _$MintManagerState {
  const factory MintManagerState({
    required List<Mint> availableMints,
    required Mint? currentMint,
  }) = _MintManagerState;
}
