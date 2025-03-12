import 'package:cashu_app/data/services/local_storage_service.dart';

class MintLocalStorage {
  final LocalStorageService localPropertiesService;

  MintLocalStorage({required this.localPropertiesService});

  Future<void> saveMintNickname(String mintUrl, String? nickname) async {
    await localPropertiesService.saveProperty(
        'mint_nickname_$mintUrl', nickname);
  }

  String? getMintNickname(String mintUrl) {
    return localPropertiesService.getProperty<String>('mint_nickname_$mintUrl');
  }

  Future<void> saveCurrentMintUrl(String mintUrl) async {
    await localPropertiesService.saveProperty('current_mint_url', mintUrl);
  }

  String? getCurrentMintUrl() {
    return localPropertiesService.getProperty<String>('current_mint_url');
  }
}
