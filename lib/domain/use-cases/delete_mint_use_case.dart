// import 'package:cashu_app/data/repositories/user_mints/user_mints_repository.dart';
// import 'package:cashu_app/utils/result.dart';
// import 'package:cashu_app/utils/unit.dart';
// import 'package:cdk_flutter/cdk_flutter.dart';
// import 'package:logging/logging.dart';

// class DeleteMintUseCase {
//   final MultiMintWallet multiMintWallet;
//   final UserMintsRepository userMintsRepository;

//   final log = Logger('DeleteMintUseCase');

//   DeleteMintUseCase({
//     required this.multiMintWallet,
//     required this.userMintsRepository,
//   });

//   Future<Result<Unit>> execute(String mintUrl) async {
//     try {
//       final currentWalletMints = await multiMintWallet.listMints();

//       final exists = currentWalletMints.any(
//         (mint) => mint.url == mintUrl,
//       );

//       if (exists) {
//         await multiMintWallet.(mintUrl: mintUrl);
//       } else {
//         log.warning('Mint does not exist in the wallet: $mintUrl');
//       }

//       userMintsRepository.deleteUserMint(mintUrl);
//       return const Result.ok(unit);
//     } catch (e, stackTrace) {
//       return Result.error(e, stackTrace: stackTrace);
//     }
//   }
// }
