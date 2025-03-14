import '../../core/types/types.dart';
import '../../domain/failures/mint_failures.dart';
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
      final nickname = mintLocalStorage.getMintNickname(mint.url);
      return Mint.fromData(nickname: nickname, url: mint.url);
    }).toList();
  }

  @override
  Future<Result<Unit, AddMintFailure>> addMint(
    MintUrl mintUrl, {
    MintNickname? nickname,
  }) async {
    try {
      await multiMintWalletDataSource.addMint(mintUrl.value);
      if (nickname != null) {
        await mintLocalStorage.saveMintNickname(mintUrl.value, nickname.value);
      }
      return Result.ok(unit);
    } catch (e) {
      return Result.error(AddMintFailure.unknown(e));
    }
  }

  @override
  Future<Mint?> getMint(MintUrl mintUrl) async {
    final mints = await multiMintWalletDataSource.listMints();
    final mint = mints.where((mint) => mint.url == mintUrl.value).firstOrNull;
    final nickname = mintLocalStorage.getMintNickname(mintUrl.value);
    return mint != null
        ? Mint.fromData(url: mintUrl.value, nickname: nickname)
        : null;
  }

  @override
  Future<Result<Unit, RemoveMintFailure>> removeMint(MintUrl mintUrl) async {
    try {
      await multiMintWalletDataSource.removeMint(mintUrl.value);
      await mintLocalStorage.deleteMintNickname(mintUrl.value);
      return Result.ok(unit);
    } catch (e) {
      return Result.error(RemoveMintFailure.unknown(e));
    }
  }

  @override
  Future<Result<Unit, SaveCurrentMintFailure>> saveCurrentMint(
      MintUrl mintUrl) async {
    try {
      final mint = await getMint(mintUrl);
      if (mint == null) {
        return Result.error(
            SaveCurrentMintFailure.unknown(Exception('Mint not found')));
      }
      await mintLocalStorage.saveCurrentMintUrl(mintUrl.value);
      return Result.ok(unit);
    } catch (e) {
      return Result.error(SaveCurrentMintFailure.unknown(e));
    }
  }

  @override
  Future<Result<Unit, RemoveCurrentMintFailure>> removeCurrentMint() async {
    try {
      await mintLocalStorage.removeCurrentMintUrl();
      return Result.ok(unit);
    } catch (e) {
      return Result.error(RemoveCurrentMintFailure.unknown(e));
    }
  }

  @override
  Future<Result<Unit, UpdateMintFailure>> updateMint(
    MintUrl mintUrl, {
    MintNickname? nickname,
  }) async {
    final mint = await getMint(mintUrl);
    if (mint == null) {
      return Result.error(
          UpdateMintFailure.unknown(Exception('Mint not found')));
    }

    try {
      if (nickname != null) {
        await mintLocalStorage.deleteMintNickname(mintUrl.value);
      }
      await mintLocalStorage.saveMintNickname(mintUrl.value, nickname!.value);

      return Result.ok(unit);
    } catch (e) {
      return Result.error(UpdateMintFailure.unknown(e));
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
  Stream<Result<BigInt, MintBalanceStreamFailure>> mintBalanceStream(
      MintUrl mintUrl) async* {
    try {
      final mintWallet =
          await multiMintWalletDataSource.getMintWallet(mintUrl.value);
      if (mintWallet == null) {
        yield Result.error(
            MintBalanceStreamFailure.unknown(Exception('Wallet not found')));
      } else {
        yield* mintWallet.streamBalance().map((balance) => Result.ok(balance));
      }
    } catch (e) {
      yield Result.error(MintBalanceStreamFailure.unknown(e));
    }
  }
}
