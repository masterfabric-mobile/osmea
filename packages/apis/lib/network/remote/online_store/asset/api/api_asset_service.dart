import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/online_store/asset/abstract/asset_service.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/request/create_image_asset_base_request.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/request/create_image_asset_source_url_request.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/response/create_image_asset_base_response.dart';
import 'package:apis/network/remote/online_store/asset/freezed_model/response/create_image_asset_source_url_response.dart';
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
}