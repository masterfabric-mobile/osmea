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

}