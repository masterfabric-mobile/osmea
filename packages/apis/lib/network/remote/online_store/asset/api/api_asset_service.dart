import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/online_store/asset/abstract/asset_service.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/request/change_liquid_template_value_request.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/request/create_image_asset_base_request.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/request/create_image_asset_source_url_request.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/request/duplicate_asset_source_key_request.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/response/change_liquid_template_value_response.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/response/create_image_asset_base_response.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/response/create_image_asset_source_url_response.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/response/duplicate_asset_source_key_response.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/response/get_liquid_template_response.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/response/list_all_assets_theme_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_asset_service.g.dart';

@RestApi()
@Injectable(as: AssetService)
/// 🌐 AssetService
abstract class AssetServiceClient implements AssetService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory AssetServiceClient(Dio dio) => _AssetServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 📦 List all asset themes in the API.
  @GET('/api/{api_version}/themes/{theme_id}/assets.json')
  Future<ListAllAssetsThemeResponse> listAllAssetTheme({
    @Path('api_version') required String apiVersion,
    @Path('theme_id') required int themeId,
    @Query('fields') String? fields,
  });

  /// 📦 Get a liquid template in the API.
  @GET('/api/{api_version}/themes/{theme_id}/assets.json')
  Future<GetLiquidTemplateResponse> getLiquidTemplate({
    @Path('api_version') required String apiVersion,
    @Path('theme_id') required int themeId,
    @Query('asset[key]') required String assetKey,
  });

  /// 📦 Create an image asset in the API.
  @PUT('/api/{api_version}/themes/{theme_id}/assets.json')
  Future<CreateImageAssetBaseResponse> createImageAsset({
    @Path('api_version') required String apiVersion,
    @Path('theme_id') required int themeId,
    @Body() required CreateImageAssetBaseRequest model,
  });

  /// 📦 Create an image asset source URL in the API.
  @PUT('/api/{api_version}/themes/{theme_id}/assets.json')
  Future<CreateImageAssetSourceUrlResponse> createImageAssetSourceUrl({
    @Path('api_version') required String apiVersion,
    @Path('theme_id') required int themeId,
    @Body() required CreateImageAssetSourceUrlRequest model,
  });

  /// 📦 Change the liquid template value in the API.
  @PUT('/api/{api_version}/themes/{theme_id}/assets.json')
  Future<ChangeLiquidTemplateValueResponse> changeLiquidTemplateValue({
    @Path('api_version') required String apiVersion,
    @Path('theme_id') required int themeId,
    @Body() required ChangeLiquidTemplateValueRequest model,
  });

  /// 📦 Duplicate an asset source key in the API.
  @PUT('/api/{api_version}/themes/{theme_id}/assets.json')
  Future<DuplicateAssetSourceKeyResponse> duplicateAssetSourceKey({
    @Path('api_version') required String apiVersion,
    @Path('theme_id') required int themeId,
    @Body() required DuplicateAssetSourceKeyRequest model,
  });

  /// 📦 Delete an image from the theme in the API.
  @DELETE('/api/{api_version}/themes/{theme_id}/assets.json')
  Future<void> deleteImageFromTheme({
    @Path('api_version') required String apiVersion,
    @Path('theme_id') required int themeId,
    @Query('asset[key]') required String assetKey,
  });
}