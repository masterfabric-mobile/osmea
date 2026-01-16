/*
 * AccountWidget
 * --------------
 * UI Components for the account view following OSMEA architecture.
 * Uses Mixin pattern for separation of Widget and View.
 *
 * Copyright (c) 2025, OSMEA Team
 * https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
 *
 * {@category Widgets}
 * {@subCategory AccountWidget}
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

/// Mixin for account widget content
mixin AccountWidget {
  /// Optional goRoute callback for navigation
  /// If not provided, will use context.go
  Function(String)? get goRouteCallback => null;

  /// Optional onSignOut callback for platform-specific cleanup
  /// Called during logout to clear cookies, wishlist, cart, etc.
  /// If not provided, only core cleanup will be performed
  Future<void> Function()? get onSignOutCallback => null;

  Widget buildAccountContent(
    BuildContext context,
    AccountCubit viewModel,
    AccountState state,
  ) {
    // Style-based rendering
    switch (state.style) {
      case AccountStyle.startup:
        return _buildStartupStyle(context, viewModel, state);
      case AccountStyle.space:
        return _buildSpaceStyle(context, viewModel, state);
      case AccountStyle.enterprise:
        return _buildEnterpriseStyle(context, viewModel, state);
    }
  }

  /// Build startup style with account content
  Widget _buildStartupStyle(
    BuildContext context,
    AccountCubit viewModel,
    AccountState state,
  ) {
    final sections = state.sections;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.spacing16),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // User Account Header (startup style)
            _buildStartupAccountHeader(context, state),
            OsmeaComponents.sizedBox(height: context.spacing24),

            // Dynamic Sections from State - Tappable Card Style
            ...sections.expand((section) => section.items.map(
                  (item) => OsmeaComponents.column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStartupMenuItem(context, item),
                      OsmeaComponents.sizedBox(height: context.spacing12),
                    ],
                  ),
                )),

            // Account Details Section (only if authenticated)
            // Hidden: JWT token and cart token sections should not be visible
            // if (_isAuthenticated(context)) ...[
            //   OsmeaComponents.sizedBox(height: context.spacing8),
            //   _buildStartupAccountSection(context),
            //   OsmeaComponents.sizedBox(height: context.spacing24),
            // ],

            // Actions
            _buildStartupActions(context, viewModel),

            // Bottom spacing for safe area
            OsmeaComponents.sizedBox(height: context.spacing32),
          ],
        ),
      ),
    );
  }

  /// Build space style - minimalist with separators (no tappable cards)
  Widget _buildSpaceStyle(
    BuildContext context,
    AccountCubit viewModel,
    AccountState state,
  ) {
    final sections = state.sections;

    // Get colors from config (default to black/white)
    final configHelper = AssetConfigHelper();
    final primaryColor = configHelper.getColor(
      'account_configuration.space_style_colors.primary_color',
      OsmeaColors.black,
    );
    final textColor = configHelper.getColor(
      'account_configuration.space_style_colors.text_color',
      OsmeaColors.black,
    );
    final iconColor = configHelper.getColor(
      'account_configuration.space_style_colors.icon_color',
      OsmeaColors.black,
    );
    final separatorColor = configHelper.getColor(
      'account_configuration.space_style_colors.separator_color',
      OsmeaColors.ash,
    );
    final backgroundColor = configHelper.getColor(
      'account_configuration.space_style_colors.background_color',
      OsmeaColors.white,
    );

    return SafeArea(
      child: Container(
        color: backgroundColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.spacing16),
          child: OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // User Account Header (space style - minimalist)
              _buildSpaceAccountHeader(context, state, textColor, iconColor),
              OsmeaComponents.sizedBox(height: context.spacing32),

              // Dynamic Sections with separators
              ...sections.expand((section) => [
                    ...section.items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final isLast = index == section.items.length - 1;

                      return OsmeaComponents.column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSpaceMenuItem(
                            context,
                            item,
                            textColor,
                            iconColor,
                            separatorColor,
                          ),
                          if (!isLast)
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: separatorColor,
                            ),
                        ],
                      );
                    }),
                    OsmeaComponents.sizedBox(height: context.spacing24),
                  ]),

              // Account Details Section (only if authenticated)
              // Hidden: JWT token and cart token sections should not be visible
              // if (_isAuthenticated(context)) ...[
              //   Divider(
              //     height: 1,
              //     thickness: 1,
              //     color: separatorColor,
              //   ),
              //   OsmeaComponents.sizedBox(height: context.spacing24),
              //   _buildSpaceAccountSection(
              //       context, textColor, iconColor, separatorColor),
              //   OsmeaComponents.sizedBox(height: context.spacing24),
              // ],

              // Actions
              _buildSpaceActions(context, viewModel, primaryColor, textColor),

              // Bottom spacing for safe area
              OsmeaComponents.sizedBox(height: context.spacing32),
            ],
          ),
        ),
      ),
    );
  }

  /// Build space style account header (minimalist)
  Widget _buildSpaceAccountHeader(
    BuildContext context,
    AccountState state,
    Color textColor,
    Color iconColor,
  ) {
    final profileData = state.profileData;

    final displayName =
        profileData.fullName.isNotEmpty ? profileData.fullName : 'Guest';
    final email = profileData.email.isNotEmpty ? profileData.email : '';
    // Always calculate initials from displayName (name)
    // First letter of first word + first letter of last word (if multiple words)
    final initials = _getInitialsFromName(displayName);
    final isAuthenticated = _isAuthenticated(context);

    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.row(
          children: [
            // Avatar (minimalist - just initials, no background)
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: iconColor, width: 2),
              ),
              child: Center(
                child: OsmeaComponents.text(
                  initials,
                  textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            OsmeaComponents.sizedBox(width: context.spacing16),
            // User Info
            Expanded(
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display Name (fullName) - use as-is from API, NO processing
                  OsmeaComponents.text(
                    displayName,
                    textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  // Email - only show if not empty
                  if (email.isNotEmpty) ...[
                    OsmeaComponents.sizedBox(height: context.spacing4),
                    OsmeaComponents.text(
                      email,
                      textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                        color: textColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        if (isAuthenticated) ...[
          OsmeaComponents.sizedBox(height: context.spacing12),
          OsmeaComponents.row(
            children: [
              Icon(
                Icons.check_circle,
                size: 16,
                color: iconColor,
              ),
              OsmeaComponents.sizedBox(width: context.spacing4),
              OsmeaComponents.text(
                'Authenticated',
                textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                  color: textColor.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// Build space style menu item (minimalist with separator)
  Widget _buildSpaceMenuItem(
    BuildContext context,
    AccountMenuItem item,
    Color textColor,
    Color iconColor,
    Color separatorColor,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (item.route.isNotEmpty) {
            _navigate(context, item.route);
          }
        },
        splashColor: iconColor.withOpacity(0.08),
        highlightColor: iconColor.withOpacity(0.04),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: context.spacing12,
            horizontal: context.spacing4,
          ),
          child: OsmeaComponents.row(
            children: [
              // Icon (minimalist - no background, softer size)
              Icon(
                _getIconData(item.iconName),
                color: iconColor.withOpacity(0.9),
                size: context.iconSizeNormal,
              ),
              OsmeaComponents.sizedBox(width: context.spacing12),
              // Title - softer styling
              Expanded(
                child: OsmeaComponents.text(
                  item.title,
                  textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                    fontWeight: FontWeight.w500,
                    color: textColor,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              // Arrow Icon - softer and rounded
              Icon(
                Icons.chevron_right_rounded,
                color: iconColor.withOpacity(0.35),
                size: context.iconSizeSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build space style account section
  /// Hidden: JWT token and cart token sections should not be visible
  // ignore: unused_element
  Widget _buildSpaceAccountSection(
    BuildContext context,
    Color textColor,
    Color iconColor,
    Color separatorColor,
  ) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          'Account Details',
          textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        OsmeaComponents.sizedBox(height: context.spacing16),
        // Async token checks
        FutureBuilder<Map<String, bool>>(
          future: _checkTokens(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            }

            final hasJwtToken = snapshot.data?['jwt'] ?? false;
            final hasCartToken = snapshot.data?['cart'] ?? false;

            if (!hasJwtToken && !hasCartToken) {
              return const SizedBox.shrink();
            }

            return OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // JWT Token Info
                if (hasJwtToken)
                  _buildSpaceAccountDetailItem(
                    context,
                    icon: Icons.lock_outline_rounded,
                    label: 'JWT Token',
                    value: 'Available',
                    textColor: textColor,
                    iconColor: iconColor,
                    isLast: !hasCartToken,
                  ),
                // Cart Token Info
                if (hasCartToken)
                  _buildSpaceAccountDetailItem(
                    context,
                    icon: Icons.shopping_bag_outlined,
                    label: 'Cart Token',
                    value: 'Available',
                    textColor: textColor,
                    iconColor: iconColor,
                    isLast: true,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// Build space style account detail item
  Widget _buildSpaceAccountDetailItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color textColor,
    required Color iconColor,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : context.spacing16),
      child: OsmeaComponents.row(
        children: [
          Icon(
            icon,
            size: 20,
            color: iconColor.withOpacity(0.6),
          ),
          OsmeaComponents.sizedBox(width: context.spacing12),
          Expanded(
            child: OsmeaComponents.text(
              label,
              textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                color: textColor,
              ),
            ),
          ),
          OsmeaComponents.text(
            value,
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Build space style actions
  Widget _buildSpaceActions(
    BuildContext context,
    AccountCubit viewModel,
    Color primaryColor,
    Color textColor,
  ) {
    final isAuthenticated = _isAuthenticated(context);
    final configHelper = AssetConfigHelper();

    // Get button colors from config
    final signOutBgColor = configHelper.getColor(
      'auth_configuration.buttons.sign_out.backgroundColor',
      OsmeaColors.white,
    );
    final signOutTextColor = configHelper.getColor(
      'auth_configuration.buttons.sign_out.textColor',
      OsmeaColors.black,
    );
    final signOutBorderColor = configHelper.getColor(
      'auth_configuration.buttons.sign_out.borderColor',
      OsmeaColors.black,
    );
    final signInBgColor = configHelper.getColor(
      'auth_configuration.buttons.sign_in.backgroundColor',
      primaryColor,
    );
    final signInTextColor = configHelper.getColor(
      'auth_configuration.buttons.sign_in.textColor',
      OsmeaColors.white,
    );

    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isAuthenticated)
          OsmeaComponents.button(
            onPressed: () => _signOut(context, viewModel),
            variant: ButtonVariant.outlined,
            size: ButtonSize.large,
            backgroundColor: signOutBgColor,
            textColor: signOutTextColor,
            borderColor: signOutBorderColor,
            text: 'Sign Out',
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: signOutTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (!isAuthenticated)
          OsmeaComponents.button(
            onPressed: () => _navigate(context, '/auth'),
            variant: ButtonVariant.primary,
            size: ButtonSize.large,
            backgroundColor: signInBgColor,
            textColor: signInTextColor,
            text: 'Sign In',
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: signInTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  /// Build enterprise style (existing implementation)
  Widget _buildEnterpriseStyle(
    BuildContext context,
    AccountCubit viewModel,
    AccountState state,
  ) {
    final profileData = state.profileData;
    final sections = state.sections;

    return OsmeaComponents.singleChildScrollView(
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account Header Card
          _buildProfileHeader(context, profileData),

          OsmeaComponents.sizedBox(height: 24),

          // Dynamic Sections from State
          ...sections.map((section) => OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(context, section),
                  OsmeaComponents.sizedBox(height: 24),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    AccountProfileData profileData,
  ) {
    final displayName =
        profileData.fullName.isNotEmpty ? profileData.fullName : 'Guest';
    // Always calculate initials from displayName (name)
    final initials = _getInitialsFromName(displayName);

    return OsmeaComponents.container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF7BB3F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: OsmeaComponents.row(
        children: [
          // Account Avatar
          OsmeaComponents.container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: OsmeaColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: OsmeaComponents.center(
              child: OsmeaComponents.text(
                initials,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: OsmeaColors.white,
              ),
            ),
          ),

          OsmeaComponents.sizedBox(width: 16),

          // Account Info
          OsmeaComponents.expanded(
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display Name (fullName)
                OsmeaComponents.text(
                  profileData.fullName.isNotEmpty
                      ? profileData.fullName
                      : 'Guest',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: OsmeaColors.white,
                ),
                // Email - only show if not empty
                if (profileData.email.isNotEmpty) ...[
                  OsmeaComponents.sizedBox(height: 4),
                  OsmeaComponents.text(
                    profileData.email,
                    fontSize: 14,
                    color: OsmeaColors.white.withOpacity(0.8),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Get initials from name
  /// Returns first letter of first word + first letter of last word (if multiple words)
  /// If single word, returns first letter only
  String _getInitialsFromName(String name) {
    final parts = name.trim().split(' ').where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    // First letter of first word + first letter of last word
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }

  Widget _buildSection(BuildContext context, AccountSection section) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          section.sectionTitle,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: OsmeaColors.black,
        ),
        OsmeaComponents.sizedBox(height: 16),
        ...section.items.map((item) => _buildMenuItem(context, item)),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, AccountMenuItem item) {
    // Parse color from hex string
    final iconColor = _parseColor(item.iconColor);
    final iconBackgroundColor = iconColor.withOpacity(0.08);

    return OsmeaComponents.container(
      margin: EdgeInsets.only(bottom: context.spacing8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (item.route.isNotEmpty) {
              _navigate(context, item.route);
            }
          },
          borderRadius: BorderRadius.circular(context.radiusMedium),
          splashColor: iconColor.withOpacity(0.1),
          highlightColor: iconColor.withOpacity(0.05),
          child: OsmeaComponents.container(
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing16,
              vertical: context.spacing12,
            ),
            decoration: BoxDecoration(
              color: OsmeaColors.white,
              borderRadius: BorderRadius.circular(context.radiusMedium),
              border: Border.all(
                color: OsmeaColors.grayMaterial[200] ?? OsmeaColors.silver.withOpacity(0.2),
                width: 0.5,
              ),
            ),
            child: OsmeaComponents.row(
              children: [
                // Icon Container - softer and more elegant
                OsmeaComponents.container(
                  width: context.iconSizeNormal + context.spacing4,
                  height: context.iconSizeNormal + context.spacing4,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(context.radiusMedium),
                  ),
                  child: OsmeaComponents.center(
                    child: Icon(
                      _getIconData(item.iconName),
                      color: iconColor,
                      size: context.iconSizeSmall,
                    ),
                  ),
                ),

                OsmeaComponents.sizedBox(width: context.spacing12),

                // Title - softer font weight
                OsmeaComponents.expanded(
                  child: OsmeaComponents.text(
                    item.title,
                    textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                      fontWeight: FontWeight.w500,
                      color: OsmeaColors.black,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),

                OsmeaComponents.sizedBox(width: context.spacing8),

                // Arrow Icon - softer color
                Icon(
                  Icons.chevron_right_rounded,
                  color: OsmeaColors.grayMaterial[400] ?? OsmeaColors.slate.withOpacity(0.4),
                  size: context.iconSizeSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to parse hex color
  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  // Helper method to get IconData from string name
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'shopping_bag_outlined':
        return Icons.shopping_bag_outlined;
      case 'schedule':
        return Icons.schedule;
      case 'update':
        return Icons.update;
      case 'person_outline':
        return Icons.person_outline;
      case 'notifications_outlined':
        return Icons.notifications_outlined;
      case 'inventory_outlined':
        return Icons.inventory_outlined;
      case 'local_offer_outlined':
        return Icons.local_offer_outlined;
      default:
        return Icons.info_outline;
    }
  }

  // Startup style helper methods

  /// Check if user is authenticated
  bool _isAuthenticated(BuildContext context) {
    try {
      final authCubit = GetIt.I<AuthCubit>();
      return authCubit.state is AuthAuthenticatedState;
    } catch (e) {
      return false;
    }
  }

  /// Navigate using goRoute callback or context.go
  /// Same behavior as enterprise style - routes should work if they exist
  void _navigate(BuildContext context, String route) {
    try {
      if (goRouteCallback != null) {
        goRouteCallback!(route);
      } else {
        context.go(route);
      }
    } catch (e) {
      // If navigation fails, show error message
      debugPrint('❌ AccountWidget: Navigation failed for $route: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigation failed: ${route.replaceFirst('/', '')}'),
          backgroundColor: OsmeaColors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Build startup style account header
  Widget _buildStartupAccountHeader(
    BuildContext context,
    AccountState state,
  ) {
    final profileData = state.profileData;

    // Use profileData from AccountCubit (loaded from AuthStorageHelper)
    final displayName =
        profileData.fullName.isNotEmpty ? profileData.fullName : 'Guest';
    final email = profileData.email.isNotEmpty ? profileData.email : '';
    // Always calculate initials from displayName (name)
    // First letter of first word + first letter of last word (if multiple words)
    final initials = _getInitialsFromName(displayName);
    final isAuthenticated = _isAuthenticated(context);

    return _buildCardWrapper(
      context: context,
      backgroundColor: OsmeaColors.white,
      borderColor: OsmeaColors.nordicBlue,
      padding: EdgeInsets.all(context.spacing20),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.row(
            children: [
              // Avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: OsmeaColors.nordicBlue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: OsmeaColors.nordicBlue.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: OsmeaComponents.text(
                    initials,
                    textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                      color: OsmeaColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              OsmeaComponents.sizedBox(width: context.spacing16),
              // User Info
              Expanded(
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display Name (fullName) - use as-is from API, NO processing
                    OsmeaComponents.text(
                      displayName,
                      textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                        fontWeight: FontWeight.w700,
                        color: OsmeaColors.thunder,
                      ),
                    ),
                    // Email - only show if not empty
                    if (email.isNotEmpty) ...[
                      OsmeaComponents.sizedBox(height: context.spacing4),
                      OsmeaComponents.text(
                        email,
                        textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                          color: OsmeaColors.pewter,
                        ),
                      ),
                    ],
                    OsmeaComponents.sizedBox(height: context.spacing8),
                    // Status Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.spacing12,
                        vertical: context.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: isAuthenticated
                            ? OsmeaColors.nordicBlue.withOpacity(0.1)
                            : OsmeaColors.pewter.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isAuthenticated
                              ? OsmeaColors.nordicBlue
                              : OsmeaColors.pewter,
                          width: 1,
                        ),
                      ),
                      child: OsmeaComponents.row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isAuthenticated ? Icons.check_circle : Icons.cancel,
                            size: 16,
                            color: isAuthenticated
                                ? OsmeaColors.nordicBlue
                                : OsmeaColors.pewter,
                          ),
                          OsmeaComponents.sizedBox(width: context.spacing4),
                          OsmeaComponents.text(
                            isAuthenticated
                                ? 'Authenticated'
                                : 'Not Authenticated',
                            textStyle:
                                OsmeaTextStyle.bodySmall(context).copyWith(
                              color: isAuthenticated
                                  ? OsmeaColors.nordicBlue
                                  : OsmeaColors.pewter,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build startup style account section
  /// Hidden: JWT token and cart token sections should not be visible
  // ignore: unused_element
  Widget _buildStartupAccountSection(BuildContext context) {
    return _buildCardWrapper(
      context: context,
      backgroundColor: OsmeaColors.white,
      borderColor: OsmeaColors.silver,
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            'Account Details',
            textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
              fontWeight: FontWeight.w700,
              color: OsmeaColors.thunder,
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing16),
          // Async token checks
          FutureBuilder<Map<String, bool>>(
            future: _checkTokens(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              }

              final hasJwtToken = snapshot.data?['jwt'] ?? false;
              final hasCartToken = snapshot.data?['cart'] ?? false;

              // If no tokens, don't show anything
              if (!hasJwtToken && !hasCartToken) {
                return const SizedBox.shrink();
              }

              return OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // JWT Token Info
                  if (hasJwtToken)
                    _buildAccountDetailItem(
                      context,
                      icon: Icons.lock_outline_rounded,
                      label: 'JWT Token',
                      value: 'Available',
                      valueColor: OsmeaColors.nordicBlue,
                      isLast: !hasCartToken,
                    ),
                  // Cart Token Info
                  if (hasCartToken)
                    _buildAccountDetailItem(
                      context,
                      icon: Icons.shopping_bag_outlined,
                      label: 'Cart Token',
                      value: 'Available',
                      valueColor: OsmeaColors.nordicBlue,
                      isLast: true,
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// Check cart token (with fallback if package not available)
  Future<bool> _checkCartToken() async {
    try {
      // Try to use dynamic import or reflection to check cart token
      // For now, if user is authenticated, assume cart token might be available
      // This is a simplified check - in production, you'd want to actually check storage
      final authStorage = AuthStorageHelper();
      final jwtToken = await authStorage.getToken();
      // If JWT exists, cart token is likely available too (they're usually created together)
      return jwtToken != null && jwtToken.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Check JWT and Cart tokens asynchronously
  Future<Map<String, bool>> _checkTokens() async {
    bool hasJwtToken = false;
    bool hasCartToken = false;

    try {
      // Check JWT token
      final authStorage = AuthStorageHelper();
      final jwtToken = await authStorage.getToken();
      hasJwtToken = jwtToken != null && jwtToken.isNotEmpty;
      debugPrint('👤 AccountWidget: JWT token check: $hasJwtToken');
    } catch (e) {
      debugPrint('⚠️ AccountWidget: Error checking JWT token: $e');
    }

    try {
      // Check Cart token - using dynamic import to avoid dependency issues
      // Cart token check is optional, if package is not available, just skip
      final cartTokenCheck = await _checkCartToken();
      hasCartToken = cartTokenCheck;
      debugPrint('👤 AccountWidget: Cart token check: $hasCartToken');
    } catch (e) {
      debugPrint('⚠️ AccountWidget: Error checking cart token: $e');
      // If cart token check fails, just set to false
      hasCartToken = false;
    }

    return {
      'jwt': hasJwtToken,
      'cart': hasCartToken,
    };
  }

  /// Build account detail item
  Widget _buildAccountDetailItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : context.spacing16),
      child: OsmeaComponents.row(
        children: [
          Icon(
            icon,
            size: 20,
            color: OsmeaColors.pewter,
          ),
          OsmeaComponents.sizedBox(width: context.spacing12),
          Expanded(
            child: OsmeaComponents.text(
              label,
              textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                color: OsmeaColors.thunder,
              ),
            ),
          ),
          OsmeaComponents.text(
            value,
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: valueColor ?? OsmeaColors.nordicBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Build startup style menu item (tappable card)
  Widget _buildStartupMenuItem(
    BuildContext context,
    AccountMenuItem item,
  ) {
    // Parse color from hex string
    final iconColor = _parseColor(item.iconColor);

    // Get description based on item title or route
    final description = _getMenuItemDescription(item.title, item.route);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (item.route.isNotEmpty) {
            _navigate(context, item.route);
          }
        },
        borderRadius: BorderRadius.circular(context.radiusMedium),
        splashColor: iconColor.withOpacity(0.1),
        highlightColor: iconColor.withOpacity(0.05),
        child: _buildCardWrapper(
          context: context,
          backgroundColor: OsmeaColors.white,
          borderColor: OsmeaColors.grayMaterial[200] ?? OsmeaColors.silver.withOpacity(0.2),
          padding: EdgeInsets.all(context.spacing16),
          child: OsmeaComponents.row(
            children: [
              // Icon Container - softer and more elegant
              Container(
                width: context.iconSizeExtraHigh,
                height: context.iconSizeExtraHigh,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(context.radiusMedium),
                ),
                child: Center(
                  child: Icon(
                    _getIconData(item.iconName),
                    color: iconColor,
                    size: context.iconSizeNormal,
                  ),
                ),
              ),
              OsmeaComponents.sizedBox(width: context.spacing12),
              // Title and Description - softer styling
              Expanded(
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OsmeaComponents.text(
                      item.title,
                      textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: OsmeaColors.black,
                        letterSpacing: -0.3,
                      ),
                    ),
                    if (description.isNotEmpty) ...[
                      OsmeaComponents.sizedBox(height: context.spacing2),
                      OsmeaComponents.text(
                        description,
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          color: OsmeaColors.grayMaterial[500] ?? OsmeaColors.pewter,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              OsmeaComponents.sizedBox(width: context.spacing8),
              // Arrow Icon - softer and rounded
              Icon(
                Icons.chevron_right_rounded,
                color: OsmeaColors.grayMaterial[400] ?? OsmeaColors.slate.withOpacity(0.4),
                size: context.iconSizeNormal,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get menu item description based on title or route
  String _getMenuItemDescription(String title, String route) {
    // Try to get description from title
    final titleLower = title.toLowerCase();

    if (titleLower.contains('order')) {
      return 'View your orders and order history';
    } else if (titleLower.contains('return')) {
      return 'View your return requests';
    } else if (titleLower.contains('cancel')) {
      return 'View your cancellation requests';
    } else if (titleLower.contains('account') ||
        titleLower.contains('setting')) {
      return 'App settings and preferences';
    } else if (titleLower.contains('notification')) {
      return 'Manage your notification preferences';
    } else if (titleLower.contains('stock') || titleLower.contains('alarm')) {
      return 'Manage your stock and price alarms';
    } else if (titleLower.contains('price')) {
      return 'Manage your price alerts';
    }

    // Default description
    return '';
  }

  /// Build startup style actions
  Widget _buildStartupActions(
    BuildContext context,
    AccountCubit viewModel,
  ) {
    final isAuthenticated = _isAuthenticated(context);
    final configHelper = AssetConfigHelper();

    // Get button colors from config
    final signOutBgColor = configHelper.getColor(
      'auth_configuration.buttons.sign_out.backgroundColor',
      OsmeaColors.white,
    );
    final signOutTextColor = configHelper.getColor(
      'auth_configuration.buttons.sign_out.textColor',
      OsmeaColors.black,
    );
    final signOutBorderColor = configHelper.getColor(
      'auth_configuration.buttons.sign_out.borderColor',
      OsmeaColors.black,
    );
    final signInBgColor = configHelper.getColor(
      'auth_configuration.buttons.sign_in.backgroundColor',
      OsmeaColors.black,
    );
    final signInTextColor = configHelper.getColor(
      'auth_configuration.buttons.sign_in.textColor',
      OsmeaColors.white,
    );

    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isAuthenticated)
          OsmeaComponents.button(
            onPressed: () => _signOut(context, viewModel),
            variant: ButtonVariant.outlined,
            size: ButtonSize.large,
            backgroundColor: signOutBgColor,
            textColor: signOutTextColor,
            borderColor: signOutBorderColor,
            text: 'Sign Out',
            textStyle: OsmeaTextStyle.bodyMedium(
              context,
            ).copyWith(color: signOutTextColor, fontWeight: FontWeight.w600),
          ),
        if (!isAuthenticated)
          OsmeaComponents.button(
            onPressed: () => _navigate(context, '/auth'),
            variant: ButtonVariant.primary,
            size: ButtonSize.large,
            backgroundColor: signInBgColor,
            textColor: signInTextColor,
            text: 'Sign In',
            textStyle: OsmeaTextStyle.bodyMedium(
              context,
            ).copyWith(color: signInTextColor, fontWeight: FontWeight.w600),
          ),
      ],
    );
  }

  /// Sign out helper
  /// Comprehensive logout that clears all user data, tokens, and cached information
  /// Platform-specific cleanup (cookies, wishlist, cart) is handled via onSignOutCallback
  Future<void> _signOut(BuildContext context, AccountCubit viewModel) async {
    try {
      debugPrint('🚪 AccountWidget: Starting comprehensive sign out process...');

      // Step 1: Clear AccountCubit state first to prevent showing stale user data
      viewModel.clearAccountData();
      debugPrint('✅ AccountWidget: AccountCubit state cleared');

      // Step 2: Call platform-specific cleanup callback if provided
      // This handles cookies, wishlist, cart, and other platform-specific data
      if (onSignOutCallback != null) {
        try {
          debugPrint('🔄 AccountWidget: Calling platform-specific cleanup callback...');
          await onSignOutCallback!();
          debugPrint('✅ AccountWidget: Platform-specific cleanup completed');
        } catch (e) {
          debugPrint('⚠️ AccountWidget: Error in platform-specific cleanup: $e');
          // Continue with core cleanup even if platform cleanup fails
        }
      } else {
        debugPrint('ℹ️ AccountWidget: No platform-specific cleanup callback provided');
      }

      // Step 3: Sign out from AuthCubit - this will:
      // - Clear AuthStorageHelper (Core JWT token and userData)
      // - Clear remember_me preference
      // - Emit AuthUnauthenticatedState
      // - Clear HydratedCubit persistence
      final authCubit = GetIt.I<AuthCubit>();
      authCubit.resetForm();
      await authCubit.signOut();
      debugPrint('✅ AccountWidget: AuthCubit sign out completed');

      // Step 4: Ensure AccountCubit state is cleared again after auth signout
      // This prevents any cached profile data from being displayed
      viewModel.clearAccountData();
      debugPrint('✅ AccountWidget: AccountCubit state cleared again (post-auth signout)');

      debugPrint('✅ AccountWidget: Comprehensive sign out completed successfully');

      // Step 5: Verify sign out was successful
      final authCubitAfterSignOut = GetIt.I<AuthCubit>();
      final authStateAfterSignOut = authCubitAfterSignOut.state;
      debugPrint('🔍 AccountWidget: Auth state after sign out: ${authStateAfterSignOut.runtimeType}');
      
      if (authStateAfterSignOut is! AuthUnauthenticatedState) {
        debugPrint('⚠️ AccountWidget: State is not unauthenticated after sign out! Retrying sign out...');
        // Retry sign out if state is not correct
        await authCubitAfterSignOut.signOut();
        debugPrint('✅ AccountWidget: Sign out retried');
      }

      // Note: Navigation should be handled by the platform-specific implementation
      // Core package only handles the sign out logic, not navigation
    } catch (e, stackTrace) {
      debugPrint('❌ AccountWidget: Error signing out: $e');
      debugPrint('❌ AccountWidget: Stack trace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out: $e'),
          backgroundColor: OsmeaColors.red,
        ),
      );
    }
  }

  /// Card wrapper helper for startup style
  Widget _buildCardWrapper({
    required BuildContext context,
    required Widget child,
    Color? backgroundColor,
    Color? borderColor,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      padding: padding ?? EdgeInsets.all(context.spacing16),
      decoration: BoxDecoration(
        color: backgroundColor ?? OsmeaColors.white,
        border: Border.all(color: borderColor ?? OsmeaColors.silver, width: 1),
        borderRadius: context.borderRadiusNormal,
      ),
      child: child,
    );
  }
}
