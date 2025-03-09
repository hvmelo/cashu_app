import 'package:cashu_app/data/repositories/user_mints/user_mints_repository.dart';
import 'package:cashu_app/domain/models/user_mint.dart';
import 'package:cashu_app/utils/result.dart';
import 'package:cashu_app/utils/unit.dart';
import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:logging/logging.dart';

class AddMintUseCase {
  final MultiMintWallet multiMintWallet;
  final UserMintsRepository userMintsRepository;

  final log = Logger('AddMintUseCase');

  AddMintUseCase({
    required this.multiMintWallet,
    required this.userMintsRepository,
  });

  Future<Result<Unit>> execute(String mintUrl, {String? nickName}) async {
    try {
      final currentWalletMints = await multiMintWallet.listMints();

      final exists = currentWalletMints.any(
        (mint) => mint.url == mintUrl,
      );

      if (!exists) {
        await multiMintWallet.addMint(mintUrl: mintUrl);
      } else {
        log.warning('Mint already exists in the wallet: $mintUrl');
      }

      userMintsRepository
          .saveUserMint(UserMint(url: mintUrl, nickName: nickName));
      return const Result.ok(unit);
    } catch (e, stackTrace) {
      return Result.error(e, stackTrace: stackTrace);
    }
  }
}
