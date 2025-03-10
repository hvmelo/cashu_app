import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/repositories.dart';
import '../data_sources/multi_mint_wallet.dart';
import '../services/local_properties_service.dart';
import 'mint/mint_repository_impl.dart';
import 'mint_transaction/mint_transaction_repository_impl.dart';
import 'mint_wallet/mint_wallet_repository_impl.dart';

part 'repo_providers.g.dart';

@Riverpod(keepAlive: true)
MintRepository mintRepository(Ref ref) {
  final multiMintWallet = ref.watch(multiMintWalletProvider).valueOrNull;
  if (multiMintWallet == null) {
    throw Exception('MultiMintWallet is not initialized');
  }
  final localProps = ref.watch(localPropertiesServiceProvider);
  return MintRepositoryImpl(
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
