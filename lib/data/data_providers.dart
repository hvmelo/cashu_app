import 'package:cashu_app/core/core_providers.dart';
import 'package:cashu_app/core/types/result.dart';
import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/models/mint_wrapper.dart';
import '../domain/repositories/repositories.dart';
import 'repositories/multi_mint_wallet/multi_mint_wallet_repository_impl.dart';
import 'repositories/mint_transaction/mint_transaction_repository_impl.dart';
import 'repositories/mint_wallet/mint_wallet_repository_impl.dart';
import 'services/local_properties_service.dart';

part 'data_providers.g.dart';

@Riverpod(keepAlive: true)
Future<MultiMintWallet> multiMintWallet(Ref ref) async {
  return await multiMintWallet(ref);
}

@Riverpod(keepAlive: true)
MultiMintWalletRepository multiMintWalletRepository(Ref ref) {
  final multiMintWallet = ref.watch(multiMintWalletProvider).valueOrNull;
  if (multiMintWallet == null) {
    throw Exception('MultiMintWallet is not initialized');
  }
  final localProps = ref.watch(localPropertiesServiceProvider);
  return MultiMintWalletRepositoryImpl(
    multiMintWallet: multiMintWallet,
    localPropertiesService: localProps,
  );
}

@Riverpod(keepAlive: true)
MintWalletRepository mintWalletRepository(Ref ref) {
  final multiMintWallet = ref.watch(multiMintWalletProvider).valueOrNull;
  if (multiMintWallet == null) {
    throw Exception('MultiMintWallet is not initialized');
  }
  return MintWalletRepositoryImpl(
    multiMintWallet: multiMintWallet,
  );
}

@Riverpod(keepAlive: true)
MintTransactionRepository mintTransactionRepository(Ref ref) {
  final multiMintWallet = ref.watch(multiMintWalletProvider).valueOrNull;
  if (multiMintWallet == null) {
    throw Exception('MultiMintWallet is not initialized');
  }
  final walletRepo = ref.watch(mintWalletRepositoryProvider);
  return MintTransactionRepositoryImpl(
    multiMintWallet: multiMintWallet,
    mintWalletRepository: walletRepo,
  );
}

@Riverpod(keepAlive: true)
LocalPropertiesService localPropertiesService(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  if (prefs == null) {
    throw Exception('SharedPreferences is not initialized');
  }
  return LocalPropertiesService(prefs);
}

@riverpod
Future<List<MintWrapper>> listMints(Ref ref) async {
  final mintRepo = ref.watch(multiMintWalletRepositoryProvider);
  return await mintRepo.listMints();
}

@riverpod
Stream<BigInt> multiMintWalletBalanceStream(Ref ref) async* {
  final multiMintWalletRepo = ref.watch(multiMintWalletRepositoryProvider);
  yield* multiMintWalletRepo.multiMintWalletBalanceStream();
}

@riverpod
Future<Wallet?> getMintWallet(Ref ref, String mintUrl) async {
  final mintWallet =
      await ref.watch(mintWalletRepositoryProvider).getWallet(mintUrl);
  return mintWallet;
}

@riverpod
Stream<Result<BigInt>> mintQuoteStream(
    Ref ref, String mintUrl, BigInt amount) async* {
  final mintWalletRepo = ref.watch(mintWalletRepositoryProvider);

  yield* mintWalletRepo.s
}

@riverpod
class MintQuoteStream extends _$MintQuoteStream {
  @override
  Stream<Result<BigInt>> build(String mintUrl, BigInt amount) async* {
    final mintWallet = await ref.watch(getMintWalletProvider(mintUrl).future);
    if (mintWallet == null) {
      yield* Result.error(MintQuoteError.mintNotFound);
    }
    yield* mintWallet.streamQuote(amount);
  }
}
