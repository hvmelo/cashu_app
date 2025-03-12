import '../../core/types/result.dart';
import '../../core/types/unit.dart';
import '../../domain/models/mint_wrapper.dart';
import '../../domain/repositories/repositories.dart';
import '../data_sources/mint_local_storage.dart';
import '../data_sources/multi_mint_wallet_data_source.dart';

class MintRepositoryImpl extends MintRepository {
  final MultiMintWalletDataSource multiMintWalletDataSource;
  final MintLocalStorage mintLocalStorage;

  MintRepositoryImpl({
    required this.multiMintWalletDataSource,
    required this.mintLocalStorage,
  });

  @override
  Future<List<MintWrapper>> listMints() async {
    final mints = await multiMintWalletDataSource.listMints();
    return mints.map((mint) {
      final nickName = mintLocalStorage.getMintNickname(mint.url);
      return MintWrapper(mint: mint, nickName: nickName);
    }).toList();
  }

  @override
  Future<Result<Unit>> addMint(String mintUrl, {String? nickName}) async {
    try {
      await multiMintWalletDataSource.addMint(mintUrl);
      if (nickName != null) {
        await mintLocalStorage.saveMintNickname(mintUrl, nickName);
      }
      return Result.ok(unit);
    } catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<MintWrapper?> getMint(String mintUrl) async {
    final mints = await multiMintWalletDataSource.listMints();
    final mint = mints.where((mint) => mint.url == mintUrl).firstOrNull;
    final nickName = mintLocalStorage.getMintNickname(mintUrl);
    return mint != null ? MintWrapper(mint: mint, nickName: nickName) : null;
  }

  @override
  Future<Result<Unit>> setCurrentMint(String mintUrl) async {
    final mint = await getMint(mintUrl);
    if (mint == null) {
      return Result.error('Mint not found');
    }
    await mintLocalStorage.saveCurrentMintUrl(mint.mint.url);
    return Result.ok(unit);
  }

  @override
  Future<Result<Unit>> updateMint(
    String mintUrl,
    String? nickName,
  ) async {
    final mint = await getMint(mintUrl);
    if (mint == null) {
      return Result.error('Mint not found');
    }
    await mintLocalStorage.saveMintNickname(mint.mint.url, nickName);
    return Result.ok(unit);
  }

  @override
  Future<MintWrapper?> getCurrentMint() async {
    final mintUrl = mintLocalStorage.getCurrentMintUrl();
    if (mintUrl == null) {
      return null;
    }
    return getMint(mintUrl);
  }

  @override
  Stream<Result<BigInt>> mintBalanceStream(String mintUrl) async* {
    try {
      final mintWallet = await multiMintWalletDataSource.getMintWallet(mintUrl);
      if (mintWallet == null) {
        yield Result.error(Exception('Wallet not found'));
      } else {
        yield* mintWallet.streamBalance().map((balance) => Result.ok(balance));
      }
    } catch (e) {
      yield Result.error(e);
    }
  }
}
