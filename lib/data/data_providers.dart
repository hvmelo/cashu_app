import 'package:cashu_app/core/core_providers.dart';
import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/repositories/repositories.dart';
import 'repositories/mint/mint_repository_impl.dart';
import 'repositories/mint_transaction/mint_transaction_repository_impl.dart';
import 'repositories/mint_wallet/mint_wallet_repository_impl.dart';
import 'services/local_properties_service.dart';

part 'data_providers.g.dart';

@Riverpod(keepAlive: true)
Future<MultiMintWallet> multiMintWallet(Ref ref) async {
  return await multiMintWallet(ref);
}

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

@Riverpod(keepAlive: true)
LocalPropertiesService localPropertiesService(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  if (prefs == null) {
    throw Exception('SharedPreferences is not initialized');
  }
  return LocalPropertiesService(prefs);
}
