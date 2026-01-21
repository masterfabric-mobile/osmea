import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/request/update_user_metadata_request.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/delete_user_metadata_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_all_users_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_by_id_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_dashboard_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_metadata_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_profile_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/update_user_metadata_response.dart';

/// 👥 OSMEA Users Manager Service
/// Abstract interface for OSMEA Users Manager REST API operations
abstract class OsmeaUsersManagerService {
  // ==========================================
  // User Metadata (Authenticated User)
  // ==========================================

  /// 📋 Get current user's metadata
  Future<GetUserMetadataResponse> getUserMetadata();

  /// 📝 Update current user's metadata
  Future<UpdateUserMetadataResponse> updateUserMetadata(
    Map<String, dynamic> metadata,
  );

  /// 🗑️ Delete current user's metadata by key
  Future<DeleteUserMetadataResponse> deleteUserMetadata(String key);

  /// 📊 Get current user's dashboard
  Future<GetUserDashboardResponse> getUserDashboard({
    bool includeOrders = true,
    int ordersLimit = 5,
    bool includeActivity = true,
    int activityLimit = 10,
  });

  /// 👤 Get current user's profile
  Future<GetUserProfileResponse> getUserProfile();

  // ==========================================
  // Admin Endpoints (Manage All Users)
  // ==========================================

  /// 👥 Get all WordPress users (Admin only)
  Future<GetAllUsersResponse> getAllUsers({
    int page = 1,
    int perPage = 20,
    String? search,
    String? role,
  });

  /// 👤 Get user by ID (Admin only)
  Future<GetUserByIdResponse> getUserById(int userId);

  /// 📋 Get user metadata (Admin - for any user)
  Future<GetUserMetadataResponse> getUserMetadataAdmin(int userId);

  /// 📝 Update user metadata (Admin - for any user)
  Future<UpdateUserMetadataResponse> updateUserMetadataAdmin(
    int userId,
    Map<String, dynamic> metadata,
  );

  /// 🗑️ Delete user metadata (Admin - for any user)
  Future<DeleteUserMetadataResponse> deleteUserMetadataAdmin(
    int userId,
    String key,
  );

  /// 📊 Get user dashboard (Admin - for any user)
  Future<GetUserDashboardResponse> getUserDashboardAdmin(
    int userId, {
    bool includeOrders = true,
    int ordersLimit = 5,
    bool includeActivity = true,
    int activityLimit = 10,
  });
}
