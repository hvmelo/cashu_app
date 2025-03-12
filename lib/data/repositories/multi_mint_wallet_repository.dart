import '../../domain/repositories/repositories.dart';
import '../data_sources/multi_mint_wallet_data_source.dart';

class MultiMintWalletRepositoryImpl extends MultiMintWalletRepository {
  final MultiMintWalletDataSource multiMintWalletDataSource;

  MultiMintWalletRepositoryImpl({
    required this.multiMintWalletDataSource,
  });

  @override
  Stream<BigInt> balanceStream() async* {
    yield* multiMintWalletDataSource.streamBalance();
  }
}
