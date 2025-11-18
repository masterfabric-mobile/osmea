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
import 'package:core/src/views/auth/cubit/auth_cubit.dart';

/// 🧠 **OSMEA Account Cubit**
///
/// Manages account view state and data loading
/// Supports loading from app_config.json or mock data fallback
class AccountCubit extends BaseViewModelCubit<AccountState> {
  AccountCubit({
    AuthCubit? authCubit,
    Future<Map<String, dynamic>?> Function()? getUsersMeCallback,
  }) : super(const AccountState()) {
    _authCubit = authCubit;
    _getUsersMeCallback = getUsersMeCallback;
    debugPrint('🔍 AccountCubit: Constructor called');
    debugPrint(
        '🔍 AccountCubit: getUsersMeCallback is null: ${getUsersMeCallback == null}');
    debugPrint('🔍 AccountCubit: authCubit is null: ${authCubit == null}');
  }

  final AssetConfigHelper _configHelper = AssetConfigHelper();
  AuthCubit? _authCubit;
  Future<Map<String, dynamic>?> Function()? _getUsersMeCallback;

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
  /// Also checks AuthCubit metadata for getUsersMe data
  Future<AccountProfileData> _loadProfileData(
      Map<String, dynamic> accountData) async {
    try {
      // Always try to load from Auth Storage first
      final authStorage = AuthStorageHelper();
      final userData = await authStorage.getUserData();

      // Call getUsersMe API to get fresh user data (user can update their info)
      // Use callback if provided, otherwise fallback to metadata
      Map<String, dynamic>? getUsersMeData;
      if (_getUsersMeCallback != null) {
        try {
          debugPrint(
              '👤 AccountCubit: Calling getUsersMe API for fresh user data...');
          getUsersMeData = await _getUsersMeCallback!();
          if (getUsersMeData != null) {
            final apiName = getUsersMeData['name'];
            debugPrint('✅ AccountCubit: getUsersMe API call successful');
            debugPrint(
                '👤 AccountCubit: getUsersMeData keys: ${getUsersMeData.keys.toList()}');
            debugPrint(
                '👤 AccountCubit: User name from API: "$apiName" (type: ${apiName.runtimeType})');

            // Check if name is valid (not null and not empty)
            if (apiName != null && apiName is String && apiName.isNotEmpty) {
              debugPrint(
                  '✅ AccountCubit: Valid name found in API response: "$apiName"');
            } else {
              debugPrint(
                  '⚠️ AccountCubit: Name is null or empty in API response');
              // Don't set to null, keep the data but name will be null
            }
          } else {
            debugPrint('⚠️ AccountCubit: getUsersMe API returned null');
            getUsersMeData = null;
          }
        } catch (e, stackTrace) {
          debugPrint('⚠️ AccountCubit: Error calling getUsersMe API: $e');
          debugPrint('⚠️ AccountCubit: Stack trace: $stackTrace');
          getUsersMeData = null;
        }
      } else {
        debugPrint('⚠️ AccountCubit: getUsersMe callback is null');
      }

      // Fallback to metadata if callback not provided or failed
      if (getUsersMeData == null && _authCubit != null) {
        try {
          getUsersMeData = _authCubit!
              .getMetadataValue<Map<String, dynamic>>('get_users_me');
          if (getUsersMeData != null) {
            debugPrint(
                '👤 AccountCubit: Using getUsersMe data from metadata (fallback)');
            debugPrint(
                '👤 AccountCubit: Metadata name: "${getUsersMeData['name']}"');
          }
        } catch (e) {
          debugPrint(
              '⚠️ AccountCubit: Error reading metadata from AuthCubit: $e');
        }
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

        // If email is still empty, try to get from AuthCubit metadata (JWT token)
        if (email.isEmpty && _authCubit != null) {
          try {
            final authUserData = _authCubit!.userData;
            if (authUserData != null) {
              email = authUserData['email'] as String? ??
                  authUserData['user_email'] as String? ??
                  email;
              if (email.isNotEmpty) {
                debugPrint(
                    '👤 AccountCubit: Email found in AuthCubit userData: $email');
              }
            }
          } catch (e) {
            debugPrint(
                '⚠️ AccountCubit: Error reading email from AuthCubit: $e');
          }
        }

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
}
