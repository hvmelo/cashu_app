import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/types/types.dart';

part 'mint_url.freezed.dart';

@freezed
class MintUrl with _$MintUrl {
  const MintUrl._(); // Private constructor to enforce validation rules

  const factory MintUrl._internal(String value) = _MintUrl;

  /// Static method for validation + object creation
  static Result<MintUrl, MintUrlValidationFailure> create(String value) {
    final validationResult = validate(value);
    return validationResult.map((_) => MintUrl._internal(value));
  }

  /// Static method for creating a [MintUrl] without validation.
  /// This is useful for creating a [MintUrl] from data that is already
  /// validated.
  static MintUrl fromData(String data) {
    return MintUrl._internal(data.trim());
  }

  /// Validation logic (single source of truth)
  static Result<Unit, MintUrlValidationFailure> validate(String value) {
    if (value.isEmpty) {
      return Result.error(const MintUrlValidationFailure.empty());
    }

    try {
      final uri = Uri.parse(value);
      if (!uri.hasScheme || !uri.hasAuthority) {
        return Result.error(const MintUrlValidationFailure.invalid());
      }
    } catch (_) {
      return Result.error(const MintUrlValidationFailure.invalid());
    }

    return Result.ok(unit);
  }

  String extractAuthority() {
    final uri = Uri.parse(value);
    return uri.authority;
  }
}

/// Represents possible validation failures for a [MintUrl].
@freezed
class MintUrlValidationFailure with _$MintUrlValidationFailure {
  const factory MintUrlValidationFailure.empty() = MintUrlEmpty;
  const factory MintUrlValidationFailure.invalid() = MintUrlInvalid;
}
