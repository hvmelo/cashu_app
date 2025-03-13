import 'package:freezed_annotation/freezed_annotation.dart';

import '../../config/constants.dart';
import '../../core/types/types.dart';
import '../../ui/utils/string_utils.dart';

part 'mint_nick_name.freezed.dart';

@freezed
class MintNickName with _$MintNickName {
  const MintNickName._(); // Private constructor to enforce validation rules

  const factory MintNickName._internal(String value) = _MintNickName;

  /// Static method for validation + object creation
  static Result<MintNickName, MintNickNameValidationFailure> create(
      String value) {
    final validationResult = validate(value);
    return validationResult.map((_) => MintNickName._internal(value));
  }

  /// Static method for creating a [MintNickName] without validation.
  /// This is useful for creating a [MintNickName] from data that is already
  /// validated.
  static MintNickName fromData(String data) {
    return MintNickName._internal(data.trim());
  }

  /// Validation logic (single source of truth)
  static Result<Unit, MintNickNameValidationFailure> validate(String value) {
    if (value.isEmpty) {
      return Result.error(const MintNickNameValidationFailure.empty());
    }

    if (value.length > mintNicknameMaxLength) {
      return Result.error(
        const MintNickNameValidationFailure.tooLong(
          maxLength: mintNicknameMaxLength,
        ),
      );
    }

    final validCharRegex = RegExp(mintNicknameValidCharRegex);
    if (!validCharRegex.hasMatch(value)) {
      return Result.error(
        MintNickNameValidationFailure.invalidCharacters(
          validCharacters:
              extractValidCharactersFromRegex(mintNicknameValidCharRegex),
        ),
      );
    }

    return Result.ok(unit);
  }
}

/// Represents possible validation failures for a [MintNickName].
@freezed
class MintNickNameValidationFailure with _$MintNickNameValidationFailure {
  const factory MintNickNameValidationFailure.empty() = NicknameEmpty;
  const factory MintNickNameValidationFailure.tooLong({
    required int maxLength,
  }) = NicknameTooLong;
  const factory MintNickNameValidationFailure.invalidCharacters({
    required String validCharacters,
  }) = NicknameInvalidCharacters;
}
