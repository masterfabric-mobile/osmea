import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_dashboard_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_metadata_response.dart';

/// User Profile States
abstract class UserProfileState {}

class UserProfileInitialState extends UserProfileState {}

class UserProfileLoadingState extends UserProfileState {}

class UserProfileLoadedState extends UserProfileState {
  final UserProfile profile;
  final Map<String, UserMetadataItem> metadata;
  final List<UserAddress> addresses;
  final Map<String, UserPreference> preferences;
  final List<UserContract> contracts;
  final List<UserActivity> activities;
  final UserStatistics statistics;

  UserProfileLoadedState({
    required this.profile,
    required this.metadata,
    required this.addresses,
    required this.preferences,
    required this.contracts,
    required this.activities,
    required this.statistics,
  });
}

class UserProfileErrorState extends UserProfileState {
  final String message;

  UserProfileErrorState({required this.message});
}
