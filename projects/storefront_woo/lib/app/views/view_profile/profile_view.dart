/*
 * ProfileView
 * -----------
 * Profile view to display user authentication status and token information.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_woo/app/views/view_profile/models/profile_view_model.dart';
import 'package:storefront_woo/app/views/view_profile/models/module/states.dart'
    as profile_states;

/// Profile View - Shows user authentication status and token information
class ProfileView
    extends
        MasterViewHydratedCubit<ProfileViewModel, profile_states.ProfileState> {
  ProfileView({super.key, required super.goRoute, super.bottomNavigationBar})
    : super(
        arguments: const {'profile': true},
        appBarPadding: const AppBarPaddingVisibility.disabled(),
        verticalPadding: const PaddingVisibility.disabled(),
        navbarSpacer: const SpacerVisibility.disabled(),
        coreAppBar: (context, vm) => OsmeaComponents.appBar(
          title: OsmeaComponents.text(
            'Profile',
            textStyle: OsmeaTextStyle.titleLarge(context),
          ),
          leading: OsmeaComponents.iconButton(
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Back',
          ),
          actions: [
            AppBarAction(
              type: AppBarActionType.secondary,
              icon: const Icon(Icons.refresh),
              onPressed: () => vm.refreshProfile(),
              tooltip: 'Refresh',
            ),
          ],
          variant: AppBarVariant.standard,
          size: AppBarSize.standard,
        ),
      ) {
    debugPrint('👤 ProfileView: Constructor called');
  }

  @override
  void initialContent(ProfileViewModel viewModel, BuildContext context) {
    debugPrint('👤 ProfileView: initialContent called');
    // Set arguments to ViewModel
    viewModel.setArguments(arguments);
    // Load profile - ViewModel handles authentication check internally
    viewModel.loadProfile();
  }

  @override
  Widget viewContent(
    BuildContext context,
    ProfileViewModel viewModel,
    profile_states.ProfileState state,
  ) {
    // Listen to AuthCubit state changes and reload profile when authenticated
    // This handles the case where ProfileView loads before AuthCubit state is updated after signin
    try {
      final authCubit = GetIt.I<AuthCubit>();
      final currentProfileState = state; // Capture current state for closure
      return BlocListener<AuthCubit, AuthState>(
        bloc: authCubit,
        listener: (context, authState) {
          // If AuthCubit becomes authenticated and ProfileView is in initial/loading state,
          // trigger loadProfile to refresh the view
          if (authState is AuthAuthenticatedState &&
              (currentProfileState is profile_states.ProfileInitialState ||
                  currentProfileState is profile_states.ProfileLoadingState)) {
            debugPrint(
              '👤 ProfileView: AuthCubit authenticated, triggering loadProfile...',
            );
            WidgetsBinding.instance.addPostFrameCallback((_) {
              viewModel.loadProfile();
            });
          }
        },
        child: _buildProfileContent(context, viewModel, state),
      );
    } catch (e) {
      debugPrint('⚠️ ProfileView: Could not access AuthCubit: $e');
      return _buildProfileContent(context, viewModel, state);
    }
  }

  Widget _buildProfileContent(
    BuildContext context,
    ProfileViewModel viewModel,
    profile_states.ProfileState state,
  ) {
    // Initial state - show loading (initialContent will trigger loadProfile)
    if (state is profile_states.ProfileInitialState) {
      return buildLoading();
    }

    if (state is profile_states.ProfileLoadingState) {
      return buildLoading();
    }

    if (state is profile_states.ProfileErrorState) {
      return buildError(state.message, onRetry: () => viewModel.loadProfile());
    }

    if (state is profile_states.ProfileSignedOutState) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        debugPrint('👤 ProfileView: Sign out completed, navigating to home');
        // Small delay to ensure AuthCubit state is updated
        await Future.delayed(const Duration(milliseconds: 150));

        // Verify AuthCubit state before navigation
        try {
          final authCubit = GetIt.I<AuthCubit>();
          if (authCubit.state is AuthUnauthenticatedState) {
            debugPrint(
              '✅ ProfileView: AuthCubit confirmed unauthenticated before navigation',
            );
          } else {
            debugPrint(
              '⚠️ ProfileView: AuthCubit state is ${authCubit.state.runtimeType}, expected AuthUnauthenticatedState',
            );
          }
        } catch (e) {
          debugPrint('⚠️ ProfileView: Could not verify AuthCubit state: $e');
        }

        // Navigate to home page using goRoute callback (safer than context.go)
        // This avoids "Looking up a deactivated widget's ancestor" error
        // goRoute is provided by MasterViewHydratedCubit and handles navigation safely
        try {
          goRoute('/home');
          debugPrint('👤 ProfileView: Navigated to /home via goRoute');
        } catch (e) {
          debugPrint('❌ ProfileView: Error navigating to /home: $e');
          // If goRoute fails, the error is logged but we don't try context.go
          // because the widget might already be disposed
        }
      });
      return buildLoading();
    }

    if (state is profile_states.ProfileLoadedState) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(context.spacing16),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Header
            _buildProfileHeader(context, state),
            OsmeaComponents.sizedBox(height: context.spacing24),

            // Menu Items Section
            _buildMenuItems(context, state.isAuthenticated),
            OsmeaComponents.sizedBox(height: context.spacing24),

            // Account Section (only if authenticated)
            if (state.isAuthenticated) ...[
              _buildAccountSection(context, state),
              OsmeaComponents.sizedBox(height: context.spacing24),
            ],

            // Actions
            _buildActions(context, viewModel, state.isAuthenticated),

            // Bottom spacing for safe area
            OsmeaComponents.sizedBox(height: context.spacing32),
          ],
        ),
      );
    }

    // Initial state
    return const SizedBox.shrink();
  }

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

  Widget _buildProfileHeader(
    BuildContext context,
    profile_states.ProfileLoadedState state,
  ) {
    final userData = state.authUserData;
    final displayName = userData?['displayName'] ??
        userData?['display_name'] ??
        userData?['username'] ??
        userData?['email'] ??
        'Guest';
    final email = userData?['email'] ?? 'Not available';
    final initials = displayName
        .toString()
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
        .take(2)
        .join();

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
                    OsmeaComponents.text(
                      displayName.toString(),
                      textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                        fontWeight: FontWeight.w700,
                        color: OsmeaColors.thunder,
                      ),
                    ),
                    OsmeaComponents.sizedBox(height: context.spacing4),
                    OsmeaComponents.text(
                      email,
                      textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                        color: OsmeaColors.pewter,
                      ),
                    ),
                    OsmeaComponents.sizedBox(height: context.spacing8),
                    // Status Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.spacing12,
                        vertical: context.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: state.isAuthenticated
                            ? OsmeaColors.nordicBlue.withOpacity(0.1)
                            : OsmeaColors.pewter.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: state.isAuthenticated
                              ? OsmeaColors.nordicBlue
                              : OsmeaColors.pewter,
                          width: 1,
                        ),
                      ),
                      child: OsmeaComponents.row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            state.isAuthenticated
                                ? Icons.check_circle
                                : Icons.cancel,
                            size: 16,
                            color: state.isAuthenticated
                                ? OsmeaColors.nordicBlue
                                : OsmeaColors.pewter,
                          ),
                          OsmeaComponents.sizedBox(width: context.spacing4),
                          OsmeaComponents.text(
                            state.isAuthenticated
                                ? 'Authenticated'
                                : 'Not Authenticated',
                            textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                              color: state.isAuthenticated
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

  Widget _buildMenuItems(BuildContext context, bool isAuthenticated) {
    return _buildCardWrapper(
      context: context,
      backgroundColor: OsmeaColors.white,
      borderColor: OsmeaColors.silver,
      padding: EdgeInsets.zero,
      child: OsmeaComponents.column(
        children: [
          // Orders Menu Item
          if (isAuthenticated)
            _buildMenuItem(
              context: context,
              icon: Icons.receipt_long_rounded,
              title: 'My Orders',
              subtitle: 'View your order history',
              onTap: () {
                goRoute('/orders');
              },
              showDivider: true,
            ),
          // Cart Menu Item
          _buildMenuItem(
            context: context,
            icon: Icons.shopping_cart_rounded,
            title: 'Cart',
            subtitle: 'View your shopping cart',
            onTap: () {
              goRoute('/cart');
            },
            showDivider: true,
          ),
          // Saved/Wishlist Menu Item
          _buildMenuItem(
            context: context,
            icon: Icons.favorite_rounded,
            title: 'Saved Items',
            subtitle: 'View your wishlist',
            onTap: () {
              goRoute('/saved');
            },
            showDivider: true,
          ),
          // Settings Menu Item
          _buildMenuItem(
            context: context,
            icon: Icons.settings_rounded,
            title: 'Settings',
            subtitle: 'App settings and preferences',
            onTap: () {
              // TODO: Navigate to settings
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Settings coming soon!'),
                  backgroundColor: OsmeaColors.nordicBlue,
                ),
              );
            },
            showDivider: true,
          ),
          // Help & Support Menu Item
          _buildMenuItem(
            context: context,
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            subtitle: 'Get help and contact support',
            onTap: () {
              // TODO: Navigate to help
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Help & Support coming soon!'),
                  backgroundColor: OsmeaColors.nordicBlue,
                ),
              );
            },
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showDivider = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.spacing16),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(
                  bottom: BorderSide(
                    color: OsmeaColors.silver,
                    width: 1,
                  ),
                )
              : null,
        ),
        child: OsmeaComponents.row(
          children: [
            // Icon Container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: OsmeaColors.nordicBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: OsmeaColors.nordicBlue,
                size: 24,
              ),
            ),
            OsmeaComponents.sizedBox(width: context.spacing16),
            // Title and Subtitle
            Expanded(
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OsmeaComponents.text(
                    title,
                    textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: OsmeaColors.thunder,
                    ),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing4),
                  OsmeaComponents.text(
                    subtitle,
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      color: OsmeaColors.pewter,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow Icon
            Icon(
              Icons.chevron_right_rounded,
              color: OsmeaColors.pewter,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection(
    BuildContext context,
    profile_states.ProfileLoadedState state,
  ) {
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
          // JWT Token Info
          if (state.authJwtToken != null && state.authJwtToken!.isNotEmpty)
            _buildAccountDetailItem(
              context,
              icon: Icons.lock_outline_rounded,
              label: 'JWT Token',
              value: 'Available',
              valueColor: OsmeaColors.nordicBlue,
            ),
          // Cart Token Info
          if (state.cartToken != null)
            _buildAccountDetailItem(
              context,
              icon: Icons.shopping_bag_outlined,
              label: 'Cart Token',
              value: 'Available',
              valueColor: OsmeaColors.nordicBlue,
            ),
        ],
      ),
    );
  }

  Widget _buildAccountDetailItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing12),
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
              color: valueColor ?? OsmeaColors.pewter,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    ProfileViewModel viewModel,
    bool isAuthenticated,
  ) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isAuthenticated)
          OsmeaComponents.button(
            onPressed: () => viewModel.signOut(),
            variant: ButtonVariant.secondary,
            size: ButtonSize.large,
            backgroundColor: OsmeaColors.red,
            textColor: OsmeaColors.white,
            text: 'Sign Out',
            textStyle: OsmeaTextStyle.bodyMedium(
              context,
            ).copyWith(color: OsmeaColors.white, fontWeight: FontWeight.w600),
          ),
        if (!isAuthenticated)
          OsmeaComponents.button(
            onPressed: () {
              goRoute('/auth');
            },
            variant: ButtonVariant.primary,
            size: ButtonSize.large,
            text: 'Sign In',
            textStyle: OsmeaTextStyle.bodyMedium(
              context,
            ).copyWith(color: OsmeaColors.white, fontWeight: FontWeight.w600),
          ),
      ],
    );
  }
}
