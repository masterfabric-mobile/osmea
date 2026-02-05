import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'get_user_metadata_response.dart';
import 'get_user_orders_response.dart';

part 'get_user_dashboard_response.freezed.dart';
part 'get_user_dashboard_response.g.dart';

/// 📊 User Dashboard Response Model
@freezed
class GetUserDashboardResponse with _$GetUserDashboardResponse {
  const factory GetUserDashboardResponse({
    required UserProfile profile,
    required Map<String, UserMetadataItem> metadata,
    required List<UserAddress> addresses,
    required Map<String, UserPreference> preferences,
    required List<UserContract> contracts,
    required List<UserOrder> orders,
    required List<UserActivity> activities,
    required UserStatistics statistics,
  }) = _GetUserDashboardResponse;

  factory GetUserDashboardResponse.fromJson(Map<String, dynamic> json) {
    try {
      // Handle case where metadata/preferences come as empty arrays instead of objects
      final metadataJson = json['metadata'];
      final preferencesJson = json['preferences'];

      // Convert empty arrays to empty maps
      Map<String, dynamic> metadataMap;
      if (metadataJson is List) {
        metadataMap = {};
      } else if (metadataJson is Map<String, dynamic>) {
        metadataMap = metadataJson;
      } else {
        metadataMap = {};
      }

      Map<String, dynamic> preferencesMap;
      if (preferencesJson is List) {
        preferencesMap = {};
      } else if (preferencesJson is Map<String, dynamic>) {
        preferencesMap = preferencesJson;
      } else {
        preferencesMap = {};
      }

      // Parse metadata
      final metadata = metadataMap.map(
        (k, e) => MapEntry(
          k,
          UserMetadataItem.fromJson(e as Map<String, dynamic>),
        ),
      );

      // Parse preferences
      final preferences = preferencesMap.map(
        (k, e) => MapEntry(
          k,
          UserPreference.fromJson(e as Map<String, dynamic>),
        ),
      );

      // Parse addresses - handle empty array
      final addressesJson = json['addresses'];
      final addresses = addressesJson is List
          ? addressesJson
              .map((e) => UserAddress.fromJson(e as Map<String, dynamic>))
              .toList()
          : <UserAddress>[];

      // Parse contracts - handle empty array
      final contractsJson = json['contracts'];
      final contracts = contractsJson is List
          ? contractsJson
              .map((e) => UserContract.fromJson(e as Map<String, dynamic>))
              .toList()
          : <UserContract>[];

      // Parse orders - handle empty array
      final ordersJson = json['orders'];
      final orders = ordersJson is List
          ? ordersJson
              .map((e) => UserOrder.fromJson(e as Map<String, dynamic>))
              .toList()
          : <UserOrder>[];

      // Parse activities - handle empty array
      final activitiesJson = json['activities'];
      final activities = activitiesJson is List
          ? activitiesJson
              .map((e) => UserActivity.fromJson(e as Map<String, dynamic>))
              .toList()
          : <UserActivity>[];

      return GetUserDashboardResponse(
        profile: UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
        metadata: metadata,
        addresses: addresses,
        preferences: preferences,
        contracts: contracts,
        orders: orders,
        activities: activities,
        statistics: UserStatistics.fromJson(
          json['statistics'] as Map<String, dynamic>,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('❌ GetUserDashboardResponse.fromJson error: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      debugPrint('❌ JSON: $json');
      rethrow;
    }
  }
}

/// 👤 User Profile Model
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'username') required String username,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'display_name') required String displayName,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'nickname') String? nickname,
    @JsonKey(name: 'roles') List<String>? roles,
    @JsonKey(name: 'registered_at') required String registeredAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

/// 📍 User Address Model
@freezed
class UserAddress with _$UserAddress {
  const factory UserAddress({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'address_type') required String addressType,
    @JsonKey(name: 'label') String? label,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'company') String? company,
    @JsonKey(name: 'address_1') String? address1,
    @JsonKey(name: 'address_2') String? address2,
    @JsonKey(name: 'city') String? city,
    @JsonKey(name: 'state') String? state,
    @JsonKey(name: 'postcode') String? postcode,
    @JsonKey(name: 'country') String? country,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'phone') String? phone,
    @JsonKey(name: 'is_default') required bool isDefault,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _UserAddress;

  factory UserAddress.fromJson(Map<String, dynamic> json) =>
      _$UserAddressFromJson(json);
}

/// ⚙️ User Preference Model
@freezed
class UserPreference with _$UserPreference {
  const factory UserPreference({
    @JsonKey(name: 'value') required dynamic value,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _UserPreference;

  factory UserPreference.fromJson(Map<String, dynamic> json) =>
      _$UserPreferenceFromJson(json);
}

/// 📝 User Contract Model
@freezed
class UserContract with _$UserContract {
  const factory UserContract({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'contract_type') required String contractType,
    @JsonKey(name: 'contract_title') required String contractTitle,
    @JsonKey(name: 'signed_at') required String signedAt,
  }) = _UserContract;

  factory UserContract.fromJson(Map<String, dynamic> json) =>
      _$UserContractFromJson(json);
}

/// 🛒 User Order Model
@freezed
class UserOrder with _$UserOrder {
  const factory UserOrder({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'order_number') required String orderNumber,
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'date_created') required String dateCreated,
    @JsonKey(
      name: 'total',
      fromJson: _totalFromJson,
    )
    required double total,
    @JsonKey(name: 'currency') required String currency,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    @JsonKey(name: 'line_items') List<OrderLineItem>? lineItems,
  }) = _UserOrder;

  factory UserOrder.fromJson(Map<String, dynamic> json) =>
      _$UserOrderFromJson(json);
}

// Helper function to parse total (can be string or number)
double _totalFromJson(dynamic value) {
  if (value is num) {
    return value.toDouble();
  } else if (value is String) {
    return double.tryParse(value) ?? 0.0;
  }
  return 0.0;
}

/// 📊 User Activity Model
@freezed
class UserActivity with _$UserActivity {
  const factory UserActivity({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'activity_type') required String activityType,
    @JsonKey(name: 'activity_description') String? activityDescription,
    @JsonKey(name: 'ip_address') String? ipAddress,
    @JsonKey(name: 'metadata') Map<String, dynamic>? metadata,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _UserActivity;

  factory UserActivity.fromJson(Map<String, dynamic> json) =>
      _$UserActivityFromJson(json);
}

/// 📈 User Statistics Model
@freezed
class UserStatistics with _$UserStatistics {
  const factory UserStatistics({
    @JsonKey(name: 'metadata_count') required int metadataCount,
    @JsonKey(name: 'contracts_count') required int contractsCount,
    @JsonKey(name: 'addresses_count') required int addressesCount,
    @JsonKey(name: 'preferences_count') required int preferencesCount,
    @JsonKey(name: 'activity_count') required int activityCount,
    @JsonKey(name: 'orders_count') int? ordersCount,
    @JsonKey(name: 'orders_total') double? ordersTotal,
    @JsonKey(name: 'orders_by_status') Map<String, int>? ordersByStatus,
  }) = _UserStatistics;

  factory UserStatistics.fromJson(Map<String, dynamic> json) =>
      _$UserStatisticsFromJson(json);
}
