import 'package:cashu_app/domain/models/mint_info.dart';

abstract class MintInfoRepository {
  Future<MintInfo> getMintInfo(String mintUrl);
}
