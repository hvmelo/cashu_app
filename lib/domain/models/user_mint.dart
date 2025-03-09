import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_mint.freezed.dart';
part 'user_mint.g.dart';

@freezed
class UserMint with _$UserMint {
  const factory UserMint({
    String? nickName,
    required String url,
  }) = _UserMint;

  factory UserMint.fromJson(Map<String, dynamic> json) =>
      _$UserMintFromJson(json);
}
