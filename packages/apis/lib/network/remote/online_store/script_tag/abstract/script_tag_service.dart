import 'package:apis/network/remote/online_store/script_tag/freezed_model/request/create_script_tag_request.dart';
import 'package:apis/network/remote/online_store/script_tag/freezed_model/request/update_script_tag_url_request.dart';
import 'package:apis/network/remote/online_store/script_tag/freezed_model/response/count_all_script_response.dart';
import 'package:apis/network/remote/online_store/script_tag/freezed_model/response/create_script_tag_response.dart';
import 'package:apis/network/remote/online_store/script_tag/freezed_model/response/get_single_script_response.dart';
import 'package:apis/network/remote/online_store/script_tag/freezed_model/response/list_all_script_tags_response.dart';
import 'package:apis/network/remote/online_store/script_tag/freezed_model/response/update_script_tag_url_response.dart';

abstract class ScriptTagService {

  /// 📋 List all script tags
  Future<ListAllScriptTagsResponse> listAllScriptTags({
    required String apiVersion,
    int? limit,
    String? sinceId,
    String? fields,
    String? createdAtMin,
    String? createdAtMax,
    String? updatedAtMin,
    String? updatedAtMax,
    String? publishedAtMin,
    String? publishedAtMax,
    String? src,
  });

  /// 📋 List single script tags
  Future<GetSingleScriptResponse> getSingleScript({
    required String apiVersion,
    required String scriptTagId,
    String? fields,
  });

  /// 🔢 Count all script tags
  Future<CountAllScriptResponse> countAllScriptTags({
    required String apiVersion,
    String? src,
  });

  /// 📋 Create a new script tag
  Future<CreateScriptTagResponse> createScriptTag({
    required String apiVersion,
    required CreateScriptTagRequest body,
  });

  /// 📋 Update Script Tag Url
  Future<UpdateScriptTagUrlResponse> updateScriptTagUrl({
    required String apiVersion,
    required String scriptTagId,
    required UpdateScriptTagUrlRequest body,
  });
}