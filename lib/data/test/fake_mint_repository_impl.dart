import 'package:cashu_app/core/types/result.dart';
import 'package:cashu_app/core/types/unit.dart';
import 'package:cashu_app/domain/models/mint_wrapper.dart';
import 'package:cashu_app/domain/repositories/mint_repository.dart';
import 'package:cdk_flutter/cdk_flutter.dart';

/// A fake implementation of the MintRepository for development and testing
class FakeMintRepositoryImpl implements MintRepository {
  final List<MintWrapper> _mints = [
    MintWrapper(
      mint: Mint(
        url: 'https://testmint1.cashu.space',
        balance: BigInt.from(1000),
      ),
      nickName: 'Test Mint 1',
    ),
    MintWrapper(
      mint: Mint(
        url: 'https://testmint2.cashu.space',
        balance: BigInt.from(2000),
      ),
      nickName: 'Test Mint 2',
    ),
  ];

  String? _currentMintUrl = 'https://testmint1.cashu.space';

  @override
  Future<Result<Unit>> addMint(String mintUrl, {String? nickName}) async {
    _mints.add(MintWrapper(
      mint: Mint(
        url: mintUrl,
        balance: BigInt.zero,
      ),
      nickName: nickName,
    ));
    return Result.ok(unit);
  }

  @override
  Future<List<MintWrapper>> listMints() async {
    return _mints;
  }

  @override
  Future<MintWrapper?> getMint(String mintUrl) async {
    return _mints.where((mint) => mint.mint.url == mintUrl).firstOrNull;
  }

  @override
  Future<Result<Unit>> updateMint(String mintUrl, String? nickName) async {
    final index = _mints.indexWhere((mint) => mint.mint.url == mintUrl);
    if (index >= 0) {
      _mints[index] = MintWrapper(
        mint: _mints[index].mint,
        nickName: nickName,
      );
    }
    return Result.ok(unit);
  }

  @override
  Future<Result<Unit>> setCurrentMint(String mintUrl) async {
    _currentMintUrl = mintUrl;
    return Result.ok(unit);
  }

  @override
  Future<MintWrapper?> getCurrentMint() async {
    if (_currentMintUrl == null) {
      return null;
    }
    return getMint(_currentMintUrl!);
  }

  @override
  Stream<Result<BigInt>> mintBalanceStream(String mintUrl) async* {
    final mint = await getMint(mintUrl);
    if (mint == null) {
      yield Result.error(Exception('Mint not found'));
    } else {
      yield Result.ok(mint.mint.balance);
    }
  }
}
