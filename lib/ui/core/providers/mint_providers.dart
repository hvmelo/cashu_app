import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/types/types.dart';
import '../../../data/data_providers.dart';
import '../../../domain/failures/mint_failures.dart';
import '../../../domain/failures/mint_transactions_failures.dart';
import '../../../domain/models/models.dart';
import '../../../domain/value_objects/value_objects.dart';

part 'mint_providers.g.dart';

@riverpod
Stream<BigInt> multiMintWalletBalanceStream(Ref ref) async* {
  final multiMintWalletRepo =
      await ref.watch(multiMintWalletRepositoryProvider.future);
  yield* multiMintWalletRepo.balanceStream();
}

@riverpod
Future<List<Mint>> listMints(Ref ref) async {
  final mintRepo = await ref.watch(mintRepositoryProvider.future);
  return await mintRepo.listMints();
}

@riverpod
Future<Result<Unit, AddMintFailure>> addMint(Ref ref,
    {required MintUrl mintUrl, MintNickname? nickname}) async {
  final mintRepo = await ref.watch(mintRepositoryProvider.future);
  final result = await mintRepo.addMint(mintUrl, nickname: nickname);
  switch (result) {
    case Ok():
      // Invalidate the list of mints
      ref.invalidate(listMintsProvider);
      return Result.ok(unit);
    case Error(:final error):
      return Result.error(error);
  }
}

@riverpod
Future<Result<Unit, UpdateMintFailure>> updateMint(
  Ref ref,
  MintUrl mintUrl, {
  MintNickname? nickname,
}) async {
  final mintRepo = await ref.watch(mintRepositoryProvider.future);
  final result = await mintRepo.updateMint(mintUrl, nickname: nickname);
  switch (result) {
    case Ok():
      // Invalidate the list of mints
      ref.invalidate(listMintsProvider);
      return Result.ok(unit);
    case Error(:final error):
      return Result.error(error);
  }
}

@riverpod
Future<Result<Unit, RemoveMintFailure>> removeMint(
    Ref ref, MintUrl mintUrl) async {
  final mintRepo = await ref.watch(mintRepositoryProvider.future);
  final result = await mintRepo.removeMint(mintUrl);
  switch (result) {
    case Ok():
      // Invalidate the list of mints
      ref.invalidate(listMintsProvider);
      return Result.ok(unit);
    case Error(:final error):
      return Result.error(error);
  }
}

@riverpod
Stream<Result<BigInt, MintBalanceStreamFailure>> mintBalanceStream(
    Ref ref, MintUrl mintUrl) async* {
  final mintRepo = await ref.watch(mintRepositoryProvider.future);
  yield* mintRepo.mintBalanceStream(mintUrl);
}

@riverpod
Stream<Result<MintQuote, MintQuoteStreamFailure>> mintQuoteStream(
  Ref ref,
  MintUrl mintUrl,
  MintAmount mintAmount,
) async* {
  final mintTransactionsRepo =
      await ref.watch(mintTransactionsRepositoryProvider.future);
  yield* mintTransactionsRepo.mintQuoteStream(mintUrl.value, mintAmount);
}
