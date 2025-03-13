import '../../core/types/types.dart';
import '../../domain/models/mint.dart';
import '../../domain/repositories/repositories.dart';

import '../../domain/value_objects/value_objects.dart';
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
  Future<List<Mint>> listMints() async {
    final mints = await multiMintWalletDataSource.listMints();
    return mints.map((mint) {
      final nickName = mintLocalStorage.getMintNickname(mint.url);
      return Mint.fromData(nickName: nickName, url: mint.url);
    }).toList();
  }

  @override
  Future<Result<Unit, Failure>> addMint(
    MintUrl mintUrl, {
    MintNickName? nickName,
  }) async {
    try {
      await multiMintWalletDataSource.addMint(mintUrl.value);
      if (nickName != null) {
        await mintLocalStorage.saveMintNickname(mintUrl.value, nickName.value);
      }
      return Result.ok(unit);
    } catch (e) {
      return Result.error(Failure(e));
    }
  }

  @override
  Future<Mint?> getMint(MintUrl mintUrl) async {
    final mints = await multiMintWalletDataSource.listMints();
    final mint = mints.where((mint) => mint.url == mintUrl.value).firstOrNull;
    final nickName = mintLocalStorage.getMintNickname(mintUrl.value);
    return mint != null
        ? Mint.fromData(url: mintUrl.value, nickName: nickName)
        : null;
  }

  @override
  Future<Result<Unit, Failure>> removeMint(MintUrl mintUrl) async {
    try {
      await multiMintWalletDataSource.removeMint(mintUrl.value);
      await mintLocalStorage.deleteMintNickname(mintUrl.value);
      return Result.ok(unit);
    } catch (e) {
      return Result.error(Failure(e));
    }
  }

  @override
  Future<Result<Unit, Failure>> saveCurrentMint(MintUrl mintUrl) async {
    try {
      final mint = await getMint(mintUrl);
      if (mint == null) {
        return Result.error(Failure('Mint not found'));
      }
      await mintLocalStorage.saveCurrentMintUrl(mintUrl.value);
      return Result.ok(unit);
    } catch (e) {
      return Result.error(Failure(e));
    }
  }

  @override
  Future<Result<Unit, Failure>> removeCurrentMint() async {
    try {
      await mintLocalStorage.removeCurrentMintUrl();
      return Result.ok(unit);
    } catch (e) {
      return Result.error(Failure(e));
    }
  }

  @override
  Future<Result<Unit, Failure>> updateMint(
    MintUrl mintUrl, {
    MintNickName? nickName,
  }) async {
    final mint = await getMint(mintUrl);
    if (mint == null) {
      return Result.error(Failure('Mint not found'));
    }

    try {
      if (nickName != null) {
        await mintLocalStorage.removeCurrentMintUrl();
      } else {
        await mintLocalStorage.saveMintNickname(mintUrl.value, nickName!.value);
      }
      return Result.ok(unit);
    } catch (e) {
      return Result.error(Failure(e));
    }
  }

  @override
  Future<Mint?> getCurrentMint() async {
    final mintUrl = mintLocalStorage.getCurrentMintUrl();
    if (mintUrl == null) {
      return null;
    }
    return await getMint(MintUrl.fromData(mintUrl));
  }

  @override
  Stream<Result<BigInt, Failure>> mintBalanceStream(MintUrl mintUrl) async* {
    try {
      final mintWallet =
          await multiMintWalletDataSource.getMintWallet(mintUrl.value);
      if (mintWallet == null) {
        yield Result.error(Failure(Exception('Wallet not found')));
      } else {
        yield* mintWallet.streamBalance().map((balance) => Result.ok(balance));
      }
    } catch (e) {
      yield Result.error(Failure(e));
    }
  }
}
