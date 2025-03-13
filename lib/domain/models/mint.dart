import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/value_objects.dart';

part 'mint.freezed.dart';

@freezed
class Mint with _$Mint {
  const factory Mint({
    MintNickName? nickName,
    required MintUrl url,
  }) = _Mint;

  factory Mint.fromData({
    String? nickName,
    required String url,
  }) {
    return Mint(
      nickName: nickName != null ? MintNickName.fromData(nickName) : null,
      url: MintUrl.fromData(url),
    );
  }
}
