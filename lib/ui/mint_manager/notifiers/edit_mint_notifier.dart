import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/types/result.dart';
import '../../../core/types/unit.dart';
import '../../../data/data_providers.dart';
import '../../../domain/models/mint.dart';
import '../../../domain/value_objects/mint_nick_name.dart';

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
      nickname: mint.nickName?.value ?? '',
      showErrorMessages: false,
    );
  }

  /// Updates the nickname field
  void nicknameChanged(String nickname) =>
      update((state) => state.copyWith(nickname: nickname.trim()));

  /// Saves the changes to the mint
  Future<void> updateMintData() async {
    // Check if we have a valid state value before proceeding
    if (state.hasValue) return;

    // Get the current state value, which we know exists at this point
    final currentState = state.value!;

    // Validate the current nickname value
    final validationResult = currentState.validate();

    // If validation failed, update state with the error
    if (validationResult.isError) {
      state = AsyncError(validationResult.error!, StackTrace.current);
      return;
    }

    // Create a MintNickName value object from the current nickname
    final mintNickNameResult = MintNickName.create(currentState.nickname);

    // If nickname creation failed, update state with the error
    if (mintNickNameResult.isError) {
      state = AsyncError(mintNickNameResult.error!, StackTrace.current);
      return;
    }

    // Get the original mint and created nickname
    final mint = currentState.originalMint;
    final mintNickName = mintNickNameResult.value;

    // Set state to loading while we update the mint
    state = AsyncValue.loading();

    // Get the mint repository and update the mint with new nickname
    final mintRepo = await ref.watch(mintRepositoryProvider.future);
    await mintRepo.updateMint(
      mint.url,
      nickName: mintNickName,
    );

    // Note: Commented out code for updating current mint if needed
    // final currentMint = await ref.read(currentMintNotifierProvider.future);
    // if (currentMint?.url == mint.url) {
    //   ref.invalidate(currentMintNotifierProvider);
    // }

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
    final nicknameValidationResult = MintNickName.validate(nickname);

    return switch (nicknameValidationResult) {
      Ok() => Result.ok(unit),
      Error(:final error) => switch (error) {
          NicknameEmpty() => Result.error(NicknameEmptyError()),
          NicknameTooLong() => Result.error(NicknameTooLongError()),
          NicknameInvalidCharacters() => Result.error(NicknameInvalidError()),
          _ => throw Exception('Unexpected error: $error'),
        },
    };
  }
}

@freezed
sealed class EditMintError with _$EditMintError {
  const EditMintError._();

  factory EditMintError.nicknameEmpty() = NicknameEmptyError;
  factory EditMintError.nicknameTooLong() = NicknameTooLongError;
  factory EditMintError.nicknameInvalid() = NicknameInvalidError;
  factory EditMintError.unknown(String message) = UnknownError;
}
