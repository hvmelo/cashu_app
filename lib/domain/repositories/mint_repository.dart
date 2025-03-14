import '../../core/types/types.dart';
import '../failures/mint_failures.dart';
import '../models/mint.dart';
import '../value_objects/value_objects.dart';

abstract class MintRepository {
  Future<Result<Unit, AddMintFailure>> addMint(MintUrl mintUrl,
      {MintNickname? nickname});
  Future<List<Mint>> listMints();
  Future<Mint?> getMint(MintUrl mintUrl);
  Future<Result<Unit, UpdateMintFailure>> updateMint(MintUrl mintUrl,
      {MintNickname? nickname});
  Future<Result<Unit, RemoveMintFailure>> removeMint(MintUrl mintUrl);
  Future<Result<Unit, SaveCurrentMintFailure>> saveCurrentMint(MintUrl mintUrl);
  Future<Result<Unit, RemoveCurrentMintFailure>> removeCurrentMint();
  Future<Mint?> getCurrentMint();
  Stream<Result<BigInt, MintBalanceStreamFailure>> mintBalanceStream(
      MintUrl mintUrl);
}
