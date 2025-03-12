import 'dart:async';

import 'package:cashu_app/domain/repositories/multi_mint_wallet_repository.dart';

/// A fake implementation of the MultiMintWalletRepository for development and testing
class FakeMultiMintWalletRepositoryImpl implements MultiMintWalletRepository {
  final StreamController<BigInt> _balanceController =
      StreamController<BigInt>.broadcast();

  // Store the current balance value
  BigInt _currentBalance = BigInt.from(21);

  FakeMultiMintWalletRepositoryImpl() {
    // Initialize with some balance
    _balanceController.add(_currentBalance);
  }

  @override
  Stream<BigInt> balanceStream() async* {
    // First yield the current value
    yield _currentBalance;

    // Then yield all future values from the controller
    await for (final value in _balanceController.stream) {
      yield value;
    }
  }

  /// Updates the mock balance
  void updateBalance(BigInt balance) {
    _currentBalance = balance;
    _balanceController.add(balance);
  }

  /// Get the current balance value
  BigInt get currentBalance => _currentBalance;

  /// Disposes resources
  void dispose() {
    _balanceController.close();
  }
}
