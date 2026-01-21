import 'package:apis/apis.dart';
import 'package:apis/dio_config/dio_client/api_dio_client.dart';
import 'package:apis/network/remote/woocommerce/users_manager/abstract/osmea_users_manager_service.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/request/update_user_metadata_request.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/delete_user_metadata_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_all_users_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_by_id_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_dashboard_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_metadata_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_profile_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/update_user_metadata_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'api_osmea_users_manager_service.g.dart';

/// 👥 OSMEA Users Manager API Service
/// Retrofit client for OSMEA Users Manager REST API.
/// Make sure WooNetwork.storeUrl is set and authentication is configured before using! 🏬🔑
@RestApi()
@Injectable(as: OsmeaUsersManagerService)
abstract class ApiOsmeaUsersManagerService implements OsmeaUsersManagerService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory ApiOsmeaUsersManagerService(Dio dio) => _ApiOsmeaUsersManagerService(
        ApiDioClient.wooDio(useJwtAuth: true), // Use JWT Auth
        baseUrl: WooNetwork.baseUrl,
      );

  // ==========================================
  // User Metadata (Authenticated User)
  // ==========================================

  /// 📋 Get current user's metadata
  @override
  @GET('/wp-json/osmea-users/v1/metadata')
  Future<GetUserMetadataResponse> getUserMetadata();

  /// 📝 Update current user's metadata
  @override
  @POST('/wp-json/osmea-users/v1/metadata')
  Future<UpdateUserMetadataResponse> updateUserMetadata(
    @Body() Map<String, dynamic> metadata,
  );

  /// 🗑️ Delete current user's metadata by key
  @override
  @DELETE('/wp-json/osmea-users/v1/metadata/{key}')
  Future<DeleteUserMetadataResponse> deleteUserMetadata(
    @Path('key') String key,
  );

  /// 📊 Get current user's dashboard
  @override
  @GET('/wp-json/osmea-users/v1/dashboard')
  Future<GetUserDashboardResponse> getUserDashboard({
    @Query('include_orders') bool includeOrders = true,
    @Query('orders_limit') int ordersLimit = 5,
    @Query('include_activity') bool includeActivity = true,
    @Query('activity_limit') int activityLimit = 10,
  });

  /// 👤 Get current user's profile
  @override
  @GET('/wp-json/osmea-users/v1/profile')
  Future<GetUserProfileResponse> getUserProfile();

  // ==========================================
  // Admin Endpoints (Manage All Users)
  // ==========================================

  /// 👥 Get all WordPress users (Admin only)
  @override
  @GET('/wp-json/osmea-users/v1/admin/users')
  Future<GetAllUsersResponse> getAllUsers({
    @Query('page') int page = 1,
    @Query('per_page') int perPage = 20,
    @Query('search') String? search,
    @Query('role') String? role,
  });

  /// 👤 Get user by ID (Admin only)
  @override
  @GET('/wp-json/osmea-users/v1/admin/users/{id}')
  Future<GetUserByIdResponse> getUserById(
    @Path('id') int userId,
  );

  /// 📋 Get user metadata (Admin - for any user)
  @override
  @GET('/wp-json/osmea-users/v1/admin/users/{id}/metadata')
  Future<GetUserMetadataResponse> getUserMetadataAdmin(
    @Path('id') int userId,
  );

  /// 📝 Update user metadata (Admin - for any user)
  @override
  @POST('/wp-json/osmea-users/v1/admin/users/{id}/metadata')
  Future<UpdateUserMetadataResponse> updateUserMetadataAdmin(
    @Path('id') int userId,
    @Body() Map<String, dynamic> metadata,
  );

  /// 🗑️ Delete user metadata (Admin - for any user)
  @override
  @DELETE('/wp-json/osmea-users/v1/admin/users/{id}/metadata/{key}')
  Future<DeleteUserMetadataResponse> deleteUserMetadataAdmin(
    @Path('id') int userId,
    @Path('key') String key,
  );

  /// 📊 Get user dashboard (Admin - for any user)
  @override
  @GET('/wp-json/osmea-users/v1/admin/users/{id}/dashboard')
  Future<GetUserDashboardResponse> getUserDashboardAdmin(
    @Path('id') int userId, {
    @Query('include_orders') bool includeOrders = true,
    @Query('orders_limit') int ordersLimit = 5,
    @Query('include_activity') bool includeActivity = true,
    @Query('activity_limit') int activityLimit = 10,
  });
}
