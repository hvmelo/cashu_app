import 'dart:async';

import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'mock_wallet.dart';

class MockMultiMintWallet extends Mock implements MultiMintWallet {
  final String _unit;
  final Map<String, MockWallet> _wallets = {};
  final StreamController<BigInt> _balanceStreamController =
      StreamController<BigInt>.broadcast();

  MockMultiMintWallet({
    required String unit,
  }) : _unit = unit {
    // Setup default behavior
    when(() => unit).thenReturn(_unit);
    when(() => streamBalance())
        .thenAnswer((_) => _balanceStreamController.stream);
    when(() => totalBalance())
        .thenAnswer((_) async => _calculateTotalBalance());
    when(() => listMints()).thenAnswer((_) async => _getMintsList());
    when(() => listWallets()).thenAnswer((_) async => _wallets.values.toList());

    // Setup methods that interact with wallets
    when(() => getWallet(mintUrl: any(named: 'mintUrl')))
        .thenAnswer((invocation) async {
      final mintUrl =
          invocation.namedArguments[const Symbol('mintUrl')] as String;
      return _wallets[mintUrl];
    });

    when(() => createOrGetWallet(mintUrl: any(named: 'mintUrl')))
        .thenAnswer((invocation) async {
      final mintUrl =
          invocation.namedArguments[const Symbol('mintUrl')] as String;
      if (!_wallets.containsKey(mintUrl)) {
        _wallets[mintUrl] = MockWallet(mintUrl: mintUrl, unit: _unit);
      }
      return _wallets[mintUrl]!;
    });

    when(() => addMint(mintUrl: any(named: 'mintUrl')))
        .thenAnswer((invocation) async {
      final mintUrl =
          invocation.namedArguments[const Symbol('mintUrl')] as String;
      if (!_wallets.containsKey(mintUrl)) {
        _wallets[mintUrl] = MockWallet(mintUrl: mintUrl, unit: _unit);
        _updateBalanceStream();
      }
    });

    when(() => removeMint(mintUrl: any(named: 'mintUrl')))
        .thenAnswer((invocation) async {
      final mintUrl =
          invocation.namedArguments[const Symbol('mintUrl')] as String;
      _wallets.remove(mintUrl);
      _updateBalanceStream();
    });
  }

  // Helper method to add a wallet with a specific balance
  void addWalletWithBalance(String mintUrl, BigInt balance) {
    _wallets[mintUrl] = MockWallet(
      mintUrl: mintUrl,
      unit: _unit,
      initialBalance: balance,
    );
    _updateBalanceStream();
  }

  // Helper method to update a wallet's balance
  void updateWalletBalance(String mintUrl, BigInt balance) {
    if (_wallets.containsKey(mintUrl)) {
      _wallets[mintUrl]!.updateBalance(balance);
      _updateBalanceStream();
    }
  }

  // Calculate total balance across all wallets
  BigInt _calculateTotalBalance() {
    BigInt total = BigInt.zero;
    for (final wallet in _wallets.values) {
      total += wallet.mockBalance;
    }
    return total;
  }

  // Get list of mints
  Future<List<Mint>> _getMintsList() async {
    // Create simplified Mint objects with minimal required fields
    return _wallets.keys
        .map((url) => Mint(
              url: url,
              balance: BigInt.zero,
            ))
        .toList();
  }

  // Update the balance stream with the new total balance
  void _updateBalanceStream() {
    _balanceStreamController.add(_calculateTotalBalance());
  }

  // Clean up resources
  @override
  void dispose() {
    _balanceStreamController.close();
  }
}
