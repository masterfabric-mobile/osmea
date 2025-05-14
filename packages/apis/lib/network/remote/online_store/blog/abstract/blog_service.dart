import 'package:apis/network/remote/online_store/blog/freezed_model/request/create_empty_blog_request.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/response/create_empty_blog_response.dart';

abstract class BlogService {
  Future<CreateEmptyBlogResponse> createEmptyBlog({
    required String apiVersion,
    required CreateEmptyBlogRequest model,
  });
}