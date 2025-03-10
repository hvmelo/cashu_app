import 'package:cashu_app/data/services/local_properties_service.dart';
import 'package:cashu_app/domain/repositories/mint_repository.dart';
import 'package:cdk_flutter/cdk_flutter.dart' show MultiMintWallet;

import '../../../domain/models/mint_wrapper.dart';

class MintRepositoryImpl extends MintRepository {
  final MultiMintWallet multiMintWallet;
  final LocalPropertiesService localPropertiesService;

  MintRepositoryImpl({
    required this.multiMintWallet,
    required this.localPropertiesService,
  });

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
  Future<void> addMint(String mintUrl, {String? nickName}) async {
    await multiMintWallet.addMint(mintUrl: mintUrl);
    if (nickName != null) {
      await localPropertiesService.setProperty(
          'mint_nickname_$mintUrl', nickName);
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
}
