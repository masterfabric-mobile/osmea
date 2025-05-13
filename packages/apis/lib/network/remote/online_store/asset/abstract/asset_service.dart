import 'package:apis/network/remote/online_store/asset/freezed_model/request/create_image_asset_base_request.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/response/create_image_asset_base_response.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/response/list_all_assets_theme_response.dart';

abstract class AssetService {
  Future<ListAllAssetsThemeResponse> listAllAssetTheme({
    required String apiVersion,
    required int themeId,
    String? fields,
  });

  Future<CreateImageAssetBaseResponse> createImageAsset({
    required String apiVersion,
    required int themeId,
    required CreateImageAssetBaseRequest model,
  });
}