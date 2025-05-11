
import 'package:apis/network/remote/online_store/article/freezed_model/response/list_all_article_authors_response.dart';

abstract class ArticleService {
    Future <ListAllArticleAuthorsResponse> listAllArticleAuthors({
    required String apiVersion,
  });
}
