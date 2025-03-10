import 'package:cashu_app/config/app_providers.dart';
import 'package:cashu_app/domain/models/mint_wrapper.dart';
import 'package:cashu_app/core/types/result.dart';
import 'package:cashu_app/core/types/unit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_mints_notifier.g.dart';

@riverpod
class UserMintsNotifier extends _$UserMintsNotifier {
  @override
  List<UserMint> build() {
    return ref.read(userMintRepositoryProvider).retrieveAllUserMints();
  }

  Future<Result<Unit>> addMint(String mintUrl, {String? nickName}) async {
    final addUserMint = ref.read(addMintUseCaseProvider);
    final result = await addUserMint.execute(mintUrl, nickName: nickName);
    if (result.isOk) {
      state = ref.read(userMintRepositoryProvider).retrieveAllUserMints();
    }
    return result;
  }

  // Future<Result<Unit>> removeMint(String mintUrl) async {
  //   final removeUserMint = ref.read(removeMintUseCaseProvider);
  //   final result = await removeUserMint.execute(mintUrl);
  //   if (result.isOk) {
  //     state = AsyncValue.data(ref.watch(userMintRepositoryProvider).retrieveAllUserMints());
  //   }
  //   return result;
  // }
}
