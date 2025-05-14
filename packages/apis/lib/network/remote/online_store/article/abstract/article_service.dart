import 'package:apis/network/remote/online_store/article/freezed_model/request/create_article_with_metafield_request.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/request/update_article_request.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/response/count_blog_articles_response.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/response/create_article_with_metafield_response.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/response/get_single_article_response.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/response/list_all_article_authors_response.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/response/list_article_tags_specific_blog_response.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/response/list_articles_from_blog_response.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/response/list_most_popular_tags_response.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/response/list_most_popular_tags_specific_blog_response.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/response/list_tags_all_articles_response.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/response/list_tags_specific_blog_response.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/response/update_article_response.dart';

abstract class ArticleService {
  Future<ListAllArticleAuthorsResponse> listAllArticleAuthors({
    required String apiVersion,
  });

  Future<ListTagsSpecificBlogResponse> listTagsSpecificBlog(
      {required String apiVersion,
      required int blogId,
      int? limit,
      bool? popular});

  Future<ListMostPopularTagsResponse> listMostPopularTags(
      {required String apiVersion, int? limit, bool? popular});

  Future<ListTagsAllArticlesResponse> listTagsAllArticles(
      {required String apiVersion, int? limit, bool? popular});

  Future<ListMostPopularTagsSpecificBlogResponse>
      listMostPopularTagsSpecificBlog(
          {required String apiVersion,
          required int blogId,
          int? limit,
          bool? popular});

  Future<ListArticlesFromBlogResponse> listArticlesFromBlog({
    required String apiVersion,
    required int blogId,
    int? limit,
    int? sinceId,
    DateTime? createdAtMin,
    DateTime? createdAtMax,
    DateTime? updatedAtMin,
    DateTime? updatedAtMax,
    DateTime? publishedAtMin,
    DateTime? publishedAtMax,
    String? publishedStatus,
    String? handle,
    String? tag,
    String? author,
    String? fields,
  });

  /// 📦 Get Single Article
  Future<GetSingleArticleResponse> getSingleArticle({
    required String apiVersion,
    required int articleId,
    required int blogId,
    String? fields,
  });

  /// 📦 Count Blog Articles
  Future<CountBlogArticlesResponse> countBlogArticles({
    required String apiVersion,
    required int blogId,
    DateTime? createdAtMin,
    DateTime? createdAtMax,
    DateTime? updatedAtMin,
    DateTime? updatedAtMax,
    DateTime? publishedAtMin,
    DateTime? publishedAtMax,
    String? publishedStatus,
  });

  /// 📦 List Article Tags for a specific blog
  Future<ListArticleTagsSpecificBlogResponse> listArticleTagsSpecificBlog(
      {required String apiVersion,
      required int blogId,
      int? limit,
      bool? popular});

  /// 📦 Update Article
  Future<UpdateArticleResponse> updateArticle({
    required String apiVersion,
    required int articleId,
    required int blogId,
    required UpdateArticleRequest model,
  });

  /// 📦 Delete Article
  Future<void> deleteArticle({
    required String apiVersion,
    required int articleId,
    required int blogId,
  });

  /// 📦 Create Article With Metafield
  Future<CreateArticleWithMetafieldResponse> createArticleWithMetafield({
    required String apiVersion,
    required int blogId,
    required CreateArticleWithMetafieldRequest model,
  });
}
