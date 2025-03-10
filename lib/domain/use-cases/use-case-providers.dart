import 'package:cashu_app/domain/use-cases/add_mint_use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'use-case-providers.g.dart';

@riverpod
AddMintUseCase addMintUseCase(Ref ref) {
  final multiMintWallet = ref.watch(multiMintWalletProvider).valueOrNull;
  if (multiMintWallet == null) {
    throw Exception('MultiMintWallet not found');
  }
  final userMintsRepository = ref.read(userMintRepositoryProvider);

  return AddMintUseCase(
    multiMintWallet: multiMintWallet,
    userMintsRepository: userMintsRepository,
  );
}
