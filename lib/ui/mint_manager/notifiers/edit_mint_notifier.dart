import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/types/result.dart';
import '../../../core/types/unit.dart';
import '../../../data/data_providers.dart';
import '../../../domain/failures/mint_failures.dart';
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

  /// Validates the nickname
  Result<Unit, MintNicknameValidationFailure> validateNickname() {
    final currentState = state.unwrapPrevious().valueOrNull;
    if (currentState == null) {
      return const Result.ok(unit);
    }
    return MintNickname.validate(currentState.nickname);
  }

  /// Saves the changes to the mint
  Future<void> updateMintData() async {
    final currentState = state.unwrapPrevious().valueOrNull;

    // Check if we have a valid state value before proceeding
    if (currentState == null) return;

    MintNickname? mintNickname;
    // If the nickname is not null, create a MintNickname value object from
    // it
    if (currentState.nickname.isNotEmpty) {
      final nicknameResult = MintNickname.create(currentState.nickname);
      switch (nicknameResult) {
        case Ok(:final value):
          mintNickname = value;
          break;
        case Error():
          update((state) => state.copyWith(showErrorMessages: true));
          return;
      }
    }

    // Get the original mint
    final mint = currentState.originalMint;

    // Set state to loading while we update the mint
    state = AsyncValue.loading();

    // Get the mint repository and update the mint with new nickname
    final mintRepo = await ref.read(mintRepositoryProvider.future);
    final result = await mintRepo.updateMint(
      mint.url,
      nickname: mintNickname,
    );

    // Handle the result
    switch (result) {
      case Ok():
        // Set state to success
        state = AsyncData(currentState.copyWith(isSuccess: true));
        break;
      case Error(error: final failure):
        state = AsyncError(
          EditMintDialogError.updateMintError(failure),
          StackTrace.current,
        );
        break;
    }
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
}

@freezed
sealed class EditMintDialogError with _$EditMintDialogError {
  const factory EditMintDialogError.nicknameValidation(
      MintNicknameValidationFailure failure) = EditMintNicknameValidationError;
  const factory EditMintDialogError.updateMintError(UpdateMintFailure failure) =
      EditMintUpdateMintError;
}
