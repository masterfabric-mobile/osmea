import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/online_store/script_tag/abstract/script_tag_service.dart';
import 'package:apis/network/remote/online_store/script_tag/freezed_model/request/create_script_tag_request.dart';
import 'package:apis/network/remote/online_store/script_tag/freezed_model/request/update_script_tag_url_request.dart';
import 'package:apis/network/remote/online_store/script_tag/freezed_model/response/count_all_script_response.dart';
import 'package:apis/network/remote/online_store/script_tag/freezed_model/response/create_script_tag_response.dart';
import 'package:apis/network/remote/online_store/script_tag/freezed_model/response/get_single_script_response.dart';
import 'package:apis/network/remote/online_store/script_tag/freezed_model/response/list_all_script_tags_response.dart';
import 'package:apis/network/remote/online_store/script_tag/freezed_model/response/update_script_tag_url_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_script_tag_service.g.dart';

@RestApi()
@Injectable(as: ScriptTagService)
/// 🌐 ScriptTagService
abstract class ScriptTagServiceClient implements ScriptTagService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory ScriptTagServiceClient(Dio dio) => _ScriptTagServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🔄 List all script tags
  @GET('/api/{api_version}/script_tags.json')
  Future<ListAllScriptTagsResponse> listAllScriptTags({
    @Path('api_version') required String apiVersion,
    @Query('limit') int? limit,
    @Query('since_id') String? sinceId,
    @Query('fields') String? fields,
    @Query('created_at_min') String? createdAtMin,
    @Query('created_at_max') String? createdAtMax,
    @Query('updated_at_min') String? updatedAtMin,
    @Query('updated_at_max') String? updatedAtMax,
    @Query('published_at_min') String? publishedAtMin,
    @Query('published_at_max') String? publishedAtMax,
    @Query('src') String? src,
  });

  /// 🔄 Get single script tag
  @GET('/api/{api_version}/script_tags/{script_tag_id}.json')
  Future<GetSingleScriptResponse> getSingleScript({
    @Path('api_version') required String apiVersion,
    @Path('script_tag_id') required String scriptTagId,
    @Query('fields') String? fields,
  });

  /// 🔢 Count All Script
  @GET('/api/{api_version}/script_tags/count.json')
  Future<CountAllScriptResponse> countAllScriptTags({
    @Path('api_version') required String apiVersion,
    @Query('src') String? src,
  });

  /// 🔄 Create a new script tag
  @POST('/api/{api_version}/script_tags.json')
  Future<CreateScriptTagResponse> createScriptTag({
    @Path('api_version') required String apiVersion,
    @Body() required CreateScriptTagRequest body,
  });

  /// 🔄 Update Script Tag Url
  @PUT('/api/{api_version}/script_tags/{script_tag_id}.json')
  Future<UpdateScriptTagUrlResponse> updateScriptTagUrl({
    @Path('api_version') required String apiVersion,
    @Path('script_tag_id') required String scriptTagId,
    @Body() required UpdateScriptTagUrlRequest body,
  });

  /// 🗑️ Delete Script Tag
  @DELETE('/api/{api_version}/script_tags/{script_tag_id}.json')
  Future<void> deleteScriptTag({
    @Path('api_version') required String apiVersion,
    @Path('script_tag_id') required String scriptTagId,
  });
}