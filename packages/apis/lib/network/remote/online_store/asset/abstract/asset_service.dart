import 'package:apis/network/remote/online_store/asset/freezed_model/list_all_assets_theme_response.dart';

abstract class AssetService {
  Future<ListAllAssetsThemeResponse> listAllAssetTheme({
    required String apiVersion,
    required int themeId,
    String? fields,
  });
}