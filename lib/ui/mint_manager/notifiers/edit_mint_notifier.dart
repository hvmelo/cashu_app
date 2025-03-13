import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/types/result.dart';
import '../../../core/types/unit.dart';
import '../../../data/data_providers.dart';
import '../../../domain/models/mint.dart';
import '../../../domain/value_objects/mint_nickname.dart';

part 'edit_mint_notifier.freezed.dart';
part 'edit_mint_notifier.g.dart';

/// Notifier for the edit mint screen
@riverpod
class EditMintNotifier extends _$EditMintNotifier {
  @override
  FutureOr<EditMintState> build(Mint mint) {
    // Initialize with the original nickname
    return EditMintState(
      originalMint: mint,
      nickname: mint.nickname?.value ?? '',
      showErrorMessages: false,
    );
  }

  /// Updates the nickname field
  void nicknameChanged(String nickname) =>
      update((state) => state.copyWith(nickname: nickname.trim()));

  /// Saves the changes to the mint
  Future<void> updateMintData() async {
    final currentState = state.unwrapPrevious().valueOrNull;

    // Check if we have a valid state value before proceeding
    if (currentState == null) return;

    // Validate the current nickname value
    final validationResult = currentState.validate();

    // If validation failed, update state with the error
    if (validationResult.isError) {
      update((state) => state.copyWith(showErrorMessages: true));
      return;
    }

    // Nickname is optional
    MintNickname? mintNickname;

    if (currentState.nickname.isNotEmpty) {
      // Create a MintNickname value object from the current nickname
      final mintNicknameResult = MintNickname.create(currentState.nickname);

      // If nickname creation failed, update state with the error
      if (mintNicknameResult.isError) {
        state = AsyncError(mintNicknameResult.error!, StackTrace.current);
        return;
      }
      mintNickname = mintNicknameResult.value;
    }

    // Get the original mint
    final mint = currentState.originalMint;

    // Set state to loading while we update the mint
    state = AsyncValue.loading();

    // Get the mint repository and update the mint with new nickname
    final mintRepo = await ref.watch(mintRepositoryProvider.future);
    await mintRepo.updateMint(
      mint.url,
      nickname: mintNickname,
    );

    // Update state with success
    state = AsyncData(currentState.copyWith(isSuccess: true));
  }
}

/// Simple model to hold the current nickname
@freezed
class EditMintState with _$EditMintState {
  const EditMintState._();

  factory EditMintState({
    required Mint originalMint,
    required String nickname,
    required bool showErrorMessages,
    @Default(false) bool isSuccess,
  }) = _EditMintState;

  /// Validates the nickname
  Result<Unit, EditMintError> validate() {
    if (nickname.isEmpty) {
      // Nickname is optional, so we can return ok if it's empty
      return Result.ok(unit);
    }

    final nicknameValidationResult = MintNickname.validate(nickname);

    return switch (nicknameValidationResult) {
      Ok() => Result.ok(unit),
      Error(:final error) => switch (error) {
          NicknameEmpty() => Result.error(EditMintNicknameEmptyError()),
          NicknameTooLong() => Result.error(EditMintNicknameTooLongError()),
          NicknameInvalidCharacters() =>
            Result.error(EditMintNicknameInvalidError()),
          _ => throw Exception('Unexpected error: $error'),
        },
    };
  }
}

@freezed
sealed class EditMintError with _$EditMintError {
  const EditMintError._();

  factory EditMintError.nicknameEmpty() = EditMintNicknameEmptyError;
  factory EditMintError.nicknameTooLong() = EditMintNicknameTooLongError;
  factory EditMintError.nicknameInvalid() = EditMintNicknameInvalidError;
  factory EditMintError.unknown(String message) = EditMintUnknownError;
}
