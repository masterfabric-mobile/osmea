/*
 * AccountCubit
 * ------------
 * ViewModel for the account view following OSMEA architecture.
 * Uses BaseViewModelCubit pattern with mock data support.
 *
 * Copyright (c) 2025, OSMEA Team
 * https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
 *
 * {@category ViewModels}
 * {@subCategory AccountCubit}
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:core/src/base/base_view_model_cubit.dart';
import 'package:core/src/helper/asset_config_helper.dart';
import 'package:core/src/helper/auth_storage_helper.dart';
import 'package:core/src/views/account/cubit/account_state.dart';
import 'package:injectable/injectable.dart';

/// 🧠 **OSMEA Account Cubit**
///
/// Manages account view state and data loading
/// Supports loading from app_config.json or mock data fallback
///
/// Note: This cubit is platform-agnostic and only uses AuthStorageHelper
/// for user data. It does not depend on AuthCubit to maintain core package independence.
/// Platform-specific implementations should provide user data (username, email, etc.) directly.
@injectable
class AccountCubit extends BaseViewModelCubit<AccountState> {
  AccountCubit() : super(const AccountState()) {
    debugPrint('🔍 AccountCubit: Constructor called');
  }

  final AssetConfigHelper _configHelper = AssetConfigHelper();
  Map<String, dynamic>? _userApiData;

  // Public trigger functions
  void initialize() => _initialize();

  /// Refresh profile data from auth storage
  /// Call this when user logs in or profile is updated
  void refreshProfile() => _initialize();

  /// Set user API data (username, email, etc.)
  /// Platform-specific implementations should call this with API response data
  void setUserApiData(Map<String, dynamic>? userData) {
    _userApiData = userData;
    debugPrint('👤 AccountCubit: User API data set');
    debugPrint('👤 AccountCubit: User data keys: ${userData?.keys.toList()}');
  }

  // Private methods
  Future<void> _initialize() async {
    try {
      debugPrint('👤 AccountCubit: Initializing account data');
      stateChanger(state.copyWith(status: AccountStatus.loading));

      // Try to load from app_config.json first
      final configLoaded =
          await _configHelper.loadConfig('assets/app_config.json') ||
              await _configHelper.loadConfig();

      Map<String, dynamic> accountData;

      if (configLoaded) {
        // Try to get account data from config
        final configData = _configHelper.getAllConfig();
        final accountConfig = configData?['account_configuration'];

        if (accountConfig != null) {
          debugPrint(
              '👤 AccountCubit: Loading account data from app_config.json');
          accountData = accountConfig as Map<String, dynamic>;
        } else {
          debugPrint(
              '👤 AccountCubit: No account_configuration found, using mock data');
          accountData = _getMockAccountData();
        }
      } else {
        debugPrint('👤 AccountCubit: Config not found, using mock data');
        accountData = _getMockAccountData();
      }

      // Load profile data: Priority 1) User API Data, 2) Auth Storage, 3) Config, 4) Default
      final profileData = await _loadProfileData(accountData, _userApiData);

      // Parse sections
      final sectionsList = accountData['sections'];
      final sections = sectionsList != null && sectionsList is List<dynamic>
          ? sectionsList
              .map((section) => section is Map<String, dynamic>
                  ? AccountSection.fromJson(section)
                  : null)
              .whereType<AccountSection>()
              .toList()
          : <AccountSection>[];

      // Parse style from config (matching splash configuration pattern)
      final styleString = accountData['style'] as String? ?? 'enterprise';
      final style = _parseStyleFromString(styleString);

      stateChanger(state.copyWith(
        status: AccountStatus.ready,
        profileData: profileData,
        sections: sections,
        style: style,
      ));

      debugPrint('👤 AccountCubit: Account data loaded successfully');
    } catch (e) {
      debugPrint('❌ AccountCubit: Error loading account data: $e');
      stateChanger(state.copyWith(
        status: AccountStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Load profile data: Priority 1) User API Data, 2) Auth Storage, 3) Default
  /// Config is not used for profile data - it's always from user API data, auth storage or default
  /// Platform-specific implementations should provide user API data via setUserApiData()
  Future<AccountProfileData> _loadProfileData(Map<String, dynamic> accountData,
      Map<String, dynamic>? userApiData) async {
    try {
      // Always try to load from Auth Storage first
      final authStorage = AuthStorageHelper();
      final userData = await authStorage.getUserData();

      // Use user API data if provided (from platform-specific implementation)
      Map<String, dynamic>? getUsersMeData = userApiData;
      if (getUsersMeData != null) {
        final apiName = getUsersMeData['name'];
        debugPrint('✅ AccountCubit: User API data available');
        debugPrint(
            '👤 AccountCubit: User API data keys: ${getUsersMeData.keys.toList()}');
        debugPrint(
            '👤 AccountCubit: User name from API: "$apiName" (type: ${apiName.runtimeType})');

        // Check if name is valid (not null and not empty)
        if (apiName != null && apiName is String && apiName.isNotEmpty) {
          debugPrint(
              '✅ AccountCubit: Valid name found in API response: "$apiName"');
        } else {
          debugPrint('⚠️ AccountCubit: Name is null or empty in API response');
        }
      } else {
        debugPrint('⚠️ AccountCubit: User API data not provided');
      }

      if (userData != null && userData.isNotEmpty) {
        debugPrint('👤 AccountCubit: Loading profile from auth storage');
        debugPrint('👤 AccountCubit: userData keys: ${userData.keys.toList()}');
        debugPrint('👤 AccountCubit: userData: $userData');

        // Extract user info from userData
        // UserInfo.toJson() returns: email, first_name, last_name
        // getUsersMe data may also be in userData (name, display_name, id, slug)
        String email = userData['email'] as String? ??
            userData['user_email'] as String? ??
            '';

        // Note: AuthCubit fallback removed - AccountCubit should only use AuthStorageHelper
        // All user data should be stored in AuthStorageHelper by platform-specific implementations

        final firstName = userData['first_name'] as String? ??
            userData['firstName'] as String? ??
            '';
        final lastName = userData['last_name'] as String? ??
            userData['lastName'] as String? ??
            '';

        // Build full name: Priority 1) getUsersMe name (DO NOT combine firstName + lastName)
        // Only use firstName + lastName if getUsersMe name is not available
        String fullName;
        final getUsersMeName = getUsersMeData?['name'];
        debugPrint('🔍 AccountCubit: _loadProfileData - getUsersMeName check:');
        debugPrint('  - getUsersMeData != null: ${getUsersMeData != null}');
        debugPrint('  - getUsersMeName: "$getUsersMeName"');
        debugPrint('  - getUsersMeName != null: ${getUsersMeName != null}');
        if (getUsersMeName != null) {
          debugPrint(
              '  - getUsersMeName is String: ${getUsersMeName is String}');
          if (getUsersMeName is String) {
            debugPrint('  - getUsersMeName.isEmpty: ${getUsersMeName.isEmpty}');
            debugPrint('  - getUsersMeName.length: ${getUsersMeName.length}');
            debugPrint(
                '  - getUsersMeName codeUnits: ${getUsersMeName.codeUnits}');
          }
        }
        if (getUsersMeData != null &&
            getUsersMeName != null &&
            getUsersMeName is String &&
            getUsersMeName.isNotEmpty) {
          // Use name from getUsersMe response directly - NO processing, use as-is
          // DO NOT combine firstName + lastName when getUsersMe name exists
          fullName = getUsersMeName;
          debugPrint(
              '✅ AccountCubit: Using name from getUsersMe (as-is, NO processing): "$fullName"');
          debugPrint('✅ AccountCubit: fullName.length: ${fullName.length}');
          debugPrint(
              '✅ AccountCubit: fullName.codeUnits: ${fullName.codeUnits}');
        } else {
          debugPrint('⚠️ AccountCubit: getUsersMe name check failed');
          debugPrint('  - getUsersMeData is null: ${getUsersMeData == null}');
          debugPrint('  - getUsersMeName: $getUsersMeName');
          debugPrint('  - getUsersMeName type: ${getUsersMeName?.runtimeType}');
          debugPrint(
              '  - getUsersMeName is String: ${getUsersMeName is String}');
          if (getUsersMeName is String) {
            debugPrint('  - getUsersMeName isEmpty: ${getUsersMeName.isEmpty}');
          }
          // Only combine firstName + lastName if getUsersMe name is NOT available
          debugPrint(
              '⚠️ AccountCubit: getUsersMe name not available, trying fallbacks...');
          if (firstName.isNotEmpty && lastName.isNotEmpty) {
            // Combine firstName and lastName with a single space
            fullName = '${firstName.trim()} ${lastName.trim()}'.trim();
            debugPrint(
                '👤 AccountCubit: Using firstName + lastName: "$fullName"');
          } else if (firstName.isNotEmpty) {
            fullName = firstName.trim();
            debugPrint('👤 AccountCubit: Using firstName only: "$fullName"');
          } else if (lastName.isNotEmpty) {
            fullName = lastName.trim();
            debugPrint('👤 AccountCubit: Using lastName only: "$fullName"');
          } else {
            // Fallback to display_name or name from userData, or use email prefix
            final fallbackName = userData['display_name'] as String? ??
                userData['name'] as String? ??
                (email.isNotEmpty ? email.split('@').first : 'User');
            fullName = fallbackName.trim();
            debugPrint('👤 AccountCubit: Using fallback name: "$fullName"');
          }
        }

        // Build initials
        String initials = _getInitials(fullName);

        // Email should always be available from UserInfo
        final finalEmail = email.isNotEmpty ? email : '';

        // Get username from getUsersMe (slug or name)
        String username = '';
        if (getUsersMeData != null) {
          username = getUsersMeData['slug'] as String? ??
              getUsersMeData['name'] as String? ??
              '';
          debugPrint(
              '👤 AccountCubit: Using username from getUsersMe: $username');
        } else if (userData['slug'] != null) {
          username = userData['slug'] as String;
        } else if (userData['name'] != null) {
          username = userData['name'] as String;
        }

        debugPrint(
            '👤 AccountCubit: Extracted - email: $finalEmail, fullName: $fullName, username: $username, initials: $initials');

        return AccountProfileData(
          fullName: fullName,
          email: finalEmail,
          initials: initials,
          username: username,
        );
      }

      // If no auth storage data, use default values
      debugPrint(
          '👤 AccountCubit: No auth data found, using default profile data');
      return const AccountProfileData(
        fullName: 'username',
        email: 'username@email.com',
        initials: 'UN',
        username: 'username',
      );
    } catch (e) {
      debugPrint('❌ AccountCubit: Error loading profile data: $e');
      // Return default on error
      return const AccountProfileData(
        fullName: 'username',
        email: 'username@email.com',
        initials: 'UN',
        username: 'username',
      );
    }
  }

  /// Get mock account data
  /// This is used as fallback when app_config.json is not available
  Map<String, dynamic> _getMockAccountData() {
    return {
      'style': 'startup',
      'profile': {
        'fullName': 'username',
        'email': 'username@email.com',
        'initials': 'UN',
      },
      'sections': [
        {
          'sectionTitle': 'Orders & Requests',
          'items': [
            {
              'id': 'all_orders',
              'title': 'All My Orders',
              'iconName': 'shopping_bag_outlined',
              'iconColor': '#4A90E2',
              'route': '/orders',
            },
            {
              'id': 'return_requests',
              'title': 'My Return Requests',
              'iconName': 'schedule',
              'iconColor': '#4CAF50',
              'route': '/returns',
            },
            {
              'id': 'cancel_requests',
              'title': 'My Cancellation Requests',
              'iconName': 'update',
              'iconColor': '#FFC107',
              'route': '/cancellations',
            },
          ],
        },
        {
          'sectionTitle': 'Account & Preferences',
          'items': [
            {
              'id': 'account_settings',
              'title': 'Account Settings',
              'iconName': 'person_outline',
              'iconColor': '#4A90E2',
              'route': '/account-info',
            },
            {
              'id': 'notification_preferences',
              'title': 'Notification Preferences',
              'iconName': 'notifications_outlined',
              'iconColor': '#E57373',
              'route': '/notifications',
            },
          ],
        },
        {
          'sectionTitle': 'Alarm & Watchlists',
          'items': [
            {
              'id': 'stock_alarm',
              'title': 'My Stock Alarm List',
              'iconName': 'inventory_outlined',
              'iconColor': '#9C27B0',
              'route': '/stock-alarms',
            },
            {
              'id': 'price_alarm',
              'title': 'My Price Alarm List',
              'iconName': 'local_offer_outlined',
              'iconColor': '#673AB7',
              'route': '/price-alarms',
            },
          ],
        },
      ],
    };
  }

  /// Update profile information
  void updateProfile(String name, String email, {String? username}) {
    final updatedProfile = state.profileData.copyWith(
      fullName: name,
      email: email,
      initials: _getInitials(name),
      username: username,
    );

    stateChanger(state.copyWith(profileData: updatedProfile));
  }

  /// Get initials from full name
  String _getInitials(String name) {
    // Trim and split, then filter out empty strings
    final parts = name.trim().split(' ').where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      // Single word: return first letter
      return parts[0][0].toUpperCase();
    }
    // Multiple words: return first letter of first word + first letter of last word
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }

  /// Convert string to AccountStyle enum (matching splash configuration pattern)
  AccountStyle _parseStyleFromString(String styleString) {
    switch (styleString.toLowerCase()) {
      case 'startup':
        return AccountStyle.startup;
      case 'space':
        return AccountStyle.space;
      case 'enterprise':
      default:
        return AccountStyle.enterprise;
    }
  }

  /// Clear account data (called on logout)
  /// Resets state to initial values to prevent showing stale user data
  void clearAccountData() {
    debugPrint('🗑️ AccountCubit: Clearing account data...');
    stateChanger(const AccountState());
    debugPrint('✅ AccountCubit: Account data cleared');
  }

  /// Sign out from account
  /// Clears all account-related data and state
  /// Platform-specific cleanup (e.g., AuthCubit signOut) can be provided via callback
  Future<void> signOut({Future<void> Function()? onSignOut}) async {
    debugPrint('🚪 AccountCubit: Signing out...');

    // Clear user API data
    _userApiData = null;
    debugPrint('✅ AccountCubit: User API data cleared');

    // Clear account state
    clearAccountData();

    // Call platform-specific signOut callback if provided
    if (onSignOut != null) {
      try {
        await onSignOut();
        debugPrint('✅ AccountCubit: Platform-specific signOut completed');
      } catch (e) {
        debugPrint('⚠️ AccountCubit: Error in platform-specific signOut: $e');
      }
    }

    debugPrint('✅ AccountCubit: Sign out completed');
  }
}
