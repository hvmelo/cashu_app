import '../../core/types/types.dart';
import '../../domain/failures/mint_failures.dart';
import '../../domain/models/models.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/value_objects/value_objects.dart';

/// A fake implementation of the MintRepository for development and testing
class FakeMintRepositoryImpl implements MintRepository {
  final List<Mint> _mints = [
    Mint(
      url: MintUrl.fromData('https://testmint1.cashu.space'),
      nickname: MintNickname.fromData('Test Mint 1'),
    ),
    Mint(
      url: MintUrl.fromData('https://testmint2.cashu.space'),
      nickname: MintNickname.fromData('Test Mint 2'),
    ),
  ];

  String? _currentMintUrl = 'https://testmint1.cashu.space';

  @override
  Future<Result<Unit, AddMintFailure>> addMint(
    MintUrl mintUrl, {
    MintNickname? nickname,
  }) async {
    _mints.add(Mint(
      url: mintUrl,
      nickname: nickname,
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
  Future<Result<Unit, UpdateMintFailure>> updateMint(
    MintUrl mintUrl, {
    MintNickname? nickname,
  }) async {
    final index = _mints.indexWhere((mint) => mint.url == mintUrl);
    if (index >= 0) {
      _mints[index] = Mint(
        url: _mints[index].url,
        nickname: nickname,
      );
    }
    return Result.ok(unit);
  }

  @override
  Future<Result<Unit, RemoveMintFailure>> removeMint(MintUrl mintUrl) async {
    _mints.removeWhere((mint) => mint.url == mintUrl);

    // If the current mint is the one being removed, clear it
    if (_currentMintUrl == mintUrl.value) {
      _currentMintUrl = null;
    }

    return Result.ok(unit);
  }

  @override
  Future<Result<Unit, SaveCurrentMintFailure>> saveCurrentMint(
      MintUrl mintUrl) async {
    _currentMintUrl = mintUrl.value;
    return Result.ok(unit);
  }

  @override
  Future<Result<Unit, RemoveCurrentMintFailure>> removeCurrentMint() async {
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
  Stream<Result<BigInt, MintBalanceStreamFailure>> mintBalanceStream(
      MintUrl mintUrl) async* {
    final mint = await getMint(mintUrl);
    if (mint == null) {
      yield Result.error(
          MintBalanceStreamFailure.unknown(Exception('Mint not found')));
    } else {
      // In a real implementation, this would be a stream of balance updates
      // For the fake implementation, we'll just yield a single value
      yield Result.ok(BigInt.from(1000));
    }
  }
}
