import 'package:cashu_app/config/cashu_providers.dart';
import 'package:cashu_app/data/repositories/mint_info/mint_info_repository.dart';
import 'package:cashu_app/data/repositories/mint_info/mint_info_repository_remote.dart';
import 'package:cashu_app/data/repositories/user_mints/user_mints_repository.dart';
import 'package:cashu_app/data/repositories/user_mints/user_mints_repository_local.dart';
import 'package:cashu_app/domain/models/mint_info.dart';
import 'package:cashu_app/domain/models/user_mint.dart';
import 'package:cashu_app/domain/use-cases/add_mint_use_case.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_providers.g.dart';

// Notifier to control the app theme
@Riverpod(keepAlive: true)
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }
}

@Riverpod(keepAlive: true)
SharedPreferences? sharedPreferences(Ref ref) {
  return null;
}

@Riverpod(keepAlive: true)
MintInfoRepository mintInfoRepository(Ref ref) {
  return const MintInfoRepositoryRemote();
}

@Riverpod(keepAlive: true)
UserMintsRepository userMintRepository(Ref ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  if (prefs == null) {
    throw Exception('SharedPreferences not found');
  }
  return UserMintsRepositoryLocal(prefs: prefs);
}

@riverpod
AddMintUseCase addMintUseCase(Ref ref) {
  final multiMintWallet = ref.read(multiMintWalletProvider);
  final userMintsRepository = ref.read(userMintRepositoryProvider);

  if (multiMintWallet == null) {
    throw Exception('MultiMintWallet not found');
  }

  return AddMintUseCase(
    multiMintWallet: multiMintWallet,
    userMintsRepository: userMintsRepository,
  );
}

@riverpod
List<UserMint> allUserMints(Ref ref) {
  final userMintRepository = ref.read(userMintRepositoryProvider);
  return userMintRepository.retrieveAllUserMints();
}

@riverpod
class CurrentMint extends _$CurrentMint {
  @override
  UserMint? build() {
    final userMintRepository = ref.read(userMintRepositoryProvider);
    final currentMintUrl = userMintRepository.retrieveCurrentMintUrl();
    if (currentMintUrl == null) {
      return null;
    }
    return userMintRepository.retrieveUserMint(currentMintUrl);
  }

  void setCurrentMint(String mintUrl) {
    final userMintRepository = ref.read(userMintRepositoryProvider);
    userMintRepository.saveCurrentMintUrl(mintUrl);
    state = userMintRepository.retrieveUserMint(mintUrl);
  }
}

@riverpod
Future<MintInfo> mintInfo(Ref ref, String mintUrl) async {
  final mintInfoRepository = ref.read(mintInfoRepositoryProvider);
  return mintInfoRepository.getMintInfo(mintUrl);
}
