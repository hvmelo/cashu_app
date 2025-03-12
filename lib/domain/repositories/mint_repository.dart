import '../../core/types/result.dart';
import '../../core/types/unit.dart';
import '../models/mint_wrapper.dart';

abstract class MintRepository {
  Future<Result<Unit>> addMint(String mintUrl, {String? nickName});
  Future<List<MintWrapper>> listMints();
  Future<MintWrapper?> getMint(String mintUrl);
  Future<Result<Unit>> updateMint(String mintUrl, String? nickName);
  Future<Result<Unit>> setCurrentMint(String mintUrl);
  Future<MintWrapper?> getCurrentMint();
  Stream<Result<BigInt>> mintBalanceStream(String mintUrl);
}
