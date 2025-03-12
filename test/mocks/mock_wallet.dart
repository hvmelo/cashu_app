import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockWallet extends Mock implements Wallet {
  final String _mintUrl;
  final String _unit;
  // Use a different name to avoid conflict with the balance() method
  BigInt mockBalance = BigInt.from(0);

  MockWallet({
    required String mintUrl,
    required String unit,
    BigInt? initialBalance,
  })  : _mintUrl = mintUrl,
        _unit = unit {
    mockBalance = initialBalance ?? BigInt.from(0);

    // Setup default behavior
    when(() => mintUrl).thenReturn(_mintUrl);
    when(() => unit).thenReturn(_unit);
    when(() => balance()).thenAnswer((_) async => mockBalance);
    when(() => streamBalance()).thenAnswer((_) => Stream.value(mockBalance));
  }

  // Helper method to update the mock balance
  void updateBalance(BigInt newBalance) {
    mockBalance = newBalance;
    when(() => balance()).thenAnswer((_) async => mockBalance);
    when(() => streamBalance()).thenAnswer((_) => Stream.value(mockBalance));
  }
}
