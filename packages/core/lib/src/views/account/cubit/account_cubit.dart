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

/// 🧠 **OSMEA Account Cubit**
///
/// Manages account view state and data loading
/// Supports loading from app_config.json or mock data fallback
class AccountCubit extends BaseViewModelCubit<AccountState> {
  AccountCubit() : super(const AccountState());

  final AssetConfigHelper _configHelper = AssetConfigHelper();

  // Public trigger functions
  void initialize() => _initialize();

  /// Refresh profile data from auth storage
  /// Call this when user logs in or profile is updated
  void refreshProfile() => _initialize();

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

      // Load profile data: Priority 1) Auth Storage, 2) Config, 3) Default
      final profileData = await _loadProfileData(accountData);

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

  /// Load profile data: Always try Auth Storage first, then use default values
  /// Config is not used for profile data - it's always from auth storage or default
  Future<AccountProfileData> _loadProfileData(
      Map<String, dynamic> accountData) async {
    try {
      // Always try to load from Auth Storage first
      final authStorage = AuthStorageHelper();
      final userData = await authStorage.getUserData();

      if (userData != null && userData.isNotEmpty) {
        debugPrint('👤 AccountCubit: Loading profile from auth storage');
        debugPrint('👤 AccountCubit: userData keys: ${userData.keys.toList()}');
        debugPrint('👤 AccountCubit: userData: $userData');

        // Extract user info from userData
        // UserInfo.toJson() returns: email, first_name, last_name
        final email = userData['email'] as String? ??
            userData['user_email'] as String? ??
            '';

        final firstName = userData['first_name'] as String? ??
            userData['firstName'] as String? ??
            '';
        final lastName = userData['last_name'] as String? ??
            userData['lastName'] as String? ??
            '';

        // Build full name from firstName and lastName
        String fullName;
        if (firstName.isNotEmpty && lastName.isNotEmpty) {
          fullName = '$firstName $lastName';
        } else if (firstName.isNotEmpty) {
          fullName = firstName;
        } else if (lastName.isNotEmpty) {
          fullName = lastName;
        } else {
          // Fallback to display_name or name, or use email prefix
          fullName = userData['display_name'] as String? ??
              userData['name'] as String? ??
              (email.isNotEmpty ? email.split('@').first : 'User');
        }

        // Build initials
        String initials = _getInitials(fullName);

        // Email should always be available from UserInfo
        final finalEmail = email.isNotEmpty ? email : '';

        debugPrint(
            '👤 AccountCubit: Extracted - email: $finalEmail, fullName: $fullName, initials: $initials');

        return AccountProfileData(
          fullName: fullName,
          email: finalEmail,
          initials: initials,
        );
      }

      // If no auth storage data, use default values
      debugPrint(
          '👤 AccountCubit: No auth data found, using default profile data');
      return const AccountProfileData(
        fullName: 'username',
        email: 'username@email.com',
        initials: 'UN',
      );
    } catch (e) {
      debugPrint('❌ AccountCubit: Error loading profile data: $e');
      // Return default on error
      return const AccountProfileData(
        fullName: 'username',
        email: 'username@email.com',
        initials: 'UN',
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
  void updateProfile(String name, String email) {
    final updatedProfile = state.profileData.copyWith(
      fullName: name,
      email: email,
      initials: _getInitials(name),
    );

    stateChanger(state.copyWith(profileData: updatedProfile));
  }

  /// Get initials from full name
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
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
}
