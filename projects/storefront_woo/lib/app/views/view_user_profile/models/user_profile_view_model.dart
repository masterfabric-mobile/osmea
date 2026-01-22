import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:apis/network/remote/woocommerce/users_manager/abstract/osmea_users_manager_service.dart';
import 'package:storefront_woo/app/views/view_user_profile/models/module/states.dart';

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
