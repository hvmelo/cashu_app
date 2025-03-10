import 'package:cashu_app/config/app_providers.dart';
import 'package:cashu_app/domain/models/user_mint.dart';
import 'package:cashu_app/utils/result.dart';
import 'package:cashu_app/utils/url_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_mint_notifier.freezed.dart';
part 'add_mint_notifier.g.dart';

/// Notifier for the add mint screen
@riverpod
class AddMintNotifier extends _$AddMintNotifier {
  @override
  AddMintState build() {
    return AddMintState.initial();
  }

  void urlChanged(String url) {
    state = state.copyWith(
      url: url.trim(),
      urlError: null,
    );
  }

  void nicknameChanged(String nickname) {
    state = state.copyWith(
      nickname: nickname.trim(),
    );
  }

  /// Validates the form inputs
  AddMintError? validate() {
    // Check if the URL is empty
    if (state.url.isEmpty) {
      return AddMintError.emptyUrl();
    }

    // Check if the URL is valid
    if (!UrlUtils.validateUrl(state.url)) {
      return AddMintError.invalidUrl();
    }

    return null;
  }

  /// Adds a new mint to the wallet
  Future<Result<UserMint>> addMint() async {
    // Validate the form
    final error = validate();
    if (error != null) {
      state = state.copyWith(
        urlError: error,
        isSubmitting: false,
      );
      return Result.error(error);
    }

    // Set submitting state
    state = state.copyWith(
      isSubmitting: true,
      error: null,
    );

    try {
      // Add the mint
      final result = await ref.read(addMintUseCaseProvider).execute(
            state.url,
            nickName: state.nickname.isNotEmpty ? state.nickname : null,
          );

      // Handle the result
      switch (result) {
        case Ok():
          // Create a UserMint object to return
          final userMint = UserMint(
            url: state.url,
            nickName: state.nickname.isNotEmpty ? state.nickname : null,
          );

          // Set as current mint if it's the first one
          final allMints = ref.read(allUserMintsProvider);
          if (allMints.length == 1) {
            ref.read(currentMintProvider.notifier).setCurrentMint(state.url);
          }

          // Reset the form
          state = AddMintState.initial().copyWith(
            isSuccess: true,
          );

          return Result.ok(userMint);
        case Error():
          state = state.copyWith(
            isSubmitting: false,
            error: AddMintError.unknown(result.error.toString()),
          );
          return Result.error(result.error, stackTrace: result.stackTrace);
      }
    } catch (e, stackTrace) {
      state = state.copyWith(
        isSubmitting: false,
        error: AddMintError.unknown(e.toString()),
      );
      return Result.error(e, stackTrace: stackTrace);
    }
  }

  void clearErrors() {
    state = state.copyWith(
      urlError: null,
      error: null,
    );
  }

  void reset() {
    state = AddMintState.initial();
  }
}

/// State for the add mint screen
@freezed
class AddMintState with _$AddMintState {
  const AddMintState._();

  factory AddMintState({
    required String url,
    required String nickname,
    required bool isSubmitting,
    required bool isSuccess,
    required AddMintError? urlError,
    required AddMintError? error,
  }) = _AddMintState;

  factory AddMintState.initial() => AddMintState(
        url: '',
        nickname: '',
        isSubmitting: false,
        isSuccess: false,
        urlError: null,
        error: null,
      );
}

@freezed
sealed class AddMintError with _$AddMintError {
  const AddMintError._();

  factory AddMintError.emptyUrl() = EmptyUrlError;
  factory AddMintError.invalidUrl() = InvalidUrlError;
  factory AddMintError.unknown(String message) = UnknownError;

  String get message {
    return switch (this) {
      EmptyUrlError() => 'Mint URL is required',
      InvalidUrlError() => 'Please enter a valid URL',
      UnknownError(:final message) => message,
    };
  }
}
