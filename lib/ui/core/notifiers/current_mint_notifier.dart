import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/data_providers.dart';
import '../../../domain/models/mint_wrapper.dart';

part 'current_mint_notifier.g.dart';

@riverpod
class CurrentMintNotifier extends _$CurrentMintNotifier {
  @override
  Future<MintWrapper?> build() async =>
      await ref.read(mintRepositoryProvider).getCurrentMint();

  Future<void> setCurrentMint(String mintUrl) async {
    await ref.read(mintRepositoryProvider).setCurrentMint(mintUrl);
    state = AsyncData(await ref.read(mintRepositoryProvider).getCurrentMint());
  }
}
