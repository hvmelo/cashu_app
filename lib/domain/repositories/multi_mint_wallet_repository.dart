import '../../core/types/result.dart';
import '../../core/types/unit.dart';
import '../models/mint_wrapper.dart';

abstract class MultiMintWalletRepository {
  Stream<BigInt> multiMintWalletBalanceStream();
  Future<Result<Unit>> addMint(String mintUrl, {String? nickName});
  Future<List<MintWrapper>> listMints();
  Future<MintWrapper?> getMint(String mintUrl);
  Future<Result<Unit>> setCurrentMint(String mintUrl);
  Future<MintWrapper?> getCurrentMint();
  Future<Result<Unit>> updateMintNickname(String mintUrl, String? nickName);
}
