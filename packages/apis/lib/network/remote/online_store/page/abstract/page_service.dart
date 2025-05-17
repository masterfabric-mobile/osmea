import 'package:apis/network/remote/online_store/blog/freezed_model/response/count_all_blogs_response.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/request/create_page_html_markup_request.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/request/create_page_with_metafield_request.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/response/create_page_html_markup_response.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/response/create_page_with_metafield_response.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/response/get_single_page_response.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/response/list_all_pages_response.dart';

abstract class PageService{

  /// 📦 List all pages
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

  /// 📄 Get single page
  Future<GetSinglePageResponse> getSinglePage({
    required String apiVersion,
    required String pageId,
    String? fields,
  });

  /// 📄 Count All Pages
  Future<CountAllBlogsResponse> countAllPages({
    required String apiVersion,
    String? title,
    String? createdAtMin,
    String? createdAtMax,
    String? updatedAtMin,
    String? updatedAtMax,
    String? publishedAtMin,
    String? publishedAtMax,
    String? publishedStatus,
  });

  /// 📄 Create Page with Metafield
  Future<CreatePageWithMetafieldResponse> createPageWithMetafield({
    required String apiVersion,
    required CreatePageWithMetafieldRequest model,
  });

  /// 📄 Create Page with HTML Markup
  Future<CreatePageHtmlMarkupResponse> createPageHtmlMarkup({
    required String apiVersion,
    required CreatePageHtmlMarkupRequest model,
  });
}