import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:apis/network/remote/woocommerce/users_manager/abstract/osmea_users_manager_service.dart';
import 'package:apis/network/remote/woocommerce/auth/abstract/woo_auth_service.dart';
import 'package:apis/network/remote/woocommerce/auth/freezed_model/request/delete_user_request.dart';
import 'package:storefront_woo/app/views/view_user_profile/models/module/states.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_dashboard_response.dart';
import 'package:apis/models/auth/woo_jwt_token.dart';
import 'package:apis/models/cart/woo_cart_token.dart';
import 'package:apis/dio_config/dio_client/api_dio_client.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';

@injectable
class UserProfileViewModel
    extends BaseViewModelHydratedCubit<UserProfileState> {
  UserProfileViewModel() : super(UserProfileInitialState());

  // Dependencies
  final OsmeaUsersManagerService _usersManagerService =
      GetIt.I<OsmeaUsersManagerService>();
  final WooAuthService _authService = GetIt.I<WooAuthService>();

  // Arguments holder
  final Map<String, dynamic> _arguments = {};
  void setArguments(Map<String, dynamic> args) {
    _arguments
      ..clear()
      ..addAll(args);
  }

  Map<String, dynamic> get arguments => Map.unmodifiable(_arguments);

  // Hydrated storage key
  @override
  String get id => 'user_profile_view_model_v1';

  // Public trigger functions
  Future<void> loadProfile() => _loadProfile();
  
  /// Delete user account
  /// Returns true if successful, false otherwise
  Future<bool> deleteAccount() => _deleteAccount();

  Future<void> _loadProfile() async {
    try {
      stateChanger(UserProfileLoadingState());

      debugPrint('👤 UserProfileViewModel: Loading profile...');
      
      // Get complete dashboard with all data
      final dashboard = await _usersManagerService.getUserDashboard(
        includeOrders: false,
        ordersLimit: 0,
        includeActivity: true,
        activityLimit: 50, // Get recent activities
      );

      debugPrint('✅ UserProfileViewModel: Dashboard loaded successfully');
      debugPrint('👤 UserProfileViewModel: Profile: ${dashboard.profile.displayName}');
      debugPrint('📊 UserProfileViewModel: Metadata count: ${dashboard.metadata.length}');
      debugPrint('📍 UserProfileViewModel: Addresses count: ${dashboard.addresses.length}');
      debugPrint('⚙️ UserProfileViewModel: Preferences count: ${dashboard.preferences.length}');
      debugPrint('📝 UserProfileViewModel: Contracts count: ${dashboard.contracts.length}');
      debugPrint('📈 UserProfileViewModel: Activities count: ${dashboard.activities.length}');

      stateChanger(UserProfileLoadedState(
        profile: dashboard.profile,
        metadata: dashboard.metadata,
        addresses: dashboard.addresses,
        preferences: dashboard.preferences,
        contracts: dashboard.contracts,
        activities: dashboard.activities,
        statistics: dashboard.statistics,
      ));
      
      debugPrint('✅ UserProfileViewModel: State changed to UserProfileLoadedState');
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading profile: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      
      // For new users, try to create a default profile from AuthCubit data
      // instead of showing error
      try {
        final authCubit = GetIt.I<AuthCubit>();
        final authState = authCubit.state;
        
        if (authState is AuthAuthenticatedState && authState.userData != null) {
          debugPrint('👤 UserProfileViewModel: Creating default profile from AuthCubit data');
          final userData = authState.userData!;
          
          // Extract user information from AuthCubit
          final email = userData['email'] as String? ?? '';
          final displayName = userData['display_name'] as String? ?? 
                             userData['name'] as String? ?? 
                             (userData['firstName'] != null && userData['lastName'] != null
                               ? '${userData['firstName']} ${userData['lastName']}'
                               : email.split('@').first);
          final firstName = userData['firstName'] as String? ?? 
                           userData['first_name'] as String? ?? '';
          final lastName = userData['lastName'] as String? ?? 
                          userData['last_name'] as String? ?? '';
          final userId = userData['id'] as int? ?? 
                        int.tryParse(userData['id'] as String? ?? '0') ?? 0;
          final username = userData['username'] as String? ?? 
                          userData['slug'] as String? ?? 
                          email.split('@').first;
          
          // Create default profile
          final defaultProfile = UserProfile(
            userId: userId,
            username: username,
            email: email,
            displayName: displayName,
            firstName: firstName.isNotEmpty ? firstName : null,
            lastName: lastName.isNotEmpty ? lastName : null,
            registeredAt: DateTime.now().toIso8601String(),
          );
          
          // Create empty statistics
          final defaultStatistics = UserStatistics(
            metadataCount: 0,
            contractsCount: 0,
            addressesCount: 0,
            preferencesCount: 0,
            activityCount: 0,
            ordersCount: 0,
            ordersTotal: 0.0,
          );
          
          debugPrint('✅ UserProfileViewModel: Created default profile for new user');
          debugPrint('👤 UserProfileViewModel: Profile: ${defaultProfile.displayName}');
          
          // Show loaded state with default/empty data
          stateChanger(UserProfileLoadedState(
            profile: defaultProfile,
            metadata: {},
            addresses: [],
            preferences: {},
            contracts: [],
            activities: [],
            statistics: defaultStatistics,
          ));
          
          debugPrint('✅ UserProfileViewModel: State changed to UserProfileLoadedState with default data');
          return;
        }
      } catch (fallbackError) {
        debugPrint('❌ Error creating default profile: $fallbackError');
      }
      
      // If we can't create default profile, show error
      stateChanger(UserProfileErrorState(
        message: 'Failed to load profile. Please try again.',
      ));
    }
  }

  Future<bool> _deleteAccount() async {
    try {
      stateChanger(UserProfileDeletingState());
      
      debugPrint('🗑️ UserProfileViewModel: Starting account deletion...');
      
      // Get current user info and tokens
      final authCubit = GetIt.I<AuthCubit>();
      final authState = authCubit.state;
      
      if (authState is! AuthAuthenticatedState) {
        debugPrint('❌ UserProfileViewModel: User not authenticated');
        stateChanger(UserProfileErrorState(
          message: 'Authentication required to delete account',
        ));
        return false;
      }
      
      // Get required data from auth state
      final userId = authState.userData?['id']?.toString() ?? '';
      final jwtToken = authState.jwtToken ?? '';
      
      if (userId.isEmpty || jwtToken.isEmpty) {
        debugPrint('❌ UserProfileViewModel: Missing user ID or JWT token');
        stateChanger(UserProfileErrorState(
          message: 'Missing authentication data',
        ));
        return false;
      }
      
      // Get config for auth key
      final configHelper = AssetConfigHelper();
      final authKey = configHelper.getString(
        'woocommerce_configuration.auth_key',
        '',
      );
      final brandName = configHelper.getString(
        'woocommerce_configuration.brand_name',
        '',
      );
      
      if (authKey.isEmpty || brandName.isEmpty) {
        debugPrint('❌ UserProfileViewModel: Missing auth key or brand name');
        stateChanger(UserProfileErrorState(
          message: 'Configuration error. Please contact support.',
        ));
        return false;
      }
      
      debugPrint('🗑️ UserProfileViewModel: Calling delete API...');
      debugPrint('🗑️ UserProfileViewModel: User ID: $userId');
      
      // Call the delete user API
      final response = await _authService.deleteUser(
        brandName,
        jwtToken,
        authKey,
        DeleteUserRequest(
          userId: userId,
          deleteOrders: true,
          deleteReviews: true,
          reason: 'user_request',
          metadata: {
            'deletion_date': DateTime.now().toIso8601String(),
            'deletion_source': 'mobile_app',
            'platform': 'flutter',
          },
        ),
      );
      
      debugPrint('✅ UserProfileViewModel: Account deleted from server');
      debugPrint('🗑️ Response: ${response.message}');
      
      // Clear all local data
      debugPrint('🧹 UserProfileViewModel: Clearing local data...');
      
      // 1. Clear JWT Token
      try {
        await WooJwtTokenStorage.clearToken();
        debugPrint('✅ JWT token cleared');
      } catch (e) {
        debugPrint('⚠️ Failed to clear JWT token: $e');
      }
      
      // 2. Clear Cart Token
      try {
        await WooCartTokenStorage.clearCartToken();
        debugPrint('✅ Cart token cleared');
      } catch (e) {
        debugPrint('⚠️ Failed to clear cart token: $e');
      }
      
      // 3. Clear all cookies
      try {
        await ApiDioClient.clearAllCookies();
        debugPrint('✅ All cookies cleared');
      } catch (e) {
        debugPrint('⚠️ Failed to clear cookies: $e');
      }
      
      // 4. Clear wishlist
      try {
        final wishlistViewModel = GetIt.I<WishlistViewModel>();
        await wishlistViewModel.clearAll();
        debugPrint('✅ Wishlist cleared');
      } catch (e) {
        debugPrint('⚠️ Failed to clear wishlist: $e');
      }
      
      // 5. Sign out from AuthCubit (this will clear auth state)
      try {
        await authCubit.signOut();
        debugPrint('✅ Auth state cleared');
      } catch (e) {
        debugPrint('⚠️ Failed to sign out: $e');
      }
      
      debugPrint('✅ UserProfileViewModel: Account deletion completed successfully');
      
      // Don't change state here - let the caller handle navigation
      return true;
      
    } catch (e, stackTrace) {
      debugPrint('❌ UserProfileViewModel: Error deleting account: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      
      stateChanger(UserProfileErrorState(
        message: 'Failed to delete account. Please try again or contact support.',
      ));
      
      return false;
    }
  }

  @override
  Map<String, dynamic>? toJson(UserProfileState state) {
    // Don't persist state - always fetch fresh data from API
    return null;
  }

  @override
  UserProfileState? fromJson(Map<String, dynamic> json) {
    // Don't restore state - always start fresh
    return UserProfileInitialState();
  }
}
