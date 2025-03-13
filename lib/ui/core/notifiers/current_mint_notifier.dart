import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/types/types.dart';
import '../../../data/data_providers.dart';
import '../../../domain/models/mint.dart';
import '../../../domain/value_objects/mint_url.dart';

part 'current_mint_notifier.g.dart';

@riverpod
class CurrentMintNotifier extends _$CurrentMintNotifier {
  @override
  Future<Mint?> build() async {
    final mintRepo = await ref.watch(mintRepositoryProvider.future);
    return await mintRepo.getCurrentMint();
  }

  Future<void> setCurrentMint(String mintUrl) async {
    final mintRepo = await ref.watch(mintRepositoryProvider.future);
    final mintUrlResult = MintUrl.create(mintUrl);
    switch (mintUrlResult) {
      case Ok(value: final mintUrl):
        await mintRepo.saveCurrentMint(mintUrl);
        state = AsyncData(await mintRepo.getCurrentMint());
      case Error(:final error):
        state = AsyncError(error, StackTrace.current);
    }
  }
}
