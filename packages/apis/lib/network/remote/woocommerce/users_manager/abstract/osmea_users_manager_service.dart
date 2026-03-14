import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/request/create_contract_signature_request.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/request/create_user_address_request.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/request/log_user_activity_request.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/request/update_user_address_request.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/request/update_user_profile_request.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/delete_user_metadata_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_all_users_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_activity_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_addresses_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_by_id_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_contracts_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_dashboard_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_metadata_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_orders_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_preferences_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_profile_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_statistics_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/update_user_metadata_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/update_user_profile_response.dart';

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

  /// ✏️ Update current user's profile
  Future<UpdateUserProfileResponse> updateUserProfile(
    UpdateUserProfileRequest request,
  );

  // ==========================================
  // Orders (Authenticated User)
  // ==========================================

  /// 🛒 Get current user's orders
  Future<GetUserOrdersResponse> getUserOrders({
    int page = 1,
    int perPage = 10,
    String? status,
  });

  /// 🛒 Get single order by ID
  Future<DetailedUserOrder> getUserOrder(int orderId);

  // ==========================================
  // Contracts (Authenticated User)
  // ==========================================

  /// 📝 Get current user's contracts
  Future<GetUserContractsResponse> getUserContracts({
    int page = 1,
    int perPage = 10,
    String? contractType,
  });

  /// 📝 Get single contract by ID
  Future<UserContractDetail> getUserContract(int contractId);

  /// 📝 Create contract signature
  Future<CreateContractSignatureResponse> createContractSignature(
    CreateContractSignatureRequest request,
  );

  // ==========================================
  // Addresses (Authenticated User)
  // ==========================================

  /// 📍 Get current user's addresses
  Future<GetUserAddressesResponse> getUserAddresses({
    String? type,
  });

  /// 📍 Create new address
  Future<AddressOperationResponse> createUserAddress(
    CreateUserAddressRequest request,
  );

  /// 📍 Update address
  Future<AddressOperationResponse> updateUserAddress(
    int addressId,
    UpdateUserAddressRequest request,
  );

  /// 📍 Delete address
  Future<AddressOperationResponse> deleteUserAddress(int addressId);

  /// 📍 Set default address
  Future<AddressOperationResponse> setDefaultAddress(int addressId);

  // ==========================================
  // Preferences (Authenticated User)
  // ==========================================

  /// ⚙️ Get current user's preferences
  Future<GetUserPreferencesResponse> getUserPreferences();

  /// ⚙️ Update current user's preferences
  Future<UpdatePreferencesResponse> updateUserPreferences(
    Map<String, dynamic> preferences,
  );

  // ==========================================
  // Activity (Authenticated User)
  // ==========================================

  /// 📊 Get current user's activity logs
  Future<GetUserActivityResponse> getUserActivity({
    int page = 1,
    int perPage = 20,
    String? type,
  });

  /// 📊 Log user activity
  Future<LogActivityResponse> logUserActivity(
    LogUserActivityRequest request,
  );

  // ==========================================
  // Statistics (Authenticated User)
  // ==========================================

  /// 📈 Get current user's statistics
  Future<GetUserStatisticsResponse> getUserStatistics();

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
