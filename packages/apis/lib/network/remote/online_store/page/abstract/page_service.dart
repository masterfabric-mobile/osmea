import 'package:apis/network/remote/online_store/page/freeezed_model/response/list_all_pages_response.dart';

abstract class PageService{
  Future<ListAllPagesResponse> listAllPages({
    required String apiVersion,
    int? limit,
    String? sinceId,
    String? createdAtMin,
    String? createdAtMax,
    String? updatedAtMin,
    String? updatedAtMax,
    String? publishedAtMin,
    String? publishedAtMax,
    String? fields,
    String? publishedStatus,
    String? title,
    String? handle,
  });
}