import 'package:cashu_app/domain/repositories/multi_mint_wallet_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'mock_multi_mint_wallet_data_source.dart';

class MockMultiMintWalletRepository extends Mock
    implements MultiMintWalletRepository {
  final MockMultiMintWalletDataSource _dataSource;

  MockMultiMintWalletRepository(this._dataSource) {
    // Setup default behavior
    when(() => balanceStream()).thenAnswer((_) => _dataSource.streamBalance());
  }

  // Expose the data source for testing
  MockMultiMintWalletDataSource get dataSource => _dataSource;

  @override
  Stream<BigInt> balanceStream() => _dataSource.streamBalance();

  // Factory method to create a mock repository
  static MockMultiMintWalletRepository create() {
    final dataSource = MockMultiMintWalletDataSource.create();
    return MockMultiMintWalletRepository(dataSource);
  }
}
