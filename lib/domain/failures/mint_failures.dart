import 'package:freezed_annotation/freezed_annotation.dart';

part 'mint_failures.freezed.dart';

@freezed
class AddMintFailure with _$AddMintFailure {
  const factory AddMintFailure.alreadyExists() = AddMintAlreadyExists;
  const factory AddMintFailure.unknown(Object error, {StackTrace? stackTrace}) =
      AddMintUnknown;
}

@freezed
class UpdateMintFailure with _$UpdateMintFailure {
  const factory UpdateMintFailure.unknown(Object error,
      {StackTrace? stackTrace}) = UpdateMintUnknown;
}

@freezed
class RemoveMintFailure with _$RemoveMintFailure {
  const factory RemoveMintFailure.unknown(Object error,
      {StackTrace? stackTrace}) = RemoveMintUnknown;
}

@freezed
class SaveCurrentMintFailure with _$SaveCurrentMintFailure {
  const factory SaveCurrentMintFailure.unknown(Object error,
      {StackTrace? stackTrace}) = SaveCurrentMintUnknown;
}

@freezed
class RemoveCurrentMintFailure with _$RemoveCurrentMintFailure {
  const factory RemoveCurrentMintFailure.unknown(Object error,
      {StackTrace? stackTrace}) = RemoveCurrentMintUnknown;
}

@freezed
class MintBalanceStreamFailure with _$MintBalanceStreamFailure {
  const factory MintBalanceStreamFailure.unknown(Object error,
      {StackTrace? stackTrace}) = MintBalanceStreamUnknown;
}
