import '../models/mint_wrapper.dart';

abstract class MintRepository {
  Future<void> addMint(String mintUrl, {String? nickName});
  Future<List<MintWrapper>> listMints();
  Future<MintWrapper?> getMint(String mintUrl);
}
