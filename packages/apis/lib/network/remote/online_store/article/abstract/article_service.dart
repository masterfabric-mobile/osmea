
import 'package:apis/network/remote/online_store/article/freezed_model/response/list_all_article_authors_response.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/response/list_most_popular_tags_response.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/response/list_tags_all_articles_response.dart';
import 'package:apis/network/remote/online_store/article/freezed_model/response/list_tags_specific_blog_response.dart';

abstract class ArticleService {
    Future <ListAllArticleAuthorsResponse> listAllArticleAuthors({
    required String apiVersion,
  });

    Future <ListTagsSpecificBlogResponse> listTagsSpecificBlog({
    required String apiVersion,
    required int blogId,
    int? limit,
    bool? popular
  });

  Future <ListMostPopularTagsResponse> listMostPopularTags({
    required String apiVersion,
    int? limit,
    bool? popular
  });

  Future<ListTagsAllArticlesResponse> listTagsAllArticles({
    required String apiVersion,
    int? limit,
    bool? popular
  });
}
