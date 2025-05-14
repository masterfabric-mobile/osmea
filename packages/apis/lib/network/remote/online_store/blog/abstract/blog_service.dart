import 'package:apis/network/remote/online_store/blog/freezed_model/request/create_empty_blog_request.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/request/create_empty_blog_with_metafield_request.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/response/create_empty_blog_response.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/response/create_empty_blog_with_metafield_response.dart';
import 'package:apis/network/remote/online_store/blog/freezed_model/response/get_all_blogs_response.dart';

abstract class BlogService {
  Future<CreateEmptyBlogResponse> createEmptyBlog({
    required String apiVersion,
    required CreateEmptyBlogRequest model,
  });

    /// 📦 Create a new empty blog with a metafield 
   Future<CreateEmptyBlogWithMetafieldResponse> createEmptyBlogWithMetafield({
    required String apiVersion,
    required CreateEmptyBlogWithMetafieldRequest model,
  });

  Future<GetAllBlogsResponse> getAllBlogs({
    required String apiVersion,
    int? limit,
    String? sinceId,
    String? handle,
    String? fields,
  });
}