import 'package:apis/network/remote/online_store/asset/freezed_model/request/change_liquid_template_value_request.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/request/create_image_asset_base_request.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/request/create_image_asset_source_url_request.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/response/change_liquid_template_value_response.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/response/create_image_asset_base_response.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/response/create_image_asset_source_url_response.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/response/get_liquid_template_response.dart';
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

  Future<CreateImageAssetSourceUrlResponse> createImageAssetSourceUrl({
    required String apiVersion,
    required int themeId,
    required CreateImageAssetSourceUrlRequest model,
  });

  Future<GetLiquidTemplateResponse> getLiquidTemplate({
    required String apiVersion,
    required int themeId,
    required String assetKey,
  });

  Future<ChangeLiquidTemplateValueResponse> changeLiquidTemplateValue({
    required String apiVersion,
    required int themeId,
    required ChangeLiquidTemplateValueRequest model,
  });
}