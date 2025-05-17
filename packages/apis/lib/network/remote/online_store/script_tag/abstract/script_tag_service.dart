import 'package:apis/network/remote/online_store/script_tag/freezed_model/response/get_single_script_response.dart';
import 'package:apis/network/remote/online_store/script_tag/freezed_model/response/list_all_script_tags_response.dart';

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
}