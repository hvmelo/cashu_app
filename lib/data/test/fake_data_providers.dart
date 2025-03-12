import 'package:cashu_app/data/test/fake_multi_mint_wallet_repository.dart';
import 'package:cashu_app/domain/repositories/mint_repository.dart';
import 'package:cashu_app/domain/repositories/mint_transactions_repository.dart';
import 'package:cashu_app/domain/repositories/multi_mint_wallet_repository.dart';
import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Import the mock implementations
import 'fake_mint_repository_impl.dart';
import 'fake_mint_transactions_repository_impl.dart';

/// A class that provides mock implementations for development mode
class FakeDataProviders {
  // Prevent instantiation
  FakeDataProviders._();

  // Provider for a mock MultiMintWallet
  static final fakeMultiMintWalletProvider = Provider<MultiMintWallet>((ref) {
    throw UnimplementedError('This should be overridden in development mode');
  });

  // Provider for a mock MultiMintWalletRepository
  static final fakeMultiMintWalletRepositoryProvider =
      Provider<MultiMintWalletRepository>((ref) {
    return FakeMultiMintWalletRepositoryImpl();
  });

  // Provider for a mock MintRepository
  static final fakeMintRepositoryProvider = Provider<MintRepository>((ref) {
    return FakeMintRepositoryImpl();
  });

  // Provider for a mock MintTransactionsRepository
  static final fakeMintTransactionsRepositoryProvider =
      Provider<MintTransactionsRepository>((ref) {
    return FakeMintTransactionsRepositoryImpl();
  });

  // Factory methods to create mock instances directly
  static MultiMintWalletRepository createMockMultiMintWalletRepository() {
    return FakeMultiMintWalletRepositoryImpl();
  }

  static MintRepository createMockMintRepository() {
    return FakeMintRepositoryImpl();
  }

  static MintTransactionsRepository createMockMintTransactionsRepository() {
    return FakeMintTransactionsRepositoryImpl();
  }
}
