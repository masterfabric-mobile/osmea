
import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/online_store/article/abstract/article_service.dart';
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

  /// 📦 Get a single article by its ID in the API.
  @GET('/api/{api_version}/blogs/{blog_id}/articles/{article_id}.json')
  Future<GetSingleArticleResponse> getSingleArticle({
    @Path('api_version') required String apiVersion,
    @Path('article_id') required int articleId,
    @Path('blog_id') required int blogId,
    @Query('fields') String? fields,
  });

  /// 📦 Count articles in a specific blog in the API.
  @GET('/api/{api_version}/blogs/{blog_id}/articles/count.json')
  Future<CountBlogArticlesResponse> countBlogArticles({
    @Path('api_version') required String apiVersion,
    @Path('blog_id') required int blogId,
    @Query('created_at_min') DateTime? createdAtMin,
    @Query('created_at_max') DateTime? createdAtMax,
    @Query('updated_at_min') DateTime? updatedAtMin,
    @Query('updated_at_max') DateTime? updatedAtMax,
    @Query('published_at_min') DateTime? publishedAtMin,
    @Query('published_at_max') DateTime? publishedAtMax,
    @Query('published_status') String? publishedStatus,
  });

  /// 📦 List Article Tags for a specific blog
  @GET('/api/{api_version}/blogs/{blog_id}/articles/tags.json')
  Future<ListArticleTagsSpecificBlogResponse> listArticleTagsSpecificBlog({
    @Path('api_version') required String apiVersion,
    @Path('blog_id') required int blogId,
    @Query('limit') int? limit,
    @Query('popular') bool? popular,
  });

  /// 📦 Update Article
  @PUT('/api/{api_version}/blogs/{blog_id}/articles/{article_id}.json')
  Future<UpdateArticleResponse> updateArticle({
    @Path('api_version') required String apiVersion,
    @Path('article_id') required int articleId,
    @Path('blog_id') required int blogId,
    @Body() required UpdateArticleRequest model,
  });

  /// 📦 Delete Article
  @DELETE('/api/{api_version}/blogs/{blog_id}/articles/{article_id}.json')
  Future<void> deleteArticle({
    @Path('api_version') required String apiVersion,
    @Path('article_id') required int articleId,
    @Path('blog_id') required int blogId,
  });

  /// 📦 Create Article With Metafield
  @POST('/api/{api_version}/blogs/{blog_id}/articles.json')
  Future<CreateArticleWithMetafieldResponse> createArticleWithMetafield({
    @Path('api_version') required String apiVersion,
    @Path('blog_id') required int blogId,
    @Body() required CreateArticleWithMetafieldRequest model,
  });
}