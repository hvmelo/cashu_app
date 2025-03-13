import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/value_objects.dart';

part 'mint.freezed.dart';

@freezed
class Mint with _$Mint {
  const factory Mint({
    MintNickname? nickname,
    required MintUrl url,
  }) = _Mint;

  factory Mint.fromData({
    String? nickname,
    required String url,
  }) {
    return Mint(
      nickname: nickname != null ? MintNickname.fromData(nickname) : null,
      url: MintUrl.fromData(url),
    );
  }
}
