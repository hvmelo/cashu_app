import '../../core/types/types.dart';
import '../../domain/models/models.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/value_objects/value_objects.dart';

/// A fake implementation of the MintRepository for development and testing
class FakeMintRepositoryImpl implements MintRepository {
  final List<Mint> _mints = [
    Mint(
      url: MintUrl.fromData('https://testmint1.cashu.space'),
      nickName: MintNickName.fromData('Test Mint 1'),
    ),
    Mint(
      url: MintUrl.fromData('https://testmint2.cashu.space'),
      nickName: MintNickName.fromData('Test Mint 2'),
    ),
  ];

  String? _currentMintUrl = 'https://testmint1.cashu.space';

  @override
  Future<Result<Unit, Failure>> addMint(
    MintUrl mintUrl, {
    MintNickName? nickName,
  }) async {
    _mints.add(Mint(
      url: mintUrl,
      nickName: nickName,
    ));
    return Result.ok(unit);
  }

  @override
  Future<List<Mint>> listMints() async {
    return _mints;
  }

  @override
  Future<Mint?> getMint(MintUrl mintUrl) async {
    return _mints.where((mint) => mint.url == mintUrl).firstOrNull;
  }

  @override
  Future<Result<Unit, Failure>> updateMint(
    MintUrl mintUrl, {
    MintNickName? nickName,
  }) async {
    final index = _mints.indexWhere((mint) => mint.url == mintUrl);
    if (index >= 0) {
      _mints[index] = Mint(
        url: _mints[index].url,
        nickName: nickName,
      );
    }
    return Result.ok(unit);
  }

  @override
  Future<Result<Unit, Failure>> removeMint(MintUrl mintUrl) async {
    _mints.removeWhere((mint) => mint.url == mintUrl);

    // If the current mint is the one being removed, clear it
    if (_currentMintUrl == mintUrl.value) {
      _currentMintUrl = null;
    }

    return Result.ok(unit);
  }

  @override
  Future<Result<Unit, Failure>> saveCurrentMint(MintUrl mintUrl) async {
    _currentMintUrl = mintUrl.value;
    return Result.ok(unit);
  }

  @override
  Future<Result<Unit, Failure>> removeCurrentMint() async {
    _currentMintUrl = null;
    return Result.ok(unit);
  }

  @override
  Future<Mint?> getCurrentMint() async {
    if (_currentMintUrl == null) {
      return null;
    }
    return await getMint(MintUrl.fromData(_currentMintUrl!));
  }

  @override
  Stream<Result<BigInt, Failure>> mintBalanceStream(MintUrl mintUrl) async* {
    final mint = await getMint(mintUrl);
    if (mint == null) {
      yield Result.error(Failure(Exception('Mint not found')));
    } else {
      // In a real implementation, this would be a stream of balance updates
      // For the fake implementation, we'll just yield a single value
      yield Result.ok(BigInt.from(1000));
    }
  }
}
