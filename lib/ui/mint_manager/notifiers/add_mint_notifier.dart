import 'package:cashu_app/data/data_providers.dart';
import 'package:cashu_app/domain/failures/mint_failures.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/types/result.dart';
import '../../../core/types/unit.dart';
import '../../../domain/value_objects/mint_nickname.dart';
import '../../../domain/value_objects/mint_url.dart';
import '../../core/errors/unexpected_error.dart';
import '../../core/notifiers/current_mint_notifier.dart';
import '../../providers/mint_providers.dart';

part 'add_mint_notifier.freezed.dart';
part 'add_mint_notifier.g.dart';

/// Notifier for the add mint screen
@riverpod
class AddMintNotifier extends _$AddMintNotifier {
  @override
  FutureOr<AddMintState> build() async {
    return AddMintState.initial();
  }

  void urlChanged(String url) {
    update((state) => state.copyWith(
          url: url.trim(),
        ));
  }

  void nicknameChanged(String nickname) {
    update((state) => state.copyWith(
          nickname: nickname.trim(),
        ));
  }

  Result<Unit, MintUrlValidationFailure> validateUrl() {
    final currentState = state.unwrapPrevious().valueOrNull;
    if (currentState == null) {
      return const Result.ok(unit);
    }

    // URL validation
    return MintUrl.validate(currentState.url);
  }

  Result<Unit, MintNicknameValidationFailure> validateNickname() {
    final currentState = state.unwrapPrevious().valueOrNull;
    if (currentState == null) {
      return const Result.ok(unit);
    }

    final nickname = currentState.nickname;

    if (nickname == null || nickname.isEmpty) {
      // Nickname is optional, so we can return ok if it's empty
      return const Result.ok(unit);
    }

    return MintNickname.validate(nickname);
  }

  /// Adds a new mint to the wallet
  Future<void> addMint() async {
    final currentState = state.unwrapPrevious().valueOrNull;

    // Check if we have a valid state value before proceeding
    if (currentState == null) return;

    MintUrl mintUrl;
    // Create a MintUrl value object from the current url
    final mintUrlResult = MintUrl.create(currentState.url);
    switch (mintUrlResult) {
      case Ok(:final value):
        mintUrl = value;
        break;
      case Error():
        update((state) => state.copyWith(showErrorMessages: true));
        return;
    }

    MintNickname? mintNickname;
    // If the nickname is not null, create a MintNickname value object from
    // it
    if (currentState.nickname != null && currentState.nickname!.isNotEmpty) {
      final nicknameResult = MintNickname.create(currentState.nickname!);
      switch (nicknameResult) {
        case Ok(:final value):
          mintNickname = value;
          break;
        case Error():
          update((state) => state.copyWith(showErrorMessages: true));
          return;
      }
    }

    // Set submitting state
    state = AsyncValue.loading();

    // Add the new mint
    final mintRepo = await ref.read(mintRepositoryProvider.future);
    final result = await mintRepo.addMint(
      mintUrl,
      nickname: mintNickname,
    );

    // Handle the result
    switch (result) {
      case Ok():
        // Set as current mint if it's the first one
        final allMints = await ref.read(listMintsProvider.future);
        if (allMints.isNotEmpty && allMints.length == 1) {
          // The setCurrentMint method expects a String, not a MintUrl
          ref
              .read(currentMintNotifierProvider.notifier)
              .setCurrentMint(mintUrl.value);
        }

        // Set state to success
        state = AsyncData(currentState.copyWith(isSuccess: true));
        break;
      case Error(error: final failure):
        state = AsyncError(
          failure,
          StackTrace.current,
        );
        break;
    }
  }
}

/// State for the add mint screen
@freezed
class AddMintState with _$AddMintState {
  const AddMintState._();

  factory AddMintState({
    required String url,
    String? nickname,
    required bool showErrorMessages,
    required bool isSuccess,
  }) = _AddMintState;

  factory AddMintState.initial() => AddMintState(
        url: '',
        nickname: '',
        showErrorMessages: false,
        isSuccess: false,
      );
}

// @freezed
// sealed class AddMintScreenError with _$AddMintScreenError {
//   factory AddMintScreenError.mintUrlValidation(
//       MintUrlValidationFailure failure) = AddMintMintUrlValidationError;
//   factory AddMintScreenError.nicknameValidation(
//       MintNicknameValidationFailure failure) = AddMintNicknameValidationError;
//   factory AddMintScreenError.addMintError(AddMintFailure failure) =
//       AddMintError;
// }
