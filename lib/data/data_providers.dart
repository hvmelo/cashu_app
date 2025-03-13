import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/core_providers.dart';
import '../domain/repositories/repositories.dart';
import 'data_sources/mint_local_storage.dart';
import 'data_sources/multi_mint_wallet_data_source.dart';
import 'repositories/mint_repository_impl.dart';
import 'repositories/mint_transactions_repository_impl.dart';
import 'repositories/multi_mint_wallet_repository.dart';
import 'services/local_storage_service.dart';

part 'data_providers.g.dart';

@Riverpod(keepAlive: true)
LocalStorageService localPropertiesService(Ref ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  if (sharedPreferences == null) {
    throw Exception('SharedPreferences is not initialized');
  }
  return LocalStorageService(sharedPreferences);
}

@Riverpod(keepAlive: true)
MintLocalStorage mintLocalStorage(Ref ref) {
  final localPropertiesService = ref.watch(localPropertiesServiceProvider);
  return MintLocalStorage(localPropertiesService: localPropertiesService);
}

@Riverpod(keepAlive: true)
Future<MultiMintWalletDataSource> multiMintWalletDataSource(Ref ref) async {
  return await MultiMintWalletDataSource.create();
}

@Riverpod(keepAlive: true)
Future<MultiMintWalletRepository> multiMintWalletRepository(Ref ref) async {
  final multiMintWalletDataSource =
      await ref.watch(multiMintWalletDataSourceProvider.future);
  return MultiMintWalletRepositoryImpl(
    multiMintWalletDataSource: multiMintWalletDataSource,
  );
}

@Riverpod(keepAlive: true)
Future<MintRepository> mintRepository(Ref ref) async {
  final multiMintWalletDataSource =
      await ref.watch(multiMintWalletDataSourceProvider.future);

  final mintLocalStorage = ref.watch(mintLocalStorageProvider);
  return MintRepositoryImpl(
    multiMintWalletDataSource: multiMintWalletDataSource,
    mintLocalStorage: mintLocalStorage,
  );
}

@Riverpod(keepAlive: true)
Future<MintTransactionsRepository> mintTransactionsRepository(Ref ref) async {
  final multiMintWalletDataSource =
      await ref.watch(multiMintWalletDataSourceProvider.future);
  return MintTransactionsRepositoryImpl(
    multiMintWalletDataSource: multiMintWalletDataSource,
  );
}
