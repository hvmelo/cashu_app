import '../models/mint_wrapper.dart';

abstract class MintRepository {
  Future<void> addMint(String mintUrl);
  Future<List<MintWrapper>> listMints();
  Future<MintWrapper?> getMint(String mintUrl);
}
