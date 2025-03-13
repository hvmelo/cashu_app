import 'package:freezed_annotation/freezed_annotation.dart';

import '../../config/constants.dart';
import '../../core/types/types.dart';

part 'mint_nickname.freezed.dart';

@freezed
class MintNickname with _$MintNickname {
  const MintNickname._(); // Private constructor to enforce validation rules

  const factory MintNickname._internal(String value) = _MintNickname;

  /// Static method for validation + object creation
  static Result<MintNickname, MintNicknameValidationFailure> create(
      String value) {
    final validationResult = validate(value);
    return validationResult.map((_) => MintNickname._internal(value));
  }

  /// Static method for creating a [MintNickname] without validation.
  /// This is useful for creating a [MintNickname] from data that is already
  /// validated.
  static MintNickname fromData(String data) {
    return MintNickname._internal(data.trim());
  }

  /// Validation logic (single source of truth)
  static Result<Unit, MintNicknameValidationFailure> validate(String value) {
    if (value.isEmpty) {
      return Result.error(const MintNicknameValidationFailure.empty());
    }

    if (value.length > mintNicknameMaxLength) {
      return Result.error(
        const MintNicknameValidationFailure.tooLong(
          maxLength: mintNicknameMaxLength,
        ),
      );
    }

    final validCharRegex = RegExp(mintNicknameValidCharRegex);
    if (!validCharRegex.hasMatch(value)) {
      return Result.error(
          const MintNicknameValidationFailure.invalidCharacters());
    }

    return Result.ok(unit);
  }
}

/// Represents possible validation failures for a [MintNickname].
@freezed
class MintNicknameValidationFailure with _$MintNicknameValidationFailure {
  const factory MintNicknameValidationFailure.empty() = NicknameEmpty;
  const factory MintNicknameValidationFailure.tooLong({
    required int maxLength,
  }) = NicknameTooLong;
  const factory MintNicknameValidationFailure.invalidCharacters() =
      NicknameInvalidCharacters;
}
