import 'package:cashu_app/data/data_providers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/types/result.dart';
import '../../../utils/url_utils.dart';
import '../../core/notifiers/current_mint_notifier.dart';

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
  Future<void> addMint() async {
    // Validate the form
    final error = validate();
    if (error != null) {
      state = state.copyWith(
        isSubmitting: false,
      );
      return;
    }

    // Set submitting state
    state = state.copyWith(
      isSubmitting: true,
      error: null,
    );

    // Add the mint
    final mintRepo = await ref.watch(mintRepositoryProvider.future);
    final result = await mintRepo.addMint(
      state.url,
      nickName: state.nickname.isNotEmpty ? state.nickname : null,
    );

    // Handle the result
    switch (result) {
      case Ok():

        // Set as current mint if it's the first one
        final allMints = await ref.read(listMintsProvider.future);
        if (allMints.length == 1) {
          ref
              .read(currentMintNotifierProvider.notifier)
              .setCurrentMint(state.url);
        }

        // Reset the form
        state = state.copyWith(
          isSuccess: true,
        );

        return;
      case Error():
        state = state.copyWith(
          isSubmitting: false,
          error: AddMintError.unknown(result.error.toString()),
        );
        return;
    }
  }

  void clearErrors() {
    state = state.copyWith(
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
    required AddMintError? error,
  }) = _AddMintState;

  factory AddMintState.initial() => AddMintState(
        url: '',
        nickname: '',
        isSubmitting: false,
        isSuccess: false,
        error: null,
      );
}

@freezed
sealed class AddMintError with _$AddMintError {
  const AddMintError._();

  factory AddMintError.emptyUrl() = EmptyUrlError;
  factory AddMintError.invalidUrl() = InvalidUrlError;
  factory AddMintError.unknown(String message) = UnknownError;
}
