import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mint_wrapper.freezed.dart';

@freezed
class MintWrapper with _$MintWrapper {
  const factory MintWrapper({
    String? nickName,
    required Mint mint,
  }) = _MintWrapper;
}
