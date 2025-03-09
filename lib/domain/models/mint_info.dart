import 'package:freezed_annotation/freezed_annotation.dart';

part 'mint_info.freezed.dart';
part 'mint_info.g.dart';

@freezed
class MintInfo with _$MintInfo {
  const factory MintInfo({
    required String name,
    required String pubkey,
    required String version,
    required String description,
    required String descriptionLong,
    required List<String> contact,
    required List<String> icon,
    required List<String> nuts,
    required List<String> parameter,
    required String motd,
  }) = _MintInfo;

  factory MintInfo.fromJson(Map<String, dynamic> json) =>
      _$MintInfoFromJson(json);
}
