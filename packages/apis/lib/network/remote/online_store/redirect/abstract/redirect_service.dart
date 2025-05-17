import 'package:apis/network/remote/online_store/redirect/freezed_model/request/create_redirect_full_url_request.dart';
import 'package:apis/network/remote/online_store/redirect/freezed_model/response/count_all_redirects_response.dart';
import 'package:apis/network/remote/online_store/redirect/freezed_model/response/create_redirect_full_url_response.dart';
import 'package:apis/network/remote/online_store/redirect/freezed_model/response/get_single_redirect_response.dart';
import 'package:apis/network/remote/online_store/redirect/freezed_model/response/list_all_redirects_response.dart';

abstract class RedirectService {
  
  /// 🔄 List all redirects
  Future<ListAllRedirectsResponse> listAllRedirects({
    required String apiVersion,
    int? limit,
    String? sinceId,
    String? path,
    String? target,
    String? fields,
  });

  /// 🔄 Get Single Redirect
  Future<GetSingleRedirectResponse> getSingleRedirect({
    required String apiVersion,
    required String redirectId,
    String? fields,
  });

  /// 🔄 Count All Redirects
  Future<CountAllRedirectsResponse> countAllRedirects({
    required String apiVersion,
    String? path,
    String? target,
  });

  /// 🆕 Create Redirect Full Url
  Future<CreateRedirectFullUrlResponse> createRedirectFullUrl({
    required String apiVersion,
    required CreateRedirectFullUrlRequest body,
  });

}