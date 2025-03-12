import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockWalletDatabase extends Mock implements WalletDatabase {
  MockWalletDatabase();

  // Factory constructor to create a mock database with a path
  factory MockWalletDatabase.withPath({required String path}) {
    return MockWalletDatabase();
  }
}
