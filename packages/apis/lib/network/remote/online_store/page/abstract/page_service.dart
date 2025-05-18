import 'package:apis/network/remote/online_store/blog/freezed_model/response/count_all_blogs_response.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/request/add_metafield_to_page_request.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/request/create_page_html_markup_request.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/request/create_page_with_metafield_request.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/request/create_unpublished_page_request.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/request/hide_published_page_request.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/request/show_hidden_page_request.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/request/update_body_html_of_page_request.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/request/update_existing_page_completely_request.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/response/add_metafield_to_page_response.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/response/create_page_html_markup_response.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/response/create_page_with_metafield_response.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/response/create_unpublished_page_response.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/response/get_single_page_response.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/response/hide_published_page_response.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/response/list_all_pages_response.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/response/show_hidden_page_response.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/response/update_body_html_of_page_response.dart';
import 'package:apis/network/remote/online_store/page/freeezed_model/response/update_existing_page_completely_response.dart';

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

  /// 📄 Create Unpublished Page
  Future<CreateUnpublishedPageResponse> createUnpublishedPage({
    required String apiVersion,
    required CreateUnpublishedPageRequest model,
  });

  /// 📄 Update Existing Page Completely
  Future<UpdateExistingPageCompletelyResponse> updateExistingPageCompletely({
    required String apiVersion,
    required String pageId,
    required UpdateExistingPageCompletelyRequest model,
  });

  /// 📄 Add Metafield To Page
  Future<AddMetafieldToPageResponse> addMetafieldToPage({
    required String apiVersion,
    required String pageId,
    required AddMetafieldToPageRequest model,
  });

  /// 📄 Show Hidden Page 
  Future<ShowHiddenPageResponse> showHiddenPage({
    required String apiVersion,
    required String pageId,
    required ShowHiddenPageRequest model,
  });

  /// 📄 Update Body Html Of Page
  Future<UpdateBodyHtmlOfPageResponse> updateBodyHtmlOfPage({
    required String apiVersion,
    required String pageId,
    required UpdateBodyHtmlOfPageRequest model,
  });

  /// 📄 Hide Published Page
  Future<HidePublishedPageResponse> hidePublishedPage({
    required String apiVersion,
    required String pageId,
    required HidePublishedPageRequest model,
  });

  /// 📄 Delete Page
  Future<void> deletePage({
    required String apiVersion,
    required String pageId,
  });
}