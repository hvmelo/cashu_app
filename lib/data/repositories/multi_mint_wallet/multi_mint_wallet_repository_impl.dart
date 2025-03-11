import 'package:cashu_app/data/services/local_properties_service.dart';
import 'package:cashu_app/domain/repositories/multi_mint_wallet_repository.dart';
import 'package:cdk_flutter/cdk_flutter.dart' show MultiMintWallet;

import '../../../core/types/result.dart';
import '../../../core/types/unit.dart';
import '../../../domain/models/mint_wrapper.dart';

class MultiMintWalletRepositoryImpl extends MultiMintWalletRepository {
  final MultiMintWallet multiMintWallet;
  final LocalPropertiesService localPropertiesService;

  MultiMintWalletRepositoryImpl({
    required this.multiMintWallet,
    required this.localPropertiesService,
  });

  @override
  Stream<BigInt> multiMintWalletBalanceStream() async* {
    yield* multiMintWallet.streamBalance();
  }

  @override
  Future<List<MintWrapper>> listMints() async {
    final mints = await multiMintWallet.listMints();
    return mints.map((mint) {
      final nickName =
          localPropertiesService.getProperty<String>('mint_nickname_$mint.url');
      return MintWrapper(mint: mint, nickName: nickName);
    }).toList();
  }

  @override
  Future<Result<Unit>> addMint(String mintUrl, {String? nickName}) async {
    try {
      await multiMintWallet.addMint(mintUrl: mintUrl);
      if (nickName != null) {
        await localPropertiesService.setProperty(
          'mint_nickname_$mintUrl',
          nickName,
        );
      }
      return Result.ok(unit);
    } catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<MintWrapper?> getMint(String mintUrl) async {
    final mints = await multiMintWallet.listMints();
    final mint = mints.where((mint) => mint.url == mintUrl).firstOrNull;
    final nickName =
        localPropertiesService.getProperty<String>('mint_nickname_$mintUrl');
    return mint != null ? MintWrapper(mint: mint, nickName: nickName) : null;
  }

  @override
  Future<Result<Unit>> updateMintNickname(
    String mintUrl,
    String? nickName,
  ) async {
    try {
      await localPropertiesService.setProperty(
        'mint_nickname_$mintUrl',
        nickName,
      );
      return Result.ok(unit);
    } catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<Unit>> setCurrentMint(String mintUrl) async {
    try {
      await localPropertiesService.setProperty('current_mint_url', mintUrl);
      return Result.ok(unit);
    } catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<MintWrapper?> getCurrentMint() async {
    final mintUrl =
        localPropertiesService.getProperty<String>('current_mint_url');
    if (mintUrl == null) return null;
    return getMint(mintUrl);
  }
}
