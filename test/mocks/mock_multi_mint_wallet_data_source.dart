import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'mock_multi_mint_wallet.dart';

class MockMultiMintWalletDataSource extends Mock {
  final MockMultiMintWallet _wallet;

  MockMultiMintWalletDataSource(this._wallet) {
    // Setup default behavior
    when(() => wallet).thenReturn(_wallet);
    when(() => streamBalance()).thenAnswer((_) => _wallet.streamBalance());
    when(() => listMints()).thenAnswer((_) => _wallet.listMints());

    // Setup methods that interact with the wallet
    when(() => addMint(any())).thenAnswer((invocation) async {
      final mintUrl = invocation.positionalArguments[0] as String;
      await _wallet.addMint(mintUrl: mintUrl);
    });

    when(() => removeMint(any())).thenAnswer((invocation) async {
      final mintUrl = invocation.positionalArguments[0] as String;
      await _wallet.removeMint(mintUrl: mintUrl);
    });

    when(() => getMintWallet(any())).thenAnswer((invocation) async {
      final mintUrl = invocation.positionalArguments[0] as String;
      return await _wallet.getWallet(mintUrl: mintUrl);
    });

    when(() => createOrGetMintWallet(any())).thenAnswer((invocation) async {
      final mintUrl = invocation.positionalArguments[0] as String;
      return await _wallet.createOrGetWallet(mintUrl: mintUrl);
    });
  }

  // Expose the mock wallet for testing
  MockMultiMintWallet get mockWallet => _wallet;

  // Methods from the original class
  MultiMintWallet get wallet => _wallet;
  Stream<BigInt> streamBalance() => _wallet.streamBalance();
  Future<List<Mint>> listMints() => _wallet.listMints();
  Future<void> addMint(String mintUrl) async =>
      await _wallet.addMint(mintUrl: mintUrl);
  Future<void> removeMint(String mintUrl) async =>
      await _wallet.removeMint(mintUrl: mintUrl);
  Future<Wallet?> getMintWallet(String mintUrl) async =>
      await _wallet.getWallet(mintUrl: mintUrl);
  Future<Wallet> createOrGetMintWallet(String mintUrl) async =>
      await _wallet.createOrGetWallet(mintUrl: mintUrl);

  // Helper methods for testing
  void addWalletWithBalance(String mintUrl, BigInt balance) {
    _wallet.addWalletWithBalance(mintUrl, balance);
  }

  void updateWalletBalance(String mintUrl, BigInt balance) {
    _wallet.updateWalletBalance(mintUrl, balance);
  }

  // Clean up resources
  void dispose() {
    _wallet.dispose();
  }

  // Factory method to create a mock data source
  static MockMultiMintWalletDataSource create() {
    final mockWallet = MockMultiMintWallet(unit: 'sat');
    return MockMultiMintWalletDataSource(mockWallet);
  }
}
