import 'package:cashu_app/data/data_providers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/types/result.dart';
import '../../../core/types/unit.dart';
import '../../../domain/value_objects/mint_nick_name.dart';
import '../../../domain/value_objects/mint_url.dart';
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

  /// Adds a new mint to the wallet
  Future<void> addMint() async {
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

    // Create a MintUrl value object from the current url
    final mintUrlResult = MintUrl.create(currentState.url);

    // Handle result with pattern matching
    switch (mintUrlResult) {
      case Ok(value: final mintUrl):
        // Create MintNickName if provided
        MintNickName? mintNickName;
        if (currentState.nickname != null) {
          final nickNameResult = MintNickName.create(currentState.nickname!);
          if (nickNameResult.isError) {
            state = AsyncError(
              AddMintScreenError.unknown(nickNameResult.error.toString()),
              StackTrace.current,
            );
            return;
          }
          mintNickName = nickNameResult.value;
        }

        // Set submitting state
        state = AsyncValue.loading();

        // Add the mint
        final mintRepo = await ref.read(mintRepositoryProvider.future);
        final result = await mintRepo.addMint(
          mintUrl,
          nickName: mintNickName,
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
          case Error():
            state = AsyncError(
              AddMintScreenError.unknown(result.error.toString()),
              StackTrace.current,
            );
            break;
        }

      case Error(:final error):
        state = AsyncError(
          AddMintScreenError.unknown(error.toString()),
          StackTrace.current,
        );
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
        nickname: null,
        showErrorMessages: false,
        isSuccess: false,
      );

  Result<Unit, AddMintScreenError> validate() {
    // URL validation
    final urlValidationResult = MintUrl.validate(url);

    if (urlValidationResult.isError) {
      return switch (urlValidationResult.error) {
        MintUrlEmpty() => Result.error(AddMintScreenError.emptyUrl()),
        MintUrlInvalid() => Result.error(AddMintScreenError.invalidUrl()),
        _ => Result.error(
            AddMintScreenError.unknown(urlValidationResult.error.toString())),
      };
    }

    return Result.ok(unit);
  }
}

@freezed
sealed class AddMintScreenError with _$AddMintScreenError {
  const AddMintScreenError._();

  factory AddMintScreenError.emptyUrl() = EmptyUrlError;
  factory AddMintScreenError.invalidUrl() = InvalidUrlError;
  factory AddMintScreenError.unknown(String message) = UnknownError;
}
