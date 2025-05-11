
import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/online_store/article/abstract/article_service.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/response/list_all_article_authors_response.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/response/list_articles_from_blog_response.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/response/list_most_popular_tags_response.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/response/list_most_popular_tags_specific_blog_response.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/response/list_tags_all_articles_response.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/response/list_tags_specific_blog_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_article_service.g.dart';

@RestApi()
@Injectable(as: ArticleService)
/// 🌐 ArticleService
abstract class ArticleServiceClient implements ArticleService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory ArticleServiceClient(Dio dio) => _ArticleServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 📦 List all article authors in the API.
  @GET('/api/{api_version}/articles/authors.json')
  Future<ListAllArticleAuthorsResponse> listAllArticleAuthors({
    @Path('api_version') required String apiVersion,
  });

  /// 📦 List tags for a specific blog in the API.
  @GET('/api/{api_version}/blogs/{blog_id}/articles/tags.json')
  Future<ListTagsSpecificBlogResponse> listTagsSpecificBlog({
    @Path('api_version') required String apiVersion,
    @Path('blog_id') required int blogId,
    @Query('limit') int? limit,
    @Query('popular') bool? popular,
  });

  /// 📦 List most popular tags in the API.
  @GET('/api/{api_version}/articles/tags.json')
  Future<ListMostPopularTagsResponse> listMostPopularTags({
    @Path('api_version') required String apiVersion,
    @Query('limit') int? limit,
    @Query('popular') bool? popular,
  });

  /// 📦 List tags for all articles in the API.
  @GET('/api/{api_version}/articles/tags.json')
  Future<ListTagsAllArticlesResponse> listTagsAllArticles({
    @Path('api_version') required String apiVersion,
    @Query('limit') int? limit,
    @Query('popular') bool? popular,
  });

  /// 📦 List most popular tags for a specific blog in the API.
  @GET('/api/{api_version}/blogs/{blog_id}/articles/tags.json')
  Future<ListMostPopularTagsSpecificBlogResponse> listMostPopularTagsSpecificBlog({
    @Path('api_version') required String apiVersion,
    @Path('blog_id') required int blogId,
    @Query('limit') int? limit,
    @Query('popular') bool? popular,
  });

  /// 📦 List articles from a specific blog in the API.
  @GET('/api/{api_version}/blogs/{blog_id}/articles.json')  
  Future<ListArticlesFromBlogResponse> listArticlesFromBlog({
    @Path('api_version') required String apiVersion,
    @Path('blog_id') required int blogId,
    @Query('limit') int? limit,
    @Query('since_id') int? sinceId,
    @Query('created_at_min') DateTime? createdAtMin,
    @Query('created_at_max') DateTime? createdAtMax,
    @Query('updated_at_min') DateTime? updatedAtMin,
    @Query('updated_at_max') DateTime? updatedAtMax,
    @Query('published_at_min') DateTime? publishedAtMin,
    @Query('published_at_max') DateTime? publishedAtMax,
    @Query('published_status') String? publishedStatus,
    @Query('handle') String? handle,
    @Query('tag') String? tag,
    @Query('author') String? author,
    @Query('fields') String? fields,
  });
}