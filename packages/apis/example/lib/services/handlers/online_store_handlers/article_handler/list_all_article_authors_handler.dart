import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/article/abstract/article_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///*******************************************************************
///************** 📝 LIST ALL ARTICLE AUTHORS HANDLER 📝 ************
///*******************************************************************

class ListAllArticleAuthorsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    // 🔒 Only handle GET requests for article authors
    if (method == 'GET') {
      try {
        // 📞 Call the article service API to get all authors
        final response = await GetIt.I.get<ArticleService>().listAllArticleAuthors(
              apiVersion: ApiNetwork.apiVersion,
            );

        // 📋 Return the article authors data
        return {
          "status": "success",
          "authors": response.toJson(),
          "count": response.authors?.length ?? 0,
          "message": "Article authors successfully retrieved",
          "timestamp": DateTime.now().toIso8601String(),
        };
      } catch (e) {
        // ❌ Error handling
        return {
          "status": "error",
          "message": "Failed to retrieve article authors: ${e.toString()}",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    }

    // ⛔ Unsupported method error
    return {
      "error": "Method $method not supported for List All Article Authors API",
    };
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          // No required fields for listing all authors
        ],
      };
}
