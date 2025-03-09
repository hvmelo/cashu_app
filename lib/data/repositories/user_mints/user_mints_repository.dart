import 'package:cashu_app/domain/models/user_mint.dart';

abstract class UserMintsRepository {
  void saveUserMint(UserMint userMint);
  void deleteUserMint(String mintUrl);
  List<UserMint> retrieveAllUserMints();
  UserMint? retrieveUserMint(String mintUrl);
  void saveCurrentMintUrl(String mintUrl);
  String? retrieveCurrentMintUrl();
  void deleteCurrentMintUrl();
  void deleteAllUserMints();
}
