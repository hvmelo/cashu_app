import '../../core/types/types.dart';
import '../models/mint.dart';
import '../value_objects/value_objects.dart';

abstract class MintRepository {
  Future<Result<Unit, Failure>> addMint(MintUrl mintUrl,
      {MintNickName? nickName});
  Future<List<Mint>> listMints();
  Future<Mint?> getMint(MintUrl mintUrl);
  Future<Result<Unit, Failure>> updateMint(MintUrl mintUrl,
      {MintNickName? nickName});
  Future<Result<Unit, Failure>> removeMint(MintUrl mintUrl);
  Future<Result<Unit, Failure>> saveCurrentMint(MintUrl mintUrl);
  Future<Result<Unit, Failure>> removeCurrentMint();
  Future<Mint?> getCurrentMint();
  Stream<Result<BigInt, Failure>> mintBalanceStream(MintUrl mintUrl);
}
