import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/data_providers.dart';
import '../../../domain/models/mint_wrapper.dart';

part 'current_mint_notifier.g.dart';

@riverpod
class CurrentMintNotifier extends _$CurrentMintNotifier {
  @override
  Future<MintWrapper?> build() async {
    final mintRepo = await ref.watch(mintRepositoryProvider.future);
    return await mintRepo.getCurrentMint();
  }

  Future<void> setCurrentMint(String mintUrl) async {
    final mintRepo = await ref.watch(mintRepositoryProvider.future);
    await mintRepo.setCurrentMint(mintUrl);
    state = AsyncData(await mintRepo.getCurrentMint());
  }
}
