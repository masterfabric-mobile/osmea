import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:apis/network/remote/woocommerce/users_manager/abstract/osmea_users_manager_service.dart';
import 'package:storefront_woo/app/views/view_user_profile/models/module/states.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_dashboard_response.dart';

@injectable
class UserProfileViewModel
    extends BaseViewModelHydratedCubit<UserProfileState> {
  UserProfileViewModel() : super(UserProfileInitialState());

  // Dependencies
  final OsmeaUsersManagerService _usersManagerService =
      GetIt.I<OsmeaUsersManagerService>();

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
