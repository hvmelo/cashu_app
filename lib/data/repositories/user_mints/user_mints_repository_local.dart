import 'dart:convert';

import 'package:cashu_app/config/constants.dart';
import 'package:cashu_app/data/repositories/user_mints/user_mints_repository.dart';
import 'package:cashu_app/domain/models/user_mint.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserMintsRepositoryLocal extends UserMintsRepository {
  final SharedPreferences prefs;

  UserMintsRepositoryLocal({required this.prefs});

  @override
  void saveUserMint(UserMint userMint) {
    final userMintJson = jsonEncode(userMint.toJson());
    final userMints = prefs.getStringList(userMintsKey);

    if (userMints == null) {
      prefs.setStringList(userMintsKey, [userMintJson]);
    } else {
      // Check if a mint with the same URL already exists
      final existingMints =
          userMints.map((e) => UserMint.fromJson(jsonDecode(e))).toList();
      final existingMint =
          existingMints.where((mint) => mint.url == userMint.url).firstOrNull;
      if (existingMint != null) {
        // Replace the existing mint with the new one
        existingMints.remove(existingMint);
      }
      existingMints.add(userMint);
      prefs.setStringList(userMintsKey,
          existingMints.map((e) => jsonEncode(e.toJson())).toList());
    }
  }

  @override
  void deleteUserMint(String mintUrl) {
    final userMints = prefs.getStringList(userMintsKey);
    if (userMints == null) {
      return;
    }
    userMints.removeWhere((e) {
      return e.contains(mintUrl);
    });
    prefs.setStringList(userMintsKey, userMints);
  }

  @override
  List<UserMint> retrieveAllUserMints() {
    final userMints = prefs.getStringList(userMintsKey);
    if (userMints == null) {
      return [];
    }
    return userMints.map((e) => UserMint.fromJson(jsonDecode(e))).toList();
  }

  @override
  UserMint? retrieveUserMint(String mintUrl) {
    final userMints = retrieveAllUserMints();
    return userMints.firstWhere((e) => e.url == mintUrl);
  }

  @override
  String? retrieveCurrentMintUrl() {
    return prefs.getString(currentMintKey);
  }

  @override
  void saveCurrentMintUrl(String mintUrl) {
    prefs.setString(currentMintKey, mintUrl);
  }

  @override
  void deleteCurrentMintUrl() {
    prefs.remove(currentMintKey);
  }

  @override
  void deleteAllUserMints() {
    prefs.remove(userMintsKey);
  }
}
